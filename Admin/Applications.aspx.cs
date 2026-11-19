using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Applications : Page
    {
        public bool HasSelectedApp { get; set; } = false;
        public string SelectedStudentName { get; set; } = "";
        public string SelectedAppliedRole { get; set; } = "";
        public string SelectedCompanyName { get; set; } = "";
        public int SelectedMatchPct { get; set; } = 80;
        public int SelectedExpPct { get; set; } = 85;
        public string SelectedEducation { get; set; } = "B.Tech Computer Science";
        public string SelectedCollege { get; set; } = "Engineering College";
        public string SelectedTimelineStatus { get; set; } = "Under Review";
        public string SelectedProfilePhoto { get; set; } = "";
        public int SelectedUserId { get; set; } = 0;
        public List<string> SelectedSkills { get; set; } = new List<string>();

        // Dynamic Application Funnel metrics
        public string FunnelAppliedCount { get; set; } = "0";
        public string FunnelAppliedPct { get; set; } = "100%";
        public string FunnelUnderReviewCount { get; set; } = "0";
        public string FunnelUnderReviewPct { get; set; } = "0%";
        public string FunnelShortlistedCount { get; set; } = "0";
        public string FunnelShortlistedPct { get; set; } = "0%";
        public string FunnelInterviewCount { get; set; } = "0";
        public string FunnelInterviewPct { get; set; } = "0%";
        public string FunnelSelectedCount { get; set; } = "0";
        public string FunnelSelectedPct { get; set; } = "0%";
        public string FunnelRejectedCount { get; set; } = "0";
        public string FunnelRejectedPct { get; set; } = "0%";

        public List<string> CompanyFilterList { get; set; } = new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin authorization
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            // Direct Resume Download
            if (Request.QueryString["download_resume"] != null && int.TryParse(Request.QueryString["uid"], out int resumeUid))
            {
                DownloadStudentResume(resumeUid);
                return;
            }

            if (!IsPostBack)
            {
                LoadFilterData();
                LoadApplicationMetrics();
                LoadApplicationsTable();
            }
        }

        // =========================================================================
        // Load dynamically registered companies for the filter dropdown
        // =========================================================================
        private void LoadFilterData()
        {
            try
            {
                CompanyFilterList = new List<string>();
                string sql = "SELECT DISTINCT comp_name FROM company_table WHERE comp_name IS NOT NULL AND comp_name <> '' ORDER BY comp_name ASC";
                DataTable dt = DBHelper.ExecuteQuery(sql);
                foreach (DataRow r in dt.Rows)
                {
                    CompanyFilterList.Add(r["comp_name"].ToString());
                }
            }
            catch
            {
                CompanyFilterList = new List<string>();
            }
        }

        // =========================================================================
        // [DATABASE CONNECTIVITY & ADO.NET]: Load Platform-wide Application Metrics & Funnel
        // Aggregates application records by status from 'applications' table
        // =========================================================================
        private void LoadApplicationMetrics()
        {
            try
            {
                string sql = @"
                    SELECT 
                        COUNT(*) AS TotalApps,
                        SUM(CASE WHEN status = 'Applied' THEN 1 ELSE 0 END) AS NewApps,
                        SUM(CASE WHEN status = 'Under Review' THEN 1 ELSE 0 END) AS UnderReview,
                        SUM(CASE WHEN status = 'Shortlisted' THEN 1 ELSE 0 END) AS Shortlisted,
                        SUM(CASE WHEN status LIKE 'Interview%' THEN 1 ELSE 0 END) AS Interviews,
                        SUM(CASE WHEN status IN ('Selected', 'Hired') THEN 1 ELSE 0 END) AS Hired,
                        SUM(CASE WHEN status = 'Rejected' THEN 1 ELSE 0 END) AS Rejected,
                        SUM(CASE WHEN applied_at >= DATEADD(day, -30, GETDATE()) THEN 1 ELSE 0 END) AS RecentMonth
                    FROM applications";

                DataTable dt = DBHelper.ExecuteQuery(sql);

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    int total = r["TotalApps"] != DBNull.Value ? Convert.ToInt32(r["TotalApps"]) : 0;
                    int newApps = r["NewApps"] != DBNull.Value ? Convert.ToInt32(r["NewApps"]) : 0;
                    int underReview = r["UnderReview"] != DBNull.Value ? Convert.ToInt32(r["UnderReview"]) : 0;
                    int shortlisted = r["Shortlisted"] != DBNull.Value ? Convert.ToInt32(r["Shortlisted"]) : 0;
                    int interviews = r["Interviews"] != DBNull.Value ? Convert.ToInt32(r["Interviews"]) : 0;
                    int hired = r["Hired"] != DBNull.Value ? Convert.ToInt32(r["Hired"]) : 0;
                    int rejected = r["Rejected"] != DBNull.Value ? Convert.ToInt32(r["Rejected"]) : 0;
                    int recent = r["RecentMonth"] != DBNull.Value ? Convert.ToInt32(r["RecentMonth"]) : 0;

                    litTotalApps.Text = total.ToString("N0");
                    litNewApps.Text = newApps.ToString("N0");
                    litUnderReview.Text = underReview.ToString("N0");
                    litShortlisted.Text = shortlisted.ToString("N0");
                    litInterviews.Text = interviews.ToString("N0");
                    litHired.Text = hired.ToString("N0");

                    if (litAppTrend != null)
                    {
                        if (recent > 0)
                        {
                            litAppTrend.Text = $"<span class=\"stat-trend-green\"><i class=\"fa-solid fa-arrow-up\"></i> +{recent} this month</span>";
                        }
                        else
                        {
                            litAppTrend.Text = "<span class=\"stat-trend-green\"><i class=\"fa-solid fa-check\"></i> Live</span>";
                        }
                    }

                    // Dynamic Application Funnel
                    FunnelAppliedCount = FormatCount(total);
                    FunnelAppliedPct = total > 0 ? "100%" : "0%";

                    FunnelUnderReviewCount = FormatCount(underReview);
                    FunnelUnderReviewPct = FormatPct(underReview, total);

                    FunnelShortlistedCount = FormatCount(shortlisted);
                    FunnelShortlistedPct = FormatPct(shortlisted, total);

                    FunnelInterviewCount = FormatCount(interviews);
                    FunnelInterviewPct = FormatPct(interviews, total);

                    FunnelSelectedCount = FormatCount(hired);
                    FunnelSelectedPct = FormatPct(hired, total);

                    FunnelRejectedCount = FormatCount(rejected);
                    FunnelRejectedPct = FormatPct(rejected, total);
                }
            }
            catch
            {
                litTotalApps.Text = "0";
                litNewApps.Text = "0";
                litUnderReview.Text = "0";
                litShortlisted.Text = "0";
                litInterviews.Text = "0";
                litHired.Text = "0";
            }
        }

        private string FormatCount(int count)
        {
            if (count >= 10000)
                return (count / 1000.0).ToString("0.#") + "k";
            if (count >= 1000)
                return (count / 1000.0).ToString("0.#") + "k";
            return count.ToString("N0");
        }

        private string FormatPct(int part, int total)
        {
            if (total <= 0) return "0%";
            double pct = ((double)part / total) * 100.0;
            if (pct == 0) return "0%";
            if (pct < 1) return pct.ToString("0.1") + "%";
            return Math.Round(pct, 0).ToString("0") + "%";
        }

        // =========================================================================
        // [DATABASE QUERY]: Load all student applications into Repeater
        // =========================================================================
        private void LoadApplicationsTable()
        {
            try
            {
                string sql = @"
                    SELECT a.application_id, a.user_id, a.status, a.applied_at,
                           m.full_name AS StudentName, m.email_add AS StudentEmail,
                           m.clg_name AS College, m.degree AS Degree, m.skills AS StudentSkills,
                           m.profile_photo AS ProfilePhoto,
                           COALESCE(j.job_title, i.internship_title, 'Opportunity') AS OpportunityTitle,
                           COALESCE(j.location, i.location_type, 'India') AS Location,
                           CASE WHEN a.job_id IS NOT NULL THEN 'Job' ELSE 'Internship' END AS OppType,
                           COALESCE(cj.comp_name, ci.comp_name, 'Hiring Organization') AS CompanyName,
                           COALESCE(j.requirements, i.skills_required, '') AS RequiredSkills
                    FROM applications a
                    INNER JOIN member_master_table m ON a.user_id = m.id
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN company_table cj ON j.company_id = cj.company_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    LEFT JOIN company_table ci ON i.company_id = ci.company_id
                    ORDER BY a.applied_at DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql);

                var list = new List<dynamic>();
                foreach (DataRow r in dt.Rows)
                {
                    string sSkills = r["StudentSkills"] != DBNull.Value ? r["StudentSkills"].ToString() : "";
                    string rSkills = r["RequiredSkills"] != DBNull.Value ? r["RequiredSkills"].ToString() : "";
                    int matchScore = AIService.CalculateMatchScore(sSkills, rSkills);
                    int expScore = matchScore > 0 ? Math.Min(95, Math.Max(40, (int)(matchScore * 0.9) + 15)) : 0;

                    DateTime appliedDate = Convert.ToDateTime(r["applied_at"]);

                    string appPhoto = r["ProfilePhoto"] != DBNull.Value ? r["ProfilePhoto"].ToString().Trim() : "";
                    if (appPhoto.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                        appPhoto.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        appPhoto = "";
                    }

                    list.Add(new
                    {
                        ApplicationId = r["application_id"],
                        UserId = r["user_id"],
                        StudentName = r["StudentName"].ToString(),
                        ProfilePhoto = !string.IsNullOrEmpty(appPhoto) ? DBHelper.ResolveImageUrl(appPhoto, "") : "",
                        AppliedDateFormatted = appliedDate.ToString("MMM dd, yyyy"),
                        OpportunityTitle = r["OpportunityTitle"].ToString(),
                        CompanyName = r["CompanyName"].ToString(),
                        OppType = r["OppType"].ToString(),
                        Location = r["Location"].ToString(),
                        MatchScore = matchScore,
                        ExperienceScore = expScore,
                        Status = r["status"].ToString(),
                        College = r["College"] != DBNull.Value ? r["College"].ToString() : "University",
                        Degree = r["Degree"] != DBNull.Value ? r["Degree"].ToString() : "Engineering",
                        Skills = sSkills
                    });
                }

                rptAdminApplications.DataSource = list;
                rptAdminApplications.DataBind();

                if (dt.Rows.Count > 0)
                {
                    HasSelectedApp = true;
                    DataRow first = dt.Rows[0];
                    SelectedUserId = Convert.ToInt32(first["user_id"]);
                    SelectedStudentName = first["StudentName"].ToString();
                    string firstPhoto = first["ProfilePhoto"] != DBNull.Value ? first["ProfilePhoto"].ToString().Trim() : "";
                    if (firstPhoto.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                        firstPhoto.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        firstPhoto = "";
                    }
                    SelectedProfilePhoto = !string.IsNullOrEmpty(firstPhoto) ? DBHelper.ResolveImageUrl(firstPhoto, "") : "";
                    SelectedAppliedRole = first["OpportunityTitle"].ToString();
                    SelectedCompanyName = first["CompanyName"].ToString();
                    SelectedCollege = first["College"] != DBNull.Value ? first["College"].ToString() : "University";
                    SelectedEducation = first["Degree"] != DBNull.Value ? first["Degree"].ToString() : "Engineering";
                    SelectedTimelineStatus = first["status"].ToString();

                    string sSkills = first["StudentSkills"] != DBNull.Value ? first["StudentSkills"].ToString() : "";
                    string rSkills = first["RequiredSkills"] != DBNull.Value ? first["RequiredSkills"].ToString() : "";
                    SelectedMatchPct = AIService.CalculateMatchScore(sSkills, rSkills);
                    SelectedExpPct = SelectedMatchPct > 0 ? Math.Min(95, Math.Max(40, (int)(SelectedMatchPct * 0.9) + 15)) : 0;

                    SelectedSkills = new List<string>();
                    string[] rawSkills = sSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string s in rawSkills)
                    {
                        if (SelectedSkills.Count < 4)
                        {
                            SelectedSkills.Add(s.Trim());
                        }
                    }
                }
                else
                {
                    HasSelectedApp = false;
                }
            }
            catch
            {
                // Graceful fallback
            }
        }

        protected void rptAdminApplications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int appId = Convert.ToInt32(e.CommandArgument);
            try
            {
                if (e.CommandName == "RejectApp")
                {
                    DBHelper.ExecuteNonQuery("UPDATE applications SET status = 'Rejected', updated_at = GETDATE() WHERE application_id = @id",
                        new SqlParameter("@id", appId));
                }
                else if (e.CommandName == "ShortlistApp")
                {
                    DBHelper.ExecuteNonQuery("UPDATE applications SET status = 'Shortlisted', updated_at = GETDATE() WHERE application_id = @id",
                        new SqlParameter("@id", appId));
                }

                LoadApplicationMetrics();
                LoadApplicationsTable();
            }
            catch
            {
                // Silent catch
            }
        }

        private void DownloadStudentResume(int studentId)
        {
            try
            {
                string resumePath = "";
                string fileName = "";

                object rfObj = DBHelper.ExecuteScalar("SELECT resume_file FROM member_master_table WHERE id = @id",
                    new SqlParameter("@id", studentId));
                if (rfObj != null && rfObj != DBNull.Value && !string.IsNullOrWhiteSpace(rfObj.ToString()))
                {
                    string p = rfObj.ToString().Trim();
                    string virtualPath = p.StartsWith("~") ? p : (p.StartsWith("/") ? "~" + p : "~/Uploads/Resumes/" + p);
                    string localPath = Server.MapPath(virtualPath);
                    if (System.IO.File.Exists(localPath))
                    {
                        resumePath = localPath;
                        fileName = System.IO.Path.GetFileName(localPath);
                    }
                }

                if (string.IsNullOrEmpty(resumePath))
                {
                    string folder = Server.MapPath("~/Uploads/Resumes/");
                    if (System.IO.Directory.Exists(folder))
                    {
                        var files = System.IO.Directory.GetFiles(folder, $"Resume_{studentId}.*");
                        if (files.Length > 0 && System.IO.File.Exists(files[0]))
                        {
                            resumePath = files[0];
                            fileName = System.IO.Path.GetFileName(files[0]);
                        }
                    }
                }

                if (!string.IsNullOrEmpty(resumePath) && System.IO.File.Exists(resumePath))
                {
                    string ext = System.IO.Path.GetExtension(resumePath).ToLower();
                    Response.Clear();
                    Response.ContentType = (ext == ".pdf") ? "application/pdf" : "application/octet-stream";
                    Response.AppendHeader("Content-Disposition", $"attachment; filename={fileName}");
                    Response.TransmitFile(resumePath);
                    Response.End();
                }
                else
                {
                    object studentNameObj = DBHelper.ExecuteScalar("SELECT full_name FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                    string studentName = studentNameObj != null ? studentNameObj.ToString() : "Student";
                    Response.Clear();
                    Response.ContentType = "text/plain";
                    Response.AppendHeader("Content-Disposition", $"attachment; filename=Resume_{studentId}.txt");
                    Response.Write($"Candidate: {studentName}\nID: {studentId}\nStatus: Student Profile Active on SkillLinkX\nGenerated: {DateTime.Now}");
                    Response.End();
                }
            }
            catch (System.Threading.ThreadAbortException) { }
            catch { }
        }
    }
}
