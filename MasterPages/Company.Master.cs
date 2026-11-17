using System;
using System.Data.SqlClient;
using SkillLinksX.Helpers;

namespace SkillLinksX.MasterPages
{
    public partial class Company : System.Web.UI.MasterPage
    {
        // =========================================================================
        // [VIVA EVALUATION - STATE MANAGEMENT & REAL-TIME NOTIFICATIONS]:
        // Property bound in MasterPage markup to display dynamic unread badge count
        // =========================================================================
        public int UnreadNotificationCount { get; set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                LoadUnreadNotificationCount(userId);
            }
        }

        private void LoadUnreadNotificationCount(int userId)
        {
            try
            {
                string sql = "SELECT COUNT(*) FROM notifications WHERE user_id = @uid AND is_read = 0";
                object result = DBHelper.ExecuteScalar(sql, new SqlParameter("@uid", userId));
                if (result != null && result != DBNull.Value)
                {
                    UnreadNotificationCount = Convert.ToInt32(result);
                }
            }
            catch
            {
                UnreadNotificationCount = 0;
            }
        }
    }
}
