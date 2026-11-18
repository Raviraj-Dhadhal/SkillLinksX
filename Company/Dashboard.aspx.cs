using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Dashboard : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Company Dashboard metric counters
        // =========================================================================
        public int ActiveJobsCount { get; set; }
        public int ActiveInternshipsCount { get; set; }
        public int TotalApplicantsCount { get; set; }
        public int ReviewCount { get; set; }
        public int ShortlistedCount { get; set; }
        public int InterviewsCount { get; set; }
        public int HiredCount { get; set; }
        public int ProfileCompletionPercentage { get; set; } = 0;
        public string GreetingText { get; set; } = "Welcome";
        public string DisplayCompanyName { get; set; } = "Company";

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
                LoadCompanyDashboardMetrics(companyId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Company Dashboard Metrics
        // Queries SQL Server tables (jobs, applications, interviews) for this company
        // =========================================================================
        private void LoadCompanyDashboardMetrics(int companyId)
        {
            // Dynamic time-of-day greeting
            int hour = DateTime.Now.Hour;
            if (hour >= 5 && hour < 12)
                GreetingText = "Good morning";
            else if (hour >= 12 && hour < 17)
                GreetingText = "Good afternoon";
            else if (hour >= 17 && hour < 22)
                GreetingText = "Good evening";
            else
                GreetingText = "Welcome";

            // Dynamic company name from database
            string userEmail = Session["Email"] != null ? Session["Email"].ToString().Trim() : "";
            if (companyId > 0)
            {
                try
                {
                    object nameObj = DBHelper.ExecuteScalar("SELECT comp_name FROM company_table WHERE company_id = @cid", new SqlParameter("@cid", companyId));
                    if (nameObj != null && nameObj != DBNull.Value && !string.IsNullOrWhiteSpace(nameObj.ToString()) && (!nameObj.ToString().Contains("TechNova") || userEmail.ToLower().Contains("technova")))
                    {
                        DisplayCompanyName = nameObj.ToString().Trim();
                        Session["UserName"] = DisplayCompanyName;
                        Session["CompanyName"] = DisplayCompanyName;
                    }
                    else if (Session["UserName"] != null && (!Session["UserName"].ToString().Contains("TechNova") || userEmail.ToLower().Contains("technova")))
                    {
                        DisplayCompanyName = Session["UserName"].ToString();
                    }
                    else
                    {
                        DisplayCompanyName = !string.IsNullOrEmpty(userEmail) ? userEmail.Split('@')[0] : "Company";
                        if (DisplayCompanyName.Length > 0) DisplayCompanyName = char.ToUpper(DisplayCompanyName[0]) + (DisplayCompanyName.Length > 1 ? DisplayCompanyName.Substring(1) : "");
                        Session["UserName"] = DisplayCompanyName;
                        Session["CompanyName"] = DisplayCompanyName;
                    }
                }
                catch
                {
                    DisplayCompanyName = Session["UserName"] != null ? Session["UserName"].ToString() : "Company";
                }
            }
            else
            {
                DisplayCompanyName = Session["UserName"] != null ? Session["UserName"].ToString() : "Company";
            }

            ProfileCompletionPercentage = companyId > 0 ? DBHelper.GetCompanyProfileStrength(companyId) : 0;

            if (companyId <= 0)
            {
                ActiveJobsCount = 0;
                ActiveInternshipsCount = 0;
                TotalApplicantsCount = 0;
                ReviewCount = 0;
                ShortlistedCount = 0;
                HiredCount = 0;
                InterviewsCount = 0;
                return;
            }

            // 1. Active Jobs Count
            object jobsObj = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM jobs WHERE company_id = @cid AND status = 'Active'",
                new SqlParameter("@cid", companyId)
            );
            ActiveJobsCount = jobsObj != null ? Convert.ToInt32(jobsObj) : 0;

            // 2. Active Internships Count
            object internObj = DBHelper.ExecuteScalar(
                @"SELECT (SELECT COUNT(*) FROM jobs WHERE company_id = @cid AND status = 'Active' AND job_type LIKE '%Intern%') +
                         (SELECT COUNT(*) FROM internships WHERE company_id = @cid AND status = 'Active')",
                new SqlParameter("@cid", companyId)
            );
            ActiveInternshipsCount = internObj != null ? Convert.ToInt32(internObj) : 0;

            // 3. Applications Breakdown by Status
            DataTable dtApps = DBHelper.ExecuteQuery(@"
                SELECT a.status, COUNT(*) AS StatusCount 
                FROM applications a
                WHERE a.company_id = @cid
                GROUP BY a.status",
                new SqlParameter("@cid", companyId)
            );

            TotalApplicantsCount = 0;
            ReviewCount = 0;
            ShortlistedCount = 0;
            HiredCount = 0;

            foreach (DataRow r in dtApps.Rows)
            {
                string status = r["status"].ToString();
                int count = Convert.ToInt32(r["StatusCount"]);
                TotalApplicantsCount += count;

                if (status.Equals("Under Review", StringComparison.OrdinalIgnoreCase) || status.Equals("New", StringComparison.OrdinalIgnoreCase))
                    ReviewCount += count;
                else if (status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase))
                    ShortlistedCount += count;
                else if (status.Equals("Accepted", StringComparison.OrdinalIgnoreCase) || status.Equals("Selected", StringComparison.OrdinalIgnoreCase))
                    HiredCount += count;
            }

            // 4. Scheduled Interviews Count
            object ivObj = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM interviews WHERE company_id = @cid",
                new SqlParameter("@cid", companyId)
            );
            InterviewsCount = ivObj != null ? Convert.ToInt32(ivObj) : 0;
        }
    }
}
