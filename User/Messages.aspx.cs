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

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify User Authentication
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

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
        // =========================================================================
        private void LoadContactThreads()
        {
            try
            {
                string sql = @"
                    SELECT 
                        c.contact_id, 
                        c.full_name, 
                        c.email, 
                        c.role_type,
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
                        SELECT user_id AS contact_id, comp_name AS full_name, email_add AS email, 'Recruiter' AS role_type
                        FROM company_table
                        WHERE user_id IS NOT NULL AND user_id <> @uid

                        UNION

                        SELECT id AS contact_id, full_name, email_add AS email, 'Student' AS role_type
                        FROM member_master_table
                        WHERE id <> @uid
                    ) c
                    ORDER BY 
                        CASE WHEN (SELECT MAX(sent_at) FROM messages WHERE (sender_id = c.contact_id AND receiver_id = @uid) OR (sender_id = @uid AND receiver_id = c.contact_id)) IS NOT NULL THEN 0 ELSE 1 END,
                        last_activity DESC,
                        c.full_name ASC";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", CurrentUserId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptContactThreads.DataSource = dt;
                    rptContactThreads.DataBind();

                    if (ActiveContactId == 0)
                    {
                        ActiveContactId = Convert.ToInt32(dt.Rows[0]["contact_id"]);
                    }
                }
                else
                {
                    rptContactThreads.DataSource = null;
                    rptContactThreads.DataBind();
                }
            }
            catch (Exception)
            {
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
                if (contactId <= 0) return;

                // 1. Fetch Contact Details
                string infoSql = @"
                    SELECT full_name, email FROM (
                        SELECT user_id AS contact_id, comp_name AS full_name, email_add AS email FROM company_table
                        UNION
                        SELECT id AS contact_id, full_name, email_add AS email FROM member_master_table
                    ) x WHERE contact_id = @cid";

                DataTable dtInfo = DBHelper.ExecuteQuery(infoSql, new SqlParameter("@cid", contactId));
                if (dtInfo != null && dtInfo.Rows.Count > 0)
                {
                    string name = dtInfo.Rows[0]["full_name"].ToString();
                    litActiveContactName.Text = name;
                    litActiveContactEmail.Text = dtInfo.Rows[0]["email"].ToString();
                    litActiveContactInitial.Text = GetInitials(name);
                }
                else
                {
                    litActiveContactName.Text = "Contact #" + contactId;
                    litActiveContactEmail.Text = "";
                    litActiveContactInitial.Text = "C";
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
