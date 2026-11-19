<%@ Page Title="Reports & Analytics - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="SkillLinksX.Admin.Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- ApexCharts CDN -->
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <style>
        .admin-page-header-flex {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }
        .admin-page-main-title {
            font-size: 24px;
            font-weight: 800;
            color: #0F172A;
            margin: 0 0 6px 0;
            letter-spacing: -0.02em;
        }
        .admin-page-main-sub {
            font-size: 13.5px;
            color: #64748B;
            margin: 0;
        }
        .analytics-header-actions-flex {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .admin-native-period-select {
            min-width: 170px;
            height: 40px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            padding: 0 38px 0 14px;
            font-size: 13.5px;
            font-weight: 600;
            color: #1E293B;
            background-color: #FFFFFF;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2364748B'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 14px;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            cursor: pointer;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
            transition: all 0.2s ease;
        }
        .admin-native-period-select:hover {
            border-color: #94A3B8;
            background-color: #F8FAFC;
        }
        .admin-native-period-select:focus {
            outline: none;
            border-color: #0040A2;
            box-shadow: 0 0 0 3px rgba(0, 64, 162, 0.12);
            background-color: #FFFFFF;
        }
    </style>
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
                <select id="analyticsTimePeriod" class="admin-native-period-select"
                    data-count-7="<%= Count7Days %>"
                    data-count-30="<%= Count30Days %>"
                    data-count-90="<%= Count90Days %>"
                    data-count-365="<%= CountAllTime %>">
                    <option value="7">Last 7 Days</option>
                    <option value="30" selected="selected">Last 30 Days</option>
                    <option value="90">Last 90 Days</option>
                    <option value="365">Year-to-Date</option>
                </select>
            </div>
        </div>

        <!-- Metric Card (100% Dynamic from dbo.member_master_table & dbo.user_auth) -->
        <div class="admin-reports-top-metrics" style="margin-top: 24px; margin-bottom: 24px;">
            <div class="admin-stat-card" style="max-width: 260px; background:#FFFFFF; border:1px solid #E2E8F0; border-radius:12px; padding:20px;">
                <div class="stat-top-row flex-between" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                    <span class="stat-label" style="font-size:12px; font-weight:700; color:#475569;">TOTAL STUDENTS</span>
                    <span class="stat-icon-wrap" style="color:#0D9488; font-size:18px;"><i class="fa-solid fa-graduation-cap"></i></span>
                </div>
                <div class="stat-num-val" style="font-size:26px; font-weight:800; color:#0F172A; margin-bottom:4px;">
                    <asp:Literal ID="litTotalStudents" runat="server">0</asp:Literal>
                </div>
                <div class="stat-sub-trend-line font-green" style="font-size:12px; font-weight:600; color:#10B981;">
                    <i class="fa-solid fa-arrow-up"></i> Live registered candidates
                </div>
            </div>
        </div>

    </div>

    <!-- Live Dynamic Period Switching Script -->
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            const periodSelect = document.getElementById("analyticsTimePeriod");
            const statVal = document.querySelector(".admin-reports-top-metrics .stat-num-val");

            function updateMetricsForPeriod() {
                if (!periodSelect || !statVal) return;
                const period = periodSelect.value;
                const count = periodSelect.getAttribute("data-count-" + period) || periodSelect.getAttribute("data-count-30") || "0";
                statVal.textContent = Number(count).toLocaleString();
            }

            if (periodSelect) {
                periodSelect.addEventListener("change", updateMetricsForPeriod);
                updateMetricsForPeriod();
            }
        });
    </script>
</asp:Content>
