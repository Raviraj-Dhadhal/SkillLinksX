/* ==========================================================================
   SkillLinkX - Company JavaScript File (company.js)
   Contains all interactive behaviors and scripts for the Company Portal:
   1. Mobile Navigation Drawer (Open / Close Sidebar)
   2. Active Sidebar Link Detection based on Current Page URL
   3. Applications Overview Bar Chart (Powered by ApexCharts)
   4. Company Settings Page Tabs (Company Information / Team Members)
   5. Applicants Table Quick Preview Card Updates
   6. Post Job Form (Opportunity Type, Work Type, Dynamic Skill Tags)
   ========================================================================== */

/// Wait until the entire HTML page has loaded before running any script
document.addEventListener("DOMContentLoaded", function () {

    /* ----------------------------------------------------------------------
       1. Mobile Navigation Drawer (Open / Close Sidebar)
       ---------------------------------------------------------------------- */
    try {
        const sidebarToggle = document.getElementById("sidebarToggle");       // Hamburger button on mobile
        const companySidebar = document.getElementById("companySidebar");     // Left sidebar element
        const sidebarBackdrop = document.getElementById("sidebarBackdrop");   // Dark dim background overlay

        // Function to open the sidebar on mobile devices
        function openSidebar() {
            if (companySidebar && sidebarBackdrop) {
                companySidebar.classList.add("open");          // Slide in the sidebar
                sidebarBackdrop.classList.add("show");         // Display the dark dim background overlay
                document.body.style.overflow = "hidden";       // Prevent background page from scrolling
            }
        }

        // Function to close the sidebar on mobile devices
        function closeSidebar() {
            if (companySidebar && sidebarBackdrop) {
                companySidebar.classList.remove("open");       // Slide sidebar back off-screen
                sidebarBackdrop.classList.remove("show");      // Hide the dim background overlay
                document.body.style.overflow = "";             // Restore normal page scrolling
            }
        }

        // Click event for the hamburger button
        if (sidebarToggle) {
            sidebarToggle.addEventListener("click", function (e) {
                e.stopPropagation(); // Stop click from propagating to other elements
                if (companySidebar && companySidebar.classList.contains("open")) {
                    closeSidebar();
                } else {
                    openSidebar();
                }
            });
        }

        // Click event for the dim background overlay (clicking outside closes the sidebar)
        if (sidebarBackdrop) {
            sidebarBackdrop.addEventListener("click", closeSidebar);
        }
    } catch (err) {
        console.warn("SkillLinkX: Sidebar init warning", err);
    }

    /* ----------------------------------------------------------------------
       2. Active Sidebar Link Highlighting
       ---------------------------------------------------------------------- */
    try {
        const currentPath = window.location.pathname.toLowerCase();
        const sidebarLinks = document.querySelectorAll(".sidebar-link, .sidebar-footer-link");

        sidebarLinks.forEach(function (link) {
            link.classList.remove("active");
            if (link.classList.contains("logout")) return; // Don't highlight logout link

            const href = link.getAttribute("href");
            if (href) {
                try {
                    const linkUrl = new URL(link.href, window.location.origin);
                    const linkPath = linkUrl.pathname.toLowerCase();
                    const fileName = linkPath.split('/').pop();
                    if (currentPath === linkPath || (fileName && currentPath.endsWith(fileName))) {
                        link.classList.add("active");
                    }
                } catch (e) {
                    // Ignore URL parsing errors
                }
            }
        });
    } catch (err) {
        console.warn("SkillLinkX: Active sidebar link warning", err);
    }

    /* ----------------------------------------------------------------------
       3. Applications Overview ApexCharts (Analytics Page)
       ---------------------------------------------------------------------- */
    function renderOverviewChart() {
        const chartContainer = document.querySelector("#applicationsOverviewChart");
        if (!chartContainer) return;

        if (typeof ApexCharts === "undefined") {
            // If the CDN script is still downloading, retry briefly
            setTimeout(renderOverviewChart, 150);
            return;
        }

        // Clear existing chart if any
        chartContainer.innerHTML = "";

        // Options configuring the ApexCharts bar graph
        const chartOptions = {
            series: [{
                name: 'Applications',
                data: [180, 290, 240, 420, 380, 520, 520, 490] // Monthly application counts
            }],
            chart: {
                type: 'bar',
                height: 290,
                toolbar: { show: false }, // Hide chart download/zoom tools
                fontFamily: 'inherit'
            },
            plotOptions: {
                bar: {
                    borderRadius: 6,      // Rounded top edges on bars
                    columnWidth: '60%',   // Bar thickness
                    distributed: false
                }
            },
            dataLabels: {
                enabled: false            // Hide values on top of bars
            },
            colors: ['#2563EB'],          // SkillLinkX Blue branding color
            xaxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'],
                axisBorder: { show: false },
                axisTicks: { show: false },
                labels: {
                    style: {
                        colors: '#64748B',
                        fontSize: '12px'
                    }
                }
            },
            yaxis: {
                show: false               // Clean borderless look matching Figma
            },
            grid: {
                show: false,
                padding: { left: 0, right: 0 }
            },
            tooltip: {
                theme: 'light',
                y: {
                    formatter: function (val) {
                        return val + " candidates"; // Display count on hover
                    }
                }
            }
        };

        try {
            const chart = new ApexCharts(chartContainer, chartOptions);
            chart.render();
        } catch (chartErr) {
            console.error("SkillLinkX: ApexCharts render error", chartErr);
        }
    }

    try {
        renderOverviewChart();
    } catch (err) {
        console.warn("SkillLinkX: Chart init warning", err);
    }

    /* ----------------------------------------------------------------------
       4. Applicants Table Row Selection & Quick Preview (Applicants Page)
       ---------------------------------------------------------------------- */
    try {
        const candidateRows = document.querySelectorAll(".candidate-row");
        const quickName = document.getElementById("quickName");
        const quickRole = document.getElementById("quickRole");
        const quickAvatar = document.getElementById("quickAvatar");
        const quickScore = document.getElementById("quickScore");
        const quickEdu = document.getElementById("quickEdu");
        const quickDegree = document.getElementById("quickDegree");

        candidateRows.forEach(function (row) {
            row.addEventListener("click", function (e) {
                // Ignore click if clicking directly on a checkbox
                if (e.target.tagName && e.target.tagName.toLowerCase() === "input" && e.target.type === "checkbox") return;

                // Highlight the clicked row
                candidateRows.forEach(r => r.classList.remove("selected-row"));
                row.classList.add("selected-row");

                // Extract candidate data from attributes
                const name = row.getAttribute("data-candidate-name");
                const role = row.getAttribute("data-candidate-role");
                const match = row.getAttribute("data-candidate-match");
                const edu = row.getAttribute("data-candidate-edu");
                const degree = row.getAttribute("data-candidate-degree");
                const img = row.getAttribute("data-candidate-img");

                // Update the preview card on the right
                if (quickName && name) quickName.textContent = name;
                if (quickRole && role) quickRole.textContent = role;
                if (quickScore && match) quickScore.textContent = match;
                if (quickEdu && edu) quickEdu.textContent = edu;
                if (quickDegree && degree) quickDegree.textContent = degree;
                if (quickAvatar && img) {
                    quickAvatar.src = img;
                    if (img.indexOf("female") !== -1) {
                        quickAvatar.style.objectPosition = "50% 8%";
                    } else {
                        quickAvatar.style.objectPosition = "50% 15%";
                    }
                }
            });
        });
    } catch (err) {
        console.warn("SkillLinkX: Applicants preview warning", err);
    }

    /* ----------------------------------------------------------------------
       5. Post Job / Internship Form Interactions (PostJob Page)
       ---------------------------------------------------------------------- */
    try {
        // 5A. Opportunity Type (Job / Internship)
        const oppButtons = document.querySelectorAll("#oppTypeSelector .pill-btn");
        const hfOppType = document.querySelector("input[id*='hfOpportunityType']");
        oppButtons.forEach(function (btn) {
            btn.addEventListener("click", function () {
                oppButtons.forEach(b => b.classList.remove("active"));
                btn.classList.add("active");
                if (hfOppType) {
                    hfOppType.value = btn.getAttribute("data-type");
                }
            });
        });

        // 5B. Work Type (Remote / Hybrid / On-site)
        const workButtons = document.querySelectorAll("#workTypeSelector .pill-btn");
        const hfWorkType = document.querySelector("input[id*='hfWorkType']");
        workButtons.forEach(function (btn) {
            btn.addEventListener("click", function () {
                workButtons.forEach(b => b.classList.remove("active"));
                btn.classList.add("active");
                if (hfWorkType) {
                    hfWorkType.value = btn.getAttribute("data-work");
                }
            });
        });

        // 5C. Dynamic Skills Input Tags
        const inputSkill = document.getElementById("inputNewSkill");
        const btnAddSkill = document.getElementById("btnAddSkill");
        const skillsList = document.getElementById("skillsTagList");

        function addSkillTag() {
            if (!inputSkill || !skillsList) return;
            const val = inputSkill.value.trim();
            if (val) {
                const span = document.createElement("span");
                span.className = "skill-tag-pill";
                span.innerHTML = val + ' <i class="fa-solid fa-xmark"></i>';
                span.querySelector("i").addEventListener("click", function () {
                    span.remove(); // Remove tag when X is clicked
                });
                skillsList.appendChild(span);
                inputSkill.value = "";
            }
        }

        if (btnAddSkill) {
            btnAddSkill.addEventListener("click", addSkillTag);
        }
        if (inputSkill) {
            inputSkill.addEventListener("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    addSkillTag();
                }
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Post job form warning", err);
    }

});

/* ----------------------------------------------------------------------
   6. Global Helper: Settings Tab Switcher (Settings Page)
   ---------------------------------------------------------------------- */
function showSettingsTab(tabId, el) {
    // 1. Update the active style indicator on the clicked tab item
    const items = document.querySelectorAll('.settings-nav-item');
    items.forEach(function (item) {
        item.classList.remove('active');
        const bar = item.querySelector('.nav-active-bar');
        if (bar) bar.remove();
    });

    if (el && el.parentElement) {
        el.parentElement.classList.add('active');
        const activeBar = document.createElement('span');
        activeBar.className = 'nav-active-bar';
        el.prepend(activeBar);
    }

    // 2. Toggle the visibility of the settings cards
    const secCompany = document.getElementById('sectionCompanyInfo');
    const secTeam = document.getElementById('sectionTeamMembers');

    if (tabId === 'team-members-tab') {
        if (secCompany) secCompany.style.display = 'none';
        if (secTeam) secTeam.style.display = 'block';
    } else {
        if (secCompany) secCompany.style.display = 'block';
        if (secTeam) secTeam.style.display = 'block';
    }
}