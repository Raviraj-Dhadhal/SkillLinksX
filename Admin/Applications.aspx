<%@ Page Title="Applications Management - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Applications.aspx.cs" Inherits="SkillLinksX.Admin.Applications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Applications Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Applications Management</h1>
                <p class="admin-page-main-sub">Monitor and manage applications across the SkillLinkX platform.</p>
            </div>
        </div>

        <!-- 6 Summary Metrics Cards -->
        <div class="admin-metrics-6grid">
            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Total Applications</span>
                </div>
                <div class="stat-num-val">12,450 <span class="stat-trend-green"><i class="fa-solid fa-arrow-up"></i> 15%</span></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">New Applications</span>
                </div>
                <div class="stat-num-val color-blue">842</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Under Review</span>
                </div>
                <div class="stat-num-val">2,130</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Shortlisted</span>
                </div>
                <div class="stat-num-val color-green">1,450</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Interviews</span>
                </div>
                <div class="stat-num-val color-orange">420</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Hired</span>
                </div>
                <div class="stat-num-val color-teal">156</div>
            </div>
        </div>

        <!-- Application Funnel Card -->
        <div class="admin-funnel-card">
            <h3 class="funnel-card-title">Application Funnel</h3>
            <div class="funnel-steps-row">
                <!-- Step 1: Applied -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-blue-light">100%</div>
                    <div class="funnel-step-name">Applied</div>
                    <div class="funnel-step-val">12.4k</div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 2: Under Review -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-purple-light">45%</div>
                    <div class="funnel-step-name">Under Review</div>
                    <div class="funnel-step-val">5.6k</div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 3: Shortlisted -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-green-light">11%</div>
                    <div class="funnel-step-name">Shortlisted</div>
                    <div class="funnel-step-val">1.4k</div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 4: Interview -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-gray-light">3%</div>
                    <div class="funnel-step-name">Interview</div>
                    <div class="funnel-step-val">420</div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 5: Selected -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-teal-light">1.2%</div>
                    <div class="funnel-step-name">Selected</div>
                    <div class="funnel-step-val">156</div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 6: Rejected -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-red-light">85%</div>
                    <div class="funnel-step-name">Rejected</div>
                    <div class="funnel-step-val">10.5k</div>
                </div>
            </div>
        </div>

        <!-- Filter Bar Row -->
        <div class="admin-filter-bar-card">
            <div class="admin-search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="searchAppInput" placeholder="Search jobs, internships, people..." />
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterAppCompany">
                    <option value="">Company</option>
                    <option value="TechCorp India">TechCorp India</option>
                    <option value="Global Analytics">Global Analytics</option>
                    <option value="CreativeMinds">CreativeMinds</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterAppType">
                    <option value="">Type</option>
                    <option value="Job">Job</option>
                    <option value="Internship">Internship</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterAppStatus">
                    <option value="">Status</option>
                    <option value="Under Review">Under Review</option>
                    <option value="Shortlisted">Shortlisted</option>
                    <option value="Selected">Selected</option>
                    <option value="Rejected">Rejected</option>
                </select>
            </div>

            <button type="button" class="btn-filter-apply" id="btnApplyAppFilters">Apply Filters</button>
            <button type="button" class="btn-filter-clear" id="btnClearAppFilters">Clear</button>
        </div>

        <!-- 2-Column Split: Left Applications Table + Right Candidate Summary Details Panel -->
        <div class="admin-workspace-split-grid">

            <!-- Left Main Column (Applications Table) -->
            <div class="admin-table-card">
                <div class="admin-table-responsive">
                    <table class="admin-data-table" id="adminAppsTable">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Opportunity</th>
                                <th>Type &amp; Loc</th>
                                <th>Match</th>
                                <th>Status</th>
                                <th style="width: 40px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- App 1: Raviraj Dhadhal (Selected by default) -->
                            <tr class="app-row selected"
                                data-student-name="Raviraj Dhadhal"
                                data-applied-for="Frontend Developer at TechCorp India"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-male-logo.png") %>'
                                data-match="94%"
                                data-skills-match="98%"
                                data-exp-match="85%"
                                data-education="B.Tech Computer Science"
                                data-college="IIT Bombay &bull; 2019 - 2023"
                                data-skills="React,TypeScript,Tailwind CSS,Redux"
                                data-status="Under Review"
                                data-date="Oct 12, 2026">
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-wrap">
                                            <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj" class="student-avatar-img" />
                                        </div>
                                        <div>
                                            <div class="student-name-text">Raviraj Dhadhal</div>
                                            <div class="student-sub-email">Applied Oct 12</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="opp-title-bold">Frontend Developer</div>
                                    <div class="opp-sub-meta">TechCorp India</div>
                                </td>
                                <td>
                                    <div class="opp-sub-meta">Job</div>
                                    <div class="opp-sub-meta">Bengaluru</div>
                                </td>
                                <td><span class="match-score-pill">94%</span></td>
                                <td>
                                    <div class="action-dropdown-wrap">
                                        <button type="button" class="btn-more-dots" onclick="event.stopPropagation(); this.nextElementSibling.classList.toggle('show');">
                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                        </button>
                                        <div class="action-menu-dropdown">
                                            <a href="<%= ResolveUrl("~/User/Messages.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-message"></i> Message
                                            </a>
                                            <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-user"></i> View Profile
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item" onclick="event.stopPropagation(); alert('Downloading application PDF...');">
                                                <i class="fa-solid fa-download"></i> Download PDF
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item danger" onclick="event.stopPropagation(); confirm('Reject candidate?');">
                                                <i class="fa-solid fa-ban"></i> Reject
                                            </a>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <!-- App 2: Priya Sharma -->
                            <tr class="app-row"
                                data-student-name="Priya Sharma"
                                data-applied-for="Data Science Intern at Global Analytics"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-female-logo.png") %>'
                                data-match="88%"
                                data-skills-match="90%"
                                data-exp-match="80%"
                                data-education="MCA"
                                data-college="NIT Trichy &bull; 2021 - 2024"
                                data-skills="Python,SQL,Pandas,Scikit-Learn"
                                data-status="Shortlisted"
                                data-date="Oct 10, 2026">
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-init">PS</div>
                                        <div>
                                            <div class="student-name-text">Priya Sharma</div>
                                            <div class="student-sub-email">Applied Oct 10</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="opp-title-bold">Data Science Intern</div>
                                    <div class="opp-sub-meta">Global Analytics</div>
                                </td>
                                <td>
                                    <div class="opp-sub-meta">Internship</div>
                                    <div class="opp-sub-meta">Pune</div>
                                </td>
                                <td><span class="match-score-pill">88%</span></td>
                                <td>
                                    <div class="action-dropdown-wrap">
                                        <button type="button" class="btn-more-dots" onclick="event.stopPropagation(); this.nextElementSibling.classList.toggle('show');">
                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                        </button>
                                        <div class="action-menu-dropdown">
                                            <a href="<%= ResolveUrl("~/User/Messages.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-message"></i> Message
                                            </a>
                                            <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-user"></i> View Profile
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item" onclick="event.stopPropagation(); alert('Downloading application PDF...');">
                                                <i class="fa-solid fa-download"></i> Download PDF
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item danger" onclick="event.stopPropagation(); confirm('Reject candidate?');">
                                                <i class="fa-solid fa-ban"></i> Reject
                                            </a>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <!-- App 3: Neha Gupta -->
                            <tr class="app-row"
                                data-student-name="Neha Gupta"
                                data-applied-for="UX Designer at CreativeMinds"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-female-logo.png") %>'
                                data-match="65%"
                                data-skills-match="70%"
                                data-exp-match="60%"
                                data-education="B.Des Interaction Design"
                                data-college="NID Ahmedabad &bull; 2020 - 2024"
                                data-skills="Figma,Wireframing,User Research"
                                data-status="Rejected"
                                data-date="Oct 05, 2026">
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-wrap">
                                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Neha" class="student-avatar-img" />
                                        </div>
                                        <div>
                                            <div class="student-name-text">Neha Gupta</div>
                                            <div class="student-sub-email">Applied Oct 05</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="opp-title-bold">UX Designer</div>
                                    <div class="opp-sub-meta">CreativeMinds</div>
                                </td>
                                <td>
                                    <div class="opp-sub-meta">Job</div>
                                    <div class="opp-sub-meta">New Delhi</div>
                                </td>
                                <td><span class="match-score-pill score-red">65%</span></td>
                                <td><span class="badge-status-rejected">Rejected</span></td>
                                <td>
                                    <div class="action-dropdown-wrap">
                                        <button type="button" class="btn-more-dots" onclick="event.stopPropagation(); this.nextElementSibling.classList.toggle('show');">
                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                        </button>
                                        <div class="action-menu-dropdown">
                                            <a href="<%= ResolveUrl("~/User/Messages.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-message"></i> Message
                                            </a>
                                            <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-user"></i> View Profile
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item" onclick="event.stopPropagation(); alert('Downloading application PDF...');">
                                                <i class="fa-solid fa-download"></i> Download PDF
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item danger" onclick="event.stopPropagation(); confirm('Reject candidate?');">
                                                <i class="fa-solid fa-ban"></i> Reject
                                            </a>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <!-- App 4: Rohan Kumar -->
                            <tr class="app-row"
                                data-student-name="Rohan Kumar"
                                data-applied-for="Backend Engineer at TechCorp India"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-male-logo.png") %>'
                                data-match="98%"
                                data-skills-match="99%"
                                data-exp-match="95%"
                                data-education="B.Tech Computer Science"
                                data-college="IIT Delhi &bull; 2018 - 2022"
                                data-skills="Go,Kubernetes,Docker,gRPC"
                                data-status="Selected"
                                data-date="Sep 28, 2026">
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-init bg-navy">RK</div>
                                        <div>
                                            <div class="student-name-text">Rohan Kumar</div>
                                            <div class="student-sub-email">Applied Sep 28</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="opp-title-bold">Backend Engineer</div>
                                    <div class="opp-sub-meta">TechCorp India</div>
                                </td>
                                <td>
                                    <div class="opp-sub-meta">Job</div>
                                    <div class="opp-sub-meta">Bengaluru</div>
                                </td>
                                <td><span class="match-score-pill">98%</span></td>
                                <td><span class="badge-status-selected">Selected</span></td>
                                <td>
                                    <div class="action-dropdown-wrap">
                                        <button type="button" class="btn-more-dots" onclick="event.stopPropagation(); this.nextElementSibling.classList.toggle('show');">
                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                        </button>
                                        <div class="action-menu-dropdown">
                                            <a href="<%= ResolveUrl("~/User/Messages.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-message"></i> Message
                                            </a>
                                            <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="action-menu-item" onclick="event.stopPropagation();">
                                                <i class="fa-regular fa-user"></i> View Profile
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item" onclick="event.stopPropagation(); alert('Downloading application PDF...');">
                                                <i class="fa-solid fa-download"></i> Download PDF
                                            </a>
                                            <a href="javascript:void(0);" class="action-menu-item danger" onclick="event.stopPropagation(); confirm('Reject candidate?');">
                                                <i class="fa-solid fa-ban"></i> Reject
                                            </a>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Right Sidebar Column: Candidate Detail Profile & Timeline Card -->
            <div class="admin-details-sidebar-card" id="appDetailsCard">
                <div class="details-card-header flex-between" style="border:none; padding-bottom:0;">
                    <div></div>
                    <button type="button" class="btn-close-details" id="btnCloseAppDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <div class="student-profile-center-block" style="padding-top:0;">
                    <div class="student-large-avatar-box">
                        <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Candidate" id="adAvatar" class="student-large-avatar-img" />
                    </div>
                    <h4 class="sd-student-name" id="adName">Raviraj Dhadhal</h4>
                    <div class="sd-student-email" id="adAppliedFor">Applying for Frontend Developer at TechCorp India</div>
                    <div class="ad-resume-portfolio-row">
                        <a href="javascript:void(0);" class="btn-ad-pill-outline"><i class="fa-regular fa-file-lines"></i> Resume</a>
                        <a href="javascript:void(0);" class="btn-ad-pill-outline"><i class="fa-solid fa-globe"></i> Portfolio</a>
                    </div>
                </div>

                <!-- AI Match Analysis Card Box -->
                <div class="ad-ai-match-box">
                    <div class="ad-ai-header flex-between">
                        <span class="ad-ai-title"><i class="fa-solid fa-sparkles"></i> AI Match Analysis</span>
                        <span class="ad-ai-pct" id="adMatchPct">94%</span>
                    </div>
                    <div class="ad-match-bar-group">
                        <div class="ad-match-bar-label flex-between">
                            <span>Skills Match</span>
                            <span id="adSkillsMatchPct">98%</span>
                        </div>
                        <div class="ad-bar-track"><div class="ad-bar-fill fill-green" id="adSkillsBar" style="width: 98%;"></div></div>
                    </div>
                    <div class="ad-match-bar-group" style="margin-top:8px;">
                        <div class="ad-match-bar-label flex-between">
                            <span>Experience Match</span>
                            <span id="adExpMatchPct">85%</span>
                        </div>
                        <div class="ad-bar-track"><div class="ad-bar-fill fill-blue" id="adExpBar" style="width: 85%;"></div></div>
                    </div>
                </div>

                <!-- Education & Skills -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">EDUCATION &amp; SKILLS</span>
                    <div class="ad-edu-icon-row">
                        <i class="fa-solid fa-graduation-cap"></i>
                        <div>
                            <div class="sd-bold-txt" id="adDegree">B.Tech Computer Science</div>
                            <div class="sd-sub-txt" id="adCollege">IIT Bombay &bull; 2019 - 2023</div>
                        </div>
                    </div>
                    <div class="sd-skills-chips-row" style="margin-top:10px;" id="adSkills">
                        <span class="sd-skill-pill">React</span>
                        <span class="sd-skill-pill">TypeScript</span>
                        <span class="sd-skill-pill">Tailwind CSS</span>
                        <span class="sd-skill-pill">Redux</span>
                    </div>
                </div>

                <!-- Application Timeline -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">APPLICATION TIMELINE</span>
                    <div class="app-status-timeline" style="padding-left:14px;">
                        <div class="timeline-step active">
                            <div class="step-dot" style="background:#0040A2;"></div>
                            <div class="step-info">
                                <div class="step-title" id="adTimelineStatus">Under Review</div>
                                <div class="step-date">Oct 12, 2026 &bull; Moved by System</div>
                            </div>
                        </div>
                        <div class="timeline-step done">
                            <div class="step-dot" style="background:#CBD5E1;"></div>
                            <div class="step-info">
                                <div class="step-title">Applied</div>
                                <div class="step-date">Oct 10, 2026 &bull; Submitted via Portal</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Update Status Dropdown -->
                <div class="ad-status-dropdown-wrap">
                    <label class="sd-section-lbl">Update Status</label>
                    <select class="form-control-select" id="ddlUpdateAppStatus">
                        <option value="Under Review" selected="selected">Under Review</option>
                        <option value="Shortlisted">Shortlisted</option>
                        <option value="Interview">Interview</option>
                        <option value="Selected">Selected</option>
                        <option value="Rejected">Rejected</option>
                    </select>
                </div>

                <!-- Actions Stack -->
                <div class="ad-actions-2btn-row">
                    <a href="<%= ResolveUrl("~/User/Messages.aspx") %>" class="btn-ad-message" style="text-align:center; text-decoration:none;">
                        Message Student
                    </a>
                    <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="btn-ad-fullprofile" style="text-align:center; text-decoration:none;">
                        Full Profile
                    </a>
                </div>
            </div>

        </div>

    </div>
</asp:Content>
