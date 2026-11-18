<%@ Page Title="Company Dashboard - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SkillLinksX.Company.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Company Dashboard Specific Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="company-dashboard-container">
        
        <!-- 1. Top Welcome & Profile Completion Banner -->
        <div class="company-welcome-card">
            <div class="welcome-info">
                <h1 class="welcome-title"><%= GreetingText %>, <%= DisplayCompanyName %>!</h1>
                <div class="completion-row">
                    <span>Profile Completion:</span>
                    <span class="completion-percent"><%= ProfileCompletionPercentage %>%</span>
                    <% if (ProfileCompletionPercentage < 100) { %>
                        <span style="font-size:12px; color:#64748b; margin-left:8px;">(Complete your profile to attract top talent)</span>
                    <% } else { %>
                        <span style="font-size:12px; color:#16a34a; font-weight:600; margin-left:8px;"><i class="fa-solid fa-circle-check"></i> 100% Completed</span>
                    <% } %>
                </div>
                <div class="welcome-progress-track">
                    <div class="welcome-progress-fill" style="width: <%= ProfileCompletionPercentage %>%;"></div>
                </div>
            </div>
            <div>
                <a href="<%= ResolveUrl("~/Company/Profile.aspx") %>" class="btn-company-profile-cta">Company Profile</a>
            </div>
        </div>

        <!-- =========================================================================
             [DYNAMIC METRIC CARDS]: Aggregated counts from SQL Server tables
             ========================================================================= -->
        <div class="company-metrics-grid">
            <!-- Active Jobs -->
            <div class="company-metric-card">
                <div class="metric-number"><%= ActiveJobsCount %></div>
                <div class="metric-sub-title">Active Jobs</div>
            </div>

            <!-- Active Internships -->
            <div class="company-metric-card">
                <div class="metric-number"><%= ActiveInternshipsCount %></div>
                <div class="metric-sub-title">Active Internships</div>
            </div>

            <!-- Total Applicants -->
            <div class="company-metric-card">
                <div class="metric-number highlight-green"><%= TotalApplicantsCount %></div>
                <div class="metric-sub-title">Total Applicants</div>
            </div>

            <!-- Shortlisted -->
            <div class="company-metric-card">
                <div class="metric-number"><%= ShortlistedCount %></div>
                <div class="metric-sub-title">Shortlisted</div>
            </div>

            <!-- Interviews -->
            <div class="company-metric-card">
                <div class="metric-number"><%= InterviewsCount %></div>
                <div class="metric-sub-title">Interviews</div>
            </div>

            <!-- Hired -->
            <div class="company-metric-card">
                <div class="metric-number highlight-green"><%= HiredCount %></div>
                <div class="metric-sub-title">Hired / Selected</div>
            </div>
        </div>

        <!-- 3. Bottom Grid: Recruitment Pipeline + Quick Actions -->
        <div class="company-bottom-grid">
            
            <!-- Recruitment Pipeline Card -->
            <div class="company-widget-card">
                <h2 class="company-widget-title">Recruitment Pipeline</h2>
                
                <div class="pipeline-track-wrapper">
                    <!-- Step 1: Applications -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-grey"><%= TotalApplicantsCount %></div>
                        <span class="pipeline-label">Applications</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 2: Review -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-blue-soft"><%= ReviewCount %></div>
                        <span class="pipeline-label">Review</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 3: Shortlisted -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-purple-soft"><%= ShortlistedCount %></div>
                        <span class="pipeline-label">Shortlisted</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 4: Interview -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-green-soft"><%= InterviewsCount %></div>
                        <span class="pipeline-label">Interview</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 5: Hired -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-blue-solid"><%= HiredCount %></div>
                        <span class="pipeline-label">Hired</span>
                    </div>
                </div>
            </div>

            <!-- Quick Actions Card (2x2 Grid) -->
            <div class="company-widget-card">
                <h2 class="company-widget-title">Quick Actions</h2>
                
                <div class="quick-actions-grid">
                    <!-- Action 1: Post a Job -->
                    <a href="<%= ResolveUrl("~/Company/PostJob.aspx") %>" class="quick-action-tile">
                        <i class="fa-solid fa-briefcase quick-action-icon"></i>
                        <span class="quick-action-label">Post a Job</span>
                    </a>

                    <!-- Action 2: Post Internship -->
                    <a href="<%= ResolveUrl("~/Company/PostJob.aspx") %>" class="quick-action-tile">
                        <i class="fa-solid fa-graduation-cap quick-action-icon"></i>
                        <span class="quick-action-label">Post<br />Internship</span>
                    </a>

                    <!-- Action 3: Review Applicants / Candidates -->
                    <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="quick-action-tile">
                        <i class="fa-solid fa-user-group quick-action-icon color-teal"></i>
                        <span class="quick-action-label">Review<br />Applicants</span>
                    </a>

                    <!-- Action 4: Schedule Interview -->
                    <a href="<%= ResolveUrl("~/Company/Interviews.aspx") %>" class="quick-action-tile">
                        <i class="fa-regular fa-calendar-check quick-action-icon"></i>
                        <span class="quick-action-label">Schedule<br />Interview</span>
                    </a>
                </div>
            </div>

        </div>

    </div>
</asp:Content>
