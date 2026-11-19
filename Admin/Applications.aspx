<%@ Page Title="Applications Management - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Applications.aspx.cs" Inherits="SkillLinksX.Admin.Applications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Applications Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Applications Management</h1>
                <p class="admin-page-main-sub">Monitor and manage applications across the SkillLinkX platform.</p>
            </div>
        </div>

        <!-- 6 Summary Metrics Cards -->
        <div class="admin-metrics-6grid">
            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Total Applications</span>
                </div>
                <div class="stat-num-val">
                    <asp:Literal ID="litTotalApps" runat="server">0</asp:Literal> 
                    <asp:Literal ID="litAppTrend" runat="server"><span class="stat-trend-green"><i class="fa-solid fa-check"></i> Live</span></asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">New Applications</span>
                </div>
                <div class="stat-num-val color-blue">
                    <asp:Literal ID="litNewApps" runat="server">0</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Under Review</span>
                </div>
                <div class="stat-num-val">
                    <asp:Literal ID="litUnderReview" runat="server">0</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Shortlisted</span>
                </div>
                <div class="stat-num-val color-green">
                    <asp:Literal ID="litShortlisted" runat="server">0</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Interviews</span>
                </div>
                <div class="stat-num-val color-orange">
                    <asp:Literal ID="litInterviews" runat="server">0</asp:Literal>
                </div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Hired</span>
                </div>
                <div class="stat-num-val color-teal">
                    <asp:Literal ID="litHired" runat="server">0</asp:Literal>
                </div>
            </div>
        </div>

        <!-- Application Funnel Card (100% Dynamic from dbo.applications) -->
        <div class="admin-funnel-card">
            <h3 class="funnel-card-title">Application Funnel</h3>
            <div class="funnel-steps-row">
                <!-- Step 1: Applied -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-blue-light"><%= FunnelAppliedPct %></div>
                    <div class="funnel-step-name">Applied</div>
                    <div class="funnel-step-val"><%= FunnelAppliedCount %></div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 2: Under Review -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-purple-light"><%= FunnelUnderReviewPct %></div>
                    <div class="funnel-step-name">Under Review</div>
                    <div class="funnel-step-val"><%= FunnelUnderReviewCount %></div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 3: Shortlisted -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-green-light"><%= FunnelShortlistedPct %></div>
                    <div class="funnel-step-name">Shortlisted</div>
                    <div class="funnel-step-val"><%= FunnelShortlistedCount %></div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 4: Interview -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-gray-light"><%= FunnelInterviewPct %></div>
                    <div class="funnel-step-name">Interview</div>
                    <div class="funnel-step-val"><%= FunnelInterviewCount %></div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 5: Selected -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-teal-light"><%= FunnelSelectedPct %></div>
                    <div class="funnel-step-name">Selected</div>
                    <div class="funnel-step-val"><%= FunnelSelectedCount %></div>
                </div>
                <div class="funnel-divider-line"></div>

                <!-- Step 6: Rejected -->
                <div class="funnel-step-item">
                    <div class="funnel-bubble-circle bg-red-light"><%= FunnelRejectedPct %></div>
                    <div class="funnel-step-name">Rejected</div>
                    <div class="funnel-step-val"><%= FunnelRejectedCount %></div>
                </div>
            </div>
        </div>

        <!-- Filter Bar Row (100% Dynamic Companies & Functional Filters) -->
        <div class="admin-filter-bar-card">
            <div class="admin-search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="txtAppSearch" placeholder="Search jobs, internships, people..." />
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterAppCompany">
                    <option value="">All Companies</option>
                    <% foreach (var c in CompanyFilterList) { %>
                        <option value="<%= c %>"><%= c %></option>
                    <% } %>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterAppType">
                    <option value="">All Types</option>
                    <option value="Job">Job</option>
                    <option value="Internship">Internship</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterAppStatus">
                    <option value="">All Statuses</option>
                    <option value="Applied">Applied</option>
                    <option value="Under Review">Under Review</option>
                    <option value="Shortlisted">Shortlisted</option>
                    <option value="Interview Scheduled">Interview Scheduled</option>
                    <option value="Selected">Selected</option>
                    <option value="Rejected">Rejected</option>
                </select>
            </div>

            <button type="button" class="btn-filter-apply" id="btnApplyAppFilters">Apply Filters</button>
            <button type="button" class="btn-filter-clear" id="btnClearAppFilters">Clear</button>
        </div>

        <!-- 2-Column Split: Left Applications Table + Right Candidate Summary Details Panel -->
        <div class="admin-workspace-split-grid">

            <!-- Left Main Column (Applications Table) -->
            <div class="admin-table-card">
                <div class="admin-table-responsive">
                    <table class="admin-data-table" id="adminAppsTable">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Opportunity</th>
                                <th>Type &amp; Loc</th>
                                <th>Match</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptAdminApplications" runat="server" OnItemCommand="rptAdminApplications_ItemCommand">
                                <ItemTemplate>
                                    <tr class="app-row"
                                        data-student-name='<%# Eval("StudentName") %>'
                                        data-company='<%# Eval("CompanyName") %>'
                                        data-role='<%# Eval("OpportunityTitle") %>'
                                        data-applied-for='<%# Eval("OpportunityTitle") + " at " + Eval("CompanyName") %>'
                                        data-type='<%# Eval("OppType") %>'
                                        data-match='<%# Eval("MatchScore") + "%" %>'
                                        data-skills-match='<%# Eval("MatchScore") + "%" %>'
                                        data-exp-match='<%# Eval("ExperienceScore") + "%" %>'
                                        data-education='<%# Eval("Degree") %>'
                                        data-college='<%# Eval("College") %>'
                                        data-skills='<%# Eval("Skills") %>'
                                        data-status='<%# Eval("Status") %>'
                                        data-date='<%# Eval("AppliedDateFormatted") %>'
                                        data-avatar='<%# Eval("ProfilePhoto") %>'
                                        data-user-id='<%# Eval("UserId") %>'>
                                        <td>
                                            <div class="student-cell-flex">
                                                <div class="student-avatar-wrap">
                                                    <%# !string.IsNullOrEmpty(Eval("ProfilePhoto") as string)
                                                        ? "<img src='" + ResolveUrl(Eval("ProfilePhoto").ToString()) + "' alt='Avatar' style='width:36px; height:36px; border-radius:50%; object-fit:cover;' />"
                                                        : "<div style='width:36px; height:36px; border-radius:50%; background:#EFF6FF; color:#0040A2; display:flex; align-items:center; justify-content:center; font-size:15px; border:1px solid #CBD5E1;'><i class=\"fa-regular fa-user\"></i></div>" %>
                                                </div>
                                                <div>
                                                    <div class="student-name-text"><%# Eval("StudentName") %></div>
                                                    <div class="student-sub-email">Applied <%# Eval("AppliedDateFormatted") %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="opp-title-bold"><%# Eval("OpportunityTitle") %></div>
                                            <div class="opp-sub-meta"><%# Eval("CompanyName") %></div>
                                        </td>
                                        <td>
                                            <div class="opp-sub-meta"><%# Eval("OppType") %></div>
                                            <div class="opp-sub-meta"><%# Eval("Location") %></div>
                                        </td>
                                        <td><span class="match-score-pill"><%# Eval("MatchScore") %>%</span></td>
                                        <td>
                                            <span class='badge-status-<%# Eval("Status").ToString().ToLower().Replace(" ", "-") %>'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Right Sidebar Column: Candidate Detail Profile & Timeline Card -->
            <div class="admin-details-sidebar-card" id="appDetailsCard">
                <% if (HasSelectedApp) { %>
                <div class="details-card-header flex-between" style="border:none; padding-bottom:0;">
                    <div></div>
                    <button type="button" class="btn-close-details" id="btnCloseAppDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <div class="student-profile-center-block" style="padding-top:0;">
                    <div class="student-large-avatar-box">
                        <img src='<%= SelectedProfilePhoto %>' id="adAvatar" alt="Student" style='width:72px; height:72px; border-radius:50%; object-fit:cover; margin:0 auto; border:2px solid #fff; box-shadow:0 2px 6px rgba(0,0,0,0.08); <%= string.IsNullOrEmpty(SelectedProfilePhoto) ? "display:none;" : "display:block;" %>' />
                        <div id="adAvatarFallback" style='width:72px; height:72px; border-radius:50%; background:#EFF6FF; color:#0040A2; display:<%= !string.IsNullOrEmpty(SelectedProfilePhoto) ? "none" : "flex" %>; align-items:center; justify-content:center; font-size:28px; border:1px solid #CBD5E1; margin:0 auto;'>
                            <i class="fa-regular fa-user"></i>
                        </div>
                    </div>
                    <h4 class="sd-student-name" id="adName"><%= SelectedStudentName %></h4>
                    <div class="sd-student-email" id="adAppliedFor">Applying for <%= SelectedAppliedRole %> at <%= SelectedCompanyName %></div>
                    <div class="ad-resume-portfolio-row">
                        <a href='<%= ResolveUrl("~/Admin/Applications.aspx?download_resume=1&uid=" + SelectedUserId) %>' id="adResumeBtn" class="btn-ad-pill-outline" title="Download Resume"><i class="fa-regular fa-file-lines"></i> Resume <i class="fa-solid fa-download" style="font-size:11px; margin-left:3px;"></i></a>
                        <a href='<%= ResolveUrl("~/User/Portfolio.aspx") %>' class="btn-ad-pill-outline"><i class="fa-solid fa-globe"></i> Portfolio</a>
                    </div>
                </div>

                <!-- AI Match Analysis Card Box -->
                <div class="ad-ai-match-box">
                    <div class="ad-ai-header flex-between">
                        <span class="ad-ai-title"><i class="fa-solid fa-sparkles"></i> AI Match Analysis</span>
                        <span class="ad-ai-pct" id="adMatchPct"><%= SelectedMatchPct %>%</span>
                    </div>
                    <div class="ad-match-bar-group">
                        <div class="ad-match-bar-label flex-between">
                            <span>Skills Match</span>
                            <span id="adSkillsMatchPct"><%= SelectedMatchPct %>%</span>
                        </div>
                        <div class="ad-bar-track"><div class="ad-bar-fill fill-green" id="adSkillsBar" style="width: <%= SelectedMatchPct %>%;"></div></div>
                    </div>
                    <div class="ad-match-bar-group" style="margin-top:8px;">
                        <div class="ad-match-bar-label flex-between">
                            <span>Experience Match</span>
                            <span id="adExpMatchPct"><%= SelectedExpPct %>%</span>
                        </div>
                        <div class="ad-bar-track"><div class="ad-bar-fill fill-blue" id="adExpBar" style="width: <%= SelectedExpPct %>%;"></div></div>
                    </div>
                </div>

                <!-- Education & Skills -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">EDUCATION &amp; SKILLS</span>
                    <div class="ad-edu-icon-row">
                        <i class="fa-solid fa-graduation-cap"></i>
                        <div>
                            <div class="sd-bold-txt" id="adDegree"><%= SelectedEducation %></div>
                            <div class="sd-sub-txt" id="adCollege"><%= SelectedCollege %></div>
                        </div>
                    </div>
                    <div class="sd-skills-chips-row" style="margin-top:10px;" id="adSkills">
                        <% if (SelectedSkills != null && SelectedSkills.Count > 0) { 
                               foreach (var sk in SelectedSkills) { %>
                                   <span class="sd-skill-pill"><%= sk %></span>
                        <%     } 
                           } else { %>
                               <span class="sd-skill-pill" style="color:#64748B;">No skills specified</span>
                        <% } %>
                    </div>
                </div>

                <!-- Application Timeline -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">APPLICATION TIMELINE</span>
                    <div class="app-status-timeline" style="padding-left:14px;">
                        <div class="timeline-step active">
                            <div class="step-dot" style="background:#0040A2;"></div>
                            <div class="step-info">
                                <div class="step-title" id="adTimelineStatus"><%= SelectedTimelineStatus %></div>
                                <div class="step-date">Current Status &bull; Updated in Database</div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div style="padding: 40px 20px; text-align: center; color: #64748B;">
                    <i class="fa-regular fa-folder-open" style="font-size: 40px; margin-bottom: 12px; color: #CBD5E1;"></i>
                    <h4 style="font-size: 16px; font-weight: 700; color: #1E293B; margin-bottom: 6px;">No Applications Yet</h4>
                    <p style="font-size: 13px; color: #64748B; margin: 0;">When candidates apply to jobs or internships, their application details and AI match score will appear here.</p>
                </div>
                <% } %>
            </div>

        </div>

    </div>

    <!-- Live Client-side Filter & Interactive Sidebar Wiring -->
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            const searchInput = document.getElementById("txtAppSearch");
            const companyFilter = document.getElementById("filterAppCompany");
            const typeFilter = document.getElementById("filterAppType");
            const statusFilter = document.getElementById("filterAppStatus");
            const btnApply = document.getElementById("btnApplyAppFilters");
            const btnClear = document.getElementById("btnClearAppFilters");
            const rows = document.querySelectorAll(".app-row");

            function applyApplicationFilters() {
                const search = (searchInput ? searchInput.value : "").trim().toLowerCase();
                const selectedCompany = (companyFilter ? companyFilter.value : "").trim().toLowerCase();
                const selectedType = (typeFilter ? typeFilter.value : "").trim().toLowerCase();
                const selectedStatus = (statusFilter ? statusFilter.value : "").trim().toLowerCase();

                let firstVisible = null;

                rows.forEach(function (row) {
                    const rowText = row.innerText.toLowerCase();
                    const rowCompany = (row.getAttribute("data-company") || "").toLowerCase();
                    const rowType = (row.getAttribute("data-type") || "").toLowerCase();
                    const rowStatus = (row.getAttribute("data-status") || "").toLowerCase();

                    const matchesSearch = !search || rowText.includes(search);
                    const matchesCompany = !selectedCompany || rowCompany.includes(selectedCompany);
                    const matchesType = !selectedType || rowType === selectedType;
                    const matchesStatus = !selectedStatus || rowStatus.includes(selectedStatus);

                    if (matchesSearch && matchesCompany && matchesType && matchesStatus) {
                        row.style.display = "";
                        if (!firstVisible) firstVisible = row;
                    } else {
                        row.style.display = "none";
                    }
                });

                if (firstVisible) {
                    firstVisible.click();
                }
            }

            if (searchInput) searchInput.addEventListener("input", applyApplicationFilters);
            if (companyFilter) companyFilter.addEventListener("change", applyApplicationFilters);
            if (typeFilter) typeFilter.addEventListener("change", applyApplicationFilters);
            if (statusFilter) statusFilter.addEventListener("change", applyApplicationFilters);

            if (btnApply) {
                btnApply.addEventListener("click", applyApplicationFilters);
            }

            if (btnClear) {
                btnClear.addEventListener("click", function () {
                    if (searchInput) searchInput.value = "";
                    if (companyFilter) companyFilter.selectedIndex = 0;
                    if (typeFilter) typeFilter.selectedIndex = 0;
                    if (statusFilter) statusFilter.selectedIndex = 0;
                    rows.forEach(function (r) { r.style.display = ""; });
                    if (rows.length > 0) rows[0].click();
                });
            }

            // Auto-select first row on load
            if (rows.length > 0) {
                rows[0].classList.add("active-row");
            }
        });
    </script>
</asp:Content>
