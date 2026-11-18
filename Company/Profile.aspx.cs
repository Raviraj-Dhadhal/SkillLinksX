using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Profile : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Company Profile data
        // =========================================================================
        public string CompanyName { get; set; } = "Company";
        public string CompanyIndustry { get; set; } = "";
        public string CompanyLocation { get; set; } = "";
        public string CompanyWebsite { get; set; } = "";
        public string CompanyDescription { get; set; } = "";
        public string EmployeeCount { get; set; } = "";
        public string CompanyLogoUrl { get; set; } = "";
        public int ActiveJobsCount { get; set; } = 0;
        public int TotalApplicantsCount { get; set; } = 0;
        public int ProfileCompletionPercentage { get; set; } = 0;
        public System.Collections.Generic.List<CompanyJobItem> PostedJobsList { get; set; } = new System.Collections.Generic.List<CompanyJobItem>();

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
                int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
                LoadCompanyProfile(companyId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Company Profile Details
        // Queries 'company_table' and counts active jobs and total applicants
        // =========================================================================
        private void LoadCompanyProfile(int companyId)
        {
            ProfileCompletionPercentage = DBHelper.GetCompanyProfileStrength(companyId);

            if (companyId <= 0)
            {
                CompanyName = Session["UserName"] != null ? Session["UserName"].ToString() : "Company";
                CompanyDescription = "No company overview added yet. Update your description in Company Settings.";
                CompanyIndustry = "Industry Not Specified";
                CompanyLocation = "Location Not Specified";
                EmployeeCount = "Size Not Specified";
                ActiveJobsCount = 0;
                TotalApplicantsCount = 0;
                return;
            }

            DBHelper.EnsureCompanyColumns();
            DBHelper.EnsureProfilePhotoColumns();

            string sql = "SELECT comp_name AS company_name, city, state, address, industry, description, website, employee_count, profile_photo FROM company_table WHERE company_id = @cid";
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                CompanyName = r["company_name"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["company_name"].ToString())
                    ? r["company_name"].ToString().Trim()
                    : (Session["UserName"] != null ? Session["UserName"].ToString() : "Company");

                if (r.Table.Columns.Contains("profile_photo") && r["profile_photo"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["profile_photo"].ToString()))
                {
                    CompanyLogoUrl = r["profile_photo"].ToString().Trim();
                    Session["CompanyProfilePhoto"] = CompanyLogoUrl;
                }
                else
                {
                    CompanyLogoUrl = "";
                    Session["CompanyProfilePhoto"] = null;
                }

                CompanyIndustry = r.Table.Columns.Contains("industry") && r["industry"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["industry"].ToString())
                    ? r["industry"].ToString().Trim()
                    : "Industry Not Specified";

                string city = r["city"] != DBNull.Value ? r["city"].ToString().Trim() : "";
                string state = r["state"] != DBNull.Value ? r["state"].ToString().Trim() : "";
                CompanyLocation = (!string.IsNullOrEmpty(city) && !string.IsNullOrEmpty(state))
                    ? $"{city}, {state}"
                    : (!string.IsNullOrEmpty(city) ? city : "Location Not Specified");

                CompanyWebsite = r.Table.Columns.Contains("website") && r["website"] != DBNull.Value ? r["website"].ToString().Trim() : "";
                EmployeeCount = r.Table.Columns.Contains("employee_count") && r["employee_count"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["employee_count"].ToString())
                    ? r["employee_count"].ToString().Trim()
                    : "Size Not Specified";

                CompanyDescription = r.Table.Columns.Contains("description") && r["description"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["description"].ToString())
                    ? r["description"].ToString().Trim()
                    : "No company overview added yet. Update your description in Company Settings.";
            }
            else
            {
                CompanyName = Session["UserName"] != null ? Session["UserName"].ToString() : "Company";
                CompanyDescription = "No company overview added yet. Update your description in Company Settings.";
                CompanyIndustry = "Industry Not Specified";
                CompanyLocation = "Location Not Specified";
                EmployeeCount = "Size Not Specified";
            }

            // Live counts
            object jObj = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM jobs WHERE company_id = @cid AND status = 'Active'",
                new SqlParameter("@cid", companyId)
            );
            ActiveJobsCount = jObj != null ? Convert.ToInt32(jObj) : 0;

            object aObj = DBHelper.ExecuteScalar(@"
                SELECT COUNT(*) FROM applications a 
                WHERE a.company_id = @cid 
                   OR EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = @cid)
                   OR EXISTS (SELECT 1 FROM internships i WHERE i.internship_id = a.internship_id AND i.company_id = @cid)",
                new SqlParameter("@cid", companyId)
            );
            TotalApplicantsCount = aObj != null ? Convert.ToInt32(aObj) : 0;

            // Load real posted jobs for this company
            string sqlJobs = @"
                SELECT j.job_id, j.job_title, j.job_type, j.location, j.experience_required, 
                       j.salary_min, j.salary_max, j.status,
                       (SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS ApplicantCount
                FROM jobs j
                WHERE j.company_id = @cid
                ORDER BY j.created_at DESC";

            DataTable dtJobs = DBHelper.ExecuteQuery(sqlJobs, new SqlParameter("@cid", companyId));
            foreach (DataRow jr in dtJobs.Rows)
            {
                decimal sMin = jr["salary_min"] != DBNull.Value ? Convert.ToDecimal(jr["salary_min"]) : 0;
                decimal sMax = jr["salary_max"] != DBNull.Value ? Convert.ToDecimal(jr["salary_max"]) : 0;
                string sal = (sMin > 0 && sMax > 0) ? $"₹{(sMin / 100000m):0.#}L - ₹{(sMax / 100000m):0.#}L" : "Competitive";

                PostedJobsList.Add(new CompanyJobItem
                {
                    JobId = jr["job_id"],
                    Title = jr["job_title"] != DBNull.Value ? jr["job_title"].ToString() : "Job Opening",
                    JobType = jr["job_type"] != DBNull.Value ? jr["job_type"].ToString() : "Full-time",
                    Location = jr["location"] != DBNull.Value ? jr["location"].ToString() : "Remote",
                    Experience = jr["experience_required"] != DBNull.Value ? jr["experience_required"].ToString() : "0-1 years",
                    Salary = sal,
                    Status = jr["status"] != DBNull.Value ? jr["status"].ToString() : "Active",
                    ApplicantCount = jr["ApplicantCount"] != DBNull.Value ? Convert.ToInt32(jr["ApplicantCount"]) : 0
                });
            }
        }
    }

    public class CompanyJobItem
    {
        public object JobId { get; set; }
        public string Title { get; set; }
        public string JobType { get; set; }
        public string Location { get; set; }
        public string Experience { get; set; }
        public string Salary { get; set; }
        public string Status { get; set; }
        public int ApplicantCount { get; set; }
    }
}
