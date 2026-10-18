<%@ Page Title="Saved Opportunities - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="SavedOpportunities.aspx.cs" Inherits="SkillLinksX.User.SavedOpportunities" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Saved Opportunities Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-saved-page-container">

        <!-- Page Header -->
        <div class="saved-page-header">
            <h1 class="saved-page-title">Saved Opportunities</h1>
            <p class="saved-page-sub">Keep track of jobs and internships you want to apply for.</p>
        </div>

        <!-- 4 Metric Tiles Row -->
        <div class="saved-metrics-grid">
            <div class="saved-metric-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label">Total Saved</span>
                    <i class="fa-regular fa-bookmark saved-metric-icon"></i>
                </div>
                <span class="saved-metric-val">12</span>
            </div>

            <div class="saved-metric-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label">Saved Jobs</span>
                    <i class="fa-solid fa-briefcase saved-metric-icon"></i>
                </div>
                <span class="saved-metric-val">5</span>
            </div>

            <div class="saved-metric-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label">Saved Internships</span>
                    <i class="fa-solid fa-graduation-cap saved-metric-icon"></i>
                </div>
                <span class="saved-metric-val">7</span>
            </div>

            <div class="saved-metric-tile danger-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label color-red" style="color: #DC2626 !important;">Closing Soon</span>
                    <i class="fa-solid fa-triangle-exclamation saved-metric-icon color-red" style="color: #DC2626 !important;"></i>
                </div>
                <span class="saved-metric-val color-red" style="color: #DC2626 !important;">2</span>
            </div>
        </div>

        <!-- Main Workspace: Left Listings + Right Closing Soon -->
        <div class="saved-layout-grid">

            <!-- Left Main Column -->
            <div class="saved-main-column">

                <!-- Filter Tabs: All, Jobs, Internships -->
                <div class="saved-filter-tabs">
                    <button type="button" class="saved-tab-btn active">All</button>
                    <button type="button" class="saved-tab-btn">Jobs</button>
                    <button type="button" class="saved-tab-btn">Internships</button>
                </div>

                <!-- Saved Cards List -->
                <div class="saved-cards-stack">

                    <!-- Saved Item 1: Backend Developer (Java/Spring) at Swiggy -->
                    <div class="saved-opp-card" data-category="job">
                        <div class="saved-card-top flex-between">
                            <div class="saved-brand-info-flex">
                                <div class="saved-company-avatar">
                                    <img src="<%= ResolveUrl("~/assets/images/swiggy-logo.svg") %>" alt="Swiggy" class="saved-logo-img" />
                                </div>
                                <div class="saved-role-meta">
                                    <h3 class="saved-role-title">Backend Developer (Java/Spring)</h3>
                                    <div class="saved-company-name">Swiggy</div>
                                </div>
                            </div>
                            <button type="button" class="btn-saved-bookmark active" title="Remove from Saved">
                                <i class="fa-solid fa-bookmark"></i>
                            </button>
                        </div>

                        <div class="saved-meta-specs-row">
                            <span><i class="fa-solid fa-location-dot"></i> Bengaluru</span>
                            <span><i class="fa-solid fa-laptop-code"></i> Hybrid</span>
                            <span><i class="fa-solid fa-indian-rupee-sign"></i> &#8377;15L - &#8377;25L</span>
                        </div>

                        <div class="saved-tags-row">
                            <span class="saved-tag-pill">Java</span>
                            <span class="saved-tag-pill">Spring Boot</span>
                            <span class="saved-tag-pill">Microservices</span>
                        </div>

                        <div class="saved-card-footer flex-between">
                            <div class="saved-footer-left">
                                <div class="ai-match-chip-pill">
                                    <i class="fa-regular fa-circle-check"></i>
                                    <span>AI MATCH <strong>88% Strong</strong></span>
                                </div>
                                <div class="saved-date-note">SAVED Oct 12, 2026</div>
                            </div>
                            <div class="saved-footer-right">
                                <a href="<%= ResolveUrl("~/User/JobDetails.aspx") %>" class="btn-saved-outline">View Details</a>
                                <a href="<%= ResolveUrl("~/User/JobDetails.aspx") %>" class="btn-saved-primary">Apply Now</a>
                            </div>
                        </div>
                    </div>

                    <!-- Saved Item 2: Data Science Intern at Infosys -->
                    <div class="saved-opp-card" data-category="internship">
                        <div class="saved-card-top flex-between">
                            <div class="saved-brand-info-flex">
                                <div class="saved-company-avatar">
                                    <img src="<%= ResolveUrl("~/assets/images/infosys-logo.svg") %>" alt="Infosys" class="saved-logo-img" />
                                </div>
                                <div class="saved-role-meta">
                                    <div class="saved-title-badge-flex">
                                        <h3 class="saved-role-title">Data Science Intern</h3>
                                        <span class="badge-type-blue">INTERNSHIP</span>
                                    </div>
                                    <div class="saved-company-name">Infosys</div>
                                </div>
                            </div>
                            <button type="button" class="btn-saved-bookmark active" title="Remove from Saved">
                                <i class="fa-solid fa-bookmark"></i>
                            </button>
                        </div>

                        <div class="saved-meta-specs-row">
                            <span><i class="fa-solid fa-location-dot"></i> Pune</span>
                            <span><i class="fa-solid fa-briefcase"></i> On-site</span>
                            <span><i class="fa-solid fa-wallet"></i> &#8377;25k/month</span>
                        </div>

                        <div class="saved-tags-row">
                            <span class="saved-tag-pill">Python</span>
                            <span class="saved-tag-pill">Machine Learning</span>
                            <span class="saved-tag-pill">SQL</span>
                        </div>

                        <div class="saved-card-footer flex-between">
                            <div class="saved-footer-left">
                                <div class="ai-match-chip-pill blue-tone">
                                    <i class="fa-solid fa-chart-simple"></i>
                                    <span>AI MATCH <strong>72% Good</strong></span>
                                </div>
                                <div class="saved-date-note">SAVED Oct 10, 2026</div>
                            </div>
                            <div class="saved-footer-right">
                                <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>" class="btn-saved-outline">View Details</a>
                                <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>" class="btn-saved-primary">Apply Now</a>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Pagination -->
                <div class="saved-pagination-wrap">
                    <a href="#" class="btn-page-arrow" aria-label="Previous Page"><i class="fa-solid fa-chevron-left"></i></a>
                    <a href="#" class="btn-page-num active">1</a>
                    <a href="#" class="btn-page-num">2</a>
                    <a href="#" class="btn-page-num">3</a>
                    <span class="page-ellipsis">&hellip;</span>
                    <a href="#" class="btn-page-arrow" aria-label="Next Page"><i class="fa-solid fa-chevron-right"></i></a>
                </div>

            </div>

            <!-- Right Sidebar: Closing Soon Panel -->
            <aside class="saved-sidebar-column">
                <div class="closing-soon-card">
                    <div class="closing-card-header">
                        <i class="fa-regular fa-clock color-red"></i>
                        <h3 class="closing-card-title">Closing Soon</h3>
                    </div>

                    <div class="closing-list-stack">

                        <!-- Item 1: Product Designer at Ola -->
                        <div class="closing-item-box">
                            <div class="closing-item-top flex-between">
                                <div class="closing-brand-wrap">
                                    <div class="closing-company-logo">
                                        <img src="<%= ResolveUrl("~/assets/images/ola-logo.svg") %>" alt="Ola" class="closing-logo-img" />
                                    </div>
                                    <div class="closing-meta">
                                        <h4 class="closing-role-name">Product Designer</h4>
                                        <div class="closing-company-name">Ola</div>
                                    </div>
                                </div>
                            </div>
                            <div class="closing-footer-row flex-between">
                                <span class="closing-timer color-red">
                                    <i class="fa-regular fa-clock"></i> 2 DAYS LEFT
                                </span>
                                <a href="javascript:void(0);" class="btn-closing-apply">Apply</a>
                            </div>
                        </div>

                        <!-- Item 2: Frontend Eng Intern at Paytm -->
                        <div class="closing-item-box">
                            <div class="closing-item-top flex-between">
                                <div class="closing-brand-wrap">
                                    <div class="closing-company-logo">
                                        <img src="<%= ResolveUrl("~/assets/images/paytm-logo.svg") %>" alt="Paytm" class="closing-logo-img" />
                                    </div>
                                    <div class="closing-meta">
                                        <h4 class="closing-role-name">Frontend Eng Intern</h4>
                                        <div class="closing-company-name">Paytm</div>
                                    </div>
                                </div>
                            </div>
                            <div class="closing-footer-row flex-between">
                                <span class="closing-timer color-red">
                                    <i class="fa-regular fa-clock"></i> 4 DAYS LEFT
                                </span>
                                <a href="javascript:void(0);" class="btn-closing-apply">Apply</a>
                            </div>
                        </div>

                    </div>

                    <div class="closing-card-footer">
                        <a href="javascript:void(0);" class="closing-view-all-link">View all deadlines</a>
                    </div>
                </div>
            </aside>

        </div>

    </div>
</asp:Content>
