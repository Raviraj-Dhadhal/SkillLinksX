using System;
using System.Web.UI;

namespace SkillLinksX.Public
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Response.Redirect("~/User/Dashboard.aspx");
            }
        }
    }
}
