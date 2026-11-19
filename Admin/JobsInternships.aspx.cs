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
        // Queries both 'jobs' and 'internships' joined with 'company_table'
        // Strictly compliant with DATABASE_SCHEMA_REFERENCE.md
        // =========================================================================
        private void LoadAllOpportunities()
        {
            string sql = @"
                SELECT 
                    'Job' AS OppCategory,
                    j.job_id AS OpportunityId,
                    j.job_title AS Title,
                    c.comp_name AS CompanyName,
                    j.job_type AS JobType,
                    j.location AS Location,
                    j.status AS Status,
                    j.created_at AS CreatedAt
                FROM jobs j
                INNER JOIN company_table c ON j.company_id = c.company_id

                UNION ALL

                SELECT 
                    'Internship' AS OppCategory,
                    i.internship_id AS OpportunityId,
                    i.internship_title AS Title,
                    c.comp_name AS CompanyName,
                    'Internship' AS JobType,
                    i.location_type AS Location,
                    i.status AS Status,
                    i.created_at AS CreatedAt
                FROM internships i
                INNER JOIN company_table c ON i.company_id = c.company_id

                ORDER BY CreatedAt DESC";

            DataTable dt = null;
            try
            {
                dt = DBHelper.ExecuteQuery(sql);
            }
            catch
            {
                // Fallback if internships table has different schema
                dt = DBHelper.ExecuteQuery(@"
                    SELECT 'Job' AS OppCategory, j.job_id AS OpportunityId, j.job_title AS Title, 
                           c.comp_name AS CompanyName, j.job_type AS JobType, j.location AS Location, 
                           j.status AS Status, j.created_at AS CreatedAt
                    FROM jobs j
                    INNER JOIN company_table c ON j.company_id = c.company_id
                    ORDER BY j.created_at DESC");
            }

            var list = new List<dynamic>();

            if (dt != null)
            {
                foreach (DataRow r in dt.Rows)
                {
                    list.Add(new
                    {
                        OppCategory = r["OppCategory"].ToString(),
                        OpportunityId = r["OpportunityId"],
                        Title = r["Title"].ToString(),
                        CompanyName = r["CompanyName"].ToString(),
                        JobType = r["JobType"].ToString(),
                        Location = r["Location"].ToString(),
                        Status = r["Status"].ToString()
                    });
                }
            }

            rptPlatformOpportunities.DataSource = list;
            rptPlatformOpportunities.DataBind();
        }

        // =========================================================================
        // [ADMIN ACTION]: Toggle Opportunity Status (Active <-> Paused)
        // Works for both 'jobs' and 'internships'
        // =========================================================================
        protected void rptPlatformOpportunities_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                string category = parts[0];
                int oppId = Convert.ToInt32(parts[1]);
                string currentStatus = parts[2];

                string newStatus = currentStatus.Equals("Active", StringComparison.OrdinalIgnoreCase) ? "Paused" : "Active";

                try
                {
                    if (category.Equals("Internship", StringComparison.OrdinalIgnoreCase))
                    {
                        DBHelper.ExecuteNonQuery(
                            "UPDATE internships SET status = @s WHERE internship_id = @id",
                            new SqlParameter("@s", newStatus),
                            new SqlParameter("@id", oppId));
                    }
                    else
                    {
                        DBHelper.ExecuteNonQuery(
                            "UPDATE jobs SET status = @s WHERE job_id = @id",
                            new SqlParameter("@s", newStatus),
                            new SqlParameter("@id", oppId));
                    }

                    lblAdminOppStatus.ForeColor = System.Drawing.Color.Green;
                    lblAdminOppStatus.Text = $"{category} opportunity #{oppId} status updated to '{newStatus}' successfully!";
                }
                catch (Exception ex)
                {
                    lblAdminOppStatus.ForeColor = System.Drawing.Color.Red;
                    lblAdminOppStatus.Text = "Status update error: " + ex.Message;
                }

                LoadAllOpportunities();
            }
        }
    }
}
