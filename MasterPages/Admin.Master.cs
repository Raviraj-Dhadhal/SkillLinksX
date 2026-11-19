using System;
using System.Data.SqlClient;
using SkillLinksX.Helpers;

namespace SkillLinksX.MasterPages
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        public string ProfilePhotoUrl { get; set; } = "";
        public int UnreadNotificationCount { get; set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                LoadUnreadNotificationCount(userId);
                LoadProfilePhoto(userId);
            }
        }

        private void LoadProfilePhoto(int userId)
        {
            try
            {
                DBHelper.EnsureProfilePhotoColumns();
                string photo = "";

                // 1. Check user_auth
                try
                {
                    object p = DBHelper.ExecuteScalar("SELECT profile_photo FROM user_auth WHERE user_id = @uid", new SqlParameter("@uid", userId));
                    if (p != null && p != DBNull.Value && !string.IsNullOrEmpty(p.ToString()))
                    {
                        photo = p.ToString().Trim();
                    }
                }
                catch { }

                // 2. Check member_master_table fallback
                if (string.IsNullOrEmpty(photo))
                {
                    try
                    {
                        object p2 = DBHelper.ExecuteScalar("SELECT profile_photo FROM member_master_table WHERE id = @uid", new SqlParameter("@uid", userId));
                        if (p2 != null && p2 != DBNull.Value && !string.IsNullOrEmpty(p2.ToString()))
                        {
                            photo = p2.ToString().Trim();
                        }
                    }
                    catch { }
                }

                if (!string.IsNullOrEmpty(photo) &&
                    photo.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) < 0 &&
                    photo.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) < 0)
                {
                    ProfilePhotoUrl = DBHelper.ResolveImageUrl(photo, "");
                }
                else
                {
                    ProfilePhotoUrl = "";
                }
            }
            catch
            {
                ProfilePhotoUrl = "";
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
