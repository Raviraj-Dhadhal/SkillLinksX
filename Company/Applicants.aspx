<%@ Page Title="Applicants - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Applicants.aspx.cs" Inherits="SkillLinksX.Company.Applicants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Applicants Head -->
    <style>
        .status-pill-selected {
            background: #dcfce7 !important;
            color: #15803d !important;
            font-weight: 600;
            border: 1px solid #bbf7d0;
        }
        .status-pill-shortlisted {
            background: #dbeafe !important;
            color: #1d4ed8 !important;
            font-weight: 600;
            border: 1px solid #bfdbfe;
        }
        .status-pill-new {
            background: #f1f5f9;
            color: #475569;
            font-weight: 600;
        }
        .status-pill-rejected {
            background: #fee2e2 !important;
            color: #b91c1c !important;
            font-weight: 600;
            border: 1px solid #fca5a5;
        }
        .status-pill-review {
            background: #fef3c7 !important;
            color: #b45309 !important;
            font-weight: 600;
            border: 1px solid #fde68a;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="applicants-page-container">

        <!-- Header -->
        <div class="applicants-header">
            <h1 class="applicants-title">Applicants</h1>
            <p class="applicants-sub">Review and manage candidates who applied to your opportunities.</p>
        </div>

        <!-- 6 Metrics Cards Grid (Clickable to filter table) -->
        <div class="applicants-metrics-grid">
            <asp:LinkButton ID="btnFilterMetricTotal" runat="server" CssClass="applicants-metric-card" OnClick="btnMetricFilter_Click" CommandArgument="All" style="text-decoration:none; cursor:pointer;">
                <div class="app-metric-label">TOTAL</div>
                <div class="app-metric-value"><%= TotalCount %></div>
            </asp:LinkButton>
            <asp:LinkButton ID="btnFilterMetricNew" runat="server" CssClass="applicants-metric-card highlight-new" OnClick="btnMetricFilter_Click" CommandArgument="New" style="text-decoration:none; cursor:pointer;">
                <div class="app-metric-label">NEW</div>
                <div class="app-metric-value color-blue"><%= NewCount %></div>
            </asp:LinkButton>
            <asp:LinkButton ID="btnFilterMetricReview" runat="server" CssClass="applicants-metric-card" OnClick="btnMetricFilter_Click" CommandArgument="Under Review" style="text-decoration:none; cursor:pointer;">
                <div class="app-metric-label">UNDER REVIEW</div>
                <div class="app-metric-value"><%= ReviewCount %></div>
            </asp:LinkButton>
            <asp:LinkButton ID="btnFilterMetricShortlisted" runat="server" CssClass="applicants-metric-card" OnClick="btnMetricFilter_Click" CommandArgument="Shortlisted" style="text-decoration:none; cursor:pointer;">
                <div class="app-metric-label">SHORTLISTED</div>
                <div class="app-metric-value"><%= ShortlistedCount %></div>
            </asp:LinkButton>
            <asp:LinkButton ID="btnFilterMetricInterview" runat="server" CssClass="applicants-metric-card" OnClick="btnMetricFilter_Click" CommandArgument="Interview Scheduled" style="text-decoration:none; cursor:pointer;">
                <div class="app-metric-label">INTERVIEW</div>
                <div class="app-metric-value"><%= InterviewCount %></div>
            </asp:LinkButton>
            <asp:LinkButton ID="btnFilterMetricSelected" runat="server" CssClass="applicants-metric-card" OnClick="btnMetricFilter_Click" CommandArgument="Selected" style="text-decoration:none; cursor:pointer;">
                <div class="app-metric-label">SELECTED</div>
                <div class="app-metric-value"><%= SelectedCount %></div>
            </asp:LinkButton>
        </div>

        <!-- Main Workspace Split Layout: Table (Left) + Candidate Quick View Panel (Right) -->
        <div class="applicants-workspace-layout">

            <!-- Left: Table & Filter Controls Container -->
            <div class="applicants-table-card">
                
                <!-- Filter Bar -->
                <div class="applicants-filters-bar" style="display:flex; flex-wrap:wrap; gap:10px; align-items:center;">
                    <div class="filter-opp-select-wrapper" style="min-width: 170px;">
                        <asp:DropDownList ID="ddlOpportunityFilter" runat="server" CssClass="app-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlOpportunityFilter_SelectedIndexChanged">
                            <asp:ListItem Text="All Opportunities" Value="0" />
                        </asp:DropDownList>
                    </div>

                    <div class="filter-opp-select-wrapper" style="min-width: 160px;">
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="app-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                            <asp:ListItem Text="Active (Pending Review)" Value="All" Selected="True" />
                            <asp:ListItem Text="New Applications" Value="New" />
                            <asp:ListItem Text="Under Review" Value="Under Review" />
                            <asp:ListItem Text="Shortlisted" Value="Shortlisted" />
                            <asp:ListItem Text="Interview Scheduled" Value="Interview Scheduled" />
                            <asp:ListItem Text="Selected (Hired)" Value="Selected" />
                            <asp:ListItem Text="Rejected" Value="Rejected" />
                            <asp:ListItem Text="All Historical Records" Value="AllHistorical" />
                        </asp:DropDownList>
                    </div>

                    <div class="app-search-box" style="flex: 1; min-width: 180px;">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <asp:TextBox ID="txtCandidateSearch" runat="server" placeholder="Search candidate, role or skill..." AutoPostBack="true" OnTextChanged="txtCandidateSearch_TextChanged" />
                    </div>

                    <div style="display:flex; align-items:center; gap:8px;">
                        <asp:LinkButton ID="btnResetFilter" runat="server" style="padding: 7px 12px; font-size: 13px; text-decoration:none; display:inline-flex; align-items:center; gap:6px; border-radius:6px; background:#f1f5f9; color:#475569; border:1px solid #cbd5e1; font-weight:500;" OnClick="btnResetFilter_Click" ToolTip="Reset all filters">
                            <i class="fa-solid fa-rotate-left"></i> Reset
                        </asp:LinkButton>
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
                                                <%# !string.IsNullOrEmpty(Eval("ProfilePhoto") as string) 
                                                    ? "<img src='" + ResolveUrl(Eval("ProfilePhoto").ToString()) + "' alt='Candidate' class='candidate-table-avatar' style='width:36px; height:36px; border-radius:50%; object-fit:cover;' />"
                                                    : "<span class='candidate-table-avatar' style='width:36px; height:36px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:15px; border:1px solid #cbd5e1;'><i class=\"fa-regular fa-user\"></i></span>" %>
                                                <div class="candidate-meta-text">
                                                    <a href='<%# ResolveUrl("~/Company/CandidateProfile.aspx?id=" + Eval("UserId") + "&app_id=" + Eval("ApplicationId")) %>' class="candidate-cell-name" style="text-decoration:none; color:#0f172a; font-weight:600;" onmouseover="this.style.color='#2563eb'" onmouseout="this.style.color='#0f172a'"><%# Eval("StudentName") %></a>
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
                                            <div style="display:flex; align-items:center; gap:6px;">
                                                <asp:LinkButton ID="btnDirectSelect" runat="server" CommandName="DirectSelect" CommandArgument='<%# Eval("ApplicationId") %>' style="padding: 4px 10px; font-size: 11.5px; font-weight:600; background:#10b981; color:#fff; border-radius:4px; text-decoration:none;" ToolTip="Select / Hire this candidate">
                                                    Select
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDirectShortlist" runat="server" CommandName="DirectShortlist" CommandArgument='<%# Eval("ApplicationId") %>' style="padding: 4px 8px; font-size: 11.5px; font-weight:600; background:#eff6ff; color:#2563eb; border:1px solid #bfdbfe; border-radius:4px; text-decoration:none;" ToolTip="Shortlist this candidate">
                                                    Shortlist
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDirectReject" runat="server" CommandName="DirectReject" CommandArgument='<%# Eval("ApplicationId") %>' style="padding: 4px 8px; font-size: 11.5px; font-weight:600; background:#fef2f2; color:#dc2626; border:1px solid #fecaca; border-radius:4px; text-decoration:none;" ToolTip="Reject this candidate">
                                                    Reject
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnViewProfile" runat="server" CommandName="SelectCandidate" CommandArgument='<%# Eval("ApplicationId") %>' style="padding: 4px 6px; font-size: 13px; color:#64748b; text-decoration:none;" ToolTip="Preview candidate profile">
                                                    <i class="fa-regular fa-eye"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Panel ID="pnlNoApplicants" runat="server" Visible='<%# rptApplicants.Items.Count == 0 %>' style="padding: 36px 16px; text-align: center; color: #64748B;">
                                        <i class="fa-solid fa-users-slash" style="font-size: 32px; color: #94A3B8; margin-bottom: 8px; display: block;"></i>
                                        <span style="font-size: 14px; font-weight: 500;">No applicants found for this filter.</span>
                                    </asp:Panel>
                                </FooterTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <!-- Bottom Pagination Bar -->
                <div class="table-pagination-row">
                    <span style="font-size: 12px; color: #64748B;">Showing <%= TableCount > 0 ? "1-" + TableCount : "0" %> of <%= TableCount %> applicants</span>
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
                <% if (HasSelectedApplicant) { %>
                    <div class="candidate-preview-top">
                        <% if (!string.IsNullOrEmpty(QuickProfilePhoto)) { %>
                            <img src='<%= ResolveUrl(QuickProfilePhoto) %>' alt="Candidate" style="width:64px; height:64px; border-radius:50%; object-fit:cover; border:2px solid #fff; box-shadow:0 2px 6px rgba(0,0,0,0.08); display:inline-block;" />
                        <% } else { %>
                            <span style="width:64px; height:64px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:26px; border:2px solid #fff; box-shadow:0 2px 6px rgba(0,0,0,0.06);">
                                <i class="fa-regular fa-user"></i>
                            </span>
                        <% } %>
                        <h3 class="preview-candidate-name" id="quickName"><%= QuickStudentName %></h3>
                        <p class="preview-candidate-role" id="quickRole"><%= QuickJobTitle %></p>
                        
                        <div class="preview-action-row" style="display:flex; gap:8px; margin-top:12px; flex-wrap:wrap; justify-content:center;">
                            <a href='<%= ResolveUrl("~/Company/CandidateProfile.aspx?id=" + QuickStudentId + "&app_id=" + QuickApplicationId) %>' class="btn-view-full-profile" id="quickViewProfileBtn" style="padding: 7px 14px; font-size: 13px;">View Full Profile</a>
                            <asp:LinkButton ID="btnQuickSelect" runat="server" style="background:#10b981; border:none; color:#fff; padding:7px 12px; font-size:12px; border-radius:6px; text-decoration:none; font-weight:600; cursor:pointer;" OnClick="btnQuickAction_Click" CommandArgument="Selected">Select</asp:LinkButton>
                            <asp:LinkButton ID="btnQuickShortlist" runat="server" style="background:#eff6ff; border:1px solid #bfdbfe; color:#2563eb; padding:7px 12px; font-size:12px; border-radius:6px; text-decoration:none; font-weight:600; cursor:pointer;" OnClick="btnQuickAction_Click" CommandArgument="Shortlisted">Shortlist</asp:LinkButton>
                            <asp:LinkButton ID="btnQuickReject" runat="server" style="background:#fef2f2; border:1px solid #fecaca; color:#dc2626; padding:7px 12px; font-size:12px; border-radius:6px; text-decoration:none; font-weight:600; cursor:pointer;" OnClick="btnQuickAction_Click" CommandArgument="Rejected">Reject</asp:LinkButton>
                        </div>
                    </div>

                    <div class="preview-divider"></div>

                    <!-- AI Match Insights Box -->
                    <div class="preview-section">
                        <div class="preview-section-title">AI MATCH INSIGHTS</div>
                        <div class="ai-match-card-callout">
                            <div class="match-score-radial-box">
                                <span class="score-circle-number" id="quickScore"><%= QuickMatchScore %>%</span>
                            </div>
                            <div class="match-insights-meta">
                                <div class="match-badge-title"><%= QuickMatchScore >= 80 ? "Excellent Match" : (QuickMatchScore >= 60 ? "Moderate Match" : "Basic Match") %></div>
                                <div class="match-badge-sub">Automated skill overlap score.</div>
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
                                <div class="preview-edu-school" id="quickEdu"><%= QuickCollege %></div>
                                <div class="preview-edu-sub" id="quickDegree"><%= QuickDegree %></div>
                            </div>
                        </div>
                    </div>

                    <div class="preview-divider"></div>

                    <!-- Top Skills -->
                    <div class="preview-section">
                        <div class="preview-section-title">TOP SKILLS</div>
                        <div class="preview-skills-pills">
                            <% if (QuickSkills != null && QuickSkills.Count > 0) { 
                                   foreach(var skill in QuickSkills) { %>
                                       <span class="preview-skill-pill"><%= skill %></span>
                            <%     } 
                               } else { %>
                                   <span style="font-size:12px; color:#94a3b8; font-style:italic;">No skills specified</span>
                            <% } %>
                        </div>
                    </div>
                <% } else { %>
                    <div style="padding:48px 20px; text-align:center; color:#64748b;">
                        <i class="fa-solid fa-user-group" style="font-size:36px; color:#cbd5e1; margin-bottom:12px; display:block;"></i>
                        <h4 style="font-size:16px; font-weight:600; color:#334155; margin-bottom:6px;">No Applicants Yet</h4>
                        <p style="font-size:13px; margin:0;">When candidates apply to your jobs or internships, their profile summary and AI match insights will appear here.</p>
                    </div>
                <% } %>

            </div>

        </div>

    </div>
</asp:Content>
