using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class JobsInternships : Page
    {
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
                LoadAllOpportunities();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load All Platform Opportunities
        // Queries 'jobs' joined with 'company_table'
        // =========================================================================
        private void LoadAllOpportunities()
        {
            string sql = @"
                SELECT j.job_id, j.title, j.location, j.job_type, j.status,
                       c.comp_name AS company_name
                FROM jobs j
                INNER JOIN company_table c ON j.company_id = c.company_id
                ORDER BY j.created_at DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql);

            var list = new List<dynamic>();

            foreach (DataRow r in dt.Rows)
            {
                list.Add(new
                {
                    JobId = r["job_id"],
                    Title = r["title"].ToString(),
                    CompanyName = r["company_name"].ToString(),
                    JobType = r["job_type"].ToString(),
                    Location = r["location"].ToString(),
                    Status = r["status"].ToString()
                });
            }

            rptPlatformOpportunities.DataSource = list;
            rptPlatformOpportunities.DataBind();
        }

        // =========================================================================
        // [ADMIN ACTION]: Toggle Opportunity Status (Active <-> Paused)
        // =========================================================================
        protected void rptPlatformOpportunities_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                int jobId = Convert.ToInt32(parts[0]);
                string currentStatus = parts[1];

                string newStatus = currentStatus == "Active" ? "Paused" : "Active";

                DBHelper.ExecuteNonQuery(
                    "UPDATE jobs SET status = @s WHERE job_id = @id",
                    new SqlParameter("@s", newStatus),
                    new SqlParameter("@id", jobId)
                );

                lblAdminOppStatus.Text = $"Opportunity #{jobId} status updated to '{newStatus}'.";
                LoadAllOpportunities();
            }
        }
    }
}
