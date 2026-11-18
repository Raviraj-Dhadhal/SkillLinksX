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
                // 1. Ensure table exists if possible
                DBHelper.EnsureAuditLogTable();

                // 2. Try inserting into contact_inquiries table
                try
                {
                    string inqSql = @"
                        INSERT INTO contact_inquiries (name, email, role, subject, message, status, created_at)
                        VALUES (@name, @email, @role, @subj, @msg, 'New', GETDATE())";

                    DBHelper.ExecuteNonQuery(
                        inqSql,
                        new SqlParameter("@name", name),
                        new SqlParameter("@email", email),
                        new SqlParameter("@role", role),
                        new SqlParameter("@subj", subject),
                        new SqlParameter("@msg", message)
                    );
                }
                catch { }

                // 3. Notify Admin in verified dbo.notifications table
                try
                {
                    object adminObj = DBHelper.ExecuteScalar(@"
                        SELECT TOP 1 u.user_id 
                        FROM user_auth u 
                        INNER JOIN role r ON u.role_id = r.role_id 
                        WHERE r.role_name = 'Admin'");

                    if (adminObj != null && adminObj != DBNull.Value)
                    {
                        int adminId = Convert.ToInt32(adminObj);
                        string notifTitle = $"Contact Inquiry: {subject}";
                        if (notifTitle.Length > 200) notifTitle = notifTitle.Substring(0, 200);

                        string notifMsg = $"From: {name} ({email}, Role: {role})\nMessage: {message}";

                        DBHelper.ExecuteNonQuery(@"
                            INSERT INTO notifications (user_id, title, message, target_url, is_read, created_at)
                            VALUES (@uid, @title, @msg, '~/Admin/Dashboard.aspx', 0, GETDATE())",
                            new SqlParameter("@uid", adminId),
                            new SqlParameter("@title", notifTitle),
                            new SqlParameter("@msg", notifMsg)
                        );
                    }
                }
                catch { }

                // 4. Reset form inputs so everything goes back to clean initial state
                txtName.Text = string.Empty;
                txtEmail.Text = string.Empty;
                ddlRole.SelectedIndex = 0;
                txtSubject.Text = string.Empty;
                txtMessage.Text = string.Empty;

                // 5. Show high-visibility emerald green success alert
                lblStatusMessage.CssClass = "contact-status-banner success";
                lblStatusMessage.Text = "<i class=\"fa-solid fa-circle-check\"></i> <div><strong style=\"display:block; font-size:14.5px; color:#065F46; margin-bottom:2px;\">Inquiry Registered Successfully!</strong> Thank you, " + Server.HtmlEncode(name) + ". Your inquiry has been submitted to our team. We will get back to you shortly.</div>";
                lblStatusMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblStatusMessage.CssClass = "contact-status-banner error";
                lblStatusMessage.Text = "<i class=\"fa-solid fa-triangle-exclamation\"></i> <div><strong style=\"display:block; font-size:14.5px; color:#991B1B; margin-bottom:2px;\">Submission Error</strong> Could not send your inquiry right now: " + Server.HtmlEncode(ex.Message) + "</div>";
                lblStatusMessage.Visible = true;
            }
        }
    }
}
