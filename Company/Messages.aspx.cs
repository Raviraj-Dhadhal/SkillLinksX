using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public partial class Messages : Page
    {
        public int CurrentCompanyUserId => Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;

        public int ActiveCandidateId
        {
            get => ViewState["ActiveCandidateId"] != null ? Convert.ToInt32(ViewState["ActiveCandidateId"]) : 0;
            set => ViewState["ActiveCandidateId"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authorization
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Check if candidate ID was passed in query string (e.g. ?cid=1 or ?id=1)
                if (Request.QueryString["cid"] != null && int.TryParse(Request.QueryString["cid"], out int cid))
                {
                    ActiveCandidateId = cid;
                }
                else if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int qid))
                {
                    ActiveCandidateId = qid;
                }

                LoadCandidateThreads();

                if (ActiveCandidateId > 0)
                {
                    LoadActiveConversation(ActiveCandidateId);
                }
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Load Candidate Contacts
        // =========================================================================
        private void LoadCandidateThreads()
        {
            try
            {
                string sql = @"
                    SELECT 
                        m.id AS candidate_id, 
                        m.full_name, 
                        m.email_add AS email, 
                        m.skills,
                        (SELECT TOP 1 message_text FROM messages 
                         WHERE (sender_id = m.id AND receiver_id = @uid) 
                            OR (sender_id = @uid AND receiver_id = m.id) 
                         ORDER BY sent_at DESC) AS last_message,
                        (SELECT MAX(sent_at) FROM messages 
                         WHERE (sender_id = m.id AND receiver_id = @uid) 
                            OR (sender_id = @uid AND receiver_id = m.id)) AS last_activity,
                        (SELECT COUNT(*) FROM messages 
                         WHERE sender_id = m.id AND receiver_id = @uid AND is_read = 0) AS unread_count
                    FROM member_master_table m
                    ORDER BY 
                        CASE WHEN (SELECT MAX(sent_at) FROM messages WHERE (sender_id = m.id AND receiver_id = @uid) OR (sender_id = @uid AND receiver_id = m.id)) IS NOT NULL THEN 0 ELSE 1 END,
                        last_activity DESC,
                        m.id DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@uid", CurrentCompanyUserId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptCandidateThreads.DataSource = dt;
                    rptCandidateThreads.DataBind();

                    if (ActiveCandidateId <= 0)
                    {
                        ActiveCandidateId = Convert.ToInt32(dt.Rows[0]["candidate_id"]);
                    }
                }
                else
                {
                    rptCandidateThreads.DataSource = null;
                    rptCandidateThreads.DataBind();
                }
            }
            catch (Exception)
            {
                rptCandidateThreads.DataSource = null;
                rptCandidateThreads.DataBind();
            }
        }

        // =========================================================================
        // [DATABASE ACCESS]: Load Conversation Messages for Active Candidate
        // =========================================================================
        private void LoadActiveConversation(int candidateId)
        {
            try
            {
                if (candidateId <= 0)
                {
                    rptCompanyChatMessages.DataSource = null;
                    rptCompanyChatMessages.DataBind();
                    pnlNoCompanyMessages.Visible = true;
                    return;
                }

                // 1. Fetch Candidate Name & Email
                string candSql = "SELECT full_name, email_add AS email FROM member_master_table WHERE id = @cid";
                DataTable dtCandidate = DBHelper.ExecuteQuery(candSql, new SqlParameter("@cid", candidateId));
                if (dtCandidate != null && dtCandidate.Rows.Count > 0)
                {
                    string name = dtCandidate.Rows[0]["full_name"].ToString();
                    litActiveCandidateName.Text = name;
                    litActiveCandidateEmail.Text = dtCandidate.Rows[0]["email"].ToString();
                    litActiveCandidateInitial.Text = GetInitials(name);
                }
                else
                {
                    litActiveCandidateName.Text = "Candidate #" + candidateId;
                    litActiveCandidateEmail.Text = "";
                    litActiveCandidateInitial.Text = "C";
                }

                // 2. Fetch Conversation History strictly according to schema:
                // message_id, sender_id, receiver_id, subject, message_text, is_read, sent_at
                string sql = @"
                    SELECT message_id, sender_id, receiver_id, subject, message_text, is_read, sent_at
                    FROM messages
                    WHERE (sender_id = @uid AND receiver_id = @cid)
                       OR (sender_id = @cid AND receiver_id = @uid)
                    ORDER BY sent_at ASC";

                DataTable dtMessages = DBHelper.ExecuteQuery(sql,
                    new SqlParameter("@uid", CurrentCompanyUserId),
                    new SqlParameter("@cid", candidateId)
                );

                rptCompanyChatMessages.DataSource = dtMessages;
                rptCompanyChatMessages.DataBind();

                pnlNoCompanyMessages.Visible = (dtMessages == null || dtMessages.Rows.Count == 0);

                // 3. Mark incoming candidate messages as read in SQL database
                string readSql = "UPDATE messages SET is_read = 1 WHERE sender_id = @cid AND receiver_id = @uid AND is_read = 0";
                DBHelper.ExecuteNonQuery(readSql,
                    new SqlParameter("@cid", candidateId),
                    new SqlParameter("@uid", CurrentCompanyUserId)
                );
            }
            catch (Exception)
            {
                rptCompanyChatMessages.DataSource = null;
                rptCompanyChatMessages.DataBind();
                pnlNoCompanyMessages.Visible = true;
            }
        }

        // =========================================================================
        // [EVENT HANDLER]: Candidate Thread Selected
        // =========================================================================
        protected void btnSelectCandidate_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            if (int.TryParse(btn.CommandArgument, out int selectedId))
            {
                ActiveCandidateId = selectedId;
                LoadActiveConversation(selectedId);
                LoadCandidateThreads();
            }
        }

        // =========================================================================
        // [DATABASE INSERTION]: Send Message Handler
        // =========================================================================
        protected void btnSendCompanyMessage_Click(object sender, EventArgs e)
        {
            string text = txtCompanyMessageInput.Text.Trim();
            if (string.IsNullOrEmpty(text) || ActiveCandidateId <= 0) return;

            try
            {
                string compName = Session["UserName"]?.ToString();
                if (string.IsNullOrEmpty(compName))
                {
                    object compObj = DBHelper.ExecuteScalar("SELECT comp_name FROM company_table WHERE user_id = @uid", new SqlParameter("@uid", CurrentCompanyUserId));
                    if (compObj != null && compObj != DBNull.Value) compName = compObj.ToString();
                    else compName = "Company Recruiter";
                }

                // Send direct message with valid subject
                DBHelper.SendDirectMessage(CurrentCompanyUserId, ActiveCandidateId, text, "Message from " + compName);

                txtCompanyMessageInput.Text = string.Empty;
                LoadActiveConversation(ActiveCandidateId);
                LoadCandidateThreads();
            }
            catch { }
        }

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "C";
            string[] parts = name.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        // Optional WebMethod for client calls
        [WebMethod(EnableSession = true)]
        public static bool SendMessage(int receiverId, string messageText)
        {
            if (HttpContext.Current?.Session?["UserId"] == null) return false;
            int senderId = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
            return DBHelper.SendDirectMessage(senderId, receiverId, messageText);
        }
    }
}
