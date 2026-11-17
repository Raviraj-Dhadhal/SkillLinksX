<%@ Page Title="Admin Dashboard - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SkillLinksX.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Dashboard Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-dashboard-container">

        <!-- Welcome Banner Header -->
        <div class="admin-greeting-header">
            <h1 class="admin-greeting-title">Welcome back, Admin</h1>
            <p class="admin-greeting-sub">Monitor and manage the SkillLinkX platform from one place.</p>
        </div>

        <!-- =========================================================================
             [DYNAMIC PLATFORM METRICS]: Real-time platform aggregates from SQL Server
             ========================================================================= -->
        <div class="admin-metrics-3grid">
            
            <!-- Card 1: Total Students -->
            <div class="admin-metric-card">
                <div class="admin-metric-info">
                    <span class="admin-metric-label">TOTAL STUDENTS</span>
                    <span class="admin-metric-num"><%= TotalStudents %></span>
                    <span class="admin-metric-trend">
                        <i class="fa-solid fa-arrow-trend-up"></i> Registered Students
                    </span>
                </div>
                <div class="admin-metric-icon-box icon-blue-subtle">
                    <i class="fa-solid fa-graduation-cap"></i>
                </div>
            </div>

            <!-- Card 2: Total Companies -->
            <div class="admin-metric-card">
                <div class="admin-metric-info">
                    <span class="admin-metric-label">TOTAL COMPANIES</span>
                    <span class="admin-metric-num"><%= TotalCompanies %></span>
                    <span class="admin-metric-trend">
                        <i class="fa-solid fa-arrow-trend-up"></i> Partner Employers
                    </span>
                </div>
                <div class="admin-metric-icon-box icon-gray-subtle">
                    <i class="fa-solid fa-building"></i>
                </div>
            </div>

            <!-- Card 3: Active Jobs/Internships -->
            <div class="admin-metric-card">
                <div class="admin-metric-info">
                    <span class="admin-metric-label">ACTIVE OPPORTUNITIES</span>
                    <span class="admin-metric-num"><%= ActiveOpportunities %></span>
                    <span class="admin-metric-trend">
                        <i class="fa-solid fa-arrow-trend-up"></i> Live Postings
                    </span>
                </div>
                <div class="admin-metric-icon-box icon-green-subtle">
                    <i class="fa-solid fa-briefcase"></i>
                </div>
            </div>

        </div>

        <!-- 2-Column Split: Left (User Growth Linear Analytics) + Right (System Health & Critical Alerts) -->
        <div class="admin-middle-grid">

            <!-- Left: User Growth Analytics Chart Card -->
            <div class="admin-growth-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">User Growth Analytics</h2>
                    <a href="<%= ResolveUrl("~/Admin/Analytics.aspx") %>" class="admin-view-report-link">
                        View Detailed Report <i class="fa-solid fa-arrow-right"></i>
                    </a>
                </div>
                <!-- Interactive Linear Growth Chart Container rendered by ApexCharts in admin.js -->
                <div class="admin-chart-wrapper" id="userGrowthChart"></div>
                
                <!-- Database-injected chart data payload -->
                <script type="text/javascript">
                    window.dbAdminStudentGrowth = <%= ChartStudentSeriesJson %>;
                    window.dbAdminCompanyGrowth = <%= ChartCompanySeriesJson %>;
                </script>
            </div>

            <!-- Right: System Health & Critical Alerts Stack -->
            <div class="admin-health-stack">
                
                <!-- System Health Panel -->
                <div class="admin-system-health-card">
                    <div class="admin-card-header">
                        <h2 class="admin-card-title">System Health</h2>
                    </div>
                    <div class="health-items-list">
                        <div class="health-status-row">
                            <div class="health-item-left">
                                <i class="fa-regular fa-circle-check"></i>
                                <span>Platform Core</span>
                            </div>
                            <span class="badge-operational">Operational</span>
                        </div>
                        <div class="health-status-row">
                            <div class="health-item-left">
                                <i class="fa-regular fa-circle-check"></i>
                                <span>Database</span>
                            </div>
                            <span class="badge-operational">Operational</span>
                        </div>
                        <div class="health-status-row">
                            <div class="health-item-left">
                                <i class="fa-regular fa-circle-check"></i>
                                <span>AI Matching</span>
                            </div>
                            <span class="badge-operational">Operational</span>
                        </div>
                    </div>
                </div>

                <!-- Critical Alerts Panel -->
                <div class="admin-critical-alert-card">
                    <i class="fa-solid fa-triangle-exclamation alert-triangle-icon"></i>
                    <div class="alert-body-stack">
                        <span class="alert-title-strong">Critical Alerts</span>
                        <p class="alert-desc-text">12 companies waiting for verification over 48 hours.</p>
                        <a href="<%= ResolveUrl("~/Admin/Companies.aspx") %>" class="alert-action-link">Review Now</a>
                    </div>
                </div>

            </div>

        </div>

        <!-- Bottom Table: Pending Approvals & Recent Activity -->
        <div class="admin-activity-card">
            <div class="activity-header-flex">
                <h2 class="activity-header-title">Pending Approvals &amp; Recent Activity</h2>
                <div class="activity-actions-group">
                    <button type="button" class="btn-admin-filter">Filter</button>
                    <button type="button" class="btn-admin-view-all">View All</button>
                </div>
            </div>

            <div class="admin-table-responsive">
                <table class="admin-data-table">
                    <thead>
                        <tr>
                            <th>Entity</th>
                            <th>Type</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- =========================================================
                             [DYNAMIC RECENT USERS REPEATER]: Binds recent signups
                             ========================================================= -->
                        <asp:Repeater ID="rptRecentUsers" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="entity-cell-flex">
                                            <div class="entity-avatar-box round">
                                                <img src='<%# ResolveUrl("~/assets/images/user-male-logo.png") %>' alt="User" class="entity-avatar-img" />
                                            </div>
                                            <div>
                                                <div class="entity-name-bold"><%# Eval("FullName") %></div>
                                                <div class="entity-sub-desc"><%# Eval("Email") %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><%# Eval("Role") %></td>
                                    <td>India</td>
                                    <td><%# Eval("JoinedDate") %></td>
                                    <td>
                                        <span class='badge-status-<%# Eval("AccountStatus").ToString().ToLower() %>'>
                                            <%# Eval("AccountStatus") %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="row-actions-group">
                                            <a href='<%# ResolveUrl("~/Admin/Students.aspx") %>' class="btn-action-icon action-view" title="Manage Account">
                                                <i class="fa-regular fa-eye"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</asp:Content>
