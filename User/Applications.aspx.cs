using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Applications : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Exposed for UI Metric Tiles in Applications.aspx
        // =========================================================================
        public int TotalApplications { get; set; }
        public int UnderReviewCount { get; set; }
        public int ShortlistedCount { get; set; }
        public int InterviewCount { get; set; }
        public int SelectedCount { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                LoadUserApplications(studentId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load User Applications
        // Queries 'applications', 'jobs', and 'company_table' tables for the student.
        // Calculates real-time metric counters and binds the status feed.
        // =========================================================================
        private void LoadUserApplications(int studentId)
        {
            string sql = @"
                SELECT a.application_id, a.status, a.applied_at, 
                       j.job_title AS JobTitle, j.location, j.job_type,
                       c.comp_name AS CompanyName
                FROM applications a
                INNER JOIN jobs j ON a.job_id = j.job_id
                INNER JOIN company_table c ON j.company_id = c.company_id
                WHERE a.user_id = @sid
                ORDER BY a.applied_at DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@sid", studentId));

            TotalApplications = dt.Rows.Count;
            UnderReviewCount = 0;
            ShortlistedCount = 0;
            InterviewCount = 0;
            SelectedCount = 0;

            var appsList = new List<dynamic>();

            foreach (DataRow row in dt.Rows)
            {
                string status = row["status"].ToString();
                string badgeClass = "badge-under-review";

                if (status.Equals("Under Review", StringComparison.OrdinalIgnoreCase) || status.Equals("New", StringComparison.OrdinalIgnoreCase))
                {
                    UnderReviewCount++;
                    badgeClass = "badge-under-review";
                }
                else if (status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase))
                {
                    ShortlistedCount++;
                    badgeClass = "badge-shortlisted";
                }
                else if (status.Equals("Interview Scheduled", StringComparison.OrdinalIgnoreCase))
                {
                    InterviewCount++;
                    badgeClass = "badge-interview-sched";
                }
                else if (status.Equals("Accepted", StringComparison.OrdinalIgnoreCase) || status.Equals("Selected", StringComparison.OrdinalIgnoreCase))
                {
                    SelectedCount++;
                    badgeClass = "badge-selected";
                }

                DateTime appliedDate = Convert.ToDateTime(row["applied_at"]);
                string timeString = "Applied " + appliedDate.ToString("MMM dd, yyyy");

                appsList.Add(new
                {
                    ApplicationId = row["application_id"],
                    JobTitle = row["JobTitle"].ToString(),
                    CompanyName = row["CompanyName"].ToString(),
                    Location = row["location"].ToString(),
                    JobType = row["job_type"].ToString(),
                    Status = status,
                    StatusBadgeClass = badgeClass,
                    AppliedTime = timeString
                });
            }

            // Bind the dynamic application list to the Repeater
            rptApplicationsList.DataSource = appsList;
            rptApplicationsList.DataBind();
        }
    }
}
