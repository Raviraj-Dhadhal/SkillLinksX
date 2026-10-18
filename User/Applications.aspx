<%@ Page Title="My Applications - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Applications.aspx.cs" Inherits="SkillLinksX.User.Applications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Applications Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-apps-page-container">

        <!-- Page Header -->
        <div class="apps-page-header">
            <h1 class="apps-page-title">My Applications</h1>
            <p class="apps-page-sub">Track and manage all your job and internship applications in one place.</p>
        </div>

        <!-- 5 Metric Tiles Row -->
        <div class="apps-metrics-grid">
            <!-- 1. Total Applications -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Total Applications</span>
                <span class="app-metric-val">24</span>
            </div>
            <!-- 2. Under Review -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Under Review</span>
                <span class="app-metric-val color-blue">8</span>
            </div>
            <!-- 3. Shortlisted -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Shortlisted</span>
                <span class="app-metric-val color-green">4</span>
            </div>
            <!-- 4. Interviews -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Interviews</span>
                <span class="app-metric-val color-orange">2</span>
            </div>
            <!-- 5. Selected -->
            <div class="app-metric-tile">
                <span class="app-metric-label">Selected</span>
                <span class="app-metric-val color-teal">1</span>
            </div>
        </div>

        <!-- Main Workspace: Left Applications List + Right Side Panels -->
        <div class="apps-layout-grid">

            <!-- Left Main Column -->
            <div class="apps-main-column">

                <!-- Filter Pills Navigation Tabs -->
                <div class="apps-filter-tabs-wrapper">
                    <button type="button" class="app-tab-pill active">All</button>
                    <button type="button" class="app-tab-pill">Jobs</button>
                    <button type="button" class="app-tab-pill">Internships</button>
                    <button type="button" class="app-tab-pill">Under Review</button>
                    <button type="button" class="app-tab-pill">Shortlisted</button>
                    <button type="button" class="app-tab-pill">Interview</button>
                    <button type="button" class="app-tab-pill">Selected</button>
                    <button type="button" class="app-tab-pill">Rejected</button>
                </div>

                <!-- Applications List Group -->
                <div class="apps-list-container">

                    <!-- App 1: Software Development Intern at Razorpay -->
                    <div class="app-row-card">
                        <div class="app-row-left">
                            <div class="app-company-logo">
                                <img src="<%= ResolveUrl("~/assets/images/razorpay-logo.svg") %>" alt="Razorpay" class="app-logo-img" />
                            </div>
                            <div class="app-details-stack">
                                <h3 class="app-role-name">Software Development Intern</h3>
                                <div class="app-meta-line">
                                    <span class="app-comp">Razorpay</span> &bull; 
                                    <span class="app-loc">Ahmedabad</span> &bull; 
                                    <span class="app-time">Applied 2 days ago</span>
                                </div>
                                <div class="app-type-badge-wrap">
                                    <span class="app-type-pill">Internship</span>
                                </div>
                            </div>
                        </div>
                        <div class="app-row-right">
                            <span class="app-status-badge badge-under-review">&bull; Under Review</span>
                        </div>
                    </div>

                    <!-- App 2: Product Management Intern at Flipkart -->
                    <div class="app-row-card">
                        <div class="app-row-left">
                            <div class="app-company-logo">
                                <img src="<%= ResolveUrl("~/assets/images/technova-avatar.svg") %>" alt="Flipkart" class="app-logo-img" />
                            </div>
                            <div class="app-details-stack">
                                <h3 class="app-role-name">Product Management Intern</h3>
                                <div class="app-meta-line">
                                    <span class="app-comp">Flipkart</span> &bull; 
                                    <span class="app-loc">Bengaluru</span> &bull; 
                                    <span class="app-time">Applied 5 days ago</span>
                                </div>
                                <div class="app-type-badge-wrap">
                                    <span class="app-type-pill">Internship</span>
                                </div>
                            </div>
                        </div>
                        <div class="app-row-right">
                            <span class="app-status-badge badge-shortlisted">&bull; Shortlisted</span>
                        </div>
                    </div>

                    <!-- App 3: Backend Engineering Intern (Go) at Zomato (Selected / Active) -->
                    <div class="app-row-card selected-app-row">
                        <div class="app-row-left">
                            <div class="app-company-logo">
                                <img src="<%= ResolveUrl("~/assets/images/zomato-logo.svg") %>" alt="Zomato" class="app-logo-img" />
                            </div>
                            <div class="app-details-stack">
                                <h3 class="app-role-name">Backend Engineering Intern (Go)</h3>
                                <div class="app-meta-line">
                                    <span class="app-comp">Zomato</span> &bull; 
                                    <span class="app-loc">Gurugram</span> &bull; 
                                    <span class="app-time">Applied 1 week ago</span>
                                </div>
                                <div class="app-type-badge-wrap">
                                    <span class="app-type-pill">Internship</span>
                                </div>
                            </div>
                        </div>
                        <div class="app-row-right flex-actions">
                            <span class="app-status-badge badge-interview-sched">&bull; Interview Scheduled</span>
                            <a href="<%= ResolveUrl("~/User/InternshipDetails.aspx") %>" class="btn-app-view-details">View Details</a>
                        </div>
                    </div>

                    <!-- App 4: Software Developer at TechFlow Mumbai -->
                    <div class="app-row-card">
                        <div class="app-row-left">
                            <div class="app-company-logo">
                                <img src="<%= ResolveUrl("~/assets/images/techflow-logo.svg") %>" alt="TechFlow" class="app-logo-img" />
                            </div>
                            <div class="app-details-stack">
                                <h3 class="app-role-name">Software Developer</h3>
                                <div class="app-meta-line">
                                    <span class="app-comp">TechFlow Mumbai</span> &bull; 
                                    <span class="app-loc">Mumbai</span> &bull; 
                                    <span class="app-time">Applied 2 weeks ago</span>
                                </div>
                                <div class="app-type-badge-wrap">
                                    <span class="app-type-pill">Job</span>
                                </div>
                            </div>
                        </div>
                        <div class="app-row-right">
                            <span class="app-status-badge badge-selected">&bull; Selected</span>
                        </div>
                    </div>

                </div>

            </div>

            <!-- Right Sidebar Column (Upcoming Interviews + Application Details) -->
            <div class="apps-sidebar-column">

                <!-- 1. Upcoming Interview Card -->
                <div class="apps-side-card">
                    <div class="side-card-top-title">
                        <i class="fa-regular fa-calendar-check text-primary"></i> Upcoming Interview
                    </div>
                    <div class="interview-preview-box">
                        <h4 class="interview-round-name">Zomato Technical Round</h4>
                        <div class="interview-schedule-line">
                            <i class="fa-regular fa-calendar"></i> Oct 28, 2:00 PM
                        </div>
                        <div class="interview-schedule-line">
                            <i class="fa-solid fa-video"></i> Video Call
                        </div>
                        <a href="https://meet.google.com" target="_blank" rel="noopener noreferrer" class="btn-join-round-primary">
                            Join Interview
                        </a>
                    </div>
                </div>

                <!-- 2. Application Details Card -->
                <div class="apps-side-card">
                    <h3 class="side-card-top-title">Application Details</h3>
                    <div class="app-selected-summary text-center">
                        <div class="app-details-avatar-circle">
                            <img src="<%= ResolveUrl("~/assets/images/zomato-logo.svg") %>" alt="Zomato" class="avatar-circle-img" />
                        </div>
                        <h4 class="app-selected-role">Backend Engineering Intern (Go)</h4>
                        <div class="app-selected-company">Zomato</div>
                        <div class="app-selected-badge-wrap">
                            <span class="badge-interview-sched">&bull; Interview Scheduled</span>
                        </div>
                    </div>

                    <!-- Status Timeline -->
                    <div class="app-timeline-block">
                        <div class="timeline-heading-txt">STATUS TIMELINE</div>
                        <div class="app-status-timeline">
                            <div class="timeline-step done">
                                <div class="step-dot"></div>
                                <div class="step-info">
                                    <div class="step-title">Applied</div>
                                    <div class="step-date">Oct 15, 2026</div>
                                </div>
                            </div>
                            <div class="timeline-step done">
                                <div class="step-dot"></div>
                                <div class="step-info">
                                    <div class="step-title">Shortlisted</div>
                                    <div class="step-date">Oct 20, 2026</div>
                                </div>
                            </div>
                            <div class="timeline-step active">
                                <div class="step-dot orange"></div>
                                <div class="step-info">
                                    <div class="step-title">Technical Round</div>
                                    <div class="step-date font-bold">Oct 28, 2:00 PM</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Information Fields -->
                    <div class="app-info-fields-block">
                        <div class="timeline-heading-txt">INFORMATION</div>
                        <div class="info-field-row">
                            <span class="info-field-lbl">Recruiter Name</span>
                            <span class="info-field-val">Anjali Sharma</span>
                        </div>
                        <div class="info-field-row">
                            <span class="info-field-lbl">Next Step</span>
                            <span class="info-field-val">Technical Round</span>
                        </div>
                    </div>

                    <!-- Withdraw Application Button -->
                    <div class="app-withdraw-wrap">
                        <button type="button" class="btn-withdraw-app" onclick="if(confirm('Are you sure you want to withdraw this application?')) alert('Application withdrawn.');">
                            Withdraw Application
                        </button>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
