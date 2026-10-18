<%@ Page Title="Portfolio - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Portfolio.aspx.cs" Inherits="SkillLinksX.User.Portfolio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Portfolio Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-portfolio-page-container">

        <!-- Top Profile Banner & Hero Header Card -->
        <div class="portfolio-hero-card">
            <div class="portfolio-hero-left">
                <!-- Avatar with online indicator -->
                <div class="portfolio-avatar-wrap">
                    <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" class="portfolio-avatar-img" />
                    <span class="portfolio-status-dot" title="Available for opportunities"></span>
                </div>

                <!-- Info Stack -->
                <div class="portfolio-info-stack">
                    <h1 class="portfolio-user-name">Raviraj Dhadhal</h1>
                    <p class="portfolio-user-headline">B.Tech Computer Engineering Student | Full Stack Developer</p>
                    <div class="portfolio-meta-tags">
                        <span class="portfolio-meta-pill">
                            <i class="fa-solid fa-location-dot"></i> Ahmedabad, Gujarat
                        </span>
                        <span class="portfolio-meta-pill">
                            <i class="fa-solid fa-building-columns"></i> Gujarat Technological University
                        </span>
                    </div>

                    <!-- Action Buttons Row -->
                    <div class="portfolio-action-buttons">
                        <a href="<%= ResolveUrl("~/User/Settings.aspx") %>" class="btn-portfolio-edit">
                            <i class="fa-regular fa-pen-to-square"></i> Edit Portfolio
                        </a>
                        <a href="javascript:void(0);" class="btn-portfolio-download">
                            <i class="fa-solid fa-download"></i> Download Resume
                        </a>
                    </div>
                </div>
            </div>

            <!-- End of container: Code Icon (GitHub) & Bag Icon (Scroll to Featured Projects) -->
            <div class="portfolio-hero-end-icons">
                <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="btn-portfolio-icon" title="GitHub / Code Profile" aria-label="GitHub Profile">
                    <i class="fa-solid fa-code"></i>
                </a>
                <button type="button" id="btnScrollToProjects" class="btn-portfolio-icon btn-portfolio-primary" title="View Featured Projects" aria-label="Featured Projects">
                    <i class="fa-solid fa-briefcase"></i>
                </button>
            </div>
        </div>

        <!-- 2-Column Grid: Left (About, Featured Projects, Contribution) + Right (Stats, Skills, Education, Certs, Internship Callout) -->
        <div class="portfolio-layout-grid">

            <!-- LEFT MAIN COLUMN -->
            <div class="portfolio-left-column">

                <!-- 1. About Me Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header">
                        <h2 class="portfolio-card-title">
                            <i class="fa-regular fa-user text-primary"></i> About Me
                        </h2>
                    </div>
                    <div class="portfolio-card-body">
                        <p class="portfolio-about-text">
                            A passionate third-year B.Tech Computer Engineering student with a strong foundation in full-stack web development. I specialize in building robust enterprise applications using the .NET ecosystem and modern JavaScript frameworks. Driven by a desire to solve complex problems, I am actively seeking internship opportunities where I can apply my skills in building scalable architectures and intuitive user interfaces while continuing to learn from industry professionals.
                        </p>
                    </div>
                </div>

                <!-- 2. Featured Projects Card -->
                <div class="portfolio-section-card" id="sectionFeaturedProjects">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-regular fa-folder-open text-primary"></i> Featured Projects
                        </h2>
                        <a href="#" class="portfolio-view-all-link">View All <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                    <div class="portfolio-card-body">
                        <div class="portfolio-projects-grid">

                            <!-- Project 1: SkillLinkX Career Platform -->
                            <div class="portfolio-project-card">
                                <div class="project-thumb-box">
                                    <img src="<%= ResolveUrl("~/assets/images/Portfolio-img-1.png") %>" alt="SkillLinkX Career Platform" class="project-thumb-img" />
                                </div>
                                <div class="project-info-box">
                                    <h3 class="project-title">SkillLinkX Career Platform</h3>
                                    <p class="project-desc">A comprehensive career hub connecting students with recruiters. Features include AI job matching, live messaging, and analytics.</p>
                                    <div class="project-tags-row">
                                        <span class="project-tag">C#</span>
                                        <span class="project-tag">.NET Core</span>
                                        <span class="project-tag">React</span>
                                    </div>
                                    <div class="project-btns-row">
                                        <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="btn-proj-code"><i class="fa-solid fa-code"></i> Code</a>
                                        <a href="<%= ResolveUrl("~/Public/Home.aspx") %>" class="btn-proj-demo"><i class="fa-solid fa-arrow-up-right-from-square"></i> Live Demo</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Project 2: Smart Expense Tracker -->
                            <div class="portfolio-project-card">
                                <div class="project-thumb-box">
                                    <img src="<%= ResolveUrl("~/assets/images/portfolio-img-2.jpg") %>" alt="Smart Expense Tracker" class="project-thumb-img" />
                                </div>
                                <div class="project-info-box">
                                    <h3 class="project-title">Smart Expense Tracker</h3>
                                    <p class="project-desc">A mobile-first progressive web app that categorizes expenses using machine learning and generates intuitive monthly reports.</p>
                                    <div class="project-tags-row">
                                        <span class="project-tag">Python</span>
                                        <span class="project-tag">Flask</span>
                                        <span class="project-tag">Vue.js</span>
                                    </div>
                                    <div class="project-btns-row">
                                        <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="btn-proj-code btn-full-width"><i class="fa-solid fa-code"></i> Code</a>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- 3. Contribution Activity Heatmap Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-code-commit text-primary"></i> Contribution Activity
                        </h2>
                        <span class="portfolio-stat-sub">342 commits this year</span>
                    </div>
                    <div class="portfolio-card-body">
                        <!-- Simulated GitHub Contribution Heatmap Grid -->
                        <div class="contrib-scroll-wrapper">
                            <div class="contrib-heatmap-grid" id="contribHeatmap">
                                <!-- Populated dynamically / styled matrix -->
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- RIGHT SIDEBAR COLUMN -->
            <div class="portfolio-right-column">

                <!-- 1. 2x2 Stats Tiles Grid -->
                <div class="portfolio-stats-2x2">
                    <!-- Metric 1: Profile Views -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-regular fa-eye"></i>
                        </div>
                        <div class="portfolio-stat-number">148</div>
                        <div class="portfolio-stat-title">Profile Views</div>
                    </div>

                    <!-- Metric 2: Resume Downloads -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-solid fa-download"></i>
                        </div>
                        <div class="portfolio-stat-number">32</div>
                        <div class="portfolio-stat-title">Resume Downloads</div>
                    </div>

                    <!-- Metric 3: Project Views -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-regular fa-hand-pointer"></i>
                        </div>
                        <div class="portfolio-stat-number">845</div>
                        <div class="portfolio-stat-title">Project Views</div>
                    </div>

                    <!-- Metric 4: Recruiter Saves -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-regular fa-star"></i>
                        </div>
                        <div class="portfolio-stat-number">12</div>
                        <div class="portfolio-stat-title">Recruiter Saves</div>
                    </div>
                </div>

                <!-- 2. Technical Skills Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-laptop-code text-primary"></i> Technical Skills
                        </h2>
                    </div>
                    <div class="portfolio-card-body">
                        <!-- Programming Languages -->
                        <div class="skills-category-group">
                            <h4 class="skills-group-title">PROGRAMMING LANGUAGES</h4>
                            <div class="skill-progress-item">
                                <div class="skill-name-percent">
                                    <span>C#</span>
                                    <span>85%</span>
                                </div>
                                <div class="skill-progress-track">
                                    <div class="skill-progress-bar" style="width: 85%;"></div>
                                </div>
                            </div>
                            <div class="skill-progress-item">
                                <div class="skill-name-percent">
                                    <span>Python</span>
                                    <span>70%</span>
                                </div>
                                <div class="skill-progress-track">
                                    <div class="skill-progress-bar" style="width: 70%;"></div>
                                </div>
                            </div>
                            <div class="skill-progress-item">
                                <div class="skill-name-percent">
                                    <span>Java</span>
                                    <span>60%</span>
                                </div>
                                <div class="skill-progress-track">
                                    <div class="skill-progress-bar" style="width: 60%;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Web & Frameworks Pills -->
                        <div class="skills-category-group mt-3">
                            <h4 class="skills-group-title">WEB &amp; FRAMEWORKS</h4>
                            <div class="skills-pills-wrap">
                                <span class="portfolio-skill-pill">ASP.NET MVC</span>
                                <span class="portfolio-skill-pill">.NET Core</span>
                                <span class="portfolio-skill-pill">JavaScript</span>
                                <span class="portfolio-skill-pill">React</span>
                                <span class="portfolio-skill-pill">SQL Server</span>
                                <span class="portfolio-skill-pill">Tailwind CSS</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 3. Education Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-graduation-cap text-primary"></i> Education
                        </h2>
                    </div>
                    <div class="portfolio-card-body">
                        <div class="portfolio-edu-item">
                            <div class="edu-blue-dot"></div>
                            <div class="edu-content">
                                <h4 class="edu-degree">B.Tech Computer Engineering</h4>
                                <div class="edu-school">Gujarat Technological University</div>
                                <div class="edu-date-badge">2021 - Present &bull; CGPA: 8.8</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 4. Certifications Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-shield-halved text-primary"></i> Certifications
                        </h2>
                    </div>
                    <div class="portfolio-card-body">
                        <div class="portfolio-cert-list">
                            <!-- Cert 1 -->
                            <div class="portfolio-cert-item">
                                <div class="cert-badge-icon">
                                    <i class="fa-solid fa-award"></i>
                                </div>
                                <div class="cert-details">
                                    <h5 class="cert-name">Microsoft Certified: Azure Fundamentals</h5>
                                    <span class="cert-date">Issued Jan 2023</span>
                                </div>
                            </div>

                            <!-- Cert 2 -->
                            <div class="portfolio-cert-item">
                                <div class="cert-badge-icon">
                                    <i class="fa-solid fa-award"></i>
                                </div>
                                <div class="cert-details">
                                    <h5 class="cert-name">Full Stack Web Development - Udemy</h5>
                                    <span class="cert-date">Issued Aug 2022</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

</asp:Content>
