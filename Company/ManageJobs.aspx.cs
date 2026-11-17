using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class ManageJobs : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time metric tile counters
        // =========================================================================
        public int TotalJobsCount { get; set; }
        public int ActiveJobsCount { get; set; }
        public int ClosedJobsCount { get; set; }
        public int TotalApplicationsCount { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
                LoadCompanyJobs(companyId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Company Jobs
        // Queries 'jobs' table for the logged-in company with applicant count per job.
        // Calculates metrics and binds the management table repeater.
        // =========================================================================
        private void LoadCompanyJobs(int companyId)
        {
            // SQL Query: joins job with applicant counts
            string sql = @"
                SELECT j.job_id, j.job_title AS title, j.location, j.job_type, j.status, j.created_at,
                       (SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS ApplicationCount
                FROM jobs j
                WHERE j.company_id = @cid
                ORDER BY j.created_at DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));

            // Metric Counters
            TotalJobsCount = dt.Rows.Count;
            ActiveJobsCount = 0;
            ClosedJobsCount = 0;
            TotalApplicationsCount = 0;

            var list = new List<dynamic>();

            foreach (DataRow row in dt.Rows)
            {
                string status = row["status"].ToString();
                int appCount = Convert.ToInt32(row["ApplicationCount"]);
                TotalApplicationsCount += appCount;

                if (status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                    ActiveJobsCount++;
                else
                    ClosedJobsCount++;

                DateTime posted = Convert.ToDateTime(row["created_at"]);

                list.Add(new
                {
                    JobId = row["job_id"],
                    Title = row["title"].ToString(),
                    Location = row["location"].ToString(),
                    JobType = row["job_type"].ToString(),
                    Status = status,
                    ApplicationCount = appCount,
                    PostedDate = posted.ToString("MMM dd, yyyy")
                });
            }

            rptCompanyJobs.DataSource = list;
            rptCompanyJobs.DataBind();
        }

        // =========================================================================
        // [DATABASE ACTIONS]: Toggle Status (Active <-> Closed) or Delete Job
        // =========================================================================
        protected void rptCompanyJobs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;

            if (e.CommandName == "ToggleStatus")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                int jobId = Convert.ToInt32(parts[0]);
                string currentStatus = parts[1];

                string newStatus = (currentStatus == "Active") ? "Closed" : "Active";

                DBHelper.ExecuteNonQuery(
                    "UPDATE jobs SET status = @s WHERE job_id = @id AND company_id = @cid",
                    new SqlParameter("@s", newStatus),
                    new SqlParameter("@id", jobId),
                    new SqlParameter("@cid", companyId)
                );

                lblActionMessage.Text = $"Job #{jobId} status updated to '{newStatus}'.";
                LoadCompanyJobs(companyId);
            }
            else if (e.CommandName == "DeleteJob")
            {
                int jobId = Convert.ToInt32(e.CommandArgument);

                try
                {
                    // Clean deletion (remove applications first if needed, then job)
                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM applications WHERE job_id = @id",
                        new SqlParameter("@id", jobId)
                    );

                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM jobs WHERE job_id = @id AND company_id = @cid",
                        new SqlParameter("@id", jobId),
                        new SqlParameter("@cid", companyId)
                    );

                    lblActionMessage.Text = $"Job #{jobId} deleted successfully.";
                    LoadCompanyJobs(companyId);
                }
                catch (Exception ex)
                {
                    lblActionMessage.ForeColor = System.Drawing.Color.Red;
                    lblActionMessage.Text = "Delete Error: " + ex.Message;
                }
            }
        }
    }
}
