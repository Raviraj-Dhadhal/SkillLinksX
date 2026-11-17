using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class CandidateProfile : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Candidate details bound to the layout
        // =========================================================================
        public string CandidateName { get; set; } = "Candidate";
        public string CandidateTitle { get; set; } = "Full Stack Developer";
        public string CandidateEmail { get; set; } = "";
        public string CandidateCity { get; set; } = "India";
        public string CandidateCollege { get; set; } = "Engineering College";
        public int CandidateMatchScore { get; set; } = 92;
        public int StudentId { get; set; } = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (Request.QueryString["id"] != null)
            {
                int sid;
                if (int.TryParse(Request.QueryString["id"], out sid))
                {
                    StudentId = sid;
                }
            }

            if (!IsPostBack)
            {
                LoadCandidateProfile();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Candidate Profile from DB
        // Queries 'member_master_table' for candidate credentials and skills
        // =========================================================================
        private void LoadCandidateProfile()
        {
            string sql = @"
                SELECT full_name, email_add, skills
                FROM member_master_table
                WHERE id = @id";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", StudentId));

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                CandidateName = row["full_name"] != DBNull.Value ? row["full_name"].ToString() : "Candidate";
                CandidateEmail = row["email_add"] != DBNull.Value ? row["email_add"].ToString() : "";

                string skills = row["skills"] != DBNull.Value ? row["skills"].ToString() : "C#, SQL, ASP.NET";
                CandidateTitle = $"Software Engineer ({skills})";

                // Evaluate match score against company primary job requirements
                CandidateMatchScore = AIService.CalculateMatchScore(skills, "C#, ASP.NET, SQL Server");
            }
        }

        // =========================================================================
        // [DATABASE UPDATE]: Shortlist Candidate
        // Updates application status for this candidate to 'Shortlisted'
        // =========================================================================
        protected void btnShortlistCandidate_Click(object sender, EventArgs e)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;

            try
            {
                DBHelper.ExecuteNonQuery(@"
                    UPDATE a
                    SET a.status = 'Shortlisted'
                    FROM applications a
                    INNER JOIN jobs j ON a.job_id = j.job_id
                    WHERE a.user_id = @sid AND j.company_id = @cid",
                    new SqlParameter("@sid", StudentId),
                    new SqlParameter("@cid", companyId)
                );

                lblActionStatus.Text = "Candidate successfully marked as 'Shortlisted'!";
            }
            catch (Exception ex)
            {
                lblActionStatus.ForeColor = System.Drawing.Color.Red;
                lblActionStatus.Text = "Error: " + ex.Message;
            }
        }
    }
}
