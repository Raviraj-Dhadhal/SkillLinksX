using System;
using System.Web.UI;

namespace SkillLinksX.Company
{
    public partial class PostJob : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnPublishOpportunity_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Response.Redirect("~/Company/ManageJobs.aspx");
            }
        }
    }
}
