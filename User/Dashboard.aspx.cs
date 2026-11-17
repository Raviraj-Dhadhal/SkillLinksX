using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Dashboard : Page
    {
        public int TotalApplications { get; set; }
        public int TotalInterviews { get; set; }
        public int TotalShortlisted { get; set; }
        public int ProfileViews { get; set; }
        public int TopAiMatchScore { get; set; }
        public string StudentSkillsSummary { get; set; }
        public bool HasUpcomingInterviews { get; set; } = false;
        public string InterviewCompany { get; set; } = "";
        public string InterviewRole { get; set; } = "";
        public string InterviewDateFormatted { get; set; } = "";

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
                LoadStudentDashboardData(studentId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Student Dashboard Data Loader
        // Queries SQL tables (member_master_table, applications, interviews, jobs)
        // and scores opportunities using AI matching algorithm.
        // =========================================================================
        private void LoadStudentDashboardData(int studentId)
        {
            // ---------------------------------------------------------------------
            // Step 1: Query student's profile skills from 'member_master_table'
            // ---------------------------------------------------------------------
            string studentSkills = "";
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

            // Expose skills to ASPX front-end and bind top skill tags
            StudentSkillsSummary = !string.IsNullOrEmpty(studentSkills) ? studentSkills : "No skills added yet";
            var skillsList = studentSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                          .Select(x => x.Trim()).Take(4).ToList();
            rptTopSkillsPills.DataSource = skillsList;
            rptTopSkillsPills.DataBind();
            rptSkillVerification.DataSource = skillsList;
            rptSkillVerification.DataBind();

            // ---------------------------------------------------------------------
            // Step 2: Query real-time metric counts from SQL Server tables
            // ---------------------------------------------------------------------
            // Applications count from 'applications' table
            object appsObj = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM applications WHERE user_id = @id",
                new SqlParameter("@id", studentId)
            );
            TotalApplications = appsObj != null ? Convert.ToInt32(appsObj) : 0;

            // Upcoming interviews from 'interviews' table
            string sqlInterviews = @"
                SELECT TOP 1 i.interview_date, i.role_title, c.comp_name
                FROM interviews i
                LEFT JOIN company_table c ON i.company_id = c.company_id
                WHERE i.user_id = @id AND i.interview_date >= GETDATE()
                ORDER BY i.interview_date ASC";
            DataTable dtInterviews = DBHelper.ExecuteQuery(sqlInterviews, new SqlParameter("@id", studentId));

            if (dtInterviews != null && dtInterviews.Rows.Count > 0)
            {
                HasUpcomingInterviews = true;
                TotalInterviews = dtInterviews.Rows.Count;
                DataRow ir = dtInterviews.Rows[0];
                InterviewCompany = ir["comp_name"] != DBNull.Value ? ir["comp_name"].ToString() : "Hiring Company";
                InterviewRole = ir["role_title"] != DBNull.Value ? ir["role_title"].ToString() : "Interview";
                InterviewDateFormatted = Convert.ToDateTime(ir["interview_date"]).ToString("MMM dd, hh:mm tt");
            }
            else
            {
                HasUpcomingInterviews = false;
                TotalInterviews = 0;
            }

            // Shortlisted count from 'applications' table
            object shortlistedObj = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM applications WHERE user_id = @id AND status = 'Shortlisted'",
                new SqlParameter("@id", studentId)
            );
            TotalShortlisted = shortlistedObj != null ? Convert.ToInt32(shortlistedObj) : 0;

            // Profile views: 1 for new profiles + 3 per application submitted
            ProfileViews = 1 + (TotalApplications * 3);

            // ---------------------------------------------------------------------
            // Step 3: Fetch active jobs and compute AI Match Score for each
            // Connects to 'jobs' joined with 'company_table'
            // ---------------------------------------------------------------------
            DataTable dtJobs = DBHelper.ExecuteQuery(
                @"SELECT TOP 6 j.job_id, j.job_title AS title, j.location, j.job_type, 
                         ('₹' + CAST(CAST(j.salary_min AS INT) AS NVARCHAR) + ' - ₹' + CAST(CAST(j.salary_max AS INT) AS NVARCHAR)) AS salary_range, 
                         j.requirements AS required_skills, c.comp_name AS company_name 
                  FROM jobs j 
                  INNER JOIN company_table c ON j.company_id = c.company_id 
                  WHERE j.status = 'Active' 
                  ORDER BY j.created_at DESC"
            );

            var rankedJobs = new List<dynamic>();
            int highestScore = 0;

            foreach (DataRow row in dtJobs.Rows)
            {
                string reqSkills = row["required_skills"] != DBNull.Value ? row["required_skills"].ToString() : "";
                
                // Compare student skills with job required skills using AI helper
                int match = AIService.CalculateMatchScore(studentSkills, reqSkills);

                if (match > highestScore)
                    highestScore = match;

                rankedJobs.Add(new
                {
                    JobId = row["job_id"],
                    Title = row["title"].ToString(),
                    CompanyName = row["company_name"].ToString(),
                    Location = row["location"].ToString(),
                    JobType = row["job_type"].ToString(),
                    SalaryRange = row["salary_range"] != DBNull.Value ? row["salary_range"].ToString() : "Best in Industry",
                    AiMatchScore = match
                });
            }

            // Sets the banner percentage (e.g., 92% AI Match)
            TopAiMatchScore = highestScore;

            // Bind Top 2 matching jobs to the Dashboard repeater
            rptTopMatches.DataSource = rankedJobs.OrderByDescending(j => j.AiMatchScore).Take(2).ToList();
            rptTopMatches.DataBind();

            // ---------------------------------------------------------------------
            // Step 4: Load Recent Applications from SQL database
            // ---------------------------------------------------------------------
            DataTable dtRecent = DBHelper.ExecuteQuery(
                @"SELECT TOP 5 a.status, j.job_title AS JobTitle, c.comp_name AS CompanyName 
                  FROM applications a 
                  INNER JOIN jobs j ON a.job_id = j.job_id 
                  INNER JOIN company_table c ON j.company_id = c.company_id 
                  WHERE a.user_id = @id 
                  ORDER BY a.applied_at DESC",
                new SqlParameter("@id", studentId)
            );

            var recentApps = new List<dynamic>();
            foreach (DataRow r in dtRecent.Rows)
            {
                string status = r["status"].ToString();
                string statusClass = "status-applied";
                if (status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase)) statusClass = "status-shortlisted";
                else if (status.Equals("Under Review", StringComparison.OrdinalIgnoreCase)) statusClass = "status-review";
                else if (status.Equals("Rejected", StringComparison.OrdinalIgnoreCase)) statusClass = "status-rejected";

                recentApps.Add(new
                {
                    CompanyName = r["CompanyName"].ToString(),
                    JobTitle = r["JobTitle"].ToString(),
                    Status = status,
                    StatusClass = statusClass
                });
            }

            // Bind recent applications table
            rptRecentApplications.DataSource = recentApps;
            rptRecentApplications.DataBind();

            // ---------------------------------------------------------------------
            // Step 5: Load Real Suggested Connections from member_master_table
            // ---------------------------------------------------------------------
            try
            {
                string sqlConns = @"
                    SELECT TOP 3 m.id, m.full_name, m.clg_name, m.degree
                    FROM member_master_table m
                    WHERE m.id <> @uid
                    ORDER BY m.id DESC";
                DataTable dtConns = DBHelper.ExecuteQuery(sqlConns, new SqlParameter("@uid", studentId));
                var connsList = new List<dynamic>();

                foreach (DataRow cr in dtConns.Rows)
                {
                    string nm = cr["full_name"].ToString();
                    string deg = cr["degree"] != DBNull.Value && !string.IsNullOrEmpty(cr["degree"].ToString()) ? cr["degree"].ToString() : "Student";
                    string clg = cr["clg_name"] != DBNull.Value && !string.IsNullOrEmpty(cr["clg_name"].ToString()) ? cr["clg_name"].ToString() : "University";
                    string initial = !string.IsNullOrEmpty(nm) ? nm.Substring(0, 1).ToUpper() : "U";

                    connsList.Add(new
                    {
                        FullName = nm,
                        Subtitle = deg + " at " + clg,
                        Initial = initial
                    });
                }

                rptSuggestedConnections.DataSource = connsList;
                rptSuggestedConnections.DataBind();
            }
            catch
            {
                // Fallback safe binding
            }
        }
    }
}
