using System;
using System.Web.UI;

namespace SkillLinksX.Public
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendResetLink_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                lblForgotStatus.Text = "A password reset link has been dispatched to your email address.";
                lblForgotStatus.Visible = true;
                txtForgotEmail.Text = string.Empty;
            }
        }
    }
}
