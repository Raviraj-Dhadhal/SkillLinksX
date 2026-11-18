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

            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

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

            bool isInternship = employmentType.IndexOf("Intern", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                (Request.QueryString["type"] != null && Request.QueryString["type"].Equals("internship", StringComparison.OrdinalIgnoreCase));

            try
            {
                if (isInternship)
                {
                    decimal stipend = 15000;
                    if (!string.IsNullOrEmpty(salaryMin)) decimal.TryParse(salaryMin, out stipend);
                    if (stipend <= 0) stipend = 15000;

                    string sqlIntern = @"
                        INSERT INTO internships 
                        (company_id, internship_title, category, duration_months, stipend_amount, stipend_type, location_type, description, skills_required, perks, status, created_at, deadline)
                        VALUES 
                        (@cid, @title, @category, 3, @stipend, 'Fixed', @locType, @desc, @skills, 'Certificate, Flexible Work Hours, Letter of Recommendation', 'Active', GETDATE(), DATEADD(month, 2, GETDATE()))";

                    int rows = DBHelper.ExecuteNonQuery(
                        sqlIntern,
                        new SqlParameter("@cid", companyId),
                        new SqlParameter("@title", title),
                        new SqlParameter("@category", string.IsNullOrEmpty(department) ? "Software Development" : department),
                        new SqlParameter("@stipend", stipend),
                        new SqlParameter("@locType", workType),
                        new SqlParameter("@desc", description),
                        new SqlParameter("@skills", requiredSkills)
                    );

                    if (rows > 0)
                    {
                        Response.Redirect("~/Company/ManageInternships.aspx");
                        return;
                    }
                }
                else
                {
                    decimal sMin = 400000;
                    decimal sMax = 800000;
                    if (!string.IsNullOrEmpty(salaryMin)) decimal.TryParse(salaryMin, out sMin);
                    if (!string.IsNullOrEmpty(salaryMax)) decimal.TryParse(salaryMax, out sMax);
                    if (sMin <= 0) sMin = 400000;
                    if (sMax <= 0) sMax = 800000;

                    // Parameterized SQL INSERT into 'jobs' table
                    string sql = @"
                        INSERT INTO jobs 
                        (company_id, job_title, location, job_type, category, experience_required, salary_min, salary_max, city, state, job_description, requirements, benefits, status, created_at, deadline)
                        VALUES 
                        (@cid, @title, @location, @jobType, @category, @exp, @smin, @smax, @city, @state, @desc, @skills, 'Health Insurance, Flexible Hours, Performance Bonus', 'Active', GETDATE(), DATEADD(month, 1, GETDATE()))";

                    int rowsAffected = DBHelper.ExecuteNonQuery(
                        sql,
                        new SqlParameter("@cid", companyId),
                        new SqlParameter("@title", title),
                        new SqlParameter("@location", location),
                        new SqlParameter("@jobType", employmentType),
                        new SqlParameter("@category", string.IsNullOrEmpty(department) ? "Software Development" : department),
                        new SqlParameter("@exp", string.IsNullOrEmpty(experienceLevel) ? "0-2 Years" : experienceLevel),
                        new SqlParameter("@smin", sMin),
                        new SqlParameter("@smax", sMax),
                        new SqlParameter("@city", city),
                        new SqlParameter("@state", state),
                        new SqlParameter("@desc", description),
                        new SqlParameter("@skills", requiredSkills)
                    );

                    if (rowsAffected > 0)
                    {
                        Response.Redirect("~/Company/ManageJobs.aspx");
                        return;
                    }
                }

                lblPostStatus.ForeColor = System.Drawing.Color.Red;
                lblPostStatus.Text = "Failed to publish opportunity. Please check details and try again.";
            }
            catch (Exception ex)
            {
                lblPostStatus.ForeColor = System.Drawing.Color.Red;
                lblPostStatus.Text = "Database Error: " + ex.Message;
            }
        }
    }
}
