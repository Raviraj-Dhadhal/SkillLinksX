<%@ Page Title="Dashboard - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SkillLinksX.User.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Dashboard Header -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-dashboard-container">
        
        <!-- 1. Top Greeting & Profile Completion Header -->
        <div class="dash-greeting-row">
            <div>
                <h1 class="dash-greeting-title">Good morning, <%= Session["UserName"] ?? "Student" %>!</h1>
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

        <!-- =========================================================================
             [DYNAMIC METRIC SUMMARY CARDS]: 4 Columns
             Values are populated from database queries in Dashboard.aspx.cs
             ========================================================================= -->
        <div class="dash-metrics-grid">
            <!-- Card 1: Applications (Queried from 'applications' table) -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Applications</span>
                    <i class="fa-regular fa-clipboard metric-icon"></i>
                </div>
                <div class="metric-value"><%= TotalApplications %></div>
            </div>

            <!-- Card 2: Interviews (Queried from 'interviews' table) -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Interviews</span>
                    <i class="fa-regular fa-calendar-check metric-icon"></i>
                </div>
                <div class="metric-value"><%= TotalInterviews %></div>
            </div>

            <!-- Card 3: Shortlisted (Queried from 'applications' where status = 'Shortlisted') -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Shortlisted</span>
                    <i class="fa-regular fa-star metric-icon"></i>
                </div>
                <div class="metric-value"><%= TotalShortlisted %></div>
            </div>

            <!-- Card 4: Profile Views -->
            <div class="metric-card">
                <div class="metric-card-header">
                    <span class="metric-title">Profile Views</span>
                    <i class="fa-regular fa-eye metric-icon"></i>
                </div>
                <div class="metric-value"><%= ProfileViews %></div>
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
                    <h2 class="ai-match-title"><%= TopAiMatchScore %>% AI Match</h2>
                    <p class="ai-match-sub">
                        Based on your profile skills (<%= StudentSkillsSummary %>), we evaluated top matching opportunities for you.
                    </p>
                    <div class="ai-skills-pill-row">
                        <asp:Repeater ID="rptTopSkillsPills" runat="server">
                            <ItemTemplate>
                                <span class="ai-skill-pill"><%# Container.DataItem %></span>
                            </ItemTemplate>
                        </asp:Repeater>
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
                        <asp:Repeater ID="rptTopMatches" runat="server">
                            <ItemTemplate>
                                <div class="match-job-card">
                                    <div class="match-job-top">
                                        <div class="match-job-icon-box">
                                            <i class="fa-solid fa-laptop-code"></i>
                                        </div>
                                        <span class="badge-role-match" style="font-size:11px; padding:3px 7px; background:#eff6ff; color:#2563eb; border-radius:6px; font-weight:600;">
                                            <%# Eval("AiMatchScore") %>% Match
                                        </span>
                                    </div>
                                    <h4 class="match-job-title"><%# Eval("Title") %></h4>
                                    <div class="match-company-name"><%# Eval("CompanyName") %> &bull; <%# Eval("Location") %></div>
                                    <div class="match-meta-row">
                                        <span><i class="fa-solid fa-money-bill-wave"></i> <%# Eval("SalaryRange") %></span>
                                        <span><i class="fa-solid fa-clock"></i> <%# Eval("JobType") %></span>
                                    </div>
                                    <a href='<%# ResolveUrl("~/User/JobDetails.aspx?id=" + Eval("JobId")) %>' class="btn-match-apply-blue">View &amp; Apply</a>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
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
                                <asp:Repeater ID="rptRecentApplications" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div class="table-company-cell">
                                                    <div class="table-company-icon">
                                                        <i class="fa-regular fa-building"></i>
                                                    </div>
                                                    <span class="table-company-name"><%# Eval("CompanyName") %></span>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="table-role-text"><%# Eval("JobTitle") %></span>
                                            </td>
                                            <td>
                                                <span class='status-pill <%# Eval("StatusClass") %>'><%# Eval("Status") %></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
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
                    <% if (HasUpcomingInterviews) { %>
                    <div class="interview-inner-card">
                        <div class="interview-header-row">
                            <div>
                                <h4 class="interview-company-name"><%= InterviewCompany %></h4>
                                <div class="interview-role-name"><%= InterviewRole %></div>
                            </div>
                            <i class="fa-solid fa-video interview-video-icon"></i>
                        </div>
                        <div class="interview-date-row">
                            <i class="fa-regular fa-calendar"></i> <%= InterviewDateFormatted %>
                        </div>
                        <a href='<%= ResolveUrl("~/User/Notifications.aspx") %>' class="btn-join-meeting">View in Notifications</a>
                    </div>
                    <% } else { %>
                    <div style="padding: 16px 10px; text-align: center; color: #64748b; font-size: 13px;">
                        <i class="fa-regular fa-calendar-xmark" style="font-size: 24px; color: #cbd5e1; display: block; margin-bottom: 6px;"></i>
                        No interviews scheduled right now.
                    </div>
                    <% } %>
                </div>

                <!-- Skill Verification Card -->
                <div class="widget-white-card">
                    <div class="widget-header-with-action">
                        <h3 class="widget-card-title">Skill Verification</h3>
                        <i class="fa-regular fa-circle-question widget-info-icon" title="Skill Verification Levels"></i>
                    </div>

                    <div class="skills-verify-list">
                        <asp:Repeater ID="rptSkillVerification" runat="server">
                            <ItemTemplate>
                                <div class="skill-verify-item">
                                    <div class="skill-verify-info">
                                        <span class="skill-name"><%# Container.DataItem %></span>
                                        <span class="skill-level">Verified</span>
                                    </div>
                                    <div class="skill-progress-bar">
                                        <div class="skill-progress-fill" style="width: 85%;"></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <% if (rptSkillVerification.Items.Count == 0 && string.IsNullOrEmpty(StudentSkillsSummary)) { %>
                        <div style="padding: 10px; text-align: center; color: #94a3b8; font-size: 12.5px;">
                            Add skills in your profile to view verification.
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Career Insight Card -->
                <div class="career-insight-card">
                    <div class="insight-header-row">
                        <span class="insight-badge-title">CAREER INSIGHT</span>
                        <i class="fa-regular fa-lightbulb insight-bulb-icon"></i>
                    </div>
                    <p class="insight-desc">
                        Explore relevant opportunities and tailor your applications to stand out to verified employers.
                    </p>
                    <a href='<%= ResolveUrl("~/User/Jobs.aspx") %>' class="btn-take-assessment">Find Matching Opportunities</a>
                </div>

                <!-- Suggested Connections Card -->
                <div class="widget-white-card">
                    <h3 class="widget-card-title">Suggested Connections</h3>
                    <div class="connections-list">
                        <asp:Repeater ID="rptSuggestedConnections" runat="server">
                            <ItemTemplate>
                                <div class="connection-item">
                                    <div class="connection-left">
                                        <div style="width:36px; height:36px; border-radius:50%; background:#0040A2; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:14px; margin-right:10px;">
                                            <%# Eval("Initial") %>
                                        </div>
                                        <div class="connection-details">
                                            <div class="connection-name"><%# Eval("FullName") %></div>
                                            <div class="connection-role"><%# Eval("Subtitle") %></div>
                                        </div>
                                    </div>
                                    <a href='<%= ResolveUrl("~/User/Networking.aspx") %>' class="btn-connect-action" title="Connect">
                                        <i class="fa-solid fa-user-plus"></i>
                                    </a>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
