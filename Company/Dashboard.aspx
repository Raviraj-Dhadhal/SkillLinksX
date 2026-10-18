<%@ Page Title="Company Dashboard - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SkillLinksX.Company.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Company Dashboard Specific Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="company-dashboard-container">
        
        <!-- 1. Top Welcome & Profile Completion Banner -->
        <div class="company-welcome-card">
            <div class="welcome-info">
                <h1 class="welcome-title">Good morning, TechNova!</h1>
                <div class="completion-row">
                    <span>Profile Completion:</span>
                    <span class="completion-percent">85%</span>
                </div>
                <div class="welcome-progress-track">
                    <div class="welcome-progress-fill" style="width: 85%;"></div>
                </div>
            </div>
            <div>
                <a href="<%= ResolveUrl("~/Company/Profile.aspx") %>" class="btn-company-profile-cta">Company Profile</a>
            </div>
        </div>

        <!-- 2. 6-Column Metric Cards Grid -->
        <div class="company-metrics-grid">
            <!-- Active Jobs -->
            <div class="company-metric-card">
                <div class="metric-number">12</div>
                <div class="metric-sub-title">Active Jobs</div>
            </div>

            <!-- Active Internships -->
            <div class="company-metric-card">
                <div class="metric-number">8</div>
                <div class="metric-sub-title">Active Internships</div>
            </div>

            <!-- Total Applicants -->
            <div class="company-metric-card">
                <div class="metric-number highlight-green">458</div>
                <div class="metric-sub-title">Total Applicants</div>
            </div>

            <!-- Shortlisted -->
            <div class="company-metric-card">
                <div class="metric-number">42</div>
                <div class="metric-sub-title">Shortlisted</div>
            </div>

            <!-- Interviews -->
            <div class="company-metric-card">
                <div class="metric-number">15</div>
                <div class="metric-sub-title">Interviews</div>
            </div>

            <!-- Hired -->
            <div class="company-metric-card">
                <div class="metric-number highlight-green">6</div>
                <div class="metric-sub-title">Hired</div>
            </div>
        </div>

        <!-- 3. Bottom Grid: Recruitment Pipeline + Quick Actions -->
        <div class="company-bottom-grid">
            
            <!-- Recruitment Pipeline Card -->
            <div class="company-widget-card">
                <h2 class="company-widget-title">Recruitment Pipeline</h2>
                
                <div class="pipeline-track-wrapper">
                    <!-- Step 1: Applications (458) -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-grey">458</div>
                        <span class="pipeline-label">Applications</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 2: Review (112) -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-blue-soft">112</div>
                        <span class="pipeline-label">Review</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 3: Shortlisted (42) -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-purple-soft">42</div>
                        <span class="pipeline-label">Shortlisted</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 4: Interview (15) -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-green-soft">15</div>
                        <span class="pipeline-label">Interview</span>
                    </div>

                    <div class="pipeline-connector-line"></div>

                    <!-- Step 5: Hired (6) -->
                    <div class="pipeline-step">
                        <div class="pipeline-circle c-blue-solid">6</div>
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
                    <a href="<%= ResolveUrl("~/Company/PostInternship.aspx") %>" class="quick-action-tile">
                        <i class="fa-solid fa-graduation-cap quick-action-icon"></i>
                        <span class="quick-action-label">Post<br />Internship</span>
                    </a>

                    <!-- Action 3: Find Candidates -->
                    <a href="<%= ResolveUrl("~/Company/Candidates.aspx") %>" class="quick-action-tile">
                        <i class="fa-solid fa-user-gear quick-action-icon color-teal"></i>
                        <span class="quick-action-label">Find<br />Candidates</span>
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
