using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace SkillLinksX.Helpers
{
    public static class DBHelper
    {
        public static string ConnectionString
        {
            get
            {
                var css = ConfigurationManager.ConnectionStrings["SkillLinksXDB"];
                if (css != null && !string.IsNullOrEmpty(css.ConnectionString))
                    return css.ConnectionString;
                return @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=c:\Project ASP NET\SkillLinksX\App_Data\Database.mdf;Integrated Security=True";
            }
        }

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(ConnectionString);
        }

        // =========================================================================
        // [DATABASE ACCESS]: Fetch DataTable (for Repeaters, GridViews)
        // =========================================================================
        public static DataTable ExecuteQuery(string query, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null && parameters.Length > 0) cmd.Parameters.AddRange(parameters);
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        var dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: INSERT / UPDATE / DELETE
        // =========================================================================
        public static int ExecuteNonQuery(string query, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null && parameters.Length > 0) cmd.Parameters.AddRange(parameters);
                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: COUNT / single value / SCOPE_IDENTITY
        // =========================================================================
        public static object ExecuteScalar(string query, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null && parameters.Length > 0) cmd.Parameters.AddRange(parameters);
                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Check if column exists in table schema
        // =========================================================================
        public static bool ColumnExists(string tableName, string columnName)
        {
            try
            {
                object res = ExecuteScalar(
                    "SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @t AND COLUMN_NAME = @c",
                    new SqlParameter("@t", tableName),
                    new SqlParameter("@c", columnName));
                return res != null && res != DBNull.Value;
            }
            catch { return false; }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee profile_photo columns exist
        // =========================================================================
        public static void EnsureProfilePhotoColumns()
        {
            try
            {
                string sql = @"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'user_auth' AND COLUMN_NAME = 'profile_photo')
                    BEGIN
                        ALTER TABLE user_auth ADD profile_photo NVARCHAR(300) NULL;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'user_auth' AND COLUMN_NAME = 'full_name')
                    BEGIN
                        ALTER TABLE user_auth ADD full_name NVARCHAR(150) NULL;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'user_auth' AND COLUMN_NAME = 'phone')
                    BEGIN
                        ALTER TABLE user_auth ADD phone NVARCHAR(20) NULL;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'member_master_table' AND COLUMN_NAME = 'profile_photo')
                    BEGIN
                        ALTER TABLE member_master_table ADD profile_photo NVARCHAR(300) NULL;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'profile_photo')
                    BEGIN
                        ALTER TABLE company_table ADD profile_photo NVARCHAR(300) NULL;
                    END;";
                ExecuteNonQuery(sql);
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee company columns exist
        // =========================================================================
        public static void EnsureCompanyColumns()
        {
            try
            {
                string sql = @"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'user_id')
                        ALTER TABLE company_table ADD user_id INT NULL;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'industry')
                        ALTER TABLE company_table ADD industry NVARCHAR(100) NULL;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'description')
                        ALTER TABLE company_table ADD description NVARCHAR(MAX) NULL;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'website')
                        ALTER TABLE company_table ADD website NVARCHAR(200) NULL;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'employee_count')
                        ALTER TABLE company_table ADD employee_count NVARCHAR(50) NULL;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'profile_strength')
                        ALTER TABLE company_table ADD profile_strength INT NULL;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'is_verified')
                        ALTER TABLE company_table ADD is_verified BIT DEFAULT 0;

                    -- Heal corrupted data: Unlink legacy TechNova company from accounts that are not TechNova
                    UPDATE company_table 
                    SET user_id = 0 
                    WHERE (company_id = 1 OR comp_name LIKE '%TechNova%')
                      AND user_id > 0
                      AND user_id IN (
                          SELECT user_id FROM user_auth 
                          WHERE LOWER(email) NOT LIKE '%technova%'
                      );

                    -- Link company users in user_auth to their own company_table rows matching their email
                    UPDATE c
                    SET c.user_id = u.user_id
                    FROM company_table c
                    INNER JOIN user_auth u ON LOWER(c.email_add) = LOWER(u.email)
                    WHERE u.role_id IN (SELECT role_id FROM role WHERE role_name LIKE '%Comp%')
                      AND (c.user_id IS NULL OR c.user_id = 0 OR c.user_id != u.user_id);
                ";
                ExecuteNonQuery(sql);
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee audit log and contact inquiries tables exist
        // =========================================================================
        public static void EnsureAuditLogTable()
        {
            try
            {
                string sqlInquiries = @"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'contact_inquiries')
                    BEGIN
                        CREATE TABLE [dbo].[contact_inquiries] (
                            [inquiry_id] INT IDENTITY(1,1) PRIMARY KEY,
                            [name] NVARCHAR(150) NOT NULL,
                            [email] NVARCHAR(150) NOT NULL,
                            [role] NVARCHAR(50) NULL,
                            [subject] NVARCHAR(250) NULL,
                            [message] NVARCHAR(MAX) NULL,
                            [status] NVARCHAR(50) DEFAULT 'Pending',
                            [created_at] DATETIME DEFAULT GETDATE()
                        );
                    END";
                ExecuteNonQuery(sqlInquiries);
            }
            catch { }

            try
            {
                string sqlLogs = @"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'admin_audit_logs')
                    BEGIN
                        CREATE TABLE [dbo].[admin_audit_logs] (
                            [log_id] INT IDENTITY(1,1) PRIMARY KEY,
                            [action] NVARCHAR(100) NOT NULL,
                            [details] NVARCHAR(MAX) NULL,
                            [created_at] DATETIME DEFAULT GETDATE()
                        );
                    END";
                ExecuteNonQuery(sqlLogs);
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee notification columns exist
        // =========================================================================
        public static void EnsureNotificationColumns()
        {
            try
            {
                string sql = @"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'notifications' AND COLUMN_NAME = 'category')
                    BEGIN
                        ALTER TABLE notifications ADD category NVARCHAR(100) NULL;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'notifications' AND COLUMN_NAME = 'link_url')
                    BEGIN
                        ALTER TABLE notifications ADD link_url NVARCHAR(300) NULL;
                    END;";
                ExecuteNonQuery(sql);
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee interview schema flexibility
        // =========================================================================
        public static void EnsureInterviewColumns()
        {
            try
            {
                string sql = @"
                    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'interviews' AND COLUMN_NAME = 'application_id' AND IS_NULLABLE = 'NO')
                    BEGIN
                        ALTER TABLE interviews ALTER COLUMN application_id INT NULL;
                    END;
                    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'interviews' AND COLUMN_NAME = 'interview_time' AND IS_NULLABLE = 'NO')
                    BEGIN
                        ALTER TABLE interviews ALTER COLUMN interview_time TIME NULL;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'interviews' AND COLUMN_NAME = 'candidate_name')
                    BEGIN
                        ALTER TABLE interviews ADD candidate_name NVARCHAR(200) NULL;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'interviews' AND COLUMN_NAME = 'job_title')
                    BEGIN
                        ALTER TABLE interviews ADD job_title NVARCHAR(200) NULL;
                    END;
                    -- Backfill existing legacy records if empty
                    UPDATE i
                    SET i.candidate_name = m.full_name
                    FROM interviews i
                    INNER JOIN member_master_table m ON i.user_id = m.id
                    WHERE i.candidate_name IS NULL OR i.candidate_name = '';

                    UPDATE interviews 
                    SET job_title = SUBSTRING(notes, 21, 200)
                    WHERE (job_title IS NULL OR job_title = '') AND notes LIKE 'Interview round for %';";
                ExecuteNonQuery(sql);
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee views_count column on jobs and internships
        // =========================================================================
        public static void EnsureJobViewsColumn()
        {
            try
            {
                string sql = @"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'jobs' AND COLUMN_NAME = 'views_count')
                    BEGIN
                        ALTER TABLE jobs ADD views_count INT NOT NULL DEFAULT 0;
                    END;
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'internships' AND COLUMN_NAME = 'views_count')
                    BEGIN
                        ALTER TABLE internships ADD views_count INT NOT NULL DEFAULT 0;
                    END;";
                ExecuteNonQuery(sql);
            }
            catch { }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee profile_strength column & calculate unified score
        // =========================================================================
        public static int GetStudentProfileStrength(int studentId)
        {
            try
            {
                // Ensure profile_strength column exists
                ExecuteNonQuery(@"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'member_master_table' AND COLUMN_NAME = 'profile_strength')
                    BEGIN
                        ALTER TABLE member_master_table ADD profile_strength INT NULL;
                    END;");

                DataTable dt = ExecuteQuery(@"
                    SELECT id, skills, tagline, about_text, resume_file, portfolio_url, linkedin_url, github_url, profile_strength
                    FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    if (r["profile_strength"] != DBNull.Value && Convert.ToInt32(r["profile_strength"]) > 0)
                    {
                        return Convert.ToInt32(r["profile_strength"]);
                    }

                    int strength = 50;
                    string about = r["about_text"] != DBNull.Value ? r["about_text"].ToString().Trim() : "";
                    string tag = r["tagline"] != DBNull.Value ? r["tagline"].ToString().Trim() : "";
                    string port = r["portfolio_url"] != DBNull.Value ? r["portfolio_url"].ToString().Trim() : "";
                    string resume = r["resume_file"] != DBNull.Value ? r["resume_file"].ToString().Trim() : "";
                    string gh = r["github_url"] != DBNull.Value ? r["github_url"].ToString().Trim() : "";
                    string li = r["linkedin_url"] != DBNull.Value ? r["linkedin_url"].ToString().Trim() : "";

                    if (about.Length > 10) strength += 5;
                    if (!string.IsNullOrEmpty(tag)) strength += 10;
                    if (!string.IsNullOrEmpty(gh) || !string.IsNullOrEmpty(li)) strength += 5;
                    if (!string.IsNullOrEmpty(port)) strength += 15;
                    if (!string.IsNullOrEmpty(resume)) strength += 15;

                    strength = Math.Min(100, Math.Max(50, strength));
                    ExecuteNonQuery("UPDATE member_master_table SET profile_strength = @str WHERE id = @id",
                        new SqlParameter("@str", strength),
                        new SqlParameter("@id", studentId));

                    return strength;
                }
            }
            catch { }
            return 50;
        }

        // =========================================================================
        // [DATABASE ACCESS]: Guarantee company profile_strength & calculate score
        // Accurately calculates from 0% to 100% based on completed company fields
        // =========================================================================
        public static int GetCompanyProfileStrength(int companyId)
        {
            try
            {
                if (companyId <= 0) return 0;

                // Ensure profile_strength column exists in company_table
                ExecuteNonQuery(@"
                    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'company_table' AND COLUMN_NAME = 'profile_strength')
                    BEGIN
                        ALTER TABLE company_table ADD profile_strength INT NULL;
                    END;");

                DataTable dt = ExecuteQuery(@"
                    SELECT comp_name, email_add, ph_no, city, address, industry, description, website, employee_count, profile_photo
                    FROM company_table WHERE company_id = @cid", new SqlParameter("@cid", companyId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    int strength = 0;

                    string name = r["comp_name"] != DBNull.Value ? r["comp_name"].ToString().Trim() : "";
                    string email = r["email_add"] != DBNull.Value ? r["email_add"].ToString().Trim() : "";
                    string phone = r["ph_no"] != DBNull.Value ? r["ph_no"].ToString().Trim() : "";
                    string city = r["city"] != DBNull.Value ? r["city"].ToString().Trim() : "";
                    string addr = r["address"] != DBNull.Value ? r["address"].ToString().Trim() : "";
                    string desc = r.Table.Columns.Contains("description") && r["description"] != DBNull.Value ? r["description"].ToString().Trim() : "";
                    string web = r.Table.Columns.Contains("website") && r["website"] != DBNull.Value ? r["website"].ToString().Trim() : "";
                    string ind = r.Table.Columns.Contains("industry") && r["industry"] != DBNull.Value ? r["industry"].ToString().Trim() : "";
                    string emp = r.Table.Columns.Contains("employee_count") && r["employee_count"] != DBNull.Value ? r["employee_count"].ToString().Trim() : "";
                    string photo = r.Table.Columns.Contains("profile_photo") && r["profile_photo"] != DBNull.Value ? r["profile_photo"].ToString().Trim() : "";

                    if (!string.IsNullOrEmpty(name) && !name.Equals("Company", StringComparison.OrdinalIgnoreCase)) strength += 15;
                    if (!string.IsNullOrEmpty(email)) strength += 10;
                    if (!string.IsNullOrEmpty(phone)) strength += 10;
                    if (!string.IsNullOrEmpty(city) || !string.IsNullOrEmpty(addr)) strength += 10;
                    if (!string.IsNullOrEmpty(ind) && !ind.Equals("Industry Not Specified", StringComparison.OrdinalIgnoreCase)) strength += 15;
                    if (!string.IsNullOrEmpty(desc) && desc.Length > 15) strength += 15;
                    if (!string.IsNullOrEmpty(web) && web.Length > 4) strength += 10;
                    if (!string.IsNullOrEmpty(emp) && !emp.Equals("Size Not Specified", StringComparison.OrdinalIgnoreCase)) strength += 5;
                    if (!string.IsNullOrEmpty(photo)) strength += 10;

                    strength = Math.Min(100, Math.Max(0, strength));

                    ExecuteNonQuery("UPDATE company_table SET profile_strength = @str WHERE company_id = @cid",
                        new SqlParameter("@str", strength),
                        new SqlParameter("@cid", companyId));

                    return strength;
                }
            }
            catch { }
            return 0;
        }

        // =========================================================================
        // [NOTIFICATIONS HELPER]: Universal notification sender
        // Uses the official schema: user_id, title, message, target_url, is_read, created_at
        // =========================================================================
        public static void SendNotification(int userId, string title, string message, string targetUrl = "")
        {
            if (userId <= 0 || string.IsNullOrEmpty(title) || string.IsNullOrEmpty(message)) return;
            if (string.IsNullOrEmpty(targetUrl)) targetUrl = "~/User/Dashboard.aspx";

            try
            {
                string sql = @"
                    INSERT INTO notifications (user_id, title, message, target_url, is_read, created_at)
                    VALUES (@uid, @title, @msg, @url, 0, GETDATE())";

                ExecuteNonQuery(sql,
                    new SqlParameter("@uid", userId),
                    new SqlParameter("@title", title),
                    new SqlParameter("@msg", message),
                    new SqlParameter("@url", targetUrl));
            }
            catch { }
        }

        // =========================================================================
        // [MESSAGES HELPER]: Universal direct message sender
        // Uses the official schema: sender_id, receiver_id, subject, message_text, is_read, sent_at
        // =========================================================================
        public static bool SendDirectMessage(int senderId, int receiverId, string messageText, string subject = "Message")
        {
            if (senderId <= 0 || receiverId <= 0 || string.IsNullOrWhiteSpace(messageText)) return false;
            if (string.IsNullOrWhiteSpace(subject)) subject = "Message";

            try
            {
                string sql = @"
                    INSERT INTO messages (sender_id, receiver_id, subject, message_text, is_read, sent_at)
                    VALUES (@sid, @rid, @subj, @msg, 0, GETDATE())";

                int rows = ExecuteNonQuery(sql,
                    new SqlParameter("@sid", senderId),
                    new SqlParameter("@rid", receiverId),
                    new SqlParameter("@subj", subject),
                    new SqlParameter("@msg", messageText.Trim()));

                // Also notify receiver about the message
                try
                {
                    string senderName = "Someone";
                    object nameObj = ExecuteScalar("SELECT full_name FROM member_master_table WHERE id = @id", new SqlParameter("@id", senderId));
                    if (nameObj != null && nameObj != DBNull.Value)
                    {
                        senderName = nameObj.ToString();
                    }
                    else
                    {
                        object compObj = ExecuteScalar("SELECT comp_name FROM company_table WHERE user_id = @uid", new SqlParameter("@uid", senderId));
                        if (compObj != null && compObj != DBNull.Value) senderName = compObj.ToString();
                    }

                    string preview = messageText.Trim();
                    if (preview.Length > 60) preview = preview.Substring(0, 57) + "...";

                    SendNotification(receiverId, $"New message from {senderName}", preview, "~/User/Messages.aspx");
                }
                catch { }

                return rows > 0;
            }
            catch
            {
                return false;
            }
        }

        // =========================================================================
        // [COMPANY HELPER]: Resolves company_id for the logged-in user_auth.user_id
        // Dynamically queries company_table. Never falls back to hardcoded company 1.
        // =========================================================================
        public static int GetCurrentCompanyId(int userId, System.Web.SessionState.HttpSessionState session = null)
        {
            if (userId <= 0 && session != null && session["UserId"] != null)
            {
                int.TryParse(session["UserId"].ToString(), out userId);
            }

            if (userId > 0)
            {
                try
                {
                    EnsureCompanyColumns();

                    string email = session != null && session["Email"] != null ? session["Email"].ToString().Trim() : "";
                    if (string.IsNullOrEmpty(email))
                    {
                        object emailObj = ExecuteScalar("SELECT email FROM user_auth WHERE user_id = @uid", new SqlParameter("@uid", userId));
                        if (emailObj != null && emailObj != DBNull.Value) email = emailObj.ToString().Trim();
                    }

                    // 1. First priority: match company_table row where BOTH user_id and email match
                    if (!string.IsNullOrEmpty(email))
                    {
                        object exactCid = ExecuteScalar(@"
                            SELECT TOP 1 company_id 
                            FROM company_table 
                            WHERE user_id = @uid AND LOWER(email_add) = LOWER(@email)
                            ORDER BY company_id DESC",
                            new SqlParameter("@uid", userId),
                            new SqlParameter("@email", email));

                        if (exactCid != null && exactCid != DBNull.Value && Convert.ToInt32(exactCid) > 0)
                        {
                            int cid = Convert.ToInt32(exactCid);
                            if (session != null) session["CompanyId"] = cid;
                            return cid;
                        }

                        // 2. Second priority: match company_table row by user's verified email
                        object emailCid = ExecuteScalar(@"
                            SELECT TOP 1 company_id 
                            FROM company_table 
                            WHERE LOWER(email_add) = LOWER(@email)
                            ORDER BY company_id DESC",
                            new SqlParameter("@email", email));

                        if (emailCid != null && emailCid != DBNull.Value && Convert.ToInt32(emailCid) > 0)
                        {
                            int cid = Convert.ToInt32(emailCid);
                            ExecuteNonQuery("UPDATE company_table SET user_id = @uid WHERE company_id = @cid",
                                new SqlParameter("@uid", userId),
                                new SqlParameter("@cid", cid));
                            if (session != null) session["CompanyId"] = cid;
                            return cid;
                        }
                    }

                    // 3. Third priority: match by user_id alone (EXCLUDE TechNova unless user's email is technova)
                    object obj = ExecuteScalar(@"
                        SELECT TOP 1 company_id 
                        FROM company_table 
                        WHERE user_id = @uid 
                          AND (comp_name NOT LIKE '%TechNova%' OR LOWER(@email) LIKE '%technova%')
                        ORDER BY company_id DESC",
                        new SqlParameter("@uid", userId),
                        new SqlParameter("@email", email));

                    if (obj != null && obj != DBNull.Value && Convert.ToInt32(obj) > 0)
                    {
                        int cid = Convert.ToInt32(obj);
                        if (session != null) session["CompanyId"] = cid;
                        return cid;
                    }

                    // 4. If this is a company user who doesn't have a row in company_table yet, auto-provision a fresh isolated row!
                    if (session == null || session["Role"] == null || session["Role"]?.ToString() == "Company")
                    {
                        string name = session != null && session["UserName"] != null ? session["UserName"].ToString().Trim() : "Company";
                        if (string.IsNullOrEmpty(name) || name == "Admin" || name == "Company")
                        {
                            name = !string.IsNullOrEmpty(email) ? email.Split('@')[0] : "New Company";
                            if (name.Length > 0) name = char.ToUpper(name[0]) + (name.Length > 1 ? name.Substring(1) : "");
                        }

                        object newCid = ExecuteScalar(@"
                            INSERT INTO company_table (user_id, comp_name, email_add, ph_no, city, state, address, is_verified, profile_strength)
                            VALUES (@uid, @cname, @email, '', '', '', '', 0, 0);
                            SELECT SCOPE_IDENTITY();",
                            new SqlParameter("@uid", userId),
                            new SqlParameter("@cname", name),
                            new SqlParameter("@email", email));

                        if (newCid != null && newCid != DBNull.Value)
                        {
                            int cid = Convert.ToInt32(newCid);
                            if (session != null)
                            {
                                session["CompanyId"] = cid;
                                session["UserName"] = name;
                                session["CompanyName"] = name;
                            }
                            return cid;
                        }
                    }
                }
                catch { }
            }

            // Never fall back to another company's ID!
            if (session != null) session["CompanyId"] = 0;
            return 0;
        }

        // =========================================================================
        // [COMPANY HELPER]: Resolves user_auth.user_id for a company_id
        // =========================================================================
        public static int GetCompanyUserId(int companyId)
        {
            try
            {
                object uidObj = ExecuteScalar("SELECT user_id FROM company_table WHERE company_id = @cid", new SqlParameter("@cid", companyId));
                if (uidObj != null && uidObj != DBNull.Value && Convert.ToInt32(uidObj) > 0)
                {
                    return Convert.ToInt32(uidObj);
                }

                object fallback = ExecuteScalar(@"
                    SELECT TOP 1 u.user_id 
                    FROM user_auth u 
                    INNER JOIN role r ON u.role_id = r.role_id 
                    WHERE r.role_name = 'Company'");
                if (fallback != null && fallback != DBNull.Value)
                    return Convert.ToInt32(fallback);
            }
            catch { }
            return 2;
        }

        // =========================================================================
        // [IMAGE RESOLVER]: Normalizes image URLs from DB for reliable client rendering
        // Handles relative paths, virtual tildes (~/), and fallback placeholders
        // =========================================================================
        public static string ResolveImageUrl(object rawPath, string defaultPath = "~/assets/images/user-male-logo.png")
        {
            string path = rawPath != null && rawPath != DBNull.Value ? rawPath.ToString().Trim() : "";
            if (string.IsNullOrEmpty(path)) path = defaultPath;
            if (path.StartsWith("http://", StringComparison.OrdinalIgnoreCase) || path.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
                return path;
            if (!path.StartsWith("~") && !path.StartsWith("/"))
                path = "~/" + path;
            if (HttpContext.Current != null)
            {
                try
                {
                    return VirtualPathUtility.ToAbsolute(path);
                }
                catch
                {
                    return path.Replace("~", "");
                }
            }
            return path.Replace("~", "");
        }
    }
}
