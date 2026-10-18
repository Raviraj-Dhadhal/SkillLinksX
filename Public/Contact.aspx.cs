using System;
using System.Web.UI;

namespace SkillLinksX.Public
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                lblStatusMessage.Text = "Thank you, " + txtName.Text.Trim() + "! Your message has been sent successfully.";
                lblStatusMessage.Visible = true;

                txtName.Text = string.Empty;
                txtEmail.Text = string.Empty;
                ddlRole.SelectedIndex = 0;
                txtSubject.Text = string.Empty;
                txtMessage.Text = string.Empty;
                chkAgreeTerms.Checked = false;
            }
        }
    }
}
