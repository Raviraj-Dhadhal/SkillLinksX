<%@ Page Title="Manage Companies - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Companies.aspx.cs" Inherits="SkillLinksX.Admin.Companies" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Companies Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Manage Companies</h1>
                <p class="admin-page-main-sub">Review and manage companies registered on SkillLinkX.</p>
            </div>
            <button type="button" class="btn-admin-primary-add" id="btnOpenAddCompanyModal">
                <i class="fa-solid fa-plus"></i> Add Company
            </button>
        </div>

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Aggregated Company counts from SQL Server
             ========================================================================= -->
        <div class="admin-metrics-5grid">
            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">TOTAL COMPANIES</span>
                </div>
                <div class="stat-num-val"><%= TotalCompaniesCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">VERIFIED</span>
                </div>
                <div class="stat-num-val color-green"><%= VerifiedCompaniesCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">PENDING VERIFICATION</span>
                </div>
                <div class="stat-num-val color-blue"><%= PendingCompaniesCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">TOTAL JOBS POSTED</span>
                </div>
                <div class="stat-num-val"><%= TotalJobsPostedCount %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">VERIFIED RATIO</span>
                </div>
                <div class="stat-num-val"><%= TotalCompaniesCount > 0 ? (VerifiedCompaniesCount * 100 / TotalCompaniesCount) : 100 %>%</div>
            </div>
        </div>

        <asp:Label ID="lblAdminCompanyStatus" runat="server" ForeColor="Green" style="margin: 10px 14px; display:block; font-size:13px; font-weight:600;" EnableViewState="false" />

        <!-- Filter Bar Row -->
        <div class="admin-filter-bar-card">
            <div class="admin-search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="searchCompanyInput" placeholder="Search company..." />
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterIndustry">
                    <option value="">All Industries</option>
                    <option value="IT">IT &amp; Software</option>
                    <option value="E-Commerce">E-Commerce</option>
                    <option value="Healthcare">Healthcare</option>
                    <option value="Education">Education</option>
                    <option value="FinTech">FinTech</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterCompanyLocation">
                    <option value="">All Locations</option>
                    <option value="Bengaluru">Bengaluru</option>
                    <option value="Mumbai">Mumbai</option>
                    <option value="Pune">Pune</option>
                    <option value="Hyderabad">Hyderabad</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterCompanyStatus">
                    <option value="">Status: All</option>
                    <option value="Verified">Verified</option>
                    <option value="Pending">Pending</option>
                    <option value="Suspended">Suspended</option>
                </select>
            </div>

            <button type="button" class="btn-filter-icon" title="More Filters"><i class="fa-solid fa-sliders"></i></button>
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
                                     ========================================================= -->
                                <asp:Repeater ID="rptCompaniesTable" runat="server" OnItemCommand="rptCompaniesTable_ItemCommand">
                                    <ItemTemplate>
                                        <tr class="company-row">
                                            <td><%# Container.ItemIndex + 1 %></td>
                                            <td>
                                                <div class="company-cell-flex">
                                                    <div class="company-avatar-box"><%# Eval("Initials") %></div>
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
                                                <asp:LinkButton ID="btnToggleVerify" runat="server" CommandName="ToggleVerify" CommandArgument='<%# Eval("CompanyId") + "|" + Eval("VerificationStatus") %>' CssClass="btn btn-sm btn-outline-primary" style="font-size:11.5px; text-decoration:none; padding:3px 8px; border:1px solid #2563eb; color:#2563eb; border-radius:4px;">
                                                    <%# Eval("VerificationStatus").ToString() == "Verified" ? "Unverify" : "Verify" %>
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                                    <td><span class="badge-status-verified">&bull; Verified</span></td>
                                </tr>

                                <!-- Company 4: EduStream -->
                                <tr class="company-row"
                                    data-company-name="EduStream"
                                    data-initials="ES"
                                    data-status="Suspended"
                                    data-industry="Education"
                                    data-location="Hyderabad, HQ"
                                    data-website="edustream.in"
                                    data-email="contact@edustream.in"
                                    data-phone="+91 98480 55443"
                                    data-size="20-50"
                                    data-founded="2020"
                                    data-jobs="3"
                                    data-applicants="110"
                                    data-hires="2">
                                    <td><input type="checkbox" /></td>
                                    <td>
                                        <div class="company-cell-flex">
                                            <div class="company-avatar-box bg-gray-tint">ES</div>
                                            <span class="company-name-bold">EduStream</span>
                                        </div>
                                    </td>
                                    <td>Education</td>
                                    <td>Hyderabad</td>
                                    <td>3</td>
                                    <td><span class="badge-status-suspended">&bull; Suspended</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Bottom 2-Cards Grid: Popular Industries & Top Locations -->
                <div class="admin-2cards-grid">
                    <!-- Card 1: Popular Industries -->
                    <div class="admin-summary-card">
                        <div class="summary-card-header flex-between">
                            <span class="summary-card-title">POPULAR INDUSTRIES</span>
                            <i class="fa-solid fa-chart-pie summary-card-icon"></i>
                        </div>
                        <div class="industry-progress-stack">
                            <div class="industry-progress-item">
                                <div class="prog-label-flex">
                                    <span>IT &amp; Software</span>
                                    <span class="font-bold">45%</span>
                                </div>
                                <div class="progress-track"><div class="progress-fill fill-blue" style="width: 45%;"></div></div>
                            </div>
                            <div class="industry-progress-item">
                                <div class="prog-label-flex">
                                    <span>FinTech</span>
                                    <span class="font-bold">25%</span>
                                </div>
                                <div class="progress-track"><div class="progress-fill fill-blue" style="width: 25%;"></div></div>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2: Top Locations -->
                    <div class="admin-summary-card">
                        <div class="summary-card-header flex-between">
                            <span class="summary-card-title">TOP LOCATIONS</span>
                            <i class="fa-regular fa-map summary-card-icon"></i>
                        </div>
                        <div class="locations-chips-wrap">
                            <span class="loc-chip">Bengaluru</span>
                            <span class="loc-chip">Mumbai</span>
                            <span class="loc-chip">Ahmedabad</span>
                            <span class="loc-chip">Pune</span>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar: Company Details Panel -->
            <div class="admin-details-sidebar-card" id="companyDetailsCard">
                <div class="company-header-top-row flex-between">
                    <div class="cd-avatar-name-flex">
                        <div class="cd-avatar-initials" id="cdInitials">RG</div>
                        <div>
                            <h3 class="cd-company-title" id="cdName">RetailGenius</h3>
                            <span class="badge-status-pending" id="cdStatus">&bull; Pending</span>
                        </div>
                    </div>
                    <button type="button" class="btn-close-details" id="btnCloseCompanyDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <div class="details-section-divider"></div>

                <!-- Company Details Block -->
                <div class="cd-meta-block">
                    <div class="cd-section-heading">COMPANY DETAILS</div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-store"></i> <span id="cdIndustry">E-Commerce</span>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-location-dot"></i> <span id="cdLocation">Mumbai, HQ</span>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-globe"></i> <a href="#" id="cdWebsite" class="cd-link">retailgenius.com</a>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-regular fa-envelope"></i> <a href="#" id="cdEmail" class="cd-link">hr@retailgenius.com</a>
                    </div>
                    <div class="cd-meta-item">
                        <i class="fa-solid fa-phone"></i> <span id="cdPhone">+91 98765 43210</span>
                    </div>
                    <div class="cd-meta-2col-row">
                        <div>
                            <span class="cd-sub-lbl">Size</span>
                            <div class="cd-sub-val" id="cdSize">50-200</div>
                        </div>
                        <div>
                            <span class="cd-sub-lbl">Founded</span>
                            <div class="cd-sub-val" id="cdFounded">2018</div>
                        </div>
                    </div>
                </div>

                <div class="details-section-divider"></div>

                <!-- Recruitment Activity 3-Tiles -->
                <div class="cd-meta-block">
                    <div class="cd-section-heading">RECRUITMENT ACTIVITY</div>
                    <div class="cd-recruit-3grid">
                        <div class="recruit-stat-box">
                            <span class="r-stat-num" id="cdJobsCount">8</span>
                            <span class="r-stat-lbl">Jobs</span>
                        </div>
                        <div class="recruit-stat-box">
                            <span class="r-stat-num" id="cdAppCount">450</span>
                            <span class="r-stat-lbl">Applicants</span>
                        </div>
                        <div class="recruit-stat-box">
                            <span class="r-stat-num" id="cdHiresCount">12</span>
                            <span class="r-stat-lbl">Hires</span>
                        </div>
                    </div>
                </div>

                <div class="details-section-divider"></div>

                <!-- Verification Documents -->
                <div class="cd-meta-block">
                    <div class="cd-section-heading">VERIFICATION DOCUMENTS</div>
                    <div class="cd-docs-stack">
                        <div class="cd-doc-card">
                            <i class="fa-regular fa-file-lines"></i> Registration Cert
                        </div>
                        <div class="cd-doc-card">
                            <i class="fa-regular fa-file-lines"></i> GST Certificate
                        </div>
                    </div>
                </div>

                <!-- Actions Button Stack -->
                <div class="cd-actions-stack">
                    <button type="button" class="btn-cd-approve" onclick="alert('Company verified & approved successfully');">
                        Approve Company
                    </button>
                    <div class="cd-action-2btn-row">
                        <button type="button" class="btn-cd-request" onclick="alert('Information request sent to company.');">
                            Request Info
                        </button>
                        <button type="button" class="btn-cd-reject" onclick="if(confirm('Are you sure you want to reject this company?')) alert('Company rejected.');">
                            Reject
                        </button>
                    </div>
                </div>
            </div>

        </div>

    </div>

    <!-- Add Company Modal -->
    <div class="modal-backdrop-overlay" id="addCompanyModal" style="display:none;">
        <div class="modal-dialog-box">
            <div class="modal-header-row">
                <h3 class="modal-title">Add New Company</h3>
                <button type="button" class="btn-modal-close" onclick="document.getElementById('addCompanyModal').style.display='none';">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            <div class="modal-body-content">
                <div class="admin-form-group">
                    <label class="admin-input-label">Company Name *</label>
                    <input type="text" class="admin-profile-input" id="newCompanyName" placeholder="e.g. NextGen AI Labs" />
                </div>
                <div class="form-2col-row" style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Industry *</label>
                        <select class="admin-filter-select" id="newCompanyIndustry">
                            <option value="IT & Software">IT &amp; Software</option>
                            <option value="FinTech">FinTech</option>
                            <option value="Healthcare">Healthcare</option>
                            <option value="E-Commerce">E-Commerce</option>
                            <option value="Education">Education</option>
                        </select>
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Location (City) *</label>
                        <input type="text" class="admin-profile-input" id="newCompanyLocation" placeholder="e.g. Bengaluru" />
                    </div>
                </div>
                <div class="admin-form-group">
                    <label class="admin-input-label">Work Email Address *</label>
                    <input type="email" class="admin-profile-input" id="newCompanyEmail" placeholder="e.g. hr@company.com" />
                </div>
                <div class="admin-form-group">
                    <label class="admin-input-label">Website URL</label>
                    <input type="url" class="admin-profile-input" id="newCompanyWebsite" placeholder="e.g. company.com" />
                </div>
            </div>
            <div class="modal-footer-row" style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <button type="button" class="btn-cancel-modal" onclick="document.getElementById('addCompanyModal').style.display='none';">Cancel</button>
                <button type="button" class="btn-submit-modal" id="btnSubmitAddCompany">Add Company</button>
            </div>
        </div>
    </div>
</asp:Content>
