using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public class PortfolioProjectItem
    {
        public object ProjectId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public System.Collections.Generic.List<string> TechTags { get; set; }
        public string GithubLink { get; set; }
        public string LiveLink { get; set; }
    }

    public class PortfolioCertItem
    {
        public object CertId { get; set; }
        public string CertName { get; set; }
        public string IssuingOrg { get; set; }
        public string IssueDate { get; set; }
    }

    public partial class Portfolio : Page
    {
        public bool IsRavirajProfile { get; set; } = false;
        public string StudentFullName { get; set; } = "Student";
        public string StudentHeadline { get; set; } = "Aspiring Software Engineer";
        public string StudentLocation { get; set; } = "India";
        public string StudentCollege { get; set; } = "University Student";
        public string StudentDegree { get; set; } = "B.Tech Computer Engineering";
        public string StudentGradYear { get; set; } = "2024";
        public string StudentCgpa { get; set; } = "N/A";
        public string StudentAboutMe { get; set; } = "";
        public System.Collections.Generic.List<string> StudentSkillsList { get; set; } = new System.Collections.Generic.List<string>();
        public System.Collections.Generic.List<PortfolioProjectItem> UserProjectsList { get; set; } = new System.Collections.Generic.List<PortfolioProjectItem>();
        public System.Collections.Generic.List<PortfolioCertItem> UserCertsList { get; set; } = new System.Collections.Generic.List<PortfolioCertItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            int studentId = Convert.ToInt32(Session["UserId"]);
            EnsureCertificationsTable();
            LoadPortfolioProfile(studentId);
            LoadUserProjects(studentId);
            LoadUserCertifications(studentId);
        }

        private void EnsureCertificationsTable()
        {
            try
            {
                string createSql = @"
                    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'certifications')
                    BEGIN
                        CREATE TABLE dbo.certifications (
                            cert_id INT IDENTITY(1,1) PRIMARY KEY,
                            user_id INT NOT NULL,
                            cert_name NVARCHAR(200) NOT NULL,
                            issuing_org NVARCHAR(200) NULL,
                            issue_date NVARCHAR(50) NULL,
                            created_at DATETIME2(7) DEFAULT(GETDATE())
                        );
                    END";
                DBHelper.ExecuteNonQuery(createSql);
            }
            catch
            {
                // Safe ignore if permissions or already exists
            }
        }

        private void LoadPortfolioProfile(int studentId)
        {
            try
            {
                StudentSkillsList.Clear();
                string sql = "SELECT full_name, clg_name, city, state, degree, grad_year, cgpa, skills, about_text, tagline FROM member_master_table WHERE id = @id";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", studentId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    string name = r["full_name"] != DBNull.Value ? r["full_name"].ToString().Trim() : "Student";
                    StudentFullName = name;

                    // Only Raviraj Dhadhal gets the pre-built mock portfolio (Featured Projects, 845 views, etc.)
                    IsRavirajProfile = name.IndexOf("Raviraj", StringComparison.OrdinalIgnoreCase) >= 0;

                    string city = r["city"] != DBNull.Value ? r["city"].ToString().Trim() : "";
                    string state = r["state"] != DBNull.Value ? r["state"].ToString().Trim() : "";
                    StudentLocation = (!string.IsNullOrEmpty(city) && !string.IsNullOrEmpty(state)) ? $"{city}, {state}" : "India";

                    string clg = r["clg_name"] != DBNull.Value ? r["clg_name"].ToString().Trim() : "";
                    StudentCollege = !string.IsNullOrEmpty(clg) ? clg : (IsRavirajProfile ? "Gujarat Technological University" : "College Not Specified");

                    string degree = r["degree"] != DBNull.Value ? r["degree"].ToString().Trim() : "";
                    StudentDegree = !string.IsNullOrEmpty(degree) ? degree : (IsRavirajProfile ? "B.Tech Computer Engineering" : "Degree Not Specified");

                    string gy = r["grad_year"] != DBNull.Value ? r["grad_year"].ToString().Trim() : "";
                    StudentGradYear = !string.IsNullOrEmpty(gy) ? gy : (IsRavirajProfile ? "2021 - Present" : "Year N/A");

                    string cgpa = r["cgpa"] != DBNull.Value ? r["cgpa"].ToString().Trim() : "";
                    StudentCgpa = !string.IsNullOrEmpty(cgpa) ? cgpa : (IsRavirajProfile ? "8.8" : "N/A");

                    StudentHeadline = $"{StudentDegree} Student | Software Developer";

                    string bio = r["about_text"] != DBNull.Value ? r["about_text"].ToString().Trim() : "";
                    if (string.IsNullOrEmpty(bio) && r["tagline"] != DBNull.Value)
                        bio = r["tagline"].ToString().Trim();
                    StudentAboutMe = bio;

                    string skills = r["skills"] != DBNull.Value ? r["skills"].ToString().Trim() : "";
                    if (!string.IsNullOrEmpty(skills))
                    {
                        var parts = skills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var p in parts)
                        {
                            string item = p.Trim();
                            if (!string.IsNullOrEmpty(item))
                                StudentSkillsList.Add(item);
                        }
                    }
                }
            }
            catch
            {
                // Graceful fallback
            }
        }

        private void LoadUserProjects(int studentId)
        {
            try
            {
                UserProjectsList.Clear();
                string sql = "SELECT project_id, project_name, description, tech_stack, github_link, live_link FROM projects WHERE user_id = @uid ORDER BY created_at DESC";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", studentId));

                if (dt != null)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        string stack = r["tech_stack"] != DBNull.Value ? r["tech_stack"].ToString() : "";
                        var tags = new System.Collections.Generic.List<string>();
                        var rawTags = stack.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var t in rawTags)
                        {
                            string trimmed = t.Trim();
                            if (!string.IsNullOrEmpty(trimmed))
                                tags.Add(trimmed);
                        }

                        UserProjectsList.Add(new PortfolioProjectItem
                        {
                            ProjectId = r["project_id"],
                            Name = r["project_name"].ToString(),
                            Description = r["description"] != DBNull.Value ? r["description"].ToString() : "",
                            TechTags = tags,
                            GithubLink = r["github_link"] != DBNull.Value ? r["github_link"].ToString() : "",
                            LiveLink = r["live_link"] != DBNull.Value ? r["live_link"].ToString() : ""
                        });
                    }
                }
            }
            catch
            {
                // Graceful fallback
            }
        }

        // =========================================================================
        // [ADD PROJECT]: Inserts student project into 'projects' table
        // =========================================================================
        protected void btnSaveProject_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string title = txtProjectTitle.Text.Trim();
            string desc = txtProjectDesc.Text.Trim();
            string stack = txtProjectStack.Text.Trim();
            string github = txtProjectGithub.Text.Trim();
            string demo = txtProjectDemo.Text.Trim();

            if (string.IsNullOrEmpty(title))
            {
                lblProjectModalMsg.ForeColor = System.Drawing.Color.Red;
                lblProjectModalMsg.Text = "Please provide a project title.";
                return;
            }

            try
            {
                string insertSql = @"
                    INSERT INTO projects (user_id, project_name, description, tech_stack, github_link, live_link, created_at)
                    VALUES (@uid, @name, @desc, @stack, @github, @live, GETDATE())";

                int rows = DBHelper.ExecuteNonQuery(insertSql,
                    new SqlParameter("@uid", studentId),
                    new SqlParameter("@name", title),
                    new SqlParameter("@desc", (object)desc ?? DBNull.Value),
                    new SqlParameter("@stack", (object)stack ?? DBNull.Value),
                    new SqlParameter("@github", (object)github ?? DBNull.Value),
                    new SqlParameter("@live", (object)demo ?? DBNull.Value)
                );

                if (rows > 0)
                {
                    txtProjectTitle.Text = "";
                    txtProjectDesc.Text = "";
                    txtProjectStack.Text = "";
                    txtProjectGithub.Text = "";
                    txtProjectDemo.Text = "";

                    LoadUserProjects(studentId);
                    lblProjectStatus.ForeColor = System.Drawing.Color.Green;
                    lblProjectStatus.Text = "Project successfully added to your portfolio!";
                }
            }
            catch (Exception ex)
            {
                lblProjectModalMsg.ForeColor = System.Drawing.Color.Red;
                lblProjectModalMsg.Text = "Error adding project: " + ex.Message;
            }
        }

        private void LoadUserCertifications(int studentId)
        {
            try
            {
                UserCertsList.Clear();
                string sql = "SELECT cert_id, cert_name, issuing_org, issue_date FROM certifications WHERE user_id = @uid ORDER BY created_at DESC";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", studentId));

                if (dt != null)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        UserCertsList.Add(new PortfolioCertItem
                        {
                            CertId = r["cert_id"],
                            CertName = r["cert_name"].ToString(),
                            IssuingOrg = r["issuing_org"] != DBNull.Value ? r["issuing_org"].ToString() : "Organization",
                            IssueDate = r["issue_date"] != DBNull.Value ? r["issue_date"].ToString() : ""
                        });
                    }
                }
            }
            catch
            {
                // Graceful fallback
            }
        }

        // =========================================================================
        // [EDIT FULL PORTFOLIO]: Updates About Me, Skills, Education, CGPA in DB
        // =========================================================================
        protected void btnSavePortfolioEdit_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string about = txtEditAboutMe.Text.Trim();
            string skills = txtEditSkills.Text.Trim();
            string college = txtEditCollege.Text.Trim();
            string degree = txtEditDegree.Text.Trim();
            string gradYear = txtEditGradYear.Text.Trim();
            string cgpa = txtEditCgpa.Text.Trim();

            try
            {
                string sql = @"
                    UPDATE member_master_table
                    SET about_text = @about,
                        skills = @skills,
                        clg_name = @college,
                        degree = @degree,
                        grad_year = @gradYear,
                        cgpa = @cgpa
                    WHERE id = @id";

                DBHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@about", (object)about ?? DBNull.Value),
                    new SqlParameter("@skills", (object)skills ?? DBNull.Value),
                    new SqlParameter("@college", (object)college ?? DBNull.Value),
                    new SqlParameter("@degree", (object)degree ?? DBNull.Value),
                    new SqlParameter("@gradYear", (object)gradYear ?? DBNull.Value),
                    new SqlParameter("@cgpa", (object)cgpa ?? DBNull.Value),
                    new SqlParameter("@id", studentId));

                lblEditPortfolioMsg.ForeColor = System.Drawing.Color.Green;
                lblEditPortfolioMsg.Text = "Portfolio successfully updated!";
                LoadPortfolioProfile(studentId);
            }
            catch (Exception ex)
            {
                lblEditPortfolioMsg.ForeColor = System.Drawing.Color.Red;
                lblEditPortfolioMsg.Text = "Error updating portfolio: " + ex.Message;
            }
        }

        // =========================================================================
        // [ADD CERTIFICATION]: Inserts a certification into 'certifications' table
        // =========================================================================
        protected void btnSaveCert_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string certName = txtCertName.Text.Trim();
            string org = txtCertOrg.Text.Trim();
            string issueDate = txtCertDate.Text.Trim();

            if (string.IsNullOrEmpty(certName))
            {
                lblCertModalMsg.ForeColor = System.Drawing.Color.Red;
                lblCertModalMsg.Text = "Please enter certification name.";
                return;
            }

            try
            {
                string sql = @"
                    INSERT INTO certifications (user_id, cert_name, issuing_org, issue_date, created_at)
                    VALUES (@uid, @name, @org, @dt, GETDATE())";

                DBHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@uid", studentId),
                    new SqlParameter("@name", certName),
                    new SqlParameter("@org", (object)org ?? DBNull.Value),
                    new SqlParameter("@dt", (object)issueDate ?? DBNull.Value));

                txtCertName.Text = "";
                txtCertOrg.Text = "";
                txtCertDate.Text = "";

                lblCertStatus.ForeColor = System.Drawing.Color.Green;
                lblCertStatus.Text = "Certification added successfully!";
                LoadUserCertifications(studentId);
            }
            catch (Exception ex)
            {
                lblCertModalMsg.ForeColor = System.Drawing.Color.Red;
                lblCertModalMsg.Text = "Error adding certification: " + ex.Message;
            }
        }
        protected void btnDownloadPortfolioResume_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string folder = Server.MapPath("~/Uploads/Resumes/");
            if (Directory.Exists(folder))
            {
                var files = Directory.GetFiles(folder, $"Resume_{studentId}.*");
                if (files.Length > 0)
                {
                    string filePath = files[0];
                    string fileName = Path.GetFileName(filePath);

                    Response.Clear();
                    Response.ContentType = "application/octet-stream";
                    Response.AppendHeader("Content-Disposition", $"attachment; filename={fileName}");
                    Response.TransmitFile(filePath);
                    Response.End();
                    return;
                }
            }

            // Alert user if no resume was uploaded yet
            ClientScript.RegisterStartupScript(this.GetType(), "noResumeAlert", "alert('No resume uploaded yet! Please upload your resume from the Profile page first.');", true);
        }
    }
}
