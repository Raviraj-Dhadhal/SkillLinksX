using System;
using System.Data;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Analytics : Page
    {
        public int Count7Days { get; set; } = 0;
        public int Count30Days { get; set; } = 0;
        public int Count90Days { get; set; } = 0;
        public int CountAllTime { get; set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin authorization
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAnalyticsData();
            }
        }

        // =========================================================================
        // [DATABASE CONNECTIVITY & ADO.NET]: Load Platform Analytics Metrics
        // Queries member_master_table and user_auth for actual student aggregates
        // =========================================================================
        private void LoadAnalyticsData()
        {
            try
            {
                string sql = @"
                    SELECT 
                        COUNT(*) AS TotalAllTime,
                        SUM(CASE WHEN u.created_at IS NOT NULL AND u.created_at >= DATEADD(day, -7, GETDATE()) THEN 1 
                                 WHEN u.created_at IS NULL THEN 1 ELSE 0 END) AS Total7Days,
                        SUM(CASE WHEN u.created_at IS NOT NULL AND u.created_at >= DATEADD(day, -30, GETDATE()) THEN 1 
                                 WHEN u.created_at IS NULL THEN 1 ELSE 0 END) AS Total30Days,
                        SUM(CASE WHEN u.created_at IS NOT NULL AND u.created_at >= DATEADD(day, -90, GETDATE()) THEN 1 
                                 WHEN u.created_at IS NULL THEN 1 ELSE 0 END) AS Total90Days
                    FROM member_master_table m
                    LEFT JOIN user_auth u ON m.id = u.user_id";

                DataTable dt = DBHelper.ExecuteQuery(sql);
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    CountAllTime = r["TotalAllTime"] != DBNull.Value ? Convert.ToInt32(r["TotalAllTime"]) : 0;
                    Count7Days = r["Total7Days"] != DBNull.Value ? Convert.ToInt32(r["Total7Days"]) : 0;
                    Count30Days = r["Total30Days"] != DBNull.Value ? Convert.ToInt32(r["Total30Days"]) : 0;
                    Count90Days = r["Total90Days"] != DBNull.Value ? Convert.ToInt32(r["Total90Days"]) : 0;

                    // Initial view for "Last 30 Days"
                    litTotalStudents.Text = Count30Days.ToString("N0");
                }
            }
            catch
            {
                CountAllTime = 0;
                Count7Days = 0;
                Count30Days = 0;
                Count90Days = 0;
                litTotalStudents.Text = "0";
            }
        }
    }
}
