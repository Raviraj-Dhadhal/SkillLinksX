<%@ Page Title="Internship Details - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="InternshipDetails.aspx.cs" Inherits="SkillLinksX.User.InternshipDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Internship Details Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-opp-details-container">

        <!-- Top Breadcrumbs Bar -->
        <div class="opp-details-breadcrumb">
            <a href="<%= ResolveUrl("~/User/Internships.aspx") %>" class="breadcrumb-back-link">
                <i class="fa-solid fa-arrow-left"></i> Back to Internship
            </a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Software Developer</span>
        </div>

        <!-- 2-Column Details Workspace -->
        <div class="opp-details-grid">

            <!-- Left Main Column (Header Banner, About, Responsibilities, Requirements) -->
            <div class="opp-details-main-col">

                <!-- 1. Header Banner Card -->
                <div class="opp-details-header-card">
                    <div class="opp-header-top-row">
                        <div class="opp-header-brand-wrap">
                            <div class="opp-details-avatar-box">
                                <img src="<%= ResolveUrl("~/assets/images/razorpay-logo.svg") %>" alt="Razorpay" class="opp-details-brand-img" />
                            </div>
                            <div class="opp-details-title-wrap">
                                <h1 class="opp-details-role-title">Frontend Developer Intern</h1>
                                <div class="opp-details-company-name">Razorpay</div>
                                <div class="opp-details-sub-meta">
                                    <span><i class="fa-solid fa-location-dot"></i> Bengaluru</span>
                                    <span><i class="fa-solid fa-laptop-code"></i> Hybrid</span>
                                    <span><i class="fa-regular fa-clock"></i> 6 Months</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="opp-details-stipend-row flex-between">
                        <div class="opp-stipend-amount">
                            &#8377;15,000 &ndash; &#8377;25,000 <span class="opp-stipend-unit">/ month</span>
                        </div>
                        <div class="opp-header-action-btns">
                            <button type="button" class="btn-opp-action-pill">
                                <i class="fa-solid fa-share-nodes"></i> Share
                            </button>
                            <button type="button" class="btn-opp-action-pill">
                                <i class="fa-regular fa-bookmark"></i> Save
                            </button>
                            <button type="button" class="btn-opp-apply-primary" onclick="alert('Application submitted successfully!');">
                                Apply Now
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 2. About the Internship Card -->
                <div class="opp-details-section-card">
                    <div class="opp-section-header">
                        <h2 class="opp-section-title">About the Internship</h2>
                    </div>
                    <div class="opp-section-body">
                        <p class="opp-body-paragraph">
                            We are seeking a passionate and driven Software Development Intern to join our dynamic engineering team. In this role, you will get hands-on experience building scalable payment solutions that empower millions of businesses.
                        </p>
                        <p class="opp-body-paragraph">
                            You will be mentored by senior engineers, gaining deep exposure to full-stack development, modern web architectures, and agile methodologies. This is an incredible opportunity to impact real products while honing your technical skills in a fast-paced fintech environment.
                        </p>

                        <!-- Key Responsibilities -->
                        <h3 class="opp-sub-heading mt-4">Key Responsibilities</h3>
                        <ul class="opp-bullets-list">
                            <li>Develop and maintain responsive user interfaces using React and modern CSS frameworks.</li>
                            <li>Collaborate with cross-functional teams to define, design, and ship new features.</li>
                            <li>Write clean, maintainable, and well-tested code.</li>
                            <li>Participate in code reviews and architecture discussions.</li>
                            <li>Create and maintain technical documentation for internal systems.</li>
                        </ul>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar Column (AI Match Score & Internship Details Meta) -->
            <div class="opp-details-sidebar-col">

                <!-- 1. AI Match Score Card (Purple Gradient) -->
                <div class="ai-match-score-card">
                    <div class="ai-match-top-flex">
                        <div class="ai-match-label-group">
                            <i class="fa-solid fa-sparkles ai-stars-icon"></i>
                            <span class="ai-match-card-label">AI Match Score</span>
                        </div>
                        <div class="ai-match-percentage">94%</div>
                    </div>
                    <p class="ai-match-description">
                        Excellent fit! Your strong background in React and frontend technologies aligns perfectly with their tech stack.
                    </p>
                    <div class="ai-matching-skills-title">MATCHING SKILLS</div>
                    <div class="ai-skills-tags-row">
                        <span class="ai-skill-tag">React</span>
                        <span class="ai-skill-tag">JavaScript</span>
                        <span class="ai-skill-tag">Tailwind CSS</span>
                    </div>
                </div>

                <!-- 2. Internship Details Info Box -->
                <div class="internship-meta-box-card">
                    <div class="meta-box-header">
                        <h3 class="meta-box-title">Internship Details</h3>
                    </div>
                    <div class="meta-box-body">
                        <div class="meta-field-item">
                            <div class="meta-field-icon">
                                <i class="fa-regular fa-calendar"></i>
                            </div>
                            <div class="meta-field-content">
                                <span class="meta-field-name">Start Date</span>
                                <span class="meta-field-val">08/06/2026</span>
                            </div>
                        </div>

                        <div class="meta-field-item">
                            <div class="meta-field-icon">
                                <i class="fa-regular fa-clock"></i>
                            </div>
                            <div class="meta-field-content">
                                <span class="meta-field-name">Duration</span>
                                <span class="meta-field-val">6 Months</span>
                            </div>
                        </div>

                        <div class="meta-field-item">
                            <div class="meta-field-icon">
                                <i class="fa-regular fa-calendar-xmark"></i>
                            </div>
                            <div class="meta-field-content">
                                <span class="meta-field-name">Apply By</span>
                                <span class="meta-field-val">24 Oct, 2026</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
