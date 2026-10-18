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
            <span class="breadcrumb-current">Software Developer</span>
        </div>

        <!-- Header Card -->
        <div class="job-header-card">
            <div class="job-header-top-flex flex-between">
                <div class="job-header-left-brand">
                    <div class="job-header-avatar">
                        <img src="<%= ResolveUrl("~/assets/images/techflow-logo.svg") %>" alt="TechFlow" class="job-brand-logo-img" />
                    </div>
                    <div class="job-header-titles">
                        <div class="job-title-badge-row">
                            <h1 class="job-main-title">.Net Developer</h1>
                            <span class="badge-actively-hiring">ACTIVELY HIRING</span>
                        </div>
                        <div class="job-header-subline">
                            <span class="job-company-name">TechFlow Mumbai</span> &bull; 
                            <span class="job-location-name">Ahmedabad, Gujarat</span>
                        </div>
                        <div class="job-meta-chips-row">
                            <span><i class="fa-solid fa-briefcase"></i> 0&ndash;2 Yrs</span>
                            <span><i class="fa-solid fa-indian-rupee-sign"></i> &#8377;4.5L &ndash; &#8377;7L / yr</span>
                            <span><i class="fa-solid fa-location-dot"></i> Mumbai</span>
                            <span><i class="fa-regular fa-clock"></i> Posted 2 days ago</span>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons: Apply Now, Save, Share -->
                <div class="job-header-actions-group">
                    <button type="button" class="btn-job-apply-primary" onclick="alert('Application submitted successfully!');">
                        Apply Now <i class="fa-solid fa-arrow-right"></i>
                    </button>
                    <button type="button" class="btn-job-action-box" title="Save Job">
                        <i class="fa-regular fa-bookmark"></i> Save
                    </button>
                    <button type="button" class="btn-job-action-box" title="Share Job">
                        <i class="fa-solid fa-share-nodes"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- 2-Column Grid: Left Content + Right Company & Application Cards -->
        <div class="job-body-grid">

            <!-- Left Main Column -->
            <div class="job-body-main-col">

                <!-- 1. Your AI Career Match Card (Soft Gradient) -->
                <div class="job-ai-match-card">
                    <div class="ai-match-score-left">
                        <div class="ai-circle-score">
                            <span class="ai-score-txt">92%</span>
                        </div>
                    </div>
                    <div class="ai-match-content-right">
                        <div class="ai-match-headline">
                            <i class="fa-solid fa-sparkles"></i> Your AI Career Match
                        </div>
                        <p class="ai-match-blurb">
                            Your strong foundation in the .NET ecosystem and SQL makes you a top candidate for this role.
                        </p>
                        <div class="ai-match-skill-chips">
                            <span class="ai-chip-pill chip-green"><i class="fa-solid fa-check"></i> C#</span>
                            <span class="ai-chip-pill chip-green"><i class="fa-solid fa-check"></i> ASP.NET</span>
                            <span class="ai-chip-pill chip-green"><i class="fa-solid fa-check"></i> SQL</span>
                            <span class="ai-chip-pill chip-red"><i class="fa-solid fa-xmark"></i> Docker</span>
                        </div>
                        <a href="javascript:void(0);" class="ai-match-improve-link">Improve My Match &rarr;</a>
                    </div>
                </div>

                <!-- 2. About the Job Card -->
                <div class="job-section-card">
                    <div class="job-card-section-block">
                        <h2 class="job-section-heading">About the Job</h2>
                        <p class="job-desc-paragraph">
                            TechFlow is seeking a highly motivated Software Developer to join our core product team in Ahmedabad. In this role, you will be instrumental in designing, building, and maintaining high-performance, reusable, and reliable code for our enterprise SaaS platforms.
                        </p>
                        <p class="job-desc-paragraph">
                            We are looking for someone who is passionate about clean code, enjoys solving complex problems, and thrives in a collaborative, agile environment. You will work closely with product managers and other engineers to deliver features that directly impact our growing client base.
                        </p>
                    </div>

                    <!-- Responsibilities -->
                    <div class="job-card-section-block">
                        <h3 class="job-sub-heading">Responsibilities</h3>
                        <ul class="job-arrow-bullets">
                            <li>Develop and maintain scalable web applications using C# and .NET Core.</li>
                            <li>Collaborate with cross-functional teams to define, design, and ship new features.</li>
                            <li>Identify bottlenecks and bugs, and devise solutions to mitigate and address these issues.</li>
                            <li>Participate in code reviews to ensure code quality and adherence to best practices.</li>
                            <li>Write unit and integration tests to ensure robustness and reliability.</li>
                        </ul>
                    </div>

                    <!-- Requirements -->
                    <div class="job-card-section-block">
                        <h3 class="job-sub-heading">Requirements</h3>
                        <div class="req-tech-skills-title">Technical Skills</div>
                        <div class="req-skills-tags-row">
                            <span class="req-skill-pill">C#</span>
                            <span class="req-skill-pill">.NET Core</span>
                            <span class="req-skill-pill">SQL Server</span>
                            <span class="req-skill-pill">JavaScript</span>
                            <span class="req-skill-pill">RESTful APIs</span>
                        </div>

                        <!-- 2 Sub Cards: Education + Experience -->
                        <div class="req-cards-2grid">
                            <div class="req-sub-card">
                                <i class="fa-solid fa-graduation-cap req-card-icon"></i>
                                <div class="req-card-info">
                                    <span class="req-card-label">Education</span>
                                    <p class="req-card-desc">B.Tech / B.E. in Computer Science, IT, or related field.</p>
                                </div>
                            </div>
                            <div class="req-sub-card">
                                <i class="fa-solid fa-briefcase req-card-icon"></i>
                                <div class="req-card-info">
                                    <span class="req-card-label">Experience</span>
                                    <p class="req-card-desc">0 - 2 years of professional software development experience.</p>
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
                                <span class="perk-tile-title">Health Insurance</span>
                            </div>
                            <div class="perk-tile">
                                <div class="perk-icon-wrap"><i class="fa-solid fa-laptop-house"></i></div>
                                <span class="perk-tile-title">Flexible Work</span>
                            </div>
                            <div class="perk-tile">
                                <div class="perk-icon-wrap"><i class="fa-solid fa-award"></i></div>
                                <span class="perk-tile-title">L&amp;D Budget</span>
                            </div>
                            <div class="perk-tile">
                                <div class="perk-icon-wrap"><i class="fa-solid fa-plane-departure"></i></div>
                                <span class="perk-tile-title">Paid Time Off</span>
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
                            <img src="<%= ResolveUrl("~/assets/images/techflow-logo.svg") %>" alt="TechFlow" class="side-company-img" />
                        </div>
                        <div class="side-company-meta">
                            <h4 class="side-company-name">TechFlow Mumbai</h4>
                            <a href="javascript:void(0);" class="side-company-link">View Profile</a>
                        </div>
                    </div>
                    <p class="side-company-desc">
                        TechFlow is a leading provider of innovative software solutions for the financial sector, empowering businesses with robust and scalable tools.
                    </p>
                    <div class="side-meta-list">
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-solid fa-building"></i> Industry</span>
                            <span class="side-meta-val">Software &amp; IT</span>
                        </div>
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-solid fa-users"></i> Company Size</span>
                            <span class="side-meta-val">50-200</span>
                        </div>
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-regular fa-calendar"></i> Founded</span>
                            <span class="side-meta-val">2015</span>
                        </div>
                        <div class="side-meta-row">
                            <span class="side-meta-label"><i class="fa-solid fa-globe"></i> Website</span>
                            <a href="https://techflow.in" target="_blank" rel="noopener noreferrer" class="side-meta-link">techflow.in</a>
                        </div>
                    </div>
                </div>

                <!-- 2. Application Details Card -->
                <div class="job-side-card">
                    <h3 class="side-card-title">Application Details</h3>
                    <div class="app-details-list">
                        <div class="app-detail-item">
                            <div class="app-detail-icon"><i class="fa-regular fa-calendar"></i></div>
                            <div class="app-detail-content">
                                <span class="app-detail-label">Deadline</span>
                                <span class="app-detail-val">October 30, 2023</span>
                            </div>
                        </div>
                        <div class="app-detail-item">
                            <div class="app-detail-icon"><i class="fa-solid fa-user-group"></i></div>
                            <div class="app-detail-content">
                                <span class="app-detail-label">Applicants</span>
                                <span class="app-detail-val">124 people applied</span>
                            </div>
                        </div>
                        <div class="app-detail-item">
                            <div class="app-detail-icon"><i class="fa-solid fa-layer-group"></i></div>
                            <div class="app-detail-content">
                                <span class="app-detail-label">Hiring Process</span>
                                <span class="app-detail-val">3 Stages (Resume, Tech Assessment, Interview)</span>
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
