using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Settings : Page
    {
        public string ProfilePhotoUrl { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            int studentId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                LoadUserSettings(studentId);
            }
            else
            {
                // Preserve ProfilePhotoUrl on postback
                if (Session["UserProfilePhoto"] != null)
                {
                    ProfilePhotoUrl = Session["UserProfilePhoto"].ToString();
                }
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Student Settings
        // Queries 'member_master_table' for current details
        // =========================================================================
        private void LoadUserSettings(int studentId)
        {
            DBHelper.EnsureProfilePhotoColumns();

            string sql = "SELECT full_name, email_add, profile_photo FROM member_master_table WHERE id = @id";
            DataTable dt = null;
            try
            {
                dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", studentId));
            }
            catch
            {
                dt = DBHelper.ExecuteQuery("SELECT full_name, email_add FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
            }

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                txtFullName.Text = r["full_name"] != DBNull.Value ? r["full_name"].ToString() : "";
                txtEmail.Text = r["email_add"] != DBNull.Value ? r["email_add"].ToString() : "";
                txtUsername.Text = txtEmail.Text.Contains("@") ? txtEmail.Text.Split('@')[0] : "student";

                if (r.Table.Columns.Contains("profile_photo") && r["profile_photo"] != DBNull.Value)
                {
                    string p = r["profile_photo"].ToString().Trim();
                    if (!string.IsNullOrEmpty(p))
                    {
                        ProfilePhotoUrl = p;
                        Session["UserProfilePhoto"] = p;
                    }
                }
                else if (Session["UserProfilePhoto"] != null)
                {
                    ProfilePhotoUrl = Session["UserProfilePhoto"].ToString();
                }
            }
        }

        // =========================================================================
        // [PROFILE PHOTO UPLOAD]: Save to ~/Uploads/ProfilePictures/
        // =========================================================================
        protected void btnUploadPhoto_Click(object sender, EventArgs e)
        {
            lblPhotoStatus.Text = "";
            if (!fileProfilePhoto.HasFile)
            {
                lblPhotoStatus.ForeColor = System.Drawing.Color.Red;
                lblPhotoStatus.Text = "Please select a photo file first.";
                return;
            }

            string ext = Path.GetExtension(fileProfilePhoto.FileName).ToLowerInvariant();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
            {
                lblPhotoStatus.ForeColor = System.Drawing.Color.Red;
                lblPhotoStatus.Text = "Invalid format. Only JPG, JPEG, and PNG images are allowed.";
                return;
            }

            if (fileProfilePhoto.PostedFile.ContentLength > 2 * 1024 * 1024)
            {
                lblPhotoStatus.ForeColor = System.Drawing.Color.Red;
                lblPhotoStatus.Text = "Image size cannot exceed 2MB.";
                return;
            }

            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                string folder = Server.MapPath("~/Uploads/ProfilePictures/");
                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                // Delete any older profile photo for this user
                var oldPhotos = Directory.GetFiles(folder, $"User_{studentId}.*");
                foreach (var f in oldPhotos)
                {
                    try { File.Delete(f); } catch { }
                }

                string newFileName = $"User_{studentId}{ext}";
                string savePath = Path.Combine(folder, newFileName);
                fileProfilePhoto.SaveAs(savePath);

                string virtualPath = $"~/Uploads/ProfilePictures/{newFileName}";

                DBHelper.EnsureProfilePhotoColumns();
                try
                {
                    DBHelper.ExecuteNonQuery("UPDATE member_master_table SET profile_photo = @photo WHERE id = @id",
                        new SqlParameter("@photo", virtualPath),
                        new SqlParameter("@id", studentId));
                }
                catch { }

                Session["UserProfilePhoto"] = virtualPath;
                ProfilePhotoUrl = virtualPath;

                lblPhotoStatus.ForeColor = System.Drawing.Color.Green;
                lblPhotoStatus.Text = "Profile picture updated successfully!";
            }
            catch (Exception ex)
            {
                lblPhotoStatus.ForeColor = System.Drawing.Color.Red;
                lblPhotoStatus.Text = "Upload error: " + ex.Message;
            }
        }

        // =========================================================================
        // [PROFILE PHOTO REMOVE]: Reset to default fa-user icon
        // =========================================================================
        protected void btnRemovePhoto_Click(object sender, EventArgs e)
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                string folder = Server.MapPath("~/Uploads/ProfilePictures/");
                if (Directory.Exists(folder))
                {
                    var oldPhotos = Directory.GetFiles(folder, $"User_{studentId}.*");
                    foreach (var f in oldPhotos)
                    {
                        try { File.Delete(f); } catch { }
                    }
                }

                try
                {
                    DBHelper.ExecuteNonQuery("UPDATE member_master_table SET profile_photo = NULL WHERE id = @id",
                        new SqlParameter("@id", studentId));
                }
                catch { }

                Session["UserProfilePhoto"] = null;
                ProfilePhotoUrl = "";

                lblPhotoStatus.ForeColor = System.Drawing.Color.Green;
                lblPhotoStatus.Text = "Profile picture removed. Default avatar restored.";
            }
            catch (Exception ex)
            {
                lblPhotoStatus.ForeColor = System.Drawing.Color.Red;
                lblPhotoStatus.Text = "Error removing photo: " + ex.Message;
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
