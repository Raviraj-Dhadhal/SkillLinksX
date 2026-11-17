using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class PostJob : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }
        }

        // =========================================================================
        // [DATABASE INSERT]: Publish Opportunity Event Handler
        // Reads all form inputs and executes parameterized INSERT into 'jobs' table
        // =========================================================================
        protected void btnPublishOpportunity_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;

            string title = txtJobTitle.Text.Trim();
            string department = ddlDepartment.SelectedValue;
            string employmentType = ddlEmploymentType.SelectedValue;
            string experienceLevel = ddlExperienceLevel.SelectedValue;
            string city = ddlCity.SelectedValue;
            string state = ddlState.SelectedValue;
            string country = ddlCountry.SelectedValue;
            string location = $"{city}, {state}, {country}";

            string workType = hfWorkType.Value;
            if (string.IsNullOrEmpty(workType)) workType = "Hybrid";

            string salaryMin = txtSalaryMin.Text.Trim();
            string salaryMax = txtSalaryMax.Text.Trim();
            string salaryPeriod = ddlSalaryPeriod.SelectedValue;
            string salaryRange = (!string.IsNullOrEmpty(salaryMin) && !string.IsNullOrEmpty(salaryMax))
                                ? $"₹{salaryMin} - ₹{salaryMax} {salaryPeriod}"
                                : "Best in Industry";

            string description = txtJobDescription.Text.Trim();
            string requiredSkills = txtRequiredSkills.Text.Trim();
            if (string.IsNullOrEmpty(requiredSkills)) requiredSkills = "C#, ASP.NET, SQL Server";

            try
            {
                // Parameterized SQL INSERT into 'jobs' table
                string sql = @"
                    INSERT INTO jobs 
                    (company_id, job_title, location, job_type, category, experience_required, salary_min, salary_max, city, state, job_description, requirements, benefits, status, created_at, deadline)
                    VALUES 
                    (@cid, @title, @location, @jobType, 'Software Development', '0-2 Years', 400000, 800000, 'Mumbai', 'Maharashtra', @desc, @skills, 'Health Insurance, Flexible Hours', 'Active', GETDATE(), DATEADD(month, 1, GETDATE()))";

                int rowsAffected = DBHelper.ExecuteNonQuery(
                    sql,
                    new SqlParameter("@cid", companyId),
                    new SqlParameter("@title", title),
                    new SqlParameter("@location", location),
                    new SqlParameter("@jobType", employmentType),
                    new SqlParameter("@desc", description),
                    new SqlParameter("@skills", requiredSkills)
                );

                if (rowsAffected > 0)
                {
                    Response.Redirect("~/Company/ManageJobs.aspx");
                }
                else
                {
                    lblPostStatus.ForeColor = System.Drawing.Color.Red;
                    lblPostStatus.Text = "Failed to publish opportunity. Please check details and try again.";
                }
            }
            catch (Exception ex)
            {
                lblPostStatus.ForeColor = System.Drawing.Color.Red;
                lblPostStatus.Text = "Database Error: " + ex.Message;
            }
        }
    }
}
