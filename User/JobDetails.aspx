<%@ Page Title="Job Details - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="JobDetails.aspx.cs" Inherits="SkillLinksX.User.JobDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Job Details Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-opp-details-container">

        <!-- Top Breadcrumbs Bar -->
        <div class="opp-details-breadcrumb">
            <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="breadcrumb-back-link">
                <i class="fa-solid fa-arrow-left"></i> Back to Jobs
            </a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current"><%= JobTitle %></span>
        </div>

        <!-- Header Card -->
        <div class="job-header-card">
            <div class="job-header-top-flex flex-between">
                <div class="job-header-left-brand">
                    <div class="job-header-avatar">
                        <span style="width:52px; height:52px; border-radius:10px; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:24px; overflow:hidden; border:1px solid #cbd5e1;">
                            <% if (!string.IsNullOrEmpty(CompanyLogoUrl)) { %>
                                <img src='<%= ResolveUrl(CompanyLogoUrl) %>' alt='<%= CompanyName %>' style='width:100%; height:100%; object-fit:cover;' />
                            <% } else { %>
                                <i class="fa-solid fa-building"></i>
                            <% } %>
                        </span>
                    </div>
                    <div class="job-header-titles">
                        <div class="job-title-badge-row">
                            <h1 class="job-main-title"><%= JobTitle %></h1>
                            <span class="badge-actively-hiring">ACTIVELY HIRING</span>
                        </div>
                        <div class="job-header-subline">
                            <span class="job-company-name"><%= CompanyName %></span> &bull; 
                            <span class="job-location-name"><%= CompanyLocation %></span>
                        </div>
                        <div class="job-meta-chips-row">
                            <span><i class="fa-solid fa-briefcase"></i> <%= ExperienceRequired %></span>
                            <span><i class="fa-solid fa-indian-rupee-sign"></i> <%= SalaryRange %></span>
                            <span><i class="fa-solid fa-location-dot"></i> <%= CompanyLocation %></span>
                            <span><i class="fa-regular fa-clock"></i> Active Opening</span>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons: Apply Now, Save, Share -->
                <div class="job-header-actions-group">
                    <!-- =========================================================
                         [APPLY ACTION BUTTON]: Wired to server-side btnApply_Click
                         Inserts student application into 'applications' table
                         ========================================================= -->
                    <asp:Button ID="btnApplyNow" runat="server" CssClass="btn-job-apply-primary" Text="Apply Now" OnClick="btnApplyNow_Click" />
                    <asp:Button ID="btnSaveJob" runat="server" CssClass="btn-job-action-box" Text="Save" OnClick="btnSaveJob_Click" />
                </div>
            </div>
        </div>

        <!-- Feedback Alert Message -->
        <asp:Label ID="lblFeedback" runat="server" style="display:block; margin: 12px 0; font-size: 14px; font-weight: 500;" EnableViewState="false"></asp:Label>

        <!-- 2-Column Grid: Left Content + Right Company & Application Cards -->
        <div class="job-body-grid">

            <!-- Left Main Column -->
            <div class="job-body-main-col">

                <!-- 1. Your AI Career Match Card (Soft Gradient) -->
                <div class="job-ai-match-card">
                    <div class="ai-match-score-left">
                        <div class="ai-circle-score">
                            <span class="ai-score-txt"><%= AiMatchScore %>%</span>
                        </div>
                    </div>
                    <div class="ai-match-content-right">
                        <div class="ai-match-headline">
                            <i class="fa-solid fa-sparkles"></i> Your AI Career Match
                        </div>
                        <p class="ai-match-blurb">
                            <%= AiMatchBlurb %>
                        </p>
                        <div class="ai-match-skill-chips">
                            <% foreach(var ms in MatchingSkills) { %>
                                <span class="ai-chip-pill chip-green"><i class="fa-solid fa-check"></i> <%= ms %></span>
                            <% } %>
                            <% foreach(var miss in MissingSkills) { %>
                                <span class="ai-chip-pill chip-red"><i class="fa-solid fa-xmark"></i> <%= miss %></span>
                            <% } %>
                        </div>
                        <a href="<%= ResolveUrl("~/User/CareerAssistant.aspx") %>" class="ai-match-improve-link">Improve My Match &rarr;</a>
                    </div>
                </div>

                <!-- 2. About the Job Card -->
                <div class="job-section-card">
                    <div class="job-card-section-block">
                        <h2 class="job-section-heading">About the Job</h2>
                        <p class="job-desc-paragraph">
                            <%= !string.IsNullOrEmpty(JobDescription) ? JobDescription : "We are seeking a talented candidate to join our team in this role. You will work on impactful projects, collaborate with cross-functional teams, and contribute to innovative software solutions." %>
                        </p>
                    </div>

                    <!-- Requirements -->
                    <div class="job-card-section-block">
                        <h3 class="job-sub-heading">Requirements &amp; Skills</h3>
                        <div class="req-tech-skills-title">Required Competencies</div>
                        <div class="req-skills-tags-row">
                            <% if (RequiredSkillsList != null && RequiredSkillsList.Count > 0) { 
                                   foreach(var req in RequiredSkillsList) { %>
                                       <span class="req-skill-pill"><%= req %></span>
                            <%     } 
                               } else { %>
                                   <span class="req-skill-pill">General Engineering</span>
                            <% } %>
                        </div>

                        <!-- 2 Sub Cards: Education + Experience -->
                        <div class="req-cards-2grid">
                            <div class="req-sub-card">
                                <i class="fa-solid fa-graduation-cap req-card-icon"></i>
                                <div class="req-card-info">
                                    <span class="req-card-label">Education</span>
                                    <p class="req-card-desc">B.Tech / B.E. / BCA / MCA in Computer Science, IT, or related degree.</p>
                                </div>
                            </div>
                            <div class="req-sub-card">
                                <i class="fa-solid fa-briefcase req-card-icon"></i>
                                <div class="req-card-info">
                                    <span class="req-card-label">Experience Required</span>
                                    <p class="req-card-desc"><%= ExperienceRequired %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Benefits & Perks -->
                    <div class="job-card-section-block no-border">
                        <h3 class="job-sub-heading">Benefits &amp; Perks</h3>
                        <div class="perks-4grid">
                            <div class="perk-tile">
                                <div class="perk-icon-wrap"><i class="fa-solid fa-briefcase-medical"></i></div>
                                <span class="perk-tile-title"><%= !string.IsNullOrEmpty(JobBenefits) ? JobBenefits : "Health & Wellness" %></span>
                            </div>
                            <div class="perk-tile">
                                <div class="perk-icon-wrap"><i class="fa-solid fa-laptop-house"></i></div>
                                <span class="perk-tile-title">Flexible Hours</span>
                            </div>
                            <div class="perk-tile">
                                <div class="perk-icon-wrap"><i class="fa-solid fa-award"></i></div>
                                <span class="perk-tile-title">Mentorship &amp; Growth</span>
                            </div>
                            <div class="perk-tile">
                                <div class="perk-icon-wrap"><i class="fa-solid fa-plane-departure"></i></div>
                                <span class="perk-tile-title">Competitive Compensation</span>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <!-- Right Sidebar Column -->
            <div class="job-body-side-col">

                <!-- 1. About the Company Card -->
                <div class="job-side-card">
                    <h3 class="side-card-title">About the Company</h3>
                    <div class="company-brand-row">
                        <div class="side-company-avatar">
                            <span style="width:40px; height:40px; border-radius:8px; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:18px; overflow:hidden; border:1px solid #cbd5e1;">
                                <% if (!string.IsNullOrEmpty(CompanyLogoUrl)) { %>
                                    <img src='<%= ResolveUrl(CompanyLogoUrl) %>' alt='<%= CompanyName %>' style='width:100%; height:100%; object-fit:cover;' />
                                <% } else { %>
                                    <i class="fa-solid fa-building"></i>
                                <% } %>
                            </span>
                        </div>
                        <div class="side-company-meta">
                            <h4 class="side-company-name"><%= CompanyName %></h4>
                            <a href="javascript:void(0);" onclick="openCompanyModal();" class="side-company-link">View Profile</a>
                        </div>
                    </div>
                    <p class="side-company-desc">
                        <%= CompanyDescription %>
                    </p>
                    <div class="side-meta-list">
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-solid fa-building"></i> Industry</span>
                            <span class="side-meta-val"><%= CompanyIndustry %></span>
                        </div>
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-solid fa-users"></i> Company Size</span>
                            <span class="side-meta-val"><%= CompanySize %></span>
                        </div>
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-solid fa-location-dot"></i> Location</span>
                            <span class="side-meta-val"><%= CompanyLocation %></span>
                        </div>
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-solid fa-globe"></i> Website</span>
                            <a href="<%= CompanyWebsite %>" target="_blank" rel="noopener noreferrer" class="side-meta-link"><%= CompanyWebsite.Replace("https://", "").Replace("http://", "").TrimEnd('/') %></a>
                        </div>
                    </div>
                </div>

                <!-- Company Details Modal Popup -->
                <div id="companyProfileModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
                    <div style="background:#fff; border-radius:14px; max-width:540px; width:90%; padding:28px 24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative; animation:fadeIn 0.2s ease;">
                        <button type="button" onclick="closeCompanyModal();" style="position:absolute; right:18px; top:18px; background:none; border:none; font-size:18px; color:#94a3b8; cursor:pointer;" aria-label="Close Modal">&times;</button>
                        
                        <div style="display:flex; align-items:center; gap:16px; margin-bottom:18px;">
                            <span style="width:56px; height:56px; border-radius:12px; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:24px; overflow:hidden; border:1px solid #cbd5e1;">
                                <% if (!string.IsNullOrEmpty(CompanyLogoUrl)) { %>
                                    <img src='<%= ResolveUrl(CompanyLogoUrl) %>' alt='<%= CompanyName %>' style='width:100%; height:100%; object-fit:cover;' />
                                <% } else { %>
                                    <i class="fa-solid fa-building"></i>
                                <% } %>
                            </span>
                            <div>
                                <h3 style="margin:0 0 4px; font-size:18px; font-weight:700; color:#0f172a;"><%= CompanyName %></h3>
                                <span style="display:inline-flex; align-items:center; gap:4px; font-size:12px; color:#10b981; font-weight:600;"><i class="fa-solid fa-circle-check"></i> Verified Company</span>
                            </div>
                        </div>

                        <div style="background:#f8fafc; border-radius:10px; padding:14px 16px; margin-bottom:18px; font-size:13.5px; color:#475569; line-height:1.6;">
                            <%= CompanyDescription %>
                        </div>

                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-bottom:20px;">
                            <div style="border:1px solid #e2e8f0; border-radius:8px; padding:10px 12px;">
                                <span style="font-size:11px; text-transform:uppercase; color:#64748b; font-weight:700; display:block; margin-bottom:2px;">Industry</span>
                                <strong style="font-size:13px; color:#1e293b;"><%= CompanyIndustry %></strong>
                            </div>
                            <div style="border:1px solid #e2e8f0; border-radius:8px; padding:10px 12px;">
                                <span style="font-size:11px; text-transform:uppercase; color:#64748b; font-weight:700; display:block; margin-bottom:2px;">Company Size</span>
                                <strong style="font-size:13px; color:#1e293b;"><%= CompanySize %></strong>
                            </div>
                            <div style="border:1px solid #e2e8f0; border-radius:8px; padding:10px 12px;">
                                <span style="font-size:11px; text-transform:uppercase; color:#64748b; font-weight:700; display:block; margin-bottom:2px;">Headquarters</span>
                                <strong style="font-size:13px; color:#1e293b;"><%= CompanyLocation %></strong>
                            </div>
                            <div style="border:1px solid #e2e8f0; border-radius:8px; padding:10px 12px;">
                                <span style="font-size:11px; text-transform:uppercase; color:#64748b; font-weight:700; display:block; margin-bottom:2px;">Official Website</span>
                                <a href="<%= CompanyWebsite %>" target="_blank" rel="noopener noreferrer" style="font-size:13px; color:#2563eb; font-weight:600; text-decoration:none;"><%= CompanyWebsite.Replace("https://", "").Replace("http://", "").TrimEnd('/') %></a>
                            </div>
                        </div>

                        <div style="display:flex; justify-content:flex-end; gap:10px;">
                            <button type="button" onclick="closeCompanyModal();" style="padding:9px 18px; border-radius:8px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Close</button>
                            <a href="<%= CompanyWebsite %>" target="_blank" rel="noopener noreferrer" style="padding:9px 18px; border-radius:8px; background:#2563eb; color:#fff; font-size:13px; font-weight:600; text-decoration:none; display:inline-flex; align-items:center; gap:6px;">Visit Official Site <i class="fa-solid fa-arrow-up-right-from-square" style="font-size:11px;"></i></a>
                        </div>
                    </div>
                </div>

                <script>
                    function openCompanyModal() {
                        const m = document.getElementById("companyProfileModal");
                        if (m) { m.style.display = "flex"; }
                    }
                    function closeCompanyModal() {
                        const m = document.getElementById("companyProfileModal");
                        if (m) { m.style.display = "none"; }
                    }
                </script>

                <!-- 2. Application Details Card -->
                <div class="job-side-card">
                    <h3 class="side-card-title">Application Details</h3>
                    <div class="app-details-list">
                        <div class="app-detail-item">
                            <div class="app-detail-icon"><i class="fa-regular fa-calendar"></i></div>
                            <div class="app-detail-content">
                                <span class="app-detail-label">Deadline</span>
                                <span class="app-detail-val"><%= Deadline %></span>
                            </div>
                        </div>
                        <div class="app-detail-item">
                            <div class="app-detail-icon"><i class="fa-solid fa-user-group"></i></div>
                            <div class="app-detail-content">
                                <span class="app-detail-label">Status</span>
                                <span class="app-detail-val">Actively Reviewing</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <!-- Bottom Similar Jobs Section -->
        <div class="similar-jobs-section">
            <h2 class="similar-jobs-title">Similar Jobs</h2>
            <div class="similar-jobs-grid">

                <!-- Job 1: .NET Developer at AppGen -->
                <div class="similar-job-card">
                    <div class="similar-job-top flex-between">
                        <div class="similar-company-avatar">
                            <img src="<%= ResolveUrl("~/assets/images/technova-avatar.svg") %>" alt="AppGen" class="similar-avatar-img" />
                        </div>
                        <button type="button" class="btn-similar-bookmark" aria-label="Save Job">
                            <i class="fa-regular fa-bookmark"></i>
                        </button>
                    </div>
                    <h3 class="similar-role-title">
                        <a href="#" style="color: inherit; text-decoration: none;">.NET Developer</a>
                    </h3>
                    <div class="similar-company-sub">AppGen &bull; Pune, Maharashtra</div>
                    <div class="similar-chips-row">
                        <span class="sim-chip">1-3 Yrs</span>
                        <span class="sim-chip">&#8377;5L - &#8377;8L</span>
                        <span class="sim-chip">Remote</span>
                    </div>
                    <div class="similar-posted-time">Posted 1 day ago</div>
                </div>

                <!-- Job 2: Junior C# Programmer at DataSys -->
                <div class="similar-job-card">
                    <div class="similar-job-top flex-between">
                        <div class="similar-company-avatar avatar-datasys">
                            <span>DataSys</span>
                        </div>
                        <button type="button" class="btn-similar-bookmark" aria-label="Save Job">
                            <i class="fa-regular fa-bookmark"></i>
                        </button>
                    </div>
                    <h3 class="similar-role-title">
                        <a href="#" style="color: inherit; text-decoration: none;">Junior C# Programmer</a>
                    </h3>
                    <div class="similar-company-sub">DataSys &bull; Mumbai, Maharashtra</div>
                    <div class="similar-chips-row">
                        <span class="sim-chip">0-1 Yrs</span>
                        <span class="sim-chip">&#8377;3.5L - &#8377;5L</span>
                        <span class="sim-chip">On-site</span>
                    </div>
                    <div class="similar-posted-time">Posted 5 days ago</div>
                </div>

                <!-- Job 3: Backend Engineer (.NET) at CloudPeak -->
                <div class="similar-job-card">
                    <div class="similar-job-top flex-between">
                        <div class="similar-company-avatar avatar-cloudpeak">
                            <i class="fa-solid fa-cloud"></i>
                        </div>
                        <button type="button" class="btn-similar-bookmark" aria-label="Save Job">
                            <i class="fa-regular fa-bookmark"></i>
                        </button>
                    </div>
                    <h3 class="similar-role-title">
                        <a href="#" style="color: inherit; text-decoration: none;">Backend Engineer (.NET)</a>
                    </h3>
                    <div class="similar-company-sub">CloudPeak &bull; Ahmedabad, Gujarat</div>
                    <div class="similar-chips-row">
                        <span class="sim-chip">2-4 Yrs</span>
                        <span class="sim-chip">&#8377;6L - &#8377;10L</span>
                        <span class="sim-chip">Hybrid</span>
                    </div>
                    <div class="similar-posted-time">Posted 1 week ago</div>
                </div>

            </div>
        </div>

    </div>
</asp:Content>
