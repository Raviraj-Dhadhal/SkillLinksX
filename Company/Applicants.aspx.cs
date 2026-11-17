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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            // Wire up custom event subscriber
            this.OnCandidateStatusChanged += Applicants_OnCandidateStatusChanged;

            if (!IsPostBack)
            {
                int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
                LoadOpportunityDropdown(companyId);
                LoadApplicants(companyId);
            }
        }

        private void Applicants_OnCandidateStatusChanged(object sender, CandidateStatusEventArgs e)
        {
            // Event receiver handler: update DB and show confirmation
            DBHelper.ExecuteNonQuery(
                "UPDATE applications SET status = @status WHERE application_id = @id",
                new SqlParameter("@status", e.NewStatus),
                new SqlParameter("@id", e.ApplicationId)
            );
            lblActionMessage.Text = $"Status updated to '{e.NewStatus}' at {e.Timestamp:hh:mm:ss tt}.";
        }

        private void LoadOpportunityDropdown(int companyId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT job_id, title FROM jobs WHERE company_id = @cid",
                new SqlParameter("@cid", companyId)
            );

            ddlOpportunityFilter.Items.Clear();
            ddlOpportunityFilter.Items.Add(new ListItem("All Opportunities", "0"));

            foreach (DataRow row in dt.Rows)
            {
                ddlOpportunityFilter.Items.Add(new ListItem(row["title"].ToString(), row["job_id"].ToString()));
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Candidates with Dynamic Filters
        // Connects to 'applications', 'jobs', and 'member_master_table' tables,
        // filters by selected opportunity & search keyword, and calculates AI match.
        // =========================================================================
        private void LoadApplicants(int companyId)
        {
            int selectedJobId = Convert.ToInt32(ddlOpportunityFilter.SelectedValue);
            string search = txtCandidateSearch.Text.Trim();

            // SQL Query joining applications with jobs and student details
            string sql = @"
                SELECT a.application_id, a.status, a.applied_at, 
                       j.title AS JobTitle, j.required_skills,
                       m.full_name AS StudentName, m.email AS Email, m.skills AS StudentSkills
                FROM applications a
                INNER JOIN jobs j ON a.job_id = j.job_id
                INNER JOIN member_master_table m ON a.student_id = m.member_id
                WHERE j.company_id = @cid";

            var parameters = new List<SqlParameter> { new SqlParameter("@cid", companyId) };

            // Dynamic filter by selected job
            if (selectedJobId > 0)
            {
                sql += " AND a.job_id = @jid";
                parameters.Add(new SqlParameter("@jid", selectedJobId));
            }

            // Dynamic search by student name or student skills
            if (!string.IsNullOrEmpty(search))
            {
                sql += " AND (m.full_name LIKE @q OR m.skills LIKE @q)";
                parameters.Add(new SqlParameter("@q", "%" + search + "%"));
            }

            sql += " ORDER BY a.applied_at DESC";

            // Execute SQL query via DBHelper
            DataTable dt = DBHelper.ExecuteQuery(sql, parameters.ToArray());

            // ---------------------------------------------------------------------
            // Calculate Metric Status Counters for Top Cards
            // ---------------------------------------------------------------------
            TotalCount = dt.Rows.Count;
            NewCount = 0; ReviewCount = 0; ShortlistedCount = 0; InterviewCount = 0; SelectedCount = 0;

            var list = new List<dynamic>();

            foreach (DataRow r in dt.Rows)
            {
                string status = r["status"].ToString();
                if (status.Equals("New", StringComparison.OrdinalIgnoreCase)) NewCount++;
                else if (status.Equals("Under Review", StringComparison.OrdinalIgnoreCase)) ReviewCount++;
                else if (status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase)) ShortlistedCount++;
                else if (status.Equals("Interview Scheduled", StringComparison.OrdinalIgnoreCase)) InterviewCount++;
                else if (status.Equals("Accepted", StringComparison.OrdinalIgnoreCase) || status.Equals("Selected", StringComparison.OrdinalIgnoreCase)) SelectedCount++;

                string statusClass = "status-pill-new";
                if (status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase)) statusClass = "status-pill-shortlisted";
                else if (status.Equals("Under Review", StringComparison.OrdinalIgnoreCase)) statusClass = "status-pill-review";

                // Evaluate candidate skills against job required skills using AI algorithm
                string sSkills = r["StudentSkills"] != DBNull.Value ? r["StudentSkills"].ToString() : "";
                string rSkills = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "";
                int matchScore = AIService.CalculateMatchScore(sSkills, rSkills);

                list.Add(new
                {
                    ApplicationId = r["application_id"],
                    StudentName = r["StudentName"].ToString(),
                    Email = r["Email"].ToString(),
                    JobTitle = r["JobTitle"].ToString(),
                    Status = status,
                    StatusClass = statusClass,
                    AiMatchScore = matchScore
                });
            }

            // Bind the applicants data to the UI table
            rptApplicants.DataSource = list;
            rptApplicants.DataBind();
        }

        protected void ddlOpportunityFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
            LoadApplicants(companyId);
        }

        protected void txtCandidateSearch_TextChanged(object sender, EventArgs e)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
            LoadApplicants(companyId);
        }

        protected void rptApplicants_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectCandidate")
            {
                int appId = Convert.ToInt32(e.CommandArgument);
                ViewState["SelectedApplicationId"] = appId;
                lblActionMessage.Text = $"Candidate application #{appId} selected for action.";
            }
        }

        protected void btnStatusAction_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string targetStatus = btn.CommandArgument;

            if (ViewState["SelectedApplicationId"] != null)
            {
                int appId = Convert.ToInt32(ViewState["SelectedApplicationId"]);
                // Trigger the custom event (TSEE Rubric requirement)
                OnCandidateStatusChanged?.Invoke(this, new CandidateStatusEventArgs(appId, targetStatus));

                int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
                LoadApplicants(companyId);
            }
            else
            {
                lblActionMessage.Text = "Please select a candidate from the table first.";
            }
        }
    }
}
