using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Messages : Page
    {
        public int CurrentUserId => Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 1;

        public int ActiveContactId
        {
            get => ViewState["ActiveContactId"] != null ? Convert.ToInt32(ViewState["ActiveContactId"]) : 0;
            set => ViewState["ActiveContactId"] = value;
        }

        public string ActiveContactPhoto { get; set; } = "";
        public string CurrentUserPhoto { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify User Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            DBHelper.EnsureProfilePhotoColumns();

            try
            {
                object myPhotoObj = DBHelper.ExecuteScalar("SELECT profile_photo FROM member_master_table WHERE id = @uid", new SqlParameter("@uid", CurrentUserId));
                if (myPhotoObj != null && myPhotoObj != DBNull.Value) CurrentUserPhoto = myPhotoObj.ToString().Trim();
            }
            catch { }

            if (!IsPostBack)
            {
                // Check if target contact was passed in query string
                if (Request.QueryString["to"] != null && int.TryParse(Request.QueryString["to"], out int toId))
                {
                    ActiveContactId = toId;
                }
                else if (Request.QueryString["cid"] != null && int.TryParse(Request.QueryString["cid"], out int cid))
                {
                    ActiveContactId = cid;
                }
                else if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int qid))
                {
                    ActiveContactId = qid;
                }

                LoadContactThreads();

                if (ActiveContactId > 0)
                {
                    LoadActiveConversation(ActiveContactId);
                }
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Load Contact List with latest messages and unread counts
        // Includes accepted peer connections, recruiters who messaged, and applied companies
        // Strictly uses user_auth.user_id as contact_id (never company_id)
        // =========================================================================
        private void LoadContactThreads()
        {
            try
            {
                // Self-healing: normalize any legacy messages stored with company_id instead of user_id
                try
                {
                    string healSql = @"
                        UPDATE m
                        SET m.receiver_id = c.user_id
                        FROM messages m
                        INNER JOIN company_table c ON m.receiver_id = c.company_id
                        WHERE m.receiver_id <> c.user_id;

                        UPDATE m
                        SET m.sender_id = c.user_id
                        FROM messages m
                        INNER JOIN company_table c ON m.sender_id = c.company_id
                        WHERE m.sender_id <> c.user_id;";
                    DBHelper.ExecuteNonQuery(healSql);
                }
                catch { }

                string sql = @"
                    SELECT 
                        c.contact_id, 
                        c.full_name, 
                        c.email, 
                        c.role_type,
                        c.profile_photo,
                        (SELECT TOP 1 message_text FROM messages 
                         WHERE (sender_id = c.contact_id AND receiver_id = @uid) 
                            OR (sender_id = @uid AND receiver_id = c.contact_id) 
                         ORDER BY sent_at DESC) AS last_message,
                        (SELECT MAX(sent_at) FROM messages 
                         WHERE (sender_id = c.contact_id AND receiver_id = @uid) 
                            OR (sender_id = @uid AND receiver_id = c.contact_id)) AS last_activity,
                        (SELECT COUNT(*) FROM messages 
                         WHERE sender_id = c.contact_id AND receiver_id = @uid AND is_read = 0) AS unread_count
                    FROM (
                        SELECT 
                            con_target.contact_id,
                            COALESCE(comp.comp_name, m.full_name, u.email, 'Recruiter / Member') AS full_name,
                            COALESCE(comp.email_add, m.email_add, u.email, '') AS email,
                            CASE WHEN comp.comp_name IS NOT NULL OR u.role_id = 3 THEN 'Recruiter' ELSE 'Connection' END AS role_type,
                            COALESCE(comp.profile_photo, m.profile_photo, '') AS profile_photo
                        FROM (
                            SELECT DISTINCT contact_id FROM (
                                -- 1. Contacts with existing messages (Recruiters or connected students)
                                SELECT CASE WHEN msg.sender_id = @uid THEN msg.receiver_id ELSE msg.sender_id END AS contact_id
                                FROM messages msg
                                WHERE (msg.sender_id = @uid OR msg.receiver_id = @uid)

                                UNION

                                -- 2. Accepted peer connections
                                SELECT CASE WHEN conn.sender_id = @uid THEN conn.receiver_id ELSE conn.sender_id END AS contact_id
                                FROM connections conn
                                WHERE (conn.sender_id = @uid OR conn.receiver_id = @uid)
                                  AND conn.status = 'Accepted'

                                UNION

                                -- 3. Recruiters from companies the student applied to
                                SELECT comp.user_id AS contact_id
                                FROM applications a
                                INNER JOIN company_table comp ON a.company_id = comp.company_id
                                WHERE a.user_id = @uid
                            ) raw_c
                            WHERE contact_id IS NOT NULL AND contact_id <> @uid
                        ) con_target
                        OUTER APPLY (
                            SELECT TOP 1 comp_name, email_add, profile_photo 
                            FROM company_table 
                            WHERE user_id = con_target.contact_id
                        ) comp
                        OUTER APPLY (
                            SELECT TOP 1 full_name, email_add, profile_photo 
                            FROM member_master_table 
                            WHERE id = con_target.contact_id
                        ) m
                        OUTER APPLY (
                            SELECT TOP 1 email, role_id 
                            FROM user_auth 
                            WHERE user_id = con_target.contact_id
                        ) u
                    ) c
                    ORDER BY 
                        unread_count DESC,
                        CASE WHEN (SELECT MAX(sent_at) FROM messages WHERE (sender_id = c.contact_id AND receiver_id = @uid) OR (sender_id = @uid AND receiver_id = c.contact_id)) IS NOT NULL THEN 0 ELSE 1 END,
                        last_activity DESC,
                        c.full_name ASC";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", CurrentUserId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptContactThreads.DataSource = dt;
                    rptContactThreads.DataBind();

                    // Check if ActiveContactId exists in the connection list
                    bool activeExists = false;
                    foreach (DataRow r in dt.Rows)
                    {
                        if (Convert.ToInt32(r["contact_id"]) == ActiveContactId)
                        {
                            activeExists = true;
                            break;
                        }
                    }

                    if (!activeExists)
                    {
                        ActiveContactId = Convert.ToInt32(dt.Rows[0]["contact_id"]);
                    }
                }
                else
                {
                    ActiveContactId = 0;
                    rptContactThreads.DataSource = null;
                    rptContactThreads.DataBind();
                }
            }
            catch (Exception)
            {
                ActiveContactId = 0;
                rptContactThreads.DataSource = null;
                rptContactThreads.DataBind();
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Load Conversation Messages for Active Contact
        // =========================================================================
        private void LoadActiveConversation(int contactId)
        {
            try
            {
                if (contactId <= 0)
                {
                    litActiveContactName.Text = "No active connection";
                    litActiveContactEmail.Text = "Connect with peers or recruiters in Networking to start chatting";
                    litActiveContactInitial.Text = "<i class=\"fa-regular fa-user\"></i>";
                    ActiveContactPhoto = "";
                    rptChatMessages.DataSource = null;
                    rptChatMessages.DataBind();
                    txtMessageInput.Enabled = false;
                    btnSend.Enabled = false;
                    txtMessageInput.Attributes["placeholder"] = "No connected contacts yet...";
                    return;
                }

                // Verify whether conversation is authorized (peer connection, recruiter, or message history)
                if (!CanChatWithContact(CurrentUserId, contactId))
                {
                    litActiveContactName.Text = "Not Connected";
                    litActiveContactEmail.Text = "You must be connected with this user or recruiter to exchange messages";
                    litActiveContactInitial.Text = "<i class=\"fa-regular fa-user\"></i>";
                    ActiveContactPhoto = "";
                    rptChatMessages.DataSource = null;
                    rptChatMessages.DataBind();
                    txtMessageInput.Enabled = false;
                    btnSend.Enabled = false;
                    txtMessageInput.Attributes["placeholder"] = "Connect or apply to start chatting...";
                    return;
                }

                txtMessageInput.Enabled = true;
                btnSend.Enabled = true;
                txtMessageInput.Attributes["placeholder"] = "Write a message...";

                // 1. Fetch Contact Details strictly by user_id
                string infoSql = @"
                    SELECT TOP 1 full_name, email, profile_photo FROM (
                        SELECT comp_name AS full_name, email_add AS email, profile_photo FROM company_table WHERE user_id = @cid
                        UNION ALL
                        SELECT full_name, email_add AS email, profile_photo FROM member_master_table WHERE id = @cid
                        UNION ALL
                        SELECT email AS full_name, email, '' AS profile_photo FROM user_auth WHERE user_id = @cid
                    ) x";

                DataTable dtInfo = DBHelper.ExecuteQuery(infoSql, new SqlParameter("@cid", contactId));
                if (dtInfo != null && dtInfo.Rows.Count > 0)
                {
                    string name = dtInfo.Rows[0]["full_name"].ToString();
                    litActiveContactName.Text = name;
                    litActiveContactEmail.Text = dtInfo.Rows[0]["email"].ToString();
                    string photo = dtInfo.Rows[0]["profile_photo"] != DBNull.Value ? dtInfo.Rows[0]["profile_photo"].ToString().Trim() : "";
                    ActiveContactPhoto = photo;
                    if (!string.IsNullOrEmpty(photo))
                    {
                        litActiveContactInitial.Text = $"<img src='{ResolveUrl(photo)}' style='width:100%; height:100%; border-radius:50%; object-fit:cover;' />";
                    }
                    else
                    {
                        litActiveContactInitial.Text = "<i class=\"fa-regular fa-user\"></i>";
                    }
                }
                else
                {
                    litActiveContactName.Text = "Contact #" + contactId;
                    litActiveContactEmail.Text = "";
                    litActiveContactInitial.Text = "<i class=\"fa-regular fa-user\"></i>";
                }

                // 2. Fetch Chat Messages strictly using messages schema:
                // message_id, sender_id, receiver_id, subject, message_text, is_read, sent_at
                string msgSql = @"
                    SELECT message_id, sender_id, receiver_id, subject, message_text, is_read, sent_at
                    FROM messages
                    WHERE (sender_id = @uid AND receiver_id = @cid)
                       OR (sender_id = @cid AND receiver_id = @uid)
                    ORDER BY sent_at ASC";

                DataTable dtMsgs = DBHelper.ExecuteQuery(msgSql,
                    new SqlParameter("@uid", CurrentUserId),
                    new SqlParameter("@cid", contactId));

                rptChatMessages.DataSource = dtMsgs;
                rptChatMessages.DataBind();

                // 3. Mark incoming messages as read in SQL database
                string readSql = "UPDATE messages SET is_read = 1 WHERE sender_id = @cid AND receiver_id = @uid AND is_read = 0";
                DBHelper.ExecuteNonQuery(readSql,
                    new SqlParameter("@cid", contactId),
                    new SqlParameter("@uid", CurrentUserId));
            }
            catch (Exception)
            {
                rptChatMessages.DataSource = null;
                rptChatMessages.DataBind();
            }
        }

        // =========================================================================
        // [EVENT HANDLER]: Contact Selected
        // =========================================================================
        protected void btnSelectThread_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            if (int.TryParse(btn.CommandArgument, out int selectedId))
            {
                ActiveContactId = selectedId;
                LoadActiveConversation(selectedId);
                LoadContactThreads();
            }
        }

        // =========================================================================
        // [EVENT HANDLER]: Send Message
        // =========================================================================
        protected void btnSend_Click(object sender, EventArgs e)
        {
            string text = txtMessageInput.Text.Trim();
            if (string.IsNullOrEmpty(text) || ActiveContactId <= 0) return;

            try
            {
                // Verify conversation authorization (peer connection, recruiter, or message history)
                if (!CanChatWithContact(CurrentUserId, ActiveContactId))
                {
                    txtMessageInput.Text = string.Empty;
                    LoadActiveConversation(ActiveContactId);
                    return;
                }

                string senderName = Session["UserName"]?.ToString();
                if (string.IsNullOrEmpty(senderName))
                {
                    object nameObj = DBHelper.ExecuteScalar("SELECT full_name FROM member_master_table WHERE id = @id", new SqlParameter("@id", CurrentUserId));
                    if (nameObj != null && nameObj != DBNull.Value) senderName = nameObj.ToString();
                    else senderName = "Student";
                }

                // Send direct message with valid subject
                DBHelper.SendDirectMessage(CurrentUserId, ActiveContactId, text, "Message from " + senderName);

                txtMessageInput.Text = string.Empty;
                LoadActiveConversation(ActiveContactId);
                LoadContactThreads();
            }
            catch { }
        }

        private bool CanChatWithContact(int currentUserId, int contactId)
        {
            if (currentUserId <= 0 || contactId <= 0 || currentUserId == contactId) return false;

            try
            {
                // 1. Accepted peer connection in connections table
                object isConn = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM connections 
                    WHERE ((sender_id = @uid AND receiver_id = @cid) OR (sender_id = @cid AND receiver_id = @uid))
                      AND status = 'Accepted'",
                    new SqlParameter("@uid", currentUserId),
                    new SqlParameter("@cid", contactId));
                if (isConn != null && Convert.ToInt32(isConn) > 0) return true;

                // 2. Existing message history between these two users
                object hasMsg = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM messages 
                    WHERE (sender_id = @uid AND receiver_id = @cid) OR (sender_id = @cid AND receiver_id = @uid)",
                    new SqlParameter("@uid", currentUserId),
                    new SqlParameter("@cid", contactId));
                if (hasMsg != null && Convert.ToInt32(hasMsg) > 0) return true;

                // 3. Contact is a recruiter / company or student applied to company
                object isRecruiter = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM (
                        SELECT 1 AS ok FROM company_table WHERE user_id = @cid
                        UNION
                        SELECT 1 AS ok FROM user_auth WHERE user_id = @cid AND role_id = 3
                        UNION
                        SELECT 1 AS ok FROM applications a 
                        INNER JOIN company_table c ON a.company_id = c.company_id 
                        WHERE a.user_id = @uid AND c.user_id = @cid
                    ) x",
                    new SqlParameter("@uid", currentUserId),
                    new SqlParameter("@cid", contactId));
                if (isRecruiter != null && Convert.ToInt32(isRecruiter) > 0) return true;
            }
            catch { }

            return false;
        }

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "U";
            string[] parts = name.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        // Optional WebMethod for client calls
        [WebMethod]
        public static bool SendMessage(int receiverId, string messageText)
        {
            if (HttpContext.Current?.Session?["UserId"] == null) return false;
            int senderId = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
            return DBHelper.SendDirectMessage(senderId, receiverId, messageText);
        }
    }
}
