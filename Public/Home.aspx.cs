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
            try
            {
                string sql = @"
                    SELECT TOP 4 j.job_id, j.job_title AS title, j.location, j.job_type, 
                           j.salary_min, j.salary_max,
                           c.comp_name AS company_name
                    FROM jobs j
                    INNER JOIN company_table c ON j.company_id = c.company_id
                    WHERE j.status = 'Active'
                    ORDER BY j.created_at DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql);

                if (dt != null && dt.Rows.Count > 0)
                {
                    // Top #1 is shown in the Big Featured Hero Card
                    DataRow first = dt.Rows[0];
                    FeaturedTitle = first["title"] != DBNull.Value ? first["title"].ToString() : FeaturedTitle;
                    FeaturedCompany = first["company_name"] != DBNull.Value ? first["company_name"].ToString() : FeaturedCompany;
                    FeaturedLocation = first["location"] != DBNull.Value ? first["location"].ToString() : FeaturedLocation;
                    FeaturedJobType = first["job_type"] != DBNull.Value ? first["job_type"].ToString() : FeaturedJobType;

                    if (first["salary_min"] != DBNull.Value && decimal.TryParse(first["salary_min"].ToString(), out decimal sMin))
                    {
                        decimal sMax = (first["salary_max"] != DBNull.Value && decimal.TryParse(first["salary_max"].ToString(), out decimal maxVal)) ? maxVal : sMin;
                        FeaturedSalary = $"₹{sMin:N0} - ₹{sMax:N0}";
                    }
                    else
                    {
                        FeaturedSalary = "Best in Industry";
                    }

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
            catch (Exception ex)
            {
                // Fallback gracefully so guests always see a fully functional home page
            }
        }
    }
}
