<%@ Page Title="Notifications - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="SkillLinksX.User.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Notifications Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-notif-page-container">

        <!-- Page Header -->
        <div class="notif-page-header flex-between">
            <div>
                <h1 class="notif-page-title">Notifications</h1>
                <p class="notif-page-sub">Stay updated with your applications, opportunities and professional network.</p>
            </div>
            <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="btn-mark-all-read" OnClick="btnMarkAllRead_Click">
                <i class="fa-solid fa-check-double"></i> Mark All as Read
            </asp:LinkButton>
        </div>

        <!-- 4 Metric Tiles Row -->
        <div class="notif-metrics-grid">
            <div class="notif-metric-tile">
                <div class="notif-metric-top flex-between">
                    <span class="notif-metric-label">Unread</span>
                    <div class="notif-metric-icon-box bg-blue-subtle">
                        <i class="fa-regular fa-bell"></i>
                    </div>
                </div>
                <span class="notif-metric-val"><asp:Literal ID="litUnreadCount" runat="server">0</asp:Literal></span>
            </div>

            <div class="notif-metric-tile">
                <div class="notif-metric-top flex-between">
                    <span class="notif-metric-label">Applications</span>
                    <div class="notif-metric-icon-box bg-indigo-subtle">
                        <i class="fa-regular fa-file-lines"></i>
                    </div>
                </div>
                <span class="notif-metric-val"><asp:Literal ID="litAppNotifs" runat="server">0</asp:Literal></span>
            </div>

            <div class="notif-metric-tile">
                <div class="notif-metric-top flex-between">
                    <span class="notif-metric-label">Interviews</span>
                    <div class="notif-metric-icon-box bg-green-subtle">
                        <i class="fa-solid fa-video"></i>
                    </div>
                </div>
                <span class="notif-metric-val"><asp:Literal ID="litInterviewNotifs" runat="server">0</asp:Literal></span>
            </div>

            <div class="notif-metric-tile">
                <div class="notif-metric-top flex-between">
                    <span class="notif-metric-label">Networking</span>
                    <div class="notif-metric-icon-box bg-purple-subtle">
                        <i class="fa-solid fa-user-group"></i>
                    </div>
                </div>
                <span class="notif-metric-val"><asp:Literal ID="litNetworkNotifs" runat="server">0</asp:Literal></span>
            </div>
        </div>

        <!-- Filter Tabs: All, Applications, Jobs & Internships, Networking, Interviews, System -->
        <div class="notif-filter-tabs">
            <button type="button" class="notif-tab-pill active">All</button>
            <button type="button" class="notif-tab-pill">Applications</button>
            <button type="button" class="notif-tab-pill">Jobs &amp; Internships</button>
            <button type="button" class="notif-tab-pill">Networking</button>
            <button type="button" class="notif-tab-pill">Interviews</button>
            <button type="button" class="notif-tab-pill">System</button>
        </div>

        <!-- Notifications Feed List -->
        <div class="notif-feed-stack" id="notifFeed">
            <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>
                    <div class='notif-card-item <%# Convert.ToBoolean(Eval("is_read")) ? "" : "unread" %>'>
                        <div class='notif-unread-blue-dot <%# Convert.ToBoolean(Eval("is_read")) ? "invisible" : "" %>'></div>
                        <div class='notif-icon-circle <%# Eval("category").ToString() == "Interviews" ? "bg-green-light" : "bg-blue-light" %>'>
                            <i class='<%# Eval("category").ToString() == "Interviews" ? "fa-solid fa-video" : "fa-regular fa-file-lines" %>'></i>
                        </div>
                        <div class="notif-text-content">
                            <p class="notif-body-line">
                                <strong><%# Eval("title") %>:</strong> <%# Eval("message") %>
                            </p>
                            <span class="notif-time-ago"><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM, hh:mm tt") %></span>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:Panel ID="pnlNoNotifs" runat="server" Visible='<%# rptNotifications.Items.Count == 0 %>' CssClass="text-center" style="padding: 30px; color: #64748b;">
                        <i class="fa-regular fa-bell-slash" style="font-size: 28px; margin-bottom: 8px;"></i>
                        <p>No notifications at the moment.</p>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <!-- Load More Button -->
        <div class="notif-load-more-row text-center">
            <button type="button" class="btn-load-more-notifs" onclick="this.innerHTML='All caught up!'; this.disabled=true;">
                Load More
            </button>
        </div>

    </div>
</asp:Content>
