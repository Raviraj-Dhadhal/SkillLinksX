<%@ Page Title="Manage Companies - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Companies.aspx.cs" Inherits="SkillLinksX.Admin.Companies" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Companies Head Styling -->
    <style>
        .company-row {
            cursor: pointer;
            transition: background 0.15s ease;
        }
        .company-row:hover {
            background-color: #F8FAFC;
        }
        .company-row.active-row {
            background-color: #EFF6FF !important;
        }
        .btn-filter-clear-link {
            display: inline-flex;
            align-items: center;
            padding: 7px 16px;
            background: #F1F5F9;
            color: #475569;
            font-size: 12.5px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-filter-clear-link:hover {
            background: #E2E8F0;
            color: #0F172A;
        }
        .badge-status-verified {
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Manage Companies</h1>
                <p class="admin-page-main-sub">Review and manage partner companies registered on SkillLinkX.</p>
            </div>
            <a href="<%= ResolveUrl("~/Public/CompanyRegister.aspx") %>" target="_blank" class="btn-admin-primary-add" style="text-decoration:none;">
                <i class="fa-solid fa-plus"></i> Add Company
            </a>
        </div>

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Aggregated Company counts from SQL Server Database
             ========================================================================= -->
        <div class="admin-metrics-5grid">
            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">TOTAL COMPANIES</span>
                    <span class="stat-icon-wrap bg-blue-subtle"><i class="fa-solid fa-building"></i></span>
                </div>
                <div class="stat-num-val"><%= TotalCompaniesCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">VERIFIED</span>
                    <span class="stat-icon-wrap bg-green-subtle"><i class="fa-regular fa-circle-check"></i></span>
                </div>
                <div class="stat-num-val color-green"><%= VerifiedCompaniesCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">PENDING VERIFICATION</span>
                    <span class="stat-icon-wrap bg-purple-subtle"><i class="fa-solid fa-clock"></i></span>
                </div>
                <div class="stat-num-val color-blue"><%= PendingCompaniesCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">TOTAL JOBS POSTED</span>
                    <span class="stat-icon-wrap bg-green-subtle"><i class="fa-solid fa-briefcase"></i></span>
                </div>
                <div class="stat-num-val"><%= TotalJobsPostedCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">VERIFIED RATIO</span>
                    <span class="stat-icon-wrap bg-blue-subtle"><i class="fa-solid fa-chart-pie"></i></span>
                </div>
                <div class="stat-num-val"><%= TotalCompaniesCount > 0 ? (VerifiedCompaniesCount * 100 / TotalCompaniesCount) : 0 %>%</div>
            </div>
        </div>

        <asp:Label ID="lblAdminCompanyStatus" runat="server" ForeColor="Green" style="margin: 10px 14px; display:block; font-size:13px; font-weight:600;" EnableViewState="false" />

        <!-- Filter Bar Row (100% Dynamic from Database) -->
        <div class="admin-filter-bar-card">
            <div class="admin-search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <asp:TextBox ID="txtSearchCompany" runat="server" placeholder="Search company name, industry, city..." AutoPostBack="true" OnTextChanged="txtSearchCompany_TextChanged" />
            </div>

            <div class="admin-dropdown-wrap">
                <asp:DropDownList ID="ddlIndustryFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlIndustryFilter_SelectedIndexChanged" />
            </div>

            <div class="admin-dropdown-wrap">
                <asp:DropDownList ID="ddlLocationFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlLocationFilter_SelectedIndexChanged" />
            </div>

            <div class="admin-dropdown-wrap">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                    <asp:ListItem Text="Status: All" Value="" />
                    <asp:ListItem Text="Verified" Value="Verified" />
                    <asp:ListItem Text="Pending" Value="Pending" />
                </asp:DropDownList>
            </div>

            <asp:LinkButton ID="btnClearFilters" runat="server" CssClass="btn-filter-clear-link" OnClick="btnClearFilters_Click">
                <i class="fa-solid fa-rotate-left" style="margin-right: 6px;"></i> Clear
            </asp:LinkButton>
        </div>

        <!-- Workspace Layout: Left Content (Table + Bottom 2 Cards) + Right Company Details Panel -->
        <div class="admin-workspace-split-grid">

            <!-- Left Main Column -->
            <div class="admin-companies-left-col">

                <!-- Companies Table Card -->
                <div class="admin-table-card">
                    <div class="admin-table-responsive">
                        <table class="admin-data-table" id="companiesTable">
                            <thead>
                                <tr>
                                    <th style="width: 40px;"><input type="checkbox" id="chkSelectAllCompanies" /></th>
                                    <th>COMPANY</th>
                                    <th>INDUSTRY</th>
                                    <th>LOCATION</th>
                                    <th>JOBS</th>
                                    <th>STATUS</th>
                                    <th>ACTION</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- =========================================================
                                     [DYNAMIC COMPANIES REPEATER]: Binds all partner employers
                                     Clicking any row dynamically updates the details panel!
                                     ========================================================= -->
                                <asp:Repeater ID="rptCompaniesTable" runat="server" OnItemCommand="rptCompaniesTable_ItemCommand">
                                    <ItemTemplate>
                                        <tr class='company-row <%# (bool)Eval("IsSelected") ? "active-row" : "" %>'
                                            data-id='<%# Eval("CompanyId") %>'
                                            data-name='<%# Eval("CompanyName") %>'
                                            data-initials='<%# Eval("Initials") %>'
                                            data-status='<%# Eval("VerificationStatus") %>'
                                            data-industry='<%# Eval("Industry") %>'
                                            data-location='<%# Eval("Location") %>'
                                            data-website='<%# Eval("Website") %>'
                                            data-email='<%# Eval("Email") %>'
                                            data-phone='<%# Eval("Phone") %>'
                                            data-size='<%# Eval("Size") %>'
                                            data-founded='-'
                                            data-jobs='<%# Eval("JobCount") %>'
                                            data-apps='<%# Eval("AppCount") %>'
                                            data-hires='<%# Eval("HireCount") %>'>
                                            
                                            <td><input type="checkbox" /></td>
                                            <td>
                                                <div class="company-cell-flex">
                                                    <div class="company-avatar-box" style="overflow:hidden; display:inline-flex; align-items:center; justify-content:center; background:#f1f5f9; color:#64748b; font-size:15px; border:1px solid #cbd5e1;">
                                                        <%# !string.IsNullOrEmpty(Eval("LogoUrl") as string)
                                                            ? "<img src='" + ResolveUrl(Eval("LogoUrl").ToString()) + "' alt='Logo' style='width:100%; height:100%; object-fit:cover;' />"
                                                            : "<span style='font-weight:700; font-size:13px; color:#0040A2;'>" + Eval("Initials") + "</span>" %>
                                                    </div>
                                                    <span class="company-name-bold"><%# Eval("CompanyName") %></span>
                                                </div>
                                            </td>
                                            <td><%# Eval("Industry") %></td>
                                            <td><%# Eval("Location") %></td>
                                            <td>
                                                <span style="font-weight:600; color:#2563eb;"><%# Eval("JobCount") %></span>
                                            </td>
                                            <td>
                                                <span class='badge-status-<%# Eval("VerificationStatus").ToString().ToLower() %>'>
                                                    &bull; <%# Eval("VerificationStatus") %>
                                                </span>
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="btnToggleVerify" runat="server" CommandName="ToggleVerify" CommandArgument='<%# Eval("CompanyId") + "|" + Eval("VerificationStatus") %>' 
                                                    CssClass='<%# "btn btn-sm " + (Eval("VerificationStatus").ToString() == "Verified" ? "btn-outline-danger" : "btn-outline-primary") %>' 
                                                    style="font-size:11.5px; text-decoration:none; padding:3px 8px; border-radius:4px;" 
                                                    OnClientClick="event.stopPropagation();">
                                                    <%# Eval("VerificationStatus").ToString() == "Verified" ? "Unverify" : "Verify" %>
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>

                    <!-- Dynamic Real-Time Count Footer -->
                    <div class="admin-table-pagination flex-between">
                        <span class="pagination-entry-count">Showing <%= FilteredCompaniesCount %> of <%= TotalCompaniesCount %> partner companies</span>
                    </div>
                </div>

                <!-- Bottom 2-Cards Grid: Dynamic Popular Industries & Top Locations from DB -->
                <div class="admin-2cards-grid">
                    <!-- Card 1: Popular Industries (Real Database Aggregates) -->
                    <div class="admin-summary-card">
                        <div class="summary-card-header flex-between">
                            <span class="summary-card-title">POPULAR INDUSTRIES</span>
                            <i class="fa-solid fa-chart-pie summary-card-icon"></i>
                        </div>
                        <div class="industry-progress-stack">
                            <asp:Repeater ID="rptPopularIndustries" runat="server">
                                <ItemTemplate>
                                    <div class="industry-progress-item">
                                        <div class="prog-label-flex">
                                            <span><%# Eval("IndustryName") %></span>
                                            <span class="font-bold"><%# Eval("Percentage") %>%</span>
                                        </div>
                                        <div class="progress-track"><div class="progress-fill fill-blue" style='width: <%# Eval("Percentage") %>%;'></div></div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <!-- Card 2: Top Locations (Real Database Cities) -->
                    <div class="admin-summary-card">
                        <div class="summary-card-header flex-between">
                            <span class="summary-card-title">TOP LOCATIONS</span>
                            <i class="fa-regular fa-map summary-card-icon"></i>
                        </div>
                        <div class="locations-chips-wrap">
                            <asp:Repeater ID="rptTopLocations" runat="server">
                                <ItemTemplate>
                                    <span class="loc-chip"><%# Eval("CityName") %></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar: 100% Dynamic Company Details Panel -->
            <div class="admin-details-sidebar-card" id="companyDetailsCard">
                <div class="company-header-top-row flex-between">
                    <div class="cd-avatar-name-flex">
                        <div class="cd-avatar-initials" id="cdInitials" style="display:inline-flex; align-items:center; justify-content:center; background:#f1f5f9; color:#64748b; font-size:20px; font-weight:700; border:1px solid #cbd5e1; width:44px; height:44px; border-radius:8px;">CO</div>
                        <div>
                            <h3 class="cd-company-title" id="cdName">Select a company</h3>
                            <span class="badge-status-pending" id="cdStatus">&bull; Status</span>
                        </div>
                    </div>
                    <button type="button" class="btn-close-details" id="btnCloseCompanyDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <div class="details-section-divider"></div>

                <!-- Company Details Block -->
                <div class="cd-meta-block">
                    <div class="cd-section-heading">COMPANY DETAILS</div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-store"></i> <span id="cdIndustry">-</span>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-location-dot"></i> <span id="cdLocation">-</span>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-globe"></i> <a href="#" id="cdWebsite" target="_blank" class="cd-link">-</a>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-regular fa-envelope"></i> <a href="#" id="cdEmail" class="cd-link">-</a>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-phone"></i> <span id="cdPhone">-</span>
                    </div>
                    <div class="cd-meta-2col-row">
                        <div>
                            <span class="cd-sub-lbl">Size</span>
                            <div class="cd-sub-val" id="cdSize">-</div>
                        </div>
                        <div>
                            <span class="cd-sub-lbl">Founded</span>
                            <div class="cd-sub-val" id="cdFounded">-</div>
                        </div>
                    </div>
                </div>

                <div class="details-section-divider"></div>

                <!-- Recruitment Activity 3-Tiles (Real Dynamic Volume) -->
                <div class="cd-meta-block">
                    <div class="cd-section-heading">RECRUITMENT ACTIVITY</div>
                    <div class="cd-recruit-3grid">
                        <div class="recruit-stat-box">
                            <span class="r-stat-num" id="cdJobsCount">0</span>
                            <span class="r-stat-lbl">Jobs</span>
                        </div>
                        <div class="recruit-stat-box">
                            <span class="r-stat-num" id="cdAppCount">0</span>
                            <span class="r-stat-lbl">Applicants</span>
                        </div>
                        <div class="recruit-stat-box">
                            <span class="r-stat-num" id="cdHiresCount">0</span>
                            <span class="r-stat-lbl">Hires</span>
                        </div>
                    </div>
                </div>

                <div class="details-section-divider"></div>

                <!-- Verification Action Block -->
                <asp:HiddenField ID="hdnSelectedCompanyId" runat="server" />
                <div class="cd-actions-stack">
                    <asp:Button ID="btnSidebarApprove" runat="server" Text="Approve & Verify Company" CssClass="btn-cd-approve" OnClick="btnSidebarApprove_Click" />
                    <asp:Button ID="btnSidebarReject" runat="server" Text="Revoke Verification (Pending)" CssClass="btn-cd-reject" OnClick="btnSidebarReject_Click" />
                </div>
            </div>

        </div>

    </div>

    <!-- Script to Synchronize HiddenField with Active Selected Company -->
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            // Auto click first company on load to populate sidebar
            var firstRow = document.querySelector(".company-row.active-row") || document.querySelector(".company-row");
            if (firstRow) {
                firstRow.click();
            }

            // Sync hidden field on row click
            document.querySelectorAll(".company-row").forEach(function (row) {
                row.addEventListener("click", function () {
                    var cid = this.getAttribute("data-id");
                    var hdn = document.getElementById("<%= hdnSelectedCompanyId.ClientID %>");
                    if (hdn && cid) {
                        hdn.value = cid;
                    }
                });
            });
        });
    </script>
</asp:Content>