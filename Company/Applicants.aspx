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
                <div class="app-metric-value"><%= TotalCount %></div>
            </div>
            <div class="applicants-metric-card highlight-new">
                <div class="app-metric-label">NEW</div>
                <div class="app-metric-value color-blue"><%= NewCount %></div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">UNDER REVIEW</div>
                <div class="app-metric-value"><%= ReviewCount %></div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">SHORTLISTED</div>
                <div class="app-metric-value"><%= ShortlistedCount %></div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">INTERVIEW</div>
                <div class="app-metric-value"><%= InterviewCount %></div>
            </div>
            <div class="applicants-metric-card">
                <div class="app-metric-label">SELECTED</div>
                <div class="app-metric-value"><%= SelectedCount %></div>
            </div>
        </div>

        <!-- Main Workspace Split Layout: Table (Left) + Candidate Quick View Panel (Right) -->
        <div class="applicants-workspace-layout">

            <!-- Left: Table & Filter Controls Container -->
            <div class="applicants-table-card">
                
                <!-- Filter Bar -->
                <div class="applicants-filters-bar">
                    <div class="filter-opp-select-wrapper">
                        <asp:DropDownList ID="ddlOpportunityFilter" runat="server" CssClass="app-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlOpportunityFilter_SelectedIndexChanged">
                            <asp:ListItem Text="All Opportunities" Value="0" />
                        </asp:DropDownList>
                    </div>

                    <div class="app-search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <asp:TextBox ID="txtCandidateSearch" runat="server" placeholder="Name or skill..." AutoPostBack="true" OnTextChanged="txtCandidateSearch_TextChanged" />
                    </div>

                    <div class="app-action-buttons-group">
                        <asp:Button ID="btnShortlist" runat="server" Text="Shortlist" CssClass="btn-app-primary" OnClick="btnStatusAction_Click" CommandArgument="Shortlisted" />
                        <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn-app-danger" OnClick="btnStatusAction_Click" CommandArgument="Rejected" />
                    </div>
                </div>

                <asp:Label ID="lblActionMessage" runat="server" ForeColor="Green" style="font-size: 13px; margin: 8px 12px; display: block;" EnableViewState="false" />

                <!-- Applicants Table -->
                <div class="app-table-scroll-wrapper" style="overflow-x: auto;">
                    <table class="applicants-data-table">
                        <thead>
                            <tr>
                                <th style="width: 40px;">#</th>
                                <th>CANDIDATE</th>
                                <th>APPLIED FOR</th>
                                <th>AI MATCH</th>
                                <th>STATUS</th>
                                <th>ACTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptApplicants" runat="server" OnItemCommand="rptApplicants_ItemCommand">
                                <ItemTemplate>
                                    <tr class="candidate-row">
                                        <td><%# Container.ItemIndex + 1 %></td>
                                        <td>
                                            <div class="candidate-cell-flex">
                                                <img src='<%# ResolveUrl("~/assets/images/user-male-logo.png") %>' alt="Candidate" class="candidate-table-avatar" />
                                                <div class="candidate-meta-text">
                                                    <span class="candidate-cell-name"><%# Eval("StudentName") %></span>
                                                    <span class="candidate-cell-sub"><%# Eval("Email") %></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="candidate-role-text"><%# Eval("JobTitle") %></td>
                                        <td>
                                            <span class="ai-match-badge match-high">
                                                <i class="fa-solid fa-wand-magic-sparkles"></i> <%# Eval("AiMatchScore") %>%
                                            </span>
                                        </td>
                                        <td>
                                            <span class='app-status-pill <%# Eval("StatusClass") %>'><%# Eval("Status") %></span>
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="btnViewProfile" runat="server" CommandName="SelectCandidate" CommandArgument='<%# Eval("ApplicationId") %>' CssClass="btn-app-secondary" style="padding: 4px 10px; font-size: 12px; text-decoration:none;">
                                                Select
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
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
