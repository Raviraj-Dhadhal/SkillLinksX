<%@ Page Title="Reports & Analytics - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="SkillLinksX.Admin.Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- ApexCharts CDN -->
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Reports &amp; Analytics</h1>
                <p class="admin-page-main-sub">Track platform growth, recruitment activity and hiring performance.</p>
            </div>
            <div class="analytics-header-actions-flex">
                <select id="analyticsTimePeriod" class="admin-native-period-select">
                    <option value="7">Last 7 Days</option>
                    <option value="30" selected="selected">Last 30 Days</option>
                    <option value="90">Last 90 Days</option>
                    <option value="365">Year-to-Date</option>
                </select>
                <button type="button" class="btn-admin-primary-add" onclick="alert('Exporting analytics report as CSV/PDF...');">
                    <i class="fa-solid fa-download"></i> Export Report
                </button>
            </div>
        </div>

        <!-- Metric Card (Single card as designed in screenshot) -->
        <div class="admin-reports-top-metrics" style="margin-top: 24px; margin-bottom: 24px;">
            <div class="admin-stat-card" style="max-width: 260px; background:#FFFFFF; border:1px solid #E2E8F0; border-radius:12px; padding:20px;">
                <div class="stat-top-row flex-between" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                    <span class="stat-label" style="font-size:12px; font-weight:700; color:#475569;">Total Students</span>
                    <span class="stat-icon-wrap" style="color:#0D9488; font-size:18px;"><i class="fa-solid fa-graduation-cap"></i></span>
                </div>
                <div class="stat-num-val" style="font-size:26px; font-weight:800; color:#0F172A; margin-bottom:4px;">25,480</div>
                <div class="stat-sub-trend-line font-green" style="font-size:12px; font-weight:600; color:#10B981;"><i class="fa-solid fa-arrow-up"></i> +12.5% vs last month</div>
            </div>
        </div>

        <!-- Placeholder Canvas as shown in Figma SS -->
    </div>
</asp:Content>
