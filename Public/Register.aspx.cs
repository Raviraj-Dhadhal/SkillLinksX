using System;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Public
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblRegisterStatus.Visible = false;
            }
        }

        protected void btnCreateAccount_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string selectedRole = Request.Form["hiddenSelectedRole"] ?? "Student";
            string fullName     = txtRegFullName.Text.Trim();
            string email        = txtRegEmail.Text.Trim();
            string phone        = txtRegPhone.Text.Trim();
            string password     = txtRegPassword.Text.Trim();
            string city         = txtRegCity.Text.Trim();
            string state        = ddlRegState.SelectedValue;
            string college      = txtRegCollege.Text.Trim();
            string skills       = txtRegSkills.Text.Trim();

            int gradYear = 0;
            int.TryParse(ddlGradYear.SelectedValue, out gradYear);
            if (gradYear == 0) gradYear = DateTime.Now.Year;

            // Determine role ID: 1 = Admin, 2 = Student, 3 = Company
            int roleId = (selectedRole.Equals("Company", StringComparison.OrdinalIgnoreCase)) ? 3 : 2;

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    // 1. Check if email is already registered
                    string checkSql = "SELECT COUNT(1) FROM [dbo].[user_auth] WHERE [email] = @email";
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@email", email);
                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            lblRegisterStatus.Text = "An account with this email address already exists. Please login instead.";
                            lblRegisterStatus.CssClass = "form-status-alert error";
                            lblRegisterStatus.Visible = true;
                            return;
                        }
                    }

                    // 2. Insert into user_auth using a transaction
                    using (SqlTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            int newUserId = 0;
                            string insertAuthSql = @"INSERT INTO [dbo].[user_auth] 
                                ([email], [password_hash], [role_id], [account_status], [created_at])
                                VALUES (@email, @pass, @roleId, 'Active', GETDATE());
                                SELECT SCOPE_IDENTITY();";

                            using (SqlCommand authCmd = new SqlCommand(insertAuthSql, conn, trans))
                            {
                                authCmd.Parameters.AddWithValue("@email", email);
                                authCmd.Parameters.AddWithValue("@pass", password);
                                authCmd.Parameters.AddWithValue("@roleId", roleId);

                                object result = authCmd.ExecuteScalar();
                                newUserId = Convert.ToInt32(result);
                            }

                            // 3. Insert into the appropriate profile table
                            if (roleId == 3)
                            {
                                // Company profile
                                string insertCompSql = @"INSERT INTO [dbo].[company_table] 
                                    ([user_id], [comp_name], [email_add], [ph_no], [city], [state], [address], [is_verified], [profile_strength])
                                    VALUES (@userId, @compName, @email, @phone, @city, @state, @address, 0, 50)";

                                using (SqlCommand compCmd = new SqlCommand(insertCompSql, conn, trans))
                                {
                                    compCmd.Parameters.AddWithValue("@userId", newUserId);
                                    compCmd.Parameters.AddWithValue("@compName", fullName);
                                    compCmd.Parameters.AddWithValue("@email", email);
                                    compCmd.Parameters.AddWithValue("@phone", phone);
                                    compCmd.Parameters.AddWithValue("@city", city);
                                    compCmd.Parameters.AddWithValue("@state", state);
                                    compCmd.Parameters.AddWithValue("@address", city + ", " + state);

                                    compCmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                // Student / Member profile
                                string insertMemberSql = @"INSERT INTO [dbo].[member_master_table] 
                                    ([id], [category], [full_name], [email_add], [ph_no], [city], [state], 
                                     [clg_name], [grad_year], [skills], [degree], [profile_strength])
                                    VALUES (@id, @category, @fullName, @email, @phone, @city, @state, 
                                            @college, @gradYear, @skills, @degree, 50)";

                                using (SqlCommand memCmd = new SqlCommand(insertMemberSql, conn, trans))
                                {
                                    memCmd.Parameters.AddWithValue("@id", newUserId);
                                    memCmd.Parameters.AddWithValue("@category", selectedRole);
                                    memCmd.Parameters.AddWithValue("@fullName", fullName);
                                    memCmd.Parameters.AddWithValue("@email", email);
                                    memCmd.Parameters.AddWithValue("@phone", phone);
                                    memCmd.Parameters.AddWithValue("@city", city);
                                    memCmd.Parameters.AddWithValue("@state", state);
                                    memCmd.Parameters.AddWithValue("@college", college);
                                    memCmd.Parameters.AddWithValue("@gradYear", gradYear);
                                    memCmd.Parameters.AddWithValue("@skills", string.IsNullOrWhiteSpace(skills) ? "General" : skills);
                                    memCmd.Parameters.AddWithValue("@degree", "Student Degree");

                                    memCmd.ExecuteNonQuery();
                                }
                            }

                            // Commit transaction
                            trans.Commit();

                            // 4. Set Session variables (State Management)
                            Session["UserId"]   = newUserId.ToString();
                            Session["UserName"] = fullName;
                            Session["Email"]    = email;
                            Session["Role"]     = (roleId == 3) ? "Company" : "Student";

                            // 5. Redirect based on role
                            if (roleId == 3)
                            {
                                Response.Redirect("~/Company/Dashboard.aspx", false);
                            }
                            else
                            {
                                Response.Redirect("~/User/Dashboard.aspx", false);
                            }
                            Context.ApplicationInstance.CompleteRequest();
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            lblRegisterStatus.Text = "Registration failed: " + ex.Message;
                            lblRegisterStatus.CssClass = "form-status-alert error";
                            lblRegisterStatus.Visible = true;
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                lblRegisterStatus.Text = "Database connection error: " + ex.Message;
                lblRegisterStatus.CssClass = "form-status-alert error";
                lblRegisterStatus.Visible = true;
            }
            catch (Exception ex)
            {
                lblRegisterStatus.Text = "An unexpected error occurred: " + ex.Message;
                lblRegisterStatus.CssClass = "form-status-alert error";
                lblRegisterStatus.Visible = true;
            }
        }
    }
}
