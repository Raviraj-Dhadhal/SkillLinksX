using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    // =========================================================================
    // TSEE RUBRIC REQUIREMENT: Custom Delegates & Events
    // Used to notify and log when a candidate application status transitions.
    // =========================================================================
    public delegate void CandidateStatusChangedEventHandler(object sender, CandidateStatusEventArgs e);

    public class CandidateStatusEventArgs : EventArgs
    {
        public int ApplicationId { get; set; }
        public string NewStatus { get; set; }
        public DateTime Timestamp { get; set; }

        public CandidateStatusEventArgs(int appId, string status)
        {
            ApplicationId = appId;
            NewStatus = status;
            Timestamp = DateTime.Now;
        }
    }

    public partial class Applicants : Page
    {
        // Declare Custom Event
        public event CandidateStatusChangedEventHandler OnCandidateStatusChanged;

        public int TotalCount { get; set; }
        public int NewCount { get; set; }
        public int ReviewCount { get; set; }
        public int ShortlistedCount { get; set; }
        public int InterviewCount { get; set; }
        public int SelectedCount { get; set; }
        public int TableCount { get; set; }

        public bool HasSelectedApplicant { get; set; } = false;
        public int QuickApplicationId { get; set; } = 0;
        public int QuickStudentId { get; set; } = 0;
        public string QuickStudentName { get; set; } = "";
        public string QuickJobTitle { get; set; } = "";
        public string QuickProfilePhoto { get; set; } = "";
        public int QuickMatchScore { get; set; } = 0;
        public string QuickCollege { get; set; } = "";
        public string QuickDegree { get; set; } = "";
        public List<string> QuickSkills { get; set; } = new List<string>();

        private int CurrentCompanyId => DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            // Ensure notification table has required columns
            DBHelper.EnsureNotificationColumns();

            // Wire up custom event subscriber
            this.OnCandidateStatusChanged += Applicants_OnCandidateStatusChanged;

            if (!IsPostBack)
            {
                int companyId = CurrentCompanyId;
                LoadOpportunityDropdown(companyId);
                LoadApplicants(companyId);
            }
        }

        private void Applicants_OnCandidateStatusChanged(object sender, CandidateStatusEventArgs e)
        {
            try
            {
                // 1. Event receiver handler: update applications status in DB
                if (e.NewStatus == "Selected")
                {
                    DBHelper.ExecuteNonQuery(
                        "UPDATE applications SET status = @status, company_id = @cid, updated_at = GETDATE() WHERE application_id = @id",
                        new SqlParameter("@status", e.NewStatus),
                        new SqlParameter("@cid", CurrentCompanyId),
                        new SqlParameter("@id", e.ApplicationId)
                    );
                }
                else
                {
                    DBHelper.ExecuteNonQuery(
                        "UPDATE applications SET status = @status, updated_at = GETDATE() WHERE application_id = @id",
                        new SqlParameter("@status", e.NewStatus),
                        new SqlParameter("@id", e.ApplicationId)
                    );
                }

                // 2. Fetch candidate & job details to deliver notification
                try
                {
                    string infoSql = @"
                        SELECT a.user_id, 
                               ISNULL(j.job_title, i.internship_title) AS job_title, 
                               c.comp_name 
                        FROM applications a
                        LEFT JOIN jobs j ON a.job_id = j.job_id
                        LEFT JOIN internships i ON a.internship_id = i.internship_id
                        LEFT JOIN company_table c ON (j.company_id = c.company_id OR i.company_id = c.company_id)
                        WHERE a.application_id = @id";

                    DataTable dtInfo = DBHelper.ExecuteQuery(infoSql, new SqlParameter("@id", e.ApplicationId));
                    if (dtInfo != null && dtInfo.Rows.Count > 0)
                    {
                        int studentId = Convert.ToInt32(dtInfo.Rows[0]["user_id"]);
                        string jobTitle = dtInfo.Rows[0]["job_title"] != DBNull.Value ? dtInfo.Rows[0]["job_title"].ToString() : "Application";
                        string compName = dtInfo.Rows[0]["comp_name"] != DBNull.Value ? dtInfo.Rows[0]["comp_name"].ToString() : "Company";

                        string notifTitle = "";
                        string notifMsg = "";

                        if (e.NewStatus.Equals("Selected", StringComparison.OrdinalIgnoreCase) || e.NewStatus.Equals("Accepted", StringComparison.OrdinalIgnoreCase))
                        {
                            notifTitle = "Application Selected! 🎉";
                            notifMsg = $"Congratulations! You have been Selected for the position of {jobTitle} at {compName}.";
                        }
                        else if (e.NewStatus.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase))
                        {
                            notifTitle = "Application Shortlisted";
                            notifMsg = $"Great news! Your application for {jobTitle} at {compName} has been Shortlisted.";
                        }
                        else if (e.NewStatus.Equals("Rejected", StringComparison.OrdinalIgnoreCase))
                        {
                            notifTitle = "Application Status Update";
                            notifMsg = $"Thank you for applying. Your application for {jobTitle} at {compName} was not selected.";
                        }
                        else
                        {
                            notifTitle = "Application Update";
                            notifMsg = $"Your application status for {jobTitle} has been updated to '{e.NewStatus}'.";
                        }

                        DBHelper.SendNotification(studentId, notifTitle, notifMsg, "~/User/Applications.aspx");
                    }
                }
                catch { }

                lblActionMessage.ForeColor = System.Drawing.Color.Green;
                lblActionMessage.Text = $"Candidate application status successfully updated to '{e.NewStatus}'!";
            }
            catch (Exception ex)
            {
                lblActionMessage.ForeColor = System.Drawing.Color.Red;
                lblActionMessage.Text = "Status update error: " + ex.Message;
            }
        }

        private void LoadOpportunityDropdown(int companyId)
        {
            ddlOpportunityFilter.Items.Clear();
            ddlOpportunityFilter.Items.Add(new ListItem("All Opportunities", "0"));

            try
            {
                DataTable dt = DBHelper.ExecuteQuery(@"
                    SELECT 'J_' + CAST(job_id AS VARCHAR) AS opp_id, job_title + ' (Job)' AS title 
                    FROM jobs WHERE company_id = @cid
                    UNION ALL
                    SELECT 'I_' + CAST(internship_id AS VARCHAR) AS opp_id, internship_title + ' (Internship)' AS title 
                    FROM internships WHERE company_id = @cid",
                    new SqlParameter("@cid", companyId)
                );

                foreach (DataRow row in dt.Rows)
                {
                    ddlOpportunityFilter.Items.Add(new ListItem(row["title"].ToString(), row["opp_id"].ToString()));
                }
            }
            catch
            {
                // Fallback to basic jobs query
                DataTable dtFallback = DBHelper.ExecuteQuery(
                    "SELECT job_id, job_title AS title FROM jobs WHERE company_id = @cid",
                    new SqlParameter("@cid", companyId)
                );

                foreach (DataRow row in dtFallback.Rows)
                {
                    ddlOpportunityFilter.Items.Add(new ListItem(row["title"].ToString(), "J_" + row["job_id"].ToString()));
                }
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Candidates with Dynamic Filters
        // Connects to 'applications', 'jobs', 'internships', and 'member_master_table'
        // filters by selected opportunity, status & search keyword, and calculates AI match.
        // =========================================================================
        private void LoadApplicants(int companyId)
        {
            // ---------------------------------------------------------------------
            // 1. Calculate Metric Status Counters for Top Cards (Overall Company Counts)
            // ---------------------------------------------------------------------
            try
            {
                DataTable dtMetrics = DBHelper.ExecuteQuery(@"
                    SELECT a.application_id, a.status
                    FROM applications a
                    INNER JOIN member_master_table m ON a.user_id = m.id
                    WHERE a.company_id = @cid 
                       OR (a.company_id = 0 AND (
                           EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = @cid) OR 
                           EXISTS (SELECT 1 FROM internships i WHERE i.internship_id = a.internship_id AND i.company_id = @cid)
                       ))",
                    new SqlParameter("@cid", companyId)
                );

                TotalCount = dtMetrics != null ? dtMetrics.Rows.Count : 0;
                NewCount = 0; ReviewCount = 0; ShortlistedCount = 0; InterviewCount = 0; SelectedCount = 0;

                if (dtMetrics != null)
                {
                    foreach (DataRow r in dtMetrics.Rows)
                    {
                        string status = r["status"] != DBNull.Value ? r["status"].ToString() : "";
                        if (status.Equals("New", StringComparison.OrdinalIgnoreCase) || status.Equals("Applied", StringComparison.OrdinalIgnoreCase))
                            NewCount++;
                        else if (status.Equals("Under Review", StringComparison.OrdinalIgnoreCase))
                            ReviewCount++;
                        else if (status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase))
                            ShortlistedCount++;
                        else if (status.Equals("Interview Scheduled", StringComparison.OrdinalIgnoreCase) || status.Equals("Interviewed", StringComparison.OrdinalIgnoreCase) || status.Equals("Interview", StringComparison.OrdinalIgnoreCase))
                            InterviewCount++;
                        else if (status.Equals("Accepted", StringComparison.OrdinalIgnoreCase) || status.Equals("Selected", StringComparison.OrdinalIgnoreCase) || status.Equals("Hired", StringComparison.OrdinalIgnoreCase))
                            SelectedCount++;
                    }
                }
            }
            catch
            {
                TotalCount = 0; NewCount = 0; ReviewCount = 0; ShortlistedCount = 0; InterviewCount = 0; SelectedCount = 0;
            }

            // ---------------------------------------------------------------------
            // 2. Build Filtered Query for the Applicants Table
            // ---------------------------------------------------------------------
            string oppVal = ddlOpportunityFilter.SelectedValue;
            string selectedStatus = ddlStatusFilter != null ? ddlStatusFilter.SelectedValue : "All";
            string search = txtCandidateSearch.Text.Trim();

            string sql = @"
                SELECT a.application_id, a.user_id, a.status, a.applied_at, 
                       ISNULL(j.job_title, i.internship_title) AS JobTitle, 
                       ISNULL(j.requirements, i.skills_required) AS required_skills,
                       m.full_name AS StudentName, m.email_add AS Email, m.skills AS StudentSkills,
                       m.clg_name AS College, m.degree AS Degree, m.profile_photo AS ProfilePhoto
                FROM applications a
                LEFT JOIN jobs j ON a.job_id = j.job_id
                LEFT JOIN internships i ON a.internship_id = i.internship_id
                INNER JOIN member_master_table m ON a.user_id = m.id
                WHERE (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)";

            var parameters = new List<SqlParameter> { new SqlParameter("@cid", companyId) };

            // Dynamic filter by opportunity (Job / Internship)
            if (!string.IsNullOrEmpty(oppVal) && oppVal != "0")
            {
                if (oppVal.StartsWith("J_"))
                {
                    sql += " AND a.job_id = @jid";
                    parameters.Add(new SqlParameter("@jid", Convert.ToInt32(oppVal.Substring(2))));
                }
                else if (oppVal.StartsWith("I_"))
                {
                    sql += " AND a.internship_id = @iid";
                    parameters.Add(new SqlParameter("@iid", Convert.ToInt32(oppVal.Substring(2))));
                }
                else if (int.TryParse(oppVal, out int jid) && jid > 0)
                {
                    sql += " AND a.job_id = @jid";
                    parameters.Add(new SqlParameter("@jid", jid));
                }
            }

            // Dynamic filter by status:
            if (string.IsNullOrEmpty(selectedStatus) || selectedStatus.Equals("All", StringComparison.OrdinalIgnoreCase) || selectedStatus.Equals("AllHistorical", StringComparison.OrdinalIgnoreCase))
            {
                // Show all applicants for this company
            }
            else if (selectedStatus.Equals("Active", StringComparison.OrdinalIgnoreCase))
            {
                sql += " AND a.status NOT IN ('Rejected')";
            }
            else if (selectedStatus.Equals("New", StringComparison.OrdinalIgnoreCase))
            {
                sql += " AND a.status IN ('New', 'Applied')";
            }
            else if (selectedStatus.Equals("Selected", StringComparison.OrdinalIgnoreCase))
            {
                sql += " AND a.status IN ('Selected', 'Accepted', 'Hired')";
            }
            else if (selectedStatus.Equals("Interview Scheduled", StringComparison.OrdinalIgnoreCase))
            {
                sql += " AND a.status LIKE 'Interview%'";
            }
            else
            {
                sql += " AND a.status = @stat";
                parameters.Add(new SqlParameter("@stat", selectedStatus));
            }

            // Dynamic search by student name, email, role, or skills
            if (!string.IsNullOrEmpty(search))
            {
                sql += " AND (m.full_name LIKE @q OR m.email_add LIKE @q OR ISNULL(j.job_title, i.internship_title) LIKE @q OR m.skills LIKE @q)";
                parameters.Add(new SqlParameter("@q", "%" + search + "%"));
            }

            sql += " ORDER BY a.applied_at DESC";

            // Execute SQL query via DBHelper
            DataTable dt = DBHelper.ExecuteQuery(sql, parameters.ToArray());

            var list = new List<dynamic>();

            foreach (DataRow r in dt.Rows)
            {
                string status = r["status"] != DBNull.Value ? r["status"].ToString() : "New";

                string statusClass = "status-pill-new";
                if (status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase)) statusClass = "status-pill-shortlisted";
                else if (status.Equals("Under Review", StringComparison.OrdinalIgnoreCase)) statusClass = "status-pill-review";
                else if (status.Equals("Selected", StringComparison.OrdinalIgnoreCase) || status.Equals("Accepted", StringComparison.OrdinalIgnoreCase)) statusClass = "status-pill-selected";
                else if (status.Equals("Rejected", StringComparison.OrdinalIgnoreCase)) statusClass = "status-pill-rejected";

                // Evaluate candidate skills against job required skills using AI algorithm
                string sSkills = r["StudentSkills"] != DBNull.Value ? r["StudentSkills"].ToString() : "";
                string rSkills = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "";
                int matchScore = AIService.CalculateMatchScore(sSkills, rSkills);

                string photo = r["ProfilePhoto"] != DBNull.Value ? r["ProfilePhoto"].ToString().Trim() : "";
                if (photo.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    photo.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    photo = "";
                }
                string resolvedPhoto = !string.IsNullOrEmpty(photo) ? DBHelper.ResolveImageUrl(photo, "") : "";

                list.Add(new
                {
                    ApplicationId = r["application_id"],
                    UserId = r["user_id"],
                    StudentName = r["StudentName"].ToString(),
                    Email = r["Email"].ToString(),
                    JobTitle = r["JobTitle"] != DBNull.Value ? r["JobTitle"].ToString() : "Opportunity",
                    Status = status,
                    StatusClass = statusClass,
                    AiMatchScore = matchScore,
                    ProfilePhoto = resolvedPhoto
                });
            }

            // Bind the applicants data to the UI table
            TableCount = list.Count;
            rptApplicants.DataSource = list;
            rptApplicants.DataBind();

            // Set dynamic preview panel candidate from first row or selected ID
            if (dt.Rows.Count > 0)
            {
                DataRow firstRow = dt.Rows[0];
                int targetAppId = ViewState["SelectedApplicationId"] != null ? Convert.ToInt32(ViewState["SelectedApplicationId"]) : 0;
                if (targetAppId > 0)
                {
                    DataRow[] matching = dt.Select(string.Format("application_id = {0}", targetAppId));
                    if (matching.Length > 0) firstRow = matching[0];
                }

                HasSelectedApplicant = true;
                QuickApplicationId = Convert.ToInt32(firstRow["application_id"]);
                QuickStudentId = Convert.ToInt32(firstRow["user_id"]);
                QuickStudentName = firstRow["StudentName"].ToString();
                QuickJobTitle = firstRow["JobTitle"] != DBNull.Value ? firstRow["JobTitle"].ToString() : "";
                QuickCollege = firstRow["College"] != DBNull.Value ? firstRow["College"].ToString() : "University";
                QuickDegree = firstRow["Degree"] != DBNull.Value ? firstRow["Degree"].ToString() : "Computer Engineering";
                string qPhoto = firstRow["ProfilePhoto"] != DBNull.Value ? firstRow["ProfilePhoto"].ToString().Trim() : "";
                if (qPhoto.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    qPhoto.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    qPhoto = "";
                }
                QuickProfilePhoto = !string.IsNullOrEmpty(qPhoto) ? DBHelper.ResolveImageUrl(qPhoto, "") : "";

                string sSkills = firstRow["StudentSkills"] != DBNull.Value ? firstRow["StudentSkills"].ToString() : "";
                string rSkills = firstRow["required_skills"] != DBNull.Value ? firstRow["required_skills"].ToString() : "";
                QuickMatchScore = AIService.CalculateMatchScore(sSkills, rSkills);

                QuickSkills.Clear();
                var rawSkills = sSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var sk in rawSkills)
                {
                    string trimmed = sk.Trim();
                    if (!string.IsNullOrEmpty(trimmed) && QuickSkills.Count < 5)
                        QuickSkills.Add(trimmed);
                }
            }
            else
            {
                HasSelectedApplicant = false;
                QuickApplicationId = 0;
            }
        }

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "C";
            string[] parts = name.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        protected void ddlOpportunityFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadApplicants(CurrentCompanyId);
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadApplicants(CurrentCompanyId);
        }

        protected void txtCandidateSearch_TextChanged(object sender, EventArgs e)
        {
            LoadApplicants(CurrentCompanyId);
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            ddlOpportunityFilter.SelectedValue = "0";
            if (ddlStatusFilter != null) ddlStatusFilter.SelectedValue = "All";
            txtCandidateSearch.Text = "";
            LoadApplicants(CurrentCompanyId);
        }

        protected void btnMetricFilter_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string targetStatus = btn.CommandArgument;
            if (targetStatus == "All")
            {
                if (ddlStatusFilter != null) ddlStatusFilter.SelectedValue = "All";
            }
            else if (ddlStatusFilter != null)
            {
                ListItem item = ddlStatusFilter.Items.FindByValue(targetStatus);
                if (item != null)
                {
                    ddlStatusFilter.SelectedValue = targetStatus;
                }
            }

            LoadApplicants(CurrentCompanyId);
        }

        protected void rptApplicants_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int appId = Convert.ToInt32(e.CommandArgument);
            int companyId = CurrentCompanyId;

            if (e.CommandName == "DirectSelect")
            {
                ViewState["SelectedApplicationId"] = appId;
                OnCandidateStatusChanged?.Invoke(this, new CandidateStatusEventArgs(appId, "Selected"));
                LoadApplicants(companyId);
            }
            else if (e.CommandName == "DirectShortlist")
            {
                ViewState["SelectedApplicationId"] = appId;
                OnCandidateStatusChanged?.Invoke(this, new CandidateStatusEventArgs(appId, "Shortlisted"));
                LoadApplicants(companyId);
            }
            else if (e.CommandName == "DirectReject")
            {
                ViewState["SelectedApplicationId"] = appId;
                OnCandidateStatusChanged?.Invoke(this, new CandidateStatusEventArgs(appId, "Rejected"));
                LoadApplicants(companyId);
            }
            else if (e.CommandName == "SelectCandidate")
            {
                ViewState["SelectedApplicationId"] = appId;
                lblActionMessage.ForeColor = System.Drawing.Color.DarkBlue;
                lblActionMessage.Text = $"Candidate application #{appId} preview loaded.";
                LoadApplicants(companyId);
            }
        }

        protected void btnQuickAction_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string targetStatus = btn.CommandArgument;

            int appId = ViewState["SelectedApplicationId"] != null ? Convert.ToInt32(ViewState["SelectedApplicationId"]) : QuickApplicationId;

            if (appId > 0)
            {
                OnCandidateStatusChanged?.Invoke(this, new CandidateStatusEventArgs(appId, targetStatus));
                LoadApplicants(CurrentCompanyId);
            }
            else
            {
                lblActionMessage.ForeColor = System.Drawing.Color.DarkRed;
                lblActionMessage.Text = "Please select a candidate from the table first.";
            }
        }
    }
}
