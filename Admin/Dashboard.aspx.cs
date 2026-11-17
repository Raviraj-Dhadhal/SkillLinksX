using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Dashboard : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Platform-wide metrics for Admin Dashboard
        // =========================================================================
        public int TotalStudents { get; set; }
        public int TotalCompanies { get; set; }
        public int ActiveOpportunities { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAdminDashboardMetrics();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Admin Platform Aggregates
        // Queries SQL Server tables (member_master_table, companies, jobs)
        // =========================================================================
        private void LoadAdminDashboardMetrics()
        {
            // 1. Total Registered Students Count
            object sObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM member_master_table WHERE role = 'Student'");
            TotalStudents = sObj != null ? Convert.ToInt32(sObj) : 0;

            // 2. Total Partner Companies Count
            object cObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM companies");
            TotalCompanies = cObj != null ? Convert.ToInt32(cObj) : 0;

            // 3. Active Opportunities Count
            object jObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM jobs WHERE status = 'Active'");
            ActiveOpportunities = jObj != null ? Convert.ToInt32(jObj) : 0;

            // 4. Load Recent Registrations Table
            DataTable dtRecent = DBHelper.ExecuteQuery(@"
                SELECT TOP 5 member_id, full_name, email, role, account_status, created_at
                FROM member_master_table
                ORDER BY created_at DESC");

            var recentUsers = new List<dynamic>();

            foreach (DataRow r in dtRecent.Rows)
            {
                DateTime dt = r["created_at"] != DBNull.Value ? Convert.ToDateTime(r["created_at"]) : DateTime.Now;

                recentUsers.Add(new
                {
                    FullName = r["full_name"].ToString(),
                    Email = r["email"].ToString(),
                    Role = r["role"].ToString(),
                    AccountStatus = r["account_status"] != DBNull.Value ? r["account_status"].ToString() : "Active",
                    JoinedDate = dt.ToString("MMM dd, yyyy")
                });
            }

            rptRecentUsers.DataSource = recentUsers;
            rptRecentUsers.DataBind();
        }
    }
}
