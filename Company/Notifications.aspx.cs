using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Notifications : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authorization
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCompanyNotifications();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Company Notifications
        // Queries SQL Server 'notifications' table for recruiter activity
        // =========================================================================
        private void LoadCompanyNotifications()
        {
            try
            {
                int companyUserId = Convert.ToInt32(Session["UserId"]);

                string sql = @"
                    SELECT notif_id, title, message, category, link_url, is_read, created_at 
                    FROM notifications 
                    WHERE user_id = @uid 
                    ORDER BY created_at DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", companyUserId));
                rptCompanyNotifications.DataSource = dt;
                rptCompanyNotifications.DataBind();
            }
            catch
            {
                // Silent catch
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Mark All Company Notifications Read
        // Updates all unread notifications to read (is_read = 1) in SQL Server
        // =========================================================================
        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            try
            {
                int companyUserId = Convert.ToInt32(Session["UserId"]);
                string sql = "UPDATE notifications SET is_read = 1 WHERE user_id = @uid";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter("@uid", companyUserId));

                // Re-bind to refresh list
                LoadCompanyNotifications();
            }
            catch
            {
                // Silent catch
            }
        }
    }
}
