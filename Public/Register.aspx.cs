using System;
using System.Data;
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
            // Determine selected role: Student vs Company
            string selectedRole = Request.Form["hiddenSelectedRole"] ?? "Student";
            bool isCompany = selectedRole.Equals("Company", StringComparison.OrdinalIgnoreCase);

            // Common Credentials
            string email    = txtRegEmail.Text.Trim();
            string phone    = txtRegPhone.Text.Trim();
            string password = txtRegPassword.Text.Trim();
            string city     = txtRegCity.Text.Trim();
            string state    = ddlRegState.SelectedValue;

            // Student Fields
            string studentFullName = txtRegFullName.Text.Trim();
            string college         = txtRegCollege.Text.Trim();
            string skills          = txtRegSkills.Text.Trim();
            int gradYear = 0;
            int.TryParse(ddlGradYear.SelectedValue, out gradYear);
            if (gradYear == 0) gradYear = DateTime.Now.Year;

            // Company Fields
            string compName      = txtRegCompName.Text.Trim();
            string recruiterName = txtRegRecruiterName.Text.Trim();
            string compAddress   = txtRegCompAddress.Text.Trim();
            string industry      = ddlRegIndustry.SelectedValue;
            string employeeCount = ddlRegEmployeeCount.SelectedValue;
            string website       = txtRegWebsite.Text.Trim();

            // =========================================================================
            // Server-Side Field Validation based on active role
            // =========================================================================
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(city))
            {
                ShowError("Please complete all required account credentials (Email, Phone, Password, City).");
                return;
            }

            if (isCompany)
            {
                if (string.IsNullOrEmpty(compName))
                {
                    ShowError("Company / Organization name is required.");
                    return;
                }
                if (string.IsNullOrEmpty(compAddress))
                {
                    ShowError("Company office address is required.");
                    return;
                }
                if (string.IsNullOrEmpty(recruiterName))
                {
                    recruiterName = compName + " HR";
                }
            }
            else
            {
                if (string.IsNullOrEmpty(studentFullName))
                {
                    ShowError("Student full name is required.");
                    return;
                }
                if (string.IsNullOrEmpty(college))
                {
                    ShowError("College / University name is required.");
                    return;
                }
                if (gradYear == 0)
                {
                    ShowError("Graduation year is required.");
                    return;
                }
            }

            // Ensure DB schema has all columns needed for company_table
            DBHelper.EnsureCompanyColumns();
            DBHelper.EnsureProfilePhotoColumns();
            DBHelper.EnsureNotificationColumns();

            // Determine role ID dynamically from the 'role' table
            int roleId = isCompany ? 3 : 2;
            try
            {
                string targetRoleName = isCompany ? "Company" : "Student";
                object rObj = DBHelper.ExecuteScalar("SELECT TOP 1 role_id FROM [dbo].[role] WHERE role_name = @rname", new SqlParameter("@rname", targetRoleName));
                if (rObj != null && rObj != DBNull.Value)
                {
                    roleId = Convert.ToInt32(rObj);
                }
                else
                {
                    object altObj = DBHelper.ExecuteScalar("SELECT TOP 1 role_id FROM [dbo].[role] WHERE role_name LIKE @rname", new SqlParameter("@rname", isCompany ? "%Comp%" : "%Stud%"));
                    if (altObj != null && altObj != DBNull.Value) roleId = Convert.ToInt32(altObj);
                }
            }
            catch { }

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
                            ShowError("An account with this email address already exists. Please login instead.");
                            return;
                        }
                    }

                    // 2. Insert into user_auth and appropriate profile table using a Transaction
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

                            int newCompanyId = 0;

                            // 3. Insert into the appropriate profile table
                            if (isCompany)
                            {
                                // Company profile
                                string insertCompSql = @"INSERT INTO [dbo].[company_table] 
                                    ([user_id], [comp_name], [email_add], [ph_no], [city], [state], [address], [industry], [website], [employee_count], [is_verified], [profile_strength])
                                    VALUES (@userId, @compName, @email, @phone, @city, @state, @address, @industry, @website, @empCount, 0, 50);
                                    SELECT SCOPE_IDENTITY();";

                                using (SqlCommand compCmd = new SqlCommand(insertCompSql, conn, trans))
                                {
                                    compCmd.Parameters.AddWithValue("@userId", newUserId);
                                    compCmd.Parameters.AddWithValue("@compName", compName);
                                    compCmd.Parameters.AddWithValue("@email", email);
                                    compCmd.Parameters.AddWithValue("@phone", phone);
                                    compCmd.Parameters.AddWithValue("@city", city);
                                    compCmd.Parameters.AddWithValue("@state", state);
                                    compCmd.Parameters.AddWithValue("@address", compAddress);
                                    compCmd.Parameters.AddWithValue("@industry", string.IsNullOrEmpty(industry) ? "Information Technology" : industry);
                                    compCmd.Parameters.AddWithValue("@website", string.IsNullOrEmpty(website) ? "" : website);
                                    compCmd.Parameters.AddWithValue("@empCount", string.IsNullOrEmpty(employeeCount) ? "11-50" : employeeCount);

                                    object cidResult = compCmd.ExecuteScalar();
                                    if (cidResult != null && cidResult != DBNull.Value)
                                    {
                                        newCompanyId = Convert.ToInt32(cidResult);
                                    }
                                }
                            }
                            else
                            {
                                // Student / Member profile
                                string insertMemberSql = @"INSERT INTO [dbo].[member_master_table] 
                                    ([id], [category], [full_name], [email_add], [ph_no], [city], [state], 
                                     [clg_name], [grad_year], [skills], [degree], [profile_strength])
                                    VALUES (@id, 'Student', @fullName, @email, @phone, @city, @state, 
                                            @college, @gradYear, @skills, @degree, 50)";

                                using (SqlCommand memCmd = new SqlCommand(insertMemberSql, conn, trans))
                                {
                                    memCmd.Parameters.AddWithValue("@id", newUserId);
                                    memCmd.Parameters.AddWithValue("@fullName", studentFullName);
                                    memCmd.Parameters.AddWithValue("@email", email);
                                    memCmd.Parameters.AddWithValue("@phone", phone);
                                    memCmd.Parameters.AddWithValue("@city", city);
                                    memCmd.Parameters.AddWithValue("@state", state);
                                    memCmd.Parameters.AddWithValue("@college", college);
                                    memCmd.Parameters.AddWithValue("@gradYear", gradYear);
                                    memCmd.Parameters.AddWithValue("@skills", string.IsNullOrWhiteSpace(skills) ? "General" : skills);
                                    memCmd.Parameters.AddWithValue("@degree", "Bachelor's Degree");

                                    memCmd.ExecuteNonQuery();
                                }
                            }

                            // Commit transaction
                            trans.Commit();

                            // 4. Set Session variables (State Management)
                            Session["UserId"]   = newUserId.ToString();
                            Session["Email"]    = email;

                            if (isCompany)
                            {
                                Session["UserName"]  = compName;
                                Session["Role"]      = "Company";
                                Session["CompanyId"] = newCompanyId > 0 ? newCompanyId : DBHelper.GetCurrentCompanyId(newUserId, Session);

                                DBHelper.SendNotification(newUserId, "Welcome to SkillLinksX!", "Your company account is ready. Post jobs and internships, search candidate profiles, and schedule interviews.", "~/Company/Dashboard.aspx");

                                Response.Redirect("~/Company/Dashboard.aspx", false);
                            }
                            else
                            {
                                Session["UserName"] = studentFullName;
                                Session["Role"]     = "Student";

                                DBHelper.SendNotification(newUserId, "Welcome to SkillLinksX!", "Your student account is active. Explore internships and jobs matching your skills.", "~/User/Dashboard.aspx");

                                Response.Redirect("~/User/Dashboard.aspx", false);
                            }
                            Context.ApplicationInstance.CompleteRequest();
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            ShowError("Registration failed: " + ex.Message);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                ShowError("Database error during registration: " + ex.Message);
            }
            catch (Exception ex)
            {
                ShowError("An unexpected error occurred: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            lblRegisterStatus.Text = msg;
            lblRegisterStatus.CssClass = "form-status-alert error";
            lblRegisterStatus.Visible = true;
        }
    }
}
