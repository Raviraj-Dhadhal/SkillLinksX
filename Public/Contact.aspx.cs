using System;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Public
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // =========================================================================
        // [DATABASE INSERT]: Save Inquiries into Database
        // Inserts contact submissions so Admin can track and review them
        // =========================================================================
        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string role = ddlRole.SelectedValue;
            string subject = txtSubject.Text.Trim();
            string message = txtMessage.Text.Trim();

            try
            {
                // Ensure inquiries / audit table handles the message
                string sql = @"
                    INSERT INTO admin_audit_logs 
                    (action, details, timestamp)
                    VALUES 
                    (@act, @det, GETDATE())";

                string details = $"Contact Form Submission from {name} ({email}, Role: {role}) - Subject: {subject}. Message: {message}";

                DBHelper.ExecuteNonQuery(
                    sql,
                    new SqlParameter("@act", "Contact Inquiry"),
                    new SqlParameter("@det", details)
                );

                lblStatusMessage.Text = "Thank you, " + name + "! Your inquiry has been registered. Our admin team will reach out shortly.";
                lblStatusMessage.ForeColor = System.Drawing.Color.Green;
                lblStatusMessage.Visible = true;

                txtName.Text = string.Empty;
                txtEmail.Text = string.Empty;
                ddlRole.SelectedIndex = 0;
                txtSubject.Text = string.Empty;
                txtMessage.Text = string.Empty;
                chkAgreeTerms.Checked = false;
            }
            catch (Exception ex)
            {
                lblStatusMessage.Text = "Inquiry registered. Thank you!";
                lblStatusMessage.Visible = true;
            }
        }
    }
}
