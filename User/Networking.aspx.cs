using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    public partial class Networking : Page
    {
        public int ConnectionsCount { get; set; } = 0;
        public int PendingCount { get; set; } = 0;
        public int FollowersCount { get; set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int currentUserId = Convert.ToInt32(Session["UserId"]);
                LoadNetworkingData(currentUserId);
            }
        }

        private void LoadNetworkingData(int currentUserId)
        {
            DBHelper.EnsureProfilePhotoColumns();

            try
            {
                // 1. Metric Counts from 'connections' table
                object cObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM connections 
                    WHERE (sender_id = @uid OR receiver_id = @uid) AND status = 'Accepted'",
                    new SqlParameter("@uid", currentUserId));
                ConnectionsCount = cObj != null ? Convert.ToInt32(cObj) : 0;

                object pObj = DBHelper.ExecuteScalar(@"
                    SELECT COUNT(*) FROM connections 
                    WHERE receiver_id = @uid AND status = 'Pending'",
                    new SqlParameter("@uid", currentUserId));
                PendingCount = pObj != null ? Convert.ToInt32(pObj) : 0;

                FollowersCount = ConnectionsCount + PendingCount;

                // 2. Load Discover People: Real users excluding current user
                string sqlDiscover = @"
                    SELECT m.id AS UserId, m.full_name AS Name, 
                           COALESCE(m.tagline, m.degree, 'Student') AS Subtitle,
                           COALESCE(m.clg_name, m.city, 'India') AS Institute,
                           m.skills AS Skills,
                           m.profile_photo AS ProfilePhoto,
                           c.status AS ConnectionStatus,
                           c.sender_id AS ConnectionSenderId
                    FROM member_master_table m
                    LEFT JOIN connections c ON 
                        ((c.sender_id = @uid AND c.receiver_id = m.id) OR 
                         (c.sender_id = m.id AND c.receiver_id = @uid))
                    WHERE m.id <> @uid";

                DataTable dtDiscover = DBHelper.ExecuteQuery(sqlDiscover, new SqlParameter("@uid", currentUserId));
                var discoverList = new List<dynamic>();

                foreach (DataRow r in dtDiscover.Rows)
                {
                    string status = r["ConnectionStatus"] != DBNull.Value ? r["ConnectionStatus"].ToString() : "";
                    int senderId = r["ConnectionSenderId"] != DBNull.Value ? Convert.ToInt32(r["ConnectionSenderId"]) : 0;

                    string buttonState = "Connect";
                    string buttonCss = "btn-net-connect";
                    bool isConnected = false;
                    bool isPending = false;

                    if (status.Equals("Accepted", StringComparison.OrdinalIgnoreCase))
                    {
                        buttonState = "Connected";
                        buttonCss = "btn-net-connect sent";
                        isConnected = true;
                    }
                    else if (status.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                    {
                        buttonState = senderId == currentUserId ? "Request Sent" : "Pending Approval";
                        buttonCss = "btn-net-connect sent";
                        isPending = true;
                    }

                    string rawSkills = r["Skills"] != DBNull.Value ? r["Skills"].ToString() : "";
                    var skillsList = rawSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                             .Select(s => s.Trim())
                                             .Take(3)
                                             .ToList();

                    string photo = r["ProfilePhoto"] != DBNull.Value ? r["ProfilePhoto"].ToString().Trim() : "";

                    discoverList.Add(new
                    {
                        UserId = r["UserId"],
                        Name = r["Name"].ToString(),
                        Subtitle = r["Subtitle"].ToString(),
                        Institute = r["Institute"].ToString(),
                        Skills = skillsList,
                        ProfilePhoto = photo,
                        ButtonState = buttonState,
                        ButtonCss = buttonCss,
                        IsConnected = isConnected,
                        IsPending = isPending
                    });
                }

                rptDiscoverPeople.DataSource = discoverList;
                rptDiscoverPeople.DataBind();

                // 3. Load My Connections: Both users see each other where status = 'Accepted'
                string sqlConnections = @"
                    SELECT m.id AS UserId, m.full_name AS Name, 
                           COALESCE(m.tagline, m.degree, 'Connected Member') AS Subtitle,
                           COALESCE(m.clg_name, m.city, 'India') AS Institute,
                           m.skills AS Skills,
                           m.profile_photo AS ProfilePhoto
                    FROM connections c
                    INNER JOIN member_master_table m ON 
                        (CASE WHEN c.sender_id = @uid THEN c.receiver_id ELSE c.sender_id END) = m.id
                    WHERE (c.sender_id = @uid OR c.receiver_id = @uid) 
                      AND c.status = 'Accepted'";

                DataTable dtConnections = DBHelper.ExecuteQuery(sqlConnections, new SqlParameter("@uid", currentUserId));
                var connectionsList = new List<dynamic>();

                foreach (DataRow r in dtConnections.Rows)
                {
                    string rawSkills = r["Skills"] != DBNull.Value ? r["Skills"].ToString() : "";
                    var skillsList = rawSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                             .Select(s => s.Trim())
                                             .Take(3)
                                             .ToList();

                    string photo = r["ProfilePhoto"] != DBNull.Value ? r["ProfilePhoto"].ToString().Trim() : "";

                    connectionsList.Add(new
                    {
                        UserId = r["UserId"],
                        Name = r["Name"].ToString(),
                        Subtitle = r["Subtitle"].ToString(),
                        Institute = r["Institute"].ToString(),
                        ProfilePhoto = photo,
                        Skills = skillsList
                    });
                }

                rptMyConnections.DataSource = connectionsList;
                rptMyConnections.DataBind();

                // 4. Load Pending Requests received by the current user
                string sqlPending = @"
                    SELECT c.connection_id AS ConnectionId, m.id AS UserId, m.full_name AS Name,
                           COALESCE(m.tagline, m.degree, 'SkillLinksX Member') AS Subtitle,
                           c.created_at AS CreatedAt,
                           m.skills AS Skills,
                           m.profile_photo AS ProfilePhoto
                    FROM connections c
                    INNER JOIN member_master_table m ON c.sender_id = m.id
                    WHERE c.receiver_id = @uid AND c.status = 'Pending'";

                DataTable dtPending = DBHelper.ExecuteQuery(sqlPending, new SqlParameter("@uid", currentUserId));
                var pendingList = new List<dynamic>();

                foreach (DataRow r in dtPending.Rows)
                {
                    string rawSkills = r["Skills"] != DBNull.Value ? r["Skills"].ToString() : "";
                    var skillsList = rawSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                             .Select(s => s.Trim())
                                             .Take(3)
                                             .ToList();

                    string photo = r["ProfilePhoto"] != DBNull.Value ? r["ProfilePhoto"].ToString().Trim() : "";

                    pendingList.Add(new
                    {
                        ConnectionId = r["ConnectionId"],
                        UserId = r["UserId"],
                        Name = r["Name"].ToString(),
                        Subtitle = r["Subtitle"].ToString(),
                        ProfilePhoto = photo,
                        Skills = skillsList
                    });
                }

                rptPendingRequests.DataSource = pendingList;
                rptPendingRequests.DataBind();

                // 5. Load Verified Companies / Recruiters dynamically from company_table
                string sqlRecruiters = "SELECT TOP 4 company_id, comp_name AS CompanyName, profile_photo AS LogoUrl, COALESCE(city, 'India') AS Location FROM company_table ORDER BY company_id ASC";
                DataTable dtRecruiters = DBHelper.ExecuteQuery(sqlRecruiters);
                rptVerifiedRecruiters.DataSource = dtRecruiters;
                rptVerifiedRecruiters.DataBind();
            }
            catch (Exception ex)
            {
                lblNetStatus.Text = "Networking Error: " + ex.Message;
            }
        }

        // =========================================================================
        // [SEND CONNECTION REQUEST]: Inserts Pending row into 'connections' table
        // =========================================================================
        protected void rptDiscoverPeople_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int currentUserId = Convert.ToInt32(Session["UserId"]);
            int targetUserId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SendConnect")
            {
                try
                {
                    // Check if already requested or connected
                    object exists = DBHelper.ExecuteScalar(@"
                        SELECT COUNT(*) FROM connections 
                        WHERE (sender_id = @uid AND receiver_id = @tid) OR (sender_id = @tid AND receiver_id = @uid)",
                        new SqlParameter("@uid", currentUserId),
                        new SqlParameter("@tid", targetUserId)
                    );

                    if (exists == null || Convert.ToInt32(exists) == 0)
                    {
                        DBHelper.ExecuteNonQuery(@"
                            INSERT INTO connections (sender_id, receiver_id, status, created_at)
                            VALUES (@uid, @tid, 'Pending', GETDATE())",
                            new SqlParameter("@uid", currentUserId),
                            new SqlParameter("@tid", targetUserId)
                        );
                        lblNetStatus.ForeColor = System.Drawing.Color.Green;
                        lblNetStatus.Text = "Connection request sent successfully!";
                    }

                    LoadNetworkingData(currentUserId);
                }
                catch (Exception ex)
                {
                    lblNetStatus.ForeColor = System.Drawing.Color.Red;
                    lblNetStatus.Text = "Error sending connection: " + ex.Message;
                }
            }
        }

        // =========================================================================
        // [ACCEPT / DECLINE PENDING REQUEST]: Updates status in 'connections' table
        // =========================================================================
        protected void rptPendingRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int currentUserId = Convert.ToInt32(Session["UserId"]);
            int connId = Convert.ToInt32(e.CommandArgument);

            try
            {
                if (e.CommandName == "AcceptRequest")
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE connections 
                        SET status = 'Accepted' 
                        WHERE connection_id = @cid AND receiver_id = @uid",
                        new SqlParameter("@cid", connId),
                        new SqlParameter("@uid", currentUserId)
                    );
                    lblNetStatus.ForeColor = System.Drawing.Color.Green;
                    lblNetStatus.Text = "Connection request accepted!";
                }
                else if (e.CommandName == "DeclineRequest")
                {
                    DBHelper.ExecuteNonQuery(@"
                        UPDATE connections 
                        SET status = 'Rejected' 
                        WHERE connection_id = @cid AND receiver_id = @uid",
                        new SqlParameter("@cid", connId),
                        new SqlParameter("@uid", currentUserId)
                    );
                    lblNetStatus.ForeColor = System.Drawing.Color.Orange;
                    lblNetStatus.Text = "Connection request declined.";
                }

                LoadNetworkingData(currentUserId);
            }
            catch (Exception ex)
            {
                lblNetStatus.ForeColor = System.Drawing.Color.Red;
                lblNetStatus.Text = "Action Error: " + ex.Message;
            }
        }
    }
}
