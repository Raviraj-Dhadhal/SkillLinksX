<%@ Page Title="Notifications - SkillLinkX Admin" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="SkillLinksX.Admin.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Notifications Head -->
    <style>
        .admin-notif-container {
            max-width: 1140px;
            margin: 0 auto;
        }
        .admin-notif-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .admin-notif-header-title {
            font-size: 24px;
            font-weight: 700;
            color: #0F172A;
            margin: 0 0 6px 0;
        }
        .admin-notif-header-sub {
            font-size: 14px;
            color: #64748B;
            margin: 0;
        }
        .btn-mark-all-read {
            padding: 8px 18px;
            background: #0040A2;
            color: #FFFFFF !important;
            border-radius: 8px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        .btn-mark-all-read:hover {
            background: #00307B;
        }

        /* 4 Metrics Tiles */
        .admin-notif-metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .admin-notif-tile {
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .admin-notif-tile .tile-info h4 {
            margin: 0 0 6px 0;
            font-size: 12px;
            color: #64748B;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .admin-notif-tile .tile-info span {
            font-size: 24px;
            font-weight: 800;
            color: #0F172A;
        }
        .admin-notif-tile .tile-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }
        .bg-red-subtle { background: #FEF2F2; color: #DC2626; }
        .bg-blue-subtle { background: #EFF6FF; color: #2563EB; }
        .bg-indigo-subtle { background: #EEF2FF; color: #4F46E5; }
        .bg-purple-subtle { background: #FAF5FF; color: #9333EA; }

        /* Filter Tab Pills */
        .notif-filter-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .notif-tab-pill {
            padding: 7px 16px;
            border-radius: 20px;
            background: #FFFFFF;
            border: 1px solid #CBD5E1;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .notif-tab-pill:hover {
            border-color: #0040A2;
            color: #0040A2;
        }
        .notif-tab-pill.active {
            background: #0040A2;
            color: #FFFFFF;
            border-color: #0040A2;
        }

        /* Notification List Items */
        .notif-list-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .notif-item {
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            transition: all 0.15s ease;
        }
        .notif-item:hover {
            border-color: #CBD5E1;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .notif-item.unread {
            background: #F8FAFC;
            border-color: #BFDBFE;
        }
        .notif-unread-dot {
            width: 8px;
            height: 8px;
            background: #2563EB;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .notif-unread-dot.read {
            opacity: 0;
        }
        .notif-icon-circle {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
            background: #F1F5F9;
        }
        .notif-text-block {
            flex-grow: 1;
            min-width: 0;
        }
        .notif-title-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 4px;
        }
        .notif-title-text {
            font-size: 14.5px;
            font-weight: 700;
            color: #0F172A;
            margin: 0;
        }
        .notif-message-text {
            font-size: 13.5px;
            color: #475569;
            margin: 0 0 6px 0;
            line-height: 1.4;
        }
        .notif-date-meta {
            font-size: 12px;
            color: #94A3B8;
        }
        .notif-action-btns {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-left: auto;
            flex-shrink: 0;
        }
        .btn-view-target {
            padding: 6px 14px;
            background: #0040A2;
            color: #FFFFFF !important;
            font-size: 12.5px;
            font-weight: 600;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            border: none;
        }
        .btn-view-target:hover {
            background: #00307B;
        }
        .btn-mark-read-single {
            padding: 6px 10px;
            background: #F1F5F9;
            color: #475569 !important;
            font-size: 12px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-mark-read-single:hover {
            background: #E2E8F0;
            color: #0F172A !important;
        }
        .btn-del-notif {
            padding: 6px 10px;
            background: #FFF1F2;
            color: #E11D48 !important;
            font-size: 12px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-del-notif:hover {
            background: #FFE4E6;
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
            font-size: 44px;
            color: #94A3B8;
            margin-bottom: 14px;
        }

        .text-blue { color: #2563EB; }
        .text-indigo { color: #4F46E5; }
        .text-orange { color: #EA580C; }
        .text-purple { color: #9333EA; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container admin-notif-container">

        <!-- Page Header -->
        <div class="admin-notif-header">
            <div>
                <h1 class="admin-notif-header-title">System &amp; Platform Notifications</h1>
                <p class="admin-notif-header-sub">Monitor platform activity, company verification requests, and administrator alerts.</p>
            </div>
            <div>
                <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="btn-mark-all-read" OnClick="btnMarkAllRead_Click">
                    <i class="fa-solid fa-check-double"></i> Mark All as Read
                </asp:LinkButton>
            </div>
        </div>

        <!-- 4 Metric Tiles Row -->
        <div class="admin-notif-metrics-grid">
            <div class="admin-notif-tile">
                <div class="tile-info">
                    <h4>Unread Alerts</h4>
                    <span><asp:Literal ID="litUnreadCount" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-red-subtle">
                    <i class="fa-regular fa-bell"></i>
                </div>
            </div>

            <div class="admin-notif-tile">
                <div class="tile-info">
                    <h4>Company Verifications</h4>
                    <span><asp:Literal ID="litCompanyNotifs" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-blue-subtle">
                    <i class="fa-solid fa-building-circle-check"></i>
                </div>
            </div>

            <div class="admin-notif-tile">
                <div class="tile-info">
                    <h4>Student Approvals</h4>
                    <span><asp:Literal ID="litStudentNotifs" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-indigo-subtle">
                    <i class="fa-solid fa-user-graduate"></i>
                </div>
            </div>

            <div class="admin-notif-tile">
                <div class="tile-info">
                    <h4>System &amp; Security</h4>
                    <span><asp:Literal ID="litSystemNotifs" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-purple-subtle">
                    <i class="fa-solid fa-shield-halved"></i>
                </div>
            </div>
        </div>

        <!-- Filter Tabs -->
        <div class="notif-filter-tabs">
            <a href="Notifications.aspx" class='notif-tab-pill <%= CurrentFilter == "all" ? "active" : "" %>'>
                All Alerts
            </a>
            <a href="Notifications.aspx?filter=unread" class='notif-tab-pill <%= CurrentFilter == "unread" ? "active" : "" %>'>
                Unread
            </a>
            <a href="Notifications.aspx?filter=companies" class='notif-tab-pill <%= CurrentFilter == "companies" ? "active" : "" %>'>
                Company Verifications
            </a>
            <a href="Notifications.aspx?filter=students" class='notif-tab-pill <%= CurrentFilter == "students" ? "active" : "" %>'>
                Student Approvals
            </a>
            <a href="Notifications.aspx?filter=system" class='notif-tab-pill <%= CurrentFilter == "system" ? "active" : "" %>'>
                System &amp; Security
            </a>
        </div>

        <!-- Notification List -->
        <div class="notif-list-container">
            <asp:Repeater ID="rptAdminNotifications" runat="server" OnItemCommand="rptAdminNotifications_ItemCommand">
                <ItemTemplate>
                    <div class='notif-item <%# !(bool)Eval("is_read") ? "unread" : "" %>'>
                        <div class='notif-unread-dot <%# (bool)Eval("is_read") ? "read" : "" %>'></div>

                        <div class="notif-icon-circle">
                            <i class='<%# GetIconClass(Eval("title").ToString()) %>'></i>
                        </div>

                        <div class="notif-text-block">
                            <div class="notif-title-row">
                                <h4 class="notif-title-text"><%# Eval("title") %></h4>
                            </div>
                            <p class="notif-message-text"><%# Eval("message") %></p>
                            <span class="notif-date-meta">
                                <i class="fa-regular fa-clock" style="margin-right: 4px;"></i>
                                <%# Convert.ToDateTime(Eval("created_at")).ToString("MMM dd, yyyy • hh:mm tt") %>
                            </span>
                        </div>

                        <div class="notif-action-btns">
                            <asp:HyperLink ID="hlViewTarget" runat="server" 
                                NavigateUrl='<%# ResolveUrl(Eval("target_url").ToString()) %>' 
                                CssClass="btn-view-target" 
                                Visible='<%# !string.IsNullOrEmpty(Eval("target_url") as string) %>'>
                                <i class="fa-solid fa-arrow-up-right-from-square"></i> View
                            </asp:HyperLink>

                            <asp:LinkButton ID="btnMarkRead" runat="server" 
                                CommandName="MarkRead" 
                                CommandArgument='<%# Eval("notification_id") %>' 
                                CssClass="btn-mark-read-single" 
                                title="Mark as Read" 
                                Visible='<%# !(bool)Eval("is_read") %>'>
                                <i class="fa-solid fa-check"></i>
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnDelete" runat="server" 
                                CommandName="DeleteNotif" 
                                CommandArgument='<%# Eval("notification_id") %>' 
                                CssClass="btn-del-notif" 
                                title="Delete Notification" 
                                OnClientClick="return confirm('Delete this notification?');">
                                <i class="fa-regular fa-trash-can"></i>
                            </asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlEmptyNotifications" runat="server" Visible="false">
                <div class="notif-empty-state">
                    <div class="notif-empty-icon">
                        <i class="fa-regular fa-bell-slash"></i>
                    </div>
                    <h3 style="font-size: 16px; font-weight: 700; color: #1E293B; margin-bottom: 6px;">No Notifications</h3>
                    <p style="font-size: 13.5px; color: #64748B; margin: 0;">You're all caught up! New alerts regarding registrations, verifications, and platform activity will appear here.</p>
                </div>
            </asp:Panel>
        </div>

    </div>
</asp:Content>
