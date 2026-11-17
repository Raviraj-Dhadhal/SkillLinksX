using System;
using System.Web.UI;

namespace SkillLinksX.User
{
    public partial class Help : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }
        }
    }
}
