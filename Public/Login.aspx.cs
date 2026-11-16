using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Public
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblLoginError.Visible = false;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string email    = txtLoginEmail.Text.Trim();
            string password = txtLoginPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("Please enter both email address and password.");
                return;
            }

            try
            {
                string sql = @"SELECT u.user_id, u.email, r.role_name, u.account_status,
                               COALESCE(m.full_name, c.comp_name, 'Admin') AS DisplayName,
                               c.company_id
                               FROM [dbo].[user_auth] u
                               JOIN [dbo].[role] r ON u.role_id = r.role_id
                               LEFT JOIN [dbo].[member_master_table] m ON u.user_id = m.id
                               LEFT JOIN [dbo].[company_table] c ON u.user_id = c.user_id
                               WHERE u.email = @email AND u.password_hash = @password;";

                SqlParameter[] parameters = {
                    new SqlParameter("@email", email),
                    new SqlParameter("@password", password)
                };

                DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    string status = row["account_status"] != DBNull.Value ? row["account_status"].ToString() : "Active";

                    if (status.Equals("Suspended", StringComparison.OrdinalIgnoreCase))
                    {
                        ShowError("Your account has been suspended by the administrator. Please contact support.");
                        return;
                    }

                    // Populate Session State
                    Session["UserId"]    = Convert.ToInt32(row["user_id"]);
                    Session["UserName"]  = row["DisplayName"].ToString();
                    Session["Email"]     = row["email"].ToString();
                    Session["Role"]      = row["role_name"].ToString();
                    Session["CompanyId"] = row["company_id"] != DBNull.Value ? Convert.ToInt32(row["company_id"]) : 0;

                    // Role-based redirection
                    string role = row["role_name"].ToString();
                    if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("~/Admin/Dashboard.aspx", false);
                    }
                    else if (role.Equals("Company", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("~/Company/Dashboard.aspx", false);
                    }
                    else
                    {
                        Response.Redirect("~/User/Dashboard.aspx", false);
                    }

                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    ShowError("Invalid email address or password.");
                }
            }
            catch (SqlException ex)
            {
                ShowError("Database connection error: " + ex.Message);
            }
            catch (Exception ex)
            {
                ShowError("An unexpected error occurred: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblLoginError.Text = message;
            lblLoginError.Visible = true;
        }
    }
}
