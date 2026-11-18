using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class JobDetails : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Exposed for data binding in JobDetails.aspx
        // =========================================================================
        public int JobId { get; set; } = 1;
        public int TargetCompanyId { get; set; } = 1;
        public string JobTitle { get; set; } = ".Net Developer";
        public string CompanyName { get; set; } = "Tech Company";
        public string CompanyLocation { get; set; } = "Mumbai";
        public string CompanyIndustry { get; set; } = "Software & IT";
        public string CompanySize { get; set; } = "50-200";
        public string CompanyWebsite { get; set; } = "https://skilllinksx.com";
        public string CompanyDescription { get; set; } = "Leading technology company providing cutting-edge digital solutions.";
        public string ExperienceRequired { get; set; } = "0-2 Yrs";
        public string SalaryRange { get; set; } = "₹4.5L - ₹7L / yr";
        public string JobDescription { get; set; } = "";
        public string JobRequirements { get; set; } = "";
        public string JobBenefits { get; set; } = "";
        public string Deadline { get; set; } = "Open";
        public int AiMatchScore { get; set; } = 0;
        public string AiMatchBlurb { get; set; } = "";
        public System.Collections.Generic.List<string> MatchingSkills { get; set; } = new System.Collections.Generic.List<string>();
        public System.Collections.Generic.List<string> MissingSkills { get; set; } = new System.Collections.Generic.List<string>();
        public System.Collections.Generic.List<string> RequiredSkillsList { get; set; } = new System.Collections.Generic.List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify student authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            // Extract Job ID from query string (e.g. JobDetails.aspx?id=2)
            if (Request.QueryString["id"] != null)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    JobId = id;
                }
            }

            LoadJobDetails();

            if (!IsPostBack)
            {
                CheckExistingApplication();
            }
        }

        private void LoadJobDetails()
        {
            try
            {
                string sql = @"
                    SELECT j.job_id, j.company_id, j.job_title, j.job_type, j.category, j.experience_required,
                           j.salary_min, j.salary_max, j.location, j.city, j.state, j.job_description,
                           j.requirements, j.benefits, j.deadline,
                           c.comp_name, c.industry, c.description AS comp_desc, c.website, c.employee_count
                    FROM jobs j
                    LEFT JOIN company_table c ON j.company_id = c.company_id
                    WHERE j.job_id = @id";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", JobId));
                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    TargetCompanyId = (r["company_id"] != DBNull.Value) ? Convert.ToInt32(r["company_id"]) : 1;
                    JobTitle = r["job_title"] != DBNull.Value ? r["job_title"].ToString() : ".Net Developer";
                    CompanyName = r["comp_name"] != DBNull.Value ? r["comp_name"].ToString() : "Hiring Company";
                    
                    string city = r["city"] != DBNull.Value ? r["city"].ToString().Trim() : "";
                    string state = r["state"] != DBNull.Value ? r["state"].ToString().Trim() : "";
                    CompanyLocation = (!string.IsNullOrEmpty(city) && !string.IsNullOrEmpty(state)) ? $"{city}, {state}" : (r["location"] != DBNull.Value ? r["location"].ToString() : "India");

                    CompanyIndustry = r["industry"] != DBNull.Value ? r["industry"].ToString() : "Technology";
                    CompanySize = r["employee_count"] != DBNull.Value ? r["employee_count"].ToString() : "50-200";
                    CompanyWebsite = r["website"] != DBNull.Value ? r["website"].ToString() : "https://skilllinksx.com";
                    CompanyDescription = r["comp_desc"] != DBNull.Value ? r["comp_desc"].ToString() : "Innovative tech organization.";

                    ExperienceRequired = r["experience_required"] != DBNull.Value ? r["experience_required"].ToString() : "0-2 Yrs";

                    decimal sMin = r["salary_min"] != DBNull.Value ? Convert.ToDecimal(r["salary_min"]) : 0;
                    decimal sMax = r["salary_max"] != DBNull.Value ? Convert.ToDecimal(r["salary_max"]) : 0;
                    SalaryRange = (sMin > 0 && sMax > 0) ? $"₹{(sMin / 100000m):0.#}L - ₹{(sMax / 100000m):0.#}L / yr" : "Competitive";

                    JobDescription = r["job_description"] != DBNull.Value ? r["job_description"].ToString() : "";
                    JobRequirements = r["requirements"] != DBNull.Value ? r["requirements"].ToString() : "";
                    JobBenefits = r["benefits"] != DBNull.Value ? r["benefits"].ToString() : "";

                    if (r["deadline"] != DBNull.Value && DateTime.TryParse(r["deadline"].ToString(), out DateTime dl))
                        Deadline = dl.ToString("MMMM dd, yyyy");
                    else
                        Deadline = "Actively Hiring";

                    // Parse Job Requirements into skill chips
                    if (!string.IsNullOrEmpty(JobRequirements))
                    {
                        var reqParts = JobRequirements.Split(new[] { ',', ';', '|', '\n' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var part in reqParts)
                        {
                            string s = part.Trim();
                            if (!string.IsNullOrEmpty(s))
                                RequiredSkillsList.Add(s);
                        }
                    }

                    // Compute dynamic AI Match Score using student's actual skills from member_master_table
                    int studentId = Convert.ToInt32(Session["UserId"]);
                    object sObj = DBHelper.ExecuteScalar("SELECT skills FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                    string studentSkills = (sObj != null && sObj != DBNull.Value) ? sObj.ToString().Trim() : "";

                    var studentTokens = new System.Collections.Generic.HashSet<string>(
                        studentSkills.Split(new[] { ',', ';', '|', '/', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)
                                     .Select(s => s.Trim().ToLower())
                    );

                    MatchingSkills.Clear();
                    MissingSkills.Clear();

                    foreach (var req in RequiredSkillsList)
                    {
                        bool isMatch = studentTokens.Count > 0 && studentTokens.Any(st => 
                            st.Equals(req.ToLower()) || 
                            req.ToLower().Contains(st) || 
                            st.Contains(req.ToLower()));

                        if (isMatch)
                            MatchingSkills.Add(req);
                        else
                            MissingSkills.Add(req);
                    }

                    if (string.IsNullOrWhiteSpace(studentSkills) || studentTokens.Count == 0)
                    {
                        AiMatchScore = 0;
                        AiMatchBlurb = "Add your skills in your profile to see your AI Career Match.";
                    }
                    else
                    {
                        if (RequiredSkillsList.Count > 0)
                        {
                            double ratio = (double)MatchingSkills.Count / RequiredSkillsList.Count;
                            AiMatchScore = (int)Math.Round(ratio * 100);
                        }
                        else
                        {
                            AiMatchScore = 0;
                        }

                        if (AiMatchScore >= 80)
                            AiMatchBlurb = $"Outstanding fit ({AiMatchScore}%)! Your skills align strongly with the requirements for {JobTitle}.";
                        else if (AiMatchScore >= 50)
                            AiMatchBlurb = $"Moderate fit ({AiMatchScore}%). You match several competencies. Learning {string.Join(", ", MissingSkills.Take(2))} will boost your score.";
                        else if (AiMatchScore > 0)
                            AiMatchBlurb = $"Basic match ({AiMatchScore}%). This role requires additional skills like {string.Join(", ", MissingSkills.Take(2))}.";
                        else
                            AiMatchBlurb = $"Low match (0%). None of the required skills were found in your profile. Consider learning {string.Join(", ", MissingSkills.Take(2))}.";
                    }
                }
            }
            catch (Exception ex)
            {
                lblFeedback.ForeColor = System.Drawing.Color.Red;
                lblFeedback.Text = "Error loading job details: " + ex.Message;
            }
        }

        // =========================================================================
        // [DATABASE CHECK]: Prevent duplicate applications for the same job
        // Queries 'applications' table for existing (user_id, job_id) pair
        // =========================================================================
        private void CheckExistingApplication()
        {
            int studentId = Convert.ToInt32(Session["UserId"]);

            // Check if candidate is currently hired / an active team member at any company
            object hiredObj = DBHelper.ExecuteScalar(@"
                SELECT TOP 1 c.comp_name 
                FROM applications a 
                INNER JOIN company_table c ON a.company_id = c.company_id 
                WHERE a.user_id = @sid AND a.status = 'Selected'",
                new SqlParameter("@sid", studentId));

            if (hiredObj != null && hiredObj != DBNull.Value)
            {
                btnApplyNow.Enabled = false;
                btnApplyNow.Text = "Employed at " + hiredObj.ToString();
                btnApplyNow.CssClass += " btn-disabled";
                lblFeedback.ForeColor = System.Drawing.Color.DarkOrange;
                lblFeedback.Text = $"You are currently an active team member at {hiredObj}. You cannot apply for other opportunities until your employer releases you from your current role.";
                return;
            }

            object existing = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM applications WHERE user_id = @sid AND job_id = @jid",
                new SqlParameter("@sid", studentId),
                new SqlParameter("@jid", JobId)
            );

            if (existing != null && Convert.ToInt32(existing) > 0)
            {
                btnApplyNow.Enabled = false;
                btnApplyNow.Text = "Already Applied";
                btnApplyNow.CssClass += " btn-disabled";
                lblFeedback.ForeColor = System.Drawing.Color.Blue;
                lblFeedback.Text = "You have already applied for this position.";
            }
        }

        // =========================================================================
        // [DATABASE INSERT]: "Apply Now" Button Click Handler
        // Inserts new row into 'applications' table with initial status 'New'
        // =========================================================================
        protected void btnApplyNow_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);

            // Guard: active employment check
            object hiredObj = DBHelper.ExecuteScalar(@"
                SELECT TOP 1 c.comp_name 
                FROM applications a 
                INNER JOIN company_table c ON a.company_id = c.company_id 
                WHERE a.user_id = @sid AND a.status = 'Selected'",
                new SqlParameter("@sid", studentId));

            if (hiredObj != null && hiredObj != DBNull.Value)
            {
                lblFeedback.ForeColor = System.Drawing.Color.DarkOrange;
                lblFeedback.Text = $"You are currently an active team member at {hiredObj} and cannot submit new applications.";
                return;
            }

            try
            {
                // Query company_id for this job to satisfy NOT NULL constraint
                object cObj = DBHelper.ExecuteScalar("SELECT company_id FROM jobs WHERE job_id = @id", new SqlParameter("@id", JobId));
                int companyId = (cObj != null && cObj != DBNull.Value) ? Convert.ToInt32(cObj) : 1;

                // SQL parameterized INSERT statement into 'applications' table
                string insertSql = @"
                    INSERT INTO applications (job_id, user_id, company_id, status, applied_at, updated_at, resume_file_path, cover_letter)
                    VALUES (@jid, @sid, @cid, 'Applied', GETDATE(), GETDATE(), 'Resume_Uploaded.pdf', 'Applied via SkillLinksX platform')";

                int rowsAffected = DBHelper.ExecuteNonQuery(
                    insertSql,
                    new SqlParameter("@jid", JobId),
                    new SqlParameter("@sid", studentId),
                    new SqlParameter("@cid", companyId)
                );

                if (rowsAffected > 0)
                {
                    btnApplyNow.Enabled = false;
                    btnApplyNow.Text = "Application Submitted";
                    lblFeedback.ForeColor = System.Drawing.Color.Green;
                    lblFeedback.Text = "Application submitted successfully! Track your status under Applications.";

                    // Send notification to Candidate
                    // 1. Send confirmation notification to Candidate
                    DBHelper.SendNotification(studentId, 
                        "Application Submitted 📄", 
                        $"You successfully applied for {JobTitle} at {CompanyName}.", 
                        "~/User/Applications.aspx");

                    // 2. Send applicant notification to Company recruiter
                    try
                    {
                        object sNameObj = DBHelper.ExecuteScalar("SELECT full_name FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                        string sName = (sNameObj != null && sNameObj != DBNull.Value) ? sNameObj.ToString() : "A candidate";
                        int compUserId = DBHelper.GetCompanyUserId(companyId);

                        DBHelper.SendNotification(compUserId, 
                            $"New Applicant: {sName}", 
                            $"{sName} applied for the position of {JobTitle}.", 
                            "~/Company/Applicants.aspx");
                    }
                    catch { }
                }
            }
            catch (Exception ex)
            {
                lblFeedback.ForeColor = System.Drawing.Color.Red;
                lblFeedback.Text = "Application Error: " + ex.Message;
            }
        }

        // =========================================================================
        // [DATABASE INSERT]: "Save Job" Button Click Handler
        // Inserts job into 'saved_opportunities' table for the logged-in student
        // =========================================================================
        protected void btnSaveJob_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);

            try
            {
                // Check if already saved
                object savedCount = DBHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM saved_jobs WHERE user_id = @sid AND job_id = @jid",
                    new SqlParameter("@sid", studentId),
                    new SqlParameter("@jid", JobId)
                );

                if (savedCount != null && Convert.ToInt32(savedCount) > 0)
                {
                    lblFeedback.ForeColor = System.Drawing.Color.Orange;
                    lblFeedback.Text = "This opportunity is already in your Saved Opportunities list.";
                    return;
                }

                // Insert into 'saved_jobs'
                DBHelper.ExecuteNonQuery(
                    "INSERT INTO saved_jobs (user_id, job_id, saved_at) VALUES (@sid, @jid, GETDATE())",
                    new SqlParameter("@sid", studentId),
                    new SqlParameter("@jid", JobId)
                );

                btnSaveJob.Text = "Saved";
                lblFeedback.ForeColor = System.Drawing.Color.Green;
                lblFeedback.Text = "Opportunity successfully saved to your profile!";
            }
            catch (Exception ex)
            {
                lblFeedback.ForeColor = System.Drawing.Color.Red;
                lblFeedback.Text = "Save Error: " + ex.Message;
            }
        }
    }
}
