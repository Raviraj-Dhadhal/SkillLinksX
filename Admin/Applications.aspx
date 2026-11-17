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
                <div class="stat-num-val">
                    <asp:Literal ID="litTotalApps" runat="server">12,450</asp:Literal> 
                    <span class="stat-trend-green"><i class="fa-solid fa-arrow-up"></i> 15%</span>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">New Applications</span>
                </div>
                <div class="stat-num-val color-blue">
                    <asp:Literal ID="litNewApps" runat="server">842</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Under Review</span>
                </div>
                <div class="stat-num-val">
                    <asp:Literal ID="litUnderReview" runat="server">2,130</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Shortlisted</span>
                </div>
                <div class="stat-num-val color-green">
                    <asp:Literal ID="litShortlisted" runat="server">1,450</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Interviews</span>
                </div>
                <div class="stat-num-val color-orange">
                    <asp:Literal ID="litInterviews" runat="server">420</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Hired</span>
                </div>
                <div class="stat-num-val color-teal">
                    <asp:Literal ID="litHired" runat="server">156</asp:Literal>
                </div>
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
                            <asp:Repeater ID="rptAdminApplications" runat="server">
                                <ItemTemplate>
                                    <tr class="app-row"
                                        data-student-name='<%# Eval("StudentName") %>'
                                        data-applied-for='<%# Eval("OpportunityTitle") + " at " + Eval("CompanyName") %>'
                                        data-match='<%# Eval("MatchScore") + "%" %>'
                                        data-skills-match='<%# Eval("MatchScore") + "%" %>'
                                        data-exp-match="85%"
                                        data-education='<%# Eval("Degree") %>'
                                        data-college='<%# Eval("College") %>'
                                        data-skills='<%# Eval("Skills") %>'
                                        data-status='<%# Eval("Status") %>'
                                        data-date='<%# Eval("AppliedDateFormatted") %>'>
                                        <td>
                                            <div class="student-cell-flex">
                                                <div class="student-avatar-wrap">
                                                    <div style="width:36px; height:36px; border-radius:50%; background:#0040A2; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:14px;">
                                                        <%# Eval("StudentName").ToString().Length > 0 ? Eval("StudentName").ToString().Substring(0, 1).ToUpper() : "S" %>
                                                    </div>
                                                </div>
                                                <div>
                                                    <div class="student-name-text"><%# Eval("StudentName") %></div>
                                                    <div class="student-sub-email">Applied <%# Eval("AppliedDateFormatted") %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="opp-title-bold"><%# Eval("OpportunityTitle") %></div>
                                            <div class="opp-sub-meta"><%# Eval("CompanyName") %></div>
                                        </td>
                                        <td>
                                            <div class="opp-sub-meta"><%# Eval("OppType") %></div>
                                            <div class="opp-sub-meta"><%# Eval("Location") %></div>
                                        </td>
                                        <td><span class="match-score-pill"><%# Eval("MatchScore") %>%</span></td>
                                        <td>
                                            <span class='badge-status-<%# Eval("Status").ToString().ToLower().Replace(" ", "-") %>'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-dropdown-wrap">
                                                <button type="button" class="btn-more-dots" onclick="event.stopPropagation(); this.nextElementSibling.classList.toggle('show');">
                                                    <i class="fa-solid fa-ellipsis-vertical"></i>
                                                </button>
                                                <div class="action-menu-dropdown">
                                                    <a href='<%= ResolveUrl("~/User/Messages.aspx") %>' class="action-menu-item" onclick="event.stopPropagation();">
                                                        <i class="fa-regular fa-message"></i> Message
                                                    </a>
                                                    <a href='<%= ResolveUrl("~/User/Profile.aspx") %>' class="action-menu-item" onclick="event.stopPropagation();">
                                                        <i class="fa-regular fa-user"></i> View Profile
                                                    </a>
                                                    <a href="javascript:void(0);" class="action-menu-item danger" onclick="event.stopPropagation(); confirm('Reject candidate?');">
                                                        <i class="fa-solid fa-ban"></i> Reject
                                                    </a>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Right Sidebar Column: Candidate Detail Profile & Timeline Card -->
            <div class="admin-details-sidebar-card" id="appDetailsCard">
                <% if (HasSelectedApp) { %>
                <div class="details-card-header flex-between" style="border:none; padding-bottom:0;">
                    <div></div>
                    <button type="button" class="btn-close-details" id="btnCloseAppDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <div class="student-profile-center-block" style="padding-top:0;">
                    <div class="student-large-avatar-box">
                        <div style="width:72px; height:72px; border-radius:50%; background:#0040A2; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:26px; margin:0 auto;">
                            <%= !string.IsNullOrEmpty(SelectedStudentName) ? SelectedStudentName.Substring(0, 1).ToUpper() : "S" %>
                        </div>
                    </div>
                    <h4 class="sd-student-name" id="adName"><%= SelectedStudentName %></h4>
                    <div class="sd-student-email" id="adAppliedFor">Applying for <%= SelectedAppliedRole %> at <%= SelectedCompanyName %></div>
                    <div class="ad-resume-portfolio-row">
                        <a href="javascript:void(0);" class="btn-ad-pill-outline"><i class="fa-regular fa-file-lines"></i> Resume</a>
                        <a href='<%= ResolveUrl("~/User/Portfolio.aspx") %>' class="btn-ad-pill-outline"><i class="fa-solid fa-globe"></i> Portfolio</a>
                    </div>
                </div>

                <!-- AI Match Analysis Card Box -->
                <div class="ad-ai-match-box">
                    <div class="ad-ai-header flex-between">
                        <span class="ad-ai-title"><i class="fa-solid fa-sparkles"></i> AI Match Analysis</span>
                        <span class="ad-ai-pct" id="adMatchPct"><%= SelectedMatchPct %>%</span>
                    </div>
                    <div class="ad-match-bar-group">
                        <div class="ad-match-bar-label flex-between">
                            <span>Skills Match</span>
                            <span id="adSkillsMatchPct"><%= SelectedMatchPct %>%</span>
                        </div>
                        <div class="ad-bar-track"><div class="ad-bar-fill fill-green" id="adSkillsBar" style="width: <%= SelectedMatchPct %>%;"></div></div>
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
                            <div class="sd-bold-txt" id="adDegree"><%= SelectedEducation %></div>
                            <div class="sd-sub-txt" id="adCollege"><%= SelectedCollege %></div>
                        </div>
                    </div>
                    <div class="sd-skills-chips-row" style="margin-top:10px;" id="adSkills">
                        <% if (SelectedSkills != null && SelectedSkills.Count > 0) { 
                               foreach (var sk in SelectedSkills) { %>
                                   <span class="sd-skill-pill"><%= sk %></span>
                        <%     } 
                           } else { %>
                               <span class="sd-skill-pill" style="color:#64748B;">No skills specified</span>
                        <% } %>
                    </div>
                </div>

                <!-- Application Timeline -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">APPLICATION TIMELINE</span>
                    <div class="app-status-timeline" style="padding-left:14px;">
                        <div class="timeline-step active">
                            <div class="step-dot" style="background:#0040A2;"></div>
                            <div class="step-info">
                                <div class="step-title" id="adTimelineStatus"><%= SelectedTimelineStatus %></div>
                                <div class="step-date">Current Status &bull; Updated in Database</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions Stack -->
                <div class="ad-actions-2btn-row">
                    <a href='<%= ResolveUrl("~/User/Messages.aspx") %>' class="btn-ad-message" style="text-align:center; text-decoration:none;">
                        Message Student
                    </a>
                    <a href='<%= ResolveUrl("~/User/Profile.aspx") %>' class="btn-ad-fullprofile" style="text-align:center; text-decoration:none;">
                        Full Profile
                    </a>
                </div>
                <% } else { %>
                <div style="padding: 40px 20px; text-align: center; color: #64748B;">
                    <i class="fa-regular fa-folder-open" style="font-size: 40px; margin-bottom: 12px; color: #CBD5E1;"></i>
                    <h4 style="font-size: 16px; font-weight: 700; color: #1E293B; margin-bottom: 6px;">No Applications Yet</h4>
                    <p style="font-size: 13px; color: #64748B; margin: 0;">When candidates apply to jobs or internships, their application details and AI match score will appear here.</p>
                </div>
                <% } %>
            </div>

        </div>

    </div>
</asp:Content>
