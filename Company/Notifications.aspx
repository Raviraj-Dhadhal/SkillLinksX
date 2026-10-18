<%@ Page Title="Notifications - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="SkillLinksX.Company.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Notifications Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="notifications-page-container">

        <!-- Header Row -->
        <div class="notifications-header-row">
            <div>
                <h1 class="notifications-title">Notifications</h1>
                <p class="notifications-sub">Stay updated with applications, interviews, jobs and important company activity.</p>
            </div>
            <div>
                <button type="button" class="btn-mark-all-read">
                    <i class="fa-solid fa-check-double"></i> Mark All as Read
                </button>
            </div>
        </div>

        <!-- Notifications Card Container -->
        <div class="notifications-list-card">
            
            <!-- Notification Item 1: New Application -->
            <div class="notif-item unread">
                <div class="notif-icon-box bg-blue-soft">
                    <i class="fa-solid fa-user-plus text-blue"></i>
                </div>
                <div class="notif-content-wrap">
                    <div class="notif-title-row">
                        <span class="notif-main-text"><strong>Vivek Gupta</strong> submitted an application for <strong>Software Developer</strong>.</span>
                        <span class="notif-time-ago">10 mins ago</span>
                    </div>
                    <p class="notif-snippet">AI Match Score: 94%. Strong overlap in React &amp; Node.js enterprise requirements.</p>
                    <div class="notif-quick-actions">
                        <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="notif-action-link">Review Application</a>
                    </div>
                </div>
                <div class="notif-dot"></div>
            </div>

            <!-- Notification Item 2: Interview Scheduled -->
            <div class="notif-item unread">
                <div class="notif-icon-box bg-green-soft">
                    <i class="fa-regular fa-calendar-check text-green"></i>
                </div>
                <div class="notif-content-wrap">
                    <div class="notif-title-row">
                        <span class="notif-main-text">Technical Interview scheduled with <strong>Mahek Godvani</strong>.</span>
                        <span class="notif-time-ago">1 hour ago</span>
                    </div>
                    <p class="notif-snippet">Confirmed for Today at 11:30 AM - 12:30 PM via Google Meet.</p>
                    <div class="notif-quick-actions">
                        <a href="<%= ResolveUrl("~/Company/Interviews.aspx") %>" class="notif-action-link">Open Calendar</a>
                    </div>
                </div>
                <div class="notif-dot"></div>
            </div>

            <!-- Notification Item 3: Job Expiring Alert -->
            <div class="notif-item">
                <div class="notif-icon-box bg-red-soft">
                    <i class="fa-solid fa-triangle-exclamation text-red"></i>
                </div>
                <div class="notif-content-wrap">
                    <div class="notif-title-row">
                        <span class="notif-main-text">Listing <strong>Senior Backend Engineer</strong> is expiring in 2 days.</span>
                        <span class="notif-time-ago">Yesterday</span>
                    </div>
                    <p class="notif-snippet">You have 42 pending applications to review before this job opportunity closes.</p>
                    <div class="notif-quick-actions">
                        <a href="<%= ResolveUrl("~/Company/ManageJobs.aspx") %>" class="notif-action-link">Manage Job</a>
                    </div>
                </div>
            </div>

            <!-- Notification Item 4: Assessment Completed -->
            <div class="notif-item">
                <div class="notif-icon-box bg-purple-soft">
                    <i class="fa-solid fa-code text-purple"></i>
                </div>
                <div class="notif-content-wrap">
                    <div class="notif-title-row">
                        <span class="notif-main-text"><strong>Raviraj Dhadhal</strong> completed the online technical assessment.</span>
                        <span class="notif-time-ago">2 days ago</span>
                    </div>
                    <p class="notif-snippet">Score: 92/100 (Expert level in C#, ASP.NET &amp; SQL Server).</p>
                    <div class="notif-quick-actions">
                        <a href="<%= ResolveUrl("~/Company/CandidateProfile.aspx") %>" class="notif-action-link">View Candidate Profile</a>
                    </div>
                </div>
            </div>

        </div>

    </div>
</asp:Content>
