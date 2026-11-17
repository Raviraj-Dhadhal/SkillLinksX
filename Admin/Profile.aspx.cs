using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Profile : Page
    {
        public string AdminFullName { get; set; } = "Administrator";
        public string AdminEmail { get; set; } = "admin@skilllinkx.com";
        public string AdminPhone { get; set; } = "+91 98765 43210";
        public string AdminLocation { get; set; } = "Ahmedabad, Gujarat, India";
        public string AdminInitials { get; set; } = "A";

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
                LoadAdminProfile();
            }
        }

        private void LoadAdminProfile()
        {
            int adminId = Convert.ToInt32(Session["UserId"]);
            string sessionName = Session["UserName"] != null ? Session["UserName"].ToString() : "Administrator";

            try
            {
                // Query database for admin user details
                string sql = "SELECT user_id, username, email FROM user_auth WHERE user_id = @uid";
                SqlParameter[] p = { new SqlParameter("@uid", adminId) };
                DataTable dt = DBHelper.ExecuteQuery(sql, p);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    AdminFullName = row["username"] != DBNull.Value ? row["username"].ToString() : sessionName;
                    AdminEmail = row["email"] != DBNull.Value ? row["email"].ToString() : (sessionName.ToLower().Replace(" ", ".") + "@skilllinkx.com");
                }
                else
                {
                    AdminFullName = sessionName;
                    AdminEmail = sessionName.ToLower().Replace(" ", ".") + "@skilllinkx.com";
                }
            }
            catch
            {
                AdminFullName = sessionName;
                AdminEmail = sessionName.ToLower().Replace(" ", ".") + "@skilllinkx.com";
            }

            AdminInitials = !string.IsNullOrEmpty(AdminFullName) ? AdminFullName.Substring(0, 1).ToUpper() : "A";
            litAdminName.Text = AdminFullName;
            litAdminEmail.Text = AdminEmail;
        }
    }
}
