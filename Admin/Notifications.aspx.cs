using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Notifications : Page
    {
        public string CurrentFilter => Request.QueryString["filter"]?.Trim().ToLower() ?? "all";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin authorization
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            int adminUserId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                EnsureAdminAlerts(adminUserId);
                LoadAdminNotifications(adminUserId);
            }
        }

        // =========================================================================
        // Sync critical system & platform activities into notifications for Admin
        // =========================================================================
        private void EnsureAdminAlerts(int adminUserId)
        {
            try
            {
                // 1. Alert for unverified companies
                string checkUnverified = @"
                    SELECT c.company_id, c.comp_name 
                    FROM company_table c
                    WHERE c.is_verified = 0";

                DataTable dtComp = DBHelper.ExecuteQuery(checkUnverified);
                foreach (DataRow r in dtComp.Rows)
                {
                    string compName = r["comp_name"].ToString();
                    string target = "~/Admin/Companies.aspx";
                    string title = $"Verification Needed: {compName}";

                    // Check if already notified
                    string existsSql = "SELECT COUNT(*) FROM notifications WHERE user_id = @uid AND title = @title";
                    int count = Convert.ToInt32(DBHelper.ExecuteScalar(existsSql, 
                        new SqlParameter("@uid", adminUserId),
                        new SqlParameter("@title", title)));

                    if (count == 0)
                    {
                        string insertSql = @"
                            INSERT INTO notifications (user_id, title, message, target_url, is_read, created_at)
                            VALUES (@uid, @title, @msg, @url, 0, GETDATE())";

                        DBHelper.ExecuteNonQuery(insertSql,
                            new SqlParameter("@uid", adminUserId),
                            new SqlParameter("@title", title),
                            new SqlParameter("@msg", $"{compName} has submitted registration and is awaiting company verification approval."),
                            new SqlParameter("@url", target));
                    }
                }

                // 2. Alert for pending accounts in user_auth
                string checkPending = @"
                    SELECT u.user_id, u.email, r.role_name
                    FROM user_auth u
                    INNER JOIN role r ON u.role_id = r.role_id
                    WHERE u.account_status = 'Pending'";

                DataTable dtPending = DBHelper.ExecuteQuery(checkPending);
                foreach (DataRow r in dtPending.Rows)
                {
                    string email = r["email"].ToString();
                    string role = r["role_name"].ToString();
                    string title = $"Pending Approval: {email}";
                    string target = role == "Student" ? "~/Admin/Students.aspx" : "~/Admin/Companies.aspx";

                    string existsSql = "SELECT COUNT(*) FROM notifications WHERE user_id = @uid AND title = @title";
                    int count = Convert.ToInt32(DBHelper.ExecuteScalar(existsSql,
                        new SqlParameter("@uid", adminUserId),
                        new SqlParameter("@title", title)));

                    if (count == 0)
                    {
                        string insertSql = @"
                            INSERT INTO notifications (user_id, title, message, target_url, is_read, created_at)
                            VALUES (@uid, @title, @msg, @url, 0, GETDATE())";

                        DBHelper.ExecuteNonQuery(insertSql,
                            new SqlParameter("@uid", adminUserId),
                            new SqlParameter("@title", title),
                            new SqlParameter("@msg", $"New {role} account ({email}) is currently pending activation."),
                            new SqlParameter("@url", target));
                    }
                }
            }
            catch
            {
                // Fail gracefully
            }
        }

        // =========================================================================
        // Load live notification counts and bind list
        // =========================================================================
        private void LoadAdminNotifications(int adminUserId)
        {
            try
            {
                // Metrics
                string countSql = @"
                    SELECT 
                        COUNT(*) AS Total,
                        SUM(CASE WHEN is_read = 0 THEN 1 ELSE 0 END) AS Unread,
                        SUM(CASE WHEN title LIKE '%Company%' OR title LIKE '%Verification%' THEN 1 ELSE 0 END) AS Companies,
                        SUM(CASE WHEN title LIKE '%Student%' OR title LIKE '%Candidate%' OR title LIKE '%Application%' THEN 1 ELSE 0 END) AS Students,
                        SUM(CASE WHEN title LIKE '%Security%' OR title LIKE '%System%' OR title LIKE '%Pending%' THEN 1 ELSE 0 END) AS SystemAlerts
                    FROM notifications 
                    WHERE user_id = @uid";

                DataTable dtCounts = DBHelper.ExecuteQuery(countSql, new SqlParameter("@uid", adminUserId));
                if (dtCounts != null && dtCounts.Rows.Count > 0)
                {
                    DataRow r = dtCounts.Rows[0];
                    litUnreadCount.Text = (r["Unread"] != DBNull.Value ? Convert.ToInt32(r["Unread"]) : 0).ToString("N0");
                    litCompanyNotifs.Text = (r["Companies"] != DBNull.Value ? Convert.ToInt32(r["Companies"]) : 0).ToString("N0");
                    litStudentNotifs.Text = (r["Students"] != DBNull.Value ? Convert.ToInt32(r["Students"]) : 0).ToString("N0");
                    litSystemNotifs.Text = (r["SystemAlerts"] != DBNull.Value ? Convert.ToInt32(r["SystemAlerts"]) : 0).ToString("N0");
                }

                // Filter
                string whereFilter = "";
                if (CurrentFilter == "unread")
                {
                    whereFilter = " AND is_read = 0 ";
                }
                else if (CurrentFilter == "companies")
                {
                    whereFilter = " AND (title LIKE '%Company%' OR title LIKE '%Verification%') ";
                }
                else if (CurrentFilter == "students")
                {
                    whereFilter = " AND (title LIKE '%Student%' OR title LIKE '%Candidate%' OR title LIKE '%Application%') ";
                }
                else if (CurrentFilter == "system")
                {
                    whereFilter = " AND (title LIKE '%Security%' OR title LIKE '%System%' OR title LIKE '%Pending%') ";
                }

                string sql = $@"
                    SELECT notification_id, user_id, title, message, target_url, is_read, created_at
                    FROM notifications
                    WHERE user_id = @uid {whereFilter}
                    ORDER BY created_at DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", adminUserId));
                rptAdminNotifications.DataSource = dt;
                rptAdminNotifications.DataBind();

                pnlEmptyNotifications.Visible = (dt == null || dt.Rows.Count == 0);
            }
            catch
            {
                pnlEmptyNotifications.Visible = true;
            }
        }

        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int adminUserId = Convert.ToInt32(Session["UserId"]);
                DBHelper.ExecuteNonQuery("UPDATE notifications SET is_read = 1 WHERE user_id = @uid",
                    new SqlParameter("@uid", adminUserId));

                Response.Redirect(Request.RawUrl);
            }
        }

        protected void rptAdminNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int notifId = Convert.ToInt32(e.CommandArgument);
            int adminUserId = Convert.ToInt32(Session["UserId"]);

            if (e.CommandName == "MarkRead")
            {
                DBHelper.ExecuteNonQuery("UPDATE notifications SET is_read = 1 WHERE notification_id = @id AND user_id = @uid",
                    new SqlParameter("@id", notifId),
                    new SqlParameter("@uid", adminUserId));
            }
            else if (e.CommandName == "DeleteNotif")
            {
                DBHelper.ExecuteNonQuery("DELETE FROM notifications WHERE notification_id = @id AND user_id = @uid",
                    new SqlParameter("@id", notifId),
                    new SqlParameter("@uid", adminUserId));
            }

            LoadAdminNotifications(adminUserId);
        }

        public string GetIconClass(string title)
        {
            string t = title.ToLower();
            if (t.Contains("company") || t.Contains("verification"))
                return "fa-solid fa-building-circle-check text-blue";
            if (t.Contains("student") || t.Contains("candidate"))
                return "fa-solid fa-user-graduate text-indigo";
            if (t.Contains("job") || t.Contains("internship") || t.Contains("application"))
                return "fa-solid fa-briefcase text-orange";
            return "fa-solid fa-shield-halved text-purple";
        }
    }
}
