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
        // [PAGE PROPERTIES]: Real-time Admin Company Metrics from Database
        // =========================================================================
        public int TotalCompaniesCount { get; set; }
        public int VerifiedCompaniesCount { get; set; }
        public int PendingCompaniesCount { get; set; }
        public int TotalJobsPostedCount { get; set; }
        public int FilteredCompaniesCount { get; set; }

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
                PopulateFilters();
                LoadAdminCompanies();
                LoadCompanyAnalyticsCards();
            }
        }

        private void PopulateFilters()
        {
            try
            {
                ddlIndustryFilter.Items.Clear();
                ddlIndustryFilter.Items.Add(new ListItem("All Industries", ""));

                DataTable dtInd = DBHelper.ExecuteQuery("SELECT DISTINCT ISNULL(NULLIF(industry, ''), 'Technology') AS ind FROM company_table ORDER BY ind ASC");
                foreach (DataRow r in dtInd.Rows)
                {
                    string ind = r["ind"].ToString();
                    ddlIndustryFilter.Items.Add(new ListItem(ind, ind));
                }

                ddlLocationFilter.Items.Clear();
                ddlLocationFilter.Items.Add(new ListItem("All Locations", ""));

                DataTable dtLoc = DBHelper.ExecuteQuery("SELECT DISTINCT ISNULL(NULLIF(city, ''), 'India') AS city FROM company_table ORDER BY city ASC");
                foreach (DataRow r in dtLoc.Rows)
                {
                    string city = r["city"].ToString();
                    ddlLocationFilter.Items.Add(new ListItem(city, city));
                }
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Companies with Real Job Counts & Status
        // Strictly compliant with DATABASE_SCHEMA_REFERENCE.md
        // =========================================================================
        private void LoadAdminCompanies()
        {
            DBHelper.EnsureProfilePhotoColumns();

            string keyword = txtSearchCompany.Text.Trim();
            string industryFilter = ddlIndustryFilter.SelectedValue;
            string locationFilter = ddlLocationFilter.SelectedValue;
            string statusFilter = ddlStatusFilter.SelectedValue;

            string sql = @"
                SELECT 
                    c.company_id, 
                    c.user_id, 
                    c.comp_name AS company_name, 
                    c.email_add, 
                    c.ph_no, 
                    c.city, 
                    c.state, 
                    c.address,
                    c.is_verified, 
                    ISNULL(NULLIF(c.industry, ''), 'Technology') AS industry, 
                    c.description, 
                    ISNULL(NULLIF(c.website, ''), 'Not specified') AS website, 
                    c.logo_url, 
                    ISNULL(NULLIF(c.employee_count, ''), '10-50') AS employee_count, 
                    c.profile_photo,
                    (SELECT COUNT(*) FROM jobs j WHERE j.company_id = c.company_id) AS JobCount,
                    (SELECT COUNT(*) FROM applications a WHERE a.company_id = c.company_id OR EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = c.company_id)) AS AppCount,
                    (SELECT COUNT(*) FROM applications a WHERE (a.company_id = c.company_id OR EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = c.company_id)) AND a.status = 'Hired') AS HireCount
                FROM company_table c
                WHERE 1=1";

            var parameters = new List<SqlParameter>();

            if (!string.IsNullOrEmpty(keyword))
            {
                sql += " AND (c.comp_name LIKE @q OR c.email_add LIKE @q OR c.city LIKE @q OR c.industry LIKE @q)";
                parameters.Add(new SqlParameter("@q", "%" + keyword + "%"));
            }

            if (!string.IsNullOrEmpty(industryFilter))
            {
                sql += " AND ISNULL(NULLIF(c.industry, ''), 'Technology') = @ind";
                parameters.Add(new SqlParameter("@ind", industryFilter));
            }

            if (!string.IsNullOrEmpty(locationFilter))
            {
                sql += " AND ISNULL(NULLIF(c.city, ''), 'India') = @loc";
                parameters.Add(new SqlParameter("@loc", locationFilter));
            }

            if (!string.IsNullOrEmpty(statusFilter))
            {
                if (statusFilter == "Verified")
                {
                    sql += " AND c.is_verified = 1";
                }
                else if (statusFilter == "Pending")
                {
                    sql += " AND c.is_verified = 0";
                }
            }

            sql += " ORDER BY c.company_id DESC";

            DataTable dt = null;
            try
            {
                dt = DBHelper.ExecuteQuery(sql, parameters.ToArray());
            }
            catch
            {
                dt = DBHelper.ExecuteQuery(@"
                    SELECT c.company_id, c.comp_name AS company_name, c.email_add, c.ph_no, c.city, c.state,
                           c.is_verified, ISNULL(NULLIF(c.industry, ''), 'Technology') AS industry, c.website,
                           c.employee_count, c.profile_photo,
                           (SELECT COUNT(*) FROM jobs j WHERE j.company_id = c.company_id) AS JobCount,
                           0 AS AppCount, 0 AS HireCount
                    FROM company_table c
                    ORDER BY c.company_id DESC", parameters.ToArray());
            }

            try
            {
                object totObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM company_table");
                TotalCompaniesCount = totObj != null && totObj != DBNull.Value ? Convert.ToInt32(totObj) : 0;

                object verObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM company_table WHERE is_verified = 1");
                VerifiedCompaniesCount = verObj != null && verObj != DBNull.Value ? Convert.ToInt32(verObj) : 0;

                object penObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM company_table WHERE is_verified = 0");
                PendingCompaniesCount = penObj != null && penObj != DBNull.Value ? Convert.ToInt32(penObj) : 0;

                object jCount = DBHelper.ExecuteScalar(@"
                    SELECT 
                        ISNULL((SELECT COUNT(*) FROM jobs), 0) + 
                        ISNULL((SELECT COUNT(*) FROM internships), 0)");
                TotalJobsPostedCount = jCount != null && jCount != DBNull.Value ? Convert.ToInt32(jCount) : 0;
            }
            catch
            {
                TotalCompaniesCount = dt != null ? dt.Rows.Count : 0;
                VerifiedCompaniesCount = 0;
                PendingCompaniesCount = TotalCompaniesCount;
                TotalJobsPostedCount = 0;
            }

            FilteredCompaniesCount = dt != null ? dt.Rows.Count : 0;

            var list = new List<dynamic>();

            if (dt != null)
            {
                int index = 0;
                foreach (DataRow r in dt.Rows)
                {
                    string name = r["company_name"] != DBNull.Value ? r["company_name"].ToString().Trim() : "Company";
                    string initials = name.Length >= 2 ? name.Substring(0, 2).ToUpper() : "CO";
                    string city = r["city"] != DBNull.Value ? r["city"].ToString().Trim() : "";
                    string state = r["state"] != DBNull.Value ? r["state"].ToString().Trim() : "";
                    string loc = (!string.IsNullOrEmpty(city) && !string.IsNullOrEmpty(state)) ? $"{city}, {state}" : (!string.IsNullOrEmpty(city) ? city : "India");
                    string logo = r.Table.Columns.Contains("profile_photo") && r["profile_photo"] != DBNull.Value ? r["profile_photo"].ToString().Trim() : "";
                    
                    bool isVerified = false;
                    if (r["is_verified"] != DBNull.Value)
                    {
                        isVerified = Convert.ToBoolean(r["is_verified"]);
                    }

                    string status = isVerified ? "Verified" : "Pending";
                    string statusClass = isVerified ? "badge-status-verified" : "badge-status-pending";

                    string industry = r["industry"] != DBNull.Value ? r["industry"].ToString() : "Technology";
                    string website = r["website"] != DBNull.Value ? r["website"].ToString() : "Not specified";
                    string email = r["email_add"] != DBNull.Value ? r["email_add"].ToString() : "";
                    string phone = r["ph_no"] != DBNull.Value ? r["ph_no"].ToString() : "";
                    string size = r["employee_count"] != DBNull.Value ? r["employee_count"].ToString() : "10-50";
                    int jobCount = r["JobCount"] != DBNull.Value ? Convert.ToInt32(r["JobCount"]) : 0;
                    int appCount = r["AppCount"] != DBNull.Value ? Convert.ToInt32(r["AppCount"]) : 0;
                    int hireCount = r["HireCount"] != DBNull.Value ? Convert.ToInt32(r["HireCount"]) : 0;

                    list.Add(new
                    {
                        Index = index + 1,
                        CompanyId = r["company_id"],
                        CompanyName = name,
                        Initials = initials,
                        Industry = industry,
                        Location = loc,
                        Website = website,
                        Email = email,
                        Phone = phone,
                        Size = size,
                        JobCount = jobCount,
                        AppCount = appCount,
                        HireCount = hireCount,
                        IsVerified = isVerified,
                        VerificationStatus = status,
                        StatusClass = statusClass,
                        LogoUrl = logo,
                        IsSelected = (index == 0)
                    });

                    index++;
                }
            }

            rptCompaniesTable.DataSource = list;
            rptCompaniesTable.DataBind();
        }

        // =========================================================================
        // [DATABASE ACCESS]: Load Dynamic Popular Industries and Locations
        // =========================================================================
        private void LoadCompanyAnalyticsCards()
        {
            try
            {
                // Real industry distribution from company_table
                DataTable dtInd = DBHelper.ExecuteQuery(@"
                    SELECT TOP 4 
                        ISNULL(NULLIF(industry, ''), 'Technology') AS IndustryName,
                        COUNT(*) AS Cnt
                    FROM company_table
                    GROUP BY ISNULL(NULLIF(industry, ''), 'Technology')
                    ORDER BY Cnt DESC");

                int totalCount = TotalCompaniesCount > 0 ? TotalCompaniesCount : 1;
                var indList = new List<dynamic>();
                if (dtInd != null)
                {
                    foreach (DataRow r in dtInd.Rows)
                    {
                        int cnt = Convert.ToInt32(r["Cnt"]);
                        int pct = (int)Math.Round((double)cnt * 100 / totalCount);
                        indList.Add(new
                        {
                            IndustryName = r["IndustryName"].ToString(),
                            Percentage = pct
                        });
                    }
                }
                rptPopularIndustries.DataSource = indList;
                rptPopularIndustries.DataBind();

                // Real top locations from company_table
                DataTable dtLoc = DBHelper.ExecuteQuery(@"
                    SELECT DISTINCT TOP 6 ISNULL(NULLIF(city, ''), 'India') AS CityName 
                    FROM company_table 
                    ORDER BY CityName ASC");

                rptTopLocations.DataSource = dtLoc;
                rptTopLocations.DataBind();
            }
            catch { }
        }

        protected void txtSearchCompany_TextChanged(object sender, EventArgs e)
        {
            LoadAdminCompanies();
        }

        protected void ddlIndustryFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAdminCompanies();
        }

        protected void ddlLocationFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAdminCompanies();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAdminCompanies();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearchCompany.Text = "";
            ddlIndustryFilter.SelectedIndex = 0;
            ddlLocationFilter.SelectedIndex = 0;
            ddlStatusFilter.SelectedIndex = 0;
            lblAdminCompanyStatus.Text = "";
            LoadAdminCompanies();
        }

        // =========================================================================
        // [ADMIN ACTION]: Toggle Company Verification Status
        // Executes real UPDATE to 'dbo.company_table' column 'is_verified'
        // =========================================================================
        protected void rptCompaniesTable_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleVerify")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                int companyId = Convert.ToInt32(parts[0]);
                string currentStatus = parts[1];

                int newVerified = (currentStatus == "Verified") ? 0 : 1;
                string newStatusText = (newVerified == 1) ? "Verified" : "Pending";

                try
                {
                    DBHelper.ExecuteNonQuery(
                        "UPDATE company_table SET is_verified = @v WHERE company_id = @cid",
                        new SqlParameter("@v", newVerified),
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Green;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} status updated to '{newStatusText}' successfully!";
                }
                catch (Exception ex)
                {
                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Red;
                    lblAdminCompanyStatus.Text = "Status update error: " + ex.Message;
                }

                LoadAdminCompanies();
                LoadCompanyAnalyticsCards();
            }
        }

        protected void btnSidebarApprove_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnSelectedCompanyId.Value, out int companyId) && companyId > 0)
            {
                try
                {
                    DBHelper.ExecuteNonQuery(
                        "UPDATE company_table SET is_verified = 1 WHERE company_id = @cid",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Green;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} successfully approved and verified!";
                }
                catch (Exception ex)
                {
                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Red;
                    lblAdminCompanyStatus.Text = "Approval error: " + ex.Message;
                }

                LoadAdminCompanies();
                LoadCompanyAnalyticsCards();
            }
        }

        protected void btnSidebarReject_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnSelectedCompanyId.Value, out int companyId) && companyId > 0)
            {
                try
                {
                    DBHelper.ExecuteNonQuery(
                        "UPDATE company_table SET is_verified = 0 WHERE company_id = @cid",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Green;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} verification revoked to Pending.";
                }
                catch (Exception ex)
                {
                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Red;
                    lblAdminCompanyStatus.Text = "Update error: " + ex.Message;
                }

                LoadAdminCompanies();
                LoadCompanyAnalyticsCards();
            }
        }
    }
}
