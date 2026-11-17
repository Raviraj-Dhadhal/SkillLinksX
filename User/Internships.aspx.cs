using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public class InternshipDisplayItem
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

    public partial class Internships : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                LoadInternships(studentId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Active Internships with AI Match
        // Queries 'jobs' where job_type LIKE '%Intern%' or salary_range LIKE '%stipend%'
        // =========================================================================
        private void LoadInternships(int studentId)
        {
            // 1. Fetch Student Skills
            string studentSkills = "C#, SQL, ASP.NET";
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

            // 2. Fetch Active Internships
            string sql = @"
                SELECT i.internship_id AS job_id, i.internship_title AS title, i.location_type AS location, 'Internship' AS job_type, 
                       ('₹' + CAST(CAST(i.stipend_amount AS INT) AS NVARCHAR) + ' / mo') AS salary_range, 
                       i.skills_required AS required_skills,
                       c.comp_name AS company_name
                FROM internships i
                INNER JOIN company_table c ON i.company_id = c.company_id
                WHERE i.status = 'Active' 
                ORDER BY i.created_at DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql);

            // If no explicit internship is found, fallback to jobs table
            if (dt == null || dt.Rows.Count == 0)
            {
                sql = @"
                    SELECT j.job_id, j.job_title AS title, j.location, j.job_type, 
                           ('₹' + CAST(CAST(j.salary_min AS INT) AS NVARCHAR) + ' - ₹' + CAST(CAST(j.salary_max AS INT) AS NVARCHAR)) AS salary_range, 
                           j.requirements AS required_skills,
                           c.comp_name AS company_name
                    FROM jobs j
                    INNER JOIN company_table c ON j.company_id = c.company_id
                    WHERE j.status = 'Active'
                    ORDER BY j.created_at DESC";
                dt = DBHelper.ExecuteQuery(sql);
            }

            // Fetch already applied jobs / internships for this student
            var appliedIds = new HashSet<int>();
            try
            {
                string appSql = "SELECT job_id, internship_id FROM applications WHERE user_id = @uid";
                DataTable dtApp = DBHelper.ExecuteQuery(appSql, new SqlParameter("@uid", studentId));
                foreach (DataRow appRow in dtApp.Rows)
                {
                    if (appRow["job_id"] != DBNull.Value) appliedIds.Add(Convert.ToInt32(appRow["job_id"]));
                    if (appRow["internship_id"] != DBNull.Value) appliedIds.Add(Convert.ToInt32(appRow["internship_id"]));
                }
            }
            catch { }

            var rankedList = new List<InternshipDisplayItem>();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow r in dt.Rows)
                {
                    int jobId = Convert.ToInt32(r["job_id"]);
                    string req = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "";
                    int match = AIService.CalculateMatchScore(studentSkills, req);

                    rankedList.Add(new InternshipDisplayItem
                    {
                        JobId = jobId,
                        Title = r["title"].ToString(),
                        CompanyName = r["company_name"].ToString(),
                        Location = r["location"] != DBNull.Value ? r["location"].ToString() : "Remote",
                        JobType = r["job_type"] != DBNull.Value ? r["job_type"].ToString() : "Internship",
                        SalaryRange = r["salary_range"] != DBNull.Value ? r["salary_range"].ToString() : "Stipend Provided",
                        RequiredSkills = req,
                        AiMatchScore = match,
                        HasApplied = appliedIds.Contains(jobId)
                    });
                }
            }

            // Order by AI match score
            var sortedList = rankedList.OrderByDescending(x => x.AiMatchScore).ToList();

            rptInternshipsList.DataSource = sortedList;
            rptInternshipsList.DataBind();
        }
    }
}
