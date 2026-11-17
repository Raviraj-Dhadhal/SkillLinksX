using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
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
        // Queries 'jobs' & 'companies' tables, compares student skills from
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
                         ('₹' + CAST(CAST(j.salary_min AS INT) AS NVARCHAR) + ' - ₹' + CAST(CAST(j.salary_max AS INT) AS NVARCHAR)) AS salary_range, 
                         j.requirements AS required_skills, c.comp_name AS company_name 
                  FROM jobs j 
                  INNER JOIN company_table c ON j.company_id = c.company_id 
                  WHERE j.status = 'Active' 
                  ORDER BY j.created_at DESC"
            );

            var rankedList = new List<dynamic>();

            // ---------------------------------------------------------------------
            // Step 3: Calculate AI Match Score (%) for every active job
            // ---------------------------------------------------------------------
            foreach (DataRow r in dtJobs.Rows)
            {
                string reqSkills = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "";
                int match = AIService.CalculateMatchScore(studentSkills, reqSkills);

                rankedList.Add(new
                {
                    JobId = Convert.ToInt32(r["job_id"]),
                    Title = r["title"].ToString(),
                    CompanyName = r["company_name"].ToString(),
                    Location = r["location"].ToString(),
                    SalaryRange = r["salary_range"] != DBNull.Value ? r["salary_range"].ToString() : "Best in Industry",
                    RequiredSkills = reqSkills,
                    AiMatchScore = match
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

                // Split skills into individual tags for the banner
                string topReq = top.RequiredSkills;
                var pillSkills = topReq.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                       .Select(s => s.Trim()).Take(4).ToList();

                rptRecommendedSkills.DataSource = pillSkills;
                rptRecommendedSkills.DataBind();
            }

            // ---------------------------------------------------------------------
            // Step 5: Bind the remaining ranked jobs to the listings repeater
            // ---------------------------------------------------------------------
            rptJobsList.DataSource = sortedJobs;
            rptJobsList.DataBind();
        }
    }
}
