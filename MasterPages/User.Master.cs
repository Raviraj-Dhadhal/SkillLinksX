using System;
using System.Data.SqlClient;
using SkillLinksX.Helpers;

namespace SkillLinksX.MasterPages
{
    public partial class User : System.Web.UI.MasterPage
    {
        // =========================================================================
        // [VIVA EVALUATION - STATE MANAGEMENT & REAL-TIME NOTIFICATIONS]:
        // Property bound in MasterPage markup to display dynamic unread badge count
        // =========================================================================
        public int UnreadNotificationCount { get; set; } = 0;
        public int UnreadMessageCount { get; set; } = 0;
        public string ProfilePhotoUrl { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                LoadUnreadNotificationCount(userId);
                LoadUnreadMessageCount(userId);
                LoadUserProfilePhoto(userId);
            }
        }

        private void LoadUserProfilePhoto(int userId)
        {
            if (Session["UserProfilePhoto"] != null)
            {
                ProfilePhotoUrl = Session["UserProfilePhoto"].ToString();
                return;
            }

            try
            {
                DBHelper.EnsureProfilePhotoColumns();
                object p = DBHelper.ExecuteScalar("SELECT profile_photo FROM member_master_table WHERE id = @id", new SqlParameter("@id", userId));
                if (p != null && p != DBNull.Value && !string.IsNullOrEmpty(p.ToString()))
                {
                    ProfilePhotoUrl = p.ToString().Trim();
                    Session["UserProfilePhoto"] = ProfilePhotoUrl;
                }
            }
            catch { }
        }

        private void LoadUnreadMessageCount(int userId)
        {
            try
            {
                string sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = @uid AND is_read = 0";
                object result = DBHelper.ExecuteScalar(sql, new SqlParameter("@uid", userId));
                if (result != null && result != DBNull.Value)
                {
                    UnreadMessageCount = Convert.ToInt32(result);
                }
            }
            catch
            {
                UnreadMessageCount = 0;
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
