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
        public string SelectedEducation { get; set; } = "B.Tech Computer Science";
        public string SelectedCollege { get; set; } = "Engineering College";
        public string SelectedTimelineStatus { get; set; } = "Under Review";
        public List<string> SelectedSkills { get; set; } = new List<string>();

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
                LoadApplicationMetrics();
                LoadApplicationsTable();
            }
        }

        // =========================================================================
        // [DATABASE CONNECTIVITY & ADO.NET]: Load Platform-wide Application Metrics
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
                        SUM(CASE WHEN status = 'Interview Scheduled' THEN 1 ELSE 0 END) AS Interviews,
                        SUM(CASE WHEN status = 'Selected' OR status = 'Hired' THEN 1 ELSE 0 END) AS Hired
                    FROM applications";

                DataTable dt = DBHelper.ExecuteQuery(sql);

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    litTotalApps.Text = r["TotalApps"] != DBNull.Value ? Convert.ToInt32(r["TotalApps"]).ToString("N0") : "0";
                    litNewApps.Text = r["NewApps"] != DBNull.Value ? Convert.ToInt32(r["NewApps"]).ToString("N0") : "0";
                    litUnderReview.Text = r["UnderReview"] != DBNull.Value ? Convert.ToInt32(r["UnderReview"]).ToString("N0") : "0";
                    litShortlisted.Text = r["Shortlisted"] != DBNull.Value ? Convert.ToInt32(r["Shortlisted"]).ToString("N0") : "0";
                    litInterviews.Text = r["Interviews"] != DBNull.Value ? Convert.ToInt32(r["Interviews"]).ToString("N0") : "0";
                    litHired.Text = r["Hired"] != DBNull.Value ? Convert.ToInt32(r["Hired"]).ToString("N0") : "0";
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

                    DateTime appliedDate = Convert.ToDateTime(r["applied_at"]);

                    list.Add(new
                    {
                        ApplicationId = r["application_id"],
                        UserId = r["user_id"],
                        StudentName = r["StudentName"].ToString(),
                        AppliedDateFormatted = appliedDate.ToString("MMM dd, yyyy"),
                        OpportunityTitle = r["OpportunityTitle"].ToString(),
                        CompanyName = r["CompanyName"].ToString(),
                        OppType = r["OppType"].ToString(),
                        Location = r["Location"].ToString(),
                        MatchScore = matchScore,
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
                    SelectedStudentName = first["StudentName"].ToString();
                    SelectedAppliedRole = first["OpportunityTitle"].ToString();
                    SelectedCompanyName = first["CompanyName"].ToString();
                    SelectedCollege = first["College"] != DBNull.Value ? first["College"].ToString() : "University";
                    SelectedEducation = first["Degree"] != DBNull.Value ? first["Degree"].ToString() : "Engineering";
                    SelectedTimelineStatus = first["status"].ToString();

                    string sSkills = first["StudentSkills"] != DBNull.Value ? first["StudentSkills"].ToString() : "";
                    string rSkills = first["RequiredSkills"] != DBNull.Value ? first["RequiredSkills"].ToString() : "";
                    SelectedMatchPct = AIService.CalculateMatchScore(sSkills, rSkills);

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
                    DBHelper.ExecuteNonQuery("UPDATE applications SET status = 'Rejected' WHERE application_id = @id",
                        new SqlParameter("@id", appId));
                }
                else if (e.CommandName == "ShortlistApp")
                {
                    DBHelper.ExecuteNonQuery("UPDATE applications SET status = 'Shortlisted' WHERE application_id = @id",
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
    }
}
