<%@ Page Title="Candidate Profile - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="CandidateProfile.aspx.cs" Inherits="SkillLinksX.Company.CandidateProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Candidate Profile Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="candidate-profile-page-container">

        <!-- Top Breadcrumb -->
        <div class="cand-breadcrumb-row">
            <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="cand-back-link">
                <i class="fa-solid fa-arrow-left"></i> Back to Search Results
            </a>
            <span class="cand-bread-sep">/</span>
            <span class="cand-bread-current">Candidate Profile</span>
        </div>

        <!-- Hero Card -->
        <div class="cand-hero-card">
            <div class="cand-hero-left">
                <div class="cand-hero-avatar-wrap">
                    <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" class="cand-hero-avatar-img" />
                    <span class="cand-open-badge"><i class="fa-solid fa-circle"></i> Open to Work</span>
                </div>
                <div class="cand-hero-info">
                    <h1 class="cand-hero-name">Raviraj Dhadhal</h1>
                    <div class="cand-hero-title">Senior Software Developer | Full-Stack</div>
                    <div class="cand-hero-meta-row">
                        <span><i class="fa-solid fa-location-dot"></i> Bengaluru, India (Hybrid preferred)</span>
                        <span><i class="fa-solid fa-briefcase"></i> 5+ Years Experience</span>
                        <span><i class="fa-solid fa-graduation-cap"></i> IIT Bombay</span>
                    </div>
                    <div class="cand-hero-cta-buttons">
                        <a href="<%= ResolveUrl("~/Company/Messages.aspx") %>" class="btn-cand-msg" style="text-decoration: none;">
                            <i class="fa-regular fa-message"></i> Message Candidate
                        </a>
                        <a href="<%= ResolveUrl("~/Company/Interviews.aspx") %>" class="btn-cand-schedule" style="text-decoration: none;">
                            <i class="fa-regular fa-calendar"></i> Schedule Interview
                        </a>
                        <button type="button" class="btn-cand-shortlist">
                            <i class="fa-regular fa-bookmark"></i> Shortlist
                        </button>
                    </div>
                </div>
            </div>

            <div class="cand-hero-right">
                <div class="cand-ai-match-hero-chip">
                    <div class="ai-circle-score-wrap">
                        <div class="ai-circle-score-val">94%</div>
                    </div>
                    <div class="ai-circle-score-text">
                        <div class="ai-score-top-label">AI Match Score</div>
                        <div class="ai-score-for-role">For Senior .NET Role</div>
                    </div>
                </div>
                <div style="text-align: right; margin-top: 14px;">
                    <a href="#" class="cand-download-resume-link">
                        <i class="fa-solid fa-download"></i> Download Resume
                    </a>
                </div>
            </div>
        </div>

        <!-- 2-Column Content Layout: Left (Main Details) + Right (AI Analysis & Side Cards) -->
        <div class="cand-layout-2col">
            
            <!-- Left Main Column -->
            <div class="cand-main-col">

                <!-- 1. Professional Summary -->
                <div class="cand-section-card">
                    <h2 class="cand-section-title">
                        <i class="fa-regular fa-user"></i> Professional Summary
                    </h2>
                    <p class="cand-summary-text">
                        Dynamic and results-oriented Software Developer with over 5 years of comprehensive experience in designing, developing, and deploying robust applications. Specializes in building scalable enterprise solutions and modern web applications.
                    </p>
                    <p class="cand-summary-text">
                        Proven track record of collaborating with cross-functional teams to deliver high-quality software within tight deadlines. Passionate about adopting new technologies and optimizing system performance to enhance user experience.
                    </p>
                </div>

                <!-- 2. Skills Matrix -->
                <div class="cand-section-card">
                    <div class="skills-matrix-header">
                        <h2 class="cand-section-title" style="margin-bottom: 0;">
                            <i class="fa-solid fa-code"></i> Skills Matrix
                        </h2>
                        <a href="#" class="view-assessment-link">View Assessment Scores</a>
                    </div>

                    <div class="skill-category-group">
                        <div class="skill-group-name">PROGRAMMING LANGUAGES</div>
                        <div class="skill-tags-flex">
                            <span class="skill-pill-dot level-expert">C# <span class="dot-indicator"></span></span>
                            <span class="skill-pill-dot level-expert">Java <span class="dot-indicator"></span></span>
                            <span class="skill-pill-dot level-intermediate">Python <span class="dot-indicator"></span></span>
                            <span class="skill-pill-dot level-intermediate">Dart <span class="dot-indicator"></span></span>
                        </div>
                    </div>

                    <div class="skill-category-group">
                        <div class="skill-group-name">WEB TECHNOLOGIES</div>
                        <div class="skill-tags-flex">
                            <span class="skill-pill-dot level-expert">ASP.NET MVC <span class="dot-indicator"></span></span>
                            <span class="skill-pill-dot level-expert">JavaScript <span class="dot-indicator"></span></span>
                            <span class="skill-pill-dot level-intermediate">HTML/CSS <span class="dot-indicator"></span></span>
                        </div>
                    </div>

                    <div class="skill-category-group">
                        <div class="skill-group-name">DATABASE &amp; MOBILE</div>
                        <div class="skill-tags-flex">
                            <span class="skill-pill-dot level-expert">SQL Server <span class="dot-indicator"></span></span>
                            <span class="skill-pill-dot level-intermediate">MySQL <span class="dot-indicator"></span></span>
                            <span class="skill-pill-dot level-intermediate">Flutter <span class="dot-indicator"></span></span>
                        </div>
                    </div>

                    <div class="skill-legend-row">
                        <span><span class="legend-dot color-expert"></span> Expert</span>
                        <span><span class="legend-dot color-intermediate"></span> Intermediate</span>
                        <span><span class="legend-dot color-beginner"></span> Beginner</span>
                    </div>
                </div>

                <!-- 3. Experience & Education Timeline -->
                <div class="cand-section-card">
                    <h2 class="cand-section-title">
                        <i class="fa-solid fa-briefcase"></i> Experience &amp; Education
                    </h2>

                    <div class="timeline-container">
                        <!-- Experience Item 1 -->
                        <div class="timeline-item">
                            <div class="timeline-bullet"></div>
                            <div class="timeline-item-header">
                                <div>
                                    <h3 class="timeline-role-title">Senior Software Engineer</h3>
                                    <div class="timeline-company-name">Infosys Technologies Ltd. &bull; Bengaluru, India</div>
                                </div>
                                <span class="timeline-date-badge">Mar 2021 - Present</span>
                            </div>
                            <ul class="timeline-duties-list">
                                <li>Architected and developed microservices utilizing ASP.NET Core, resulting in a 30% reduction in system latency.</li>
                                <li>Mentored junior developers and established code review practices to maintain high code quality standards.</li>
                                <li>Integrated automated CI/CD pipelines using Azure DevOps.</li>
                            </ul>
                        </div>

                        <!-- Experience Item 2 -->
                        <div class="timeline-item">
                            <div class="timeline-bullet"></div>
                            <div class="timeline-item-header">
                                <div>
                                    <h3 class="timeline-role-title">Software Developer</h3>
                                    <div class="timeline-company-name">Wipro Limited &bull; Pune, India</div>
                                </div>
                                <span class="timeline-date-badge">Jul 2018 - Feb 2021</span>
                            </div>
                            <ul class="timeline-duties-list">
                                <li>Developed responsive front-end interfaces using JavaScript and Bootstrap.</li>
                                <li>Designed complex SQL queries and stored procedures for data reporting tools.</li>
                            </ul>
                        </div>

                        <!-- Education Item 3 -->
                        <div class="timeline-item">
                            <div class="timeline-bullet bullet-edu"></div>
                            <div class="timeline-item-header">
                                <div>
                                    <h3 class="timeline-role-title">B.Tech in Computer Science and Engineering</h3>
                                    <div class="timeline-company-name">Indian Institute of Technology (IIT) Bombay</div>
                                </div>
                                <span class="timeline-date-badge">2014 - 2018</span>
                            </div>
                            <div class="timeline-cgpa">CGPA: 9.2/10.0</div>
                        </div>
                    </div>
                </div>

                <!-- 4. Portfolio & Projects -->
                <div class="cand-section-card">
                    <h2 class="cand-section-title">
                        <i class="fa-regular fa-folder-open"></i> Portfolio &amp; Projects
                    </h2>

                    <div class="projects-cards-grid">
                        <!-- Project 1 -->
                        <div class="project-box-card">
                            <div class="project-top-row">
                                <h3 class="project-card-title">E-Commerce API Gateway</h3>
                                <i class="fa-solid fa-code project-link-icon"></i>
                            </div>
                            <p class="project-card-desc">
                                A high-performance API gateway built in C# .NET to manage traffic for high concurrency web services.
                            </p>
                            <div class="project-tags-row">
                                <span class="proj-tag">C#</span>
                                <span class="proj-tag">.NET Core</span>
                                <span class="proj-tag">Redis</span>
                            </div>
                        </div>

                        <!-- Project 2 -->
                        <div class="project-box-card">
                            <div class="project-top-row">
                                <h3 class="project-card-title">TaskMate App</h3>
                                <i class="fa-solid fa-arrow-up-right-from-square project-link-icon"></i>
                            </div>
                            <p class="project-card-desc">
                                A cross-platform productivity mobile application built with Flutter, featuring task syncing &amp; notifications.
                            </p>
                            <div class="project-tags-row">
                                <span class="proj-tag">Flutter</span>
                                <span class="proj-tag">Dart</span>
                                <span class="proj-tag">Firebase</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar Column -->
            <div class="cand-sidebar-col">
                
                <!-- 1. AI Match Analysis Card -->
                <div class="cand-sidebar-card ai-analysis-card">
                    <div class="ai-analysis-header">
                        <i class="fa-solid fa-wand-magic-sparkles"></i>
                        <span class="ai-analysis-title">AI Match Analysis</span>
                    </div>
                    <div class="ai-target-role">Target Role: Senior .NET Developer</div>

                    <div class="ai-big-score-row">
                        <span class="big-score-number">94%</span>
                        <span class="match-quality-pill">Excellent Fit</span>
                    </div>

                    <!-- Progress Bars -->
                    <div class="ai-score-bar-group">
                        <div class="bar-label-row">
                            <span>Skills Match</span>
                            <strong>96%</strong>
                        </div>
                        <div class="cand-progress-track">
                            <div class="cand-progress-fill" style="width: 96%;"></div>
                        </div>
                    </div>

                    <div class="ai-score-bar-group">
                        <div class="bar-label-row">
                            <span>Experience Match</span>
                            <strong>90%</strong>
                        </div>
                        <div class="cand-progress-track">
                            <div class="cand-progress-fill" style="width: 90%;"></div>
                        </div>
                    </div>

                    <div class="ai-score-bar-group">
                        <div class="bar-label-row">
                            <span>Education Match</span>
                            <strong>95%</strong>
                        </div>
                        <div class="cand-progress-track">
                            <div class="cand-progress-fill" style="width: 95%;"></div>
                        </div>
                    </div>

                    <div class="ai-analysis-divider"></div>

                    <!-- Key Matching Skills -->
                    <div class="ai-sub-block">
                        <div class="ai-sub-title">
                            <i class="fa-regular fa-circle-check text-green"></i> Key Matching Skills
                        </div>
                        <div class="ai-skills-chips">
                            <span class="ai-skill-chip-green">C#</span>
                            <span class="ai-skill-chip-green">ASP.NET</span>
                            <span class="ai-skill-chip-green">SQL Server</span>
                            <span class="ai-skill-chip-green">Microservices</span>
                        </div>
                    </div>

                    <!-- Missing/Weak Skills -->
                    <div class="ai-sub-block" style="margin-top: 14px;">
                        <div class="ai-sub-title">
                            <i class="fa-regular fa-circle-xmark text-red"></i> Missing/Weak Skills
                        </div>
                        <div class="ai-skills-chips">
                            <span class="ai-skill-chip-orange">AWS (Required)</span>
                            <span class="ai-skill-chip-gray">Docker (Preferred)</span>
                        </div>
                    </div>
                </div>

                <!-- 2. Candidate Preferences -->
                <div class="cand-sidebar-card">
                    <h3 class="cand-sidebar-card-title">
                        <i class="fa-solid fa-sliders"></i> Candidate Preferences
                    </h3>

                    <div class="cand-pref-list">
                        <div class="cand-pref-row">
                            <span class="pref-label">Preferred Roles</span>
                            <span class="pref-value">Senior Dev, Tech Lead</span>
                        </div>
                        <div class="cand-pref-row">
                            <span class="pref-label">Expected Salary</span>
                            <span class="pref-value">&#8377; 25,00,000 / yr</span>
                        </div>
                        <div class="cand-pref-row">
                            <span class="pref-label">Notice Period</span>
                            <span class="pref-badge-pill">30 Days</span>
                        </div>
                        <div class="cand-pref-row">
                            <span class="pref-label">Work Mode</span>
                            <span class="pref-value">Hybrid / Remote</span>
                        </div>
                    </div>
                </div>

                <!-- 3. Private Team Notes -->
                <div class="cand-sidebar-card">
                    <h3 class="cand-sidebar-card-title">
                        <i class="fa-regular fa-note-sticky"></i> Private Team Notes
                    </h3>

                    <!-- Previous Note Bubble -->
                    <div class="team-note-bubble">
                        <div class="team-note-header">
                            <span class="note-author">Sarah Jenkins (You)</span>
                            <span class="note-time">2 days ago</span>
                        </div>
                        <p class="note-content">
                            Strong technical background. Need to verify AWS knowledge during the technical round as it was flagged by AI.
                        </p>
                    </div>

                    <!-- Add Note Input Box -->
                    <div class="add-note-box">
                        <textarea class="add-note-textarea" placeholder="Add a note for the hiring team..."></textarea>
                        <div style="text-align: right; margin-top: 8px;">
                            <button type="button" class="btn-save-note">Save</button>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
