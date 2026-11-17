using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
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
            if (dt.Rows.Count == 0)
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

            var rankedList = new List<dynamic>();

            foreach (DataRow r in dt.Rows)
            {
                string req = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "";
                int match = AIService.CalculateMatchScore(studentSkills, req);

                rankedList.Add(new
                {
                    JobId = Convert.ToInt32(r["job_id"]),
                    Title = r["title"].ToString(),
                    CompanyName = r["company_name"].ToString(),
                    Location = r["location"].ToString(),
                    JobType = r["job_type"].ToString(),
                    SalaryRange = r["salary_range"] != DBNull.Value ? r["salary_range"].ToString() : "Stipend Provided",
                    RequiredSkills = req,
                    AiMatchScore = match
                });
            }

            rptInternshipsList.DataSource = rankedList.OrderByDescending(x => x.AiMatchScore).ToList();
            rptInternshipsList.DataBind();
        }
    }
}
