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

        public string ActiveCandidatePhoto { get; set; } = "";
        public string CurrentCompanyPhoto { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authorization
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            DBHelper.EnsureProfilePhotoColumns();

            try
            {
                if (Session["CompanyProfilePhoto"] != null && !string.IsNullOrEmpty(Session["CompanyProfilePhoto"].ToString()))
                {
                    CurrentCompanyPhoto = Session["CompanyProfilePhoto"].ToString();
                }
                else
                {
                    int cid = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
                    if (cid > 0)
                    {
                        object pObj = DBHelper.ExecuteScalar("SELECT profile_photo FROM company_table WHERE company_id = @cid", new SqlParameter("@cid", cid));
                        if (pObj != null && pObj != DBNull.Value) CurrentCompanyPhoto = pObj.ToString().Trim();
                    }
                }
            }
            catch { }

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
                int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

                string sql = @"
                    SELECT 
                        m.id AS candidate_id, 
                        m.full_name, 
                        m.email_add AS email, 
                        m.skills,
                        m.profile_photo,
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
                    WHERE EXISTS (
                        SELECT 1 FROM applications a 
                        LEFT JOIN jobs j ON a.job_id = j.job_id
                        LEFT JOIN internships i ON a.internship_id = i.internship_id
                        WHERE a.user_id = m.id AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)
                    )
                    OR EXISTS (
                        SELECT 1 FROM connections conn 
                        WHERE ((conn.sender_id = @uid AND conn.receiver_id = m.id) OR (conn.sender_id = m.id AND conn.receiver_id = @uid))
                          AND conn.status = 'Accepted'
                    )
                    OR EXISTS (
                        SELECT 1 FROM messages msg 
                        WHERE (msg.sender_id = m.id AND msg.receiver_id = @uid) OR (msg.sender_id = @uid AND msg.receiver_id = m.id)
                    )
                    ORDER BY 
                        CASE WHEN (SELECT MAX(sent_at) FROM messages WHERE (sender_id = m.id AND receiver_id = @uid) OR (sender_id = @uid AND receiver_id = m.id)) IS NOT NULL THEN 0 ELSE 1 END,
                        last_activity DESC,
                        m.id DESC";

                DataTable dt = DBHelper.ExecuteQuery(sql,
                    new SqlParameter("@uid", CurrentCompanyUserId),
                    new SqlParameter("@cid", companyId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptCandidateThreads.DataSource = dt;
                    rptCandidateThreads.DataBind();

                    bool exists = false;
                    foreach (DataRow r in dt.Rows)
                    {
                        if (Convert.ToInt32(r["candidate_id"]) == ActiveCandidateId)
                        {
                            exists = true;
                            break;
                        }
                    }

                    if (!exists)
                    {
                        ActiveCandidateId = Convert.ToInt32(dt.Rows[0]["candidate_id"]);
                    }
                }
                else
                {
                    ActiveCandidateId = 0;
                    rptCandidateThreads.DataSource = null;
                    rptCandidateThreads.DataBind();
                }
            }
            catch (Exception)
            {
                ActiveCandidateId = 0;
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
                    litActiveCandidateName.Text = "No candidate selected";
                    litActiveCandidateEmail.Text = "Select a candidate from the left to start messaging";
                    litActiveCandidateInitial.Text = "<i class=\"fa-regular fa-user\"></i>";
                    ActiveCandidatePhoto = "";
                    rptCompanyChatMessages.DataSource = null;
                    rptCompanyChatMessages.DataBind();
                    pnlNoCompanyMessages.Visible = true;
                    txtCompanyMessageInput.Enabled = false;
                    btnSendCompanyMessage.Enabled = false;
                    txtCompanyMessageInput.Attributes["placeholder"] = "No candidate selected...";
                    return;
                }

                txtCompanyMessageInput.Enabled = true;
                btnSendCompanyMessage.Enabled = true;
                txtCompanyMessageInput.Attributes["placeholder"] = "Write a message to candidate...";

                // 1. Fetch Candidate Name & Email
                string candSql = "SELECT full_name, email_add AS email, profile_photo FROM member_master_table WHERE id = @cid";
                DataTable dtCandidate = DBHelper.ExecuteQuery(candSql, new SqlParameter("@cid", candidateId));
                if (dtCandidate != null && dtCandidate.Rows.Count > 0)
                {
                    string name = dtCandidate.Rows[0]["full_name"].ToString();
                    litActiveCandidateName.Text = name;
                    litActiveCandidateEmail.Text = dtCandidate.Rows[0]["email"].ToString();
                    string photo = dtCandidate.Rows[0]["profile_photo"] != DBNull.Value ? dtCandidate.Rows[0]["profile_photo"].ToString().Trim() : "";
                    ActiveCandidatePhoto = photo;
                    if (!string.IsNullOrEmpty(photo))
                    {
                        litActiveCandidateInitial.Text = $"<img src='{ResolveUrl(photo)}' style='width:100%; height:100%; border-radius:50%; object-fit:cover;' />";
                    }
                    else
                    {
                        litActiveCandidateInitial.Text = "<i class=\"fa-regular fa-user\"></i>";
                    }
                }
                else
                {
                    litActiveCandidateName.Text = "Candidate #" + candidateId;
                    litActiveCandidateEmail.Text = "";
                    litActiveCandidateInitial.Text = "<i class=\"fa-regular fa-user\"></i>";
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
