using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class ManageInternships : Page
    {
        public int TotalInternshipsCount { get; set; } = 0;
        public int ActiveInternshipsCount { get; set; } = 0;
        public int DraftsCount { get; set; } = 0;
        public int TotalApplicationsCount { get; set; } = 0;

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
                LoadCompanyInternships(companyId);
            }
        }

        private void LoadCompanyInternships(int companyId)
        {
            try
            {
                string sql = @"
                    SELECT i.internship_id, i.internship_title, i.location_type, i.duration_months,
                           i.stipend_amount, i.status, i.created_at,
                           (SELECT COUNT(*) FROM applications a WHERE a.internship_id = i.internship_id) AS ApplicationCount
                    FROM internships i
                    WHERE i.company_id = @cid
                    ORDER BY i.created_at DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));

                TotalInternshipsCount = dt.Rows.Count;
                ActiveInternshipsCount = 0;
                DraftsCount = 0;
                TotalApplicationsCount = 0;

                var list = new List<dynamic>();

                foreach (DataRow r in dt.Rows)
                {
                    string status = r["status"] != DBNull.Value ? r["status"].ToString() : "Active";
                    int appCount = Convert.ToInt32(r["ApplicationCount"]);
                    TotalApplicationsCount += appCount;

                    if (status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                        ActiveInternshipsCount++;
                    else
                        DraftsCount++;

                    DateTime dtCreated = Convert.ToDateTime(r["created_at"]);
                    string stipend = r["stipend_amount"] != DBNull.Value ? $"₹{r["stipend_amount"]}/mo" : "Unpaid";

                    list.Add(new
                    {
                        InternshipId = r["internship_id"],
                        Title = r["internship_title"].ToString(),
                        Location = r["location_type"] != DBNull.Value ? r["location_type"].ToString() : "On-site",
                        Duration = r["duration_months"] != DBNull.Value ? $"{r["duration_months"]} Months" : "3 Months",
                        Stipend = stipend,
                        ApplicationCount = appCount,
                        PostedDate = dtCreated.ToString("MMM dd, yyyy"),
                        Status = status
                    });
                }

                rptInternships.DataSource = list;
                rptInternships.DataBind();
            }
            catch
            {
                // Graceful fallback
            }
        }

        protected void rptInternships_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
            int internshipId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ToggleStatus")
            {
                DBHelper.ExecuteNonQuery(@"
                    UPDATE internships 
                    SET status = CASE WHEN status = 'Active' THEN 'Closed' ELSE 'Active' END 
                    WHERE internship_id = @id AND company_id = @cid",
                    new SqlParameter("@id", internshipId),
                    new SqlParameter("@cid", companyId)
                );
                LoadCompanyInternships(companyId);
            }
            else if (e.CommandName == "DeleteInternship")
            {
                DBHelper.ExecuteNonQuery(@"
                    DELETE FROM internships WHERE internship_id = @id AND company_id = @cid",
                    new SqlParameter("@id", internshipId),
                    new SqlParameter("@cid", companyId)
                );
                LoadCompanyInternships(companyId);
            }
        }
    }
}
