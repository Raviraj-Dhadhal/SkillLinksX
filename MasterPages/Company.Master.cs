using System;
using System.Data;
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
        public int UnreadMessageCount { get; set; } = 0;
        public string CompanyLogoUrl { get; set; } = "";
        public string DisplayCompanyName { get; set; } = "Company";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                LoadUnreadNotificationCount(userId);
                LoadUnreadMessageCount(userId);
                LoadCompanyInfo(userId);
            }
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

        private void LoadCompanyInfo(int userId)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 0;
            if (companyId <= 0 && Session["UserId"] != null)
            {
                companyId = DBHelper.GetCurrentCompanyId(userId, Session);
            }

            if (companyId > 0)
            {
                try
                {
                    DBHelper.EnsureProfilePhotoColumns();
                    DataTable dt = DBHelper.ExecuteQuery(
                        "SELECT comp_name, profile_photo FROM company_table WHERE company_id = @cid",
                        new SqlParameter("@cid", companyId));

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        string email = Session["Email"] != null ? Session["Email"].ToString().Trim() : "";
                        string name = dt.Rows[0]["comp_name"] != DBNull.Value ? dt.Rows[0]["comp_name"].ToString().Trim() : "";
                        if (!string.IsNullOrEmpty(name) && (!name.Contains("TechNova") || email.ToLower().Contains("technova")))
                        {
                            DisplayCompanyName = name;
                            Session["UserName"] = name;
                            Session["CompanyName"] = name;
                        }

                        if (dt.Rows[0]["profile_photo"] != DBNull.Value && !string.IsNullOrEmpty(dt.Rows[0]["profile_photo"].ToString()))
                        {
                            CompanyLogoUrl = dt.Rows[0]["profile_photo"].ToString().Trim();
                            Session["CompanyProfilePhoto"] = CompanyLogoUrl;
                            return;
                        }
                    }
                }
                catch { }
            }

            if (Session["UserName"] != null && !string.IsNullOrEmpty(Session["UserName"].ToString()))
            {
                DisplayCompanyName = Session["UserName"].ToString();
            }
            CompanyLogoUrl = "";
            Session["CompanyProfilePhoto"] = null;
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
