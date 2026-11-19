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
                if (Request.QueryString["action"] == "logout")
                {
                    Session.Clear();
                    Session.Abandon();
                }
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
                DBHelper.EnsureCompanyColumns();
                DBHelper.EnsureProfilePhotoColumns();

                string sql = @"SELECT u.user_id, u.email, r.role_name, u.account_status,
                               COALESCE(m.full_name, c.comp_name, 'Admin') AS DisplayName,
                               c.company_id
                               FROM [dbo].[user_auth] u
                               JOIN [dbo].[role] r ON u.role_id = r.role_id
                               LEFT JOIN [dbo].[member_master_table] m ON u.user_id = m.id
                               LEFT JOIN [dbo].[company_table] c ON (u.user_id = c.user_id AND (c.comp_name NOT LIKE '%TechNova%' OR LOWER(u.email) LIKE '%technova%'))
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

                    if (status.Equals("Suspended", StringComparison.OrdinalIgnoreCase) || status.Equals("Revoked", StringComparison.OrdinalIgnoreCase))
                    {
                        ShowError("Your account has been revoked/suspended by the administrator. Please contact support.");
                        return;
                    }

                    if (status.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                    {
                        ShowError("Your account is currently pending administrator verification. Please wait for approval.");
                        return;
                    }

                    // Clear any leftover session state from previous logins
                    Session.Clear();

                    int userId = Convert.ToInt32(row["user_id"]);
                    string userEmail = row["email"].ToString();
                    string role = row["role_name"].ToString();
                    string displayName = row["DisplayName"] != DBNull.Value ? row["DisplayName"].ToString() : "";

                    // Populate Base Session State
                    Session["UserId"] = userId;
                    Session["Email"]  = userEmail;
                    Session["Role"]   = role;

                    // Role-based redirection
                    if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                    {
                        Session["UserName"] = !string.IsNullOrEmpty(displayName) ? displayName : "Administrator";
                        Response.Redirect("~/Admin/Dashboard.aspx", false);
                    }
                    else if (role.Equals("Company", StringComparison.OrdinalIgnoreCase))
                    {
                        DBHelper.EnsureCompanyColumns();
                        DBHelper.EnsureProfilePhotoColumns();

                        int cid = DBHelper.GetCurrentCompanyId(userId, Session);
                        string compName = "";
                        string compPhoto = "";

                        if (cid > 0)
                        {
                            DataTable dtComp = DBHelper.ExecuteQuery(
                                "SELECT comp_name, profile_photo FROM company_table WHERE company_id = @cid",
                                new SqlParameter("@cid", cid));

                            if (dtComp != null && dtComp.Rows.Count > 0)
                            {
                                compName = dtComp.Rows[0]["comp_name"] != DBNull.Value ? dtComp.Rows[0]["comp_name"].ToString().Trim() : "";
                                if (dtComp.Rows[0]["profile_photo"] != DBNull.Value)
                                    compPhoto = dtComp.Rows[0]["profile_photo"].ToString().Trim();
                            }
                        }

                        if (string.IsNullOrEmpty(compName) || (compName.Contains("TechNova") && !userEmail.ToLower().Contains("technova")))
                        {
                            compName = !string.IsNullOrEmpty(displayName) && displayName != "Admin" && displayName != "Company" && (!displayName.Contains("TechNova") || userEmail.ToLower().Contains("technova"))
                                ? displayName
                                : userEmail.Split('@')[0];
                            if (compName.Length > 0) compName = char.ToUpper(compName[0]) + (compName.Length > 1 ? compName.Substring(1) : "");
                        }

                        Session["CompanyId"] = cid;
                        Session["UserName"]  = compName;
                        Session["CompanyName"] = compName;
                        if (!string.IsNullOrEmpty(compPhoto))
                            Session["CompanyProfilePhoto"] = compPhoto;
                        else
                            Session["CompanyProfilePhoto"] = null;

                        Response.Redirect("~/Company/Dashboard.aspx", false);
                    }
                    else
                    {
                        Session["UserName"] = !string.IsNullOrEmpty(displayName) ? displayName : userEmail.Split('@')[0];
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
