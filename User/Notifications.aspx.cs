using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Notifications : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadNotifications();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load User Notifications
        // Queries SQL Server 'notifications' table for candidate notifications & metrics
        // =========================================================================
        private void LoadNotifications()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);

                // 1. Fetch live metrics
                string countSql = @"
                    SELECT 
                        SUM(CASE WHEN is_read = 0 THEN 1 ELSE 0 END) AS Unread,
                        SUM(CASE WHEN category = 'Applications' THEN 1 ELSE 0 END) AS Apps,
                        SUM(CASE WHEN category = 'Interviews' THEN 1 ELSE 0 END) AS Interviews,
                        SUM(CASE WHEN category = 'Networking' THEN 1 ELSE 0 END) AS Network
                    FROM notifications 
                    WHERE user_id = @uid";

                DataTable dtCounts = DBHelper.ExecuteQuery(countSql, new SqlParameter("@uid", studentId));
                if (dtCounts != null && dtCounts.Rows.Count > 0)
                {
                    DataRow r = dtCounts.Rows[0];
                    litUnreadCount.Text = r["Unread"] != DBNull.Value ? Convert.ToInt32(r["Unread"]).ToString() : "0";
                    litAppNotifs.Text = r["Apps"] != DBNull.Value ? Convert.ToInt32(r["Apps"]).ToString() : "0";
                    litInterviewNotifs.Text = r["Interviews"] != DBNull.Value ? Convert.ToInt32(r["Interviews"]).ToString() : "0";
                    litNetworkNotifs.Text = r["Network"] != DBNull.Value ? Convert.ToInt32(r["Network"]).ToString() : "0";
                }

                // 2. Fetch list of notifications
                string listSql = @"
                    SELECT notif_id, title, message, category, link_url, is_read, created_at 
                    FROM notifications 
                    WHERE user_id = @uid 
                    ORDER BY created_at DESC";

                DataTable dtList = DBHelper.ExecuteQuery(listSql, new SqlParameter("@uid", studentId));
                rptNotifications.DataSource = dtList;
                rptNotifications.DataBind();
            }
            catch (Exception ex)
            {
                // Fallback graceful display
                litUnreadCount.Text = "0";
                litAppNotifs.Text = "0";
                litInterviewNotifs.Text = "0";
                litNetworkNotifs.Text = "0";
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Mark All As Read Event Handler
        // Updates all unread notifications to read (is_read = 1) in SQL Server
        // =========================================================================
        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                string sql = "UPDATE notifications SET is_read = 1 WHERE user_id = @uid";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter("@uid", studentId));

                // Re-bind to update view
                LoadNotifications();
            }
            catch
            {
                // Silent catch
            }
        }
    }
}
