using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Profile : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Dynamic profile values bound into Profile.aspx
        // =========================================================================
        public bool IsRavirajProfile { get; set; } = false;
        public string StudentName { get; set; } = "Student";
        public string StudentEmail { get; set; } = "";
        public string StudentCity { get; set; } = "India";
        public string ProfilePhotoUrl { get; set; } = "";
        public string StudentCollege { get; set; } = "";
        public string StudentDegree { get; set; } = "";
        public string StudentGradYear { get; set; } = "";
        public string StudentCgpa { get; set; } = "";
        public string StudentBio { get; set; } = "";
        public string StudentTagline { get; set; } = "";
        public string GitHubUrl { get; set; } = "";
        public string LinkedInUrl { get; set; } = "";
        public string PortfolioUrl { get; set; } = "";
        public string StudentExperience { get; set; } = "";
        public string PreferredRoles { get; set; } = "";
        public string PreferredLocations { get; set; } = "";
        public string PreferredWorkType { get; set; } = "";
        public string ExpectedSalary { get; set; } = "";
        public int ResumeScore { get; set; } = 0;
        public int ProfileStrengthPercent { get; set; } = 50;
        public string ProfileStrengthLevel { get; set; } = "Moderate";
        public string ProfileStrengthHint { get; set; } = "Add your bio (+5%), portfolio projects (+15%), and resume (+15%) to boost your profile strength.";
        public double StrengthDashOffset { get; set; } = 43.98;
        public bool HasEducation { get; set; } = false;
        public bool HasBio { get; set; } = false;
        public bool HasResume { get; set; } = false;
        public bool HasSkills { get; set; } = false;
        public List<PortfolioProjectItem> UserProjectsList { get; set; } = new List<PortfolioProjectItem>();
        public List<ProfileEducationItem> UserEducationList { get; set; } = new List<ProfileEducationItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            int studentId = Convert.ToInt32(Session["UserId"]);

            // If user selected a new resume file, process upload immediately
            if (IsPostBack && fileResumeUpload.HasFile)
            {
                HandleResumeUpload(studentId);
            }

            if (!IsPostBack)
            {
                LoadStudentProfile(studentId);
            }
        }

        // =========================================================================
        // [INLINE QUICK EDIT / ADD HANDLERS]: Save directly from Profile page to DB
        // =========================================================================
        protected void btnSaveInlineBio_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string bio = txtInlineBio.Text.Trim();

            try
            {
                string sql = "UPDATE member_master_table SET about_text = @bio WHERE id = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter("@bio", (object)bio ?? DBNull.Value), new SqlParameter("@id", studentId));
                lblInlineBioMsg.ForeColor = System.Drawing.Color.Green;
                lblInlineBioMsg.Text = "Bio updated successfully!";
            }
            catch (Exception ex)
            {
                lblInlineBioMsg.ForeColor = System.Drawing.Color.Red;
                lblInlineBioMsg.Text = "Error: " + ex.Message;
            }

            LoadStudentProfile(studentId);
        }

        protected void btnSaveInlineEdu_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string clg = txtInlineCollege.Text.Trim();
            string deg = txtInlineDegree.Text.Trim();
            string yr = txtInlineGradYear.Text.Trim();
            string cgpa = txtInlineCgpa.Text.Trim();

            if (string.IsNullOrEmpty(clg) && string.IsNullOrEmpty(deg))
            {
                lblInlineEduMsg.ForeColor = System.Drawing.Color.Red;
                lblInlineEduMsg.Text = "Please enter college or degree name.";
                return;
            }

            try
            {
                // Ensure user_education table exists
                string createSql = @"
                    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user_education')
                    BEGIN
                        CREATE TABLE user_education (
                            edu_id INT IDENTITY(1,1) PRIMARY KEY,
                            user_id INT NOT NULL,
                            college NVARCHAR(255) NOT NULL,
                            degree NVARCHAR(255) NOT NULL,
                            grad_year NVARCHAR(50),
                            cgpa NVARCHAR(50),
                            created_at DATETIME DEFAULT GETDATE()
                        )
                    END";
                DBHelper.ExecuteNonQuery(createSql);

                // Insert new education item (supports 1st, 2nd, 3rd college/school/master)
                string insertSql = @"
                    INSERT INTO user_education (user_id, college, degree, grad_year, cgpa)
                    VALUES (@uid, @clg, @deg, @yr, @cgpa)";

                DBHelper.ExecuteNonQuery(insertSql,
                    new SqlParameter("@uid", studentId),
                    new SqlParameter("@clg", (object)clg ?? DBNull.Value),
                    new SqlParameter("@deg", (object)deg ?? DBNull.Value),
                    new SqlParameter("@yr", (object)yr ?? DBNull.Value),
                    new SqlParameter("@cgpa", (object)cgpa ?? DBNull.Value));

                // Also update member_master_table for general compatibility
                string sql = @"
                    UPDATE member_master_table 
                    SET clg_name = @clg, degree = @deg, grad_year = @yr, cgpa = @cgpa 
                    WHERE id = @id";

                DBHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@clg", (object)clg ?? DBNull.Value),
                    new SqlParameter("@deg", (object)deg ?? DBNull.Value),
                    new SqlParameter("@yr", (object)yr ?? DBNull.Value),
                    new SqlParameter("@cgpa", (object)cgpa ?? DBNull.Value),
                    new SqlParameter("@id", studentId));

                lblInlineEduMsg.ForeColor = System.Drawing.Color.Green;
                lblInlineEduMsg.Text = "Education added successfully!";

                // Clear input fields for next entry
                txtInlineCollege.Text = string.Empty;
                txtInlineDegree.Text = string.Empty;
                txtInlineGradYear.Text = string.Empty;
                txtInlineCgpa.Text = string.Empty;
            }
            catch (Exception ex)
            {
                lblInlineEduMsg.ForeColor = System.Drawing.Color.Red;
                lblInlineEduMsg.Text = "Error: " + ex.Message;
            }

            LoadStudentProfile(studentId);
        }

        protected void btnSaveInlineSkills_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string skills = txtInlineSkills.Text.Trim();

            try
            {
                string sql = "UPDATE member_master_table SET skills = @sk WHERE id = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter("@sk", (object)skills ?? DBNull.Value), new SqlParameter("@id", studentId));
                lblInlineSkillsMsg.ForeColor = System.Drawing.Color.Green;
                lblInlineSkillsMsg.Text = "Skills updated successfully!";
            }
            catch (Exception ex)
            {
                lblInlineSkillsMsg.ForeColor = System.Drawing.Color.Red;
                lblInlineSkillsMsg.Text = "Error: " + ex.Message;
            }

            LoadStudentProfile(studentId);
        }

        protected void btnSaveInlineExp_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string exp = txtInlineExp.Text.Trim();

            try
            {
                // Experience is saved directly to tagline or about_text if dedicated column not present
                string sql = "UPDATE member_master_table SET tagline = @exp WHERE id = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter("@exp", (object)exp ?? DBNull.Value), new SqlParameter("@id", studentId));
                lblInlineExpMsg.ForeColor = System.Drawing.Color.Green;
                lblInlineExpMsg.Text = "Experience updated successfully!";
            }
            catch (Exception ex)
            {
                lblInlineExpMsg.ForeColor = System.Drawing.Color.Red;
                lblInlineExpMsg.Text = "Error: " + ex.Message;
            }

            LoadStudentProfile(studentId);
        }

        protected void btnSaveInlineLinks_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string gh = txtInlineGithub.Text.Trim();
            string li = txtInlineLinkedIn.Text.Trim();
            string pf = txtInlinePortfolio.Text.Trim();

            try
            {
                string sql = "UPDATE member_master_table SET github_url = @gh, linkedin_url = @li, portfolio_url = @pf WHERE id = @id";
                DBHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@gh", (object)gh ?? DBNull.Value),
                    new SqlParameter("@li", (object)li ?? DBNull.Value),
                    new SqlParameter("@pf", (object)pf ?? DBNull.Value),
                    new SqlParameter("@id", studentId));

                lblInlineLinksMsg.ForeColor = System.Drawing.Color.Green;
                lblInlineLinksMsg.Text = "Links updated successfully!";
            }
            catch (Exception ex)
            {
                lblInlineLinksMsg.ForeColor = System.Drawing.Color.Red;
                lblInlineLinksMsg.Text = "Error: " + ex.Message;
            }

            LoadStudentProfile(studentId);
        }

        protected void btnSaveInlinePref_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string roles = txtInlineRoles.Text.Trim();
            string locs = txtInlineLocations.Text.Trim();
            string wtype = txtInlineWorkType.Text.Trim();
            string salary = txtInlineSalary.Text.Trim();

            // Store in Session (no dedicated DB columns for career prefs)
            Session["PrefRoles"] = roles;
            Session["PrefLocations"] = locs;
            Session["PrefWorkType"] = wtype;
            Session["PrefSalary"] = salary;

            lblInlinePrefMsg.ForeColor = System.Drawing.Color.Green;
            lblInlinePrefMsg.Text = "Career preferences saved!";

            LoadStudentProfile(studentId);
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Student Profile Details
        // Queries 'member_master_table' for student info and skill pills
        // =========================================================================
        private void LoadStudentProfile(int studentId)
        {
            try
            {
                string sql = @"
                    SELECT full_name, email_add, city, state, clg_name, grad_year, skills, 
                           degree, cgpa, tagline, about_text, resume_file, profile_photo,
                           linkedin_url, github_url, portfolio_url
                    FROM member_master_table
                    WHERE id = @id";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", studentId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    StudentName = r["full_name"] != DBNull.Value ? r["full_name"].ToString().Trim() : "Student";
                    IsRavirajProfile = StudentName.IndexOf("Raviraj", StringComparison.OrdinalIgnoreCase) >= 0;

                    if (r.Table.Columns.Contains("profile_photo") && r["profile_photo"] != DBNull.Value)
                    {
                        string p = r["profile_photo"].ToString().Trim();
                        if (!string.IsNullOrEmpty(p)) ProfilePhotoUrl = p;
                    }
                    else if (Session["UserProfilePhoto"] != null)
                    {
                        ProfilePhotoUrl = Session["UserProfilePhoto"].ToString();
                    }

                    StudentEmail = r["email_add"] != DBNull.Value ? r["email_add"].ToString().Trim() : "";

                    string city = r["city"] != DBNull.Value ? r["city"].ToString().Trim() : "";
                    string state = r["state"] != DBNull.Value ? r["state"].ToString().Trim() : "";
                    StudentCity = (!string.IsNullOrEmpty(city) && !string.IsNullOrEmpty(state)) ? $"{city}, {state}" : (!string.IsNullOrEmpty(city) ? city : "India");

                    StudentCollege = r["clg_name"] != DBNull.Value ? r["clg_name"].ToString().Trim() : "";
                    StudentDegree = r["degree"] != DBNull.Value ? r["degree"].ToString().Trim() : "";
                    StudentGradYear = r["grad_year"] != DBNull.Value ? r["grad_year"].ToString().Trim() : "";
                    StudentCgpa = r["cgpa"] != DBNull.Value ? r["cgpa"].ToString().Trim() : "";

                    HasEducation = !string.IsNullOrEmpty(StudentCollege) || !string.IsNullOrEmpty(StudentDegree);

                    StudentTagline = r["tagline"] != DBNull.Value ? r["tagline"].ToString().Trim() : "";
                    StudentExperience = StudentTagline; // Experience stored in tagline column
                    StudentBio = r["about_text"] != DBNull.Value ? r["about_text"].ToString().Trim() : "";

                    HasBio = !string.IsNullOrEmpty(StudentBio);

                    // Load Career Preferences from Session (no dedicated DB columns)
                    if (Session["PrefRoles"] != null) PreferredRoles = Session["PrefRoles"].ToString();
                    if (Session["PrefLocations"] != null) PreferredLocations = Session["PrefLocations"].ToString();
                    if (Session["PrefWorkType"] != null) PreferredWorkType = Session["PrefWorkType"].ToString();
                    if (Session["PrefSalary"] != null) ExpectedSalary = Session["PrefSalary"].ToString();

                    GitHubUrl = r["github_url"] != DBNull.Value ? r["github_url"].ToString().Trim() : "";
                    LinkedInUrl = r["linkedin_url"] != DBNull.Value ? r["linkedin_url"].ToString().Trim() : "";
                    PortfolioUrl = r["portfolio_url"] != DBNull.Value ? r["portfolio_url"].ToString().Trim() : "";

                    string rawSkills = r["skills"] != DBNull.Value ? r["skills"].ToString().Trim() : "";
                    var skillsList = rawSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                             .Select(s => s.Trim())
                                             .Where(s => !string.IsNullOrEmpty(s))
                                             .ToList();

                    HasSkills = skillsList.Count > 0;
                    rptProfileSkills.DataSource = skillsList.Take(3).ToList();
                    rptProfileSkills.DataBind();

                    // Load User Education History (supports multiple schools/degrees/masters)
                    LoadUserEducation(studentId);

                    // Pre-fill inline modal controls
                    txtInlineBio.Text = StudentBio;
                    txtInlineCollege.Text = StudentCollege;
                    txtInlineDegree.Text = StudentDegree;
                    txtInlineGradYear.Text = StudentGradYear;
                    txtInlineCgpa.Text = StudentCgpa;
                    txtInlineSkills.Text = rawSkills;
                    txtInlineExp.Text = StudentExperience;
                    txtInlineGithub.Text = GitHubUrl;
                    txtInlineLinkedIn.Text = LinkedInUrl;
                    txtInlinePortfolio.Text = PortfolioUrl;
                    txtInlineRoles.Text = PreferredRoles;
                    txtInlineLocations.Text = PreferredLocations;
                    txtInlineWorkType.Text = PreferredWorkType;
                    txtInlineSalary.Text = ExpectedSalary;

                    // 1. Check existing resume & calculate ResumeScore
                    CheckExistingResume(studentId);

                    // 2. Load Real Projects from projects table
                    LoadUserProjects(studentId);

                    // 3. Check for Portfolio / Projects presence
                    bool hasProjects = UserProjectsList != null && UserProjectsList.Count > 0;
                    bool hasPortfolio = hasProjects || !string.IsNullOrEmpty(PortfolioUrl);

                    // 4. Check for Certifications
                    bool hasCerts = false;
                    try
                    {
                        object cCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM certifications WHERE user_id = @uid", new SqlParameter("@uid", studentId));
                        if (cCount != null && Convert.ToInt32(cCount) > 0)
                            hasCerts = true;
                    }
                    catch { }

                    // =====================================================================
                    // [DYNAMIC PROFILE STRENGTH CALCULATION]:
                    // Base for newly registered profile = 50%
                    // + Bio written: +5%
                    // + Portfolio / Projects added: +15%
                    // + Valid Resume uploaded: +15%
                    // + Experience / Internships added: +10%
                    // + Certifications or Social Links added: +5%
                    // Total Max = 50 + 5 + 15 + 15 + 10 + 5 = 100%
                    // =====================================================================
                    int strength = 50; // Base score for a newly generated profile

                    if (HasBio && StudentBio.Length > 10)
                    {
                        strength += 5; // Bio adds +5%
                    }

                    if (hasPortfolio)
                    {
                        strength += 15; // Portfolio projects or link adds +15%
                    }

                    if (HasResume && ResumeScore >= 30)
                    {
                        strength += 15; // Valid resume adds +15%
                    }

                    if (!string.IsNullOrEmpty(StudentExperience))
                    {
                        strength += 10; // Experience adds +10%
                    }

                    if (hasCerts || !string.IsNullOrEmpty(GitHubUrl) || !string.IsNullOrEmpty(LinkedInUrl))
                    {
                        strength += 5; // Certifications or Links adds +5%
                    }

                    ProfileStrengthPercent = Math.Min(100, Math.Max(50, strength));

                    // SVG stroke-dashoffset: circumference is ~87.96 (2 * PI * 14)
                    // offset = circumference - (circumference * percent / 100)
                    StrengthDashOffset = 87.96 - (87.96 * ProfileStrengthPercent / 100.0);

                    if (ProfileStrengthPercent >= 85)
                    {
                        ProfileStrengthLevel = "Strong";
                        ProfileStrengthHint = "Great job! Your profile stands out to recruiters.";
                    }
                    else if (ProfileStrengthPercent >= 65)
                    {
                        ProfileStrengthLevel = "Good";
                        ProfileStrengthHint = "Almost there! Add your resume or experience to reach Strong.";
                    }
                    else
                    {
                        ProfileStrengthLevel = "Moderate";
                        ProfileStrengthHint = "Add your bio (+5%), portfolio projects (+15%), and resume (+15%) to boost your profile strength.";
                    }

                    // Sync to database
                    try
                    {
                        DBHelper.ExecuteNonQuery("UPDATE member_master_table SET profile_strength = @str WHERE id = @id",
                            new SqlParameter("@str", ProfileStrengthPercent),
                            new SqlParameter("@id", studentId));
                    }
                    catch { }
                }
            }
            catch
            {
                // Graceful fallback
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Load User Education History (supports multiple degrees/schools)
        // =========================================================================
        private void LoadUserEducation(int studentId)
        {
            try
            {
                UserEducationList.Clear();

                string createSql = @"
                    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user_education')
                    BEGIN
                        CREATE TABLE user_education (
                            edu_id INT IDENTITY(1,1) PRIMARY KEY,
                            user_id INT NOT NULL,
                            college NVARCHAR(255) NOT NULL,
                            degree NVARCHAR(255) NOT NULL,
                            grad_year NVARCHAR(50),
                            cgpa NVARCHAR(50),
                            created_at DATETIME DEFAULT GETDATE()
                        )
                    END";
                DBHelper.ExecuteNonQuery(createSql);

                string sql = "SELECT edu_id, college, degree, grad_year, cgpa FROM user_education WHERE user_id = @uid ORDER BY edu_id ASC";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", studentId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        UserEducationList.Add(new ProfileEducationItem
                        {
                            EduId = Convert.ToInt32(r["edu_id"]),
                            College = r["college"] != DBNull.Value ? r["college"].ToString().Trim() : "",
                            Degree = r["degree"] != DBNull.Value ? r["degree"].ToString().Trim() : "",
                            GradYear = r["grad_year"] != DBNull.Value ? r["grad_year"].ToString().Trim() : "",
                            Cgpa = r["cgpa"] != DBNull.Value ? r["cgpa"].ToString().Trim() : ""
                        });
                    }
                }
                else if (HasEducation)
                {
                    // First time: migrate from member_master_table
                    string insertSeed = @"
                        INSERT INTO user_education (user_id, college, degree, grad_year, cgpa)
                        VALUES (@uid, @clg, @deg, @yr, @cgpa)";
                    DBHelper.ExecuteNonQuery(insertSeed,
                        new SqlParameter("@uid", studentId),
                        new SqlParameter("@clg", (object)StudentCollege ?? DBNull.Value),
                        new SqlParameter("@deg", (object)StudentDegree ?? DBNull.Value),
                        new SqlParameter("@yr", (object)StudentGradYear ?? DBNull.Value),
                        new SqlParameter("@cgpa", (object)StudentCgpa ?? DBNull.Value));

                    UserEducationList.Add(new ProfileEducationItem
                    {
                        EduId = 1,
                        College = StudentCollege,
                        Degree = StudentDegree,
                        GradYear = StudentGradYear,
                        Cgpa = StudentCgpa
                    });
                }

                HasEducation = UserEducationList.Count > 0;
                if (rptProfileEducation != null)
                {
                    rptProfileEducation.DataSource = UserEducationList;
                    rptProfileEducation.DataBind();
                }
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Load User Projects for Profile Display
        // =========================================================================
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
                            Name = r["project_name"] != DBNull.Value ? r["project_name"].ToString() : "",
                            Description = r["description"] != DBNull.Value ? r["description"].ToString() : "",
                            TechTags = tags,
                            GithubLink = r["github_link"] != DBNull.Value ? r["github_link"].ToString() : "",
                            LiveLink = r["live_link"] != DBNull.Value ? r["live_link"].ToString() : ""
                        });
                    }
                }

                rptProfileProjects.DataSource = UserProjectsList;
                rptProfileProjects.DataBind();
            }
            catch
            {
                // Graceful fallback
            }
        }

        // =========================================================================
        // [FILE SYSTEM & RESUME CHECK]: Inspects if user already has an uploaded resume
        // =========================================================================
        private void CheckExistingResume(int studentId)
        {
            try
            {
                string folder = Server.MapPath("~/Uploads/Resumes/");
                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                // Search for existing resume matching student ID (e.g., Resume_1.pdf or Resume_1.docx)
                var files = Directory.GetFiles(folder, $"Resume_{studentId}.*");
                if (files.Length > 0)
                {
                    HasResume = true;
                    FileInfo fi = new FileInfo(files[0]);
                    litResumeFileName.Text = fi.Name;
                    litResumeFileMeta.Text = $"Uploaded on {fi.LastWriteTime:dd MMM yyyy} &bull; {(fi.Length / 1024.0):F1} KB";

                    // Dynamic Resume Scoring:
                    // Check if file has readable text or is a blank sheet
                    bool hasReadableText = false;
                    try
                    {
                        byte[] fileBytes = File.ReadAllBytes(files[0]);
                        string ext = fi.Extension.ToLower();
                        if (ext == ".pdf")
                        {
                            string raw = System.Text.Encoding.ASCII.GetString(fileBytes);
                            hasReadableText = System.Text.RegularExpressions.Regex.IsMatch(raw, @"\b(skills?|education|experience|project|developer|engineer|university|college|asp\.net|c#|sql|react|javascript)\b", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                        }
                        else
                        {
                            hasReadableText = fileBytes.Length > 2048;
                        }
                    }
                    catch { }

                    if (!hasReadableText)
                    {
                        ResumeScore = 15; // Low/minimal score for blank document / empty paper
                    }
                    else
                    {
                        // Real resume with actual content
                        int dynamicScore = 50;
                        if (HasSkills) dynamicScore += 20;
                        if (HasEducation) dynamicScore += 15;
                        if (HasBio) dynamicScore += 10;
                        ResumeScore = Math.Min(95, dynamicScore);
                    }
                }
                else
                {
                    HasResume = false;
                    ResumeScore = 0;
                    litResumeFileName.Text = "No resume uploaded yet";
                    litResumeFileMeta.Text = "Upload PDF or DOCX (Max 5MB)";
                }
            }
            catch
            {
                // Silent catch
            }
        }

        // =========================================================================
        // [FILE UPLOAD HANDLER]: Saves uploaded resume to ~/Uploads/Resumes/
        // =========================================================================
        private void HandleResumeUpload(int studentId)
        {
            lblResumeStatus.Text = "";
            string ext = Path.GetExtension(fileResumeUpload.FileName).ToLower();

            // Validate file extension
            if (ext != ".pdf" && ext != ".docx")
            {
                lblResumeStatus.ForeColor = System.Drawing.Color.Red;
                lblResumeStatus.Text = "Invalid format! Only .pdf and .docx documents are accepted.";
                return;
            }

            // Validate file size limit (5MB)
            if (fileResumeUpload.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                lblResumeStatus.ForeColor = System.Drawing.Color.Red;
                lblResumeStatus.Text = "File size exceeds 5MB limit.";
                return;
            }

            try
            {
                string folder = Server.MapPath("~/Uploads/Resumes/");
                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                // Delete older version if exists to prevent duplicates
                var oldFiles = Directory.GetFiles(folder, $"Resume_{studentId}.*");
                foreach (var old in oldFiles)
                {
                    try { File.Delete(old); } catch { }
                }

                // Save new resume file with standardized name
                string newFileName = $"Resume_{studentId}{ext}";
                string savePath = Path.Combine(folder, newFileName);
                fileResumeUpload.SaveAs(savePath);

                lblResumeStatus.ForeColor = System.Drawing.Color.Green;
                lblResumeStatus.Text = "Resume uploaded successfully!";

                // Refresh UI metadata
                CheckExistingResume(studentId);
            }
            catch (Exception ex)
            {
                lblResumeStatus.ForeColor = System.Drawing.Color.Red;
                lblResumeStatus.Text = "Upload error: " + ex.Message;
            }
        }

        // =========================================================================
        // [RESUME DOWNLOAD HANDLER]: Streams the physical file to browser
        // =========================================================================
        protected void btnDownloadResume_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string folder = Server.MapPath("~/Uploads/Resumes/");
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
            }
            else
            {
                lblResumeStatus.ForeColor = System.Drawing.Color.OrangeRed;
                lblResumeStatus.Text = "No resume uploaded yet to download.";
            }
        }
    }

    public class ProfileEducationItem
    {
        public int EduId { get; set; }
        public string College { get; set; }
        public string Degree { get; set; }
        public string GradYear { get; set; }
        public string Cgpa { get; set; }
    }
}
