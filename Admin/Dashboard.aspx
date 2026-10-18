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

        <!-- 3 Summary Metrics Cards Row -->
        <div class="admin-metrics-3grid">
            
            <!-- Card 1: Total Students -->
            <div class="admin-metric-card">
                <div class="admin-metric-info">
                    <span class="admin-metric-label">TOTAL STUDENTS</span>
                    <span class="admin-metric-num">45,231</span>
                    <span class="admin-metric-trend">
                        <i class="fa-solid fa-arrow-trend-up"></i> +12.5% this month
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
                    <span class="admin-metric-num">1,845</span>
                    <span class="admin-metric-trend">
                        <i class="fa-solid fa-arrow-trend-up"></i> +4.2% this month
                    </span>
                </div>
                <div class="admin-metric-icon-box icon-gray-subtle">
                    <i class="fa-solid fa-building"></i>
                </div>
            </div>

            <!-- Card 3: Active Jobs/Internships -->
            <div class="admin-metric-card">
                <div class="admin-metric-info">
                    <span class="admin-metric-label">ACTIVE JOBS/INTERNSHIPS</span>
                    <span class="admin-metric-num">8,402</span>
                    <span class="admin-metric-trend">
                        <i class="fa-solid fa-arrow-trend-up"></i> +8.1% this month
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
                        <!-- Row 1: TechNova Solutions -->
                        <tr>
                            <td>
                                <div class="entity-cell-flex">
                                    <div class="entity-avatar-box">
                                        <img src="<%= ResolveUrl("~/assets/images/technova-avatar.svg") %>" alt="TechNova" class="entity-avatar-img" />
                                    </div>
                                    <div>
                                        <div class="entity-name-bold">TechNova Solutions</div>
                                        <div class="entity-sub-desc">IT Services</div>
                                    </div>
                                </div>
                            </td>
                            <td>Company</td>
                            <td>Bengaluru</td>
                            <td>Oct 24, 2026</td>
                            <td>
                                <span class="badge-status-pending">Pending</span>
                            </td>
                            <td>
                                <div class="row-actions-group">
                                    <button type="button" class="btn-action-icon action-approve" title="Approve" onclick="alert('TechNova approved successfully');">
                                        <i class="fa-solid fa-check"></i>
                                    </button>
                                    <button type="button" class="btn-action-icon action-reject" title="Reject" onclick="alert('TechNova rejected');">
                                        <i class="fa-solid fa-xmark"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <!-- Row 2: Raviraj Dhadhal -->
                        <tr>
                            <td>
                                <div class="entity-cell-flex">
                                    <div class="entity-avatar-box round">
                                        <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" class="entity-avatar-img" />
                                    </div>
                                    <div>
                                        <div class="entity-name-bold">Raviraj Dhadhal</div>
                                        <div class="entity-sub-desc">B.Tech CS, IIT Bombay</div>
                                    </div>
                                </div>
                            </td>
                            <td>Student</td>
                            <td>Mumbai</td>
                            <td>Oct 24, 2026</td>
                            <td>
                                <span class="badge-status-verified">Verified</span>
                            </td>
                            <td>
                                <div class="row-actions-group">
                                    <button type="button" class="btn-action-icon action-view" title="View Profile" onclick="alert('Viewing Raviraj Dhadhal profile');">
                                        <i class="fa-regular fa-eye"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</asp:Content>
