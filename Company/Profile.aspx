<%@ Page Title="Company Profile - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SkillLinksX.Company.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Company Profile Specific Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="company-profile-container">
        
        <!-- 1. Top Company Overview Header Card -->
        <div class="profile-header-card">
            <div class="profile-header-top">
                <!-- TechNova Logo Monogram -->
                <div class="company-profile-logo-box">
                    <img src='<%= ResolveUrl("~/assets/images/technova-logo.svg") %>' alt="TechNova Logo" />
                </div>

                <!-- Company Details -->
                <div class="profile-header-details">
                    <h1 class="profile-company-name">TechNova</h1>
                    <div class="profile-meta-tags-row">
                        <div class="profile-meta-item">
                            <i class="fa-solid fa-briefcase"></i> IT Services & Consulting
                        </div>
                        <div class="profile-meta-item">
                            <i class="fa-solid fa-location-dot"></i> Bengaluru, KA
                        </div>
                        <div class="profile-meta-item">
                            <i class="fa-solid fa-users"></i> 501-1,000 employees
                        </div>
                    </div>
                    <div class="profile-meta-tags-row">
                        <div class="profile-meta-item">
                            <i class="fa-regular fa-calendar"></i> Founded 2015
                        </div>
                        <div class="profile-meta-item">
                            <i class="fa-solid fa-globe"></i> technova.ai
                        </div>
                    </div>
                </div>

                <!-- Action Buttons: Share & Edit -->
                <div class="profile-header-actions">
                    <button type="button" class="btn-profile-share" title="Share Profile">
                        <i class="fa-solid fa-share-nodes"></i> Share Profile
                    </button>
                    <a href="#" class="btn-profile-edit" title="Edit Profile">
                        <i class="fa-regular fa-pen-to-square"></i> Edit Profile
                    </a>
                </div>
            </div>

            <!-- Profile Completion Progress Track -->
            <div class="profile-completion-section">
                <div class="profile-completion-header">
                    <span>PROFILE COMPLETION</span>
                    <span>85%</span>
                </div>
                <div class="profile-completion-track">
                    <div class="profile-completion-bar" style="width: 85%;"></div>
                </div>
            </div>
        </div>

        <!-- 2. Two-Column Split Grid (Left Main / Right Widgets) -->
        <div class="profile-two-col-grid">
            
            <!-- Left Column -->
            <div class="profile-left-col">
                
                <!-- About TechNova Card -->
                <div class="profile-card">
                    <h2 class="profile-card-title">About TechNova</h2>
                    <p class="about-company-desc">
                        TechNova is a premier IT services and consulting firm specializing in AI and digital transformation. We partner with forward-thinking enterprises to design, build, and deploy intelligent software solutions that drive operational efficiency and create new revenue streams. Our team of expert engineers and data scientists are dedicated to solving complex business challenges with cutting-edge technology.
                    </p>

                    <!-- Mission & Vision 2-Col Box -->
                    <div class="mission-vision-row">
                        <div class="mission-vision-box">
                            <span class="mv-badge">MISSION</span>
                            <p class="mv-quote">"Empowering businesses through intelligent technology."</p>
                        </div>
                        <div class="mission-vision-box">
                            <span class="mv-badge">VISION</span>
                            <p class="mv-quote">"To be the global leader in AI-driven solutions."</p>
                        </div>
                    </div>
                </div>

                <!-- Open Positions Section -->
                <div>
                    <div class="positions-header-row">
                        <h2 class="profile-card-title" style="margin-bottom:0;">Open Positions</h2>
                        <a href="<%= ResolveUrl("~/Company/ManageJobs.aspx") %>" class="view-all-positions-link">View all</a>
                    </div>

                    <!-- Position Card 1: Senior Software Engineer -->
                    <div class="position-item-card">
                        <div class="position-top-row">
                            <h3 class="position-role-title">Senior Software Engineer</h3>
                            <span class="position-badge-active">Active</span>
                        </div>
                        <div class="position-company-sub">TechNova &bull; Full-time</div>
                        <div class="position-pills-row">
                            <span class="position-pill"><i class="fa-solid fa-location-dot"></i> Bengaluru</span>
                            <span class="position-pill"><i class="fa-solid fa-briefcase"></i> 5+ yrs</span>
                            <span class="position-pill"><i class="fa-solid fa-money-bill-wave"></i> &#8377;18L - &#8377;25L</span>
                        </div>
                        <div class="position-bottom-row">
                            <span class="position-applicants-count">12 applicants</span>
                            <a href="<%= ResolveUrl("~/Company/ManageJobs.aspx") %>" class="manage-job-btn-link">Manage Job</a>
                        </div>
                    </div>

                    <!-- Position Card 2: Frontend Developer Intern -->
                    <div class="position-item-card">
                        <div class="position-top-row">
                            <h3 class="position-role-title">Frontend Developer Intern</h3>
                            <span class="position-badge-active">Active</span>
                        </div>
                        <div class="position-company-sub">TechNova &bull; Internship</div>
                        <div class="position-pills-row">
                            <span class="position-pill"><i class="fa-solid fa-laptop"></i> Remote</span>
                            <span class="position-pill"><i class="fa-regular fa-clock"></i> 6 months</span>
                            <span class="position-pill"><i class="fa-solid fa-money-bill-wave"></i> &#8377;25k/mo</span>
                        </div>
                        <div class="position-bottom-row">
                            <span class="position-applicants-count">45 applicants</span>
                            <a href="<%= ResolveUrl("~/Company/ManageJobs.aspx") %>" class="manage-job-btn-link">Manage Job</a>
                        </div>
                    </div>
                </div>

                <!-- Our Hiring Process Card -->
                <div class="hiring-process-card">
                    <h2 class="profile-card-title" style="margin-bottom:0;">Our Hiring Process</h2>
                    
                    <div class="hiring-steps-track">
                        <!-- Step 1: Application -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">1</div>
                            <span class="hiring-node-title">Application</span>
                            <span class="hiring-node-desc">Review of resume and portfolio.</span>
                        </div>

                        <!-- Step 2: Screening -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">2</div>
                            <span class="hiring-node-title">Screening</span>
                            <span class="hiring-node-desc">Initial HR call for alignment.</span>
                        </div>

                        <!-- Step 3: Interview -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">3</div>
                            <span class="hiring-node-title">Interview</span>
                            <span class="hiring-node-desc">Technical and cultural rounds.</span>
                        </div>

                        <!-- Step 4: Selection -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">4</div>
                            <span class="hiring-node-title">Selection</span>
                            <span class="hiring-node-desc">Offer and onboarding.</span>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Right Column Widgets -->
            <div class="profile-right-col">
                
                <!-- 2-Column Stats (Active Jobs & Total Hires) -->
                <div class="profile-stats-2col">
                    <div class="profile-stat-box">
                        <div class="profile-stat-num">12</div>
                        <div class="profile-stat-label">Active Jobs</div>
                    </div>
                    <div class="profile-stat-box">
                        <div class="profile-stat-num">156</div>
                        <div class="profile-stat-label">Total Hires</div>
                    </div>
                </div>

                <!-- Average Response Time Banner -->
                <div class="avg-response-banner">
                    <span class="avg-response-label">AVG RESPONSE TIME</span>
                    <span class="avg-response-val">2 days</span>
                </div>

                <!-- Primary Recruiter Card -->
                <div class="primary-recruiter-card">
                    <div class="recruiter-header-label">PRIMARY RECRUITER</div>
                    <div class="recruiter-profile-row">
                        <img src='<%= ResolveUrl("~/assets/images/user-female-logo.png") %>' alt="Mahek Godvani" class="recruiter-avatar-circle" />
                        <div>
                            <h4 class="recruiter-name">Mahek Godvani</h4>
                            <span class="recruiter-role">Senior Talent Acquisition</span>
                        </div>
                    </div>
                    <a href="<%= ResolveUrl("~/Company/Messages.aspx") %>" class="btn-message-recruiter">
                        <i class="fa-regular fa-message"></i> Message
                    </a>
                </div>

                <!-- Benefits & Culture Card -->
                <div class="benefits-card">
                    <div class="benefits-card-title">BENEFITS &amp; CULTURE</div>
                    
                    <!-- Benefit 1: Flexible Work -->
                    <div class="benefit-item-row">
                        <div class="benefit-icon-box">
                            <i class="fa-solid fa-house-laptop"></i>
                        </div>
                        <div>
                            <div class="benefit-text-title">Flexible Work</div>
                            <p class="benefit-text-sub">Hybrid and remote options available.</p>
                        </div>
                    </div>

                    <!-- Benefit 2: Learning & Dev -->
                    <div class="benefit-item-row">
                        <div class="benefit-icon-box">
                            <i class="fa-solid fa-graduation-cap"></i>
                        </div>
                        <div>
                            <div class="benefit-text-title">Learning &amp; Dev</div>
                            <p class="benefit-text-sub">Dedicated budget for courses and certs.</p>
                        </div>
                    </div>

                    <!-- Benefit 3: Team Collaboration -->
                    <div class="benefit-item-row">
                        <div class="benefit-icon-box">
                            <i class="fa-solid fa-people-group"></i>
                        </div>
                        <div>
                            <div class="benefit-text-title">Team Collaboration</div>
                            <p class="benefit-text-sub">Regular offsites and team building.</p>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
