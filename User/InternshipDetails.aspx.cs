using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class InternshipDetails : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Internship Information
        // =========================================================================
        public int InternshipId { get; set; } = 1;
        public string InternshipTitle { get; set; } = "Software Development Intern";
        public string CompanyName { get; set; } = "Tech Company";
        public string Location { get; set; } = "Bengaluru";
        public string JobType { get; set; } = "Internship";
        public string SalaryRange { get; set; } = "₹20,000 / month";
        public int AiMatchScore { get; set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (Request.QueryString["id"] != null)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    InternshipId = id;
                }
            }

            LoadInternshipDetails();

            if (!IsPostBack)
            {
                if (DBHelper.ColumnExists("internships", "views_count"))
                {
                    try
                    {
                        DBHelper.ExecuteNonQuery("UPDATE internships SET views_count = ISNULL(views_count, 0) + 1 WHERE internship_id = @iid", new SqlParameter("@iid", InternshipId));
                    }
                    catch { }
                }
                CheckAlreadyApplied();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Internship by ID
        // =========================================================================
        private void LoadInternshipDetails()
        {
            string sql = @"
                SELECT i.internship_id AS job_id, i.internship_title AS title, i.location_type AS location, 'Internship' AS job_type, 
                       i.stipend_amount,
                       i.skills_required AS required_skills,
                       c.comp_name AS company_name
                FROM internships i
                INNER JOIN company_table c ON i.company_id = c.company_id
                WHERE i.internship_id = @id";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", InternshipId));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                InternshipTitle = r["title"].ToString();
                CompanyName = r["company_name"].ToString();
                Location = r["location"].ToString();
                JobType = r["job_type"].ToString();

                if (r["stipend_amount"] != DBNull.Value && decimal.TryParse(r["stipend_amount"].ToString(), out decimal stp))
                {
                    SalaryRange = $"₹{stp:N0} / month";
                }
                else
                {
                    SalaryRange = "₹20,000 / month";
                }

                string reqSkills = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "C#, SQL";
                var skillsList = reqSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                          .Select(s => s.Trim()).ToList();

                rptRequiredSkills.DataSource = skillsList;
                rptRequiredSkills.DataBind();

                // Compute AI match score against student skills
                int studentId = Convert.ToInt32(Session["UserId"]);
                object sObj = DBHelper.ExecuteScalar("SELECT skills FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                string studentSkills = sObj != null ? sObj.ToString() : "C#";

                AiMatchScore = AIService.CalculateMatchScore(studentSkills, reqSkills);
            }
        }

        private void CheckAlreadyApplied()
        {
            int studentId = Convert.ToInt32(Session["UserId"]);

            // Guard: active employment check
            object hiredObj = DBHelper.ExecuteScalar(@"
                SELECT TOP 1 COALESCE(c.comp_name, 'another company')
                FROM applications a 
                LEFT JOIN company_table c ON a.company_id = c.company_id 
                WHERE a.user_id = @sid AND a.status = 'Selected'",
                new SqlParameter("@sid", studentId));

            if (hiredObj != null && hiredObj != DBNull.Value)
            {
                btnApplyInternship.Enabled = false;
                btnApplyInternship.Text = "Employed at " + hiredObj.ToString();
                btnApplyInternship.CssClass += " btn-disabled";
                lblApplyFeedback.ForeColor = System.Drawing.Color.DarkOrange;
                lblApplyFeedback.Text = $"You are currently an active team member at {hiredObj}. You cannot apply for new opportunities until your employer releases you from your current role.";
                return;
            }

            object existing = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM applications WHERE user_id = @sid AND (job_id = @jid OR internship_id = @jid)",
                new SqlParameter("@sid", studentId),
                new SqlParameter("@jid", InternshipId)
            );

            if (existing != null && Convert.ToInt32(existing) > 0)
            {
                btnApplyInternship.Enabled = false;
                btnApplyInternship.Text = "Applied Already";
                btnApplyInternship.CssClass += " btn-disabled";
                lblApplyFeedback.ForeColor = System.Drawing.Color.Green;
                lblApplyFeedback.Text = "You have already applied for this internship position.";
            }
        }

        // =========================================================================
        // [DATABASE INSERT]: "Apply Now" Event Handler
        // =========================================================================
        protected void btnApplyInternship_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);

            // Guard: active employment check
            object hiredObj = DBHelper.ExecuteScalar(@"
                SELECT TOP 1 COALESCE(c.comp_name, 'another company')
                FROM applications a 
                LEFT JOIN company_table c ON a.company_id = c.company_id 
                WHERE a.user_id = @sid AND a.status = 'Selected'",
                new SqlParameter("@sid", studentId));

            if (hiredObj != null && hiredObj != DBNull.Value)
            {
                lblApplyFeedback.ForeColor = System.Drawing.Color.DarkOrange;
                lblApplyFeedback.Text = $"You are currently an active team member at {hiredObj} and cannot submit new applications.";
                return;
            }

            try
            {
                // Query company_id for this internship to satisfy NOT NULL constraint
                object cObj = DBHelper.ExecuteScalar("SELECT company_id FROM internships WHERE internship_id = @id", new SqlParameter("@id", InternshipId));
                int companyId = (cObj != null && cObj != DBNull.Value) ? Convert.ToInt32(cObj) : 1;

                string sql = @"
                    INSERT INTO applications (internship_id, user_id, company_id, status, applied_at, updated_at, resume_file_path, cover_letter) 
                    VALUES (@iid, @sid, @cid, 'Applied', GETDATE(), GETDATE(), 'Resume_Uploaded.pdf', 'Applied via SkillLinksX platform')";

                int rows = DBHelper.ExecuteNonQuery(
                    sql,
                    new SqlParameter("@iid", InternshipId),
                    new SqlParameter("@sid", studentId),
                    new SqlParameter("@cid", companyId)
                );

                if (rows > 0)
                {
                    btnApplyInternship.Enabled = false;
                    btnApplyInternship.Text = "Applied Successfully";
                    lblApplyFeedback.ForeColor = System.Drawing.Color.Green;
                    lblApplyFeedback.Text = "Internship application submitted! Track progress in Applications.";

                    // Send notification to Candidate
                    // 1. Send confirmation notification to Candidate
                    DBHelper.SendNotification(studentId, 
                        "Internship Application Submitted 📄", 
                        $"You successfully applied for {InternshipTitle} at {CompanyName}.", 
                        "~/User/Applications.aspx");

                    // 2. Send applicant notification to Company recruiter
                    try
                    {
                        object sNameObj = DBHelper.ExecuteScalar("SELECT full_name FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                        string sName = (sNameObj != null && sNameObj != DBNull.Value) ? sNameObj.ToString() : "A candidate";
                        int compUserId = DBHelper.GetCompanyUserId(companyId);

                        DBHelper.SendNotification(compUserId, 
                            $"New Internship Applicant: {sName}", 
                            $"{sName} applied for {InternshipTitle}.", 
                            "~/Company/Applicants.aspx");
                    }
                    catch { }
                }
            }
            catch (Exception ex)
            {
                lblApplyFeedback.ForeColor = System.Drawing.Color.Red;
                lblApplyFeedback.Text = "Error: " + ex.Message;
            }
        }
    }
}
