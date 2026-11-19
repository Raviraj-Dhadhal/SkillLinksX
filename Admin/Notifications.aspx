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
            cursor: pointer;
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

        .clickable-notif-area {
            cursor: pointer;
        }
        .clickable-notif-area:hover .notif-title-text {
            color: #0040A2;
        }

        /* Preview Modal Styling */
        .notif-modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 99999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }
        .notif-modal-dialog {
            background: #FFFFFF;
            border-radius: 16px;
            width: 100%;
            max-width: 600px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.05);
            border: 1px solid #E2E8F0;
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
            display: flex;
            flex-direction: column;
            max-height: 90vh;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(10px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .notif-modal-header {
            padding: 18px 24px;
            border-bottom: 1px solid #E2E8F0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #FAFAFA;
        }
        .notif-modal-header-left {
            display: flex;
            align-items: center;
            gap: 14px;
            min-width: 0;
        }
        .notif-modal-icon-badge {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: #EFF6FF;
            color: #0040A2;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }
        .notif-modal-title {
            margin: 0;
            font-size: 16.5px;
            font-weight: 700;
            color: #0F172A;
            line-height: 1.3;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            max-width: 440px;
        }
        .notif-modal-sub {
            font-size: 12.5px;
            color: #64748B;
            margin-top: 3px;
        }
        .notif-modal-close-btn {
            background: none;
            border: none;
            font-size: 24px;
            line-height: 1;
            color: #94A3B8;
            cursor: pointer;
            padding: 4px 8px;
            border-radius: 6px;
            transition: all 0.15s ease;
        }
        .notif-modal-close-btn:hover {
            color: #0F172A;
            background: #F1F5F9;
        }
        .notif-modal-body {
            padding: 22px 24px;
            overflow-y: auto;
            flex-grow: 1;
        }
        .notif-sender-card {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 18px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 12px;
        }
        .sender-info-item {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .sender-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748B;
        }
        .sender-value {
            font-size: 13.5px;
            font-weight: 600;
            color: #0F172A;
            word-break: break-all;
        }
        .sender-badge {
            display: inline-block;
            background: #EFF6FF;
            color: #0040A2;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            width: fit-content;
        }
        .notif-content-label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .notif-subject-box {
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
            font-weight: 600;
            color: #0F172A;
        }
        .notif-message-box {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 10px;
            padding: 16px;
            font-size: 14px;
            line-height: 1.6;
            color: #1E293B;
            white-space: pre-wrap;
            word-break: break-word;
            min-height: 90px;
            max-height: 280px;
            overflow-y: auto;
        }
        .notif-modal-footer {
            padding: 14px 24px;
            border-top: 1px solid #E2E8F0;
            background: #FAFAFA;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }
        .notif-modal-footer-left {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn-reply-email {
            padding: 8px 16px;
            background: #0040A2;
            color: #FFFFFF !important;
            font-size: 13px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }
        .btn-reply-email:hover {
            background: #00307B;
        }
        .btn-target-nav {
            padding: 8px 16px;
            background: #EFF6FF;
            color: #0040A2 !important;
            border: 1px solid #BFDBFE;
            font-size: 13px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }
        .btn-target-nav:hover {
            background: #DBEAFE;
        }
        .btn-modal-close {
            padding: 8px 18px;
            background: #F1F5F9;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            border-radius: 8px;
            border: 1px solid #CBD5E1;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-modal-close:hover {
            background: #E2E8F0;
            color: #0F172A;
        }
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
            <a href="Notifications.aspx?filter=inquiries" class='notif-tab-pill <%= CurrentFilter == "inquiries" ? "active" : "" %>'>
                Inquiries &amp; Complaints
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
                    <div class='notif-item <%# !(bool)Eval("is_read") ? "unread" : "" %>' data-id='<%# Eval("notification_id") %>'>
                        <div class='notif-unread-dot <%# (bool)Eval("is_read") ? "read" : "" %>'></div>

                        <div class="notif-icon-circle">
                            <i class='<%# GetIconClass(Eval("title").ToString()) %>'></i>
                        </div>

                        <div class="notif-text-block clickable-notif-area"
                            data-id='<%# Eval("notification_id") %>'
                            data-title='<%# HttpUtility.HtmlAttributeEncode(Eval("title").ToString()) %>'
                            data-message='<%# HttpUtility.HtmlAttributeEncode(Eval("message").ToString()) %>'
                            data-target='<%# HttpUtility.HtmlAttributeEncode(ResolveUrl(Eval("target_url")?.ToString() ?? "")) %>'
                            data-date='<%# Convert.ToDateTime(Eval("created_at")).ToString("MMM dd, yyyy • hh:mm tt") %>'
                            data-unread='<%# (!(bool)Eval("is_read")).ToString().ToLower() %>'>
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
                            <button type="button" 
                                class="btn-view-target btn-open-preview" 
                                data-id='<%# Eval("notification_id") %>'
                                data-title='<%# HttpUtility.HtmlAttributeEncode(Eval("title").ToString()) %>'
                                data-message='<%# HttpUtility.HtmlAttributeEncode(Eval("message").ToString()) %>'
                                data-target='<%# HttpUtility.HtmlAttributeEncode(ResolveUrl(Eval("target_url")?.ToString() ?? "")) %>'
                                data-date='<%# Convert.ToDateTime(Eval("created_at")).ToString("MMM dd, yyyy • hh:mm tt") %>'
                                data-unread='<%# (!(bool)Eval("is_read")).ToString().ToLower() %>'>
                                <i class="fa-solid fa-arrow-up-right-from-square"></i> View
                            </button>

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

        <!-- Notification / Complaint Preview Modal -->
        <div id="notifPreviewModal" class="notif-modal-backdrop" style="display:none;" onclick="handleModalBackdropClick(event)">
            <div class="notif-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
                <!-- Modal Header -->
                <div class="notif-modal-header">
                    <div class="notif-modal-header-left">
                        <div class="notif-modal-icon-badge" id="modalIconBadge">
                            <i class="fa-solid fa-envelope-open-text"></i>
                        </div>
                        <div>
                            <h3 class="notif-modal-title" id="modalTitle">Inquiry / Notification Preview</h3>
                            <div class="notif-modal-sub" id="modalDate">-</div>
                        </div>
                    </div>
                    <button type="button" class="notif-modal-close-btn" onclick="closeNotifModal()" aria-label="Close modal">&times;</button>
                </div>

                <!-- Modal Body -->
                <div class="notif-modal-body">
                    <!-- Dynamic Sender Details (Shown for Inquiries / Complaints / Direct Messages) -->
                    <div id="modalSenderCard" class="notif-sender-card" style="display:none;">
                        <div class="sender-info-item">
                            <span class="sender-label">Sender Name</span>
                            <span class="sender-value" id="modalSenderName">-</span>
                        </div>
                        <div class="sender-info-item">
                            <span class="sender-label">Email Address</span>
                            <a href="#" class="sender-value text-blue" id="modalSenderEmail" target="_blank">-</a>
                        </div>
                        <div class="sender-info-item">
                            <span class="sender-label">User Role</span>
                            <span class="sender-badge" id="modalSenderRole">-</span>
                        </div>
                    </div>

                    <!-- Subject / Title -->
                    <div class="notif-content-section">
                        <label class="notif-content-label">Subject / Title</label>
                        <div class="notif-subject-box" id="modalSubjectBox">-</div>
                    </div>

                    <!-- Full Message / Details Content -->
                    <div class="notif-content-section" style="margin-top: 14px;">
                        <label class="notif-content-label" id="modalMessageLabel">Message / Complaint Content</label>
                        <div class="notif-message-box" id="modalMessageBox">-</div>
                    </div>
                </div>

                <!-- Modal Footer -->
                <div class="notif-modal-footer">
                    <div class="notif-modal-footer-left">
                        <a id="modalReplyBtn" href="#" class="btn-reply-email" style="display:none;">
                            <i class="fa-solid fa-reply"></i> Reply via Email
                        </a>
                        <a id="modalTargetLink" href="#" class="btn-target-nav" style="display:none;">
                            <i class="fa-solid fa-arrow-up-right-from-square"></i> Open Associated Page
                        </a>
                    </div>
                    <div class="notif-modal-footer-right">
                        <button type="button" class="btn-modal-close" onclick="closeNotifModal()">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function openNotifPreviewFromElem(elem) {
                if (!elem) return;
                const notifId = elem.getAttribute('data-id') || '';
                const title = elem.getAttribute('data-title') || '';
                const rawMsg = elem.getAttribute('data-message') || '';
                const targetUrl = elem.getAttribute('data-target') || '';
                const dateStr = elem.getAttribute('data-date') || '';
                const isUnread = (elem.getAttribute('data-unread') === 'true');

                // Set Header
                document.getElementById('modalTitle').textContent = title || 'Notification Details';
                document.getElementById('modalDate').innerHTML = '<i class="fa-regular fa-clock" style="margin-right: 4px;"></i> ' + (dateStr || 'Recent');
                document.getElementById('modalSubjectBox').textContent = title || 'No Title';

                // Icon badge dynamic adjustment
                const iconBadge = document.getElementById('modalIconBadge');
                const tLower = (title || '').toLowerCase();
                if (tLower.includes('inquiry') || tLower.includes('complain') || tLower.includes('contact') || rawMsg.includes('Role:')) {
                    iconBadge.innerHTML = '<i class="fa-solid fa-envelope-open-text" style="color: #0040A2;"></i>';
                    document.getElementById('modalMessageLabel').textContent = 'Complaint / Inquiry Message';
                } else if (tLower.includes('company') || tLower.includes('verification')) {
                    iconBadge.innerHTML = '<i class="fa-solid fa-building-circle-check" style="color: #2563EB;"></i>';
                    document.getElementById('modalMessageLabel').textContent = 'System Alert Details';
                } else if (tLower.includes('student') || tLower.includes('candidate')) {
                    iconBadge.innerHTML = '<i class="fa-solid fa-user-graduate" style="color: #4F46E5;"></i>';
                    document.getElementById('modalMessageLabel').textContent = 'Student Notification Details';
                } else {
                    iconBadge.innerHTML = '<i class="fa-solid fa-shield-halved" style="color: #9333EA;"></i>';
                    document.getElementById('modalMessageLabel').textContent = 'Notification Details';
                }

                // Parser for Contact Inquiries / Complaints:
                // Format: "From: <name> (<email>, Role: <role>) Message: <msg>"
                const senderCard = document.getElementById('modalSenderCard');
                const replyBtn = document.getElementById('modalReplyBtn');
                const targetLink = document.getElementById('modalTargetLink');

                let senderName = '';
                let senderEmail = '';
                let senderRole = '';
                let actualMessage = rawMsg;
                let isSenderDetected = false;

                const inquiryRegex = /From:\s*([^(]+?)\s*\(\s*([^,]+?)\s*,\s*Role:\s*([^)]+?)\s*\)\s*(?:Message:\s*|\n*)([\s\S]*)/i;
                const match = rawMsg.match(inquiryRegex);

                if (match) {
                    isSenderDetected = true;
                    senderName = match[1].trim();
                    senderEmail = match[2].trim();
                    senderRole = match[3].trim();
                    actualMessage = match[4].trim() || 'No additional message text provided.';
                } else {
                    // Alternative format check
                    const emailRegex = /([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/;
                    const eMatch = rawMsg.match(emailRegex);
                    if (eMatch && (tLower.includes('inquiry') || tLower.includes('contact') || tLower.includes('complain'))) {
                        isSenderDetected = true;
                        senderEmail = eMatch[1];
                        senderName = title.replace(/^Contact Inquiry:\s*/i, '').trim() || 'Website Visitor';
                        senderRole = rawMsg.includes('Student') ? 'Student' : (rawMsg.includes('Company') ? 'Company' : 'User');
                        actualMessage = rawMsg.replace(/From:[^\n]+/i, '').replace(/^Message:\s*/i, '').trim();
                    }
                }

                if (isSenderDetected) {
                    senderCard.style.display = 'grid';
                    document.getElementById('modalSenderName').textContent = senderName || 'User';
                    const emailAnchor = document.getElementById('modalSenderEmail');
                    emailAnchor.textContent = senderEmail || 'N/A';
                    emailAnchor.href = senderEmail ? ('mailto:' + senderEmail + '?subject=Re: ' + encodeURIComponent(title)) : '#';
                    document.getElementById('modalSenderRole').textContent = senderRole || 'General';

                    if (senderEmail) {
                        replyBtn.style.display = 'inline-flex';
                        replyBtn.href = 'mailto:' + senderEmail + '?subject=Re: ' + encodeURIComponent(title);
                    } else {
                        replyBtn.style.display = 'none';
                    }
                } else {
                    senderCard.style.display = 'none';
                    replyBtn.style.display = 'none';
                }

                // Message box content
                document.getElementById('modalMessageBox').textContent = actualMessage || rawMsg || 'No details available.';

                // Target URL link if applicable (and not just pointing back to Dashboard)
                if (targetUrl && !targetUrl.toLowerCase().includes('dashboard.aspx') && targetUrl !== '#' && targetUrl !== '') {
                    targetLink.style.display = 'inline-flex';
                    targetLink.href = targetUrl;
                } else {
                    targetLink.style.display = 'none';
                }

                // Open Modal
                document.getElementById('notifPreviewModal').style.display = 'flex';
                document.body.style.overflow = 'hidden';

                // Automatically mark as read if currently unread
                if (notifId && isUnread) {
                    fetch('Notifications.aspx?ajax=mark_read&id=' + encodeURIComponent(notifId), { method: 'POST' })
                        .then(() => {
                            // Update row visually
                            elem.setAttribute('data-unread', 'false');
                            const notifRow = document.querySelector(`.notif-item[data-id="${notifId}"]`);
                            if (notifRow) {
                                notifRow.classList.remove('unread');
                                const dot = notifRow.querySelector('.notif-unread-dot');
                                if (dot) dot.classList.add('read');
                                const singleMarkBtn = notifRow.querySelector('.btn-mark-read-single');
                                if (singleMarkBtn) singleMarkBtn.style.display = 'none';
                            }
                            // Decrement unread badge in top metrics
                            const unreadSpan = document.querySelector('.admin-notif-tile .tile-info span');
                            if (unreadSpan) {
                                let cur = parseInt(unreadSpan.textContent.replace(/,/g, ''), 10);
                                if (!isNaN(cur) && cur > 0) {
                                    unreadSpan.textContent = (cur - 1).toLocaleString();
                                }
                            }
                        })
                        .catch(() => {});
                }
            }

            function closeNotifModal() {
                const modal = document.getElementById('notifPreviewModal');
                if (modal) modal.style.display = 'none';
                document.body.style.overflow = '';
            }

            function handleModalBackdropClick(e) {
                if (e.target.id === 'notifPreviewModal') {
                    closeNotifModal();
                }
            }

            // Keyboard ESC to close modal
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    closeNotifModal();
                }
            });

            // Delegate click on buttons and preview areas
            document.addEventListener('DOMContentLoaded', function () {
                document.addEventListener('click', function (e) {
                    const btn = e.target.closest('.btn-open-preview') || e.target.closest('.clickable-notif-area');
                    if (btn) {
                        e.preventDefault();
                        openNotifPreviewFromElem(btn);
                    }
                });
            });
        </script>

    </div>
</asp:Content>
