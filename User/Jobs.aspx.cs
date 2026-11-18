using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public class JobDisplayItem
    {
        public int JobId { get; set; }
        public string Title { get; set; }
        public string CompanyName { get; set; }
        public string Location { get; set; }
        public string JobType { get; set; }
        public string SalaryRange { get; set; }
        public string RequiredSkills { get; set; }
        public int AiMatchScore { get; set; }
        public bool HasApplied { get; set; }
    }

    public partial class Jobs : Page
    {
        public int RecommendedScore { get; set; } = 92;
        public string RecommendedTitle { get; set; } = ".NET Full Stack Developer";
        public string RecommendedCompany { get; set; } = "TechFlow Solutions";
        public string RecommendedLocation { get; set; } = "Bengaluru";
        public int RecommendedJobId { get; set; } = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                LoadOpportunities(studentId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Opportunities with AI Ranking
        // Queries 'jobs' & 'company_table' tables, compares student skills from
        // 'member_master_table' using AIService, and picks the #1 top match.
        // =========================================================================
        private void LoadOpportunities(int studentId)
        {
            // ---------------------------------------------------------------------
            // Step 1: Read Student Skills from 'member_master_table'
            // ---------------------------------------------------------------------
            string studentSkills = "C#, ASP.NET, SQL, JavaScript";
            DataTable dtStudent = DBHelper.ExecuteQuery(
                "SELECT skills FROM member_master_table WHERE id = @id",
                new SqlParameter("@id", studentId)
            );

            if (dtStudent.Rows.Count > 0 && dtStudent.Rows[0]["skills"] != DBNull.Value)
            {
                string s = dtStudent.Rows[0]["skills"].ToString().Trim();
                if (!string.IsNullOrEmpty(s))
                    studentSkills = s;
            }

            // ---------------------------------------------------------------------
            // Step 2: Fetch all Active Job postings from 'jobs' & 'company_table' tables
            // ---------------------------------------------------------------------
            DataTable dtJobs = DBHelper.ExecuteQuery(
                @"SELECT j.job_id, j.job_title AS title, j.location, j.job_type, 
                         j.salary_min, j.salary_max,
                         j.requirements AS required_skills, c.comp_name AS company_name 
                  FROM jobs j 
                  INNER JOIN company_table c ON j.company_id = c.company_id 
                  WHERE j.status = 'Active' 
                  ORDER BY j.created_at DESC"
            );

            // Check applied jobs for this student
            var appliedJobIds = new HashSet<int>();
            try
            {
                string appSql = "SELECT job_id FROM applications WHERE user_id = @uid AND job_id IS NOT NULL";
                DataTable dtApp = DBHelper.ExecuteQuery(appSql, new SqlParameter("@uid", studentId));
                foreach (DataRow appRow in dtApp.Rows)
                {
                    appliedJobIds.Add(Convert.ToInt32(appRow["job_id"]));
                }
            }
            catch { }

            var rankedList = new List<JobDisplayItem>();

            // ---------------------------------------------------------------------
            // Step 3: Calculate AI Match Score (%) for every active job
            // ---------------------------------------------------------------------
            foreach (DataRow r in dtJobs.Rows)
            {
                int jId = Convert.ToInt32(r["job_id"]);
                string reqSkills = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "";
                int match = AIService.CalculateMatchScore(studentSkills, reqSkills);

                string salaryDisplay = "Best in Industry";
                if (r["salary_min"] != DBNull.Value && decimal.TryParse(r["salary_min"].ToString(), out decimal sMin))
                {
                    decimal sMax = (r["salary_max"] != DBNull.Value && decimal.TryParse(r["salary_max"].ToString(), out decimal maxVal)) ? maxVal : sMin;
                    salaryDisplay = $"₹{sMin:N0} - ₹{sMax:N0}";
                }

                rankedList.Add(new JobDisplayItem
                {
                    JobId = jId,
                    Title = r["title"].ToString(),
                    CompanyName = r["company_name"].ToString(),
                    Location = r["location"] != DBNull.Value ? r["location"].ToString() : "Remote",
                    JobType = r["job_type"] != DBNull.Value ? r["job_type"].ToString() : "Full-time",
                    SalaryRange = salaryDisplay,
                    RequiredSkills = reqSkills,
                    AiMatchScore = match,
                    HasApplied = appliedJobIds.Contains(jId)
                });
            }

            // Sort jobs by highest match score first
            var sortedJobs = rankedList.OrderByDescending(j => j.AiMatchScore).ToList();

            // ---------------------------------------------------------------------
            // Step 4: Populate the "Recommended For You" Hero Banner with #1 Job
            // ---------------------------------------------------------------------
            if (sortedJobs.Count > 0)
            {
                var top = sortedJobs[0];
                RecommendedJobId = top.JobId;
                RecommendedTitle = top.Title;
                RecommendedCompany = top.CompanyName;
                RecommendedLocation = top.Location;
                RecommendedScore = top.AiMatchScore;

                var reqTokens = top.RequiredSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                                  .Select(x => x.Trim())
                                                  .Where(x => !string.IsNullOrEmpty(x))
                                                  .Take(4)
                                                  .ToList();
                rptRecommendedSkills.DataSource = reqTokens;
                rptRecommendedSkills.DataBind();
            }

            // ---------------------------------------------------------------------
            // Step 5: Bind the Full Dynamic List
            // ---------------------------------------------------------------------
            rptJobsList.DataSource = sortedJobs;
            rptJobsList.DataBind();
        }
    }
}
