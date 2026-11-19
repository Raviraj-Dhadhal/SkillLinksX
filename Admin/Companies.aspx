<%@ Page Title="Manage Companies - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Companies.aspx.cs" Inherits="SkillLinksX.Admin.Companies" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Companies Page Head -->
    <style>
        .btn-filter-clear-link {
            display: inline-flex;
            align-items: center;
            padding: 8px 14px;
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
        .badge-status-revoked, .badge-status-suspended {
            background-color: #FEE2E2;
            color: #991B1B;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
        }

        /* Modal Box Styles */
        .modal-backdrop-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal-dialog-box {
            background: #FFFFFF;
            border-radius: 14px;
            width: 100%;
            max-width: 650px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            padding: 24px;
        }
        .modal-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 16px;
            border-bottom: 1px solid #E2E8F0;
            margin-bottom: 18px;
        }
        .modal-title {
            font-size: 18px;
            font-weight: 700;
            color: #0F172A;
            margin: 0;
        }
        .btn-modal-close {
            background: none;
            border: none;
            font-size: 18px;
            color: #64748B;
            cursor: pointer;
            padding: 4px;
        }
        .btn-modal-close:hover {
            color: #0F172A;
        }
        .admin-form-group {
            margin-bottom: 14px;
        }
        .admin-input-label {
            display: block;
            font-size: 12.5px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 5px;
        }
        .admin-profile-input, .admin-filter-select {
            width: 100%;
            height: 40px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            padding: 0 12px;
            font-size: 13.5px;
            color: #0F172A;
            box-sizing: border-box;
            background-color: #FFFFFF;
        }
        .admin-profile-input:focus, .admin-filter-select:focus {
            outline: none;
            border-color: #0040A2;
            box-shadow: 0 0 0 3px rgba(0, 64, 162, 0.1);
        }
        .form-2col-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        .btn-cancel-modal {
            background: #F1F5F9;
            border: none;
            color: #475569;
            font-weight: 600;
            font-size: 13px;
            padding: 9px 18px;
            border-radius: 8px;
            cursor: pointer;
        }
        .btn-cancel-modal:hover {
            background: #E2E8F0;
            color: #0F172A;
        }
        .btn-submit-modal {
            background: #0040A2;
            border: none;
            color: #FFFFFF;
            font-weight: 600;
            font-size: 13px;
            padding: 9px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.2s ease;
        }
        .btn-submit-modal:hover {
            background: #003080;
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
            <button type="button" class="btn-admin-primary-add" onclick="document.getElementById('addCompanyModal').style.display='flex';" style="cursor:pointer; border:none;">
                <i class="fa-solid fa-plus"></i> Add Company
            </button>
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
                    <span class="stat-icon-wrap bg-orange-subtle"><i class="fa-solid fa-briefcase"></i></span>
                </div>
                <div class="stat-num-val"><%= TotalJobsPostedCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">VERIFIED RATIO</span>
                    <span class="stat-icon-wrap bg-teal-subtle"><i class="fa-solid fa-percent"></i></span>
                </div>
                <div class="stat-num-val color-teal">
                    <%= (TotalCompaniesCount > 0 ? ((VerifiedCompaniesCount * 100) / TotalCompaniesCount) : 0) %>%
                </div>
            </div>
        </div>

        <asp:Label ID="lblAdminCompanyStatus" runat="server" ForeColor="Green" style="margin: 8px 12px; display:block; font-size:13px; font-weight:600;" EnableViewState="false" />

        <!-- Filter Bar Row -->
        <div class="admin-filter-bar-card">
            <div class="admin-search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <asp:TextBox ID="txtSearchCompany" runat="server" placeholder="Search company name, location, or industry..." AutoPostBack="true" OnTextChanged="txtSearchCompany_TextChanged" />
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
                    <asp:ListItem Text="Revoked" Value="Revoked" />
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
                                    <th style="width: 40px;"><input type="checkbox" /></th>
                                    <th>COMPANY</th>
                                    <th>INDUSTRY</th>
                                    <th>LOCATION</th>
                                    <th>JOBS</th>
                                    <th>STATUS</th>
                                    <th style="min-width: 130px;">ACTION</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptCompaniesTable" runat="server" OnItemCommand="rptCompaniesTable_ItemCommand">
                                    <ItemTemplate>
                                        <tr class='company-row <%# (bool)Eval("IsSelected") ? "active-row" : "" %>'
                                            data-id='<%# Eval("CompanyId") %>'
                                            data-name='<%# Eval("CompanyName") %>'
                                            data-avatar='<%# Eval("LogoUrl") %>'
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
                                                    <div class="company-avatar-box" style="overflow:hidden; display:inline-flex; align-items:center; justify-content:center; background:#EFF6FF; border:1px solid #CBD5E1; width:36px; height:36px; border-radius:8px;">
                                                        <%# !string.IsNullOrEmpty(Eval("LogoUrl") as string)
                                                            ? "<img src='" + ResolveUrl(Eval("LogoUrl").ToString()) + "' alt='Logo' style='width:100%; height:100%; object-fit:cover;' />"
                                                            : "<i class='fa-solid fa-building' style='color:#0040A2; font-size:15px;'></i>" %>
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
                                                <div style="display:flex; gap:4px; align-items:center; flex-wrap:wrap;">
                                                    <%# Eval("VerificationStatus").ToString() != "Verified" 
                                                        ? "<a href='" + ResolveUrl("~/Admin/Companies.aspx?action=approve&cid=" + Eval("CompanyId")) + "' onclick='event.stopPropagation();' style='font-size:11px; padding:2px 7px; border-radius:4px; text-decoration:none; color:#15803d; border:1px solid #86efac; background:#f0fdf4;'>Approve</a>" 
                                                        : "" %>
                                                    
                                                    <%# Eval("VerificationStatus").ToString() != "Pending" 
                                                        ? "<a href='" + ResolveUrl("~/Admin/Companies.aspx?action=pending&cid=" + Eval("CompanyId")) + "' onclick='event.stopPropagation();' style='font-size:11px; padding:2px 7px; border-radius:4px; text-decoration:none; color:#b45309; border:1px solid #fde68a; background:#fffbeb;'>Pending</a>" 
                                                        : "" %>

                                                    <%# Eval("VerificationStatus").ToString() != "Revoked" 
                                                        ? "<a href='" + ResolveUrl("~/Admin/Companies.aspx?action=revoke&cid=" + Eval("CompanyId")) + "' onclick=\"event.stopPropagation(); return confirm('Revoke company verification and disable login?');\" style='font-size:11px; padding:2px 7px; border-radius:4px; text-decoration:none; color:#b91c1c; border:1px solid #fecaca; background:#fef2f2;'>Revoke</a>" 
                                                        : "" %>
                                                </div>
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

            </div>

            <!-- Right Sidebar Column: Interactive Dynamic Company Profile Card -->
            <div class="admin-details-sidebar-card" id="companyDetailsCard">
                <div class="details-card-header flex-between">
                    <div></div>
                    <button type="button" class="btn-close-details" id="btnCloseCompanyDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <!-- Avatar & Identity Block -->
                <div class="cd-profile-center-block">
                    <div class="cd-avatar-large-box" id="cdAvatarWrap" style="overflow:hidden; display:inline-flex; align-items:center; justify-content:center; background:#EFF6FF; border:1px solid #CBD5E1; width:64px; height:64px; border-radius:50%; margin:0 auto 10px auto;">
                        <img id="cdAvatar" src="<%= SelectedCompanyLogo %>" alt="Company" style='width:100%; height:100%; object-fit:cover; border-radius:50%; <%= string.IsNullOrEmpty(SelectedCompanyLogo) ? "display:none;" : "" %>' />
                        <div id="cdAvatarFallback" style='display:<%= !string.IsNullOrEmpty(SelectedCompanyLogo) ? "none" : "flex" %>; align-items:center; justify-content:center; width:100%; height:100%; color:#0040A2; font-size:26px;'>
                            <i class="fa-solid fa-building"></i>
                        </div>
                    </div>
                    <h4 class="cd-comp-name" id="cdName">Select a Company</h4>
                    <span class="badge-status-verified" id="cdBadge">&bull; Verified</span>
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
                <div class="cd-actions-stack" style="display:flex; flex-direction:column; gap:8px;">
                    <asp:Button ID="btnSidebarApprove" runat="server" Text="Approve & Verify Company" CssClass="btn-cd-approve" OnClick="btnSidebarApprove_Click" />
                    <asp:Button ID="btnSidebarPending" runat="server" Text="Mark as Pending" OnClick="btnSidebarPending_Click" style="background:#F59E0B; color:#fff; border:none; padding:10px 16px; border-radius:8px; font-weight:600; cursor:pointer;" />
                    <asp:Button ID="btnSidebarRevoke" runat="server" Text="Revoke Account (Block Login)" OnClick="btnSidebarRevoke_Click" style="background:#EF4444; color:#fff; border:none; padding:10px 16px; border-radius:8px; font-weight:600; cursor:pointer;" OnClientClick="return confirm('Revoke this company account and block login?');" />
                </div>
            </div>

        </div>

    </div>

    <!-- Add Company Modal (Dynamic Registration) -->
    <div class="modal-backdrop-overlay" id="addCompanyModal" style="display:none;">
        <div class="modal-dialog-box">
            <div class="modal-header-row">
                <h3 class="modal-title"><i class="fa-solid fa-building-circle-check" style="color:#0040A2; margin-right:8px;"></i> Register New Company</h3>
                <button type="button" class="btn-modal-close" onclick="document.getElementById('addCompanyModal').style.display='none';">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <asp:Label ID="lblNewCompError" runat="server" ForeColor="Red" style="display:block; margin-bottom:12px; font-size:13px; font-weight:600;" EnableViewState="false" />

            <div class="modal-body-content">
                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Company Name *</label>
                        <asp:TextBox ID="txtNewCompName" runat="server" CssClass="admin-profile-input" placeholder="e.g. Apex Innovations Ltd." />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Recruiter / Contact Name</label>
                        <asp:TextBox ID="txtNewRecruiterName" runat="server" CssClass="admin-profile-input" placeholder="e.g. Anita Roy (HR Lead)" />
                    </div>
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Official Email (Login ID) *</label>
                        <asp:TextBox ID="txtNewCompEmail" runat="server" CssClass="admin-profile-input" TextMode="Email" placeholder="e.g. hr@apex.com" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Password (for login) *</label>
                        <asp:TextBox ID="txtNewCompPassword" runat="server" CssClass="admin-profile-input" TextMode="Password" placeholder="Minimum 6 characters" />
                    </div>
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Phone Number *</label>
                        <asp:TextBox ID="txtNewCompPhone" runat="server" CssClass="admin-profile-input" placeholder="e.g. +91 9876543210" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Industry Domain *</label>
                        <asp:DropDownList ID="ddlNewCompIndustry" runat="server" CssClass="admin-filter-select">
                            <asp:ListItem Text="IT & Software" Value="IT & Software" />
                            <asp:ListItem Text="Technology" Value="Technology" />
                            <asp:ListItem Text="FinTech" Value="FinTech" />
                            <asp:ListItem Text="E-Commerce" Value="E-Commerce" />
                            <asp:ListItem Text="Healthcare" Value="Healthcare" />
                            <asp:ListItem Text="EdTech" Value="EdTech" />
                            <asp:ListItem Text="Consulting" Value="Consulting" />
                            <asp:ListItem Text="Other" Value="Other" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">City *</label>
                        <asp:TextBox ID="txtNewCompCity" runat="server" CssClass="admin-profile-input" placeholder="e.g. Bengaluru" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">State *</label>
                        <asp:DropDownList ID="ddlNewCompState" runat="server" CssClass="admin-filter-select">
                            <asp:ListItem Text="Karnataka" Value="Karnataka" />
                            <asp:ListItem Text="Maharashtra" Value="Maharashtra" />
                            <asp:ListItem Text="Delhi" Value="Delhi" />
                            <asp:ListItem Text="Telangana" Value="Telangana" />
                            <asp:ListItem Text="Tamil Nadu" Value="Tamil Nadu" />
                            <asp:ListItem Text="Gujarat" Value="Gujarat" />
                            <asp:ListItem Text="Uttar Pradesh" Value="Uttar Pradesh" />
                            <asp:ListItem Text="West Bengal" Value="West Bengal" />
                            <asp:ListItem Text="Madhya Pradesh" Value="Madhya Pradesh" />
                            <asp:ListItem Text="Rajasthan" Value="Rajasthan" />
                            <asp:ListItem Text="Other" Value="Other" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="admin-form-group">
                    <label class="admin-input-label">Headquarter Address *</label>
                    <asp:TextBox ID="txtNewCompAddress" runat="server" CssClass="admin-profile-input" placeholder="e.g. Tech Park, Outer Ring Road" />
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Website URL</label>
                        <asp:TextBox ID="txtNewCompWebsite" runat="server" CssClass="admin-profile-input" placeholder="e.g. https://www.apex.com" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Company Size</label>
                        <asp:DropDownList ID="ddlNewCompEmpCount" runat="server" CssClass="admin-filter-select">
                            <asp:ListItem Text="1-10 employees" Value="1-10" />
                            <asp:ListItem Text="11-50 employees" Value="11-50" />
                            <asp:ListItem Text="51-200 employees" Value="51-200" />
                            <asp:ListItem Text="201-500 employees" Value="201-500" />
                            <asp:ListItem Text="500+ employees" Value="500+" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="admin-form-group">
                    <label class="admin-input-label">Initial Verification Status</label>
                    <asp:DropDownList ID="ddlNewCompStatus" runat="server" CssClass="admin-filter-select">
                        <asp:ListItem Text="Verified & Active (Can login immediately)" Value="Active" />
                        <asp:ListItem Text="Pending Verification (Requires approval)" Value="Pending" />
                    </asp:DropDownList>
                </div>
            </div>

            <div class="modal-footer-row" style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px; border-top:1px solid #E2E8F0; padding-top:16px;">
                <button type="button" class="btn-cancel-modal" onclick="document.getElementById('addCompanyModal').style.display='none';">Cancel</button>
                <asp:Button ID="btnSaveNewCompany" runat="server" Text="Register Company" CssClass="btn-submit-modal" OnClick="btnSaveNewCompany_Click" />
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
