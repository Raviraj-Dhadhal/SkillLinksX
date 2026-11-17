using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Settings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                LoadUserSettings(studentId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Student Settings
        // Queries 'member_master_table' for current details
        // =========================================================================
        private void LoadUserSettings(int studentId)
        {
            string sql = "SELECT full_name, email_add FROM member_master_table WHERE id = @id";
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", studentId));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                txtFullName.Text = r["full_name"] != DBNull.Value ? r["full_name"].ToString() : "";
                txtEmail.Text = r["email_add"] != DBNull.Value ? r["email_add"].ToString() : "";
                txtUsername.Text = txtEmail.Text.Contains("@") ? txtEmail.Text.Split('@')[0] : "student";
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Save Changes Event Handler
        // Updates student full_name and email in 'member_master_table'
        // =========================================================================
        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string newName = txtFullName.Text.Trim();
            string newEmail = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(newName) || string.IsNullOrEmpty(newEmail))
            {
                lblSettingsFeedback.ForeColor = System.Drawing.Color.Red;
                lblSettingsFeedback.Text = "Full Name and Email cannot be empty.";
                return;
            }

            try
            {
                string sql = "UPDATE member_master_table SET full_name = @name, email_add = @email WHERE id = @id";
                int rows = DBHelper.ExecuteNonQuery(
                    sql,
                    new SqlParameter("@name", newName),
                    new SqlParameter("@email", newEmail),
                    new SqlParameter("@id", studentId)
                );

                if (rows > 0)
                {
                    // Refresh session user name so masterpage header updates immediately
                    Session["UserName"] = newName;
                    lblSettingsFeedback.ForeColor = System.Drawing.Color.Green;
                    lblSettingsFeedback.Text = "Settings updated successfully!";
                }
            }
            catch (Exception ex)
            {
                lblSettingsFeedback.ForeColor = System.Drawing.Color.Red;
                lblSettingsFeedback.Text = "Update Error: " + ex.Message;
            }
        }
    }
}
