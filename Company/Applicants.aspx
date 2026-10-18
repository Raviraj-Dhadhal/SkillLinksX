<%@ Page Title="Applicants - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Applicants.aspx.cs" Inherits="SkillLinksX.Company.Applicants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Applicants Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="applicants-page-container">

        <!-- Header -->
        <div class="applicants-header">
            <h1 class="applicants-title">Applicants</h1>
            <p class="applicants-sub">Review and manage candidates who applied to your opportunities.</p>
        </div>

        <!-- 6 Metrics Cards Grid (Scrollable on mobile) -->
        <div class="applicants-metrics-grid">
            <div class="applicants-metric-card">
                <div class="app-metric-label">TOTAL</div>
                <div class="app-metric-value">1,248</div>
            </div>
            <div class="applicants-metric-card highlight-new">
                <div class="app-metric-label">NEW</div>
                <div class="app-metric-value color-blue">84</div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">UNDER REVIEW</div>
                <div class="app-metric-value">312</div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">SHORTLISTED</div>
                <div class="app-metric-value">156</div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">INTERVIEW</div>
                <div class="app-metric-value">42</div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">SELECTED</div>
                <div class="app-metric-value">18</div>
            </div>
        </div>

        <!-- Main Workspace Split Layout: Table (Left) + Candidate Quick View Panel (Right) -->
        <div class="applicants-workspace-layout">

            <!-- Left: Table & Filter Controls Container -->
            <div class="applicants-table-card">
                
                <!-- Filter Bar -->
                <div class="applicants-filters-bar">
                    <div class="filter-opp-select-wrapper">
                        <select class="app-filter-select">
                            <option>All Opportunities</option>
                            <option>Software Developer</option>
                            <option>Frontend Developer Intern</option>
                            <option>UI/UX Designer</option>
                        </select>
                    </div>

                    <div class="app-search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" placeholder="Name or skill..." />
                    </div>

                    <div class="app-action-buttons-group">
                        <button type="button" class="btn-app-secondary">
                            <i class="fa-solid fa-sliders"></i> Filters
                        </button>
                        <button type="button" class="btn-app-primary">Shortlist Selected</button>
                        <button type="button" class="btn-app-danger">Reject</button>
                        <button type="button" class="btn-app-icon" title="Message Selected">
                            <i class="fa-regular fa-message"></i>
                        </button>
                        <button type="button" class="btn-app-icon" title="Export / Download">
                            <i class="fa-solid fa-download"></i>
                        </button>
                    </div>
                </div>

                <!-- Applicants Table -->
                <div class="app-table-scroll-wrapper" style="overflow-x: auto;">
                    <table class="applicants-data-table">
                        <thead>
                            <tr>
                                <th style="width: 40px;">
                                    <input type="checkbox" class="app-chk" id="chkSelectAll" />
                                </th>
                                <th>CANDIDATE</th>
                                <th>APPLIED FOR</th>
                                <th>AI MATCH</th>
                                <th>STATUS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Candidate Row 1: Vivek Gupta (Selected / Focused) -->
                            <tr class="candidate-row selected-row" data-candidate-name="Vivek Gupta" data-candidate-role="Software Developer" data-candidate-match="94%" data-candidate-status="New" data-candidate-edu="IIT Bombay" data-candidate-degree="B.Tech in Computer Science" data-candidate-img="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" data-profile-url="<%= ResolveUrl("~/Company/CandidateProfile.aspx") %>">
                                <td>
                                    <input type="checkbox" class="app-chk" checked="checked" />
                                </td>
                                <td>
                                    <div class="candidate-cell-flex">
                                        <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Vivek Gupta" class="candidate-table-avatar" />
                                        <div class="candidate-meta-text">
                                            <span class="candidate-cell-name">Vivek Gupta</span>
                                            <span class="candidate-cell-sub">Bengaluru, India</span>
                                        </div>
                                    </div>
                                </td>
                                <td class="candidate-role-text">Software Developer</td>
                                <td>
                                    <span class="ai-match-badge match-high">
                                        <i class="fa-solid fa-wand-magic-sparkles"></i> 94%
                                    </span>
                                </td>
                                <td>
                                    <span class="app-status-pill status-pill-new">New</span>
                                </td>
                            </tr>

                            <!-- Candidate Row 2: Priya Sharma -->
                            <tr class="candidate-row" data-candidate-name="Priya Sharma" data-candidate-role="Frontend Developer Intern" data-candidate-match="88%" data-candidate-status="Under Review" data-candidate-edu="NIT Surat" data-candidate-degree="B.Tech in Information Technology" data-candidate-img="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" data-profile-url="<%= ResolveUrl("~/Company/CandidateProfile.aspx") %>">
                                <td>
                                    <input type="checkbox" class="app-chk" />
                                </td>
                                <td>
                                    <div class="candidate-cell-flex">
                                        <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Priya Sharma" class="candidate-table-avatar" style="object-position: 50% 10%; object-fit: cover;" />
                                        <div class="candidate-meta-text">
                                            <span class="candidate-cell-name">Priya Sharma</span>
                                            <span class="candidate-cell-sub">Mumbai, India</span>
                                        </div>
                                    </div>
                                </td>
                                <td class="candidate-role-text">Frontend Developer Intern</td>
                                <td>
                                    <span class="ai-match-badge match-high">
                                        <i class="fa-solid fa-wand-magic-sparkles"></i> 88%
                                    </span>
                                </td>
                                <td>
                                    <span class="app-status-pill status-pill-review">Under Review</span>
                                </td>
                            </tr>

                            <!-- Candidate Row 3: Rahul Verma -->
                            <tr class="candidate-row" data-candidate-name="Rahul Verma" data-candidate-role="UI/UX Designer" data-candidate-match="91%" data-candidate-status="Shortlisted" data-candidate-edu="NID Ahmedabad" data-candidate-degree="Master of Design" data-candidate-img="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" data-profile-url="<%= ResolveUrl("~/Company/CandidateProfile.aspx") %>">
                                <td>
                                    <input type="checkbox" class="app-chk" />
                                </td>
                                <td>
                                    <div class="candidate-cell-flex">
                                        <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Rahul Verma" class="candidate-table-avatar" />
                                        <div class="candidate-meta-text">
                                            <span class="candidate-cell-name">Rahul Verma</span>
                                            <span class="candidate-cell-sub">Pune, India</span>
                                        </div>
                                    </div>
                                </td>
                                <td class="candidate-role-text">UI/UX Designer</td>
                                <td>
                                    <span class="ai-match-badge match-high">
                                        <i class="fa-solid fa-wand-magic-sparkles"></i> 91%
                                    </span>
                                </td>
                                <td>
                                    <span class="app-status-pill status-pill-shortlisted">Shortlisted</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Bottom Pagination Bar -->
                <div class="table-pagination-row">
                    <span style="font-size: 12px; color: #64748B;">Showing 1-10 of 1,248</span>
                    <div class="pagination-controls">
                        <a href="#" class="pagination-nav-btn" aria-label="Previous Page">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                        <a href="#" class="pagination-nav-btn" aria-label="Next Page">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>
                </div>

            </div>

            <!-- Right: Candidate Quick Profile Card (As shown in Figma) -->
            <div class="candidate-preview-panel" id="candidatePreviewCard">
                <div class="candidate-preview-top">
                    <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Candidate" class="preview-avatar-img" id="quickAvatar" />
                    <h3 class="preview-candidate-name" id="quickName">Raviraj Dhadhal</h3>
                    <p class="preview-candidate-role" id="quickRole">Software Developer</p>
                    
                    <div class="preview-action-row">
                        <a href="<%= ResolveUrl("~/Company/CandidateProfile.aspx") %>" class="btn-view-full-profile" id="quickViewProfileBtn">View Full Profile</a>
                    </div>
                </div>

                <div class="preview-divider"></div>

                <!-- AI Match Insights Box -->
                <div class="preview-section">
                    <div class="preview-section-title">AI MATCH INSIGHTS</div>
                    <div class="ai-match-card-callout">
                        <div class="match-score-radial-box">
                            <span class="score-circle-number" id="quickScore">94%</span>
                        </div>
                        <div class="match-insights-meta">
                            <div class="match-badge-title">Excellent Match</div>
                            <div class="match-badge-sub">Strong overlap in React &amp; Node.js.</div>
                        </div>
                    </div>
                </div>

                <div class="preview-divider"></div>

                <!-- Education -->
                <div class="preview-section">
                    <div class="preview-section-title">EDUCATION</div>
                    <div class="preview-edu-item">
                        <div class="edu-icon-box">
                            <i class="fa-solid fa-graduation-cap"></i>
                        </div>
                        <div>
                            <div class="preview-edu-school" id="quickEdu">IIT Bombay</div>
                            <div class="preview-edu-sub" id="quickDegree">B.Tech in Computer Science</div>
                        </div>
                    </div>
                </div>

                <div class="preview-divider"></div>

                <!-- Top Skills -->
                <div class="preview-section">
                    <div class="preview-section-title">TOP SKILLS</div>
                    <div class="preview-skills-pills">
                        <span class="preview-skill-pill">React</span>
                        <span class="preview-skill-pill">Node.js</span>
                        <span class="preview-skill-pill">TypeScript</span>
                        <span class="preview-skill-pill">C#</span>
                        <span class="preview-skill-pill">SQL</span>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
