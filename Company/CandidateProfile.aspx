<%@ Page Title="Candidate Profile - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="CandidateProfile.aspx.cs" Inherits="SkillLinksX.Company.CandidateProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Candidate Profile Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="candidate-profile-page-container">

        <!-- Top Breadcrumb -->
        <div class="cand-breadcrumb-row">
            <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="cand-back-link">
                <i class="fa-solid fa-arrow-left"></i> Back to Applicants
            </a>
            <span class="cand-bread-sep">/</span>
            <span class="cand-bread-current">Candidate Profile</span>
        </div>

        <!-- Hero Card -->
        <div class="cand-hero-card">
            <div class="cand-hero-left">
                <div class="cand-hero-avatar-wrap">
                    <% if (!string.IsNullOrEmpty(CandidatePhotoUrl)) { %>
                        <img src="<%= ResolveUrl(CandidatePhotoUrl) %>" alt="<%= CandidateName %>" class="cand-hero-avatar-img" style="width:84px; height:84px; border-radius:50%; object-fit:cover; border:3px solid #fff; box-shadow:0 2px 8px rgba(0,0,0,0.08);" />
                    <% } else { %>
                        <span class="cand-hero-avatar-img" style="width:84px; height:84px; border-radius:50%; background:#f1f5f9; display:flex; align-items:center; justify-content:center; color:#64748b; font-size:36px; border:3px solid #fff; box-shadow:0 2px 8px rgba(0,0,0,0.08);">
                            <i class="fa-regular fa-user"></i>
                        </span>
                    <% } %>
                    <span class="cand-open-badge"><i class="fa-solid fa-circle"></i> <%= ApplicationStatus.Equals("Selected", StringComparison.OrdinalIgnoreCase) ? "Hired / Team" : "Open to Work" %></span>
                </div>
                <div class="cand-hero-info">
                    <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                        <h1 class="cand-hero-name" style="margin:0;"><%= CandidateName %></h1>
                        <span style="display:inline-flex; align-items:center; padding:3px 10px; border-radius:12px; font-size:12px; font-weight:600; <%= ApplicationStatus.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase) ? "background:#dbeafe; color:#1d4ed8; border:1px solid #bfdbfe;" : (ApplicationStatus.Equals("Selected", StringComparison.OrdinalIgnoreCase) ? "background:#dcfce7; color:#15803d; border:1px solid #bbf7d0;" : (ApplicationStatus.Equals("Rejected", StringComparison.OrdinalIgnoreCase) ? "background:#fee2e2; color:#b91c1c; border:1px solid #fca5a5;" : "background:#f1f5f9; color:#475569; border:1px solid #e2e8f0;")) %>">
                            Status: <%= ApplicationStatus %>
                        </span>
                    </div>
                    <div class="cand-hero-title"><%= CandidateTitle %></div>
                    <div class="cand-hero-meta-row">
                        <span><i class="fa-solid fa-location-dot"></i> <%= CandidateCity %></span>
                        <span><i class="fa-solid fa-envelope"></i> <%= CandidateEmail %></span>
                        <span><i class="fa-solid fa-graduation-cap"></i> <%= CandidateCollege %></span>
                    </div>
                    <div class="cand-hero-cta-buttons" style="display:flex; flex-wrap:wrap; gap:8px; align-items:center; margin-top:12px;">
                        <a href='<%= ResolveUrl("~/Company/Messages.aspx?cid=" + StudentId) %>' class="btn-cand-msg" style="text-decoration:none; background:#2563eb; color:#fff;">
                            <i class="fa-regular fa-comment-dots"></i> Message
                        </a>
                        <a href='<%= ResolveUrl("~/Company/Interviews.aspx?candId=" + StudentId + "&name=" + Server.UrlEncode(CandidateName) + "&role=" + Server.UrlEncode(TargetRoleName)) %>' class="btn-cand-schedule" style="text-decoration:none; background:#10b981; color:#fff; border:1px solid #10b981; display:inline-flex; align-items:center; gap:6px;">
                            <i class="fa-regular fa-calendar-check"></i> Schedule Interview
                        </a>
                        <% if (!ApplicationStatus.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase) && !ApplicationStatus.Equals("Selected", StringComparison.OrdinalIgnoreCase)) { %>
                            <asp:Button ID="btnShortlistCandidate" runat="server" Text="Shortlist Candidate" CssClass="btn-cand-schedule" OnClick="btnShortlistCandidate_Click" />
                        <% } else { %>
                            <span style="display:inline-flex; align-items:center; gap:5px; padding:8px 14px; border-radius:6px; font-size:13px; font-weight:600; background:#dbeafe; color:#1d4ed8; border:1px solid #bfdbfe;">
                                <i class="fa-solid fa-check"></i> Shortlisted
                            </span>
                        <% } %>
                        <asp:LinkButton ID="btnSelectCandidate" runat="server" OnClick="btnSelectCandidate_Click" style="text-decoration:none; display:inline-flex; align-items:center; gap:5px; padding:8px 14px; border-radius:6px; font-size:13px; font-weight:600; background:#dcfce7; color:#15803d; border:1px solid #bbf7d0;" ToolTip="Mark as Selected / Hired into Team">
                            <i class="fa-solid fa-award"></i> Select
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnRejectCandidate" runat="server" OnClick="btnRejectCandidate_Click" style="text-decoration:none; display:inline-flex; align-items:center; gap:5px; padding:8px 12px; border-radius:6px; font-size:13px; font-weight:600; background:#fef2f2; color:#dc2626; border:1px solid #fecaca;" ToolTip="Reject candidate">
                            Reject
                        </asp:LinkButton>
                        <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="btn-cand-msg" style="text-decoration: none;">
                            <i class="fa-solid fa-list-check"></i> Manage Applicants
                        </a>
                    </div>
                    <asp:Label ID="lblActionStatus" runat="server" ForeColor="Green" style="margin-top: 8px; display:block; font-size:12.5px; font-weight:600;" EnableViewState="false" />
                </div>
            </div>

            <div class="cand-hero-right">
                <div class="cand-ai-match-hero-chip">
                    <div class="ai-circle-score-wrap">
                        <div class="ai-circle-score-val"><%= CandidateMatchScore %>%</div>
                    </div>
                    <div class="ai-circle-score-text">
                        <div class="ai-score-top-label">AI Match Score</div>
                        <div class="ai-score-for-role">Job Overlap</div>
                    </div>
                </div>
                <div style="text-align: right; margin-top: 14px;">
                    <asp:LinkButton ID="btnViewResume" runat="server" OnClick="btnViewResume_Click" CssClass="cand-download-resume-link">
                        <i class="fa-solid fa-file-pdf"></i> View Resume
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <!-- 2-Column Content Layout: Left (Main Details) + Right (AI Analysis & Side Cards) -->
        <div class="cand-layout-2col">
            
            <!-- Left Main Column -->
            <div class="cand-main-col">

                <!-- 1. Professional Summary -->
                <div class="cand-section-card">
                    <h2 class="cand-section-title">
                        <i class="fa-regular fa-user"></i> Professional Summary
                    </h2>
                    <p class="cand-summary-text">
                        <%= !string.IsNullOrEmpty(CandidateBio) ? CandidateBio : "No professional summary provided by the candidate." %>
                    </p>
                </div>

                <!-- 2. Skills Matrix -->
                <div class="cand-section-card">
                    <div class="skills-matrix-header">
                        <h2 class="cand-section-title" style="margin-bottom: 0;">
                            <i class="fa-solid fa-code"></i> Skills Matrix
                        </h2>
                    </div>

                    <div class="skill-category-group">
                        <div class="skill-group-name">VERIFIED &amp; LISTED SKILLS</div>
                        <div class="skill-tags-flex">
                            <asp:Repeater ID="rptCandidateSkills" runat="server">
                                <ItemTemplate>
                                    <span class="skill-pill-dot level-expert"><%# Container.DataItem %> <span class="dot-indicator"></span></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <!-- 3. Experience & Education Timeline -->
                <div class="cand-section-card">
                    <h2 class="cand-section-title">
                        <i class="fa-solid fa-briefcase"></i> Experience &amp; Education
                    </h2>

                    <div class="timeline-container">
                        <% if (!string.IsNullOrEmpty(CandidateExperience)) { %>
                        <div class="timeline-item">
                            <div class="timeline-bullet"></div>
                            <div class="timeline-item-header">
                                <div>
                                    <h3 class="timeline-role-title">Professional Experience</h3>
                                    <div class="timeline-company-name"><%= CandidateExperience %></div>
                                </div>
                                <span class="timeline-date-badge">Experienced</span>
                            </div>
                        </div>
                        <% } %>

                        <asp:Repeater ID="rptCandidateEdu" runat="server">
                            <ItemTemplate>
                                <div class="timeline-item">
                                    <div class="timeline-bullet bullet-edu"></div>
                                    <div class="timeline-item-header">
                                        <div>
                                            <h3 class="timeline-role-title"><%# Eval("DegreeName") %></h3>
                                            <div class="timeline-company-name"><%# Eval("SchoolName") %></div>
                                        </div>
                                        <span class="timeline-date-badge"><%# Eval("GradYear") %></span>
                                    </div>
                                    <%# !string.IsNullOrEmpty(Eval("Cgpa")?.ToString()) ? "<div class=\"timeline-cgpa\">CGPA / Score: " + Eval("Cgpa") + "</div>" : "" %>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <% if (EducationList.Count == 0 && string.IsNullOrEmpty(CandidateExperience)) { %>
                            <p style="color:#94a3b8; font-size:13px; margin:8px 0;">No education or experience details provided yet.</p>
                        <% } %>
                    </div>
                </div>

                <!-- 4. Portfolio & Projects -->
                <div class="cand-section-card">
                    <h2 class="cand-section-title">
                        <i class="fa-regular fa-folder-open"></i> Portfolio &amp; Projects
                    </h2>

                    <div class="projects-cards-grid">
                        <asp:Repeater ID="rptCandidateProjects" runat="server">
                            <ItemTemplate>
                                <div class="project-box-card">
                                    <div class="project-top-row">
                                        <h3 class="project-card-title"><%# Eval("ProjectName") %></h3>
                                        <%# !string.IsNullOrEmpty(Eval("LinkUrl")?.ToString()) ? "<a href=\"" + Eval("LinkUrl") + "\" target=\"_blank\"><i class=\"fa-solid fa-arrow-up-right-from-square project-link-icon\"></i></a>" : "<i class=\"fa-solid fa-code project-link-icon\"></i>" %>
                                    </div>
                                    <p class="project-card-desc">
                                        <%# Eval("Description") %>
                                    </p>
                                    <div class="project-tags-row">
                                        <%# string.Join("", ((System.Collections.Generic.List<string>)Eval("TechTags")).Select(t => "<span class=\"proj-tag\">" + t + "</span>")) %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <% if (ProjectsList.Count == 0) { %>
                            <p style="color:#94a3b8; font-size:13px; margin:8px 0;">No portfolio projects listed yet.</p>
                        <% } %>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar Column -->
            <div class="cand-sidebar-col">
                
                <!-- 1. AI Match Analysis Card -->
                <div class="cand-sidebar-card ai-analysis-card">
                    <div class="ai-analysis-header">
                        <i class="fa-solid fa-wand-magic-sparkles"></i>
                        <span class="ai-analysis-title">AI Match Analysis</span>
                    </div>
                    <div class="ai-target-role">Target Role: <%= TargetRoleName %></div>

                    <div class="ai-big-score-row">
                        <span class="big-score-number"><%= CandidateMatchScore %>%</span>
                        <span class="match-quality-pill"><%= CandidateMatchScore >= 80 ? "Excellent Fit" : (CandidateMatchScore >= 60 ? "Good Match" : "Moderate Fit") %></span>
                    </div>

                    <!-- Progress Bars -->
                    <div class="ai-score-bar-group">
                        <div class="bar-label-row">
                            <span>Skills Match</span>
                            <strong><%= SkillsMatchPct %>%</strong>
                        </div>
                        <div class="cand-progress-track">
                            <div class="cand-progress-fill" style='width: <%= SkillsMatchPct %>%;'></div>
                        </div>
                    </div>

                    <div class="ai-score-bar-group">
                        <div class="bar-label-row">
                            <span>Experience Match</span>
                            <strong><%= ExperienceMatchPct %>%</strong>
                        </div>
                        <div class="cand-progress-track">
                            <div class="cand-progress-fill" style='width: <%= ExperienceMatchPct %>%;'></div>
                        </div>
                    </div>

                    <div class="ai-score-bar-group">
                        <div class="bar-label-row">
                            <span>Education Match</span>
                            <strong><%= EducationMatchPct %>%</strong>
                        </div>
                        <div class="cand-progress-track">
                            <div class="cand-progress-fill" style='width: <%= EducationMatchPct %>%;'></div>
                        </div>
                    </div>

                    <div class="ai-analysis-divider"></div>

                    <!-- Key Matching Skills -->
                    <div class="ai-sub-block">
                        <div class="ai-sub-title">
                            <i class="fa-regular fa-circle-check text-green"></i> Key Matching Skills
                        </div>
                        <div class="ai-skills-chips">
                            <asp:Repeater ID="rptKeyMatchingSkills" runat="server">
                                <ItemTemplate>
                                    <span class="ai-skill-chip-green"><%# Container.DataItem %></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <!-- Missing/Weak Skills -->
                    <div class="ai-sub-block" style="margin-top: 14px;">
                        <div class="ai-sub-title">
                            <i class="fa-regular fa-circle-xmark text-red"></i> Missing/Weak Skills
                        </div>
                        <div class="ai-skills-chips">
                            <asp:Repeater ID="rptMissingSkills" runat="server">
                                <ItemTemplate>
                                    <span class="ai-skill-chip-orange"><%# Container.DataItem %></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <!-- 2. Candidate Preferences -->
                <div class="cand-sidebar-card">
                    <h3 class="cand-sidebar-card-title">
                        <i class="fa-solid fa-sliders"></i> Candidate Preferences
                    </h3>

                    <div class="cand-pref-list">
                        <div class="cand-pref-row">
                            <span class="pref-label">Preferred Roles</span>
                            <span class="pref-value"><%= PreferredRoles %></span>
                        </div>
                        <div class="cand-pref-row">
                            <span class="pref-label">Expected Salary</span>
                            <span class="pref-value"><%= ExpectedSalary %></span>
                        </div>
                        <div class="cand-pref-row">
                            <span class="pref-label">Notice Period</span>
                            <span class="pref-badge-pill"><%= NoticePeriod %></span>
                        </div>
                        <div class="cand-pref-row">
                            <span class="pref-label">Work Mode</span>
                            <span class="pref-value"><%= WorkMode %></span>
                        </div>
                    </div>
                </div>

                <!-- 3. Private Team Notes -->
                <div class="cand-sidebar-card">
                    <h3 class="cand-sidebar-card-title">
                        <i class="fa-regular fa-note-sticky"></i> Private Team Notes
                    </h3>

                    <% if (!string.IsNullOrEmpty(CandidateTeamNote)) { %>
                        <div class="team-note-bubble">
                            <div class="team-note-header">
                                <span class="note-author"><%= NoteAuthorName %> (You)</span>
                                <span class="note-time"><%= NoteUpdatedAt %></span>
                            </div>
                            <p class="note-content">
                                <%= CandidateTeamNote %>
                            </p>
                        </div>
                    <% } else { %>
                        <div class="team-note-bubble" style="background:#f8fafc; border-left:3px solid #cbd5e1;">
                            <p class="note-content" style="color:#64748b; font-style:italic; margin:0;">
                                No private team notes added yet. Use the field below to record evaluation notes or interview feedback.
                            </p>
                        </div>
                    <% } %>

                    <!-- Add Note Input Box -->
                    <div class="add-note-box" style="margin-top:12px;">
                        <asp:TextBox ID="txtCandidateNote" runat="server" TextMode="MultiLine" Rows="3" CssClass="add-note-textarea" placeholder="Add an evaluation note for this candidate..." />
                        <div style="text-align: right; margin-top: 8px;">
                            <asp:Button ID="btnSaveNote" runat="server" Text="Save Note" CssClass="btn-save-note" OnClick="btnSaveNote_Click" style="padding:6px 14px; font-size:12.5px; font-weight:600; background:#2563eb; color:#fff; border:none; border-radius:6px; cursor:pointer;" />
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- Schedule Interview Modal -->
    <div class="modal-backdrop-overlay" id="scheduleInterviewModal" style="display:none;">
        <div class="modal-dialog-box">
            <div class="modal-header-row">
                <h3 class="modal-title"><i class="fa-regular fa-calendar-check" style="color:#2563EB; margin-right:8px;"></i>Schedule Interview</h3>
                <button type="button" class="btn-modal-close" onclick="document.getElementById('scheduleInterviewModal').style.display='none';">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            <div class="modal-body-content">
                <div class="admin-form-group">
                    <label class="admin-input-label">Candidate</label>
                    <input type="text" class="admin-profile-input" value="<%= CandidateName %> (<%= CandidateEmail %>)" readonly="readonly" style="background-color:#F8FAFC;" />
                </div>
                <div class="admin-form-group">
                    <label class="admin-input-label">Interview Stage / Round</label>
                    <select class="admin-filter-select" id="interviewStageSelect">
                        <option value="Technical Round 1">Technical Round 1</option>
                        <option value="System Design">System Design Round</option>
                        <option value="HR & Cultural Fit">HR &amp; Cultural Fit</option>
                        <option value="Final Leadership Round">Final Leadership Round</option>
                    </select>
                </div>
                <div class="form-2col-row" style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Interview Date *</label>
                        <input type="date" class="admin-profile-input" id="interviewDateInput" value="<%= DateTime.Today.AddDays(1).ToString("yyyy-MM-dd") %>" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Interview Time *</label>
                        <input type="time" class="admin-profile-input" id="interviewTimeInput" value="11:00" />
                    </div>
                </div>
                <div class="admin-form-group">
                    <label class="admin-input-label">Meeting Provider &amp; Link</label>
                    <div style="display:flex; gap:8px;">
                        <input type="text" class="admin-profile-input" id="meetLinkInput" value="https://meet.google.com/new" />
                        <button type="button" class="btn-cancel-modal" id="btnGenMeetLink" onclick="document.getElementById('meetLinkInput').value='https://meet.google.com/' + Math.random().toString(36).substring(2, 5) + '-' + Math.random().toString(36).substring(2, 6) + '-' + Math.random().toString(36).substring(2, 5);" style="white-space:nowrap; background:#EFF6FF; border-color:#BFDBFE; color:#1D4ED8;">
                            <i class="fa-solid fa-arrows-rotate"></i> New Link
                        </button>
                    </div>
                </div>
            </div>
            <div class="modal-footer-row" style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <button type="button" class="btn-cancel-modal" onclick="document.getElementById('scheduleInterviewModal').style.display='none';">Cancel</button>
                <a href='<%= ResolveUrl("~/Company/Interviews.aspx?candId=" + StudentId + "&name=" + Server.UrlEncode(CandidateName) + "&role=" + Server.UrlEncode(TargetRoleName)) %>' class="btn-submit-modal" style="background-color:#2563EB; text-decoration:none; display:inline-flex; align-items:center; padding:8px 16px; border-radius:6px; color:#fff; font-size:13px; font-weight:600;">
                    Continue to Interview Scheduler
                </a>
            </div>
        </div>
    </div>
</asp:Content>
