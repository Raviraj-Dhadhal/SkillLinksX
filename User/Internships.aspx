<%@ Page Title="Find Internships - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Internships.aspx.cs" Inherits="SkillLinksX.User.Internships" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Internships Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-opps-page-container">

        <!-- Header Row -->
        <div class="opps-page-header">
            <h1 class="opps-page-title">Find Your Perfect Internship</h1>
            <p class="opps-page-sub">Gain real-world experience, build your network, and start accelerating your career with top tech companies.</p>
        </div>

        <!-- 2-Column Layout: Left Filters + Right Listings -->
        <div class="opps-layout-grid">

            <!-- Left Filters Column -->
            <aside class="opps-filter-column">
                <div class="opps-filter-card">
                    <div class="filter-card-header flex-between">
                        <h3 class="filter-card-title">Filters</h3>
                        <a href="javascript:void(0);" class="filter-clear-all" onclick="resetFilters()">Clear All</a>
                    </div>

                    <div class="filter-card-body">
                        <!-- Location Filter -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">Location</label>
                            <div class="filter-search-input-wrap">
                                <i class="fa-solid fa-location-dot filter-input-icon"></i>
                                <input type="text" class="filter-search-input" placeholder="e.g. Bengaluru" />
                            </div>
                            <div class="filter-pill-tags">
                                <button type="button" class="filter-pill-btn">Remote</button>
                                <button type="button" class="filter-pill-btn active">Bengaluru</button>
                                <button type="button" class="filter-pill-btn">Mumbai</button>
                            </div>
                        </div>

                        <!-- Work Type -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">Work Type</label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" checked="checked" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">On-site</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" checked="checked" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Hybrid</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Remote</span>
                            </label>
                        </div>

                        <!-- Duration -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">Duration</label>
                            <div class="filter-select-wrap">
                                <select class="filter-select-box">
                                    <option selected="selected">3-6 Months</option>
                                    <option>1-3 Months</option>
                                    <option>6+ Months</option>
                                </select>
                                <i class="fa-solid fa-chevron-down filter-select-arrow"></i>
                            </div>
                        </div>

                        <!-- Monthly Stipend -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">Monthly Stipend (INR)</label>
                            <label class="filter-radio-row">
                                <input type="radio" name="stipend" />
                                <span class="custom-radio-indicator"></span>
                                <span class="filter-cb-label">Unpaid / College Credit</span>
                            </label>
                            <label class="filter-radio-row">
                                <input type="radio" name="stipend" checked="checked" />
                                <span class="custom-radio-indicator"></span>
                                <span class="filter-cb-label">&#8377;10,000 - &#8377;20,000</span>
                            </label>
                            <label class="filter-radio-row">
                                <input type="radio" name="stipend" />
                                <span class="custom-radio-indicator"></span>
                                <span class="filter-cb-label">&#8377;20,000+</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Pro Tips Callout Card -->
                <div class="pro-tips-card">
                    <div class="pro-tips-title">
                        <i class="fa-regular fa-lightbulb"></i> Pro Tips
                    </div>
                    <ul class="pro-tips-list">
                        <li>
                            <i class="fa-regular fa-circle-check"></i>
                            <span>Tailor your resume for specific roles.</span>
                        </li>
                        <li>
                            <i class="fa-regular fa-circle-check"></i>
                            <span>Keep your portfolio links updated.</span>
                        </li>
                    </ul>
                </div>
            </aside>

            <!-- Right Main Content Column -->
            <main class="opps-main-column">

                <!-- Category Tabs Navigation -->
                <div class="opps-cat-nav-wrapper">
                    <div class="opps-cat-tabs">
                        <button type="button" class="opps-cat-pill active">All Internships</button>
                        <button type="button" class="opps-cat-pill">Software Dev</button>
                        <button type="button" class="opps-cat-pill">UI/UX Design</button>
                        <button type="button" class="opps-cat-pill">Data Science</button>
                        <button type="button" class="opps-cat-pill">Marketing</button>
                    </div>
                </div>

                <!-- Section: Recommended For You -->
                <div class="opps-section-group">
                    <div class="opps-group-header">
                        <h2 class="opps-group-title">
                            <i class="fa-solid fa-sparkles text-primary"></i> Recommended For You
                        </h2>
                    </div>

                    <!-- Recommended Featured Card: Frontend Developer Intern at Razorpay -->
                    <div class="opp-featured-card">
                        <div class="opp-featured-top">
                            <div class="opp-featured-brand">
                                <div class="opp-company-avatar">
                                    <img src="<%= ResolveUrl("~/assets/images/razorpay-logo.svg") %>" alt="Razorpay Logo" class="opp-brand-logo-img" />
                                </div>
                                <div class="opp-brand-meta">
                                    <h3 class="opp-job-title">
                                        <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>">Frontend Developer Intern</a>
                                    </h3>
                                    <div class="opp-company-location">Razorpay &bull; Bengaluru (Hybrid)</div>
                                </div>
                            </div>
                            <div class="opp-match-badge-wrap">
                                <span class="opp-match-pill"><i class="fa-regular fa-lightbulb"></i> 98% Match</span>
                            </div>
                        </div>

                        <div class="opp-featured-meta-row">
                            <span class="opp-meta-item"><i class="fa-regular fa-calendar"></i> 6 Months</span>
                            <span class="opp-meta-item"><i class="fa-solid fa-wallet"></i> &#8377;25,000 / mo</span>
                        </div>

                        <div class="opp-featured-tags-row">
                            <span class="opp-tag-pill">React.js</span>
                            <span class="opp-tag-pill opp-tag-green">Tailwind CSS</span>
                        </div>
                    </div>
                </div>

                <!-- Section: Recent Postings (with clear separation) -->
                <div class="opps-section-group opps-recent-postings-section" style="margin-top: 36px;">
                    <div class="opps-group-header flex-between">
                        <h2 class="opps-group-title">Recent Postings</h2>
                        <span class="opps-total-results">Showing 124 results</span>
                    </div>

                    <div class="opps-listings-stack">

                        <!-- Item 1: Product Management Intern at Flipkart -->
                        <div class="opp-listing-card">
                            <div class="opp-listing-top">
                                <div class="opp-listing-brand-wrap">
                                    <div class="opp-company-avatar">
                                        <img src="<%= ResolveUrl("~/assets/images/technova-avatar.svg") %>" alt="Flipkart" class="opp-brand-logo-img" />
                                    </div>
                                    <div class="opp-listing-info">
                                        <h3 class="opp-card-heading">
                                            <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>">Product Management Intern</a>
                                        </h3>
                                        <div class="opp-card-sub">Flipkart &bull; Bengaluru, KA</div>
                                    </div>
                                </div>
                                <button type="button" class="btn-opp-bookmark" title="Save Opportunity" aria-label="Save Opportunity">
                                    <i class="fa-regular fa-bookmark"></i>
                                </button>
                            </div>

                            <div class="opp-listing-meta-row">
                                <span class="opp-meta-item"><i class="fa-solid fa-briefcase"></i> On-site</span>
                                <span class="opp-meta-item"><i class="fa-regular fa-clock"></i> 3 Months</span>
                                <span class="opp-meta-item"><i class="fa-solid fa-wallet"></i> &#8377;30,000 / mo</span>
                            </div>

                            <div class="opp-tags-flex">
                                <span class="opp-tag-pill">Agile</span>
                                <span class="opp-tag-pill">Data Analysis</span>
                                <span class="opp-tag-pill">Wireframing</span>
                            </div>

                            <div class="opp-listing-footer flex-between">
                                <span class="opp-posted-time">Posted 2 days ago</span>
                                <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>" class="btn-opp-apply">Apply Now</a>
                            </div>
                        </div>

                        <!-- Item 2: Backend Engineering Intern (Go) at Zomato -->
                        <div class="opp-listing-card">
                            <div class="opp-listing-top">
                                <div class="opp-listing-brand-wrap">
                                    <div class="opp-company-avatar avatar-letter-z">Z</div>
                                    <div class="opp-listing-info">
                                        <h3 class="opp-card-heading">
                                            <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>">Backend Engineering Intern (Go)</a>
                                        </h3>
                                        <div class="opp-card-sub">Zomato &bull; Gurugram (Hybrid)</div>
                                    </div>
                                </div>
                                <button type="button" class="btn-opp-bookmark" title="Save Opportunity" aria-label="Save Opportunity">
                                    <i class="fa-regular fa-bookmark"></i>
                                </button>
                            </div>

                            <div class="opp-listing-meta-row">
                                <span class="opp-meta-item"><i class="fa-solid fa-laptop-code"></i> Hybrid</span>
                                <span class="opp-meta-item"><i class="fa-regular fa-clock"></i> 6 Months</span>
                                <span class="opp-meta-item"><i class="fa-solid fa-wallet"></i> &#8377;40,000 / mo</span>
                            </div>

                            <div class="opp-tags-flex">
                                <span class="opp-tag-pill">Golang</span>
                                <span class="opp-tag-pill">PostgreSQL</span>
                                <span class="opp-tag-pill">APIs</span>
                            </div>

                            <div class="opp-listing-footer flex-between">
                                <span class="opp-posted-time">Posted 5 hours ago</span>
                                <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>" class="btn-opp-apply">Apply Now</a>
                            </div>
                        </div>

                    </div>

                    <!-- Pagination Row -->
                    <div class="opp-pagination-wrap">
                        <a href="#" class="btn-page-step" style="opacity: 0.5; pointer-events: none;">Previous</a>
                        <a href="#" class="btn-page-num active">1</a>
                        <a href="#" class="btn-page-num">2</a>
                        <a href="#" class="btn-page-num">3</a>
                        <span class="page-ellipsis">&hellip;</span>
                        <a href="#" class="btn-page-step">Next</a>
                    </div>
                </div>

            </main>

        </div>

    </div>
</asp:Content>
