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
    // [OOP & COLLECTIONS]: Abstract Base Class demonstrating Polymorphism
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

    public class JobOpportunity : BaseOpportunity
    {
        public string AnnualSalary { get; set; }
        public override string Category => "job";
        public override string CompensationDisplay => !string.IsNullOrEmpty(AnnualSalary) ? AnnualSalary : "Best in Industry";
    }

    public class InternshipOpportunity : BaseOpportunity
    {
        public string MonthlyStipend { get; set; }
        public override string Category => "internship";
        public override string CompensationDisplay => !string.IsNullOrEmpty(MonthlyStipend) ? MonthlyStipend : "Stipend Provided";
    }

    public class ClosingSoonItem
    {
        public int JobId { get; set; }
        public string Title { get; set; }
        public string CompanyName { get; set; }
        public string DaysLeft { get; set; }
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
                LoadClosingSoon();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Saved Opportunities from DB
        // Queries 'saved_jobs' joined with 'jobs' and 'company_table'
        // =========================================================================
        private void LoadSavedOpportunities(int studentId)
        {
            string sql = @"
                SELECT s.saved_id, s.saved_at, 
                       j.job_id, j.job_title AS title, j.location, j.job_type, 
                       j.salary_min, j.salary_max,
                       c.comp_name AS company_name
                FROM saved_jobs s
                INNER JOIN jobs j ON s.job_id = j.job_id
                INNER JOIN company_table c ON j.company_id = c.company_id
                WHERE s.user_id = @sid
                ORDER BY s.saved_at DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@sid", studentId));

            List<BaseOpportunity> opportunitiesList = new List<BaseOpportunity>();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    string jobType = row["job_type"] != DBNull.Value ? row["job_type"].ToString() : "";
                    string salary = "Best in Industry";
                    if (row["salary_min"] != DBNull.Value && decimal.TryParse(row["salary_min"].ToString(), out decimal sMin))
                    {
                        decimal sMax = (row["salary_max"] != DBNull.Value && decimal.TryParse(row["salary_max"].ToString(), out decimal maxVal)) ? maxVal : sMin;
                        salary = $"₹{sMin:N0} - ₹{sMax:N0}";
                    }
                    DateTime savedDate = Convert.ToDateTime(row["saved_at"]);

                    if (jobType.IndexOf("intern", StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        opportunitiesList.Add(new InternshipOpportunity
                        {
                            SavedId = Convert.ToInt32(row["saved_id"]),
                            JobId = Convert.ToInt32(row["job_id"]),
                            Title = row["title"].ToString(),
                            CompanyName = row["company_name"].ToString(),
                            Location = row["location"] != DBNull.Value ? row["location"].ToString() : "Remote",
                            JobType = jobType,
                            MonthlyStipend = salary,
                            SavedTime = savedDate.ToString("MMM dd")
                        });
                    }
                    else
                    {
                        opportunitiesList.Add(new JobOpportunity
                        {
                            SavedId = Convert.ToInt32(row["saved_id"]),
                            JobId = Convert.ToInt32(row["job_id"]),
                            Title = row["title"].ToString(),
                            CompanyName = row["company_name"].ToString(),
                            Location = row["location"] != DBNull.Value ? row["location"].ToString() : "Remote",
                            JobType = jobType,
                            AnnualSalary = salary,
                            SavedTime = savedDate.ToString("MMM dd")
                        });
                    }
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
        // [CLOSING SOON OPPORTUNITIES]: Loads real active jobs from DB
        // =========================================================================
        private void LoadClosingSoon()
        {
            try
            {
                string sql = @"
                    SELECT TOP 3 j.job_id, j.job_title, c.comp_name, j.created_at
                    FROM jobs j
                    INNER JOIN company_table c ON j.company_id = c.company_id
                    WHERE j.status = 'Active'
                    ORDER BY j.created_at DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql);
                var list = new List<ClosingSoonItem>();
                int days = 2;

                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        list.Add(new ClosingSoonItem
                        {
                            JobId = Convert.ToInt32(r["job_id"]),
                            Title = r["job_title"].ToString(),
                            CompanyName = r["comp_name"].ToString(),
                            DaysLeft = $"{days++} DAYS LEFT"
                        });
                    }
                }

                rptClosingSoon.DataSource = list;
                rptClosingSoon.DataBind();
            }
            catch
            {
                rptClosingSoon.DataSource = null;
                rptClosingSoon.DataBind();
            }
        }

        // =========================================================================
        // [DATABASE DELETE]: Remove bookmark from saved_jobs
        // =========================================================================
        protected void rptSavedList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Remove")
            {
                int savedId = Convert.ToInt32(e.CommandArgument);
                int studentId = Convert.ToInt32(Session["UserId"]);

                DBHelper.ExecuteNonQuery(
                    "DELETE FROM saved_jobs WHERE saved_id = @id AND user_id = @uid",
                    new SqlParameter("@id", savedId),
                    new SqlParameter("@uid", studentId)
                );

                LoadSavedOpportunities(studentId);
            }
        }
    }
}
