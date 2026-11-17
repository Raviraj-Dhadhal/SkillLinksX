using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Admin
{
    public partial class Students : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Admin Student metrics
        // =========================================================================
        public int TotalStudents { get; set; }
        public int ActiveStudents { get; set; }
        public int PendingStudents { get; set; }
        public int SuspendedStudents { get; set; }

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
                LoadStudentsData();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Students with Search & Filter
        // Queries 'member_master_table' where role = 'Student'.
        // Calculates metrics and populates the table repeater.
        // =========================================================================
        private void LoadStudentsData()
        {
            string keyword = txtSearchStudent.Text.Trim();
            string statusFilter = ddlStatusFilter.SelectedValue;

            string sql = @"
                SELECT id AS member_id, full_name, email_add AS email, skills, 'Active' AS account_status, GETDATE() AS created_at 
                FROM member_master_table 
                WHERE (category = 'Student' OR category IS NULL)";

            var parameters = new List<SqlParameter>();

            if (!string.IsNullOrEmpty(keyword))
            {
                sql += " AND (full_name LIKE @q OR email_add LIKE @q OR skills LIKE @q)";
                parameters.Add(new SqlParameter("@q", "%" + keyword + "%"));
            }

            if (!string.IsNullOrEmpty(statusFilter))
            {
                sql += " AND 'Active' = @status";
                parameters.Add(new SqlParameter("@status", statusFilter));
            }

            sql += " ORDER BY id DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters.ToArray());

            // ---------------------------------------------------------------------
            // Step 2: Compute real-time metric counters for top cards
            // ---------------------------------------------------------------------
            object totalObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM member_master_table WHERE category = 'Student' OR category IS NULL");
            TotalStudents = totalObj != null ? Convert.ToInt32(totalObj) : 0;

            object activeObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM member_master_table WHERE (category = 'Student' OR category IS NULL)");
            ActiveStudents = activeObj != null ? Convert.ToInt32(activeObj) : 0;

            PendingStudents = 0;
            SuspendedStudents = 0;

            var list = new List<dynamic>();

            foreach (DataRow row in dt.Rows)
            {
                string status = row["account_status"] != DBNull.Value ? row["account_status"].ToString() : "Active";
                string badgeClass = "badge-status-active";
                if (status.Equals("Suspended", StringComparison.OrdinalIgnoreCase))
                    badgeClass = "badge-status-suspended";
                else if (status.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                    badgeClass = "badge-status-pending";

                DateTime joined = row["created_at"] != DBNull.Value ? Convert.ToDateTime(row["created_at"]) : DateTime.Now;

                list.Add(new
                {
                    MemberId = row["member_id"],
                    FullName = row["full_name"].ToString(),
                    Email = row["email"].ToString(),
                    Skills = row["skills"] != DBNull.Value ? row["skills"].ToString() : "Not Specified",
                    AccountStatus = status,
                    StatusBadgeClass = badgeClass,
                    JoinedDate = joined.ToString("MMM yyyy")
                });
            }

            rptStudents.DataSource = list;
            rptStudents.DataBind();
        }

        protected void txtSearchStudent_TextChanged(object sender, EventArgs e)
        {
            LoadStudentsData();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadStudentsData();
        }

        // =========================================================================
        // [DATABASE UPDATE]: Toggle Student Account Status (Active <-> Suspended)
        // =========================================================================
        protected void rptStudents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                int memberId = Convert.ToInt32(parts[0]);
                string currentStatus = parts[1];

                string newStatus = (currentStatus == "Active") ? "Suspended" : "Active";

                DBHelper.ExecuteNonQuery(
                    "UPDATE member_master_table SET account_status = @status WHERE id = @id",
                    new SqlParameter("@status", newStatus),
                    new SqlParameter("@id", memberId)
                );

                lblAdminMessage.Text = $"Student account #{memberId} status updated to '{newStatus}'.";
                LoadStudentsData();
            }
        }
    }
}
