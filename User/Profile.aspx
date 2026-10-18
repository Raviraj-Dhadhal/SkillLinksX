<%@ Page Title="My Profile - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SkillLinksX.User.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Profile Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-profile-page-container">

        <!-- Top Profile Banner & Hero Header Card -->
        <div class="cand-profile-hero-card">
            <!-- Top Hero Row -->
            <div class="cand-profile-hero-top">
                <div class="cand-profile-avatar-wrap">
                    <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" class="cand-profile-avatar-img" />
                </div>

                <div class="cand-profile-hero-details">
                    <div class="cand-profile-title-row">
                        <div class="cand-name-and-tagline">
                            <h1 class="cand-profile-name">Raviraj Dhadhal</h1>
                            <p class="cand-profile-tagline">B.Tech Computer Engineering Student | Aspiring Full Stack Developer</p>
                            <div class="cand-profile-meta-row">
                                <span><i class="fa-solid fa-location-dot"></i> Ahmedabad, Gujarat</span>
                                <span><i class="fa-solid fa-building-columns"></i> Gujarat Technological University</span>
                                <span><i class="fa-regular fa-calendar"></i> Graduation: 2025</span>
                            </div>
                        </div>

                        <!-- Action Buttons: Share & Edit -->
                        <div class="cand-profile-hero-actions">
                            <button type="button" class="btn-profile-hero-share">
                                <i class="fa-solid fa-share-nodes"></i> Share Profile
                            </button>
                            <a href="<%= ResolveUrl("~/User/Settings.aspx") %>" class="btn-profile-hero-edit" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
                                <i class="fa-regular fa-pen-to-square"></i> Edit Profile
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Strength Row -->
            <div class="cand-strength-banner">
                <div class="cand-strength-circle-wrap">
                    <svg class="strength-circle-svg" width="36" height="36">
                        <circle class="strength-bg" cx="18" cy="18" r="14" stroke="#E2E8F0" stroke-width="3" fill="none" />
                        <circle class="strength-fill" cx="18" cy="18" r="14" stroke="#10B981" stroke-width="3" stroke-dasharray="87.96" stroke-dashoffset="13.19" stroke-linecap="round" fill="none" />
                    </svg>
                    <span class="strength-percentage-txt">85%</span>
                </div>
                <div class="cand-strength-info">
                    <span class="cand-strength-title">Profile Strength: <strong class="text-green">Excellent</strong></span>
                    <span class="cand-strength-sub">Add a cover photo to reach 100%</span>
                </div>
            </div>
        </div>

        <!-- 2-Column Content Layout: Left Details + Right Insights/Sidebar Cards -->
        <div class="cand-profile-main-grid">

            <!-- Left Main Column (About, Education, Experience, Key Projects) -->
            <div class="cand-profile-left-col">

                <!-- 1. About Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-regular fa-user section-icon-blue"></i>
                            <h2 class="cand-card-title">About</h2>
                        </div>
                        <button type="button" class="btn-card-edit" aria-label="Edit About">
                            <i class="fa-regular fa-pen-to-square"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <p class="cand-about-p">
                            Passionate about building scalable web applications and mobile solutions. Currently exploring AI-driven career paths. I am actively seeking internship and junior developer opportunities where I can apply my knowledge of full-stack development and learn from experienced professionals. I thrive in collaborative environments and am driven by solving complex logical problems.
                        </p>
                    </div>
                </div>

                <!-- 2. Education Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-graduation-cap section-icon-blue"></i>
                            <h2 class="cand-card-title">Education</h2>
                        </div>
                        <button type="button" class="btn-card-add" aria-label="Add Education">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <div class="timeline-item">
                            <div class="timeline-dot-ring"></div>
                            <div class="timeline-details">
                                <h3 class="timeline-title">Gujarat Technological University</h3>
                                <p class="timeline-sub">B.Tech Computer Engineering</p>
                                <div class="timeline-meta-row">
                                    <span><i class="fa-regular fa-calendar"></i> 2021 - 2025</span>
                                    <span class="badge-grade"><i class="fa-regular fa-star"></i> CGPA: 8.8/10.0</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 3. Experience & Internships Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-briefcase section-icon-blue"></i>
                            <h2 class="cand-card-title">Experience &amp; Internships</h2>
                        </div>
                        <button type="button" class="btn-card-add" aria-label="Add Experience">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <div class="timeline-item">
                            <div class="timeline-dot-ring"></div>
                            <div class="timeline-details">
                                <h3 class="timeline-title">Junior Web Intern</h3>
                                <p class="timeline-sub">TechFlow &bull; Internship</p>
                                <div class="timeline-meta-row">
                                    <span><i class="fa-regular fa-calendar"></i> Jun 2024 - Aug 2024 (3 months)</span>
                                    <span><i class="fa-solid fa-location-dot"></i> Ahmedabad, India</span>
                                </div>
                                <p class="timeline-desc-text">
                                    Assisted in developing responsive frontend components using React.js and integrated REST APIs. Participated in daily stand-ups and agile development cycles.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 4. Key Projects Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-code section-icon-blue"></i>
                            <h2 class="cand-card-title">Key Projects</h2>
                        </div>
                        <button type="button" class="btn-card-add" aria-label="Add Project">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <div class="cand-projects-2grid">
                            <!-- Project 1 -->
                            <div class="cand-project-box">
                                <div class="project-box-header">
                                    <h3 class="project-box-name">AI-Powered Job Scraper</h3>
                                    <a href="javascript:void(0);" class="project-ext-link" aria-label="Open Project">
                                        <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                    </a>
                                </div>
                                <p class="project-box-desc">
                                    A Python script utilizing BeautifulSoup and simple NLP to extract and categorize jobs...
                                </p>
                                <div class="project-tags-list">
                                    <span class="project-tag-pill">Python</span>
                                    <span class="project-tag-pill">NLP</span>
                                </div>
                            </div>

                            <!-- Project 2 -->
                            <div class="cand-project-box">
                                <div class="project-box-header">
                                    <h3 class="project-box-name">SkillLinkX Mobile Prototype</h3>
                                    <a href="javascript:void(0);" class="project-ext-link" aria-label="Open Project">
                                        <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                    </a>
                                </div>
                                <p class="project-box-desc">
                                    A cross-platform mobile application prototype for a professional networking...
                                </p>
                                <div class="project-tags-list">
                                    <span class="project-tag-pill">Flutter</span>
                                    <span class="project-tag-pill">Dart</span>
                                    <span class="project-tag-pill">Firebase</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar Column (AI Insights, Resume, Top Skills, Career Preferences, Links) -->
            <div class="cand-profile-right-col">

                <!-- 1. AI Profile Insights Card -->
                <div class="cand-section-card ai-insights-card">
                    <div class="cand-card-header">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-wand-magic-sparkles section-icon-blue"></i>
                            <h2 class="cand-card-title">AI Profile Insights</h2>
                        </div>
                    </div>
                    <div class="cand-card-body">
                        <div class="ai-score-row">
                            <span class="ai-score-label">Resume Score</span>
                            <span class="ai-score-value">82/100</span>
                        </div>

                        <div class="ai-suggested-section">
                            <span class="ai-suggested-label">SUGGESTED SKILLS TO ADD</span>
                            <div class="ai-skills-chips">
                                <button type="button" class="btn-suggested-chip">+ React</button>
                                <button type="button" class="btn-suggested-chip">+ Docker</button>
                            </div>
                        </div>

                        <button type="button" class="btn-improve-profile">
                            <i class="fa-solid fa-wand-magic-sparkles"></i> Improve My Profile
                        </button>
                    </div>
                </div>

                <!-- 2. Resume Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header">
                        <div class="cand-card-title-group">
                            <i class="fa-regular fa-file-lines section-icon-blue"></i>
                            <h2 class="cand-card-title">Resume</h2>
                        </div>
                    </div>
                    <div class="cand-card-body">
                        <div class="resume-file-preview-card">
                            <div class="resume-icon-box">
                                <i class="fa-regular fa-file-pdf"></i>
                            </div>
                            <div class="resume-file-info">
                                <span class="resume-file-name">Raviraj_Dhadhal_CV.pdf</span>
                                <span class="resume-file-meta">Updated 2 days ago &bull; 1.2 MB</span>
                            </div>
                            <div class="resume-file-actions">
                                <a href="javascript:void(0);" class="btn-resume-action" title="View Resume">
                                    <i class="fa-regular fa-eye"></i>
                                </a>
                                <a href="javascript:void(0);" class="btn-resume-action" title="Download Resume">
                                    <i class="fa-solid fa-download"></i>
                                </a>
                            </div>
                        </div>

                        <button type="button" class="btn-upload-new-resume">
                            <i class="fa-solid fa-upload"></i> Upload New Resume
                        </button>
                    </div>
                </div>

                <!-- 3. Top Skills Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-crosshairs section-icon-blue"></i>
                            <h2 class="cand-card-title">Top Skills</h2>
                        </div>
                        <button type="button" class="btn-card-edit" aria-label="Edit Skills">
                            <i class="fa-regular fa-pen-to-square"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <div class="cand-skills-chips-wrap">
                            <span class="skill-dot-chip">C# <span class="skill-level-dot dot-blue"></span></span>
                            <span class="skill-dot-chip">ASP.NET MVC <span class="skill-level-dot dot-blue"></span></span>
                            <span class="skill-dot-chip">SQL Server <span class="skill-level-dot dot-blue"></span></span>
                            <span class="skill-dot-chip">Flutter <span class="skill-level-dot dot-blue"></span></span>
                            <span class="skill-dot-chip">Dart <span class="skill-level-dot dot-blue"></span></span>
                            <span class="skill-dot-chip">HTML/CSS/JS <span class="skill-level-dot dot-blue"></span></span>
                        </div>
                        <div class="skills-legend-row">
                            <span class="legend-item"><span class="legend-dot bg-blue"></span> Advanced</span>
                            <span class="legend-item"><span class="legend-dot bg-purple"></span> Intermediate</span>
                        </div>
                    </div>
                </div>

                <!-- 4. Career Preferences Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-briefcase section-icon-blue"></i>
                            <h2 class="cand-card-title">Career Preferences</h2>
                        </div>
                        <button type="button" class="btn-card-edit" aria-label="Edit Career Preferences">
                            <i class="fa-regular fa-pen-to-square"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <div class="pref-field-group">
                            <span class="pref-field-label">ROLES</span>
                            <span class="pref-field-val">Full Stack Developer, Software Engineer</span>
                        </div>
                        <div class="pref-field-group">
                            <span class="pref-field-label">LOCATIONS</span>
                            <span class="pref-field-val">Bengaluru, Mumbai, Remote</span>
                        </div>
                        <div class="pref-field-group">
                            <span class="pref-field-label">WORK TYPE</span>
                            <span class="pref-field-val">Hybrid / Remote</span>
                        </div>
                        <div class="pref-field-group">
                            <span class="pref-field-label">EXPECTED SALARY</span>
                            <span class="pref-field-val">&#8377;8L - &#8377;12L</span>
                        </div>
                    </div>
                </div>

                <!-- 5. Links Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-link section-icon-blue"></i>
                            <h2 class="cand-card-title">Links</h2>
                        </div>
                    </div>
                    <div class="cand-card-body">
                        <div class="social-links-list">
                            <a href="https://github.com" target="_blank" class="social-link-item">
                                <i class="fa-brands fa-github"></i>
                                <span>GitHub</span>
                            </a>
                            <a href="https://linkedin.com" target="_blank" class="social-link-item">
                                <i class="fa-brands fa-linkedin"></i>
                                <span>LinkedIn</span>
                            </a>
                            <a href="javascript:void(0);" class="social-link-item">
                                <i class="fa-solid fa-globe"></i>
                                <span>Personal Site</span>
                            </a>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
