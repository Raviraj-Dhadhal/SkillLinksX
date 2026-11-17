using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Settings : Page
    {
        public bool IsTechNova { get; set; } = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;

            if (!IsPostBack)
            {
                LoadCompanyData(companyId);
            }
        }

        private void LoadCompanyData(int companyId)
        {
            try
            {
                string sql = "SELECT company_id, comp_name, email_add, ph_no, city, state, address, industry, description, website, employee_count FROM company_table WHERE company_id = @cid";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    string name = r["comp_name"] != DBNull.Value ? r["comp_name"].ToString().Trim() : "";
                    txtCompanyName.Text = name;
                    IsTechNova = name.IndexOf("TechNova", StringComparison.OrdinalIgnoreCase) >= 0;

                    string ind = r["industry"] != DBNull.Value ? r["industry"].ToString().Trim() : "Information Technology";
                    if (ddlIndustry.Items.FindByText(ind) != null)
                        ddlIndustry.SelectedValue = ind;

                    string size = r["employee_count"] != DBNull.Value ? r["employee_count"].ToString().Trim() : "51-200 employees";
                    if (ddlCompanySize.Items.FindByText(size) != null)
                        ddlCompanySize.SelectedValue = size;

                    txtWebsite.Text = r["website"] != DBNull.Value ? r["website"].ToString().Trim() : "";
                    txtLocation.Text = r["address"] != DBNull.Value ? r["address"].ToString().Trim() : "";
                    txtContactEmail.Text = r["email_add"] != DBNull.Value ? r["email_add"].ToString().Trim() : "";
                    txtCompanyDesc.Text = r["description"] != DBNull.Value ? r["description"].ToString().Trim() : "";
                }
            }
            catch (Exception ex)
            {
                lblSettingsStatus.ForeColor = System.Drawing.Color.Red;
                lblSettingsStatus.Text = "Error loading settings: " + ex.Message;
            }
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;

            string name = txtCompanyName.Text.Trim();
            string industry = ddlIndustry.SelectedValue;
            string size = ddlCompanySize.SelectedValue;
            string website = txtWebsite.Text.Trim();
            string address = txtLocation.Text.Trim();
            string email = txtContactEmail.Text.Trim();
            string desc = txtCompanyDesc.Text.Trim();

            try
            {
                string updateSql = @"
                    UPDATE company_table 
                    SET comp_name = @name,
                        industry = @ind,
                        employee_count = @size,
                        website = @web,
                        address = @addr,
                        email_add = @email,
                        description = @desc
                    WHERE company_id = @cid";

                int rows = DBHelper.ExecuteNonQuery(updateSql,
                    new SqlParameter("@name", name),
                    new SqlParameter("@ind", industry),
                    new SqlParameter("@size", size),
                    new SqlParameter("@web", website),
                    new SqlParameter("@addr", address),
                    new SqlParameter("@email", email),
                    new SqlParameter("@desc", desc),
                    new SqlParameter("@cid", companyId)
                );

                if (rows > 0)
                {
                    Session["UserName"] = name;
                    lblSettingsStatus.ForeColor = System.Drawing.Color.Green;
                    lblSettingsStatus.Text = "Company profile updated successfully!";
                }
            }
            catch (Exception ex)
            {
                lblSettingsStatus.ForeColor = System.Drawing.Color.Red;
                lblSettingsStatus.Text = "Save error: " + ex.Message;
            }
        }
    }
}
