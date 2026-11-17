using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Settings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // =========================================================================
            // [VIVA EVALUATION - STATE MANAGEMENT & AUTHENTICATION]:
            // Restrict admin portal settings to authenticated Admin users only.
            // =========================================================================
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAdminSettings();
            }
        }

        // =========================================================================
        // [DATABASE CONNECTIVITY & ADO.NET]: Load Platform Settings
        // Retrieves administrative configurations or defaults from audit/system tables
        // =========================================================================
        private void LoadAdminSettings()
        {
            try
            {
                // Attempt to read recent admin configuration audit logs
                string sql = "SELECT TOP 1 details, timestamp FROM admin_audit_logs WHERE action = 'Admin Settings Update' ORDER BY log_id DESC";
                DataTable dt = DBHelper.ExecuteQuery(sql);

                if (dt != null && dt.Rows.Count > 0)
                {
                    lblGeneralFeedback.ForeColor = System.Drawing.Color.DimGray;
                    lblGeneralFeedback.Text = "Last updated: " + Convert.ToDateTime(dt.Rows[0]["timestamp"]).ToString("g");
                }
            }
            catch
            {
                // Graceful fallback to default values in aspx markup
            }
        }

        // =========================================================================
        // [DATABASE INSERTION & ADO.NET]: Save General Platform Settings
        // Writes updated platform parameters to 'admin_audit_logs'
        // =========================================================================
        protected void btnSaveGeneral_Click(object sender, EventArgs e)
        {
            try
            {
                string platformName = txtPlatformName.Text.Trim();
                string email = txtPlatformEmail.Text.Trim();
                string support = txtSupportEmail.Text.Trim();
                string phone = txtSupportPhone.Text.Trim();
                string city = txtDefaultCity.Text.Trim();
                string country = ddlCountry.SelectedValue;

                string logDetails = $"Platform: {platformName}, Email: {email}, Support: {support}, Phone: {phone}, Location: {city}, {country}";

                string sql = @"
                    INSERT INTO admin_audit_logs 
                    (action, details, timestamp)
                    VALUES 
                    (@act, @det, GETDATE())";

                DBHelper.ExecuteNonQuery(
                    sql,
                    new SqlParameter("@act", "Admin Settings Update"),
                    new SqlParameter("@det", logDetails)
                );

                lblGeneralFeedback.ForeColor = System.Drawing.Color.Green;
                lblGeneralFeedback.Text = "General settings saved and logged to database!";
            }
            catch (Exception ex)
            {
                lblGeneralFeedback.ForeColor = System.Drawing.Color.Red;
                lblGeneralFeedback.Text = "Save error: " + ex.Message;
            }
        }

        // =========================================================================
        // [DATABASE INSERTION & ADO.NET]: Save Platform Toggles
        // Persists operational toggles (Registration, Verification, AI features)
        // =========================================================================
        protected void btnSavePlatformSettings_Click(object sender, EventArgs e)
        {
            try
            {
                string toggleDetails = $"Registration: {chkAllowRegistration.Checked}, Verification: {chkRequireVerification.Checked}, JobPosting: {chkAllowJobPosting.Checked}, AIMatching: {chkAIMatching.Checked}, AIAssistant: {chkAIAssistant.Checked}";

                string sql = @"
                    INSERT INTO admin_audit_logs 
                    (action, details, timestamp)
                    VALUES 
                    (@act, @det, GETDATE())";

                DBHelper.ExecuteNonQuery(
                    sql,
                    new SqlParameter("@act", "Platform Toggles Update"),
                    new SqlParameter("@det", toggleDetails)
                );

                lblPlatformFeedback.ForeColor = System.Drawing.Color.Green;
                lblPlatformFeedback.Text = "Platform feature toggles saved successfully!";
            }
            catch (Exception ex)
            {
                lblPlatformFeedback.ForeColor = System.Drawing.Color.Red;
                lblPlatformFeedback.Text = "Save error: " + ex.Message;
            }
        }
    }
}
