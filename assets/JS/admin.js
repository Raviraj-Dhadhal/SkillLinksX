/**
 * SkillLinkX - Admin Portal JavaScript (admin.js)
 * Manages Admin sidebar active link detection, mobile drawer toggles, and ApexCharts linear graph
 */

document.addEventListener("DOMContentLoaded", function () {

    /* ----------------------------------------------------------------------
       1. Mobile Sidebar Navigation Drawer & Overlay Toggle
       ---------------------------------------------------------------------- */
    try {
        const sidebarToggle = document.getElementById("sidebarToggle");
        const adminSidebar = document.getElementById("adminSidebar");
        const sidebarBackdrop = document.getElementById("sidebarBackdrop");

        function openSidebar() {
            if (adminSidebar) adminSidebar.classList.add("open");
            if (sidebarBackdrop) sidebarBackdrop.classList.add("show");
            document.body.style.overflow = "hidden";
        }

        function closeSidebar() {
            if (adminSidebar) adminSidebar.classList.remove("open");
            if (sidebarBackdrop) sidebarBackdrop.classList.remove("show");
            document.body.style.overflow = "";
        }

        if (sidebarToggle) {
            sidebarToggle.addEventListener("click", function (e) {
                e.stopPropagation();
                if (adminSidebar && adminSidebar.classList.contains("open")) {
                    closeSidebar();
                } else {
                    openSidebar();
                }
            });
        }

        if (sidebarBackdrop) {
            sidebarBackdrop.addEventListener("click", closeSidebar);
        }
    } catch (e) {
        console.warn("SkillLinkX: Admin sidebar toggle warning", e);
    }

    /* ----------------------------------------------------------------------
       2. Active Sidebar Link Detection
       ---------------------------------------------------------------------- */
    try {
        const currentPath = window.location.pathname.toLowerCase();
        const currentFile = currentPath.substring(currentPath.lastIndexOf("/") + 1) || "dashboard.aspx";
        const sidebarLinks = document.querySelectorAll(".admin-sidebar .sidebar-link");

        sidebarLinks.forEach(link => {
            const href = link.getAttribute("href");
            if (href) {
                const linkFile = href.substring(href.lastIndexOf("/") + 1).toLowerCase();
                if (linkFile === currentFile) {
                    link.classList.add("active");
                } else {
                    link.classList.remove("active");
                }
            }
        });
    } catch (e) {
        console.warn("SkillLinkX: Admin active link warning", e);
    }

    /* ----------------------------------------------------------------------
       3. User Growth Analytics ApexCharts (Linear Growth Area / Line Chart)
       ---------------------------------------------------------------------- */
    function renderUserGrowthChart() {
        const chartContainer = document.querySelector("#userGrowthChart");
        if (!chartContainer) return;

        if (typeof ApexCharts === "undefined") {
            // Retry briefly if CDN is still downloading
            setTimeout(renderUserGrowthChart, 150);
            return;
        }

        // Clear existing chart container
        chartContainer.innerHTML = "";

        const chartOptions = {
            series: [
                {
                    name: 'Students',
                    data: [12000, 18500, 24000, 31000, 38500, 45231]
                },
                {
                    name: 'Companies',
                    data: [420, 680, 950, 1250, 1580, 1845]
                }
            ],
            chart: {
                type: 'area',
                height: 270,
                toolbar: { show: false },
                fontFamily: 'Inter, sans-serif'
            },
            colors: ['#0040A2', '#10B981'],
            fill: {
                type: 'gradient',
                gradient: {
                    shadeIntensity: 1,
                    opacityFrom: 0.35,
                    opacityTo: 0.05,
                    stops: [0, 90, 100]
                }
            },
            stroke: {
                curve: 'smooth',
                width: 2.5
            },
            dataLabels: {
                enabled: false
            },
            xaxis: {
                categories: ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
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
                labels: {
                    style: {
                        colors: '#64748B',
                        fontSize: '12px'
                    },
                    formatter: function (val) {
                        return val >= 1000 ? (val / 1000).toFixed(0) + 'k' : val;
                    }
                }
            },
            grid: {
                borderColor: '#F1F5F9',
                strokeDashArray: 4,
                padding: { left: 10, right: 10, top: 0, bottom: 0 }
            },
            legend: {
                position: 'top',
                horizontalAlign: 'right',
                fontSize: '12px',
                labels: {
                    colors: '#475569'
                },
                markers: {
                    radius: 12
                }
            },
            tooltip: {
                theme: 'light',
                y: {
                    formatter: function (val) {
                        return val.toLocaleString();
                    }
                }
            }
        };

        try {
            const chart = new ApexCharts(chartContainer, chartOptions);
            chart.render();
        } catch (chartErr) {
            console.error("SkillLinkX: Admin ApexCharts render error", chartErr);
        }
    }

    try {
        renderUserGrowthChart();
    } catch (err) {
        console.warn("SkillLinkX: userGrowthChart init error", err);
    }

    /* ----------------------------------------------------------------------
       4. Admin Dashboard - Pending Approvals Table Filter
       ---------------------------------------------------------------------- */
    try {
        const btnFilter = document.querySelector(".btn-admin-filter");
        const btnViewAll = document.querySelector(".btn-admin-view-all");
        const tableRows = document.querySelectorAll(".admin-activity-card .admin-data-table tbody tr");

        if (btnFilter && tableRows.length > 0) {
            btnFilter.addEventListener("click", function () {
                tableRows.forEach(function (row) {
                    const statusBadge = row.querySelector(".badge-status-pending");
                    if (statusBadge) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });

                btnFilter.classList.add("active");
                if (btnViewAll) btnViewAll.classList.remove("active");
            });
        }

        if (btnViewAll && tableRows.length > 0) {
            btnViewAll.addEventListener("click", function () {
                tableRows.forEach(function (row) {
                    row.style.display = "";
                });

                btnViewAll.classList.add("active");
                if (btnFilter) btnFilter.classList.remove("active");
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Admin table filter error", err);
    }

    /* ----------------------------------------------------------------------
       5. Manage Students - Row Selection & Details Sidebar Dynamic Update
       ---------------------------------------------------------------------- */
    try {
        const studentRows = document.querySelectorAll(".student-row");
        const studentSidebar = document.getElementById("studentDetailsCard") || document.getElementById("studentDetailsSidebar");
        const btnCloseStudentDetails = document.getElementById("btnCloseStudentDetails");

        if (studentRows.length > 0 && studentSidebar) {
            studentRows.forEach(row => {
                row.addEventListener("click", function (e) {
                    // Ignore clicks if clicking directly on a checkbox
                    if (e.target.type === "checkbox") return;

                    studentRows.forEach(r => r.classList.remove("active-row"));
                    this.classList.add("active-row");

                    const name = this.getAttribute("data-name") || "Student";
                    const email = this.getAttribute("data-email") || "";
                    const avatar = this.getAttribute("data-avatar") || "../assets/Images/profile.png";
                    const status = this.getAttribute("data-status") || "Active Account";
                    const college = this.getAttribute("data-college") || "";
                    const degree = this.getAttribute("data-degree") || "";
                    const cgpa = this.getAttribute("data-cgpa") || "";
                    const skills = (this.getAttribute("data-skills") || "").split(",").map(s => s.trim()).filter(Boolean);
                    const resume = this.getAttribute("data-resume") || "Student_Resume.pdf";

                    // Update UI elements
                    const sdName = document.getElementById("sdName");
                    const sdEmail = document.getElementById("sdEmail");
                    const sdAvatar = document.getElementById("sdAvatar");
                    const sdStatus = document.getElementById("sdStatus");
                    const sdCollege = document.getElementById("sdCollege");
                    const sdDegree = document.getElementById("sdDegree");
                    const sdCgpa = document.getElementById("sdCgpa");
                    const sdSkills = document.getElementById("sdSkills");
                    const sdResumeName = document.getElementById("sdResumeName");

                    if (sdName) sdName.textContent = name;
                    if (sdEmail) sdEmail.textContent = email;
                    if (sdAvatar) sdAvatar.src = avatar;
                    if (sdStatus) {
                        sdStatus.textContent = status;
                        sdStatus.className = "student-badge-status " + (status.toLowerCase().includes("inactive") ? "status-inactive" : "status-active");
                    }
                    if (sdCollege) sdCollege.textContent = college;
                    if (sdDegree) sdDegree.textContent = degree;
                    if (sdCgpa) sdCgpa.textContent = cgpa;
                    if (sdResumeName) sdResumeName.textContent = resume;

                    if (sdSkills) {
                        sdSkills.innerHTML = "";
                        skills.forEach(skill => {
                            const badge = document.createElement("span");
                            badge.className = "badge-skill";
                            badge.textContent = skill;
                            sdSkills.appendChild(badge);
                        });
                    }

                    studentSidebar.style.display = "block";
                });
            });

            if (btnCloseStudentDetails) {
                btnCloseStudentDetails.addEventListener("click", function (e) {
                    e.stopPropagation();
                    studentSidebar.style.display = "none";
                    studentRows.forEach(r => r.classList.remove("active-row"));
                });
            }
        }
    } catch (err) {
        console.warn("SkillLinkX: Students table row selection error", err);
    }

    /* ----------------------------------------------------------------------
       6. Manage Companies - Row Selection & Details Sidebar Dynamic Update
       ---------------------------------------------------------------------- */
    try {
        const companyRows = document.querySelectorAll(".company-row");
        const companySidebar = document.getElementById("companyDetailsCard") || document.getElementById("companyDetailsSidebar");
        const btnCloseCompanyDetails = document.getElementById("btnCloseCompanyDetails");

        if (companyRows.length > 0 && companySidebar) {
            companyRows.forEach(row => {
                row.addEventListener("click", function (e) {
                    if (e.target.type === "checkbox") return;

                    companyRows.forEach(r => r.classList.remove("active-row"));
                    this.classList.add("active-row");

                    const name = this.getAttribute("data-name") || "Company";
                    const initials = this.getAttribute("data-initials") || "CO";
                    const status = this.getAttribute("data-status") || "Pending";
                    const industry = this.getAttribute("data-industry") || "";
                    const location = this.getAttribute("data-location") || "";
                    const website = this.getAttribute("data-website") || "";
                    const email = this.getAttribute("data-email") || "";
                    const phone = this.getAttribute("data-phone") || "";
                    const size = this.getAttribute("data-size") || "";
                    const founded = this.getAttribute("data-founded") || "";
                    const jobs = this.getAttribute("data-jobs") || "0";
                    const apps = this.getAttribute("data-apps") || "0";
                    const hires = this.getAttribute("data-hires") || "0";

                    // Update sidebar fields
                    const cdInitials = document.getElementById("cdInitials");
                    const cdName = document.getElementById("cdName");
                    const cdStatus = document.getElementById("cdStatus");
                    const cdIndustry = document.getElementById("cdIndustry");
                    const cdLocation = document.getElementById("cdLocation");
                    const cdWebsite = document.getElementById("cdWebsite");
                    const cdEmail = document.getElementById("cdEmail");
                    const cdPhone = document.getElementById("cdPhone");
                    const cdSize = document.getElementById("cdSize");
                    const cdFounded = document.getElementById("cdFounded");
                    const cdJobsCount = document.getElementById("cdJobsCount");
                    const cdAppCount = document.getElementById("cdAppCount");
                    const cdHiresCount = document.getElementById("cdHiresCount");

                    if (cdInitials) cdInitials.textContent = initials;
                    if (cdName) cdName.textContent = name;
                    if (cdStatus) {
                        cdStatus.textContent = status;
                        let statusCls = "badge-status-pending";
                        if (status.toLowerCase().includes("verified")) statusCls = "badge-status-verified";
                        else if (status.toLowerCase().includes("suspend")) statusCls = "badge-status-suspended";
                        cdStatus.className = "company-badge-status " + statusCls;
                    }
                    if (cdIndustry) cdIndustry.textContent = industry;
                    if (cdLocation) cdLocation.textContent = location;
                    if (cdWebsite) {
                        cdWebsite.textContent = website;
                        cdWebsite.href = website.startsWith("http") ? website : "https://" + website;
                    }
                    if (cdEmail) {
                        cdEmail.textContent = email;
                        cdEmail.href = "mailto:" + email;
                    }
                    if (cdPhone) cdPhone.textContent = phone;
                    if (cdSize) cdSize.textContent = size;
                    if (cdFounded) cdFounded.textContent = founded;
                    if (cdJobsCount) cdJobsCount.textContent = jobs;
                    if (cdAppCount) cdAppCount.textContent = apps;
                    if (cdHiresCount) cdHiresCount.textContent = hires;

                    companySidebar.style.display = "block";
                });
            });

            if (btnCloseCompanyDetails) {
                btnCloseCompanyDetails.addEventListener("click", function (e) {
                    e.stopPropagation();
                    companySidebar.style.display = "none";
                    companyRows.forEach(r => r.classList.remove("active-row"));
                });
            }
        }
    } catch (err) {
        console.warn("SkillLinkX: Companies row selection error", err);
    }

    /* ----------------------------------------------------------------------
       7. Applications Management - Row Selection & Details Sidebar Update
       ---------------------------------------------------------------------- */
    try {
        const appRows = document.querySelectorAll(".app-row");
        const appSidebar = document.getElementById("appDetailsCard") || document.getElementById("appDetailsSidebar");
        const btnCloseAppDetails = document.getElementById("btnCloseAppDetails");

        if (appRows.length > 0 && appSidebar) {
            appRows.forEach(row => {
                row.addEventListener("click", function (e) {
                    if (e.target.tagName === "BUTTON" || e.target.closest("button") || e.target.closest(".action-dropdown-wrap")) return;

                    appRows.forEach(r => r.classList.remove("active-row"));
                    this.classList.add("active-row");

                    const name = this.getAttribute("data-name") || this.getAttribute("data-student-name") || "Applicant";
                    const avatar = this.getAttribute("data-avatar") || "../assets/Images/profile.png";
                    const role = this.getAttribute("data-role") || this.getAttribute("data-applied-for") || "Applicant";
                    const company = this.getAttribute("data-company") || "";
                    const match = this.getAttribute("data-match") || "90%";
                    const skillsMatch = this.getAttribute("data-skillsmatch") || this.getAttribute("data-skills-match") || match;
                    const expMatch = this.getAttribute("data-expmatch") || this.getAttribute("data-exp-match") || match;
                    const degree = this.getAttribute("data-degree") || this.getAttribute("data-education") || "";
                    const college = this.getAttribute("data-college") || "";
                    const status = this.getAttribute("data-status") || "Under Review";
                    const skills = (this.getAttribute("data-skills") || "").split(",").map(s => s.trim()).filter(Boolean);

                    const adAvatar = document.getElementById("adAvatar");
                    const adName = document.getElementById("adName");
                    const adAppliedFor = document.getElementById("adAppliedFor");
                    const adMatchPct = document.getElementById("adMatchPct");
                    const adSkillsMatchPct = document.getElementById("adSkillsMatchPct");
                    const adSkillsBar = document.getElementById("adSkillsBar");
                    const adExpMatchPct = document.getElementById("adExpMatchPct");
                    const adExpBar = document.getElementById("adExpBar");
                    const adDegree = document.getElementById("adDegree");
                    const adCollege = document.getElementById("adCollege");
                    const adSkills = document.getElementById("adSkills");
                    const adTimelineStatus = document.getElementById("adTimelineStatus");
                    const adStatusSelect = document.getElementById("adStatusSelect") || document.getElementById("ddlUpdateAppStatus");

                    if (adAvatar) adAvatar.src = avatar;
                    if (adName) adName.textContent = name;
                    if (adAppliedFor) adAppliedFor.textContent = role.includes(" at ") ? "Applying for " + role : "Applying for " + role + " at " + company;
                    if (adMatchPct) adMatchPct.textContent = match;
                    if (adSkillsMatchPct) adSkillsMatchPct.textContent = skillsMatch;
                    if (adSkillsBar) adSkillsBar.style.width = skillsMatch;
                    if (adExpMatchPct) adExpMatchPct.textContent = expMatch;
                    if (adExpBar) adExpBar.style.width = expMatch;
                    if (adDegree) adDegree.textContent = degree;
                    if (adCollege) adCollege.textContent = college;
                    if (adTimelineStatus) adTimelineStatus.textContent = status;
                    if (adStatusSelect) adStatusSelect.value = status;

                    if (adSkills) {
                        adSkills.innerHTML = "";
                        skills.forEach(skill => {
                            const badge = document.createElement("span");
                            badge.className = "sd-skill-pill";
                            badge.textContent = skill;
                            adSkills.appendChild(badge);
                        });
                    }

                    appSidebar.style.display = "block";
                });
            });

            if (btnCloseAppDetails) {
                btnCloseAppDetails.addEventListener("click", function (e) {
                    e.stopPropagation();
                    appSidebar.style.display = "none";
                    appRows.forEach(r => r.classList.remove("active-row"));
                });
            }
        }
    } catch (err) {
        console.warn("SkillLinkX: Applications row selection error", err);
    }

    /* ----------------------------------------------------------------------
       8. Admin Filter Bars & Table Search Filtering
       ---------------------------------------------------------------------- */
    try {
        function setupTableSearch(inputId, tableRowsSelector) {
            const searchInput = document.getElementById(inputId);
            if (!searchInput) return;

            searchInput.addEventListener("input", function () {
                const term = this.value.trim().toLowerCase();
                const rows = document.querySelectorAll(tableRowsSelector);
                rows.forEach(row => {
                    const text = row.innerText.toLowerCase();
                    row.style.display = text.includes(term) ? "" : "none";
                });
            });
        }

        setupTableSearch("txtStudentSearch", ".student-row");
        setupTableSearch("txtCompanySearch", ".company-row");
        setupTableSearch("txtAppSearch", ".app-row");
        setupTableSearch("txtJobSearch", ".job-row");

        // Clear filter buttons
        const btnClearStudentFilters = document.getElementById("btnClearStudentFilters");
        if (btnClearStudentFilters) {
            btnClearStudentFilters.addEventListener("click", function () {
                const search = document.getElementById("txtStudentSearch");
                if (search) search.value = "";
                document.querySelectorAll(".student-row").forEach(r => r.style.display = "");
            });
        }

        const btnClearCompanyFilters = document.getElementById("btnClearCompanyFilters");
        if (btnClearCompanyFilters) {
            btnClearCompanyFilters.addEventListener("click", function () {
                const search = document.getElementById("txtCompanySearch");
                if (search) search.value = "";
                document.querySelectorAll(".company-row").forEach(r => r.style.display = "");
            });
        }

        const btnClearAppFilters = document.getElementById("btnClearAppFilters");
        if (btnClearAppFilters) {
            btnClearAppFilters.addEventListener("click", function () {
                const search = document.getElementById("txtAppSearch");
                if (search) search.value = "";
                document.querySelectorAll(".app-row").forEach(r => r.style.display = "");
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Table filter search error", err);
    }

    /* ----------------------------------------------------------------------
       9. Reports & Analytics Charts (adminGrowthAnalyticsChart & adminDeptHiringChart)
       ---------------------------------------------------------------------- */
    function renderAnalyticsCharts() {
        const growthContainer = document.querySelector("#adminGrowthAnalyticsChart");
        const deptContainer = document.querySelector("#adminDeptHiringChart");

        if (!growthContainer && !deptContainer) return;

        if (typeof ApexCharts === "undefined") {
            setTimeout(renderAnalyticsCharts, 150);
            return;
        }

        // 1. Platform Growth Trends Chart (Line / Area)
        if (growthContainer) {
            growthContainer.innerHTML = "";
            const growthOptions = {
                series: [
                    {
                        name: 'Student Registrations',
                        data: [1540, 2100, 2800, 3600, 4200, 5100, 6400, 7200, 8900, 10500, 12800, 14200]
                    },
                    {
                        name: 'Applications Submitted',
                        data: [980, 1400, 2100, 2900, 3800, 4700, 5800, 6900, 8100, 9600, 11400, 12450]
                    },
                    {
                        name: 'Successful Placements',
                        data: [120, 180, 250, 310, 420, 580, 710, 890, 1050, 1280, 1450, 1680]
                    }
                ],
                chart: {
                    type: 'area',
                    height: 310,
                    toolbar: { show: false },
                    fontFamily: 'Inter, sans-serif'
                },
                colors: ['#2563eb', '#10b981', '#f59e0b'],
                dataLabels: { enabled: false },
                stroke: {
                    curve: 'smooth',
                    width: [2.5, 2.5, 2.5]
                },
                fill: {
                    type: 'gradient',
                    gradient: {
                        shadeIntensity: 1,
                        opacityFrom: 0.35,
                        opacityTo: 0.05,
                        stops: [0, 90, 100]
                    }
                },
                xaxis: {
                    categories: ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
                    axisBorder: { show: false },
                    axisTicks: { show: false },
                    labels: {
                        style: { colors: '#64748b', fontSize: '12px' }
                    }
                },
                yaxis: {
                    labels: {
                        style: { colors: '#64748b', fontSize: '12px' },
                        formatter: function (v) { return v >= 1000 ? (v / 1000).toFixed(1) + 'k' : v; }
                    }
                },
                grid: {
                    borderColor: '#f1f5f9',
                    strokeDashArray: 4
                },
                legend: {
                    position: 'top',
                    horizontalAlign: 'right',
                    fontSize: '12px',
                    labels: { colors: '#475569' }
                },
                tooltip: {
                    theme: 'light',
                    y: {
                        formatter: function (val) { return val.toLocaleString(); }
                    }
                }
            };
            new ApexCharts(growthContainer, growthOptions).render();
        }

        // 2. Department Hiring Distribution Chart (Horizontal Bar)
        if (deptContainer) {
            deptContainer.innerHTML = "";
            const deptOptions = {
                series: [{
                    name: 'Hires',
                    data: [540, 420, 310, 240, 170]
                }],
                chart: {
                    type: 'bar',
                    height: 310,
                    toolbar: { show: false },
                    fontFamily: 'Inter, sans-serif'
                },
                plotOptions: {
                    bar: {
                        horizontal: true,
                        borderRadius: 6,
                        barHeight: '55%'
                    }
                },
                colors: ['#2563eb'],
                dataLabels: {
                    enabled: true,
                    style: { fontSize: '11px', fontWeight: 600, colors: ['#fff'] }
                },
                xaxis: {
                    categories: ['Computer Science', 'IT & Software', 'Electronics', 'Mechanical', 'Finance & Analytics'],
                    labels: {
                        style: { colors: '#64748b', fontSize: '12px' }
                    }
                },
                yaxis: {
                    labels: {
                        style: { colors: '#334155', fontSize: '12px', fontWeight: 500 }
                    }
                },
                grid: {
                    borderColor: '#f1f5f9',
                    strokeDashArray: 4
                },
                tooltip: {
                    theme: 'light',
                    y: {
                        formatter: function (val) { return val + " candidates hired"; }
                    }
                }
            };
            new ApexCharts(deptContainer, deptOptions).render();
        }
    }

    try {
        renderAnalyticsCharts();
    } catch (err) {
        console.warn("SkillLinkX: renderAnalyticsCharts error", err);
    }

    /* ----------------------------------------------------------------------
       14. Add Student & Add Company Modals
       ---------------------------------------------------------------------- */
    try {
        // Add Student Modal
        const btnOpenAddStudent = document.getElementById("btnOpenAddStudentModal");
        const modalAddStudent = document.getElementById("addStudentModal");
        const btnSubmitAddStudent = document.getElementById("btnSubmitAddStudent");

        if (btnOpenAddStudent && modalAddStudent) {
            btnOpenAddStudent.addEventListener("click", function (e) {
                e.preventDefault();
                modalAddStudent.style.display = "flex";
            });
        }

        if (btnSubmitAddStudent && modalAddStudent) {
            btnSubmitAddStudent.addEventListener("click", function () {
                const nameInput = document.getElementById("newStudentName");
                const emailInput = document.getElementById("newStudentEmail");
                if (nameInput && !nameInput.value.trim()) {
                    alert("Please enter the student's full name.");
                    nameInput.focus();
                    return;
                }
                if (emailInput && !emailInput.value.trim()) {
                    alert("Please enter the student's email address.");
                    emailInput.focus();
                    return;
                }

                alert("Student " + (nameInput ? nameInput.value : "") + " successfully added to SkillLinkX!");
                modalAddStudent.style.display = "none";
                if (nameInput) nameInput.value = "";
                if (emailInput) emailInput.value = "";
            });
        }

        // Add Company Modal
        const btnOpenAddCompany = document.getElementById("btnOpenAddCompanyModal");
        const modalAddCompany = document.getElementById("addCompanyModal");
        const btnSubmitAddCompany = document.getElementById("btnSubmitAddCompany");

        if (btnOpenAddCompany && modalAddCompany) {
            btnOpenAddCompany.addEventListener("click", function (e) {
                e.preventDefault();
                modalAddCompany.style.display = "flex";
            });
        }

        if (btnSubmitAddCompany && modalAddCompany) {
            btnSubmitAddCompany.addEventListener("click", function () {
                const companyNameInput = document.getElementById("newCompanyName");
                const companyEmailInput = document.getElementById("newCompanyEmail");
                if (companyNameInput && !companyNameInput.value.trim()) {
                    alert("Please enter the company name.");
                    companyNameInput.focus();
                    return;
                }
                if (companyEmailInput && !companyEmailInput.value.trim()) {
                    alert("Please enter the company contact email.");
                    companyEmailInput.focus();
                    return;
                }

                alert("Company " + (companyNameInput ? companyNameInput.value : "") + " successfully registered!");
                modalAddCompany.style.display = "none";
                if (companyNameInput) companyNameInput.value = "";
                if (companyEmailInput) companyEmailInput.value = "";
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Admin modals error", err);
    }

    /* ----------------------------------------------------------------------
       15. Analytics Date Range Selector Dropdown
       ---------------------------------------------------------------------- */
    try {
        const analyticsTimePeriod = document.getElementById("analyticsTimePeriod");
        if (analyticsTimePeriod) {
            analyticsTimePeriod.addEventListener("change", function () {
                const selectedText = this.options[this.selectedIndex].text;
                // Toast or simulated live update
                const statVal = document.querySelector(".admin-reports-top-metrics .stat-num-val");
                if (statVal) {
                    if (this.value === "7") {
                        statVal.textContent = "6,140";
                    } else if (this.value === "30") {
                        statVal.textContent = "25,480";
                    } else if (this.value === "90") {
                        statVal.textContent = "78,920";
                    } else {
                        statVal.textContent = "142,650";
                    }
                }
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Analytics time period change error", err);
    }

    /* ----------------------------------------------------------------------
       16. Table Pagination Controls (Client-Side Page Navigation)
       ---------------------------------------------------------------------- */
    try {
        const paginationList = document.querySelector(".pagination-pages-list");
        const entryCountSpan = document.getElementById("studentPaginationCount");

        if (paginationList) {
            const pageLinks = paginationList.querySelectorAll("a.btn-pg-num");
            const prevArrow = paginationList.querySelector("a.btn-pg-arrow:first-child");
            const nextArrow = paginationList.querySelector("a.btn-pg-arrow:last-child");

            function updatePaginationDisplay(activePage) {
                pageLinks.forEach(link => {
                    const pageVal = parseInt(link.textContent.trim(), 10);
                    if (pageVal === activePage) {
                        link.classList.add("active");
                    } else {
                        link.classList.remove("active");
                    }
                });

                if (entryCountSpan) {
                    if (activePage === 1) {
                        entryCountSpan.textContent = "Showing 1 to 4 of 45,231 entries";
                    } else if (activePage === 2) {
                        entryCountSpan.textContent = "Showing 5 to 8 of 45,231 entries";
                    } else if (activePage === 3) {
                        entryCountSpan.textContent = "Showing 9 to 12 of 45,231 entries";
                    } else {
                        entryCountSpan.textContent = "Showing 45,228 to 45,231 of 45,231 entries";
                    }
                }
            }

            let currentPage = 1;

            pageLinks.forEach(link => {
                link.addEventListener("click", function (e) {
                    e.preventDefault();
                    const pageNum = parseInt(this.textContent.trim(), 10);
                    if (!isNaN(pageNum)) {
                        currentPage = pageNum;
                        updatePaginationDisplay(currentPage);
                    }
                });
            });

            if (prevArrow) {
                prevArrow.addEventListener("click", function (e) {
                    e.preventDefault();
                    if (currentPage > 1) {
                        currentPage--;
                        updatePaginationDisplay(currentPage);
                    }
                });
            }

            if (nextArrow) {
                nextArrow.addEventListener("click", function (e) {
                    e.preventDefault();
                    if (currentPage < 452) {
                        currentPage++;
                        updatePaginationDisplay(currentPage);
                    }
                });
            }
        }
    } catch (err) {
        console.warn("SkillLinkX: Pagination controls error", err);
    }
});


