using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Notifications : Page
    {
        public string CurrentFilter => Request.QueryString["filter"]?.Trim().ToLower() ?? "all";

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
        // =========================================================================
        private void LoadCompanyNotifications()
        {
            try
            {
                int companyUserId = Convert.ToInt32(Session["UserId"]);

                // 1. Fetch live metrics
                string countSql = @"
                    SELECT 
                        COUNT(*) AS Total,
                        SUM(CASE WHEN is_read = 0 THEN 1 ELSE 0 END) AS Unread,
                        SUM(CASE WHEN title LIKE '%Application%' OR title LIKE '%Applied%' THEN 1 ELSE 0 END) AS Apps,
                        SUM(CASE WHEN title LIKE '%Interview%' THEN 1 ELSE 0 END) AS Interviews
                    FROM notifications 
                    WHERE user_id = @uid";

                DataTable dtCounts = DBHelper.ExecuteQuery(countSql, new SqlParameter("@uid", companyUserId));
                if (dtCounts != null && dtCounts.Rows.Count > 0)
                {
                    DataRow r = dtCounts.Rows[0];
                    litCompanyTotalNotifs.Text = (r["Total"] != DBNull.Value ? Convert.ToInt32(r["Total"]) : 0).ToString();
                    litCompanyUnreadCount.Text = (r["Unread"] != DBNull.Value ? Convert.ToInt32(r["Unread"]) : 0).ToString();
                    litCompanyAppNotifs.Text = (r["Apps"] != DBNull.Value ? Convert.ToInt32(r["Apps"]) : 0).ToString();
                    litCompanyInterviewNotifs.Text = (r["Interviews"] != DBNull.Value ? Convert.ToInt32(r["Interviews"]) : 0).ToString();
                }

                // 2. Filter query
                string whereFilter = "";
                if (CurrentFilter == "unread")
                {
                    whereFilter = " AND is_read = 0 ";
                }
                else if (CurrentFilter == "applications")
                {
                    whereFilter = " AND (title LIKE '%Application%' OR title LIKE '%Applied%') ";
                }
                else if (CurrentFilter == "interviews")
                {
                    whereFilter = " AND title LIKE '%Interview%' ";
                }

                string listSql = $@"
                    SELECT notification_id, user_id, title, message, target_url, is_read, created_at 
                    FROM notifications 
                    WHERE user_id = @uid {whereFilter}
                    ORDER BY created_at DESC";

                DataTable dt = DBHelper.ExecuteQuery(listSql, new SqlParameter("@uid", companyUserId));
                rptCompanyNotifications.DataSource = dt;
                rptCompanyNotifications.DataBind();
            }
            catch (Exception)
            {
                litCompanyTotalNotifs.Text = "0";
                litCompanyUnreadCount.Text = "0";
                litCompanyAppNotifs.Text = "0";
                litCompanyInterviewNotifs.Text = "0";
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Item Command Handler (Mark Read / Navigate)
        // =========================================================================
        protected void rptCompanyNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["UserId"] == null) return;
            int companyUserId = Convert.ToInt32(Session["UserId"]);

            if (e.CommandName == "MarkRead")
            {
                if (int.TryParse(e.CommandArgument.ToString(), out int notifId))
                {
                    string sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = @nid AND user_id = @uid";
                    DBHelper.ExecuteNonQuery(sql, new SqlParameter("@nid", notifId), new SqlParameter("@uid", companyUserId));
                    LoadCompanyNotifications();
                }
            }
            else if (e.CommandName == "Navigate")
            {
                string[] parts = (e.CommandArgument ?? "").ToString().Split(new char[] { '|' }, 2);
                if (parts.Length > 0 && int.TryParse(parts[0], out int notifId))
                {
                    string sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = @nid AND user_id = @uid";
                    DBHelper.ExecuteNonQuery(sql, new SqlParameter("@nid", notifId), new SqlParameter("@uid", companyUserId));
                }

                string targetUrl = parts.Length > 1 ? parts[1].Trim() : "";
                if (string.IsNullOrEmpty(targetUrl) || targetUrl == "#")
                {
                    targetUrl = "~/Company/Applicants.aspx";
                }

                Response.Redirect(ResolveUrl(targetUrl));
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Mark All Company Notifications Read
        // =========================================================================
        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            try
            {
                int companyUserId = Convert.ToInt32(Session["UserId"]);
                string sql = "UPDATE notifications SET is_read = 1 WHERE user_id = @uid";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter("@uid", companyUserId));
                LoadCompanyNotifications();
            }
            catch { }
        }

        // =========================================================================
        // [HELPERS]: Dynamic Presentation
        // =========================================================================
        public string GetNotificationIcon(string title)
        {
            if (string.IsNullOrEmpty(title)) return "fa-regular fa-bell";
            title = title.ToLower();

            if (title.Contains("interview")) return "fa-regular fa-calendar-check";
            if (title.Contains("application") || title.Contains("applied")) return "fa-solid fa-user-plus";
            if (title.Contains("message")) return "fa-regular fa-comment-dots";
            if (title.Contains("job") || title.Contains("internship")) return "fa-solid fa-briefcase";

            return "fa-regular fa-bell";
        }

        public string GetIconBg(string title)
        {
            if (string.IsNullOrEmpty(title)) return "bg-blue-soft";
            title = title.ToLower();

            if (title.Contains("interview")) return "bg-green-soft";
            if (title.Contains("application") || title.Contains("applied")) return "bg-purple-soft";
            if (title.Contains("message")) return "bg-blue-soft";

            return "bg-blue-soft";
        }

        public string FormatNotificationTime(object dtObj)
        {
            if (dtObj == null || dtObj == DBNull.Value) return "";
            DateTime dt = Convert.ToDateTime(dtObj);
            TimeSpan diff = DateTime.Now - dt;

            if (diff.TotalMinutes < 1) return "Just now";
            if (diff.TotalMinutes < 60) return $"{(int)diff.TotalMinutes} mins ago";
            if (diff.TotalHours < 24 && dt.Date == DateTime.Today) return $"Today at {dt:hh:mm tt}";
            if (diff.TotalDays < 2 && dt.Date == DateTime.Today.AddDays(-1)) return $"Yesterday at {dt:hh:mm tt}";

            return dt.ToString("dd MMM, hh:mm tt");
        }
    }
}
