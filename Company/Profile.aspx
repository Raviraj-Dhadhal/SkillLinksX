<%@ Page Title="Company Profile - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SkillLinksX.Company.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Company Profile Specific Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="company-profile-container">
        
        <!-- 1. Top Company Overview Header Card -->
        <div class="profile-header-card">
            <div class="profile-header-top">
                <!-- Company Logo Monogram -->
                <div class="company-profile-logo-box" style="overflow:hidden; display:flex; align-items:center; justify-content:center;">
                    <% if (!string.IsNullOrEmpty(CompanyLogoUrl)) { %>
                        <img src="<%= ResolveUrl(CompanyLogoUrl) %>" alt="<%= CompanyName %>" style="width:100%; height:100%; object-fit:cover;" />
                    <% } else { %>
                        <i class="fa-solid fa-building" style="font-size:32px; color:#64748b;"></i>
                    <% } %>
                </div>

                <!-- Company Details -->
                <div class="profile-header-details">
                    <h1 class="profile-company-name"><%= CompanyName %></h1>
                    <div class="profile-meta-tags-row">
                        <div class="profile-meta-item">
                            <i class="fa-solid fa-briefcase"></i> <%= CompanyIndustry %>
                        </div>
                        <div class="profile-meta-item">
                            <i class="fa-solid fa-location-dot"></i> <%= CompanyLocation %>
                        </div>
                        <div class="profile-meta-item">
                            <i class="fa-solid fa-users"></i> <%= EmployeeCount %>
                        </div>
                    </div>
                    <% if (!string.IsNullOrEmpty(CompanyWebsite)) { %>
                        <div class="profile-meta-tags-row">
                            <div class="profile-meta-item">
                                <i class="fa-solid fa-globe"></i> 
                                <a href="<%= CompanyWebsite.StartsWith("http") ? CompanyWebsite : "https://" + CompanyWebsite %>" target="_blank" rel="noopener noreferrer" style="color:inherit; text-decoration:none;">
                                    <%= CompanyWebsite %>
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Action Buttons: Share & Edit -->
                <div class="profile-header-actions">
                    <button type="button" class="btn-profile-share" title="Share Profile">
                        <i class="fa-solid fa-share-nodes"></i> Share Profile
                    </button>
                    <a href="<%= ResolveUrl("~/Company/Settings.aspx") %>" class="btn-profile-edit" title="Edit Profile">
                        <i class="fa-regular fa-pen-to-square"></i> Edit Profile
                    </a>
                </div>
            </div>

            <!-- Profile Completion Progress Track -->
            <div class="profile-completion-section">
                <div class="profile-completion-header">
                    <span>PROFILE COMPLETION</span>
                    <span><%= ProfileCompletionPercentage %>%</span>
                </div>
                <div class="profile-completion-track">
                    <div class="profile-completion-bar" style="width: <%= ProfileCompletionPercentage %>%;"></div>
                </div>
            </div>
        </div>

        <!-- 2. Two-Column Split Grid (Left Main / Right Widgets) -->
        <div class="profile-two-col-grid">
            
            <!-- Left Column -->
            <div class="profile-left-col">
                
                <!-- About Company Card -->
                <div class="profile-card">
                    <h2 class="profile-card-title">About <%= CompanyName %></h2>
                    <p class="about-company-desc">
                        <%= CompanyDescription %>
                    </p>

                    <!-- Mission & Vision 2-Col Box -->
                    <div class="mission-vision-row">
                        <div class="mission-vision-box">
                            <span class="mv-badge">MISSION</span>
                            <p class="mv-quote">"Empowering businesses through intelligent technology and innovative talent."</p>
                        </div>
                        <div class="mission-vision-box">
                            <span class="mv-badge">VISION</span>
                            <p class="mv-quote">"To build scalable, next-generation solutions for global enterprise challenges."</p>
                        </div>
                    </div>
                </div>

                <!-- Open Positions Section -->
                <div>
                    <div class="positions-header-row">
                        <h2 class="profile-card-title" style="margin-bottom:0;">Open Positions (<%= PostedJobsList.Count %>)</h2>
                        <a href="<%= ResolveUrl("~/Company/ManageJobs.aspx") %>" class="view-all-positions-link">View all</a>
                    </div>

                    <% if (PostedJobsList != null && PostedJobsList.Count > 0) { 
                           foreach(var job in PostedJobsList) { %>
                               <div class="position-item-card">
                                   <div class="position-top-row">
                                       <h3 class="position-role-title"><%= job.Title %></h3>
                                       <span class="position-badge-active"><%= job.Status %></span>
                                   </div>
                                   <div class="position-company-sub"><%= CompanyName %> &bull; <%= job.JobType %></div>
                                   <div class="position-pills-row">
                                       <span class="position-pill"><i class="fa-solid fa-location-dot"></i> <%= job.Location %></span>
                                       <span class="position-pill"><i class="fa-solid fa-briefcase"></i> <%= job.Experience %></span>
                                       <span class="position-pill"><i class="fa-solid fa-money-bill-wave"></i> <%= job.Salary %></span>
                                   </div>
                                   <div class="position-bottom-row">
                                       <span class="position-applicants-count"><%= job.ApplicantCount %> applicants</span>
                                       <a href="<%= ResolveUrl("~/Company/ManageJobs.aspx") %>" class="manage-job-btn-link">Manage Job</a>
                                   </div>
                               </div>
                    <%     } 
                       } else { %>
                           <div style="padding:28px 16px; text-align:center; color:#64748b; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:10px; margin-bottom:20px;">
                               <i class="fa-solid fa-briefcase" style="font-size:32px; color:#94a3b8; margin-bottom:8px; display:block;"></i>
                               <h4 style="font-size:15px; font-weight:600; color:#334155; margin-bottom:4px;">No Positions Posted Yet</h4>
                               <p style="font-size:13px; margin:0 0 12px;">Create your first opening to attract top candidates.</p>
                               <a href="<%= ResolveUrl("~/Company/PostJob.aspx") %>" class="manage-job-btn-link" style="display:inline-block; padding:8px 16px;">Post a Job</a>
                           </div>
                    <% } %>
                </div>

                <!-- Our Hiring Process Card -->
                <div class="hiring-process-card">
                    <h2 class="profile-card-title" style="margin-bottom:0;">Our Hiring Process</h2>
                    
                    <div class="hiring-steps-track">
                        <!-- Step 1: Application -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">1</div>
                            <span class="hiring-node-title">Application</span>
                            <span class="hiring-node-desc">Review of resume and portfolio.</span>
                        </div>

                        <!-- Step 2: Screening -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">2</div>
                            <span class="hiring-node-title">Screening</span>
                            <span class="hiring-node-desc">Initial HR call for alignment.</span>
                        </div>

                        <!-- Step 3: Interview -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">3</div>
                            <span class="hiring-node-title">Interview</span>
                            <span class="hiring-node-desc">Technical and cultural rounds.</span>
                        </div>

                        <!-- Step 4: Selection -->
                        <div class="hiring-step-node">
                            <div class="hiring-node-circle">4</div>
                            <span class="hiring-node-title">Selection</span>
                            <span class="hiring-node-desc">Offer and onboarding.</span>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Right Column Widgets -->
            <div class="profile-right-col">
                
                <!-- 2-Column Stats (Active Jobs & Total Hires) -->
                <div class="profile-stats-2col">
                    <div class="profile-stat-box">
                        <div class="profile-stat-num"><%= ActiveJobsCount %></div>
                        <div class="profile-stat-label">Active Jobs</div>
                    </div>
                    <div class="profile-stat-box">
                        <div class="profile-stat-num"><%= TotalApplicantsCount %></div>
                        <div class="profile-stat-label">Total Applicants</div>
                    </div>
                </div>

                <!-- Average Response Time Banner -->
                <div class="avg-response-banner">
                    <span class="avg-response-label">AVG RESPONSE TIME</span>
                    <span class="avg-response-val">2 days</span>
                </div>

                <!-- Primary Recruiter Card -->
                <div class="primary-recruiter-card">
                    <div class="recruiter-header-label">PRIMARY RECRUITER</div>
                    <div class="recruiter-profile-row">
                        <span style="width:40px; height:40px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:18px; border:1px solid #cbd5e1;">
                            <i class="fa-regular fa-user"></i>
                        </span>
                        <div>
                            <h4 class="recruiter-name"><%= Session["UserName"] ?? "Talent Acquisition" %></h4>
                            <span class="recruiter-role">Lead Recruiter</span>
                        </div>
                    </div>
                    <a href="<%= ResolveUrl("~/Company/Messages.aspx") %>" class="btn-message-recruiter">
                        <i class="fa-regular fa-message"></i> Messages
                    </a>
                </div>

                <!-- Benefits & Culture Card -->
                <div class="benefits-card">
                    <div class="benefits-card-title">BENEFITS &amp; CULTURE</div>
                    
                    <!-- Benefit 1: Flexible Work -->
                    <div class="benefit-item-row">
                        <div class="benefit-icon-box">
                            <i class="fa-solid fa-house-laptop"></i>
                        </div>
                        <div>
                            <div class="benefit-text-title">Flexible Work</div>
                            <p class="benefit-text-sub">Hybrid and remote options available.</p>
                        </div>
                    </div>

                    <!-- Benefit 2: Learning & Dev -->
                    <div class="benefit-item-row">
                        <div class="benefit-icon-box">
                            <i class="fa-solid fa-graduation-cap"></i>
                        </div>
                        <div>
                            <div class="benefit-text-title">Learning &amp; Dev</div>
                            <p class="benefit-text-sub">Dedicated budget for courses and certs.</p>
                        </div>
                    </div>

                    <!-- Benefit 3: Team Collaboration -->
                    <div class="benefit-item-row">
                        <div class="benefit-icon-box">
                            <i class="fa-solid fa-people-group"></i>
                        </div>
                        <div>
                            <div class="benefit-text-title">Team Collaboration</div>
                            <p class="benefit-text-sub">Regular offsites and team building.</p>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
