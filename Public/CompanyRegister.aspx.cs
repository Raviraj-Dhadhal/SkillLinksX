using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Public
{
    public partial class CompanyRegister : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblRegisterStatus.Visible = false;
            }
        }

        protected void btnRegisterCompany_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string compName      = txtRegCompName.Text.Trim();
            string recruiterName = txtRegRecruiterName.Text.Trim();
            string industry      = ddlRegIndustry.SelectedValue;
            string employeeCount = ddlRegEmployeeCount.SelectedValue;
            string compAddress   = txtRegCompAddress.Text.Trim();
            string website       = txtRegWebsite.Text.Trim();

            string email    = txtRegEmail.Text.Trim();
            string phone    = txtRegPhone.Text.Trim().Replace(" ", "");
            string password = txtRegPassword.Text.Trim();
            string city     = txtRegCity.Text.Trim();
            string state    = ddlRegState.SelectedValue;

            if (string.IsNullOrEmpty(compName) || string.IsNullOrEmpty(compAddress) ||
                string.IsNullOrEmpty(email) || string.IsNullOrEmpty(phone) ||
                string.IsNullOrEmpty(password) || string.IsNullOrEmpty(city))
            {
                ShowError("Please complete all required fields.");
                return;
            }

            if (string.IsNullOrEmpty(recruiterName))
            {
                recruiterName = compName + " HR";
            }

            // Guarantee database schema has necessary company columns
            DBHelper.EnsureCompanyColumns();
            DBHelper.EnsureProfilePhotoColumns();
            DBHelper.EnsureNotificationColumns();

            // Company role id = 3 as per database schema
            int roleId = 3;
            try
            {
                object rObj = DBHelper.ExecuteScalar("SELECT TOP 1 role_id FROM [dbo].[role] WHERE role_name = 'Company'");
                if (rObj != null && rObj != DBNull.Value) roleId = Convert.ToInt32(rObj);
            }
            catch { }

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    // 1. Check if email already registered
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

                    // 2. Insert into user_auth and company_table using Transaction
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
                            string insertCompSql = @"INSERT INTO [dbo].[company_table] 
                                ([user_id], [comp_name], [email_add], [ph_no], [city], [state], [address], [industry], [website], [employee_count], [is_verified], [profile_strength])
                                VALUES (@userId, @compName, @email, @phone, @city, @state, @address, @industry, @website, @empCount, 0, 0);
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
                                compCmd.Parameters.AddWithValue("@industry", string.IsNullOrEmpty(industry) ? "Information Technology & Services" : industry);
                                compCmd.Parameters.AddWithValue("@website", string.IsNullOrEmpty(website) ? "" : website);
                                compCmd.Parameters.AddWithValue("@empCount", string.IsNullOrEmpty(employeeCount) ? "11-50" : employeeCount);

                                object cidResult = compCmd.ExecuteScalar();
                                if (cidResult != null && cidResult != DBNull.Value)
                                {
                                    newCompanyId = Convert.ToInt32(cidResult);
                                }
                            }

                            trans.Commit();

                            // 3. Set Session State & Redirect to Company Dashboard
                            Session["UserId"]    = newUserId.ToString();
                            Session["Email"]     = email;
                            Session["UserName"]  = compName;
                            Session["Role"]      = "Company";
                            Session["CompanyId"] = newCompanyId > 0 ? newCompanyId : DBHelper.GetCurrentCompanyId(newUserId, Session);

                            DBHelper.SendNotification(newUserId, "Welcome to SkillLinksX!", "Your company recruiter account is active. Post jobs and internships, view applicants, and schedule interviews.", "~/Company/Dashboard.aspx");

                            Response.Redirect("~/Company/Dashboard.aspx", false);
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
