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

        <!-- 5 Summary Metrics Cards -->
        <div class="admin-metrics-5grid">
            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">TOTAL COMPANIES</span>
                </div>
                <div class="stat-num-val">1,845</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">VERIFIED</span>
                </div>
                <div class="stat-num-val color-green">1,620</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">PENDING VERIFICATION</span>
                </div>
                <div class="stat-num-val color-blue">42</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">ACTIVE</span>
                </div>
                <div class="stat-num-val">1,580</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">NEW THIS MONTH</span>
                </div>
                <div class="stat-num-val">28</div>
            </div>
        </div>

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
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Company 1: TechNova Solutions -->
                                <tr class="company-row"
                                    data-company-name="TechNova Solutions"
                                    data-initials="TN"
                                    data-status="Verified"
                                    data-industry="IT & Software"
                                    data-location="Bengaluru, HQ"
                                    data-website="technova.io"
                                    data-email="careers@technova.io"
                                    data-phone="+91 98450 12345"
                                    data-size="500-1000"
                                    data-founded="2015"
                                    data-jobs="12"
                                    data-applicants="850"
                                    data-hires="34">
                                    <td><input type="checkbox" /></td>
                                    <td>
                                        <div class="company-cell-flex">
                                            <div class="company-avatar-box">TN</div>
                                            <span class="company-name-bold">TechNova Solutions</span>
                                        </div>
                                    </td>
                                    <td>IT</td>
                                    <td>Bengaluru</td>
                                    <td>12</td>
                                    <td><span class="badge-status-verified">&bull; Verified</span></td>
                                </tr>

                                <!-- Company 2: RetailGenius (Selected by default) -->
                                <tr class="company-row selected"
                                    data-company-name="RetailGenius"
                                    data-initials="RG"
                                    data-status="Pending"
                                    data-industry="E-Commerce"
                                    data-location="Mumbai, HQ"
                                    data-website="retailgenius.com"
                                    data-email="hr@retailgenius.com"
                                    data-phone="+91 98765 43210"
                                    data-size="50-200"
                                    data-founded="2018"
                                    data-jobs="8"
                                    data-applicants="450"
                                    data-hires="12">
                                    <td><input type="checkbox" checked="checked" /></td>
                                    <td>
                                        <div class="company-cell-flex">
                                            <div class="company-avatar-box bg-purple-tint">RG</div>
                                            <span class="company-name-bold">RetailGenius</span>
                                        </div>
                                    </td>
                                    <td>E-Commerce</td>
                                    <td>Mumbai</td>
                                    <td>8</td>
                                    <td><span class="badge-status-pending">&bull; Pending</span></td>
                                </tr>

                                <!-- Company 3: HealthFirst -->
                                <tr class="company-row"
                                    data-company-name="HealthFirst"
                                    data-initials="HF"
                                    data-status="Verified"
                                    data-industry="Healthcare"
                                    data-location="Pune, HQ"
                                    data-website="healthfirst.org"
                                    data-email="talent@healthfirst.org"
                                    data-phone="+91 98220 99887"
                                    data-size="200-500"
                                    data-founded="2012"
                                    data-jobs="5"
                                    data-applicants="320"
                                    data-hires="9">
                                    <td><input type="checkbox" /></td>
                                    <td>
                                        <div class="company-cell-flex">
                                            <div class="company-avatar-box bg-blue-tint">HF</div>
                                            <span class="company-name-bold">HealthFirst</span>
                                        </div>
                                    </td>
                                    <td>Healthcare</td>
                                    <td>Pune</td>
                                    <td>5</td>
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
