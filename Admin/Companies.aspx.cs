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
        public string SelectedCompanyLogo { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            // Direct Action Trigger (Approve, Pending, Revoke) via robust URL action
            if (!string.IsNullOrEmpty(Request.QueryString["action"]) && int.TryParse(Request.QueryString["cid"], out int actionCid))
            {
                string act = Request.QueryString["action"].ToLower();
                try
                {
                    if (act == "approve")
                    {
                        DBHelper.ExecuteNonQuery(@"
                            UPDATE company_table SET is_verified = 1 WHERE company_id = @cid;
                            UPDATE user_auth SET account_status = 'Active' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                            new SqlParameter("@cid", actionCid));
                    }
                    else if (act == "pending")
                    {
                        DBHelper.ExecuteNonQuery(@"
                            UPDATE company_table SET is_verified = 0 WHERE company_id = @cid;
                            UPDATE user_auth SET account_status = 'Pending' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                            new SqlParameter("@cid", actionCid));
                    }
                    else if (act == "revoke")
                    {
                        DBHelper.ExecuteNonQuery(@"
                            UPDATE company_table SET is_verified = 0 WHERE company_id = @cid;
                            UPDATE user_auth SET account_status = 'Suspended' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                            new SqlParameter("@cid", actionCid));
                    }
                }
                catch { }

                Response.Redirect("~/Admin/Companies.aspx");
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
            DBHelper.EnsureCompanyColumns();
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
                    ISNULL(u.account_status, 'Active') AS account_status,
                    (SELECT COUNT(*) FROM jobs j WHERE j.company_id = c.company_id) AS JobCount,
                    (SELECT COUNT(*) FROM applications a WHERE a.company_id = c.company_id OR EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = c.company_id)) AS AppCount,
                    (SELECT COUNT(*) FROM applications a WHERE (a.company_id = c.company_id OR EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = c.company_id)) AND a.status = 'Hired') AS HireCount
                FROM company_table c
                LEFT JOIN user_auth u ON c.user_id = u.user_id
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
                    sql += " AND c.is_verified = 1 AND ISNULL(u.account_status, 'Active') = 'Active'";
                }
                else if (statusFilter == "Pending")
                {
                    sql += " AND c.is_verified = 0 AND ISNULL(u.account_status, 'Pending') = 'Pending'";
                }
                else if (statusFilter == "Revoked" || statusFilter == "Suspended")
                {
                    sql += " AND ISNULL(u.account_status, '') IN ('Revoked', 'Suspended')";
                }
            }

            sql += " ORDER BY c.company_id DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters.ToArray());

            try
            {
                object totObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM company_table");
                TotalCompaniesCount = totObj != null && totObj != DBNull.Value ? Convert.ToInt32(totObj) : 0;

                object verObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) 
                    FROM company_table c
                    LEFT JOIN user_auth u ON c.user_id = u.user_id
                    WHERE c.is_verified = 1 AND ISNULL(u.account_status, 'Active') = 'Active'");
                VerifiedCompaniesCount = verObj != null && verObj != DBNull.Value ? Convert.ToInt32(verObj) : 0;

                object pendObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) 
                    FROM company_table c
                    LEFT JOIN user_auth u ON c.user_id = u.user_id
                    WHERE c.is_verified = 0 AND ISNULL(u.account_status, 'Pending') = 'Pending'");
                PendingCompaniesCount = pendObj != null && pendObj != DBNull.Value ? Convert.ToInt32(pendObj) : 0;

                object jobsObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM jobs");
                TotalJobsPostedCount = jobsObj != null && jobsObj != DBNull.Value ? Convert.ToInt32(jobsObj) : 0;
            }
            catch
            {
                TotalCompaniesCount = 0;
                VerifiedCompaniesCount = 0;
                PendingCompaniesCount = 0;
                TotalJobsPostedCount = 0;
            }

            FilteredCompaniesCount = (dt != null) ? dt.Rows.Count : 0;

            var list = new List<dynamic>();

            if (dt != null)
            {
                int index = 0;
                foreach (DataRow r in dt.Rows)
                {
                    string cName = r["company_name"].ToString().Trim();
                    string initial = "C";
                    if (!string.IsNullOrEmpty(cName))
                    {
                        string[] parts = cName.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                        if (parts.Length > 1)
                            initial = (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
                        else
                            initial = cName.Substring(0, Math.Min(2, cName.Length)).ToUpper();
                    }

                    string logo = "";
                    if (r["logo_url"] != DBNull.Value && !string.IsNullOrEmpty(r["logo_url"].ToString()))
                    {
                        logo = r["logo_url"].ToString().Trim();
                    }
                    else if (r["profile_photo"] != DBNull.Value && !string.IsNullOrEmpty(r["profile_photo"].ToString()))
                    {
                        logo = r["profile_photo"].ToString().Trim();
                    }

                    if (logo.IndexOf("technova-avatar", StringComparison.OrdinalIgnoreCase) >= 0 ||
                        logo.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        logo = "";
                    }

                    string resolvedLogo = !string.IsNullOrEmpty(logo) ? DBHelper.ResolveImageUrl(logo, "") : "";

                    if (index == 0)
                    {
                        SelectedCompanyLogo = resolvedLogo;
                    }

                    string accStatus = r["account_status"] != DBNull.Value ? r["account_status"].ToString() : "Active";
                    int isVerified = r["is_verified"] != DBNull.Value ? Convert.ToInt32(r["is_verified"]) : 0;

                    string vStatus = "Pending";
                    if (accStatus.Equals("Revoked", StringComparison.OrdinalIgnoreCase) || accStatus.Equals("Suspended", StringComparison.OrdinalIgnoreCase))
                    {
                        vStatus = "Revoked";
                    }
                    else if (isVerified == 1 && accStatus.Equals("Active", StringComparison.OrdinalIgnoreCase))
                    {
                        vStatus = "Verified";
                    }
                    else
                    {
                        vStatus = "Pending";
                    }

                    list.Add(new
                    {
                        CompanyId = r["company_id"],
                        UserId = r["user_id"],
                        CompanyName = cName,
                        Initials = initial,
                        Email = r["email_add"].ToString(),
                        Phone = r["ph_no"] != DBNull.Value ? r["ph_no"].ToString() : "-",
                        Location = (!string.IsNullOrEmpty(r["city"].ToString()) ? r["city"].ToString() : "") +
                                   (!string.IsNullOrEmpty(r["state"].ToString()) ? ", " + r["state"].ToString() : ""),
                        Industry = r["industry"].ToString(),
                        Website = r["website"].ToString(),
                        Size = r["employee_count"].ToString(),
                        VerificationStatus = vStatus,
                        JobCount = r["JobCount"],
                        AppCount = r["AppCount"],
                        HireCount = r["HireCount"],
                        LogoUrl = resolvedLogo,
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
        // [ADMIN ACTIONS]: Table Command Actions (Approve, Pending, Revoke)
        // =========================================================================
        protected void rptCompaniesTable_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string[] parts = e.CommandArgument.ToString().Split('|');
            int companyId = Convert.ToInt32(parts[0]);

            try
            {
                if (e.CommandName == "ApproveCompany")
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE company_table SET is_verified = 1 WHERE company_id = @cid;
                        UPDATE user_auth SET account_status = 'Active' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Green;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} verified and activated successfully!";
                }
                else if (e.CommandName == "PendingCompany")
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE company_table SET is_verified = 0 WHERE company_id = @cid;
                        UPDATE user_auth SET account_status = 'Pending' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.DarkOrange;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} set to Pending verification.";
                }
                else if (e.CommandName == "RevokeCompany")
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE company_table SET is_verified = 0 WHERE company_id = @cid;
                        UPDATE user_auth SET account_status = 'Suspended' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Red;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} access revoked. Login disabled.";
                }

                LoadAdminCompanies();
                LoadCompanyAnalyticsCards();
            }
            catch (Exception ex)
            {
                lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Red;
                lblAdminCompanyStatus.Text = "Status update error: " + ex.Message;
            }
        }

        // Sidebar Approve
        protected void btnSidebarApprove_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnSelectedCompanyId.Value, out int companyId) && companyId > 0)
            {
                try
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE company_table SET is_verified = 1 WHERE company_id = @cid;
                        UPDATE user_auth SET account_status = 'Active' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Green;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} successfully approved, verified, and activated!";
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

        // Sidebar Mark as Pending
        protected void btnSidebarPending_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnSelectedCompanyId.Value, out int companyId) && companyId > 0)
            {
                try
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE company_table SET is_verified = 0 WHERE company_id = @cid;
                        UPDATE user_auth SET account_status = 'Pending' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.DarkOrange;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} verification set to Pending.";
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

        // Sidebar Revoke Access
        protected void btnSidebarRevoke_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnSelectedCompanyId.Value, out int companyId) && companyId > 0)
            {
                try
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE company_table SET is_verified = 0 WHERE company_id = @cid;
                        UPDATE user_auth SET account_status = 'Suspended' WHERE user_id = (SELECT user_id FROM company_table WHERE company_id = @cid);",
                        new SqlParameter("@cid", companyId));

                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Red;
                    lblAdminCompanyStatus.Text = $"Company #{companyId} account revoked! Login is now blocked.";
                }
                catch (Exception ex)
                {
                    lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Red;
                    lblAdminCompanyStatus.Text = "Revoke error: " + ex.Message;
                }

                LoadAdminCompanies();
                LoadCompanyAnalyticsCards();
            }
        }

        // =========================================================================
        // [ADMIN ACTION]: Add New Company with Login Credentials
        // Saves directly to user_auth & company_table so company can login
        // =========================================================================
        protected void btnSaveNewCompany_Click(object sender, EventArgs e)
        {
            lblNewCompError.Text = "";

            string compName = txtNewCompName.Text.Trim();
            string recruiterName = txtNewRecruiterName.Text.Trim();
            string email = txtNewCompEmail.Text.Trim();
            string password = txtNewCompPassword.Text.Trim();
            string phone = txtNewCompPhone.Text.Trim().Replace(" ", "");
            string industry = ddlNewCompIndustry.SelectedValue;
            string city = txtNewCompCity.Text.Trim();
            string state = ddlNewCompState.SelectedValue;
            string address = txtNewCompAddress.Text.Trim();
            string website = txtNewCompWebsite.Text.Trim();
            string empCount = ddlNewCompEmpCount.SelectedValue;
            string statusChoice = ddlNewCompStatus.SelectedValue; // "Active" (verified) or "Pending"

            if (string.IsNullOrEmpty(compName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(address))
            {
                lblNewCompError.Text = "Please fill in all required fields (Company Name, Email, Password, Phone, City, Address).";
                return;
            }

            if (password.Length < 6)
            {
                lblNewCompError.Text = "Password must be at least 6 characters long.";
                return;
            }

            if (string.IsNullOrEmpty(recruiterName))
            {
                recruiterName = compName + " HR";
            }

            try
            {
                // Check if email already exists
                int count = Convert.ToInt32(DBHelper.ExecuteScalar(
                    "SELECT COUNT(1) FROM user_auth WHERE email = @email",
                    new SqlParameter("@email", email)));

                if (count > 0)
                {
                    lblNewCompError.Text = "An account with this email address already exists.";
                    return;
                }

                int roleId = 3; // Company
                try
                {
                    object rObj = DBHelper.ExecuteScalar("SELECT TOP 1 role_id FROM [dbo].[role] WHERE role_name = 'Company'");
                    if (rObj != null && rObj != DBNull.Value) roleId = Convert.ToInt32(rObj);
                }
                catch { }

                int isVerified = (statusChoice == "Active") ? 1 : 0;
                string accountStatus = statusChoice; // "Active" or "Pending"

                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (SqlTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            string insertAuthSql = @"
                                INSERT INTO user_auth (email, password_hash, role_id, account_status, created_at)
                                VALUES (@email, @pass, @roleId, @status, GETDATE());
                                SELECT SCOPE_IDENTITY();";

                            int newUserId = 0;
                            using (SqlCommand authCmd = new SqlCommand(insertAuthSql, conn, trans))
                            {
                                authCmd.Parameters.AddWithValue("@email", email);
                                authCmd.Parameters.AddWithValue("@pass", password);
                                authCmd.Parameters.AddWithValue("@roleId", roleId);
                                authCmd.Parameters.AddWithValue("@status", accountStatus);
                                newUserId = Convert.ToInt32(authCmd.ExecuteScalar());
                            }

                            string insertCompSql = @"
                                INSERT INTO company_table 
                                (user_id, comp_name, email_add, ph_no, city, state, address, industry, description, website, employee_count, is_verified)
                                VALUES (@uid, @name, @email, @phone, @city, @state, @addr, @ind, @desc, @web, @emp, @v)";

                            using (SqlCommand compCmd = new SqlCommand(insertCompSql, conn, trans))
                            {
                                compCmd.Parameters.AddWithValue("@uid", newUserId);
                                compCmd.Parameters.AddWithValue("@name", compName);
                                compCmd.Parameters.AddWithValue("@email", email);
                                compCmd.Parameters.AddWithValue("@phone", phone);
                                compCmd.Parameters.AddWithValue("@city", city);
                                compCmd.Parameters.AddWithValue("@state", state);
                                compCmd.Parameters.AddWithValue("@addr", address);
                                compCmd.Parameters.AddWithValue("@ind", industry);
                                compCmd.Parameters.AddWithValue("@desc", $"Official company account for {compName}.");
                                compCmd.Parameters.AddWithValue("@web", string.IsNullOrEmpty(website) ? "https://www.skilllinkx.com" : website);
                                compCmd.Parameters.AddWithValue("@emp", empCount);
                                compCmd.Parameters.AddWithValue("@v", isVerified);
                                compCmd.ExecuteNonQuery();
                            }

                            trans.Commit();

                            // Reset form fields
                            txtNewCompName.Text = "";
                            txtNewRecruiterName.Text = "";
                            txtNewCompEmail.Text = "";
                            txtNewCompPassword.Text = "";
                            txtNewCompPhone.Text = "";
                            txtNewCompCity.Text = "";
                            txtNewCompAddress.Text = "";
                            txtNewCompWebsite.Text = "";

                            lblAdminCompanyStatus.ForeColor = System.Drawing.Color.Green;
                            lblAdminCompanyStatus.Text = $"Company '{compName}' registered successfully! Credentials ({email}) are {accountStatus} and ready for login.";

                            LoadAdminCompanies();
                            LoadCompanyAnalyticsCards();
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            lblNewCompError.Text = "Registration error: " + ex.Message;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblNewCompError.Text = "System error: " + ex.Message;
            }
        }
    }
}
