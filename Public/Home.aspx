<%@ Page Title="SkillLinkX - Connecting Talent With Opportunity" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="SkillLinksX.Public.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page specific meta / head tags if needed -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- ================================================================= -->
    <!-- 1. JOB SEARCH & POPULAR CATEGORIES SECTION                        -->
    <!-- ================================================================= -->
    <section class="home-search-section" id="searchSection">
        <div class="public-container">
            <!-- Section Header -->
            <div class="search-header-box">
                <h2 class="search-headline">Connect. Showcase. Get Hired.</h2>
                <p class="search-subheadline">
                    Discover jobs and internships that match your skills, experience and career goals.
                </p>
            </div>

            <!-- Multi-field Search Bar -->
            <div class="search-bar-wrapper" id="searchBarWrapper">
                <!-- Search Keyword -->
                <div class="search-input-group">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <asp:TextBox ID="txtSearchKeyword" runat="server" CssClass="search-input-field" placeholder="Job title, keywords, or company"></asp:TextBox>
                </div>

                <div class="search-field-divider"></div>

                <!-- Search Location -->
                <div class="search-input-group">
                    <i class="fa-solid fa-location-dot"></i>
                    <asp:TextBox ID="txtSearchLocation" runat="server" CssClass="search-input-field" placeholder="City, state, or 'Remote'"></asp:TextBox>
                </div>

                <!-- Search Button (Anchor tag) -->
                <a href="#" class="btn-search-submit" id="btnSearchJobs">Search</a>
            </div>

            <!-- Popular Category Cards (4-column grid matching Figma) -->
            <div class="category-cards-grid" id="categoryCardsGrid">
                <!-- Category 1: Software & IT -->
                <a href='<%= ResolveUrl("~/Public/Login.aspx") %>' class="category-card-item" id="catSoftwareIT">
                    <div class="category-icon-box">
                        <i class="fa-solid fa-shapes"></i>
                    </div>
                    <span class="category-title-text">Software & IT</span>
                    <span class="category-count-sub">2,450 open roles</span>
                </a>

                <!-- Category 2: Marketing -->
                <a href='<%= ResolveUrl("~/Public/Login.aspx") %>' class="category-card-item" id="catMarketing">
                    <div class="category-icon-box">
                        <i class="fa-solid fa-bullhorn"></i>
                    </div>
                    <span class="category-title-text">Marketing</span>
                    <span class="category-count-sub">1,230 open roles</span>
                </a>

                <!-- Category 3: Design -->
                <a href='<%= ResolveUrl("~/Public/Login.aspx") %>' class="category-card-item" id="catDesign">
                    <div class="category-icon-box">
                        <i class="fa-solid fa-wrench"></i>
                    </div>
                    <span class="category-title-text">Design</span>
                    <span class="category-count-sub">840 open roles</span>
                </a>

                <!-- Category 4: Finance -->
                <a href='<%= ResolveUrl("~/Public/Login.aspx") %>' class="category-card-item" id="catFinance">
                    <div class="category-icon-box">
                        <i class="fa-solid fa-building-columns"></i>
                    </div>
                    <span class="category-title-text">Finance</span>
                    <span class="category-count-sub">1,890 open roles</span>
                </a>
            </div>
        </div>
    </section>

    <!-- ================================================================= -->
    <!-- 3. FEATURED OPPORTUNITIES SECTION                                 -->
    <!-- ================================================================= -->
    <section class="featured-jobs-section" id="featuredJobsSection">
        <div class="public-container">
            <!-- Section Title Row -->
            <div class="section-title-row">
                <div>
                    <h2 class="section-heading-text">Featured Opportunities</h2>
                    <p class="section-subtext">Top roles hand-picked for you.</p>
                </div>
                <a href='<%= ResolveUrl("~/Public/Login.aspx") %>' class="section-view-all-link" id="linkBrowseAllJobs">
                    View all jobs
                </a>
            </div>

            <!-- 2-Column Split Grid Matching Figma -->
            <div class="featured-split-grid" id="opportunitiesList">
                <!-- Left: Big Featured Card -->
                <div class="featured-big-card">
                    <div class="featured-big-header">
                        <div class="featured-big-header-left">
                            <div class="company-logo-badge">
                                <img src='<%= ResolveUrl("~/assets/images/logo.svg") %>' alt="TechFlow Systems" />
                            </div>
                            <div>
                                <h3 class="featured-big-role-title">Senior Frontend Developer</h3>
                                <div class="featured-big-company">TechFlow Systems</div>
                            </div>
                        </div>
                        <button type="button" class="btn-bookmark-action" aria-label="Bookmark Job">
                            <i class="fa-solid fa-bookmark" style="color:#334155;"></i>
                        </button>
                    </div>

                    <div class="featured-big-tags">
                        <span class="figma-pill"><i class="fa-solid fa-location-dot"></i> Dehli, India</span>
                        <span class="figma-pill"><i class="fa-regular fa-clock"></i> Full-time</span>
                        <span class="figma-pill"><i class="fa-solid fa-money-bill-wave"></i> ₹120k - 150k</span>
                    </div>

                    <p class="featured-big-desc">
                        We are seeking an experienced Frontend Developer to lead our UI architecture. You will be responsible for building highly performant, scalable, and beautifully designed user interfaces using modern web technologies.
                    </p>

                    <div>
                        <a href='<%= ResolveUrl("~/Public/Login.aspx") %>' class="btn-apply-figma">Apply Now</a>
                    </div>
                </div>

                <!-- Right: 3 Stacked Cards -->
                <div class="featured-stacked-column">
                    <!-- Right Card 1: UX Designer Intern -->
                    <div class="featured-stack-card">
                        <div class="stack-card-top">
                            <div class="stack-card-icon-box">
                                <i class="fa-solid fa-desktop" style="color:#0052CC;"></i>
                            </div>
                            <div class="stack-card-details">
                                <h4 class="stack-role-title">UX Designer Intern</h4>
                                <div class="stack-company-name">DataStream</div>
                            </div>
                        </div>
                        <div class="stack-card-bottom">
                            <span class="stack-loc"><i class="fa-solid fa-location-dot"></i> Dehli</span>
                            <span class="stack-status-active">Active</span>
                        </div>
                    </div>

                    <!-- Right Card 2: Financial Analyst -->
                    <div class="featured-stack-card">
                        <div class="stack-card-top">
                            <div class="stack-card-icon-box">
                                <i class="fa-solid fa-award" style="color:#854D0E;"></i>
                            </div>
                            <div class="stack-card-details">
                                <h4 class="stack-role-title">Financial Analyst</h4>
                                <div class="stack-company-name">Apex Capital</div>
                            </div>
                        </div>
                        <div class="stack-card-bottom">
                            <span class="stack-loc"><i class="fa-solid fa-location-dot"></i> Mumbai</span>
                            <span class="stack-status-new">New</span>
                        </div>
                    </div>

                    <!-- Right Card 3: Marketing Manager -->
                    <div class="featured-stack-card">
                        <div class="stack-card-top">
                            <div class="stack-card-icon-box">
                                <i class="fa-solid fa-rectangle-ad" style="color:#0284C7;"></i>
                            </div>
                            <div class="stack-card-details">
                                <h4 class="stack-role-title">Marketing Manager</h4>
                                <div class="stack-company-name">BrandLift</div>
                            </div>
                        </div>
                        <div class="stack-card-bottom">
                            <span class="stack-loc"><i class="fa-solid fa-location-dot"></i> Bangluru</span>
                            <span class="stack-status-ago">2 days ago</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ============================================================= -->
            <!-- 4. CALL TO ACTION BANNER                                      -->
            <!-- ============================================================= -->
            <div class="home-cta-banner" id="homeCtaBanner">
                <h3 class="cta-banner-title">Ready to accelerate your career?</h3>
                <p class="cta-banner-subtext">
                    Join thousands of students and companies on SkillLinkX. Build your profile, explore opportunities, and get hired.
                </p>
                <div class="cta-button-group">
                    <a href='<%= ResolveUrl("~/Public/Register.aspx") %>' class="btn-cta-white" id="btnCtaGetStarted">
                        Get Started Free
                    </a>
                    <a href='<%= ResolveUrl("~/Public/Register.aspx") %>' class="btn-cta-transparent" id="btnCtaEmployers">
                        For Employers
                    </a>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
