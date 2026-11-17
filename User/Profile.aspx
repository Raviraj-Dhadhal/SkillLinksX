<%@ Page Title="My Profile - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SkillLinksX.User.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Profile Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-profile-page-container">

        <!-- Top Profile Banner & Hero Header Card -->
        <div class="cand-profile-hero-card">
            <!-- Top Hero Row -->
            <div class="cand-profile-hero-top">
                <div class="cand-profile-avatar-wrap">
                    <span class="cand-profile-avatar-circle" style="width:96px; height:96px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#94a3b8; font-size:48px; border:3px solid #fff; box-shadow:0 2px 8px rgba(0,0,0,0.06);">
                        <i class="fa-regular fa-user"></i>
                    </span>
                </div>

                <div class="cand-profile-hero-details">
                    <div class="cand-profile-title-row">
                        <div class="cand-name-and-tagline">
                            <h1 class="cand-profile-name"><%= StudentName %></h1>
                            <p class="cand-profile-tagline"><%= !string.IsNullOrEmpty(StudentBio) ? StudentBio : "Student at " + (string.IsNullOrEmpty(StudentCollege) ? "University" : StudentCollege) %></p>
                            <div class="cand-profile-meta-row">
                                <span><i class="fa-solid fa-location-dot"></i> <%= StudentCity %></span>
                                <span><i class="fa-solid fa-building-columns"></i> <%= !string.IsNullOrEmpty(StudentCollege) ? StudentCollege : "College Not Added" %></span>
                                <span><i class="fa-regular fa-envelope"></i> <%= StudentEmail %></span>
                            </div>
                        </div>

                        <!-- Action Buttons: Share & Edit -->
                        <div class="cand-profile-hero-actions">
                            <button type="button" class="btn-profile-hero-share" onclick="alert('Profile link copied to clipboard!');">
                                <i class="fa-solid fa-share-nodes"></i> Share Profile
                            </button>
                            <button type="button" class="btn-profile-hero-edit" onclick="openInlineBioModal();" style="display: inline-flex; align-items: center; justify-content: center; gap: 6px; cursor: pointer; border: none; background: #2563eb; color: #fff; padding: 8px 16px; border-radius: 6px; font-weight: 600; font-size: 13px;">
                                <i class="fa-regular fa-pen-to-square"></i> Edit Profile
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Strength Row -->
            <div class="cand-strength-banner">
                <div class="cand-strength-circle-wrap">
                    <svg class="strength-circle-svg" width="36" height="36">
                        <circle class="strength-bg" cx="18" cy="18" r="14" stroke="#E2E8F0" stroke-width="3" fill="none" />
                        <circle class="strength-fill" cx="18" cy="18" r="14" stroke='<%= ProfileStrengthPercent >= 80 ? "#10B981" : (ProfileStrengthPercent >= 60 ? "#2563eb" : "#f59e0b") %>' stroke-width="3" stroke-dasharray="87.96" stroke-dashoffset="<%= StrengthDashOffset.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture) %>" stroke-linecap="round" fill="none" />
                    </svg>
                    <span class="strength-percentage-txt"><%= ProfileStrengthPercent %>%</span>
                </div>
                <div class="cand-strength-info">
                    <span class="cand-strength-title">Profile Strength: <strong class='<%= ProfileStrengthPercent >= 80 ? "text-green" : (ProfileStrengthPercent >= 60 ? "text-blue" : "text-orange") %>'><%= ProfileStrengthLevel %></strong></span>
                    <span class="cand-strength-sub"><%= ProfileStrengthHint %></span>
                </div>
            </div>
        </div>

        <!-- 2-Column Content Layout: Left Details + Right Insights/Sidebar Cards -->
        <div class="cand-profile-main-grid">

            <!-- Left Main Column (About, Education, Experience, Key Projects) -->
            <div class="cand-profile-left-col">

                <!-- 1. About Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-regular fa-user section-icon-blue"></i>
                            <h2 class="cand-card-title">About</h2>
                        </div>
                        <button type="button" onclick="openInlineBioModal();" class="btn-card-edit" aria-label="Edit About" style="background:none; border:none; cursor:pointer;">
                            <i class="fa-regular fa-pen-to-square"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <% if (HasBio) { %>
                            <p class="cand-about-p">
                                <%= StudentBio %>
                            </p>
                        <% } else { %>
                            <div style="padding:16px 12px; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:8px; text-align:center; color:#64748b; font-size:13px;">
                                <i class="fa-regular fa-pen-to-square" style="font-size:22px; color:#94a3b8; display:block; margin-bottom:6px;"></i>
                                No bio added yet. Tell recruiters about yourself directly on your profile.
                                <div style="margin-top:8px;">
                                    <button type="button" onclick="openInlineBioModal();" style="color:#2563eb; font-weight:600; background:none; border:none; cursor:pointer; font-size:13px;">+ Add Bio</button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- 2. Education Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-graduation-cap section-icon-blue"></i>
                            <h2 class="cand-card-title">Education</h2>
                        </div>
                        <button type="button" onclick="openInlineEduModal();" class="btn-card-add" aria-label="Add Education" style="background:none; border:none; cursor:pointer;">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <% if (UserEducationList != null && UserEducationList.Count > 0) { %>
                            <asp:Repeater ID="rptProfileEducation" runat="server">
                                <ItemTemplate>
                                    <div class="timeline-item">
                                        <div class="timeline-dot-ring"></div>
                                        <div class="timeline-details">
                                            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                                                <h3 class="timeline-title"><%# Eval("College") %></h3>
                                            </div>
                                            <p class="timeline-sub"><%# Eval("Degree") %></p>
                                            <div class="timeline-meta-row">
                                                <%# !string.IsNullOrEmpty(Eval("GradYear") as string) ? "<span><i class='fa-regular fa-calendar'></i> Graduation: " + Eval("GradYear") + "</span>" : "" %>
                                                <%# !string.IsNullOrEmpty(Eval("Cgpa") as string) ? "<span class='badge-grade'><i class='fa-regular fa-star'></i> CGPA / Score: " + Eval("Cgpa") + "</span>" : "" %>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div style="margin-top:10px; border-top:1px solid #f1f5f9; padding-top:8px;">
                                <button type="button" onclick="openInlineEduModal();" style="color:#2563eb; font-weight:600; background:none; border:none; cursor:pointer; font-size:12.5px; padding:0;">+ Add Another Education / Degree</button>
                            </div>
                        <% } else { %>
                            <div style="padding:16px 12px; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:8px; text-align:center; color:#64748b; font-size:13px;">
                                <i class="fa-solid fa-graduation-cap" style="font-size:22px; color:#94a3b8; display:block; margin-bottom:6px;"></i>
                                No education history added yet.
                                <div style="margin-top:8px;">
                                    <button type="button" onclick="openInlineEduModal();" style="color:#2563eb; font-weight:600; background:none; border:none; cursor:pointer; font-size:13px;">+ Add Education</button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- 3. Experience & Internships Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-briefcase section-icon-blue"></i>
                            <h2 class="cand-card-title">Experience &amp; Internships</h2>
                        </div>
                        <button type="button" onclick="openInlineExpModal();" class="btn-card-add" aria-label="Add Experience" style="background:none; border:none; cursor:pointer;">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <% if (!string.IsNullOrEmpty(StudentExperience)) { %>
                            <div class="timeline-item">
                                <div class="timeline-dot-ring"></div>
                                <div class="timeline-details">
                                    <h3 class="timeline-title"><%= StudentExperience %></h3>
                                    <p class="timeline-sub">Experience &bull; Verified</p>
                                </div>
                            </div>
                        <% } else { %>
                            <div style="padding:16px 12px; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:8px; text-align:center; color:#64748b; font-size:13px;">
                                <i class="fa-solid fa-briefcase" style="font-size:22px; color:#94a3b8; display:block; margin-bottom:6px;"></i>
                                No previous experience or internships added yet.
                                <div style="margin-top:8px;">
                                    <button type="button" onclick="openInlineExpModal();" style="color:#2563eb; font-weight:600; background:none; border:none; cursor:pointer; font-size:13px;">+ Add Experience</button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- 4. Key Projects Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-code section-icon-blue"></i>
                            <h2 class="cand-card-title">Key Projects</h2>
                        </div>
                        <a href="<%= ResolveUrl("~/User/Portfolio.aspx") %>" class="btn-card-add" aria-label="Manage Projects">
                            <i class="fa-solid fa-plus"></i>
                        </a>
                    </div>
                    <div class="cand-card-body">
                        <% if (UserProjectsList != null && UserProjectsList.Count > 0) { %>
                            <div class="cand-projects-2grid">
                                <asp:Repeater ID="rptProfileProjects" runat="server">
                                    <ItemTemplate>
                                        <div class="cand-project-box">
                                            <div class="project-box-header">
                                                <h3 class="project-box-name"><%# Eval("Name") %></h3>
                                                <a href='<%# !string.IsNullOrEmpty(Eval("GithubLink") as string) ? Eval("GithubLink") : (!string.IsNullOrEmpty(Eval("LiveLink") as string) ? Eval("LiveLink") : "javascript:void(0);") %>' target="_blank" rel="noopener noreferrer" class="project-ext-link" aria-label="Open Project">
                                                    <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                </a>
                                            </div>
                                            <p class="project-box-desc">
                                                <%# Eval("Description") %>
                                            </p>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        <% } else { %>
                            <div style="padding:16px 12px; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:8px; text-align:center; color:#64748b; font-size:13px;">
                                <i class="fa-solid fa-folder-open" style="font-size:22px; color:#94a3b8; display:block; margin-bottom:6px;"></i>
                                No projects featured yet.
                                <div style="margin-top:8px;">
                                    <a href="<%= ResolveUrl("~/User/Portfolio.aspx") %>" style="color:#2563eb; font-weight:600; text-decoration:none;">View &amp; Manage in Portfolio</a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar Column (AI Insights, Resume, Top Skills, Career Preferences, Links) -->
            <div class="cand-profile-right-col">

                <!-- 1. AI Profile Insights Card -->
                <div class="cand-section-card ai-insights-card">
                    <div class="cand-card-header">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-wand-magic-sparkles section-icon-blue"></i>
                            <h2 class="cand-card-title">AI Profile Insights</h2>
                        </div>
                    </div>
                    <div class="cand-card-body">
                        <div class="ai-score-row" style="margin-bottom:16px;">
                            <span class="ai-score-label">Resume Score</span>
                            <span class="ai-score-value"><%= ResumeScore %>/100</span>
                        </div>

                        <button type="button" class="btn-improve-profile" onclick="openInlineSkillsModal();">
                            <i class="fa-solid fa-wand-magic-sparkles"></i> Improve My Profile
                        </button>
                    </div>
                </div>

                <!-- 2. Resume Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header">
                        <div class="cand-card-title-group">
                            <i class="fa-regular fa-file-lines section-icon-blue"></i>
                            <h2 class="cand-card-title">Resume</h2>
                        </div>
                    </div>
                    <div class="cand-card-body">
                        <div class="resume-file-preview-card">
                            <div class="resume-icon-box">
                                <i class="fa-regular fa-file-pdf"></i>
                            </div>
                            <div class="resume-file-info">
                                <span class="resume-file-name">
                                    <asp:Literal ID="litResumeFileName" runat="server">Resume_Student.pdf</asp:Literal>
                                </span>
                                <span class="resume-file-meta">
                                    <asp:Literal ID="litResumeFileMeta" runat="server">PDF Document &bull; Verified</asp:Literal>
                                </span>
                            </div>
                            <div class="resume-file-actions">
                                <asp:LinkButton ID="btnDownloadResume" runat="server" CssClass="btn-resume-action" title="Download Resume" OnClick="btnDownloadResume_Click">
                                    <i class="fa-solid fa-download"></i>
                                </asp:LinkButton>
                            </div>
                        </div>

                        <!-- Hidden FileUpload control triggered by click -->
                        <asp:FileUpload ID="fileResumeUpload" runat="server" accept=".pdf,.docx" style="display:none;" onchange="this.form.submit();" />
                        
                        <button type="button" class="btn-upload-new-resume" onclick="document.getElementById('<%= fileResumeUpload.ClientID %>').click();">
                            <i class="fa-solid fa-upload"></i> Upload New Resume
                        </button>
                        <asp:Label ID="lblResumeStatus" runat="server" Font-Size="Small" Font-Bold="true" style="display:block; margin-top:8px;"></asp:Label>
                    </div>
                </div>

                <!-- 3. Top Skills Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-crosshairs section-icon-blue"></i>
                            <h2 class="cand-card-title">Top Skills</h2>
                        </div>
                        <button type="button" onclick="openInlineSkillsModal();" class="btn-card-edit" aria-label="Edit Skills">
                            <i class="fa-regular fa-pen-to-square"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <!-- =========================================================
                             [DYNAMIC PROFILE SKILLS REPEATER]: Binds skills from DB
                             ========================================================= -->
                        <div class="cand-skills-chips-wrap">
                            <asp:Repeater ID="rptProfileSkills" runat="server">
                                <ItemTemplate>
                                    <span class="skill-dot-chip">
                                        <%# Container.DataItem %> 
                                        <span class="skill-level-dot dot-blue"></span>
                                    </span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="skills-legend-row" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:8px;">
                            <span class="legend-item"><span class="legend-dot bg-blue"></span> Verified Profile Skill</span>
                            <button type="button" onclick="openInlineSkillsModal();" style="color:#2563eb; font-weight:600; background:none; border:none; cursor:pointer; font-size:12.5px; padding:0;">+ Edit Skills</button>
                        </div>
                    </div>
                </div>

                <!-- 4. Career Preferences Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-briefcase section-icon-blue"></i>
                            <h2 class="cand-card-title">Career Preferences</h2>
                        </div>
                        <button type="button" onclick="openInlinePrefModal();" class="btn-card-edit" aria-label="Edit Career Preferences">
                            <i class="fa-regular fa-pen-to-square"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <div class="pref-field-group">
                            <span class="pref-field-label">ROLES</span>
                            <span class="pref-field-val"><%= !string.IsNullOrEmpty(PreferredRoles) ? PreferredRoles : "Not set yet" %></span>
                        </div>
                        <div class="pref-field-group">
                            <span class="pref-field-label">LOCATIONS</span>
                            <span class="pref-field-val"><%= !string.IsNullOrEmpty(PreferredLocations) ? PreferredLocations : "Not set yet" %></span>
                        </div>
                        <div class="pref-field-group">
                            <span class="pref-field-label">WORK TYPE</span>
                            <span class="pref-field-val"><%= !string.IsNullOrEmpty(PreferredWorkType) ? PreferredWorkType : "Not set yet" %></span>
                        </div>
                        <div class="pref-field-group">
                            <span class="pref-field-label">EXPECTED SALARY</span>
                            <span class="pref-field-val"><%= !string.IsNullOrEmpty(ExpectedSalary) ? ExpectedSalary : "Not set yet" %></span>
                        </div>
                        <div style="margin-top:12px; border-top:1px solid #f1f5f9; padding-top:10px;">
                            <button type="button" onclick="openInlinePrefModal();" style="color:#2563eb; font-weight:600; background:none; border:none; cursor:pointer; font-size:12.5px; padding:0;">+ Edit Career Preferences</button>
                        </div>
                    </div>
                </div>

                <!-- 5. Links Card -->
                <div class="cand-section-card">
                    <div class="cand-card-header flex-between">
                        <div class="cand-card-title-group">
                            <i class="fa-solid fa-link section-icon-blue"></i>
                            <h2 class="cand-card-title">Links</h2>
                        </div>
                        <button type="button" onclick="openInlineLinksModal();" class="btn-card-edit" aria-label="Edit Links">
                            <i class="fa-regular fa-pen-to-square"></i>
                        </button>
                    </div>
                    <div class="cand-card-body">
                        <div class="social-links-list">
                            <a href="<%= !string.IsNullOrEmpty(GitHubUrl) ? GitHubUrl : "javascript:void(0);" %>" <%= !string.IsNullOrEmpty(GitHubUrl) ? "target='_blank' rel='noopener noreferrer'" : "onclick='openInlineLinksModal();'" %> class="social-link-item">
                                <i class="fa-brands fa-github"></i>
                                <span>GitHub <%= string.IsNullOrEmpty(GitHubUrl) ? "(Not linked)" : "" %></span>
                            </a>
                            <a href="<%= !string.IsNullOrEmpty(LinkedInUrl) ? LinkedInUrl : "javascript:void(0);" %>" <%= !string.IsNullOrEmpty(LinkedInUrl) ? "target='_blank' rel='noopener noreferrer'" : "onclick='openInlineLinksModal();'" %> class="social-link-item">
                                <i class="fa-brands fa-linkedin"></i>
                                <span>LinkedIn <%= string.IsNullOrEmpty(LinkedInUrl) ? "(Not linked)" : "" %></span>
                            </a>
                            <a href="<%= !string.IsNullOrEmpty(PortfolioUrl) ? PortfolioUrl : "javascript:void(0);" %>" <%= !string.IsNullOrEmpty(PortfolioUrl) ? "target='_blank' rel='noopener noreferrer'" : "onclick='openInlineLinksModal();'" %> class="social-link-item">
                                <i class="fa-solid fa-globe"></i>
                                <span>Portfolio <%= string.IsNullOrEmpty(PortfolioUrl) ? "(Not linked)" : "" %></span>
                            </a>
                        </div>
                        <div style="margin-top:12px; border-top:1px solid #f1f5f9; padding-top:10px;">
                            <button type="button" onclick="openInlineLinksModal();" style="color:#2563eb; font-weight:600; background:none; border:none; cursor:pointer; font-size:12.5px; padding:0;">+ Edit or Add Links</button>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- Modals for Inline Profile Updating Directly to Database -->
    <!-- 1. Edit Bio Modal -->
    <div id="inlineBioModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:12px; max-width:480px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeInlineBioModal();" style="position:absolute; right:16px; top:16px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:17px; font-weight:700; color:#0f172a;">Update About / Bio</h3>
            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px;">This bio is saved directly to the database and appears to recruiters.</p>
            <asp:Label ID="lblInlineBioMsg" runat="server" style="display:block; margin-bottom:10px; font-size:13px; font-weight:600;" EnableViewState="false" />
            <asp:TextBox ID="txtInlineBio" runat="server" TextMode="MultiLine" Rows="4" placeholder="Write about yourself, career aspirations, and specialties..." style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px; resize:vertical;" />
            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                <button type="button" onclick="closeInlineBioModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveInlineBio" runat="server" Text="Save Bio" OnClick="btnSaveInlineBio_Click" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <!-- 2. Edit Education Modal -->
    <div id="inlineEduModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:12px; max-width:480px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeInlineEduModal();" style="position:absolute; right:16px; top:16px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:17px; font-weight:700; color:#0f172a;">Update Education History</h3>
            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px;">Add your college, degree, graduation year, and CGPA.</p>
            <asp:Label ID="lblInlineEduMsg" runat="server" style="display:block; margin-bottom:10px; font-size:13px; font-weight:600;" EnableViewState="false" />
            <div style="display:flex; flex-direction:column; gap:10px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">College / University Name</label>
                    <asp:TextBox ID="txtInlineCollege" runat="server" placeholder="e.g. Gujarat Technological University" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Degree / Major</label>
                    <asp:TextBox ID="txtInlineDegree" runat="server" placeholder="e.g. B.Tech Computer Engineering" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Graduation Year</label>
                        <asp:TextBox ID="txtInlineGradYear" runat="server" placeholder="e.g. 2025" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">CGPA / Percentage</label>
                        <asp:TextBox ID="txtInlineCgpa" runat="server" placeholder="e.g. 8.5" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                </div>
            </div>
            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                <button type="button" onclick="closeInlineEduModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveInlineEdu" runat="server" Text="Save Education" OnClick="btnSaveInlineEdu_Click" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <!-- 3. Edit Skills Modal -->
    <div id="inlineSkillsModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:12px; max-width:480px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeInlineSkillsModal();" style="position:absolute; right:16px; top:16px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:17px; font-weight:700; color:#0f172a;">Update Top Skills</h3>
            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px;">Comma-separated list of your technical and soft skills.</p>
            <asp:Label ID="lblInlineSkillsMsg" runat="server" style="display:block; margin-bottom:10px; font-size:13px; font-weight:600;" EnableViewState="false" />
            <asp:TextBox ID="txtInlineSkills" runat="server" placeholder="e.g. C#, ASP.NET, SQL Server, React, JavaScript, Git" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                <button type="button" onclick="closeInlineSkillsModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveInlineSkills" runat="server" Text="Save Skills" OnClick="btnSaveInlineSkills_Click" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <!-- 4. Edit Experience Modal -->
    <div id="inlineExpModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:12px; max-width:480px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeInlineExpModal();" style="position:absolute; right:16px; top:16px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:17px; font-weight:700; color:#0f172a;">Update Experience &amp; Internships</h3>
            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px;">Add your work experience, company, and role.</p>
            <asp:Label ID="lblInlineExpMsg" runat="server" style="display:block; margin-bottom:10px; font-size:13px; font-weight:600;" EnableViewState="false" />
            <div style="display:flex; flex-direction:column; gap:10px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Experience Summary / Role &amp; Company</label>
                    <asp:TextBox ID="txtInlineExp" runat="server" TextMode="MultiLine" Rows="3" placeholder="e.g. Junior Web Intern at TechFlow (3 months) - Developed responsive UI and integrated REST APIs" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px; resize:vertical;" />
                </div>
            </div>
            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                <button type="button" onclick="closeInlineExpModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveInlineExp" runat="server" Text="Save Experience" OnClick="btnSaveInlineExp_Click" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <!-- 5. Edit Social Links Modal -->
    <div id="inlineLinksModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:12px; max-width:480px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeInlineLinksModal();" style="position:absolute; right:16px; top:16px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:17px; font-weight:700; color:#0f172a;">Update Links</h3>
            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px;">Add your GitHub, LinkedIn, and Portfolio URLs.</p>
            <asp:Label ID="lblInlineLinksMsg" runat="server" style="display:block; margin-bottom:10px; font-size:13px; font-weight:600;" EnableViewState="false" />
            <div style="display:flex; flex-direction:column; gap:10px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">GitHub URL</label>
                    <asp:TextBox ID="txtInlineGithub" runat="server" placeholder="https://github.com/username" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">LinkedIn URL</label>
                    <asp:TextBox ID="txtInlineLinkedIn" runat="server" placeholder="https://linkedin.com/in/username" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Portfolio URL</label>
                    <asp:TextBox ID="txtInlinePortfolio" runat="server" placeholder="https://yourportfolio.com" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
            </div>
            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                <button type="button" onclick="closeInlineLinksModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveInlineLinks" runat="server" Text="Save Links" OnClick="btnSaveInlineLinks_Click" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <!-- 6. Edit Career Preferences Modal -->
    <div id="inlinePrefModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:12px; max-width:480px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeInlinePrefModal();" style="position:absolute; right:16px; top:16px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:17px; font-weight:700; color:#0f172a;">Update Career Preferences</h3>
            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px;">Set your target roles, locations, work mode, and expected salary.</p>
            <asp:Label ID="lblInlinePrefMsg" runat="server" style="display:block; margin-bottom:10px; font-size:13px; font-weight:600;" EnableViewState="false" />
            <div style="display:flex; flex-direction:column; gap:10px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Target Roles</label>
                    <asp:TextBox ID="txtInlineRoles" runat="server" placeholder="e.g. Full Stack Developer, Software Engineer" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Preferred Locations</label>
                    <asp:TextBox ID="txtInlineLocations" runat="server" placeholder="e.g. Bengaluru, Mumbai, Remote" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Work Type</label>
                        <asp:TextBox ID="txtInlineWorkType" runat="server" placeholder="e.g. Hybrid / Remote" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Expected Salary</label>
                        <asp:TextBox ID="txtInlineSalary" runat="server" placeholder="e.g. ₹8L - ₹12L" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                </div>
            </div>
            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                <button type="button" onclick="closeInlinePrefModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveInlinePref" runat="server" Text="Save Preferences" OnClick="btnSaveInlinePref_Click" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openInlineBioModal() {
            var m = document.getElementById("inlineBioModal");
            if (m) m.style.display = "flex";
        }
        function closeInlineBioModal() {
            var m = document.getElementById("inlineBioModal");
            if (m) m.style.display = "none";
        }
        function openInlineEduModal() {
            var m = document.getElementById("inlineEduModal");
            if (m) m.style.display = "flex";
        }
        function closeInlineEduModal() {
            var m = document.getElementById("inlineEduModal");
            if (m) m.style.display = "none";
        }
        function openInlineSkillsModal() {
            var m = document.getElementById("inlineSkillsModal");
            if (m) m.style.display = "flex";
        }
        function closeInlineSkillsModal() {
            var m = document.getElementById("inlineSkillsModal");
            if (m) m.style.display = "none";
        }
        function openInlineExpModal() {
            var m = document.getElementById("inlineExpModal");
            if (m) m.style.display = "flex";
        }
        function closeInlineExpModal() {
            var m = document.getElementById("inlineExpModal");
            if (m) m.style.display = "none";
        }
        function openInlineLinksModal() {
            var m = document.getElementById("inlineLinksModal");
            if (m) m.style.display = "flex";
        }
        function closeInlineLinksModal() {
            var m = document.getElementById("inlineLinksModal");
            if (m) m.style.display = "none";
        }
        function openInlinePrefModal() {
            var m = document.getElementById("inlinePrefModal");
            if (m) m.style.display = "flex";
        }
        function closeInlinePrefModal() {
            var m = document.getElementById("inlinePrefModal");
            if (m) m.style.display = "none";
        }
    </script>
</asp:Content>
