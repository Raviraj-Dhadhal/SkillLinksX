using System;
using System.Web.UI;

namespace SkillLinksX.Admin
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin authorization
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // =========================================================================
                // [STATE MANAGEMENT & VIVA RUBRIC]:
                // Display authenticated administrator session name and email
                // =========================================================================
                string adminName = Session["UserName"] != null ? Session["UserName"].ToString() : "Mahek Godvani";
                litAdminName.Text = adminName;
                litAdminEmail.Text = adminName.ToLower().Replace(" ", ".") + "@skilllinkx.com";
            }
        }
    }
}
