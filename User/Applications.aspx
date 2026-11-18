<%@ Page Title="My Applications - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Applications.aspx.cs" Inherits="SkillLinksX.User.Applications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Applications Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-apps-page-container">

        <!-- Page Header -->
        <div class="apps-page-header">
            <h1 class="apps-page-title">My Applications</h1>
            <p class="apps-page-sub">Track and manage all your job and internship applications in one place.</p>
        </div>

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Real-time application counters from SQL Server
             ========================================================================= -->
        <div class="apps-metrics-grid">
            <!-- 1. Total Applications -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Total Applications</span>
                <span class="app-metric-val"><%= TotalApplications %></span>
            </div>
            <!-- 2. Under Review -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Under Review</span>
                <span class="app-metric-val color-blue"><%= UnderReviewCount %></span>
            </div>
            <!-- 3. Shortlisted -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Shortlisted</span>
                <span class="app-metric-val color-green"><%= ShortlistedCount %></span>
            </div>
            <!-- 4. Interviews -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Interviews</span>
                <span class="app-metric-val color-orange"><%= InterviewCount %></span>
            </div>
            <!-- 5. Selected -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Selected</span>
                <span class="app-metric-val color-teal"><%= SelectedCount %></span>
            </div>
        </div>

        <!-- Main Workspace: Left Applications List + Right Side Panels -->
        <div class="apps-layout-grid">

            <!-- Left Main Column -->
            <div class="apps-main-column">

                <!-- Filter Pills Navigation Tabs -->
                <div class="apps-filter-tabs-wrapper">
                    <button type="button" class="app-tab-pill active">All</button>
                    <button type="button" class="app-tab-pill">Jobs</button>
                    <button type="button" class="app-tab-pill">Internships</button>
                    <button type="button" class="app-tab-pill">Under Review</button>
                    <button type="button" class="app-tab-pill">Shortlisted</button>
                    <button type="button" class="app-tab-pill">Interview</button>
                    <button type="button" class="app-tab-pill">Selected</button>
                    <button type="button" class="app-tab-pill">Rejected</button>
                </div>

                <!-- =================================================================
                     [APPLICATIONS REPEATER]: Binds all submitted applications for user
                     ================================================================= -->
                <div class="apps-list-container">
                    <asp:Repeater ID="rptApplicationsList" runat="server">
                        <ItemTemplate>
                            <div class="app-row-card">
                                <div class="app-row-left">
                                    <div class="app-company-logo">
                                        <i class="fa-solid fa-briefcase" style="font-size:20px; color:#2563eb;"></i>
                                    </div>
                                    <div class="app-details-stack">
                                        <h3 class="app-role-name"><%# Eval("JobTitle") %></h3>
                                        <div class="app-meta-line">
                                            <span class="app-comp"><%# Eval("CompanyName") %></span> &bull; 
                                            <span class="app-loc"><%# Eval("Location") %></span> &bull; 
                                            <span class="app-time"><%# Eval("AppliedTime") %></span>
                                        </div>
                                        <div class="app-type-badge-wrap">
                                            <span class="app-type-pill"><%# Eval("JobType") %></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="app-row-right">
                                    <span class='app-status-badge <%# Eval("StatusBadgeClass") %>'>&bull; <%# Eval("Status") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <% if (TotalApplications == 0) { %>
                        <div style="padding:48px 24px; text-align:center; background:#fff; border-radius:12px; border:1px dashed #cbd5e1; margin-top:16px;">
                            <i class="fa-regular fa-folder-open" style="font-size:36px; color:#94a3b8; margin-bottom:12px; display:block;"></i>
                            <h3 style="font-size:16px; font-weight:700; color:#1e293b; margin:0 0 6px;">No Applications Submitted Yet</h3>
                            <p style="font-size:13px; color:#64748b; margin:0 0 16px;">Explore open internships and jobs to start applying directly.</p>
                            <a href="<%= ResolveUrl("~/User/Internships.aspx") %>" style="display:inline-block; padding:9px 20px; background:#2563eb; color:#fff; font-size:13px; font-weight:600; border-radius:8px; text-decoration:none;">
                                Browse Internships
                            </a>
                        </div>
                    <% } %>
                </div>

            </div>

            <!-- Right Sidebar Column (Upcoming Interviews + Application Details) -->
            <div class="apps-sidebar-column">
                <% if (TotalApplications > 0) { %>
                    <!-- Application Details Card -->
                    <div class="apps-side-card">
                        <h3 class="side-card-top-title">Application Status</h3>
                        <p style="font-size:13px; color:#64748b; margin-top:8px;">You have <strong><%= TotalApplications %></strong> active application(s). Check your Notifications for updates from recruiters.</p>
                    </div>
                <% } else { %>
                    <div class="apps-side-card" style="text-align:center; padding:28px 16px;">
                        <i class="fa-regular fa-clipboard" style="font-size:28px; color:#94a3b8; margin-bottom:10px; display:block;"></i>
                        <h4 style="font-size:14px; font-weight:700; color:#334155; margin:0 0 4px;">No Active Application</h4>
                        <p style="font-size:12px; color:#64748b; margin:0;">Select or submit an application to view live tracking.</p>
                    </div>
                <% } %>
            </div>

        </div>

    </div>
</asp:Content>
