using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class InternshipDetails : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Internship Information
        // =========================================================================
        public int InternshipId { get; set; } = 1;
        public string InternshipTitle { get; set; } = "Software Development Intern";
        public string CompanyName { get; set; } = "Tech Company";
        public string Location { get; set; } = "Bengaluru";
        public string JobType { get; set; } = "Internship";
        public string SalaryRange { get; set; } = "₹20,000 / month";
        public int AiMatchScore { get; set; } = 92;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (Request.QueryString["id"] != null)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    InternshipId = id;
                }
            }

            if (!IsPostBack)
            {
                LoadInternshipDetails();
                CheckAlreadyApplied();
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Internship by ID
        // =========================================================================
        private void LoadInternshipDetails()
        {
            string sql = @"
                SELECT i.internship_id AS job_id, i.internship_title AS title, i.location_type AS location, 'Internship' AS job_type, 
                       ('₹' + CAST(CAST(i.stipend_amount AS INT) AS NVARCHAR) + ' / mo') AS salary_range, 
                       i.skills_required AS required_skills,
                       c.comp_name AS company_name
                FROM internships i
                INNER JOIN company_table c ON i.company_id = c.company_id
                WHERE i.internship_id = @id";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", InternshipId));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                InternshipTitle = r["title"].ToString();
                CompanyName = r["company_name"].ToString();
                Location = r["location"].ToString();
                JobType = r["job_type"].ToString();
                SalaryRange = r["salary_range"] != DBNull.Value ? r["salary_range"].ToString() : "Stipend Provided";

                string reqSkills = r["required_skills"] != DBNull.Value ? r["required_skills"].ToString() : "C#, SQL";
                var skillsList = reqSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                          .Select(s => s.Trim()).ToList();

                rptRequiredSkills.DataSource = skillsList;
                rptRequiredSkills.DataBind();

                // Compute AI match score against student skills
                int studentId = Convert.ToInt32(Session["UserId"]);
                object sObj = DBHelper.ExecuteScalar("SELECT skills FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                string studentSkills = sObj != null ? sObj.ToString() : "C#";

                AiMatchScore = AIService.CalculateMatchScore(studentSkills, reqSkills);
            }
        }

        private void CheckAlreadyApplied()
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            object existing = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM applications WHERE user_id = @sid AND job_id = @jid",
                new SqlParameter("@sid", studentId),
                new SqlParameter("@jid", InternshipId)
            );

            if (existing != null && Convert.ToInt32(existing) > 0)
            {
                btnApplyInternship.Enabled = false;
                btnApplyInternship.Text = "Already Applied";
                btnApplyInternship.CssClass += " btn-disabled";
                lblApplyFeedback.ForeColor = System.Drawing.Color.Blue;
                lblApplyFeedback.Text = "You have already applied for this internship position.";
            }
        }

        // =========================================================================
        // [DATABASE INSERT]: "Apply Now" Event Handler
        // =========================================================================
        protected void btnApplyInternship_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);

            try
            {
                // Query company_id for this internship to satisfy NOT NULL constraint
                object cObj = DBHelper.ExecuteScalar("SELECT company_id FROM internships WHERE internship_id = @id", new SqlParameter("@id", InternshipId));
                int companyId = (cObj != null && cObj != DBNull.Value) ? Convert.ToInt32(cObj) : 1;

                string sql = @"
                    INSERT INTO applications (internship_id, user_id, company_id, status, applied_at, updated_at, resume_file_path, cover_letter) 
                    VALUES (@iid, @sid, @cid, 'Applied', GETDATE(), GETDATE(), 'Resume_Uploaded.pdf', 'Applied via SkillLinksX platform')";

                int rows = DBHelper.ExecuteNonQuery(
                    sql,
                    new SqlParameter("@iid", InternshipId),
                    new SqlParameter("@sid", studentId),
                    new SqlParameter("@cid", companyId)
                );

                if (rows > 0)
                {
                    btnApplyInternship.Enabled = false;
                    btnApplyInternship.Text = "Applied Successfully";
                    lblApplyFeedback.ForeColor = System.Drawing.Color.Green;
                    lblApplyFeedback.Text = "Internship application submitted! Track progress in Applications.";
                }
            }
            catch (Exception ex)
            {
                lblApplyFeedback.ForeColor = System.Drawing.Color.Red;
                lblApplyFeedback.Text = "Error: " + ex.Message;
            }
        }
    }
}
