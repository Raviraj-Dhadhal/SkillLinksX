<%@ Page Title="Notifications - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="SkillLinksX.User.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Notifications Styles -->
    <link href="<%= ResolveUrl("~/assets/CSS/user-pages.css") %>" rel="stylesheet" />
    <style>
        .notif-filter-tabs a.notif-tab-pill {
            text-decoration: none;
            display: inline-block;
        }
        .notif-action-btn-group {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-left: auto;
            flex-shrink: 0;
        }
        .btn-view-target {
            padding: 6px 12px;
            background: #0040A2;
            color: #ffffff !important;
            font-size: 12px;
            font-weight: 600;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s ease;
            border: none;
        }
        .btn-view-target:hover {
            background: #00307B;
        }
        .btn-inline-mark-read {
            padding: 6px 10px;
            background: #F1F5F9;
            color: #475569 !important;
            font-size: 12px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s ease;
            border: none;
        }
        .btn-inline-mark-read:hover {
            background: #E2E8F0;
            color: #0F172A !important;
        }
        .notif-empty-state {
            background: #FFFFFF;
            border: 1px dashed #CBD5E1;
            border-radius: 12px;
            padding: 50px 20px;
            text-align: center;
            color: #64748B;
        }
        .notif-empty-icon {
            font-size: 42px;
            color: #94A3B8;
            margin-bottom: 14px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-notif-page-container">

        <!-- Page Header -->
        <div class="notif-page-header flex-between" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
            <div>
                <h1 class="notif-page-title" style="font-size:24px; font-weight:700; color:#0F172A; margin:0 0 6px 0;">Notifications</h1>
                <p class="notif-page-sub" style="font-size:14px; color:#64748B; margin:0;">Stay updated with your job applications, interviews, recruiter messages, and activity.</p>
            </div>
            <div>
                <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="btn-mark-all-read" OnClick="btnMarkAllRead_Click"
                    style="padding:8px 16px; background:#0040A2; color:#fff; border-radius:8px; text-decoration:none; font-size:13px; font-weight:600; display:inline-flex; align-items:center; gap:8px;">
                    <i class="fa-solid fa-check-double"></i> Mark All as Read
                </asp:LinkButton>
            </div>
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
                    <span class="notif-metric-label">Messages &amp; Network</span>
                    <div class="notif-metric-icon-box bg-purple-subtle">
                        <i class="fa-solid fa-user-group"></i>
                    </div>
                </div>
                <span class="notif-metric-val"><asp:Literal ID="litNetworkNotifs" runat="server">0</asp:Literal></span>
            </div>
        </div>

        <!-- Filter Tabs: All, Unread, Applications, Interviews -->
        <div class="notif-filter-tabs" style="margin: 20px 0;">
            <a href="Notifications.aspx" class='<%= string.IsNullOrEmpty(CurrentFilter) || CurrentFilter == "all" ? "notif-tab-pill active" : "notif-tab-pill" %>'>All</a>
            <a href="Notifications.aspx?filter=unread" class='<%= CurrentFilter == "unread" ? "notif-tab-pill active" : "notif-tab-pill" %>'>Unread</a>
            <a href="Notifications.aspx?filter=applications" class='<%= CurrentFilter == "applications" ? "notif-tab-pill active" : "notif-tab-pill" %>'>Applications</a>
            <a href="Notifications.aspx?filter=interviews" class='<%= CurrentFilter == "interviews" ? "notif-tab-pill active" : "notif-tab-pill" %>'>Interviews</a>
        </div>

        <!-- Notifications Feed List -->
        <div class="notif-feed-stack" id="notifFeed">
            <asp:Repeater ID="rptNotifications" runat="server" OnItemCommand="rptNotifications_ItemCommand">
                <ItemTemplate>
                    <div class='notif-card-item <%# Convert.ToBoolean(Eval("is_read")) ? "" : "unread" %>' style="display:flex; align-items:center; gap:14px;">
                        
                        <!-- Unread Dot Indicator -->
                        <div class='notif-unread-blue-dot <%# Convert.ToBoolean(Eval("is_read")) ? "invisible" : "" %>'></div>
                        
                        <!-- Dynamic Icon Box -->
                        <div class='notif-icon-circle <%# GetIconBg(Eval("title").ToString()) %>'>
                            <i class='<%# GetNotificationIcon(Eval("title").ToString()) %>'></i>
                        </div>
                        
                        <!-- Content -->
                        <div class="notif-text-content">
                            <p class="notif-body-line">
                                <strong><%# Eval("title") %>:</strong> <%# Eval("message") %>
                            </p>
                            <span class="notif-time-ago">
                                <i class="fa-regular fa-clock" style="margin-right:4px;"></i><%# FormatNotificationTime(Eval("created_at")) %>
                            </span>
                        </div>

                        <!-- Action Buttons -->
                        <div class="notif-action-btn-group">
                            <asp:LinkButton ID="btnInlineMarkRead" runat="server" CommandName="MarkRead" 
                                CommandArgument='<%# Eval("notification_id") %>' 
                                Visible='<%# !Convert.ToBoolean(Eval("is_read")) %>' 
                                CssClass="btn-inline-mark-read" title="Mark as Read">
                                <i class="fa-solid fa-check"></i> Mark Read
                            </asp:LinkButton>
                            
                            <asp:LinkButton ID="btnViewTarget" runat="server" CommandName="Navigate" 
                                CommandArgument='<%# Eval("notification_id") + "|" + Eval("target_url") %>' 
                                CssClass="btn-view-target">
                                View <i class="fa-solid fa-arrow-right" style="font-size:10px;"></i>
                            </asp:LinkButton>
                        </div>

                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:Panel ID="pnlNoNotifs" runat="server" Visible='<%# rptNotifications.Items.Count == 0 %>' CssClass="notif-empty-state">
                        <div class="notif-empty-icon">
                            <i class="fa-regular fa-bell-slash"></i>
                        </div>
                        <h3 style="font-size: 16px; font-weight: 600; color: #1E293B; margin-bottom: 6px;">You're all caught up!</h3>
                        <p style="font-size: 13.5px; margin: 0; color: #64748B;">No notifications found under this filter. When updates arrive, they will appear here.</p>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </div>

    </div>
</asp:Content>
