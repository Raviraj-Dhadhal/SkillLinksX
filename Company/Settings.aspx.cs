using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Settings : Page
    {
        public string CompanyLogoUrl { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

            if (!IsPostBack)
            {
                LoadCompanyData(companyId);
                LoadTeamMembers(companyId);
            }
            else
            {
                if (Session["CompanyProfilePhoto"] != null)
                {
                    CompanyLogoUrl = Session["CompanyProfilePhoto"].ToString();
                }
            }
        }

        private void LoadCompanyData(int companyId)
        {
            try
            {
                DBHelper.EnsureProfilePhotoColumns();

                string sql = "SELECT company_id, comp_name, email_add, ph_no, city, state, address, industry, description, website, employee_count, profile_photo FROM company_table WHERE company_id = @cid";
                DataTable dt = null;
                try
                {
                    dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));
                }
                catch
                {
                    dt = DBHelper.ExecuteQuery("SELECT company_id, comp_name, email_add, ph_no, city, state, address, industry, description, website, employee_count FROM company_table WHERE company_id = @cid", new SqlParameter("@cid", companyId));
                }

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    string name = r["comp_name"] != DBNull.Value ? r["comp_name"].ToString().Trim() : "";
                    txtCompanyName.Text = name;

                    if (r.Table.Columns.Contains("profile_photo") && r["profile_photo"] != DBNull.Value)
                    {
                        string p = r["profile_photo"].ToString().Trim();
                        if (!string.IsNullOrEmpty(p))
                        {
                            CompanyLogoUrl = p;
                            Session["CompanyProfilePhoto"] = p;
                        }
                    }
                    else if (Session["CompanyProfilePhoto"] != null)
                    {
                        CompanyLogoUrl = Session["CompanyProfilePhoto"].ToString();
                    }

                    string ind = r["industry"] != DBNull.Value ? r["industry"].ToString().Trim() : "Information Technology";
                    if (ddlIndustry.Items.FindByText(ind) != null)
                        ddlIndustry.SelectedValue = ind;

                    string size = r["employee_count"] != DBNull.Value ? r["employee_count"].ToString().Trim() : "51-200 employees";
                    if (ddlCompanySize.Items.FindByText(size) != null)
                        ddlCompanySize.SelectedValue = size;

                    txtWebsite.Text = r["website"] != DBNull.Value ? r["website"].ToString().Trim() : "";
                    txtLocation.Text = r["address"] != DBNull.Value ? r["address"].ToString().Trim() : "";
                    txtContactEmail.Text = r["email_add"] != DBNull.Value ? r["email_add"].ToString().Trim() : "";
                    txtCompanyDesc.Text = r["description"] != DBNull.Value ? r["description"].ToString().Trim() : "";
                }
            }
            catch (Exception ex)
            {
                lblSettingsStatus.ForeColor = System.Drawing.Color.Red;
                lblSettingsStatus.Text = "Error loading settings: " + ex.Message;
            }
        }

        // =========================================================================
        // [TEAM MEMBERS]: Load Account Owner + all Selected/Hired Candidates
        // =========================================================================
        private void LoadTeamMembers(int companyId)
        {
            try
            {
                var teamList = new List<dynamic>();

                // 1. Account Owner / Primary Admin
                string compSql = "SELECT comp_name, email_add, profile_photo FROM company_table WHERE company_id = @cid";
                DataTable dtComp = DBHelper.ExecuteQuery(compSql, new SqlParameter("@cid", companyId));
                if (dtComp != null && dtComp.Rows.Count > 0)
                {
                    string cName = dtComp.Rows[0]["comp_name"].ToString();
                    string cEmail = dtComp.Rows[0]["email_add"].ToString();
                    string cPhoto = dtComp.Rows[0]["profile_photo"] != DBNull.Value ? dtComp.Rows[0]["profile_photo"].ToString() : "";
                    teamList.Add(new
                    {
                        ApplicationId = 0,
                        FullName = cName,
                        Email = cEmail,
                        RoleName = "Company Administrator",
                        RoleType = "Admin",
                        Status = "Active",
                        ProfilePhoto = cPhoto,
                        Initials = GetInitials(cName)
                    });
                }

                // 2. All candidates marked 'Selected' (Hired) by this company
                string selectedSql = @"
                    SELECT a.application_id, m.id AS member_id, m.full_name, m.email_add AS email, m.profile_photo,
                           ISNULL(j.job_title, i.internship_title) AS role_title,
                           a.updated_at
                    FROM applications a
                    INNER JOIN member_master_table m ON a.user_id = m.id
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    WHERE a.company_id = @cid AND a.status = 'Selected'
                    ORDER BY a.updated_at DESC";

                DataTable dtHired = DBHelper.ExecuteQuery(selectedSql, new SqlParameter("@cid", companyId));
                if (dtHired != null)
                {
                    foreach (DataRow r in dtHired.Rows)
                    {
                        string sName = r["full_name"].ToString();
                        string sRole = r["role_title"] != DBNull.Value && !string.IsNullOrEmpty(r["role_title"].ToString()) ? r["role_title"].ToString() : "Hired Team Member";
                        string sPhoto = r["profile_photo"] != DBNull.Value ? r["profile_photo"].ToString() : "";
                        teamList.Add(new
                        {
                            ApplicationId = Convert.ToInt32(r["application_id"]),
                            FullName = sName,
                            Email = r["email"].ToString(),
                            RoleName = sRole,
                            RoleType = "Member",
                            Status = "Active",
                            ProfilePhoto = sPhoto,
                            Initials = GetInitials(sName)
                        });
                    }
                }

                rptTeamMembers.DataSource = teamList;
                rptTeamMembers.DataBind();
            }
            catch { }
        }

        // =========================================================================
        // [TEAM MEMBERS]: Release / Remove Candidate from Company Team
        // Frees the candidate so they can apply for other opportunities again
        // =========================================================================
        protected void rptTeamMembers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ReleaseMember")
            {
                int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
                if (int.TryParse(e.CommandArgument.ToString(), out int appId))
                {
                    try
                    {
                        // Get candidate user_id before releasing
                        object uidObj = DBHelper.ExecuteScalar("SELECT user_id FROM applications WHERE application_id = @aid AND company_id = @cid",
                            new SqlParameter("@aid", appId),
                            new SqlParameter("@cid", companyId));

                        // Release employee from application
                        DBHelper.ExecuteNonQuery("UPDATE applications SET status = 'Released', updated_at = GETDATE() WHERE application_id = @aid AND company_id = @cid",
                            new SqlParameter("@aid", appId),
                            new SqlParameter("@cid", companyId));

                        if (uidObj != null && uidObj != DBNull.Value)
                        {
                            int candUserId = Convert.ToInt32(uidObj);
                            string compName = Session["UserName"]?.ToString() ?? "Company";
                            DBHelper.SendNotification(candUserId,
                                "Released from Company Team",
                                $"You have been released from {compName}. Your profile is now open to apply for new opportunities.",
                                "~/User/Jobs.aspx");
                        }

                        lblTeamActionMsg.ForeColor = System.Drawing.Color.Green;
                        lblTeamActionMsg.Text = "Team member released successfully! Candidate is now eligible to apply for other opportunities.";
                        LoadTeamMembers(companyId);
                    }
                    catch (Exception ex)
                    {
                        lblTeamActionMsg.ForeColor = System.Drawing.Color.Red;
                        lblTeamActionMsg.Text = "Error releasing member: " + ex.Message;
                    }
                }
            }
        }

        protected void btnUploadLogo_Click(object sender, EventArgs e)
        {
            lblLogoStatus.Text = "";
            if (!fileCompanyLogo.HasFile)
            {
                lblLogoStatus.ForeColor = System.Drawing.Color.Red;
                lblLogoStatus.Text = "Please select a logo file first.";
                return;
            }

            string ext = Path.GetExtension(fileCompanyLogo.FileName).ToLowerInvariant();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
            {
                lblLogoStatus.ForeColor = System.Drawing.Color.Red;
                lblLogoStatus.Text = "Invalid format. Only JPG, JPEG, and PNG images are allowed.";
                return;
            }

            if (fileCompanyLogo.PostedFile.ContentLength > 2 * 1024 * 1024)
            {
                lblLogoStatus.ForeColor = System.Drawing.Color.Red;
                lblLogoStatus.Text = "Logo size cannot exceed 2MB.";
                return;
            }

            try
            {
                int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
                string folder = Server.MapPath("~/Uploads/ProfilePictures/");
                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                var oldLogos = Directory.GetFiles(folder, $"Company_{companyId}.*");
                foreach (var f in oldLogos)
                {
                    try { File.Delete(f); } catch { }
                }

                string newFileName = $"Company_{companyId}{ext}";
                string savePath = Path.Combine(folder, newFileName);
                fileCompanyLogo.SaveAs(savePath);

                string virtualPath = $"~/Uploads/ProfilePictures/{newFileName}";

                DBHelper.EnsureProfilePhotoColumns();
                try
                {
                    DBHelper.ExecuteNonQuery("UPDATE company_table SET profile_photo = @photo WHERE company_id = @cid",
                        new SqlParameter("@photo", virtualPath),
                        new SqlParameter("@cid", companyId));
                }
                catch { }

                Session["CompanyProfilePhoto"] = virtualPath;
                CompanyLogoUrl = virtualPath;

                DBHelper.GetCompanyProfileStrength(companyId);

                lblLogoStatus.ForeColor = System.Drawing.Color.Green;
                lblLogoStatus.Text = "Company logo updated successfully!";
            }
            catch (Exception ex)
            {
                lblLogoStatus.ForeColor = System.Drawing.Color.Red;
                lblLogoStatus.Text = "Upload error: " + ex.Message;
            }
        }

        protected void btnRemoveLogo_Click(object sender, EventArgs e)
        {
            try
            {
                int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
                string folder = Server.MapPath("~/Uploads/ProfilePictures/");
                if (Directory.Exists(folder))
                {
                    var oldLogos = Directory.GetFiles(folder, $"Company_{companyId}.*");
                    foreach (var f in oldLogos)
                    {
                        try { File.Delete(f); } catch { }
                    }
                }

                try
                {
                    DBHelper.ExecuteNonQuery("UPDATE company_table SET profile_photo = NULL WHERE company_id = @cid",
                        new SqlParameter("@cid", companyId));
                }
                catch { }

                Session["CompanyProfilePhoto"] = null;
                CompanyLogoUrl = "";

                DBHelper.GetCompanyProfileStrength(companyId);

                lblLogoStatus.ForeColor = System.Drawing.Color.Green;
                lblLogoStatus.Text = "Company logo removed. Default logo restored.";
            }
            catch (Exception ex)
            {
                lblLogoStatus.ForeColor = System.Drawing.Color.Red;
                lblLogoStatus.Text = "Error removing logo: " + ex.Message;
            }
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

            string name = txtCompanyName.Text.Trim();
            string industry = ddlIndustry.SelectedValue;
            string size = ddlCompanySize.SelectedValue;
            string website = txtWebsite.Text.Trim();
            string address = txtLocation.Text.Trim();
            string email = txtContactEmail.Text.Trim();
            string desc = txtCompanyDesc.Text.Trim();

            try
            {
                string updateSql = @"
                    UPDATE company_table 
                    SET comp_name = @name,
                        industry = @ind,
                        employee_count = @size,
                        website = @web,
                        address = @addr,
                        email_add = @email,
                        description = @desc
                    WHERE company_id = @cid";

                int rows = DBHelper.ExecuteNonQuery(updateSql,
                    new SqlParameter("@name", name),
                    new SqlParameter("@ind", industry),
                    new SqlParameter("@size", size),
                    new SqlParameter("@web", website),
                    new SqlParameter("@addr", address),
                    new SqlParameter("@email", email),
                    new SqlParameter("@desc", desc),
                    new SqlParameter("@cid", companyId)
                );

                if (rows > 0)
                {
                    Session["UserName"] = name;
                    Session["CompanyName"] = name;
                    DBHelper.GetCompanyProfileStrength(companyId);
                    lblSettingsStatus.ForeColor = System.Drawing.Color.Green;
                    lblSettingsStatus.Text = "Company profile updated successfully!";
                    LoadTeamMembers(companyId);
                }
            }
            catch (Exception ex)
            {
                lblSettingsStatus.ForeColor = System.Drawing.Color.Red;
                lblSettingsStatus.Text = "Save error: " + ex.Message;
            }
        }

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "C";
            string[] parts = name.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }
    }
}
