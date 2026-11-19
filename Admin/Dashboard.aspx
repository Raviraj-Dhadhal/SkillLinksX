<%@ Page Title="Admin Dashboard - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SkillLinksX.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Dashboard Styling -->
    <style>
        .admin-critical-alert-card.is-success {
            border-left-color: #10B981 !important;
            background-color: #F0FDF4;
        }
        .admin-critical-alert-card.alert-warning-theme {
            border-left-color: #F59E0B !important;
            background-color: #FFFBEB;
        }
        .alert-success-icon {
            color: #10B981;
            font-size: 18px;
            margin-top: 2px;
        }
        .alert-warning-icon {
            color: #F59E0B;
            font-size: 18px;
            margin-top: 2px;
        }
        .badge-status-active {
            background-color: #ECFDF5;
            color: #065F46;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .badge-status-pending {
            background-color: #FEF3C7;
            color: #92400E;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .badge-status-suspended {
            background-color: #FEE2E2;
            color: #991B1B;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .badge-degraded {
            background-color: #FEF2F2;
            color: #DC2626;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 4px;
        }
        .admin-filter-pill-group {
            display: inline-flex;
            background: #F1F5F9;
            padding: 3px;
            border-radius: 8px;
            gap: 2px;
        }
        .admin-pill-btn {
            border: none;
            background: transparent;
            font-size: 12px;
            font-weight: 600;
            color: #64748B;
            padding: 6px 14px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .admin-pill-btn:hover {
            color: #0F172A;
        }
        .admin-pill-btn.active {
            background: #FFFFFF;
            color: #0040A2;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
        }
        .entity-avatar-fallback.student {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #EFF6FF;
            color: #0040A2;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }
        .entity-avatar-fallback.company {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            background: #EFF6FF;
            color: #0040A2;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }
        .activity-actions-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn-admin-view-all {
            display: inline-flex;
            align-items: center;
            text-decoration: none;
            background-color: #0040A2;
            color: #FFFFFF !important;
            font-size: 12.5px;
            font-weight: 600;
            padding: 7px 16px;
            border-radius: 8px;
            transition: background 0.2s ease;
        }
        .btn-admin-view-all:hover {
            background-color: #003080;
        }
    </style>
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

            <!-- Card 3: Active Opportunities (Jobs + Internships) -->
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
                    window.dbAdminCategories = <%= ChartCategoriesJson %>;
                </script>
            </div>

            <!-- Right: System Health & Critical Alerts Stack -->
            <div class="admin-health-stack">
                
                <!-- Dynamic System Health Panel -->
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
                            <span class="<%= CoreHealthClass %>"><%= CoreHealthStatus %></span>
                        </div>
                        <div class="health-status-row">
                            <div class="health-item-left">
                                <i class="fa-regular fa-circle-check"></i>
                                <span>Database</span>
                            </div>
                            <span class="<%= DatabaseHealthClass %>" title="Latency: <%= DatabaseHealthLatency %>"><%= DatabaseHealthStatus %> (<%= DatabaseHealthLatency %>)</span>
                        </div>
                        <div class="health-status-row">
                            <div class="health-item-left">
                                <i class="fa-regular fa-circle-check"></i>
                                <span>AI Matching</span>
                            </div>
                            <span class="<%= AiHealthClass %>"><%= AiHealthStatus %></span>
                        </div>
                    </div>
                </div>

                <!-- Dynamic Critical Alerts Panel (Data-Driven from SQL) -->
                <div class="<%= CriticalAlertCardClass %>">
                    <i class="<%= CriticalAlertIconClass %>"></i>
                    <div class="alert-body-stack">
                        <span class="alert-title-strong"><%= CriticalAlertTitle %></span>
                        <p class="alert-desc-text"><%= CriticalAlertMessage %></p>
                        <a href="<%= CriticalAlertActionUrl %>" class="alert-action-link"><%= CriticalAlertActionText %> <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                </div>

            </div>

        </div>

        <!-- Bottom Table: Dynamic Pending Approvals & Recent Activity -->
        <div class="admin-activity-card">
            <div class="activity-header-flex">
                <h2 class="activity-header-title">Pending Approvals &amp; Recent Activity</h2>
                <div class="activity-actions-group">
                    <div class="admin-filter-pill-group">
                        <button type="button" class="admin-pill-btn active" onclick="filterRecentActivity('all', this)">All</button>
                        <button type="button" class="admin-pill-btn" onclick="filterRecentActivity('Student', this)">Students</button>
                        <button type="button" class="admin-pill-btn" onclick="filterRecentActivity('Company', this)">Companies</button>
                        <button type="button" class="admin-pill-btn" onclick="filterRecentActivity('pending', this)">Pending</button>
                    </div>
                </div>
            </div>

            <div class="admin-table-responsive">
                <table class="admin-data-table" id="tblRecentActivity">
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
                             [DYNAMIC RECENT USERS REPEATER]: Binds recent signups (Students & Employers)
                             ========================================================= -->
                        <asp:Repeater ID="rptRecentUsers" runat="server">
                            <ItemTemplate>
                                <tr class="recent-activity-row" data-role='<%# Eval("Role") %>' data-status='<%# Eval("AccountStatus").ToString().ToLower() %>'>
                                    <td>
                                        <div class="entity-cell-flex">
                                            <div class="entity-avatar-box round">
                                                <%# !string.IsNullOrEmpty(Eval("ProfilePhoto").ToString()) 
                                                    ? "<img src='" + ResolveUrl(Eval("ProfilePhoto").ToString()) + "' alt='Avatar' class='entity-avatar-img' />"
                                                    : (Eval("Role").ToString() == "Company" 
                                                        ? "<div class='entity-avatar-fallback company'><i class='fa-solid fa-building'></i></div>"
                                                        : "<div class='entity-avatar-fallback student'><i class='fa-regular fa-user'></i></div>") 
                                                %>
                                            </div>
                                            <div>
                                                <div class="entity-name-bold"><%# Eval("FullName") %></div>
                                                <div class="entity-sub-desc"><%# Eval("Email") %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><%# Eval("Role") %></td>
                                    <td><%# Eval("Location") %></td>
                                    <td><%# Eval("JoinedDate") %></td>
                                    <td>
                                        <span class='<%# Eval("StatusClass") %>'>
                                            <%# Eval("AccountStatus") %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="row-actions-group">
                                            <a href='<%# ResolveUrl(Eval("ManageUrl").ToString()) %>' class="btn-action-icon action-view" title="Manage Entity">
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

    <!-- Quick Real-Time Filter Script for Recent Activity Table -->
    <script type="text/javascript">
        function filterRecentActivity(filter, btn) {
            document.querySelectorAll('.admin-pill-btn').forEach(function (b) {
                b.classList.remove('active');
            });
            if (btn) btn.classList.add('active');

            var rows = document.querySelectorAll('.recent-activity-row');
            rows.forEach(function (row) {
                var role = row.getAttribute('data-role') || '';
                var status = row.getAttribute('data-status') || '';

                if (filter === 'all') {
                    row.style.display = '';
                } else if (filter === 'pending') {
                    if (status.indexOf('pending') >= 0) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                } else {
                    if (role.toLowerCase() === filter.toLowerCase()) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            });
        }
    </script>
</asp:Content>