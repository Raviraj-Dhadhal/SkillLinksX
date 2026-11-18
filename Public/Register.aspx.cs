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
            if (!Page.IsValid) return;

            // Student Credentials
            string email    = txtRegEmail.Text.Trim();
            string phone    = txtRegPhone.Text.Trim().Replace(" ", "");
            string password = txtRegPassword.Text.Trim();
            string city     = txtRegCity.Text.Trim();
            string state    = ddlRegState.SelectedValue;

            // Student Details
            string studentFullName = txtRegFullName.Text.Trim();
            string college         = txtRegCollege.Text.Trim();
            string skills          = txtRegSkills.Text.Trim();
            int gradYear = 0;
            int.TryParse(ddlGradYear.SelectedValue, out gradYear);
            if (gradYear == 0) gradYear = DateTime.Now.Year;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(city) || string.IsNullOrEmpty(studentFullName) || string.IsNullOrEmpty(college))
            {
                ShowError("Please complete all required fields.");
                return;
            }

            // Student role_id is 2
            int roleId = 2;
            try
            {
                object rObj = DBHelper.ExecuteScalar("SELECT TOP 1 role_id FROM [dbo].[role] WHERE role_name = 'Student'");
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

                    // 2. Insert into user_auth and member_master_table using Transaction
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

                            trans.Commit();

                            // 3. Set Session State & Redirect to Student Dashboard
                            Session["UserId"]   = newUserId.ToString();
                            Session["Email"]    = email;
                            Session["UserName"] = studentFullName;
                            Session["Role"]     = "Student";

                            DBHelper.SendNotification(newUserId, "Welcome to SkillLinksX!", "Your student account is active. Explore internships and jobs matching your skills.", "~/User/Dashboard.aspx");

                            Response.Redirect("~/User/Dashboard.aspx", false);
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
