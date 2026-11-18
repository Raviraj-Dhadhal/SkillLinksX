<%@ Page Title="Portfolio - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Portfolio.aspx.cs" Inherits="SkillLinksX.User.Portfolio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Portfolio Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-portfolio-page-container">

        <!-- Top Profile Banner & Hero Header Card -->
        <div class="portfolio-hero-card">
            <div class="portfolio-hero-left">
                <!-- Avatar with online indicator -->
                <div class="portfolio-avatar-wrap">
                    <% if (!string.IsNullOrEmpty(ProfilePhotoUrl)) { %>
                        <img src="<%= ResolveUrl(ProfilePhotoUrl) %>" alt="<%= StudentFullName %>" class="portfolio-avatar-img" />
                    <% } else { %>
                        <div style="width:100%; height:100%; border-radius:50%; background:#f1f5f9; display:flex; align-items:center; justify-content:center; color:#94a3b8; font-size:40px; border:3px solid #fff; box-sizing:border-box;">
                            <i class="fa-regular fa-user"></i>
                        </div>
                    <% } %>
                    <span class="portfolio-status-dot" title="Available for opportunities"></span>
                </div>

                <!-- Info Stack -->
                <div class="portfolio-info-stack">
                    <h1 class="portfolio-user-name"><%= StudentFullName %></h1>
                    <p class="portfolio-user-headline"><%= StudentHeadline %></p>
                    <div class="portfolio-meta-tags">
                        <span class="portfolio-meta-pill">
                            <i class="fa-solid fa-location-dot"></i> <%= StudentLocation %>
                        </span>
                        <span class="portfolio-meta-pill">
                            <i class="fa-solid fa-building-columns"></i> <%= StudentCollege %>
                        </span>
                    </div>

                    <!-- Action Buttons Row -->
                    <div class="portfolio-action-buttons">
                        <button type="button" onclick="openEditPortfolioModal();" class="btn-portfolio-edit" style="cursor:pointer; border:none;">
                            <i class="fa-regular fa-pen-to-square"></i> Edit Portfolio
                        </button>
                        <asp:LinkButton ID="btnDownloadPortfolioResume" runat="server" CssClass="btn-portfolio-download" OnClick="btnDownloadPortfolioResume_Click">
                            <i class="fa-solid fa-download"></i> Download Resume
                        </asp:LinkButton>
                    </div>
                    <asp:Label ID="lblResumeMsg" runat="server" EnableViewState="false" style="display:block; margin-top:8px; font-size:12.5px; font-weight:600;"></asp:Label>
                </div>
            </div>

            <!-- End of container: Code Icon (GitHub) & Bag Icon (Scroll to Featured Projects) -->
            <div class="portfolio-hero-end-icons">
                <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="btn-portfolio-icon" title="GitHub / Code Profile" aria-label="GitHub Profile">
                    <i class="fa-solid fa-code"></i>
                </a>
                <button type="button" id="btnScrollToProjects" class="btn-portfolio-icon btn-portfolio-primary" title="View Featured Projects" aria-label="Featured Projects">
                    <i class="fa-solid fa-briefcase"></i>
                </button>
            </div>
        </div>

        <!-- 2-Column Grid: Left (About, Featured Projects, Contribution) + Right (Stats, Skills, Education, Certs, Internship Callout) -->
        <div class="portfolio-layout-grid">

            <!-- LEFT MAIN COLUMN -->
            <div class="portfolio-left-column">

                <!-- 1. About Me Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-regular fa-user text-primary"></i> About Me
                        </h2>
                        <button type="button" onclick="openEditPortfolioModal();" style="background:none; border:none; color:#2563eb; font-size:13px; font-weight:600; cursor:pointer;">
                            <i class="fa-regular fa-pen-to-square"></i> Edit
                        </button>
                    </div>
                    <div class="portfolio-card-body">
                        <p class="portfolio-about-text">
                            <%= !string.IsNullOrEmpty(StudentAboutMe) ? StudentAboutMe : (IsRavirajProfile ? "A passionate third-year B.Tech Computer Engineering student with a strong foundation in full-stack web development. I specialize in building robust enterprise applications using the .NET ecosystem and modern JavaScript frameworks. Driven by a desire to solve complex problems, I am actively seeking internship opportunities where I can apply my skills in building scalable architectures and intuitive user interfaces while continuing to learn from industry professionals." : "Tell recruiters about yourself, your career focus, and your passion for technology by clicking 'Edit Portfolio'.") %>
                        </p>
                    </div>
                </div>

                <!-- 2. Featured Projects Card -->
                <div class="portfolio-section-card" id="sectionFeaturedProjects">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-regular fa-folder-open text-primary"></i> Featured Projects
                        </h2>
                        <button type="button" onclick="openAddProjectModal();" class="btn-portfolio-edit" style="font-size:12px; padding:6px 14px; border-radius:6px; background:#2563eb; color:#fff; border:none; cursor:pointer;">
                            <i class="fa-solid fa-plus"></i> Add Project
                        </button>
                    </div>
                    <div class="portfolio-card-body">
                        <asp:Label ID="lblProjectStatus" runat="server" style="display:block; margin-bottom:12px; font-size:13px; font-weight:600;" EnableViewState="false" />

                        <% if (UserProjectsList != null && UserProjectsList.Count > 0) { %>
                            <div class="portfolio-projects-grid">
                                <% foreach (var proj in UserProjectsList) { %>
                                    <div class="portfolio-project-card">
                                        <div class="project-info-box" style="padding-top:16px;">
                                            <h3 class="project-title"><%= proj.Name %></h3>
                                            <p class="project-desc"><%= !string.IsNullOrEmpty(proj.Description) ? proj.Description : "No description provided." %></p>
                                            <div class="project-tags-row">
                                                <% if (proj.TechTags != null) { 
                                                       foreach (var tag in proj.TechTags) { %>
                                                           <span class="project-tag"><%= tag %></span>
                                                <%     } 
                                                   } %>
                                            </div>
                                            <div class="project-btns-row">
                                                <% if (!string.IsNullOrEmpty(proj.GithubLink)) { %>
                                                    <a href="<%= proj.GithubLink %>" target="_blank" rel="noopener noreferrer" class="btn-proj-code"><i class="fa-solid fa-code"></i> Code</a>
                                                <% } %>
                                                <% if (!string.IsNullOrEmpty(proj.LiveLink)) { %>
                                                    <a href="<%= proj.LiveLink %>" target="_blank" rel="noopener noreferrer" class="btn-proj-demo"><i class="fa-solid fa-arrow-up-right-from-square"></i> Live Demo</a>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else if (IsRavirajProfile) { %>
                            <div class="portfolio-projects-grid">
                                <!-- Project 1: SkillLinkX Career Platform -->
                                <div class="portfolio-project-card">
                                    <div class="project-thumb-box">
                                        <img src="<%= ResolveUrl("~/assets/images/Portfolio-img-1.png") %>" alt="SkillLinkX Career Platform" class="project-thumb-img" />
                                    </div>
                                    <div class="project-info-box">
                                        <h3 class="project-title">SkillLinkX Career Platform</h3>
                                        <p class="project-desc">A comprehensive career hub connecting students with recruiters. Features include AI job matching, live messaging, and analytics.</p>
                                        <div class="project-tags-row">
                                            <span class="project-tag">C#</span>
                                            <span class="project-tag">.NET Core</span>
                                            <span class="project-tag">React</span>
                                        </div>
                                        <div class="project-btns-row">
                                            <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="btn-proj-code"><i class="fa-solid fa-code"></i> Code</a>
                                            <a href="<%= ResolveUrl("~/Public/Home.aspx") %>" class="btn-proj-demo"><i class="fa-solid fa-arrow-up-right-from-square"></i> Live Demo</a>
                                        </div>
                                    </div>
                                </div>

                                <!-- Project 2: Smart Expense Tracker -->
                                <div class="portfolio-project-card">
                                    <div class="project-thumb-box">
                                        <img src="<%= ResolveUrl("~/assets/images/portfolio-img-2.jpg") %>" alt="Smart Expense Tracker" class="project-thumb-img" />
                                    </div>
                                    <div class="project-info-box">
                                        <h3 class="project-title">Smart Expense Tracker</h3>
                                        <p class="project-desc">A mobile-first progressive web app that categorizes expenses using machine learning and generates intuitive monthly reports.</p>
                                        <div class="project-tags-row">
                                            <span class="project-tag">Python</span>
                                            <span class="project-tag">Flask</span>
                                            <span class="project-tag">Vue.js</span>
                                        </div>
                                        <div class="project-btns-row">
                                            <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="btn-proj-code btn-full-width"><i class="fa-solid fa-code"></i> Code</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } else { %>
                            <div style="padding:32px 16px; text-align:center; color:#64748b; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:10px;">
                                <i class="fa-regular fa-folder-open" style="font-size:32px; color:#94a3b8; margin-bottom:8px; display:block;"></i>
                                <h4 style="font-size:15px; font-weight:600; color:#334155; margin-bottom:4px;">No Projects Added Yet</h4>
                                <p style="font-size:13px; margin:0 0 12px;">Add your personal apps, hackathon projects, or GitHub repos to showcase your skills to recruiters.</p>
                                <button type="button" onclick="openAddProjectModal();" class="btn-portfolio-edit" style="display:inline-block; font-size:13px; padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; cursor:pointer;">
                                    <i class="fa-solid fa-plus"></i> Add Your First Project
                                </button>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Add Project Modal Popup -->
                <div id="addProjectModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
                    <div style="background:#fff; border-radius:14px; max-width:520px; width:90%; padding:28px 24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative; animation:fadeIn 0.2s ease;">
                        <button type="button" onclick="closeAddProjectModal();" style="position:absolute; right:18px; top:18px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;" aria-label="Close Modal">&times;</button>
                        
                        <h3 style="margin:0 0 6px; font-size:18px; font-weight:700; color:#0f172a; display:flex; align-items:center; gap:8px;">
                            <i class="fa-solid fa-folder-plus text-primary"></i> Add Project to Portfolio
                        </h3>
                        <p style="font-size:13px; color:#64748b; margin:0 0 18px;">Showcase your personal work, repos, or live apps to recruiters.</p>

                        <asp:Label ID="lblProjectModalMsg" runat="server" style="display:block; margin-bottom:12px; font-size:13px; font-weight:600;" EnableViewState="false" />

                        <div style="display:flex; flex-direction:column; gap:12px;">
                            <div>
                                <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Project Title *</label>
                                <asp:TextBox ID="txtProjectTitle" runat="server" placeholder="e.g. AI-Powered Job Matcher" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                            </div>

                            <div>
                                <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Description</label>
                                <asp:TextBox ID="txtProjectDesc" runat="server" TextMode="MultiLine" Rows="2" placeholder="Briefly describe what this project does and problems it solves..." style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px; resize:vertical;" />
                            </div>

                            <div>
                                <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Tech Stack / Tags (Comma-separated)</label>
                                <asp:TextBox ID="txtProjectStack" runat="server" placeholder="e.g. React, Node.js, Express, MongoDB" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                            </div>

                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                                <div>
                                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">GitHub Code Link</label>
                                    <asp:TextBox ID="txtProjectGithub" runat="server" placeholder="https://github.com/..." style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                                </div>
                                <div>
                                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Live Demo Link</label>
                                    <asp:TextBox ID="txtProjectDemo" runat="server" placeholder="https://..." style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                                </div>
                            </div>
                        </div>

                        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                            <button type="button" onclick="closeAddProjectModal();" style="padding:9px 16px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                            <asp:Button ID="btnSaveProject" runat="server" Text="Save Project" OnClick="btnSaveProject_Click" style="padding:9px 20px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
                        </div>
                    </div>
                </div>

                <script>
                    function openAddProjectModal() {
                        const m = document.getElementById("addProjectModal");
                        if (m) { m.style.display = "flex"; }
                    }
                    function closeAddProjectModal() {
                        const m = document.getElementById("addProjectModal");
                        if (m) { m.style.display = "none"; }
                    }
                </script>

                <!-- 3. Contribution Activity Heatmap Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-code-commit text-primary"></i> Contribution Activity
                        </h2>
                        <span class="portfolio-stat-sub"><%= IsRavirajProfile ? "342 commits this year" : "0 contributions this year" %></span>
                    </div>
                    <div class="portfolio-card-body">
                        <!-- Simulated GitHub Contribution Heatmap Grid -->
                        <div class="contrib-scroll-wrapper">
                            <div class="contrib-heatmap-grid" id="contribHeatmap" data-has-activity="<%= IsRavirajProfile ? "true" : "false" %>">
                                <!-- Populated dynamically / styled matrix -->
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- RIGHT SIDEBAR COLUMN -->
            <div class="portfolio-right-column">

                <!-- 1. 2x2 Stats Tiles Grid -->
                <div class="portfolio-stats-2x2">
                    <!-- Metric 1: Profile Views -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-regular fa-eye"></i>
                        </div>
                        <div class="portfolio-stat-number"><%= ProfileViews %></div>
                        <div class="portfolio-stat-title">Profile Views</div>
                    </div>

                    <!-- Metric 2: Resume Downloads -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-solid fa-download"></i>
                        </div>
                        <div class="portfolio-stat-number"><%= ResumeDownloads %></div>
                        <div class="portfolio-stat-title">Resume Downloads</div>
                    </div>

                    <!-- Metric 3: Project Views -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-regular fa-hand-pointer"></i>
                        </div>
                        <div class="portfolio-stat-number"><%= ProjectViews %></div>
                        <div class="portfolio-stat-title">Project Views</div>
                    </div>

                    <!-- Metric 4: Recruiter Saves -->
                    <div class="portfolio-stat-tile">
                        <div class="portfolio-stat-icon-wrap">
                            <i class="fa-regular fa-star"></i>
                        </div>
                        <div class="portfolio-stat-number"><%= RecruiterSaves %></div>
                        <div class="portfolio-stat-title">Recruiter Saves</div>
                    </div>
                </div>

                <!-- 2. Technical Skills Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-laptop-code text-primary"></i> Technical Skills
                        </h2>
                        <button type="button" onclick="openEditPortfolioModal();" style="background:none; border:none; color:#2563eb; font-size:12px; font-weight:600; cursor:pointer;">
                            <i class="fa-regular fa-pen-to-square"></i> Edit
                        </button>
                    </div>
                    <div class="portfolio-card-body">
                        <% if (IsRavirajProfile) { %>
                            <!-- Programming Languages -->
                            <div class="skills-category-group">
                                <h4 class="skills-group-title">PROGRAMMING LANGUAGES</h4>
                                <div class="skill-progress-item">
                                    <div class="skill-name-percent">
                                        <span>C#</span>
                                        <span>85%</span>
                                    </div>
                                    <div class="skill-progress-track">
                                        <div class="skill-progress-bar" style="width: 85%;"></div>
                                    </div>
                                </div>
                                <div class="skill-progress-item">
                                    <div class="skill-name-percent">
                                        <span>Python</span>
                                        <span>70%</span>
                                    </div>
                                    <div class="skill-progress-track">
                                        <div class="skill-progress-bar" style="width: 70%;"></div>
                                    </div>
                                </div>
                                <div class="skill-progress-item">
                                    <div class="skill-name-percent">
                                        <span>Java</span>
                                        <span>60%</span>
                                    </div>
                                    <div class="skill-progress-track">
                                        <div class="skill-progress-bar" style="width: 60%;"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Web & Frameworks Pills -->
                            <div class="skills-category-group mt-3">
                                <h4 class="skills-group-title">WEB &amp; FRAMEWORKS</h4>
                                <div class="skills-pills-wrap">
                                    <span class="portfolio-skill-pill">ASP.NET MVC</span>
                                    <span class="portfolio-skill-pill">.NET Core</span>
                                    <span class="portfolio-skill-pill">JavaScript</span>
                                    <span class="portfolio-skill-pill">React</span>
                                    <span class="portfolio-skill-pill">SQL Server</span>
                                    <span class="portfolio-skill-pill">Tailwind CSS</span>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="skills-category-group">
                                <h4 class="skills-group-title">MY SKILLS</h4>
                                <div class="skills-pills-wrap">
                                    <% if (StudentSkillsList != null && StudentSkillsList.Count > 0) { 
                                           foreach(var s in StudentSkillsList) { %>
                                               <span class="portfolio-skill-pill"><%= s %></span>
                                    <%     } 
                                       } else { %>
                                           <span style="font-size:13px; color:#94a3b8; font-style:italic;">No skills added yet. Add skills in your Profile settings.</span>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- 3. Education Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-graduation-cap text-primary"></i> Education
                        </h2>
                        <button type="button" onclick="openEditPortfolioModal();" style="background:none; border:none; color:#2563eb; font-size:12px; font-weight:600; cursor:pointer;">
                            <i class="fa-regular fa-pen-to-square"></i> Edit
                        </button>
                    </div>
                    <div class="portfolio-card-body">
                        <div class="portfolio-edu-item">
                            <div class="edu-blue-dot"></div>
                            <div class="edu-content">
                                <h4 class="edu-degree"><%= StudentDegree %></h4>
                                <div class="edu-school"><%= StudentCollege %></div>
                                <div class="edu-date-badge"><%= StudentGradYear %> &bull; CGPA: <%= StudentCgpa %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 4. Certifications Card -->
                <div class="portfolio-section-card">
                    <div class="portfolio-card-header flex-between">
                        <h2 class="portfolio-card-title">
                            <i class="fa-solid fa-shield-halved text-primary"></i> Certifications
                        </h2>
                        <button type="button" onclick="openAddCertModal();" class="btn-portfolio-edit" style="font-size:12px; padding:5px 12px; border-radius:6px; background:#2563eb; color:#fff; border:none; cursor:pointer;">
                            <i class="fa-solid fa-plus"></i> Add
                        </button>
                    </div>
                    <div class="portfolio-card-body">
                        <asp:Label ID="lblCertStatus" runat="server" style="display:block; margin-bottom:10px; font-size:12.5px; font-weight:600;" EnableViewState="false" />

                        <% if (UserCertsList != null && UserCertsList.Count > 0) { %>
                            <div class="portfolio-cert-list">
                                <% foreach (var c in UserCertsList) { %>
                                    <div class="portfolio-cert-item">
                                        <div class="cert-badge-icon"><i class="fa-solid fa-award"></i></div>
                                        <div class="cert-details">
                                            <h5 class="cert-name"><%= c.CertName %></h5>
                                            <span class="cert-date"><%= c.IssuingOrg %><%= !string.IsNullOrEmpty(c.IssueDate) ? " &bull; " + c.IssueDate : "" %></span>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else if (IsRavirajProfile) { %>
                            <div class="portfolio-cert-list">
                                <div class="portfolio-cert-item">
                                    <div class="cert-badge-icon"><i class="fa-solid fa-award"></i></div>
                                    <div class="cert-details">
                                        <h5 class="cert-name">Microsoft Certified: Azure Fundamentals</h5>
                                        <span class="cert-date">Issued Jan 2023</span>
                                    </div>
                                </div>
                                <div class="portfolio-cert-item">
                                    <div class="cert-badge-icon"><i class="fa-solid fa-award"></i></div>
                                    <div class="cert-details">
                                        <h5 class="cert-name">Full Stack Web Development - Udemy</h5>
                                        <span class="cert-date">Issued Aug 2022</span>
                                    </div>
                                </div>
                            </div>
                        <% } else { %>
                            <div style="text-align:center; padding:16px 8px; color:#94a3b8; font-size:13px; font-style:italic;">
                                <i class="fa-solid fa-award" style="font-size:24px; color:#cbd5e1; display:block; margin-bottom:6px;"></i>
                                No certifications added yet. Click '+ Add' to showcase your credentials.
                            </div>
                        <% } %>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- Modals for Editing Portfolio and Adding Certifications -->
    <!-- 1. Edit Full Portfolio Modal (About Me, Skills, Education, CGPA) -->
    <div id="editPortfolioModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:14px; max-width:540px; width:92%; max-height:90vh; overflow-y:auto; padding:26px 24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeEditPortfolioModal();" style="position:absolute; right:18px; top:18px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:18px; font-weight:700; color:#0f172a;">Edit Portfolio</h3>
            <p style="font-size:13px; color:#64748b; margin:0 0 16px;">Update your About Me, Technical Skills, and Education. Changes save directly to the database.</p>
            <asp:Label ID="lblEditPortfolioMsg" runat="server" style="display:block; margin-bottom:12px; font-size:13px; font-weight:600;" EnableViewState="false" />

            <div style="display:flex; flex-direction:column; gap:12px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">About Me</label>
                    <asp:TextBox ID="txtEditAboutMe" runat="server" TextMode="MultiLine" Rows="3" placeholder="Tell recruiters about yourself and your passions..." style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px; resize:vertical;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Technical Skills (Comma-separated)</label>
                    <asp:TextBox ID="txtEditSkills" runat="server" placeholder="e.g. C#, ASP.NET, SQL Server, React, JavaScript" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">College / University</label>
                        <asp:TextBox ID="txtEditCollege" runat="server" placeholder="e.g. Gujarat Technological University" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Degree</label>
                        <asp:TextBox ID="txtEditDegree" runat="server" placeholder="e.g. B.Tech Computer Engineering" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                </div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Graduation Year</label>
                        <asp:TextBox ID="txtEditGradYear" runat="server" placeholder="e.g. 2021 - 2025" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                    <div>
                        <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">CGPA / Grade</label>
                        <asp:TextBox ID="txtEditCgpa" runat="server" placeholder="e.g. 8.8" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                    </div>
                </div>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <button type="button" onclick="closeEditPortfolioModal();" style="padding:9px 16px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSavePortfolioEdit" runat="server" Text="Save Changes" OnClick="btnSavePortfolioEdit_Click" style="padding:9px 20px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <!-- 2. Add Certification Modal -->
    <div id="addCertModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:14px; max-width:480px; width:90%; padding:26px 24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeAddCertModal();" style="position:absolute; right:18px; top:18px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 style="margin:0 0 6px; font-size:18px; font-weight:700; color:#0f172a;">Add Certification</h3>
            <p style="font-size:13px; color:#64748b; margin:0 0 16px;">Add certifications or licenses to show proof of skill.</p>
            <asp:Label ID="lblCertModalMsg" runat="server" style="display:block; margin-bottom:12px; font-size:13px; font-weight:600;" EnableViewState="false" />

            <div style="display:flex; flex-direction:column; gap:12px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Certification Title *</label>
                    <asp:TextBox ID="txtCertName" runat="server" placeholder="e.g. AWS Certified Solutions Architect" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Issuing Organization</label>
                    <asp:TextBox ID="txtCertOrg" runat="server" placeholder="e.g. Amazon Web Services, Microsoft, Coursera" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Issue Date / Year</label>
                    <asp:TextBox ID="txtCertDate" runat="server" placeholder="e.g. Issued Jan 2024" style="width:100%; padding:9px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <button type="button" onclick="closeAddCertModal();" style="padding:9px 16px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveCert" runat="server" Text="Save Certification" OnClick="btnSaveCert_Click" style="padding:9px 20px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openEditPortfolioModal() {
            var m = document.getElementById("editPortfolioModal");
            if (m) {
                // Pre-fill existing values
                var txtAbout = document.getElementById("<%= txtEditAboutMe.ClientID %>");
                if (txtAbout && !txtAbout.value) {
                    txtAbout.value = "<%= System.Web.HttpUtility.JavaScriptStringEncode(StudentAboutMe) %>";
                }
                var txtSk = document.getElementById("<%= txtEditSkills.ClientID %>");
                if (txtSk && !txtSk.value) {
                    txtSk.value = "<%= System.Web.HttpUtility.JavaScriptStringEncode(string.Join(", ", StudentSkillsList)) %>";
                }
                var txtClg = document.getElementById("<%= txtEditCollege.ClientID %>");
                if (txtClg && !txtClg.value) {
                    txtClg.value = "<%= System.Web.HttpUtility.JavaScriptStringEncode(StudentCollege) %>";
                }
                var txtDeg = document.getElementById("<%= txtEditDegree.ClientID %>");
                if (txtDeg && !txtDeg.value) {
                    txtDeg.value = "<%= System.Web.HttpUtility.JavaScriptStringEncode(StudentDegree) %>";
                }
                var txtYr = document.getElementById("<%= txtEditGradYear.ClientID %>");
                if (txtYr && !txtYr.value) {
                    txtYr.value = "<%= System.Web.HttpUtility.JavaScriptStringEncode(StudentGradYear) %>";
                }
                var txtC = document.getElementById("<%= txtEditCgpa.ClientID %>");
                if (txtC && !txtC.value) {
                    txtC.value = "<%= System.Web.HttpUtility.JavaScriptStringEncode(StudentCgpa) %>";
                }
                m.style.display = "flex";
            }
        }
        function closeEditPortfolioModal() {
            var m = document.getElementById("editPortfolioModal");
            if (m) m.style.display = "none";
        }
        function openAddCertModal() {
            var m = document.getElementById("addCertModal");
            if (m) m.style.display = "flex";
        }
        function closeAddCertModal() {
            var m = document.getElementById("addCertModal");
            if (m) m.style.display = "none";
        }
    </script>
</asp:Content>
