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

                        // Query company_table specifically for this company account
                        DataTable dtComp = DBHelper.ExecuteQuery(
                            "SELECT company_id, comp_name, profile_photo FROM company_table WHERE user_id = @uid OR email_add = @email",
                            new SqlParameter("@uid", userId),
                            new SqlParameter("@email", userEmail));

                        int cid = 0;
                        string compName = "";
                        string compPhoto = "";

                        if (dtComp != null && dtComp.Rows.Count > 0)
                        {
                            cid = Convert.ToInt32(dtComp.Rows[0]["company_id"]);
                            compName = dtComp.Rows[0]["comp_name"].ToString().Trim();
                            if (dtComp.Rows[0]["profile_photo"] != DBNull.Value)
                                compPhoto = dtComp.Rows[0]["profile_photo"].ToString().Trim();

                            // Ensure user_id is properly linked
                            DBHelper.ExecuteNonQuery("UPDATE company_table SET user_id = @uid WHERE company_id = @cid",
                                new SqlParameter("@uid", userId),
                                new SqlParameter("@cid", cid));
                        }
                        else
                        {
                            // Auto-provision an isolated company_table record for this company account
                            compName = !string.IsNullOrEmpty(displayName) && displayName != "Admin" && displayName != "Company"
                                ? displayName
                                : userEmail.Split('@')[0];

                            if (compName.Length > 0)
                                compName = char.ToUpper(compName[0]) + (compName.Length > 1 ? compName.Substring(1) : "");

                            object newCid = DBHelper.ExecuteScalar(@"
                                INSERT INTO company_table (user_id, comp_name, email_add, ph_no, city, state, address, is_verified, profile_strength)
                                VALUES (@uid, @cname, @email, '', 'Ahmedabad', 'Gujarat', '', 0, 50);
                                SELECT SCOPE_IDENTITY();",
                                new SqlParameter("@uid", userId),
                                new SqlParameter("@cname", compName),
                                new SqlParameter("@email", userEmail));

                            if (newCid != null && newCid != DBNull.Value)
                                cid = Convert.ToInt32(newCid);
                        }

                        Session["CompanyId"] = cid;
                        Session["UserName"]  = compName;
                        if (!string.IsNullOrEmpty(compPhoto))
                            Session["CompanyProfilePhoto"] = compPhoto;

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
