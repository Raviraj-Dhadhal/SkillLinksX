using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Public
{
    public partial class Home : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Exposed for the Featured Opportunity Banner
        // =========================================================================
        public string FeaturedTitle { get; set; } = ".NET Full Stack Developer";
        public string FeaturedCompany { get; set; } = "TechFlow Solutions";
        public string FeaturedLocation { get; set; } = "Bengaluru, India";
        public string FeaturedJobType { get; set; } = "Full-time";
        public string FeaturedSalary { get; set; } = "₹6L - ₹10L / yr";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPublicOpportunities();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Real Opportunities for Public Guests
        // Queries 'jobs' joined with 'companies' table without touching any layout CSS
        // =========================================================================
        private void LoadPublicOpportunities()
        {
            string sql = @"
                SELECT TOP 4 j.job_id, j.title, j.location, j.job_type, j.salary_range,
                       c.company_name
                FROM jobs j
                INNER JOIN companies c ON j.company_id = c.company_id
                WHERE j.status = 'Active'
                ORDER BY j.created_at DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql);

            if (dt.Rows.Count > 0)
            {
                // Top #1 is shown in the Big Featured Hero Card
                DataRow first = dt.Rows[0];
                FeaturedTitle = first["title"].ToString();
                FeaturedCompany = first["company_name"].ToString();
                FeaturedLocation = first["location"].ToString();
                FeaturedJobType = first["job_type"].ToString();
                FeaturedSalary = first["salary_range"] != DBNull.Value ? first["salary_range"].ToString() : "Best in Industry";

                // Remaining 3 are bound to the stacked cards on the right
                var stackList = new List<dynamic>();
                for (int i = 1; i < dt.Rows.Count; i++)
                {
                    DataRow r = dt.Rows[i];
                    stackList.Add(new
                    {
                        JobId = r["job_id"],
                        Title = r["title"].ToString(),
                        CompanyName = r["company_name"].ToString(),
                        Location = r["location"].ToString()
                    });
                }

                rptStackedJobs.DataSource = stackList;
                rptStackedJobs.DataBind();
            }
        }
    }
}
