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
            <a href="javascript:void(0);" class="btn-mark-all-read" onclick="markAllAsRead()">
                <i class="fa-solid fa-check-double"></i> Mark All as Read
            </a>
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
                <span class="notif-metric-val">3</span>
            </div>

            <div class="notif-metric-tile">
                <div class="notif-metric-top flex-between">
                    <span class="notif-metric-label">Applications</span>
                    <div class="notif-metric-icon-box bg-indigo-subtle">
                        <i class="fa-regular fa-file-lines"></i>
                    </div>
                </div>
                <span class="notif-metric-val">1</span>
            </div>

            <div class="notif-metric-tile">
                <div class="notif-metric-top flex-between">
                    <span class="notif-metric-label">Interviews</span>
                    <div class="notif-metric-icon-box bg-green-subtle">
                        <i class="fa-solid fa-video"></i>
                    </div>
                </div>
                <span class="notif-metric-val">1</span>
            </div>

            <div class="notif-metric-tile">
                <div class="notif-metric-top flex-between">
                    <span class="notif-metric-label">Networking</span>
                    <div class="notif-metric-icon-box bg-purple-subtle">
                        <i class="fa-solid fa-user-group"></i>
                    </div>
                </div>
                <span class="notif-metric-val">2</span>
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

            <!-- Item 1: Application Shortlisted (Unread) -->
            <div class="notif-card-item unread">
                <div class="notif-unread-blue-dot"></div>
                <div class="notif-icon-circle bg-blue-light">
                    <i class="fa-regular fa-file-lines"></i>
                </div>
                <div class="notif-text-content">
                    <p class="notif-body-line">
                        Your application for <strong>Software Developer Intern</strong> at <strong>TechNova</strong> has been shortlisted.
                    </p>
                    <span class="notif-time-ago">2m ago</span>
                </div>
            </div>

            <!-- Item 2: Connection Request Accepted -->
            <div class="notif-card-item">
                <div class="notif-unread-blue-dot invisible"></div>
                <div class="notif-avatar-circle">
                    <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Mahek Godvani" class="notif-avatar-img" />
                </div>
                <div class="notif-text-content">
                    <p class="notif-body-line">
                        <strong>Mahek Godvani</strong> accepted your connection request.
                    </p>
                    <span class="notif-time-ago">1h ago</span>
                </div>
            </div>

            <!-- Item 3: Interview Scheduled (Unread) -->
            <div class="notif-card-item unread">
                <div class="notif-unread-blue-dot"></div>
                <div class="notif-icon-circle bg-green-light">
                    <i class="fa-solid fa-video"></i>
                </div>
                <div class="notif-text-content">
                    <p class="notif-body-line">
                        Your interview for <strong>Software Developer</strong> at <strong>Zomato</strong> is scheduled for tomorrow at 11:00 AM.
                    </p>
                    <span class="notif-time-ago">3h ago</span>
                </div>
            </div>

            <!-- Item 4: Internship Match -->
            <div class="notif-card-item">
                <div class="notif-unread-blue-dot invisible"></div>
                <div class="notif-icon-circle bg-sky-light">
                    <i class="fa-solid fa-briefcase"></i>
                </div>
                <div class="notif-text-content">
                    <p class="notif-body-line">
                        A new internship matches <strong>94%</strong> of your skills.
                    </p>
                    <span class="notif-time-ago">5h ago</span>
                </div>
            </div>

        </div>

        <!-- Load More Button -->
        <div class="notif-load-more-row text-center">
            <button type="button" class="btn-load-more-notifs" onclick="this.innerHTML='All caught up!'; this.disabled=true;">
                Load More
            </button>
        </div>

    </div>
</asp:Content>
