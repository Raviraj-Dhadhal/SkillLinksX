using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public class CandidateEduDisplayItem
    {
        public string SchoolName { get; set; }
        public string DegreeName { get; set; }
        public string GradYear { get; set; }
        public string Cgpa { get; set; }
    }

    public class CandidateProjectDisplayItem
    {
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public List<string> TechTags { get; set; } = new List<string>();
        public string LinkUrl { get; set; }
    }

    public partial class CandidateProfile : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Candidate details bound to the layout
        // =========================================================================
        public string CandidateName { get; set; } = "Candidate";
        public string CandidatePhotoUrl { get; set; } = "";
        public string CandidateTitle { get; set; } = "Software Developer";
        public string CandidateEmail { get; set; } = "";
        public string CandidateCity { get; set; } = "India";
        public string CandidateCollege { get; set; } = "University / College";
        public string CandidateBio { get; set; } = "";
        public string CandidateExperience { get; set; } = "";
        public int CandidateMatchScore { get; set; } = 85;
        public int SkillsMatchPct { get; set; } = 88;
        public int ExperienceMatchPct { get; set; } = 80;
        public int EducationMatchPct { get; set; } = 90;
        public string TargetRoleName { get; set; } = "Software Engineer";
        public string PreferredRoles { get; set; } = "Software Developer";
        public string ExpectedSalary { get; set; } = "Competitive";
        public string NoticePeriod { get; set; } = "Immediate";
        public string WorkMode { get; set; } = "Hybrid / Remote";
        public bool HasResume { get; set; } = false;
        public int StudentId { get; set; } = 0;
        public int ApplicationId { get; set; } = 0;
        public string ApplicationStatus { get; set; } = "Applied";
        public string CandidateTeamNote { get; set; } = "";
        public string NoteAuthorName { get; set; } = "Hiring Team";
        public string NoteUpdatedAt { get; set; } = "";

        public List<CandidateEduDisplayItem> EducationList { get; set; } = new List<CandidateEduDisplayItem>();
        public List<CandidateProjectDisplayItem> ProjectsList { get; set; } = new List<CandidateProjectDisplayItem>();

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "C";
            var parts = name.Trim().Split(new[] { ' ', '.', '_' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Length >= 2 ? parts[0].Substring(0, 2).ToUpper() : parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int sid))
            {
                StudentId = sid;
            }
            else if (Request.QueryString["uid"] != null && int.TryParse(Request.QueryString["uid"], out int uid))
            {
                StudentId = uid;
            }

            if (Request.QueryString["app_id"] != null && int.TryParse(Request.QueryString["app_id"], out int aid))
            {
                ApplicationId = aid;
            }
            else if (Request.QueryString["aid"] != null && int.TryParse(Request.QueryString["aid"], out int aid2))
            {
                ApplicationId = aid2;
            }

            if (ApplicationId > 0 && StudentId <= 0)
            {
                try
                {
                    object uidObj = DBHelper.ExecuteScalar("SELECT user_id FROM applications WHERE application_id = @aid", new SqlParameter("@aid", ApplicationId));
                    if (uidObj != null && uidObj != DBNull.Value)
                    {
                        StudentId = Convert.ToInt32(uidObj);
                    }
                }
                catch { }
            }

            if (StudentId <= 0)
            {
                try
                {
                    int cid = CurrentCompanyId;
                    object topStudent = DBHelper.ExecuteScalar(@"
                        SELECT TOP 1 a.user_id 
                        FROM applications a 
                        INNER JOIN member_master_table m ON a.user_id = m.id
                        WHERE a.company_id = @cid OR EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = @cid)
                        ORDER BY a.applied_at DESC", new SqlParameter("@cid", cid));

                    if (topStudent != null && topStudent != DBNull.Value)
                    {
                        StudentId = Convert.ToInt32(topStudent);
                    }
                    else
                    {
                        object firstStudent = DBHelper.ExecuteScalar("SELECT TOP 1 id FROM member_master_table ORDER BY id ASC");
                        if (firstStudent != null && firstStudent != DBNull.Value)
                        {
                            StudentId = Convert.ToInt32(firstStudent);
                        }
                    }
                }
                catch { }
            }

            // Ensure Notes column in applications table
            EnsureNotesColumn();
        }

        private void EnsureNotesColumn()
        {
            try
            {
                DBHelper.ExecuteNonQuery(@"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'applications' AND COLUMN_NAME = 'notes')
                    BEGIN
                        ALTER TABLE applications ADD notes NVARCHAR(MAX) NULL;
                    END");
            }
            catch { }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            LoadCandidateProfile();
        }

        private int CurrentCompanyId => DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Candidate Profile from DB
        // Queries 'member_master_table', 'user_education', and 'projects'
        // =========================================================================
        private void LoadCandidateProfile()
        {
            int companyId = CurrentCompanyId;

            // 1. Fetch Company's Target Job / Internship Requirements
            string jobReqs = "C#, ASP.NET, SQL Server, Web API";
            try
            {
                if (ApplicationId > 0)
                {
                    string appJobSql = @"
                        SELECT ISNULL(j.job_title, i.internship_title) AS role_title,
                               ISNULL(j.requirements, i.skills_required) AS reqs,
                               a.status
                        FROM applications a
                        LEFT JOIN jobs j ON a.job_id = j.job_id
                        LEFT JOIN internships i ON a.internship_id = i.internship_id
                        WHERE a.application_id = @aid";
                    DataTable dtApp = DBHelper.ExecuteQuery(appJobSql, new SqlParameter("@aid", ApplicationId));
                    if (dtApp != null && dtApp.Rows.Count > 0)
                    {
                        if (dtApp.Rows[0]["role_title"] != DBNull.Value)
                            TargetRoleName = dtApp.Rows[0]["role_title"].ToString();
                        if (dtApp.Rows[0]["reqs"] != DBNull.Value)
                            jobReqs = dtApp.Rows[0]["reqs"].ToString();
                        if (dtApp.Rows[0]["status"] != DBNull.Value)
                            ApplicationStatus = dtApp.Rows[0]["status"].ToString().Trim();
                    }
                }
                else
                {
                    string jobSql = "SELECT TOP 1 job_title, requirements FROM jobs WHERE company_id = @cid AND status = 'Active' ORDER BY created_at DESC";
                    DataTable dtJob = DBHelper.ExecuteQuery(jobSql, new SqlParameter("@cid", companyId));
                    if (dtJob != null && dtJob.Rows.Count > 0)
                    {
                        TargetRoleName = dtJob.Rows[0]["job_title"].ToString();
                        if (dtJob.Rows[0]["requirements"] != DBNull.Value)
                        {
                            string r = dtJob.Rows[0]["requirements"].ToString().Trim();
                            if (!string.IsNullOrEmpty(r)) jobReqs = r;
                        }
                    }
                }
            }
            catch { }

            // 2. Fetch Candidate details from member_master_table
            string sql = @"
                SELECT full_name, email_add, city, state, clg_name, degree, grad_year, cgpa,
                       skills, tagline, about_text, resume_file, profile_photo, linkedin_url, github_url, portfolio_url
                FROM member_master_table
                WHERE id = @id";

            DataTable dt = null;
            try
            {
                dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", StudentId));
            }
            catch
            {
                dt = DBHelper.ExecuteQuery(@"
                    SELECT full_name, email_add, city, state, clg_name, degree, grad_year, cgpa,
                           skills, tagline, about_text, resume_file, linkedin_url, github_url, portfolio_url
                    FROM member_master_table
                    WHERE id = @id", new SqlParameter("@id", StudentId));
            }

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];

                string dbName = row["full_name"] != DBNull.Value ? row["full_name"].ToString().Trim() : "";
                CandidateEmail = row["email_add"] != DBNull.Value ? row["email_add"].ToString().Trim() : "";

                if ((string.IsNullOrEmpty(dbName) || dbName.Equals("Candidate", StringComparison.OrdinalIgnoreCase)) && !string.IsNullOrEmpty(CandidateEmail))
                {
                    string uname = CandidateEmail.Split('@')[0];
                    if (uname.Contains(".") || uname.Contains("_"))
                    {
                        var parts = uname.Split(new[] { '.', '_' }, StringSplitOptions.RemoveEmptyEntries)
                                         .Select(p => char.ToUpper(p[0]) + (p.Length > 1 ? p.Substring(1) : ""));
                        dbName = string.Join(" ", parts);
                    }
                    else if (uname.Length > 0)
                    {
                        dbName = char.ToUpper(uname[0]) + (uname.Length > 1 ? uname.Substring(1) : "");
                    }
                }
                CandidateName = !string.IsNullOrEmpty(dbName) ? dbName : "Candidate";

                // Candidate Photo URL
                if (row.Table.Columns.Contains("profile_photo") && row["profile_photo"] != DBNull.Value)
                {
                    string p = row["profile_photo"].ToString().Trim();
                    if (!string.IsNullOrEmpty(p)) CandidatePhotoUrl = p;
                    else CandidatePhotoUrl = "";
                }
                else
                {
                    CandidatePhotoUrl = "";
                }

                // Check physical file on disk if not set in DB
                if (string.IsNullOrEmpty(CandidatePhotoUrl))
                {
                    try
                    {
                        string picFolder = Server.MapPath("~/Uploads/ProfilePictures/");
                        if (Directory.Exists(picFolder))
                        {
                            var picFiles = Directory.GetFiles(picFolder, $"Profile_{StudentId}.*");
                            if (picFiles.Length > 0)
                            {
                                CandidatePhotoUrl = "~/Uploads/ProfilePictures/" + Path.GetFileName(picFiles[0]);
                            }
                        }
                    }
                    catch { }
                }

                string city = row["city"] != DBNull.Value ? row["city"].ToString().Trim() : "";
                string state = row["state"] != DBNull.Value ? row["state"].ToString().Trim() : "";
                CandidateCity = (!string.IsNullOrEmpty(city) && !string.IsNullOrEmpty(state)) ? $"{city}, {state}" : (!string.IsNullOrEmpty(city) ? city : "India");

                CandidateCollege = row["clg_name"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["clg_name"].ToString()) ? row["clg_name"].ToString().Trim() : "College Not Added";
                CandidateExperience = row["tagline"] != DBNull.Value ? row["tagline"].ToString().Trim() : "";
                CandidateBio = row["about_text"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["about_text"].ToString()) ? row["about_text"].ToString().Trim() : CandidateExperience;

                string rawSkills = row["skills"] != DBNull.Value ? row["skills"].ToString().Trim() : "";
                var skillsList = rawSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                          .Select(s => s.Trim())
                                          .Where(s => !string.IsNullOrEmpty(s))
                                          .ToList();

                if (skillsList.Count > 0)
                {
                    CandidateTitle = string.Join(" • ", skillsList.Take(3)) + " Developer";
                }
                else
                {
                    CandidateTitle = !string.IsNullOrEmpty(row["degree"].ToString()) ? row["degree"].ToString() + " Candidate" : "Software Developer";
                }

                // Bind Skills to matrix repeater
                rptCandidateSkills.DataSource = skillsList;
                rptCandidateSkills.DataBind();

                // Compute AI Match Score
                CandidateMatchScore = AIService.CalculateMatchScore(rawSkills, jobReqs);
                SkillsMatchPct = Math.Min(100, Math.Max(50, CandidateMatchScore + 4));
                ExperienceMatchPct = !string.IsNullOrEmpty(CandidateExperience) ? 85 : 60;
                EducationMatchPct = (!string.IsNullOrEmpty(row["degree"].ToString()) || !string.IsNullOrEmpty(row["clg_name"].ToString())) ? 92 : 65;

                // Determine Key Matching Skills and Missing Skills
                var jobTokens = jobReqs.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                       .Select(s => s.Trim())
                                       .Where(s => !string.IsNullOrEmpty(s))
                                       .ToList();

                var userTokens = new HashSet<string>(skillsList.Select(s => s.ToLower()));
                var matchingSkills = jobTokens.Where(s => userTokens.Contains(s.ToLower())).Take(4).ToList();
                if (matchingSkills.Count == 0 && skillsList.Count > 0) matchingSkills = skillsList.Take(3).ToList();

                var missingSkills = jobTokens.Where(s => !userTokens.Contains(s.ToLower())).Take(3).ToList();

                rptKeyMatchingSkills.DataSource = matchingSkills;
                rptKeyMatchingSkills.DataBind();

                rptMissingSkills.DataSource = missingSkills;
                rptMissingSkills.DataBind();

                // 3. Load Candidate Education
                LoadEducation(row);

                // 4. Load Current Application Status for this Company
                try
                {
                    string statSql = ApplicationId > 0 ?
                        "SELECT status FROM applications WHERE application_id = @aid" :
                        @"SELECT TOP 1 a.status 
                          FROM applications a
                          LEFT JOIN jobs j ON a.job_id = j.job_id
                          LEFT JOIN internships i ON a.internship_id = i.internship_id
                          WHERE a.user_id = @sid AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)
                          ORDER BY a.applied_at DESC";

                    SqlParameter[] prms = ApplicationId > 0 ?
                        new[] { new SqlParameter("@aid", ApplicationId) } :
                        new[] { new SqlParameter("@sid", StudentId), new SqlParameter("@cid", companyId) };

                    object statObj = DBHelper.ExecuteScalar(statSql, prms);
                    if (statObj != null && statObj != DBNull.Value)
                    {
                        ApplicationStatus = statObj.ToString().Trim();
                    }
                }
                catch { }

                // 5. Load Candidate Projects
                LoadProjects();

                // 6. Check if physical resume exists
                CheckResumeFile(row);

                // 7. Load Private Team Note
                LoadTeamNote(companyId);

                // 8. Set candidate preferences
                PreferredRoles = !string.IsNullOrEmpty(CandidateTitle) && !CandidateTitle.Equals("Candidate", StringComparison.OrdinalIgnoreCase) 
                                 ? CandidateTitle 
                                 : (!string.IsNullOrEmpty(TargetRoleName) ? TargetRoleName : "Software Developer");
                ExpectedSalary = "Competitive / Negotiable";
                NoticePeriod = "Immediate (Available)";
                WorkMode = "Flexible (Remote / Hybrid)";
            }
        }

        private void LoadTeamNote(int companyId)
        {
            try
            {
                string noteSql = @"
                    SELECT TOP 1 a.notes, a.updated_at
                    FROM applications a
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    WHERE a.user_id = @sid AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)
                    ORDER BY a.updated_at DESC";

                DataTable dtNote = DBHelper.ExecuteQuery(noteSql, new SqlParameter("@sid", StudentId), new SqlParameter("@cid", companyId));
                if (dtNote != null && dtNote.Rows.Count > 0 && dtNote.Rows[0]["notes"] != DBNull.Value)
                {
                    string noteText = dtNote.Rows[0]["notes"].ToString().Trim();
                    if (!string.IsNullOrEmpty(noteText))
                    {
                        CandidateTeamNote = noteText;
                        DateTime dtUp = dtNote.Rows[0]["updated_at"] != DBNull.Value ? Convert.ToDateTime(dtNote.Rows[0]["updated_at"]) : DateTime.Now;
                        NoteUpdatedAt = dtUp.ToString("MMM dd, yyyy - hh:mm tt");
                    }
                }
            }
            catch { }

            NoteAuthorName = Session["UserName"] != null ? Session["UserName"].ToString() : "Hiring Team";
        }

        private void LoadEducation(DataRow row)
        {
            EducationList.Clear();

            // Try loading from user_education table
            try
            {
                string eduSql = "SELECT college, degree, grad_year, cgpa FROM user_education WHERE user_id = @uid ORDER BY edu_id DESC";
                DataTable dtEdu = DBHelper.ExecuteQuery(eduSql, new SqlParameter("@uid", StudentId));
                if (dtEdu != null && dtEdu.Rows.Count > 0)
                {
                    foreach (DataRow er in dtEdu.Rows)
                    {
                        EducationList.Add(new CandidateEduDisplayItem
                        {
                            SchoolName = er["college"] != DBNull.Value ? er["college"].ToString() : "University",
                            DegreeName = er["degree"] != DBNull.Value ? er["degree"].ToString() : "Course",
                            GradYear = er["grad_year"] != DBNull.Value ? er["grad_year"].ToString() : "",
                            Cgpa = er["cgpa"] != DBNull.Value ? er["cgpa"].ToString() : ""
                        });
                    }
                }
            }
            catch { }

            // Fallback to member_master_table if none in user_education
            if (EducationList.Count == 0)
            {
                string clg = row["clg_name"] != DBNull.Value ? row["clg_name"].ToString() : "";
                string deg = row["degree"] != DBNull.Value ? row["degree"].ToString() : "";
                string yr = row["grad_year"] != DBNull.Value ? row["grad_year"].ToString() : "";
                string cgpa = row["cgpa"] != DBNull.Value ? row["cgpa"].ToString() : "";

                if (!string.IsNullOrEmpty(clg) || !string.IsNullOrEmpty(deg))
                {
                    EducationList.Add(new CandidateEduDisplayItem
                    {
                        SchoolName = !string.IsNullOrEmpty(clg) ? clg : "University Student",
                        DegreeName = !string.IsNullOrEmpty(deg) ? deg : "Degree Not Specified",
                        GradYear = yr,
                        Cgpa = cgpa
                    });
                }
            }

            rptCandidateEdu.DataSource = EducationList;
            rptCandidateEdu.DataBind();
        }

        private void LoadProjects()
        {
            ProjectsList.Clear();

            try
            {
                string pSql = "SELECT project_name, description, tech_stack, github_link, live_link FROM projects WHERE user_id = @uid ORDER BY created_at DESC";
                DataTable dtProjects = DBHelper.ExecuteQuery(pSql, new SqlParameter("@uid", StudentId));

                if (dtProjects != null && dtProjects.Rows.Count > 0)
                {
                    foreach (DataRow pr in dtProjects.Rows)
                    {
                        string stack = pr["tech_stack"] != DBNull.Value ? pr["tech_stack"].ToString() : "";
                        var tags = stack.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                        .Select(s => s.Trim())
                                        .Where(s => !string.IsNullOrEmpty(s))
                                        .ToList();

                        string link = pr["github_link"] != DBNull.Value && !string.IsNullOrEmpty(pr["github_link"].ToString()) 
                                      ? pr["github_link"].ToString() 
                                      : (pr["live_link"] != DBNull.Value ? pr["live_link"].ToString() : "");

                        ProjectsList.Add(new CandidateProjectDisplayItem
                        {
                            ProjectName = pr["project_name"] != DBNull.Value ? pr["project_name"].ToString() : "Project",
                            Description = pr["description"] != DBNull.Value ? pr["description"].ToString() : "",
                            TechTags = tags,
                            LinkUrl = link
                        });
                    }
                }
            }
            catch { }

            rptCandidateProjects.DataSource = ProjectsList;
            rptCandidateProjects.DataBind();
        }

        private void CheckResumeFile(DataRow row)
        {
            HasResume = false;

            if (row != null && row.Table.Columns.Contains("resume_file") && row["resume_file"] != DBNull.Value)
            {
                string rf = row["resume_file"].ToString().Trim();
                if (!string.IsNullOrEmpty(rf)) HasResume = true;
            }

            if (!HasResume)
            {
                try
                {
                    string folder = Server.MapPath("~/Uploads/Resumes/");
                    if (Directory.Exists(folder))
                    {
                        var files = Directory.GetFiles(folder, $"Resume_{StudentId}.*");
                        HasResume = files.Length > 0;
                    }
                }
                catch
                {
                    HasResume = false;
                }
            }
        }

        // =========================================================================
        // [RESUME STREAM HANDLER]: Streams the physical uploaded resume to the browser
        // =========================================================================
        protected void btnViewResume_Click(object sender, EventArgs e)
        {
            try
            {
                string folder = Server.MapPath("~/Uploads/Resumes/");
                if (!Directory.Exists(folder))
                {
                    lblActionStatus.ForeColor = System.Drawing.Color.Red;
                    lblActionStatus.Text = "Resume directory not found.";
                    return;
                }

                // Check member_master_table resume_file column first
                string resumePath = "";
                try
                {
                    object rfObj = DBHelper.ExecuteScalar("SELECT resume_file FROM member_master_table WHERE id = @id", new SqlParameter("@id", StudentId));
                    if (rfObj != null && rfObj != DBNull.Value && !string.IsNullOrEmpty(rfObj.ToString()))
                    {
                        string p = rfObj.ToString();
                        string localPath = Server.MapPath(p.StartsWith("~") ? p : "~/" + p.TrimStart('/'));
                        if (File.Exists(localPath)) resumePath = localPath;
                    }
                }
                catch { }

                if (string.IsNullOrEmpty(resumePath))
                {
                    var files = Directory.GetFiles(folder, $"Resume_{StudentId}.*");
                    if (files.Length > 0) resumePath = files[0];
                }

                if (!string.IsNullOrEmpty(resumePath) && File.Exists(resumePath))
                {
                    string fileName = Path.GetFileName(resumePath);
                    string ext = Path.GetExtension(resumePath).ToLower();

                    Response.Clear();
                    Response.ContentType = (ext == ".pdf") ? "application/pdf" : "application/octet-stream";
                    Response.AppendHeader("Content-Disposition", $"inline; filename={fileName}");
                    Response.TransmitFile(resumePath);
                    Response.End();
                }
                else
                {
                    lblActionStatus.ForeColor = System.Drawing.Color.Red;
                    lblActionStatus.Text = "Candidate has not uploaded a resume file yet.";
                }
            }
            catch (System.Threading.ThreadAbortException)
            {
                // Expected when Response.End() terminates stream
            }
            catch (Exception ex)
            {
                lblActionStatus.ForeColor = System.Drawing.Color.Red;
                lblActionStatus.Text = "Error opening resume: " + ex.Message;
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Shortlist Candidate
        // =========================================================================
        protected void btnShortlistCandidate_Click(object sender, EventArgs e)
        {
            int companyId = CurrentCompanyId;

            try
            {
                DBHelper.ExecuteNonQuery(@"
                    UPDATE a
                    SET a.status = 'Shortlisted', a.updated_at = GETDATE()
                    FROM applications a
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    WHERE a.user_id = @sid AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)",
                    new SqlParameter("@sid", StudentId),
                    new SqlParameter("@cid", companyId)
                );

                // Notify candidate
                DBHelper.SendNotification(StudentId, "Application Shortlisted 🚀", $"Your application for {TargetRoleName} has been shortlisted by the hiring team.", "~/User/Applications.aspx");

                lblActionStatus.ForeColor = System.Drawing.Color.Green;
                lblActionStatus.Text = "Candidate successfully marked as 'Shortlisted'!";
                ApplicationStatus = "Shortlisted";
            }
            catch (Exception ex)
            {
                lblActionStatus.ForeColor = System.Drawing.Color.Red;
                lblActionStatus.Text = "Error: " + ex.Message;
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Select / Hire Candidate
        // Adds candidate directly to Company Team (member)
        // =========================================================================
        protected void btnSelectCandidate_Click(object sender, EventArgs e)
        {
            int companyId = CurrentCompanyId;

            try
            {
                DBHelper.ExecuteNonQuery(@"
                    UPDATE a
                    SET a.status = 'Selected', a.company_id = @cid, a.updated_at = GETDATE()
                    FROM applications a
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    WHERE a.user_id = @sid AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)",
                    new SqlParameter("@sid", StudentId),
                    new SqlParameter("@cid", companyId)
                );

                DBHelper.SendNotification(StudentId, "Application Selected! 🎉", $"Congratulations! You have been Selected for {TargetRoleName} and welcomed to our company team.", "~/User/Applications.aspx");

                lblActionStatus.ForeColor = System.Drawing.Color.Green;
                lblActionStatus.Text = "Candidate successfully marked as 'Selected' and added to your Company Team!";
                ApplicationStatus = "Selected";
            }
            catch (Exception ex)
            {
                lblActionStatus.ForeColor = System.Drawing.Color.Red;
                lblActionStatus.Text = "Error: " + ex.Message;
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Reject Candidate
        // =========================================================================
        protected void btnRejectCandidate_Click(object sender, EventArgs e)
        {
            int companyId = CurrentCompanyId;

            try
            {
                DBHelper.ExecuteNonQuery(@"
                    UPDATE a
                    SET a.status = 'Rejected', a.updated_at = GETDATE()
                    FROM applications a
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    WHERE a.user_id = @sid AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)",
                    new SqlParameter("@sid", StudentId),
                    new SqlParameter("@cid", companyId)
                );

                DBHelper.SendNotification(StudentId, "Application Status Updated", $"Your application for {TargetRoleName} has been updated.", "~/User/Applications.aspx");

                lblActionStatus.ForeColor = System.Drawing.Color.DarkRed;
                lblActionStatus.Text = "Candidate application has been marked as 'Rejected'.";
                ApplicationStatus = "Rejected";
            }
            catch (Exception ex)
            {
                lblActionStatus.ForeColor = System.Drawing.Color.Red;
                lblActionStatus.Text = "Error: " + ex.Message;
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Save Private Team Note
        // =========================================================================
        protected void btnSaveNote_Click(object sender, EventArgs e)
        {
            int companyId = CurrentCompanyId;
            string newNote = txtCandidateNote.Text.Trim();
            if (string.IsNullOrEmpty(newNote)) return;

            try
            {
                DBHelper.ExecuteNonQuery(@"
                    UPDATE a
                    SET a.notes = @note, a.updated_at = GETDATE()
                    FROM applications a
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    WHERE a.user_id = @sid AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)",
                    new SqlParameter("@note", newNote),
                    new SqlParameter("@sid", StudentId),
                    new SqlParameter("@cid", companyId)
                );

                txtCandidateNote.Text = "";
                lblActionStatus.ForeColor = System.Drawing.Color.Green;
                lblActionStatus.Text = "Team note saved successfully!";
            }
            catch (Exception ex)
            {
                lblActionStatus.ForeColor = System.Drawing.Color.Red;
                lblActionStatus.Text = "Error saving note: " + ex.Message;
            }
        }
    }
}
