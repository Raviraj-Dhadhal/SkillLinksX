/**
 * =============================================================================
 * SkillLinksX - Global Unified Search Component (global-search.js)
 * =============================================================================
 * This script powers the global search input across the entire website:
 * 1. User Header (User.Master)
 * 2. Company Header (Company.Master)
 * 3. Admin Header (Admin.Master)
 * 4. Public Home Page (Public/Home.aspx)
 *
 * It listens for user typing, fetches live matching results from
 * /Handlers/SearchHandler.ashx, and renders a floating grouped dropdown
 * displaying Jobs, Internships, and People.
 * =============================================================================
 */

(function () {
    "use strict";

    // Track active debounce timer so we don't spam the server on every keystroke
    var debounceTimer = null;

    // Track the currently active dropdown element on the page
    var activeDropdown = null;

    // Track keyboard navigation selected index (-1 means none selected)
    var highlightedIndex = -1;

    /**
     * Helper: Resolves application base URL for API calls.
     * Checks if ASP.NET injected window.SKILLLINKSX_SEARCH_HANDLER_URL,
     * or computes the correct root path dynamically.
     */
    function getApiUrl(endpoint) {
        if (window.SKILLLINKSX_SEARCH_HANDLER_URL && endpoint.indexOf("/Handlers/SearchHandler.ashx") > -1) {
            return window.SKILLLINKSX_SEARCH_HANDLER_URL;
        }

        var origin = window.location.origin;
        var pathname = window.location.pathname;

        // Check if there is an application virtual directory (e.g. /SkillLinksX/...)
        // By looking at the first path segment that is NOT a known application folder
        var pathSegments = pathname.split("/").filter(Boolean);
        var knownSections = ["user", "company", "admin", "public", "handlers", "assets"];

        var virtualDir = "";
        if (pathSegments.length > 0 && knownSections.indexOf(pathSegments[0].toLowerCase()) === -1) {
            virtualDir = "/" + pathSegments[0];
        }

        return origin + virtualDir + endpoint;
    }

    /**
     * Builds and injects the CSS styles for the search dropdown once.
     */
    function injectDropdownStyles() {
        if (document.getElementById("global-search-styles")) return;

        var style = document.createElement("style");
        style.id = "global-search-styles";
        style.textContent = `
            .global-search-wrapper-rel {
                position: relative !important;
            }
            .global-search-dropdown {
                position: absolute;
                top: calc(100% + 8px);
                left: 0;
                width: 100%;
                min-width: 340px;
                max-width: 100%;
                background: #FFFFFF;
                border: 1px solid #E2E8F0;
                border-radius: 12px;
                box-shadow: 0 12px 32px rgba(15, 23, 42, 0.12), 0 4px 12px rgba(15, 23, 42, 0.06);
                z-index: 99999;
                max-height: 420px;
                overflow-y: auto;
                font-family: inherit;
                display: none;
                animation: gSearchFadeIn 0.15s ease-out;
            }
            .global-search-dropdown::-webkit-scrollbar {
                width: 6px;
            }
            .global-search-dropdown::-webkit-scrollbar-track {
                background: #F8FAFC;
                border-radius: 0 12px 12px 0;
            }
            .global-search-dropdown::-webkit-scrollbar-thumb {
                background: #CBD5E1;
                border-radius: 4px;
            }
            .global-search-dropdown::-webkit-scrollbar-thumb:hover {
                background: #94A3B8;
            }
            @keyframes gSearchFadeIn {
                from { opacity: 0; transform: translateY(-4px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .gs-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 16px;
                text-decoration: none;
                color: #1E293B;
                transition: background 0.15s ease;
                border-bottom: 1px solid #F8FAFC;
                cursor: pointer;
            }
            .gs-item:hover, .gs-item.gs-highlighted {
                background: #EFF6FF;
            }
            .gs-item-avatar {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                background: #E0E7FF;
                color: #0040A2;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 15px;
                flex-shrink: 0;
                overflow: hidden;
                position: relative;
                box-sizing: border-box;
            }
            .gs-item-avatar.is-circle {
                border-radius: 50%;
                background: #EEF2FF;
                color: #4F46E5;
            }
            .gs-item-avatar i {
                font-size: 15px;
                line-height: 1;
                color: #0040A2;
                display: inline-block;
            }
            .gs-item-avatar.is-circle i {
                color: #4F46E5;
            }
            .gs-item-avatar .gs-avatar-img {
                width: 100%;
                height: 100%;
                object-fit: contain;
                border-radius: inherit;
                background: #FFFFFF;
                display: block;
                box-sizing: border-box;
                padding: 3px;
            }
            .gs-item-content {
                flex: 1;
                min-width: 0;
            }
            .gs-item-title {
                font-size: 13.5px;
                font-weight: 600;
                color: #0F172A;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .gs-item-sub {
                font-size: 12px;
                color: #64748B;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                margin-top: 2px;
            }
            .gs-item-skills {
                display: flex;
                gap: 4px;
                flex-wrap: wrap;
                margin-top: 4px;
            }
            .gs-skill-badge {
                font-size: 10.5px;
                padding: 2px 6px;
                border-radius: 4px;
                background: #F1F5F9;
                color: #475569;
                font-weight: 500;
            }
            .gs-status-loading {
                padding: 18px 16px;
                text-align: center;
                color: #64748B;
                font-size: 13px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            .gs-status-empty {
                padding: 24px 16px;
                text-align: center;
                color: #64748B;
                font-size: 13px;
            }
            .gs-status-empty i {
                font-size: 24px;
                color: #94A3B8;
                display: block;
                margin-bottom: 8px;
            }
            .gs-footer-bar {
                padding: 8px 16px;
                font-size: 11.5px;
                color: #94A3B8;
                background: #F8FAFC;
                border-top: 1px solid #E2E8F0;
                border-radius: 0 0 12px 12px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .gs-footer-hint kbd {
                background: #FFFFFF;
                border: 1px solid #CBD5E1;
                border-radius: 4px;
                padding: 1px 4px;
                font-size: 10px;
                color: #475569;
            }
        `;
        document.head.appendChild(style);
    }

    /**
     * Creates or gets the dropdown element attached to an input's parent wrapper.
     */
    function getOrCreateDropdown(inputElement) {
        var wrapper = inputElement.closest(".search-bar-wrapper") || 
                      inputElement.closest(".topbar-search") || 
                      inputElement.parentElement;
        if (!wrapper) return null;

        // Ensure parent wrapper has relative positioning
        wrapper.classList.add("global-search-wrapper-rel");

        var dropdown = wrapper.querySelector(".global-search-dropdown");
        if (!dropdown) {
            dropdown = document.createElement("div");
            dropdown.className = "global-search-dropdown";
            wrapper.appendChild(dropdown);
        }
        return dropdown;
    }

    /**
     * Hides and clears the active dropdown.
     */
    function closeActiveDropdown() {
        if (activeDropdown) {
            activeDropdown.style.display = "none";
            activeDropdown.innerHTML = "";
            activeDropdown = null;
            highlightedIndex = -1;
        }
    }

    /**
     * Builds avatar markup with clean, bulletproof fallback:
     * - If an image URL exists, render <img> directly (with fallback icon hidden).
     * - If the image fails/404s, onerror hides the image and shows the clean fallback icon.
     * - If no image URL exists, render only the clean default icon.
     * This guarantees an image and an icon can NEVER overlap or collide!
     */
    function buildAvatarHtml(imageUrl, fallbackIconClass, isCircle) {
        var circleClass = isCircle ? " is-circle" : "";
        if (imageUrl) {
            return `<div class="gs-item-avatar${circleClass}">
                <img src="${imageUrl}" alt="" class="gs-avatar-img" onerror="this.style.display='none'; if(this.nextElementSibling) this.nextElementSibling.style.display='inline-block';" />
                <i class="${fallbackIconClass}" style="display:none;"></i>
            </div>`;
        } else {
            return `<div class="gs-item-avatar${circleClass}"><i class="${fallbackIconClass}"></i></div>`;
        }
    }

    /**
     * Renders matching results inside the dropdown.
     */
    function renderResults(dropdown, data, query, inputElement) {
        dropdown.innerHTML = "";
        highlightedIndex = -1;

        var totalCount = 0;
        var jobs = data.jobs || [];
        var internships = data.internships || [];
        var people = data.people || [];
        totalCount = jobs.length + internships.length + people.length;

        // Empty state: no matching items in any category
        if (totalCount === 0) {
            dropdown.innerHTML = `
                <div class="gs-status-empty">
                    <i class="fa-regular fa-folder-open"></i>
                    <div>No results found for <strong>"${escapeHtml(query)}"</strong></div>
                    <div style="font-size:11.5px; color:#94A3B8; margin-top:4px;">Try searching for job titles, technologies, skills, or people names.</div>
                </div>
            `;
            dropdown.style.display = "block";
            activeDropdown = dropdown;
            return;
        }

        var fragment = document.createDocumentFragment();

        // 1. RENDER JOBS
        if (jobs.length > 0) {
            jobs.forEach(function (job) {
                var item = document.createElement("a");
                item.className = "gs-item";
                item.href = job.url;

                // Company logo with fallback to fa-solid fa-building
                var avatarHtml = buildAvatarHtml(job.logo, "fa-solid fa-building", false);

                // Display first 2 skills as tags
                var skillsHtml = "";
                if (job.skills) {
                    var skillsArr = job.skills.split(",").slice(0, 2);
                    skillsHtml = `<div class="gs-item-skills">` + 
                        skillsArr.map(function(s) { return `<span class="gs-skill-badge">${escapeHtml(s.trim())}</span>`; }).join("") +
                        `</div>`;
                }

                item.innerHTML = `
                    ${avatarHtml}
                    <div class="gs-item-content">
                        <div class="gs-item-title">${escapeHtml(job.title)}</div>
                        <div class="gs-item-sub">${escapeHtml(job.subtitle)}</div>
                        ${skillsHtml}
                    </div>
                `;
                fragment.appendChild(item);
            });
        }

        // 2. RENDER INTERNSHIPS
        if (internships.length > 0) {
            internships.forEach(function (intern) {
                var item = document.createElement("a");
                item.className = "gs-item";
                item.href = intern.url;

                // Internship company logo with fallback to fa-solid fa-graduation-cap
                var avatarHtml = buildAvatarHtml(intern.logo, "fa-solid fa-graduation-cap", false);

                var skillsHtml = "";
                if (intern.skills) {
                    var skillsArr = intern.skills.split(",").slice(0, 2);
                    skillsHtml = `<div class="gs-item-skills">` + 
                        skillsArr.map(function(s) { return `<span class="gs-skill-badge">${escapeHtml(s.trim())}</span>`; }).join("") +
                        `</div>`;
                }

                item.innerHTML = `
                    ${avatarHtml}
                    <div class="gs-item-content">
                        <div class="gs-item-title">${escapeHtml(intern.title)}</div>
                        <div class="gs-item-sub">${escapeHtml(intern.subtitle)}</div>
                        ${skillsHtml}
                    </div>
                `;
                fragment.appendChild(item);
            });
        }

        // 3. RENDER PEOPLE & COMPANIES
        if (people.length > 0) {
            people.forEach(function (person) {
                var item = document.createElement("a");
                item.className = "gs-item";
                item.href = person.url;

                var isCandidate = person.type === "Candidate";
                var fallbackIcon = isCandidate ? "fa-regular fa-user" : "fa-solid fa-building";
                var avatarHtml = buildAvatarHtml(person.logo, fallbackIcon, isCandidate);

                var skillsHtml = "";
                if (person.skills) {
                    var skillsArr = person.skills.split(",").slice(0, 2);
                    skillsHtml = `<div class="gs-item-skills">` + 
                        skillsArr.map(function(s) { return `<span class="gs-skill-badge">${escapeHtml(s.trim())}</span>`; }).join("") +
                        `</div>`;
                }

                item.innerHTML = `
                    ${avatarHtml}
                    <div class="gs-item-content">
                        <div class="gs-item-title">${escapeHtml(person.title)} <span style="font-size:11px; font-weight:normal; color:#64748B;">(${person.type})</span></div>
                        <div class="gs-item-sub">${escapeHtml(person.subtitle)}</div>
                        ${skillsHtml}
                    </div>
                `;
                fragment.appendChild(item);
            });
        }

        // 4. FOOTER HINT BAR
        var footer = document.createElement("div");
        footer.className = "gs-footer-bar";
        footer.innerHTML = `
            <span>Showing ${totalCount} results</span>
            <span class="gs-footer-hint">Press <kbd>Esc</kbd> to exit • <kbd>Enter</kbd> to view all</span>
        `;
        fragment.appendChild(footer);

        dropdown.appendChild(fragment);
        dropdown.style.display = "block";
        activeDropdown = dropdown;
    }

    /**
     * Executes the search request to /Handlers/SearchHandler.ashx
     */
    function performSearch(query, inputElement) {
        var dropdown = getOrCreateDropdown(inputElement);
        if (!dropdown) return;

        // Show subtle loading state
        dropdown.innerHTML = `
            <div class="gs-status-loading">
                <i class="fa-solid fa-circle-notch fa-spin"></i> Searching SkillLinkX...
            </div>
        `;
        dropdown.style.display = "block";
        activeDropdown = dropdown;

        var requestUrl = getApiUrl("/Handlers/SearchHandler.ashx") + "?q=" + encodeURIComponent(query);

        fetch(requestUrl, {
            method: "GET",
            headers: { "Accept": "application/json" }
        })
        .then(function (res) {
            if (!res.ok) throw new Error("Search server returned status " + res.status);
            return res.json();
        })
        .then(function (data) {
            renderResults(dropdown, data, query, inputElement);
        })
        .catch(function (err) {
            console.warn("SkillLinkX: Global search request failed", err);
            dropdown.innerHTML = `
                <div class="gs-status-empty" style="color:#EF4444;">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>Unable to complete search. Please try again.</div>
                </div>
            `;
            dropdown.style.display = "block";
        });
    }

    /**
     * Handles full search redirection when Enter is pressed or Search button is clicked
     */
    function routeFullSearch(query) {
        if (!query || query.trim().length === 0) return;
        var q = encodeURIComponent(query.trim());
        var path = window.location.pathname.toLowerCase();

        if (path.indexOf("/company/") > -1) {
            window.location.href = getApiUrl("/Company/Applicants.aspx") + "?q=" + q;
        } else if (path.indexOf("/admin/") > -1) {
            window.location.href = getApiUrl("/Admin/JobsInternships.aspx") + "?q=" + q;
        } else {
            // User and Public landing page
            window.location.href = getApiUrl("/User/Jobs.aspx") + "?q=" + q;
        }
    }

    /**
     * Wires an individual search input element with event listeners.
     */
    function wireSearchInput(input) {
        if (!input || input.dataset.globalSearchWired === "true") return;
        input.dataset.globalSearchWired = "true";

        // Listen for typing with 250ms debounce
        input.addEventListener("input", function () {
            var val = (this.value || "").trim();
            clearTimeout(debounceTimer);

            if (val.length < 2) {
                closeActiveDropdown();
                return;
            }

            debounceTimer = setTimeout(function () {
                performSearch(val, input);
            }, 250);
        });

        // Listen for focus to re-open if text exists
        input.addEventListener("focus", function () {
            var val = (this.value || "").trim();
            if (val.length >= 2) {
                performSearch(val, input);
            }
        });

        // Listen for keyboard navigation (Arrows, Enter, Escape)
        input.addEventListener("keydown", function (e) {
            if (e.key === "Escape") {
                closeActiveDropdown();
                return;
            }

            if (!activeDropdown || activeDropdown.style.display === "none") {
                if (e.key === "Enter") {
                    e.preventDefault();
                    routeFullSearch(this.value);
                }
                return;
            }

            var items = activeDropdown.querySelectorAll(".gs-item");
            if (items.length === 0) return;

            if (e.key === "ArrowDown") {
                e.preventDefault();
                highlightedIndex = (highlightedIndex + 1) % items.length;
                updateHighlight(items);
            } else if (e.key === "ArrowUp") {
                e.preventDefault();
                highlightedIndex = (highlightedIndex - 1 + items.length) % items.length;
                updateHighlight(items);
            } else if (e.key === "Enter") {
                e.preventDefault();
                if (highlightedIndex >= 0 && items[highlightedIndex]) {
                    items[highlightedIndex].click();
                } else {
                    routeFullSearch(this.value);
                }
            }
        });
    }

    function updateHighlight(items) {
        items.forEach(function (item, idx) {
            if (idx === highlightedIndex) {
                item.classList.add("gs-highlighted");
                item.scrollIntoView({ block: "nearest" });
            } else {
                item.classList.remove("gs-highlighted");
            }
        });
    }

    function escapeHtml(str) {
        if (!str) return "";
        return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
    }

    /**
     * Initializes global search across the current page.
     */
    function initGlobalSearch() {
        injectDropdownStyles();

        // 1. Topbar headers (User.Master, Company.Master, Admin.Master)
        var topbarInputs = document.querySelectorAll(".topbar-search input, .header-search-box input, #txtGlobalHeaderSearch");
        topbarInputs.forEach(function (inp) {
            wireSearchInput(inp);
        });

        // 2. Public Home Page Hero Search (#txtSearchKeyword, #btnSearchJobs)
        var homeSearchInput = document.getElementById("txtSearchKeyword") || document.querySelector("input[id*='txtSearchKeyword']");
        var homeSearchBtn = document.getElementById("btnSearchJobs");
        if (homeSearchInput) {
            wireSearchInput(homeSearchInput);
            if (homeSearchBtn) {
                homeSearchBtn.addEventListener("click", function (e) {
                    e.preventDefault();
                    routeFullSearch(homeSearchInput.value);
                });
            }
        }

        // 3. Global click-outside listener to close dropdown smoothly
        document.addEventListener("click", function (e) {
            if (activeDropdown && !e.target.closest(".global-search-wrapper-rel")) {
                closeActiveDropdown();
            }
        });
    }

    // Initialize when DOM is ready
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initGlobalSearch);
    } else {
        initGlobalSearch();
    }
})();
