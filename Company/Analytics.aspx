<%@ Page Title="Company Analytics - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="SkillLinksX.Company.Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Analytics Head -->
    <style>
        .funnel-bar-track {
            position: relative !important;
            flex: 1 !important;
            height: 40px !important;
            background-color: #F1F5F9 !important;
            border-radius: 8px !important;
            overflow: hidden !important;
            display: flex !important;
            align-items: center !important;
        }
        .funnel-bar-fill {
            position: absolute !important;
            left: 0 !important;
            top: 0 !important;
            bottom: 0 !important;
            height: 100% !important;
            border-radius: 8px !important;
            transition: width 0.4s ease !important;
            z-index: 1 !important;
        }
        .funnel-label-name {
            position: relative !important;
            z-index: 2 !important;
            padding-left: 14px !important;
            font-size: 13px !important;
            font-weight: 600 !important;
            line-height: 40px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="analytics-page-container">

        <!-- Top Header Row -->
        <div class="analytics-header-row">
            <div>
                <h1 class="analytics-title">Company Analytics</h1>
                <p class="analytics-sub">Track your recruitment performance, candidate activity and hiring results.</p>
            </div>
            <div class="analytics-header-actions">
                <asp:DropDownList ID="ddlTimeFilter" runat="server" CssClass="analytics-time-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTimeFilter_SelectedIndexChanged" style="padding: 8px 14px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 13px; font-weight: 600; color: #334155; background: #fff; cursor: pointer;">
                    <asp:ListItem Text="Last 30 Days" Value="30" Selected="True" />
                    <asp:ListItem Text="Last 60 Days" Value="60" />
                    <asp:ListItem Text="Last 90 Days" Value="90" />
                    <asp:ListItem Text="Year to Date" Value="365" />
                    <asp:ListItem Text="All Time" Value="0" />
                </asp:DropDownList>
            </div>
        </div>

        <!-- 6 Metrics Tiles Grid (Scrollable container) -->
        <div class="analytics-metrics-scroll-wrapper">
            <div class="analytics-metrics-grid">
                <!-- Metric 1: Job Views -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Job Views</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value"><%= TotalViews.ToString("N0") %></span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> Live</span>
                    </div>
                </div>

                <!-- Metric 2: Applications -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Applications</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value"><%= TotalApps %></span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> Live</span>
                    </div>
                </div>

                <!-- Metric 3: Shortlisted -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Shortlisted</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value"><%= TotalShortlisted %></span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> Live</span>
                    </div>
                </div>

                <!-- Metric 4: Interviews -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Interviews</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value"><%= TotalInterviews %></span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> Live</span>
                    </div>
                </div>

                <!-- Metric 5: Hires -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Hires</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value"><%= TotalHired %></span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> Live</span>
                    </div>
                </div>

                <!-- Metric 6: Avg AI Match -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Avg AI Match</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value color-blue"><%= AvgAiMatch %>%</span>
                        <span class="an-match-quality-text"><%= AvgAiMatch >= 75 ? "Strong" : (AvgAiMatch >= 50 ? "Solid" : "Building") %></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2-Column Section: Applications Overview ApexChart (Left) + Recruitment Funnel (Right) -->
        <div class="analytics-charts-grid">

            <!-- Left: Applications & Recruitment Activity with ApexCharts -->
            <div class="chart-box-card">
                <div class="chart-card-header">
                    <h3 class="chart-card-title">Recruitment Activity</h3>
                    <div style="font-size:12px; color:#64748B; font-weight:500;">Direct from Database</div>
                </div>

                <!-- ApexCharts container -->
                <div id="applicationsOverviewChart" style="min-height: 290px;"></div>

                <!-- Database-injected chart data payload -->
                <script type="text/javascript">
                    window.dbCompanyChartCategories = <%= ChartCategoriesJson %>;
                    window.dbCompanyAppMonthly = <%= ChartMonthlyAppsJson %>;
                    window.dbCompanyInterviewMonthly = <%= ChartMonthlyInterviewsJson %>;
                </script>
            </div>

            <!-- Right: Recruitment Funnel -->
            <div class="chart-box-card">
                <div class="chart-card-header">
                    <h3 class="chart-card-title">Recruitment Funnel</h3>
                </div>

                <div class="funnel-bars-list">
                    <!-- Funnel 1: Views -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <% if (ViewsPct > 0) { %>
                                <div class="funnel-bar-fill" style="width: <%= ViewsPct %>%; background-color: #E2E8F0;"></div>
                            <% } %>
                            <span class="funnel-label-name" style="color: #0F172A;">Views</span>
                        </div>
                        <span class="funnel-count"><%= TotalViews.ToString("N0") %></span>
                    </div>

                    <!-- Funnel 2: Applications -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <% if (AppsPct > 0) { %>
                                <div class="funnel-bar-fill" style="width: <%= AppsPct %>%; background-color: #C7D7F7;"></div>
                            <% } %>
                            <span class="funnel-label-name" style="color: #0F172A;">Applications</span>
                        </div>
                        <span class="funnel-count"><%= TotalApps %></span>
                    </div>

                    <!-- Funnel 3: Shortlisted -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <% if (ShortlistedPct > 0) { %>
                                <div class="funnel-bar-fill" style="width: <%= ShortlistedPct %>%; background-color: #93B0FC;"></div>
                            <% } %>
                            <span class="funnel-label-name" style="color: #0F172A;">Shortlisted</span>
                        </div>
                        <span class="funnel-count"><%= TotalShortlisted %></span>
                    </div>

                    <!-- Funnel 4: Interviews -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <% if (InterviewsPct > 0) { %>
                                <div class="funnel-bar-fill" style="width: <%= InterviewsPct %>%; background-color: #4C7DE8;"></div>
                            <% } %>
                            <span class="funnel-label-name" style="color: <%= InterviewsPct >= 35 ? "#FFFFFF" : "#0F172A" %>;">Interviews</span>
                        </div>
                        <span class="funnel-count"><%= TotalInterviews %></span>
                    </div>

                    <!-- Funnel 5: Hired -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <% if (HiredPct > 0) { %>
                                <div class="funnel-bar-fill" style="width: <%= HiredPct %>%; background-color: #0040A2;"></div>
                            <% } %>
                            <span class="funnel-label-name" style="color: <%= HiredPct >= 35 ? "#FFFFFF" : "#0F172A" %>;">Hired / Selected</span>
                        </div>
                        <span class="funnel-count"><%= TotalHired %></span>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
