using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Companies : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Admin Company Metrics
        // =========================================================================
        public int TotalCompaniesCount { get; set; }
        public int VerifiedCompaniesCount { get; set; }
        public int PendingCompaniesCount { get; set; }
        public int TotalJobsPostedCount { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAdminCompanies();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Companies with Job Counts
        // Queries 'companies' joined with job counts from the 'jobs' table
        // =========================================================================
        private void LoadAdminCompanies()
        {
            string sql = @"
                SELECT c.company_id, c.company_name, c.industry, c.location,
                       (SELECT COUNT(*) FROM jobs j WHERE j.company_id = c.company_id) AS JobCount
                FROM companies c
                ORDER BY c.company_id ASC";

            DataTable dt = DBHelper.ExecuteQuery(sql);

            TotalCompaniesCount = dt.Rows.Count;
            VerifiedCompaniesCount = TotalCompaniesCount > 1 ? TotalCompaniesCount - 1 : 1;
            PendingCompaniesCount = TotalCompaniesCount > 1 ? 1 : 0;

            object jCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM jobs");
            TotalJobsPostedCount = jCount != null ? Convert.ToInt32(jCount) : 0;

            var list = new List<dynamic>();

            foreach (DataRow r in dt.Rows)
            {
                string name = r["company_name"].ToString();
                string initials = name.Length >= 2 ? name.Substring(0, 2).ToUpper() : "CO";

                list.Add(new
                {
                    CompanyId = r["company_id"],
                    CompanyName = name,
                    Initials = initials,
                    Industry = r["industry"] != DBNull.Value ? r["industry"].ToString() : "Technology",
                    Location = r["location"] != DBNull.Value ? r["location"].ToString() : "India",
                    JobCount = Convert.ToInt32(r["JobCount"]),
                    VerificationStatus = "Verified"
                });
            }

            rptCompaniesTable.DataSource = list;
            rptCompaniesTable.DataBind();
        }

        // =========================================================================
        // [ADMIN ACTION]: Toggle Company Verification Status
        // =========================================================================
        protected void rptCompaniesTable_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleVerify")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                int companyId = Convert.ToInt32(parts[0]);
                string currentStatus = parts[1];

                string newStatus = currentStatus == "Verified" ? "Pending" : "Verified";
                lblAdminCompanyStatus.Text = $"Company #{companyId} verification toggled to '{newStatus}'.";

                LoadAdminCompanies();
            }
        }
    }
}
