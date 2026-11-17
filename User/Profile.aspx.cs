using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Profile : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Dynamic profile values bound into Profile.aspx
        // =========================================================================
        public string StudentName { get; set; } = "Student";
        public string StudentEmail { get; set; } = "";
        public string StudentCity { get; set; } = "India";
        public string StudentCollege { get; set; } = "Engineering University";
        public string StudentBio { get; set; } = "Aspiring Full Stack Software Developer";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                LoadStudentProfile(studentId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Student Profile Details
        // Queries 'member_master_table' for student info and skill pills
        // =========================================================================
        private void LoadStudentProfile(int studentId)
        {
            string sql = @"
                SELECT full_name, email, skills, created_at
                FROM member_master_table
                WHERE member_id = @id";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@id", studentId));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                StudentName = r["full_name"] != DBNull.Value ? r["full_name"].ToString() : "Student";
                StudentEmail = r["email"] != DBNull.Value ? r["email"].ToString() : "";

                string skillsRaw = r["skills"] != DBNull.Value ? r["skills"].ToString() : "C#, ASP.NET, SQL Server";
                StudentBio = $"Passionate Software Engineer skilled in {skillsRaw}.";

                var skillsList = skillsRaw.Split(new[] { ',', ';', '|' }, StringSplitOptions.RemoveEmptyEntries)
                                          .Select(s => s.Trim()).ToList();

                rptProfileSkills.DataSource = skillsList;
                rptProfileSkills.DataBind();
            }
        }
    }
}
