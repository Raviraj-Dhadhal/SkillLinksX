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
                <select class="analytics-time-select">
                    <option selected="selected">Last 30 Days</option>
                    <option>Last 60 Days</option>
                    <option>Last 90 Days</option>
                    <option>Year to Date</option>
                </select>
                <button type="button" class="btn-analytics-export">
                    <i class="fa-solid fa-download"></i> Export Report
                </button>
            </div>
        </div>

        <!-- 6 Metrics Tiles Grid (Scrollable container) -->
        <div class="analytics-metrics-scroll-wrapper">
            <div class="analytics-metrics-grid">
                <!-- Metric 1: Job Views -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Job Views</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value">18,420</span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> 12%</span>
                    </div>
                </div>

                <!-- Metric 2: Applications -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Applications</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value">1,284</span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> 8%</span>
                    </div>
                </div>

                <!-- Metric 3: Shortlisted -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Shortlisted</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value">286</span>
                        <span class="an-trend-badge trend-down"><i class="fa-solid fa-arrow-down"></i> 3%</span>
                    </div>
                </div>

                <!-- Metric 4: Interviews -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Interviews</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value">142</span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> 5%</span>
                    </div>
                </div>

                <!-- Metric 5: Hires -->
                <div class="analytics-metric-card">
                    <div class="an-metric-label">Hires</div>
                    <div class="an-metric-row">
                        <span class="an-metric-value">48</span>
                        <span class="an-trend-badge trend-up"><i class="fa-solid fa-arrow-up"></i> 15%</span>
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
                        <span class="funnel-count">18,420</span>
                    </div>

                    <!-- Funnel 2: Applications -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-75">
                                <span class="funnel-label-name">Applications</span>
                            </div>
                        </div>
                        <span class="funnel-count">1,284</span>
                    </div>

                    <!-- Funnel 3: Shortlisted -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-50">
                                <span class="funnel-label-name">Shortlisted</span>
                            </div>
                        </div>
                        <span class="funnel-count">286</span>
                    </div>

                    <!-- Funnel 4: Interviews -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-30">
                                <span class="funnel-label-name">Interviews</span>
                            </div>
                        </div>
                        <span class="funnel-count">142</span>
                    </div>

                    <!-- Funnel 5: Hired -->
                    <div class="funnel-row-item">
                        <div class="funnel-bar-track">
                            <div class="funnel-bar-fill fill-15">
                                <span class="funnel-label-name">Hired</span>
                            </div>
                        </div>
                        <span class="funnel-count">48</span>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
