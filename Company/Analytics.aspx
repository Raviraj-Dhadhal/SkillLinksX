<%@ Page Title="Company Analytics - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="SkillLinksX.Company.Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Analytics Head -->
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
                        <span class="an-metric-value color-blue">89%</span>
                        <span class="an-match-quality-text">Solid</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2-Column Section: Applications Overview ApexChart (Left) + Recruitment Funnel (Right) -->
        <div class="analytics-charts-grid">

            <!-- Left: Applications Overview with ApexCharts -->
            <div class="chart-box-card">
                <div class="chart-card-header">
                    <h3 class="chart-card-title">Applications Overview</h3>
                    <button type="button" class="btn-chart-more" aria-label="More Options">
                        <i class="fa-solid fa-ellipsis"></i>
                    </button>
                </div>

                <!-- ApexCharts container -->
                <div id="applicationsOverviewChart" style="min-height: 290px;"></div>

                <!-- Database-injected chart data payload -->
                <script type="text/javascript">
                    window.dbCompanyAppMonthly = <%= ChartMonthlyAppsJson %>;
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
                            <div class="funnel-bar-fill fill-100">
                                <span class="funnel-label-name">Views</span>
                            </div>
                        </div>
                        <span class="funnel-count"><%= TotalViews.ToString("N0") %></span>
                    </div>

                    <!-- Funnel 2: Applications -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-75">
                                <span class="funnel-label-name">Applications</span>
                            </div>
                        </div>
                        <span class="funnel-count"><%= TotalApps %></span>
                    </div>

                    <!-- Funnel 3: Shortlisted -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-50">
                                <span class="funnel-label-name">Shortlisted</span>
                            </div>
                        </div>
                        <span class="funnel-count"><%= TotalShortlisted %></span>
                    </div>

                    <!-- Funnel 4: Interviews -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-30">
                                <span class="funnel-label-name">Interviews</span>
                            </div>
                        </div>
                        <span class="funnel-count"><%= TotalInterviews %></span>
                    </div>

                    <!-- Funnel 5: Hired -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-15">
                                <span class="funnel-label-name">Hired / Selected</span>
                            </div>
                        </div>
                        <span class="funnel-count"><%= TotalHired %></span>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
