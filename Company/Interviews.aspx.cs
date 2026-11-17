using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Interviews : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Interview Metric Counters
        // =========================================================================
        public int TotalInterviewsCount { get; set; }
        public int UpcomingCount { get; set; }
        public int CompletedCount { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
                LoadCompanyInterviews(companyId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Company Interviews
        // Queries 'interviews' joined with 'member_master_table' and 'jobs'
        // =========================================================================
        private void LoadCompanyInterviews(int companyId)
        {
            string sql = @"
                SELECT i.interview_id, i.interview_date, i.meeting_link_or_venue, i.status,
                       m.full_name AS StudentName,
                       j.job_title AS JobTitle
                FROM interviews i
                INNER JOIN member_master_table m ON i.user_id = m.id
                INNER JOIN jobs j ON i.company_id = j.company_id
                WHERE i.company_id = @cid
                ORDER BY i.interview_date DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));

            TotalInterviewsCount = dt.Rows.Count;
            UpcomingCount = 0;
            CompletedCount = 0;

            var list = new List<dynamic>();

            foreach (DataRow r in dt.Rows)
            {
                string status = r["status"].ToString();
                DateTime iDate = Convert.ToDateTime(r["interview_date"]);

                if (iDate >= DateTime.Today && !status.Equals("Completed", StringComparison.OrdinalIgnoreCase))
                    UpcomingCount++;
                else
                    CompletedCount++;

                string statusClass = "pending";
                if (status.Equals("Confirmed", StringComparison.OrdinalIgnoreCase)) statusClass = "confirmed";
                else if (status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) statusClass = "completed";

                string meetLink = r["meeting_link_or_venue"] != DBNull.Value ? r["meeting_link_or_venue"].ToString() : "https://meet.google.com/new";

                list.Add(new
                {
                    InterviewId = r["interview_id"],
                    StudentName = r["StudentName"].ToString(),
                    JobTitle = r["JobTitle"].ToString(),
                    InterviewDateFormatted = iDate.ToString("MMM dd, yyyy - hh:mm tt"),
                    MeetingLink = meetLink,
                    Status = status,
                    StatusClass = statusClass
                });
            }

            rptUpcomingInterviews.DataSource = list;
            rptUpcomingInterviews.DataBind();
        }
    }
}
