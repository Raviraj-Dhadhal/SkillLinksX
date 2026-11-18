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

            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

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
            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
            int internshipId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ToggleStatus")
            {
                try
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE internships 
                        SET status = CASE WHEN status = 'Active' THEN 'Closed' ELSE 'Active' END 
                        WHERE internship_id = @id AND company_id = @cid",
                        new SqlParameter("@id", internshipId),
                        new SqlParameter("@cid", companyId)
                    );
                    lblActionMessage.ForeColor = System.Drawing.Color.Green;
                    lblActionMessage.Text = "Internship status toggled successfully.";
                    LoadCompanyInternships(companyId);
                }
                catch (Exception ex)
                {
                    lblActionMessage.ForeColor = System.Drawing.Color.Red;
                    lblActionMessage.Text = "Status update error: " + ex.Message;
                }
            }
            else if (e.CommandName == "DeleteInternship")
            {
                try
                {
                    // 1. Delete linked interviews first
                    try
                    {
                        DBHelper.ExecuteNonQuery(@"
                            DELETE FROM interviews 
                            WHERE application_id IN (SELECT application_id FROM applications WHERE internship_id = @id)",
                            new SqlParameter("@id", internshipId));
                    }
                    catch { }

                    // 2. Delete linked student applications
                    try
                    {
                        DBHelper.ExecuteNonQuery(
                            "DELETE FROM applications WHERE internship_id = @id",
                            new SqlParameter("@id", internshipId));
                    }
                    catch { }

                    // 3. Delete from saved_jobs (resolves FK_saved_jobs_internship)
                    try
                    {
                        DBHelper.ExecuteNonQuery(
                            "DELETE FROM saved_jobs WHERE internship_id = @id",
                            new SqlParameter("@id", internshipId));
                    }
                    catch { }

                    // 4. Delete the internship record itself
                    int rows = DBHelper.ExecuteNonQuery(@"
                        DELETE FROM internships WHERE internship_id = @id AND company_id = @cid",
                        new SqlParameter("@id", internshipId),
                        new SqlParameter("@cid", companyId)
                    );

                    lblActionMessage.ForeColor = System.Drawing.Color.Green;
                    lblActionMessage.Text = "Internship deleted successfully.";
                    LoadCompanyInternships(companyId);
                }
                catch (Exception ex)
                {
                    lblActionMessage.ForeColor = System.Drawing.Color.Red;
                    lblActionMessage.Text = "Delete error: " + ex.Message;
                }
            }
        }
    }
}
