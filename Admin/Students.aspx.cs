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
        // [PAGE PROPERTIES]: Real-time Admin Student metrics from SQL Server
        // =========================================================================
        public int TotalStudents { get; set; }
        public int ActiveStudents { get; set; }
        public int PendingStudents { get; set; }
        public int VerifiedProfiles { get; set; }
        public int SuspendedStudents { get; set; }
        public int FilteredStudentsCount { get; set; }
        public string SelectedStudentPhoto { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Admin Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            // Direct Resume Download Handler
            if (Request.QueryString["download_resume"] != null && int.TryParse(Request.QueryString["uid"], out int resumeUid))
            {
                DownloadStudentResume(resumeUid);
                return;
            }

            // Direct Status Toggle Action Handler
            if (!string.IsNullOrEmpty(Request.QueryString["action"]) && int.TryParse(Request.QueryString["id"], out int studentActionId))
            {
                string act = Request.QueryString["action"].ToLower();
                if (act == "toggle")
                {
                    string curStatus = Request.QueryString["status"] ?? "Active";
                    string newStatus = curStatus.Equals("Active", StringComparison.OrdinalIgnoreCase) ? "Suspended" : "Active";
                    try
                    {
                        DBHelper.ExecuteNonQuery("UPDATE user_auth SET account_status = @status WHERE user_id = @id",
                            new SqlParameter("@status", newStatus),
                            new SqlParameter("@id", studentActionId));
                    }
                    catch { }
                }
                Response.Redirect("~/Admin/Students.aspx");
                return;
            }

            if (!IsPostBack)
            {
                PopulateGradYears();
                LoadStudentsData();
            }
        }

        private void PopulateGradYears()
        {
            try
            {
                ddlGradYear.Items.Clear();
                ddlGradYear.Items.Add(new ListItem("All Grad Years", ""));

                DataTable dtYears = DBHelper.ExecuteQuery(
                    "SELECT DISTINCT grad_year FROM member_master_table WHERE grad_year > 0 ORDER BY grad_year DESC");

                foreach (DataRow r in dtYears.Rows)
                {
                    string yr = r["grad_year"].ToString();
                    ddlGradYear.Items.Add(new ListItem("Class of " + yr, yr));
                }

                // Populate Modal Grad Year
                ddlNewStudentGradYear.Items.Clear();
                int currentYr = DateTime.Now.Year;
                for (int y = currentYr + 4; y >= currentYr - 4; y--)
                {
                    ddlNewStudentGradYear.Items.Add(new ListItem("Class of " + y, y.ToString()));
                }
                ddlNewStudentGradYear.SelectedValue = currentYr.ToString();
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Students with Search & Multi-Filters
        // Strict adherence to DATABASE_SCHEMA_REFERENCE.md
        // Joins 'member_master_table' and 'user_auth' to get full dynamic student info
        // =========================================================================
        private void LoadStudentsData()
        {
            string keyword = txtSearchStudent.Text.Trim();
            string statusFilter = ddlStatusFilter.SelectedValue;
            string gradYearFilter = ddlGradYear.SelectedValue;

            DBHelper.EnsureProfilePhotoColumns();

            string sql = @"
                SELECT 
                    m.id AS member_id,
                    m.full_name,
                    m.email_add AS email,
                    m.clg_name,
                    m.city,
                    m.state,
                    m.degree,
                    m.grad_year,
                    m.cgpa,
                    m.skills,
                    m.resume_file,
                    m.profile_photo,
                    ISNULL(u.account_status, 'Active') AS account_status,
                    ISNULL(u.created_at, GETDATE()) AS created_at
                FROM member_master_table m
                LEFT JOIN user_auth u ON m.id = u.user_id
                WHERE (m.category = 'Student' OR m.category IS NULL)";

            var parameters = new List<SqlParameter>();

            if (!string.IsNullOrEmpty(keyword))
            {
                sql += " AND (m.full_name LIKE @q OR m.email_add LIKE @q OR m.skills LIKE @q OR m.clg_name LIKE @q OR m.degree LIKE @q)";
                parameters.Add(new SqlParameter("@q", "%" + keyword + "%"));
            }

            if (!string.IsNullOrEmpty(statusFilter))
            {
                sql += " AND ISNULL(u.account_status, 'Active') = @status";
                parameters.Add(new SqlParameter("@status", statusFilter));
            }

            if (!string.IsNullOrEmpty(gradYearFilter) && int.TryParse(gradYearFilter, out int gYear))
            {
                sql += " AND m.grad_year = @gyear";
                parameters.Add(new SqlParameter("@gyear", gYear));
            }

            sql += " ORDER BY m.id DESC";

            DataTable dt = null;
            try
            {
                dt = DBHelper.ExecuteQuery(sql, parameters.ToArray());
            }
            catch
            {
                // Fallback query if joined structure is different in test environment
                dt = DBHelper.ExecuteQuery(@"
                    SELECT id AS member_id, full_name, email_add AS email, clg_name, city, state, degree, grad_year, cgpa, skills, resume_file, profile_photo,
                           'Active' AS account_status, GETDATE() AS created_at
                    FROM member_master_table 
                    WHERE (category = 'Student' OR category IS NULL) ORDER BY id DESC", parameters.ToArray());
            }

            // ---------------------------------------------------------------------
            // Compute real-time metric counters for top cards from SQL Server
            // ---------------------------------------------------------------------
            try
            {
                object totalObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM member_master_table WHERE category = 'Student' OR category IS NULL");
                TotalStudents = totalObj != null && totalObj != DBNull.Value ? Convert.ToInt32(totalObj) : 0;

                object activeObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM member_master_table m 
                    LEFT JOIN user_auth u ON m.id = u.user_id 
                    WHERE (m.category = 'Student' OR m.category IS NULL) AND ISNULL(u.account_status, 'Active') = 'Active'");
                ActiveStudents = activeObj != null && activeObj != DBNull.Value ? Convert.ToInt32(activeObj) : 0;

                object pendingObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM member_master_table m 
                    INNER JOIN user_auth u ON m.id = u.user_id 
                    WHERE (m.category = 'Student' OR m.category IS NULL) AND u.account_status = 'Pending'");
                PendingStudents = pendingObj != null && pendingObj != DBNull.Value ? Convert.ToInt32(pendingObj) : 0;

                object verifiedObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM member_master_table 
                    WHERE (category = 'Student' OR category IS NULL) 
                      AND (profile_strength >= 80 OR (resume_file IS NOT NULL AND resume_file <> ''))");
                VerifiedProfiles = verifiedObj != null && verifiedObj != DBNull.Value ? Convert.ToInt32(verifiedObj) : ActiveStudents;

                object suspObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM member_master_table m 
                    INNER JOIN user_auth u ON m.id = u.user_id 
                    WHERE (m.category = 'Student' OR m.category IS NULL) AND u.account_status = 'Suspended'");
                SuspendedStudents = suspObj != null && suspObj != DBNull.Value ? Convert.ToInt32(suspObj) : 0;
            }
            catch
            {
                TotalStudents = dt != null ? dt.Rows.Count : 0;
                ActiveStudents = TotalStudents;
                PendingStudents = 0;
                VerifiedProfiles = TotalStudents;
                SuspendedStudents = 0;
            }

            FilteredStudentsCount = dt != null ? dt.Rows.Count : 0;

            var list = new List<dynamic>();

            if (dt != null)
            {
                int index = 0;
                foreach (DataRow row in dt.Rows)
                {
                    string status = row["account_status"] != DBNull.Value ? row["account_status"].ToString().Trim() : "Active";
                    string badgeClass = "badge-status-active";
                    if (status.Equals("Suspended", StringComparison.OrdinalIgnoreCase))
                        badgeClass = "badge-status-suspended";
                    else if (status.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                        badgeClass = "badge-status-pending";

                    string college = row["clg_name"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["clg_name"].ToString())
                        ? row["clg_name"].ToString().Trim()
                        : "University Not Specified";

                    string city = row["city"] != DBNull.Value ? row["city"].ToString().Trim() : "";
                    string state = row["state"] != DBNull.Value ? row["state"].ToString().Trim() : "";
                    string location = !string.IsNullOrEmpty(city)
                        ? (city + (!string.IsNullOrEmpty(state) ? ", " + state : ""))
                        : "India";

                    string degree = row["degree"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["degree"].ToString())
                        ? row["degree"].ToString().Trim()
                        : "Undergraduate";

                    string gradYear = row["grad_year"] != DBNull.Value && Convert.ToInt32(row["grad_year"]) > 0
                        ? "Class of " + row["grad_year"].ToString()
                        : "Class Not Specified";

                    string cgpa = row["cgpa"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["cgpa"].ToString())
                        ? string.Format("{0:0.0}", Convert.ToDecimal(row["cgpa"]))
                        : "N/A";

                    string skills = row["skills"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["skills"].ToString())
                        ? row["skills"].ToString().Trim()
                        : "General";

                    string resumeFile = row["resume_file"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["resume_file"].ToString())
                        ? row["resume_file"].ToString().Trim()
                        : "";

                    string photo = row.Table.Columns.Contains("profile_photo") && row["profile_photo"] != DBNull.Value
                        ? row["profile_photo"].ToString().Trim()
                        : "";

                    if (photo.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                        photo.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        photo = "";
                    }

                    string resolvedPhoto = !string.IsNullOrEmpty(photo) ? DBHelper.ResolveImageUrl(photo, "") : "";

                    if (index == 0)
                    {
                        SelectedStudentPhoto = resolvedPhoto;
                    }

                    list.Add(new
                    {
                        Index = index + 1,
                        MemberId = row["member_id"],
                        FullName = row["full_name"] != DBNull.Value ? row["full_name"].ToString().Trim() : "Student",
                        Email = row["email"] != DBNull.Value ? row["email"].ToString().Trim() : "",
                        College = college,
                        Location = location,
                        Degree = degree,
                        GradYear = gradYear,
                        Cgpa = cgpa,
                        Skills = skills,
                        ResumeFile = resumeFile,
                        ProfilePhotoUrl = resolvedPhoto,
                        AccountStatus = status,
                        StatusBadgeClass = badgeClass,
                        IsSelected = (index == 0) // First student auto-selected for sidebar preview
                    });

                    index++;
                }
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

        protected void ddlGradYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadStudentsData();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearchStudent.Text = "";
            ddlStatusFilter.SelectedIndex = 0;
            ddlGradYear.SelectedIndex = 0;
            lblAdminMessage.Text = "";
            LoadStudentsData();
        }

        // =========================================================================
        // [DATABASE UPDATE]: Toggle Student Account Status (Active <-> Suspended)
        // Updates 'dbo.user_auth' where account_status column resides per schema reference
        // =========================================================================
        protected void rptStudents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                int memberId = Convert.ToInt32(parts[0]);
                string currentStatus = parts[1];

                string newStatus = (currentStatus == "Active") ? "Suspended" : "Active";

                try
                {
                    // Update user_auth where account_status column belongs
                    DBHelper.ExecuteNonQuery(
                        "UPDATE user_auth SET account_status = @status WHERE user_id = @id",
                        new SqlParameter("@status", newStatus),
                        new SqlParameter("@id", memberId));

                    lblAdminMessage.ForeColor = System.Drawing.Color.Green;
                    lblAdminMessage.Text = $"Student account status changed to {newStatus} successfully!";
                }
                catch (Exception ex)
                {
                    lblAdminMessage.ForeColor = System.Drawing.Color.Red;
                    lblAdminMessage.Text = "Status update error: " + ex.Message;
                }

                LoadStudentsData();
            }
        }

        // =========================================================================
        // [ADMIN ACTION]: Add New Student with Credentials into user_auth & member_master_table
        // =========================================================================
        protected void btnSaveNewStudent_Click(object sender, EventArgs e)
        {
            lblNewStudentError.Text = "";

            string name = txtNewStudentName.Text.Trim();
            string email = txtNewStudentEmail.Text.Trim();
            string password = txtNewStudentPassword.Text.Trim();
            string phone = txtNewStudentPhone.Text.Trim().Replace(" ", "");
            string college = txtNewStudentCollege.Text.Trim();
            string degree = txtNewStudentDegree.Text.Trim();
            string skills = txtNewStudentSkills.Text.Trim();
            string city = txtNewStudentCity.Text.Trim();
            string state = ddlNewStudentState.SelectedValue;
            string status = ddlNewStudentStatus.SelectedValue; // "Active" or "Pending"
            
            int gradYear = DateTime.Now.Year;
            if (!string.IsNullOrEmpty(ddlNewStudentGradYear.SelectedValue))
            {
                int.TryParse(ddlNewStudentGradYear.SelectedValue, out gradYear);
            }

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(college) || string.IsNullOrEmpty(city))
            {
                lblNewStudentError.Text = "Please fill in all required fields (Name, Email, Password, Phone, College, City).";
                return;
            }

            if (password.Length < 6)
            {
                lblNewStudentError.Text = "Password must be at least 6 characters long.";
                return;
            }

            try
            {
                // Check if email already registered
                int count = Convert.ToInt32(DBHelper.ExecuteScalar(
                    "SELECT COUNT(1) FROM user_auth WHERE email = @email",
                    new SqlParameter("@email", email)));

                if (count > 0)
                {
                    lblNewStudentError.Text = "An account with this email address already exists.";
                    return;
                }

                int roleId = 2; // Student
                try
                {
                    object rObj = DBHelper.ExecuteScalar("SELECT TOP 1 role_id FROM [dbo].[role] WHERE role_name = 'Student'");
                    if (rObj != null && rObj != DBNull.Value) roleId = Convert.ToInt32(rObj);
                }
                catch { }

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
                                authCmd.Parameters.AddWithValue("@status", status);
                                newUserId = Convert.ToInt32(authCmd.ExecuteScalar());
                            }

                            string insertMemberSql = @"
                                INSERT INTO member_master_table 
                                (id, category, full_name, email_add, ph_no, city, state, clg_name, grad_year, skills, degree, profile_strength)
                                VALUES (@id, 'Student', @fullName, @email, @phone, @city, @state, @college, @gradYear, @skills, @degree, 65)";

                            using (SqlCommand memCmd = new SqlCommand(insertMemberSql, conn, trans))
                            {
                                memCmd.Parameters.AddWithValue("@id", newUserId);
                                memCmd.Parameters.AddWithValue("@fullName", name);
                                memCmd.Parameters.AddWithValue("@email", email);
                                memCmd.Parameters.AddWithValue("@phone", phone);
                                memCmd.Parameters.AddWithValue("@city", city);
                                memCmd.Parameters.AddWithValue("@state", state);
                                memCmd.Parameters.AddWithValue("@college", college);
                                memCmd.Parameters.AddWithValue("@gradYear", gradYear);
                                memCmd.Parameters.AddWithValue("@skills", string.IsNullOrEmpty(skills) ? "C#, ASP.NET, SQL Server" : skills);
                                memCmd.Parameters.AddWithValue("@degree", string.IsNullOrEmpty(degree) ? "B.Tech Computer Science" : degree);
                                memCmd.ExecuteNonQuery();
                            }

                            trans.Commit();

                            // Reset fields
                            txtNewStudentName.Text = "";
                            txtNewStudentEmail.Text = "";
                            txtNewStudentPassword.Text = "";
                            txtNewStudentPhone.Text = "";
                            txtNewStudentCollege.Text = "";
                            txtNewStudentDegree.Text = "";
                            txtNewStudentSkills.Text = "";
                            txtNewStudentCity.Text = "";

                            lblAdminMessage.ForeColor = System.Drawing.Color.Green;
                            lblAdminMessage.Text = $"Student '{name}' registered successfully! Credentials ({email}) are active and ready for login.";

                            LoadStudentsData();
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            lblNewStudentError.Text = "Registration error: " + ex.Message;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblNewStudentError.Text = "System error: " + ex.Message;
            }
        }

        private void DownloadStudentResume(int studentId)
        {
            try
            {
                string resumePath = "";
                string fileName = "";

                object rfObj = DBHelper.ExecuteScalar("SELECT resume_file FROM member_master_table WHERE id = @id",
                    new SqlParameter("@id", studentId));
                if (rfObj != null && rfObj != DBNull.Value && !string.IsNullOrWhiteSpace(rfObj.ToString()))
                {
                    string p = rfObj.ToString().Trim();
                    string virtualPath = p.StartsWith("~") ? p : (p.StartsWith("/") ? "~" + p : "~/Uploads/Resumes/" + p);
                    string localPath = Server.MapPath(virtualPath);
                    if (System.IO.File.Exists(localPath))
                    {
                        resumePath = localPath;
                        fileName = System.IO.Path.GetFileName(localPath);
                    }
                }

                if (string.IsNullOrEmpty(resumePath))
                {
                    string folder = Server.MapPath("~/Uploads/Resumes/");
                    if (System.IO.Directory.Exists(folder))
                    {
                        var files = System.IO.Directory.GetFiles(folder, $"Resume_{studentId}.*");
                        if (files.Length > 0 && System.IO.File.Exists(files[0]))
                        {
                            resumePath = files[0];
                            fileName = System.IO.Path.GetFileName(files[0]);
                        }
                    }
                }

                if (!string.IsNullOrEmpty(resumePath) && System.IO.File.Exists(resumePath))
                {
                    string ext = System.IO.Path.GetExtension(resumePath).ToLower();
                    Response.Clear();
                    Response.ContentType = (ext == ".pdf") ? "application/pdf" : "application/octet-stream";
                    Response.AppendHeader("Content-Disposition", $"attachment; filename={fileName}");
                    Response.TransmitFile(resumePath);
                    Response.End();
                }
                else
                {
                    object studentNameObj = DBHelper.ExecuteScalar("SELECT full_name FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                    string studentName = studentNameObj != null ? studentNameObj.ToString() : "Student";
                    Response.Clear();
                    Response.ContentType = "text/plain";
                    Response.AppendHeader("Content-Disposition", $"attachment; filename=Resume_{studentId}.txt");
                    Response.Write($"Candidate: {studentName}\nID: {studentId}\nStatus: Student Profile Active on SkillLinkX\nGenerated: {DateTime.Now}");
                    Response.End();
                }
            }
            catch (System.Threading.ThreadAbortException) { }
            catch { }
        }
    }
}
