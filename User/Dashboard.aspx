<%@ Page Title="Dashboard - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SkillLinksX.User.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Dashboard Header -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-dashboard-container">
        
        <!-- 1. Top Greeting & Profile Completion Header -->
        <div class="dash-greeting-row">
            <div>
                <h1 class="dash-greeting-title">Good morning, Raviraj!</h1>
                <p class="dash-greeting-sub">Discover opportunities that match your skills and career goals.</p>
            </div>

            <!-- Profile Completion Widget -->
            <div class="profile-completion-card">
                <div class="progress-ring-box">
                    <svg class="progress-ring" width="46" height="46">
                        <circle class="progress-ring-bg" stroke="#E2E8F0" stroke-width="4" fill="transparent" r="19" cx="23" cy="23" />
                        <circle class="progress-ring-fill" stroke="#059669" stroke-width="4" stroke-dasharray="119.38" stroke-dashoffset="17.9" stroke-linecap="round" fill="transparent" r="19" cx="23" cy="23" />
                    </svg>
                    <span class="progress-ring-text">85%</span>
                </div>
                <div class="profile-completion-info">
                    <span class="completion-label">Profile Completion</span>
                    <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="completion-link">Complete profile</a>
                </div>
            </div>
        </div>

        <!-- 2. Metric Summary Cards (4 Columns) -->
        <div class="dash-metrics-grid">
            <!-- Card 1: Applications -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Applications</span>
                    <i class="fa-regular fa-clipboard metric-icon"></i>
                </div>
                <div class="metric-value">12</div>
            </div>

            <!-- Card 2: Interviews -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Interviews</span>
                    <i class="fa-regular fa-calendar-check metric-icon"></i>
                </div>
                <div class="metric-value">3</div>
            </div>

            <!-- Card 3: Shortlisted -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Shortlisted</span>
                    <i class="fa-regular fa-star metric-icon"></i>
                </div>
                <div class="metric-value">5</div>
            </div>

            <!-- Card 4: Profile Views -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Profile Views</span>
                    <i class="fa-regular fa-eye metric-icon"></i>
                </div>
                <div class="metric-value">148</div>
            </div>
        </div>

        <!-- 3. Two-Column Split Layout (Main Left 1.9fr / Sidebar Right 1fr) -->
        <div class="dash-split-grid">
            
            <!-- Left / Center Column -->
            <div class="dash-main-column">
                
                <!-- AI Match Analysis Banner -->
                <div class="ai-match-card">
                    <div class="ai-badge-row">
                        <i class="fa-solid fa-wand-magic-sparkles"></i>
                        <span>AI MATCH ANALYSIS</span>
                    </div>
                    <h2 class="ai-match-title">92% AI Match</h2>
                    <p class="ai-match-sub">
                        Based on your recent projects, we found 24 highly recommended opportunities.
                    </p>
                    <div class="ai-skills-pill-row">
                        <span class="ai-skill-pill">C#</span>
                        <span class="ai-skill-pill">SQL</span>
                        <span class="ai-skill-pill">ASP.NET</span>
                    </div>
                    <div>
                        <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="btn-ai-recommendations">
                            View Recommendations <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <!-- Top Matches Section -->
                <div class="dash-section-box">
                    <div class="dash-section-header">
                        <h3 class="dash-section-title">Top Matches</h3>
                        <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="dash-view-all-link">View all</a>
                    </div>

                    <div class="top-matches-grid">
                        <!-- Match Card 1: Junior .NET Developer -->
                        <div class="match-job-card">
                            <div class="match-job-top">
                                <div class="match-job-icon-box">
                                    <i class="fa-regular fa-building"></i>
                                </div>
                                <button type="button" class="btn-match-bookmark" aria-label="Bookmark">
                                    <i class="fa-regular fa-bookmark"></i>
                                </button>
                            </div>
                            <h4 class="match-job-title">Junior .NET Developer</h4>
                            <div class="match-company-name">TechFlow Mumbai</div>
                            <div class="match-meta-row">
                                <span><i class="fa-solid fa-money-bill-wave"></i> &#8377;6L - &#8377;8L</span>
                                <span><i class="fa-solid fa-location-dot"></i> Mumbai</span>
                            </div>
                            <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="btn-match-apply-blue">Apply Now</a>
                        </div>

                        <!-- Match Card 2: Flutter Intern -->
                        <div class="match-job-card">
                            <div class="match-job-top">
                                <div class="match-job-icon-box">
                                    <i class="fa-solid fa-laptop-code"></i>
                                </div>
                                <button type="button" class="btn-match-bookmark" aria-label="Bookmark">
                                    <i class="fa-regular fa-bookmark"></i>
                                </button>
                            </div>
                            <h4 class="match-job-title">Flutter Intern</h4>
                            <div class="match-company-name">AppGen Bengaluru</div>
                            <div class="match-meta-row">
                                <span><i class="fa-solid fa-money-bill-wave"></i> &#8377;25k stipend</span>
                                <span><i class="fa-solid fa-location-dot"></i> Ahemadabad</span>
                            </div>
                            <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="btn-match-quick-apply-white">Quick Apply</a>
                        </div>
                    </div>
                </div>

                <!-- Recent Applications Table Section -->
                <div class="dash-section-box">
                    <div class="dash-section-header">
                        <h3 class="dash-section-title">Recent Applications</h3>
                        <a href="<%= ResolveUrl("~/User/Applications.aspx") %>" class="dash-view-all-link">View all</a>
                    </div>

                    <div class="recent-apps-table-card">
                        <table class="recent-apps-table">
                            <thead>
                                <tr>
                                    <th>COMPANY</th>
                                    <th>ROLE</th>
                                    <th>STATUS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Row 1: Digital Solutions -->
                                <tr>
                                    <td>
                                        <div class="table-company-cell">
                                            <div class="table-company-icon">
                                                <i class="fa-regular fa-building"></i>
                                            </div>
                                            <span class="table-company-name">Digital Solutions</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="table-role-text">Software Engineer</span>
                                    </td>
                                    <td>
                                        <span class="status-pill status-review">Under Review</span>
                                    </td>
                                </tr>

                                <!-- Row 2: Global Reach -->
                                <tr>
                                    <td>
                                        <div class="table-company-cell">
                                            <div class="table-company-icon">
                                                <i class="fa-solid fa-globe"></i>
                                            </div>
                                            <span class="table-company-name">Global Reach</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="table-role-text">Backend Intern</span>
                                    </td>
                                    <td>
                                        <span class="status-pill status-shortlisted">Shortlisted</span>
                                    </td>
                                </tr>

                                <!-- Row 3: InnoTech Labs -->
                                <tr>
                                    <td>
                                        <div class="table-company-cell">
                                            <div class="table-company-icon">
                                                <i class="fa-solid fa-code"></i>
                                            </div>
                                            <span class="table-company-name">InnoTech Labs</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="table-role-text">Full Stack Developer</span>
                                    </td>
                                    <td>
                                        <span class="status-pill status-applied">Applied</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

            <!-- Right Column Widgets -->
            <div class="dash-side-column">
                
                <!-- Upcoming Interviews Card -->
                <div class="widget-white-card">
                    <h3 class="widget-card-title">Upcoming Interviews</h3>
                    <div class="interview-inner-card">
                        <div class="interview-header-row">
                            <div>
                                <h4 class="interview-company-name">Apex Capital</h4>
                                <div class="interview-role-name">Full Stack Developer</div>
                            </div>
                            <i class="fa-solid fa-video interview-video-icon"></i>
                        </div>
                        <div class="interview-date-row">
                            <i class="fa-regular fa-calendar"></i> Oct 24, 10:00 AM
                        </div>
                        <a href="#" class="btn-join-meeting">Join Virtual Meeting</a>
                    </div>
                </div>

                <!-- Skill Verification Card -->
                <div class="widget-white-card">
                    <div class="widget-header-with-action">
                        <h3 class="widget-card-title">Skill Verification</h3>
                        <i class="fa-regular fa-circle-question widget-info-icon" title="Skill Verification Levels"></i>
                    </div>

                    <div class="skills-verify-list">
                        <!-- C# -->
                        <div class="skill-verify-item">
                            <div class="skill-verify-info">
                                <span class="skill-name">C#</span>
                                <span class="skill-level">Expert</span>
                            </div>
                            <div class="skill-progress-bar">
                                <div class="skill-progress-fill" style="width: 95%;"></div>
                            </div>
                        </div>

                        <!-- ASP.NET -->
                        <div class="skill-verify-item">
                            <div class="skill-verify-info">
                                <span class="skill-name">ASP.NET</span>
                                <span class="skill-level">Advanced</span>
                            </div>
                            <div class="skill-progress-bar">
                                <div class="skill-progress-fill" style="width: 82%;"></div>
                            </div>
                        </div>

                        <!-- SQL -->
                        <div class="skill-verify-item">
                            <div class="skill-verify-info">
                                <span class="skill-name">SQL</span>
                                <span class="skill-level">Intermediate</span>
                            </div>
                            <div class="skill-progress-bar">
                                <div class="skill-progress-fill" style="width: 60%;"></div>
                            </div>
                        </div>

                        <!-- JavaScript -->
                        <div class="skill-verify-item">
                            <div class="skill-verify-info">
                                <span class="skill-name">JavaScript</span>
                                <span class="skill-level">Intermediate</span>
                            </div>
                            <div class="skill-progress-bar">
                                <div class="skill-progress-fill" style="width: 55%;"></div>
                            </div>
                        </div>

                        <!-- Flutter -->
                        <div class="skill-verify-item">
                            <div class="skill-verify-info">
                                <span class="skill-name">Flutter</span>
                                <span class="skill-level">Beginner</span>
                            </div>
                            <div class="skill-progress-bar">
                                <div class="skill-progress-fill" style="width: 30%;"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Career Insight Card -->
                <div class="career-insight-card">
                    <div class="insight-header-row">
                        <span class="insight-badge-title">CAREER INSIGHT</span>
                        <i class="fa-regular fa-lightbulb insight-bulb-icon"></i>
                    </div>
                    <p class="insight-desc">
                        Improve your SQL skills to increase your match with 12 recommended opportunities.
                    </p>
                    <a href="#" class="btn-take-assessment">Take SQL Assessment</a>
                </div>

                <!-- Suggested Connections Card -->
                <div class="widget-white-card">
                    <h3 class="widget-card-title">Suggested Connections</h3>
                    <div class="connections-list">
                        <!-- Connection 1: Mahek Godvani -->
                        <div class="connection-item">
                            <div class="connection-left">
                                <img src='<%= ResolveUrl("~/assets/images/user-female-logo.png") %>' alt="Mahek Godvani" class="connection-avatar" />
                                <div class="connection-details">
                                    <div class="connection-name">Mahek Godvani</div>
                                    <div class="connection-role">SDE at Google</div>
                                </div>
                            </div>
                            <button type="button" class="btn-connect-action" aria-label="Connect">
                                <i class="fa-solid fa-user-plus"></i>
                            </button>
                        </div>

                        <!-- Connection 2: Ananya Sharma -->
                        <div class="connection-item">
                            <div class="connection-left">
                                <div class="connection-avatar-initials"><i class="fa-solid fa-a"></i></div>
                                <div class="connection-details">
                                    <div class="connection-name">Ananya Sharma</div>
                                    <div class="connection-role">Senior Recruiter</div>
                                </div>
                            </div>
                            <button type="button" class="btn-connect-action" aria-label="Connect">
                                <i class="fa-solid fa-user-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
