<%@ Page Title="Notifications - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="SkillLinksX.Company.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Company Notifications Head -->
    <link href="<%= ResolveUrl("~/assets/CSS/company-pages.css") %>" rel="stylesheet" />
    <style>
        .company-notif-metrics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .company-notif-tile {
            background: #ffffff;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .company-notif-tile .tile-info h4 {
            margin: 0 0 6px 0;
            font-size: 13px;
            color: #64748B;
            font-weight: 500;
        }
        .company-notif-tile .tile-info span {
            font-size: 24px;
            font-weight: 700;
            color: #0F172A;
        }
        .company-notif-tile .tile-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }
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
        .notif-item {
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            transition: all 0.15s ease;
        }
        .notif-item.unread {
            background: #F0F7FF;
            border-color: #BFDBFE;
        }
        .notif-dot {
            width: 8px;
            height: 8px;
            background: #2563EB;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .notif-dot.invisible {
            opacity: 0;
        }
        .notif-icon-box {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
        }
        .bg-blue-soft { background: #DBEAFE; color: #1D4ED8; }
        .bg-green-soft { background: #DCFCE7; color: #16A34A; }
        .bg-purple-soft { background: #F3E8FF; color: #9333EA; }
        .bg-rose-soft { background: #FFE4E6; color: #E11D48; }
        .notif-content-wrap {
            flex-grow: 1;
        }
        .notif-main-text {
            font-size: 13.5px;
            color: #1E293B;
            line-height: 1.45;
            display: block;
            margin-bottom: 4px;
        }
        .notif-time-ago {
            font-size: 11.5px;
            color: #64748B;
        }
        .btn-view-target {
            padding: 6px 14px;
            background: #0040A2;
            color: #ffffff !important;
            font-size: 12px;
            font-weight: 600;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
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
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="notifications-page-container">

        <!-- Header Row -->
        <div class="notifications-header-row" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
            <div>
                <h1 class="notifications-title" style="font-size:24px; font-weight:700; color:#0F172A; margin:0 0 6px 0;">Company Notifications</h1>
                <p class="notifications-sub" style="font-size:14px; color:#64748B; margin:0;">Track candidate applications, interview confirmations, and recruiter updates in real time.</p>
            </div>
            <div>
                <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="btn-mark-all-read" OnClick="btnMarkAllRead_Click"
                    style="padding:8px 16px; background:#0040A2; color:#fff; border-radius:8px; text-decoration:none; font-size:13px; font-weight:600; display:inline-flex; align-items:center; gap:8px;">
                    <i class="fa-solid fa-check-double"></i> Mark All as Read
                </asp:LinkButton>
            </div>
        </div>

        <!-- Metric Tiles -->
        <div class="company-notif-metrics">
            <div class="company-notif-tile">
                <div class="tile-info">
                    <h4>Unread Alerts</h4>
                    <span><asp:Literal ID="litCompanyUnreadCount" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-blue-soft">
                    <i class="fa-regular fa-bell"></i>
                </div>
            </div>

            <div class="company-notif-tile">
                <div class="tile-info">
                    <h4>New Applications</h4>
                    <span><asp:Literal ID="litCompanyAppNotifs" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-purple-soft">
                    <i class="fa-regular fa-file-lines"></i>
                </div>
            </div>

            <div class="company-notif-tile">
                <div class="tile-info">
                    <h4>Interviews</h4>
                    <span><asp:Literal ID="litCompanyInterviewNotifs" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-green-soft">
                    <i class="fa-solid fa-video"></i>
                </div>
            </div>

            <div class="company-notif-tile">
                <div class="tile-info">
                    <h4>Total Notifications</h4>
                    <span><asp:Literal ID="litCompanyTotalNotifs" runat="server">0</asp:Literal></span>
                </div>
                <div class="tile-icon bg-rose-soft">
                    <i class="fa-solid fa-inbox"></i>
                </div>
            </div>
        </div>

        <!-- Filter Tabs -->
        <div class="notif-filter-tabs">
            <a href="Notifications.aspx" class='<%= string.IsNullOrEmpty(CurrentFilter) || CurrentFilter == "all" ? "notif-tab-pill active" : "notif-tab-pill" %>'>All</a>
            <a href="Notifications.aspx?filter=unread" class='<%= CurrentFilter == "unread" ? "notif-tab-pill active" : "notif-tab-pill" %>'>Unread</a>
            <a href="Notifications.aspx?filter=applications" class='<%= CurrentFilter == "applications" ? "notif-tab-pill active" : "notif-tab-pill" %>'>Applications</a>
            <a href="Notifications.aspx?filter=interviews" class='<%= CurrentFilter == "interviews" ? "notif-tab-pill active" : "notif-tab-pill" %>'>Interviews</a>
        </div>

        <!-- Notifications Card Container -->
        <div class="notifications-list-card">
            <asp:Repeater ID="rptCompanyNotifications" runat="server" OnItemCommand="rptCompanyNotifications_ItemCommand">
                <ItemTemplate>
                    <div class='notif-item <%# Convert.ToBoolean(Eval("is_read")) ? "" : "unread" %>'>
                        
                        <!-- Unread Dot -->
                        <div class='notif-dot <%# Convert.ToBoolean(Eval("is_read")) ? "invisible" : "" %>'></div>

                        <!-- Dynamic Icon -->
                        <div class='notif-icon-box <%# GetIconBg(Eval("title").ToString()) %>'>
                            <i class='<%# GetNotificationIcon(Eval("title").ToString()) %>'></i>
                        </div>

                        <!-- Content -->
                        <div class="notif-content-wrap">
                            <span class="notif-main-text">
                                <strong><%# Eval("title") %>:</strong> <%# Eval("message") %>
                            </span>
                            <span class="notif-time-ago">
                                <i class="fa-regular fa-clock" style="margin-right:4px;"></i><%# FormatNotificationTime(Eval("created_at")) %>
                            </span>
                        </div>

                        <!-- Action Buttons -->
                        <div style="display:flex; align-items:center; gap:8px; flex-shrink:0;">
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
                    <asp:Panel ID="pnlNoCompanyNotifs" runat="server" Visible='<%# rptCompanyNotifications.Items.Count == 0 %>' CssClass="notif-empty-state">
                        <i class="fa-regular fa-bell-slash" style="font-size:42px; color:#94A3B8; margin-bottom:14px; display:block;"></i>
                        <h3 style="font-size: 16px; font-weight: 600; color: #1E293B; margin-bottom: 6px;">No company notifications</h3>
                        <p style="font-size: 13.5px; margin: 0; color: #64748B;">When candidate applications arrive or interviews are scheduled, notifications will appear here.</p>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </div>

    </div>
</asp:Content>
