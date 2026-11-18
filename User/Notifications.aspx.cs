using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Notifications : Page
    {
        public string CurrentFilter => Request.QueryString["filter"]?.Trim().ToLower() ?? "all";

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
        // Queries SQL Server 'notifications' table strictly according to schema:
        // notification_id, user_id, title, message, target_url, is_read, created_at
        // =========================================================================
        private void LoadNotifications()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);

                // 1. Fetch live metrics
                string countSql = @"
                    SELECT 
                        COUNT(*) AS Total,
                        SUM(CASE WHEN is_read = 0 THEN 1 ELSE 0 END) AS Unread,
                        SUM(CASE WHEN title LIKE '%Application%' OR title LIKE '%Shortlist%' OR title LIKE '%Select%' OR title LIKE '%Reject%' THEN 1 ELSE 0 END) AS Apps,
                        SUM(CASE WHEN title LIKE '%Interview%' THEN 1 ELSE 0 END) AS Interviews,
                        SUM(CASE WHEN title LIKE '%Message%' THEN 1 ELSE 0 END) AS Network
                    FROM notifications 
                    WHERE user_id = @uid";

                DataTable dtCounts = DBHelper.ExecuteQuery(countSql, new SqlParameter("@uid", studentId));
                if (dtCounts != null && dtCounts.Rows.Count > 0)
                {
                    DataRow r = dtCounts.Rows[0];
                    litUnreadCount.Text = (r["Unread"] != DBNull.Value ? Convert.ToInt32(r["Unread"]) : 0).ToString();
                    litAppNotifs.Text = (r["Apps"] != DBNull.Value ? Convert.ToInt32(r["Apps"]) : 0).ToString();
                    litInterviewNotifs.Text = (r["Interviews"] != DBNull.Value ? Convert.ToInt32(r["Interviews"]) : 0).ToString();
                    litNetworkNotifs.Text = (r["Network"] != DBNull.Value ? Convert.ToInt32(r["Network"]) : 0).ToString();
                }

                // 2. Build list query based on filter tab
                string whereFilter = "";
                if (CurrentFilter == "unread")
                {
                    whereFilter = " AND is_read = 0 ";
                }
                else if (CurrentFilter == "applications")
                {
                    whereFilter = " AND (title LIKE '%Application%' OR title LIKE '%Shortlist%' OR title LIKE '%Select%' OR title LIKE '%Reject%') ";
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

                DataTable dtList = DBHelper.ExecuteQuery(listSql, new SqlParameter("@uid", studentId));
                rptNotifications.DataSource = dtList;
                rptNotifications.DataBind();
            }
            catch (Exception)
            {
                litUnreadCount.Text = "0";
                litAppNotifs.Text = "0";
                litInterviewNotifs.Text = "0";
                litNetworkNotifs.Text = "0";
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Item Command Handler (Mark Read / Navigate)
        // =========================================================================
        protected void rptNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["UserId"] == null) return;
            int studentId = Convert.ToInt32(Session["UserId"]);

            if (e.CommandName == "MarkRead")
            {
                if (int.TryParse(e.CommandArgument.ToString(), out int notifId))
                {
                    string sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = @nid AND user_id = @uid";
                    DBHelper.ExecuteNonQuery(sql, new SqlParameter("@nid", notifId), new SqlParameter("@uid", studentId));
                    LoadNotifications();
                }
            }
            else if (e.CommandName == "Navigate")
            {
                string[] parts = (e.CommandArgument ?? "").ToString().Split(new char[] { '|' }, 2);
                if (parts.Length > 0 && int.TryParse(parts[0], out int notifId))
                {
                    string sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = @nid AND user_id = @uid";
                    DBHelper.ExecuteNonQuery(sql, new SqlParameter("@nid", notifId), new SqlParameter("@uid", studentId));
                }

                string targetUrl = parts.Length > 1 ? parts[1].Trim() : "";
                if (string.IsNullOrEmpty(targetUrl) || targetUrl == "#")
                {
                    targetUrl = "~/User/Dashboard.aspx";
                }

                Response.Redirect(ResolveUrl(targetUrl));
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Mark All As Read Event Handler
        // =========================================================================
        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                string sql = "UPDATE notifications SET is_read = 1 WHERE user_id = @uid";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter("@uid", studentId));
                LoadNotifications();
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

            if (title.Contains("interview")) return "fa-solid fa-video";
            if (title.Contains("shortlist") || title.Contains("select")) return "fa-solid fa-award";
            if (title.Contains("reject")) return "fa-solid fa-circle-xmark";
            if (title.Contains("application") || title.Contains("applied")) return "fa-regular fa-file-lines";
            if (title.Contains("message")) return "fa-regular fa-comment-dots";
            if (title.Contains("profile")) return "fa-regular fa-user";

            return "fa-regular fa-bell";
        }

        public string GetIconBg(string title)
        {
            if (string.IsNullOrEmpty(title)) return "bg-blue-light";
            title = title.ToLower();

            if (title.Contains("interview")) return "bg-green-light";
            if (title.Contains("shortlist") || title.Contains("select")) return "bg-green-light";
            if (title.Contains("reject")) return "bg-rose-subtle";
            if (title.Contains("message")) return "bg-sky-light";

            return "bg-blue-light";
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
