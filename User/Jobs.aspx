<%@ Page Title="Find Jobs - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Jobs.aspx.cs" Inherits="SkillLinksX.User.Jobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Jobs Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-opps-page-container">

        <!-- Header Row -->
        <div class="opps-page-header">
            <h1 class="opps-page-title">Find Your Next Opportunity</h1>
            <p class="opps-page-sub">Discover jobs that match your skills, experience and career goals.</p>
        </div>

        <!-- 2-Column Layout: Left Filters + Right Recommended & Listings -->
        <div class="opps-layout-grid">

            <!-- Left Filters Column -->
            <aside class="opps-filter-column">
                <div class="opps-filter-card">
                    <div class="filter-card-header flex-between">
                        <h3 class="filter-card-title">Filters</h3>
                        <a href="javascript:void(0);" class="filter-clear-all" onclick="resetFilters()">Clear all</a>
                    </div>

                    <div class="filter-card-body">
                        <!-- Search Box -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">SEARCH</label>
                            <div class="filter-search-input-wrap">
                                <i class="fa-solid fa-magnifying-glass filter-input-icon"></i>
                                <input type="text" id="txtJobSearch" class="filter-search-input" placeholder="Role, company, skill..." oninput="applyJobFilters();" />
                            </div>
                        </div>

                        <!-- Job Category -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">JOB CATEGORY</label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="job-cat-cb" value="Software" onchange="applyJobFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Software Engineering</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="job-cat-cb" value="Data" onchange="applyJobFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Data Science &amp; AI</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="job-cat-cb" value="Design" onchange="applyJobFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">UI/UX &amp; Design</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="job-cat-cb" value="Web" onchange="applyJobFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Web &amp; Cloud</span>
                            </label>
                        </div>

                        <!-- Location Filter -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">LOCATION</label>
                            <div class="filter-pill-tags">
                                <button type="button" class="filter-pill-btn active" onclick="setJobLocation('', this);">All</button>
                                <button type="button" class="filter-pill-btn" onclick="setJobLocation('Remote', this);">Remote</button>
                                <button type="button" class="filter-pill-btn" onclick="setJobLocation('Bengaluru', this);">Bengaluru</button>
                                <button type="button" class="filter-pill-btn" onclick="setJobLocation('Mumbai', this);">Mumbai</button>
                            </div>
                        </div>

                        <!-- Job Type -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">JOB TYPE</label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="job-type-cb" value="Full" onchange="applyJobFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Full-time</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="job-type-cb" value="Part" onchange="applyJobFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Part-time</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="job-type-cb" value="Remote" onchange="applyJobFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Remote / Hybrid</span>
                            </label>
                        </div>
                    </div>
                </div>
            </aside>

            <!-- Right Main Content Column -->
            <main class="opps-main-column">

                <!-- Recommended For You Hero Banner (Dynamic AI Match) -->
                <div class="recommended-hero-banner">
                    <div class="rec-banner-top">
                        <div class="rec-tag-title">
                            <i class="fa-solid fa-sparkles"></i> RECOMMENDED FOR YOU
                        </div>
                        <!-- Match score ring -->
                        <div class="rec-score-chip">
                            <span class="rec-score-number"><%= RecommendedScore %>%</span>
                        </div>
                    </div>

                    <div class="rec-banner-body">
                        <h2 class="rec-role-title"><%= RecommendedTitle %></h2>
                        <div class="rec-company-loc">
                            <i class="fa-regular fa-building"></i> <%= RecommendedCompany %> &bull; <%= RecommendedLocation %>
                        </div>

                        <div class="rec-skills-row">
                            <asp:Repeater ID="rptRecommendedSkills" runat="server">
                                <ItemTemplate>
                                    <span class="rec-skill-tag"><i class="fa-solid fa-check"></i> <%# Container.DataItem %></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <div class="rec-banner-actions">
                        <a href='<%= ResolveUrl("~/User/JobDetails.aspx?id=" + RecommendedJobId) %>' class="btn-rec-apply">View &amp; Apply</a>
                    </div>
                </div>

                <!-- Dynamic Jobs Listing Section -->
                <div class="opps-listings-list" id="jobsContainer" style="margin-top: 24px; display: flex; flex-direction: column; gap: 16px;">
                    <asp:Repeater ID="rptJobsList" runat="server">
                        <ItemTemplate>
                            <div class="job-list-card" 
                                 data-title='<%# Eval("Title") %>' 
                                 data-company='<%# Eval("CompanyName") %>' 
                                 data-location='<%# Eval("Location") %>' 
                                 data-skills='<%# Eval("RequiredSkills") %>' 
                                 data-type='<%# Eval("JobType") %>'
                                 style="background:#fff; border:1px solid #e2e8f0; border-radius:12px; padding:18px; display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="display:flex; align-items:center; gap:8px; margin-bottom:4px;">
                                        <h3 style="font-size:16px; font-weight:600; color:#0f172a; margin:0;"><%# Eval("Title") %></h3>
                                        <span class="badge-role-match" style="font-size:11px; padding:2px 8px; background:#eff6ff; color:#2563eb; border-radius:6px; font-weight:600;">
                                            <%# Eval("AiMatchScore") %>% Match
                                        </span>
                                    </div>
                                    <div style="font-size:13px; color:#64748b; margin-bottom:8px;">
                                        <i class="fa-regular fa-building"></i> <%# Eval("CompanyName") %> &bull; <i class="fa-solid fa-location-dot"></i> <%# Eval("Location") %> &bull; <i class="fa-solid fa-money-bill-wave"></i> <%# Eval("SalaryRange") %>
                                    </div>
                                    <div style="font-size:12px; color:#475569;">
                                        <strong>Skills:</strong> <%# Eval("RequiredSkills") %>
                                    </div>
                                </div>
                                <div>
                                    <%# Convert.ToBoolean(Eval("HasApplied")) 
                                        ? "<span style='padding:6px 14px; font-size:12px; font-weight:600; border-radius:6px; background:#dcfce7; color:#15803d; display:inline-flex; align-items:center; gap:4px;'><i class=\"fa-solid fa-check\"></i> Applied</span>" 
                                        : "<a href='" + ResolveUrl("~/User/JobDetails.aspx?id=" + Eval("JobId")) + "' class='btn btn-primary' style='padding:8px 16px; font-size:13px; border-radius:8px; text-decoration:none; background:#2563eb; color:#fff; font-weight:500;'>View Details</a>" %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <!-- Filter Empty State -->
                    <div id="jobEmptyState" style="display:none; padding:40px 20px; text-align:center; color:#64748b; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:12px;">
                        <i class="fa-solid fa-magnifying-glass" style="font-size:32px; color:#94a3b8; margin-bottom:12px; display:block;"></i>
                        <h4 style="font-size:16px; font-weight:700; color:#1e293b; margin-bottom:6px;">No jobs match your filters</h4>
                        <p style="font-size:13px; color:#64748b; margin:0 0 16px;">Try clearing some filters or searching for different keywords.</p>
                        <button type="button" onclick="resetFilters();" style="padding:8px 18px; background:#2563eb; color:#fff; border:none; border-radius:6px; font-size:13px; font-weight:600; cursor:pointer;">Clear Filters</button>
                    </div>
                </div>

            </main>

        </div>

    </div>

    <script type="text/javascript">
        let selectedJobLocation = '';

        function setJobLocation(loc, btn) {
            selectedJobLocation = loc.toLowerCase();
            document.querySelectorAll('.opps-filter-column .filter-pill-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');
            applyJobFilters();
        }

        function applyJobFilters() {
            const searchVal = (document.getElementById('txtJobSearch')?.value || '').toLowerCase().trim();
            const catCheckboxes = Array.from(document.querySelectorAll('.job-cat-cb:checked')).map(cb => cb.value.toLowerCase());
            const typeCheckboxes = Array.from(document.querySelectorAll('.job-type-cb:checked')).map(cb => cb.value.toLowerCase());

            const cards = document.querySelectorAll('.job-list-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const title = (card.getAttribute('data-title') || '').toLowerCase();
                const company = (card.getAttribute('data-company') || '').toLowerCase();
                const location = (card.getAttribute('data-location') || '').toLowerCase();
                const skills = (card.getAttribute('data-skills') || '').toLowerCase();
                const type = (card.getAttribute('data-type') || '').toLowerCase();
                const combined = `${title} ${company} ${location} ${skills} ${type}`;

                // 1. Search text
                const matchesSearch = !searchVal || combined.includes(searchVal);

                // 2. Category
                const matchesCat = catCheckboxes.length === 0 || catCheckboxes.some(cat => combined.includes(cat));

                // 3. Location
                const matchesLoc = !selectedJobLocation || location.includes(selectedJobLocation);

                // 4. Job type
                const matchesType = typeCheckboxes.length === 0 || typeCheckboxes.some(t => type.includes(t) || combined.includes(t));

                if (matchesSearch && matchesCat && matchesLoc && matchesType) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            const empty = document.getElementById('jobEmptyState');
            if (empty) {
                empty.style.display = (visibleCount === 0 && cards.length > 0) ? 'block' : 'none';
            }
        }

        function resetFilters() {
            const searchBox = document.getElementById('txtJobSearch');
            if (searchBox) searchBox.value = '';

            document.querySelectorAll('.job-cat-cb').forEach(cb => cb.checked = false);
            document.querySelectorAll('.job-type-cb').forEach(cb => cb.checked = false);

            selectedJobLocation = '';
            const allPill = document.querySelector('.opps-filter-column .filter-pill-btn');
            if (allPill) {
                document.querySelectorAll('.opps-filter-column .filter-pill-btn').forEach(b => b.classList.remove('active'));
                allPill.classList.add('active');
            }

            applyJobFilters();
        }
    </script>
</asp:Content>
