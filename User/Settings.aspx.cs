using System;
using System.Web.UI;

namespace SkillLinksX.User
{
    public partial class Settings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            // Persist settings / confirmation
            ClientScript.RegisterStartupScript(this.GetType(), "savedAlert", "alert('Settings saved successfully!');", true);
        }
    }
}
