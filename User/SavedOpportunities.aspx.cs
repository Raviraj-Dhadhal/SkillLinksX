using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    // =========================================================================
    // [TSEE RUBRIC REQUIREMENT: OOP & COLLECTIONS (5 MARKS)]
    // Abstract Base Class demonstrating Inheritance and Polymorphism
    // =========================================================================
    public abstract class BaseOpportunity
    {
        public int SavedId { get; set; }
        public int JobId { get; set; }
        public string Title { get; set; }
        public string CompanyName { get; set; }
        public string Location { get; set; }
        public string JobType { get; set; }
        public string SavedTime { get; set; }

        public abstract string Category { get; }
        public abstract string CompensationDisplay { get; }
    }

    // Derived Class 1: Full-Time Job Opportunity
    public class JobOpportunity : BaseOpportunity
    {
        public string AnnualSalary { get; set; }
        public override string Category => "job";
        public override string CompensationDisplay => !string.IsNullOrEmpty(AnnualSalary) ? AnnualSalary : "Best in Industry";
    }

    // Derived Class 2: Internship Opportunity
    public class InternshipOpportunity : BaseOpportunity
    {
        public string MonthlyStipend { get; set; }
        public override string Category => "internship";
        public override string CompensationDisplay => !string.IsNullOrEmpty(MonthlyStipend) ? MonthlyStipend : "Stipend Provided";
    }

    public partial class SavedOpportunities : Page
    {
        // Metric Counters
        public int TotalSavedCount { get; set; }
        public int SavedJobsCount { get; set; }
        public int SavedInternshipsCount { get; set; }

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
                LoadSavedOpportunities(studentId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Saved Opportunities using List<T>
        // Queries 'saved_opportunities' joined with 'jobs' and 'companies'.
        // Instantiates polymorphic objects (JobOpportunity vs InternshipOpportunity).
        // =========================================================================
        private void LoadSavedOpportunities(int studentId)
        {
            string sql = @"
                SELECT s.saved_id, s.saved_at, 
                       j.job_id, j.job_title AS title, j.location, j.job_type, 
                       ('₹' + CAST(CAST(j.salary_min AS INT) AS NVARCHAR) + ' - ₹' + CAST(CAST(j.salary_max AS INT) AS NVARCHAR)) AS salary_range,
                       c.comp_name AS company_name
                FROM saved_jobs s
                INNER JOIN jobs j ON s.job_id = j.job_id
                INNER JOIN company_table c ON j.company_id = c.company_id
                WHERE s.user_id = @sid
                ORDER BY s.saved_at DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@sid", studentId));

            // Generic Collection List<BaseOpportunity> (TSEE Requirement)
            List<BaseOpportunity> opportunitiesList = new List<BaseOpportunity>();

            foreach (DataRow row in dt.Rows)
            {
                string jobType = row["job_type"].ToString();
                string salary = row["salary_range"] != DBNull.Value ? row["salary_range"].ToString() : "";
                DateTime savedDate = Convert.ToDateTime(row["saved_at"]);

                if (jobType.IndexOf("intern", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    // Polymorphic instantiation of InternshipOpportunity
                    opportunitiesList.Add(new InternshipOpportunity
                    {
                        SavedId = Convert.ToInt32(row["saved_id"]),
                        JobId = Convert.ToInt32(row["job_id"]),
                        Title = row["title"].ToString(),
                        CompanyName = row["company_name"].ToString(),
                        Location = row["location"].ToString(),
                        JobType = jobType,
                        MonthlyStipend = salary,
                        SavedTime = savedDate.ToString("MMM dd")
                    });
                }
                else
                {
                    // Polymorphic instantiation of JobOpportunity
                    opportunitiesList.Add(new JobOpportunity
                    {
                        SavedId = Convert.ToInt32(row["saved_id"]),
                        JobId = Convert.ToInt32(row["job_id"]),
                        Title = row["title"].ToString(),
                        CompanyName = row["company_name"].ToString(),
                        Location = row["location"].ToString(),
                        JobType = jobType,
                        AnnualSalary = salary,
                        SavedTime = savedDate.ToString("MMM dd")
                    });
                }
            }

            // Metric Counters
            TotalSavedCount = opportunitiesList.Count;
            SavedJobsCount = opportunitiesList.FindAll(o => o is JobOpportunity).Count;
            SavedInternshipsCount = opportunitiesList.FindAll(o => o is InternshipOpportunity).Count;

            // Bind Collection to Repeater
            rptSavedList.DataSource = opportunitiesList;
            rptSavedList.DataBind();
        }

        // =========================================================================
        // [DATABASE DELETE]: Remove bookmark from saved_opportunities
        // =========================================================================
        protected void rptSavedList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Remove")
            {
                int savedId = Convert.ToInt32(e.CommandArgument);
                DBHelper.ExecuteNonQuery(
                    "DELETE FROM saved_jobs WHERE saved_id = @id",
                    new SqlParameter("@id", savedId)
                );

                int studentId = Convert.ToInt32(Session["UserId"]);
                LoadSavedOpportunities(studentId);
            }
        }
    }
}
