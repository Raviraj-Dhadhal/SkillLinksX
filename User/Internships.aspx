<%@ Page Title="Find Internships - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Internships.aspx.cs" Inherits="SkillLinksX.User.Internships" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Internships Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-opps-page-container">

        <!-- Header Row -->
        <div class="opps-page-header">
            <h1 class="opps-page-title">Find Your Perfect Internship</h1>
            <p class="opps-page-sub">Gain real-world experience, build your network, and start accelerating your career with top tech companies.</p>
        </div>

        <!-- 2-Column Layout: Left Filters + Right Listings -->
        <div class="opps-layout-grid">

            <!-- Left Filters Column -->
            <aside class="opps-filter-column">
                <div class="opps-filter-card">
                    <div class="filter-card-header flex-between">
                        <h3 class="filter-card-title">Filters</h3>
                        <a href="javascript:void(0);" class="filter-clear-all" onclick="resetFilters()">Clear All</a>
                    </div>

                    <div class="filter-card-body">
                        <!-- Location Filter -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">Location</label>
                            <div class="filter-search-input-wrap">
                                <i class="fa-solid fa-location-dot filter-input-icon"></i>
                                <input type="text" id="txtInternLocation" class="filter-search-input" placeholder="e.g. Bengaluru, Remote..." oninput="applyInternshipFilters();" />
                            </div>
                            <div class="filter-pill-tags">
                                <button type="button" class="filter-pill-btn active" onclick="setInternLocation('', this);">All</button>
                                <button type="button" class="filter-pill-btn" onclick="setInternLocation('Remote', this);">Remote</button>
                                <button type="button" class="filter-pill-btn" onclick="setInternLocation('Bengaluru', this);">Bengaluru</button>
                                <button type="button" class="filter-pill-btn" onclick="setInternLocation('Mumbai', this);">Mumbai</button>
                            </div>
                        </div>

                        <!-- Work Type -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">Work Type</label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="intern-type-cb" value="On-site" onchange="applyInternshipFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">On-site</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="intern-type-cb" value="Hybrid" onchange="applyInternshipFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Hybrid</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" class="intern-type-cb" value="Remote" onchange="applyInternshipFilters();" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Remote</span>
                            </label>
                        </div>

                        <!-- Monthly Stipend -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">Monthly Stipend</label>
                            <label class="filter-radio-row">
                                <input type="radio" name="stipend" value="all" checked="checked" onchange="applyInternshipFilters();" />
                                <span class="custom-radio-indicator"></span>
                                <span class="filter-cb-label">All Stipends</span>
                            </label>
                            <label class="filter-radio-row">
                                <input type="radio" name="stipend" value="paid" onchange="applyInternshipFilters();" />
                                <span class="custom-radio-indicator"></span>
                                <span class="filter-cb-label">Paid (₹10,000+)</span>
                            </label>
                            <label class="filter-radio-row">
                                <input type="radio" name="stipend" value="high" onchange="applyInternshipFilters();" />
                                <span class="custom-radio-indicator"></span>
                                <span class="filter-cb-label">&#8377;20,000+</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Pro Tips Callout Card -->
                <div class="pro-tips-card">
                    <div class="pro-tips-title">
                        <i class="fa-regular fa-lightbulb"></i> Pro Tips
                    </div>
                    <ul class="pro-tips-list">
                        <li>
                            <i class="fa-regular fa-circle-check"></i>
                            <span>Tailor your resume for specific roles.</span>
                        </li>
                        <li>
                            <i class="fa-regular fa-circle-check"></i>
                            <span>Keep your portfolio links updated.</span>
                        </li>
                    </ul>
                </div>
            </aside>

            <!-- Right Main Content Column -->
            <main class="opps-main-column">

                <!-- Category Tabs Navigation -->
                <div class="opps-cat-nav-wrapper">
                    <div class="opps-cat-tabs">
                        <button type="button" class="opps-cat-pill active" onclick="setInternshipCategory('', this);">All Internships</button>
                        <button type="button" class="opps-cat-pill" onclick="setInternshipCategory('Software', this);">Software Dev</button>
                        <button type="button" class="opps-cat-pill" onclick="setInternshipCategory('Design', this);">UI/UX Design</button>
                        <button type="button" class="opps-cat-pill" onclick="setInternshipCategory('Data', this);">Data Science</button>
                        <button type="button" class="opps-cat-pill" onclick="setInternshipCategory('Marketing', this);">Marketing</button>
                    </div>
                </div>

                <!-- =================================================================
                     [DYNAMIC INTERNSHIPS FEED]: Binds from 'jobs' / 'internships'
                     ================================================================= -->
                <div class="opps-section-group opps-recent-postings-section" style="margin-top: 24px;">
                    <div class="opps-group-header flex-between">
                        <h2 class="opps-group-title">Available Internships</h2>
                        <span class="opps-total-results">Live Opportunities</span>
                    </div>

                    <div class="opps-listings-stack" id="internshipsContainer">
                        <asp:Repeater ID="rptInternshipsList" runat="server">
                            <ItemTemplate>
                                <div class="opp-listing-card"
                                     data-title='<%# Eval("Title") %>'
                                     data-company='<%# Eval("CompanyName") %>'
                                     data-location='<%# Eval("Location") %>'
                                     data-skills='<%# Eval("RequiredSkills") %>'
                                     data-type='<%# Eval("JobType") %>'
                                     data-stipend='<%# Eval("SalaryRange") %>'>
                                    <div class="opp-listing-top">
                                        <div class="opp-listing-brand-wrap">
                                            <div class="opp-company-avatar">
                                                <i class="fa-solid fa-graduation-cap" style="font-size:20px; color:#2563eb;"></i>
                                            </div>
                                            <div class="opp-listing-info">
                                                <h3 class="opp-card-heading">
                                                    <a href='<%# ResolveUrl("~/User/JobDetails.aspx?id=" + Eval("JobId")) %>'>
                                                        <%# Eval("Title") %>
                                                    </a>
                                                </h3>
                                                <div class="opp-card-sub"><%# Eval("CompanyName") %> &bull; <%# Eval("Location") %></div>
                                            </div>
                                        </div>
                                        <span class="opp-match-pill" style="font-size:11px; padding:3px 8px; border-radius:6px; background:#eff6ff; color:#2563eb; font-weight:600;">
                                            <%# Eval("AiMatchScore") %>% Match
                                        </span>
                                    </div>

                                    <div class="opp-listing-meta-row">
                                        <span class="opp-meta-item"><i class="fa-solid fa-briefcase"></i> <%# Eval("JobType") %></span>
                                        <span class="opp-meta-item"><i class="fa-solid fa-wallet"></i> <%# Eval("SalaryRange") %></span>
                                    </div>

                                    <div class="opp-listing-footer flex-between" style="margin-top: 10px;">
                                        <span style="font-size:12px; color:#64748b;"><strong>Skills:</strong> <%# Eval("RequiredSkills") %></span>
                                        <%# Convert.ToBoolean(Eval("HasApplied")) 
                                            ? "<span style='padding:5px 12px; font-size:12px; font-weight:600; border-radius:6px; background:#dcfce7; color:#15803d; display:inline-flex; align-items:center; gap:4px;'><i class=\"fa-solid fa-check\"></i> Applied</span>" 
                                            : "<a href='" + ResolveUrl("~/User/JobDetails.aspx?id=" + Eval("JobId")) + "' class='btn-rec-apply' style='padding:4px 12px; font-size:12px; text-decoration:none;'>Apply Now</a>" %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <!-- Filter Empty State -->
                        <div id="internEmptyState" style="display:none; padding:40px 20px; text-align:center; color:#64748b; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:12px; margin-top:16px;">
                            <i class="fa-solid fa-graduation-cap" style="font-size:32px; color:#94a3b8; margin-bottom:12px; display:block;"></i>
                            <h4 style="font-size:16px; font-weight:700; color:#1e293b; margin-bottom:6px;">No internships match your filters</h4>
                            <p style="font-size:13px; color:#64748b; margin:0 0 16px;">Try clearing some filters or searching for different locations.</p>
                            <button type="button" onclick="resetFilters();" style="padding:8px 18px; background:#2563eb; color:#fff; border:none; border-radius:6px; font-size:13px; font-weight:600; cursor:pointer;">Clear Filters</button>
                        </div>
                    </div>
                </div>

            </main>

        </div>

    </div>

    <script type="text/javascript">
        let selectedInternCat = '';
        let selectedInternLocPill = '';

        function setInternshipCategory(cat, btn) {
            selectedInternCat = cat.toLowerCase();
            document.querySelectorAll('.opps-cat-pill').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');
            applyInternshipFilters();
        }

        function setInternLocation(loc, btn) {
            selectedInternLocPill = loc.toLowerCase();
            document.querySelectorAll('.filter-pill-tags .filter-pill-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');
            applyInternshipFilters();
        }

        function applyInternshipFilters() {
            const locInput = (document.getElementById('txtInternLocation')?.value || '').toLowerCase().trim();
            const typeCbs = Array.from(document.querySelectorAll('.intern-type-cb:checked')).map(cb => cb.value.toLowerCase());
            const stipendVal = document.querySelector('input[name="stipend"]:checked')?.value || 'all';

            const cards = document.querySelectorAll('.opp-listing-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const title = (card.getAttribute('data-title') || '').toLowerCase();
                const company = (card.getAttribute('data-company') || '').toLowerCase();
                const location = (card.getAttribute('data-location') || '').toLowerCase();
                const skills = (card.getAttribute('data-skills') || '').toLowerCase();
                const type = (card.getAttribute('data-type') || '').toLowerCase();
                const stipend = (card.getAttribute('data-stipend') || '').toLowerCase();
                const combined = `${title} ${company} ${location} ${skills} ${type}`;

                // 1. Category match
                const matchesCat = !selectedInternCat || combined.includes(selectedInternCat);

                // 2. Location match
                const matchesLocInput = !locInput || location.includes(locInput) || combined.includes(locInput);
                const matchesLocPill = !selectedInternLocPill || location.includes(selectedInternLocPill);

                // 3. Work Type match
                const matchesType = typeCbs.length === 0 || typeCbs.some(t => type.includes(t) || location.includes(t) || combined.includes(t));

                // 4. Stipend match
                let matchesStipend = true;
                if (stipendVal === 'paid') {
                    matchesStipend = !stipend.includes('unpaid') && !stipend.includes('0');
                } else if (stipendVal === 'high') {
                    matchesStipend = stipend.includes('20') || stipend.includes('25') || stipend.includes('30') || stipend.includes('40') || stipend.includes('50');
                }

                if (matchesCat && matchesLocInput && matchesLocPill && matchesType && matchesStipend) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            const empty = document.getElementById('internEmptyState');
            if (empty) {
                empty.style.display = (visibleCount === 0 && cards.length > 0) ? 'block' : 'none';
            }
        }

        function resetFilters() {
            const locInput = document.getElementById('txtInternLocation');
            if (locInput) locInput.value = '';

            document.querySelectorAll('.intern-type-cb').forEach(cb => cb.checked = false);

            const allRadio = document.querySelector('input[name="stipend"][value="all"]');
            if (allRadio) allRadio.checked = true;

            selectedInternCat = '';
            const firstCatPill = document.querySelector('.opps-cat-pill');
            if (firstCatPill) {
                document.querySelectorAll('.opps-cat-pill').forEach(b => b.classList.remove('active'));
                firstCatPill.classList.add('active');
            }

            selectedInternLocPill = '';
            const firstLocPill = document.querySelector('.filter-pill-tags .filter-pill-btn');
            if (firstLocPill) {
                document.querySelectorAll('.filter-pill-tags .filter-pill-btn').forEach(b => b.classList.remove('active'));
                firstLocPill.classList.add('active');
            }

            applyInternshipFilters();
        }
    </script>
</asp:Content>
