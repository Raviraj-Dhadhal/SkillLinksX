// Wait until the entire HTML page has loaded before running any script
document.addEventListener("DOMContentLoaded", function () {

    // 1. Get references to HTML elements by their IDs
    const sidebarToggle = document.getElementById("sidebarToggle");       // Hamburger button on mobile
    const userSidebar = document.getElementById("userSidebar");           // Left sidebar element
    const sidebarBackdrop = document.getElementById("sidebarBackdrop");   // Dark dim background overlay

    // Function to open the sidebar on mobile devices
    function openSidebar() {
        if (userSidebar && sidebarBackdrop) {
            userSidebar.classList.add("open");             // Slide in the sidebar (60% width)
            sidebarBackdrop.classList.add("show");         // Display the dark dim background overlay
            document.body.style.overflow = "hidden";       // Prevent background page from scrolling
        }
    }

    // Function to close the sidebar on mobile devices
    function closeSidebar() {
        if (userSidebar && sidebarBackdrop) {
            userSidebar.classList.remove("open");          // Slide sidebar back off-screen
            sidebarBackdrop.classList.remove("show");      // Hide the dim background overlay
            document.body.style.overflow = "";             // Restore normal page scrolling
        }
    }

    // 2. Click event for the hamburger button
    if (sidebarToggle) {
        sidebarToggle.addEventListener("click", function (e) {
            e.stopPropagation(); // Stop click from propagating to other elements
            if (userSidebar.classList.contains("open")) {
                closeSidebar();
            } else {
                openSidebar();
            }
        });
    }

    // 3. Click event for the dim background overlay (clicking outside closes the sidebar)
    if (sidebarBackdrop) {
        sidebarBackdrop.addEventListener("click", closeSidebar);
    }

    // 4. Automatically highlight the active sidebar link based on current page URL
    const currentPath = window.location.pathname.toLowerCase();
    const currentFile = currentPath.split('/').pop();
    const sidebarLinks = document.querySelectorAll(".sidebar-link, .sidebar-footer-link");

    sidebarLinks.forEach(function (link) {
        link.classList.remove("active");
        if (link.classList.contains("logout")) return;

        const href = link.getAttribute("href");
        if (href) {
            try {
                const linkUrl = new URL(link.href, window.location.origin);
                const linkPath = linkUrl.pathname.toLowerCase();
                const linkFile = linkPath.split('/').pop();
                if (currentPath === linkPath || (linkFile && currentFile === linkFile)) {
                    link.classList.add("active");
                }
            } catch (e) {
                // Ignore URL parsing errors
            }
        }
    });

    /* ----------------------------------------------------------------------
       5. Contribution Activity Heatmap Matrix (Portfolio Page)
       Renders the GitHub-style commit activity boxes dynamically
       ---------------------------------------------------------------------- */
    try {
        const contribContainer = document.getElementById("contribHeatmap");
        if (contribContainer) {
            // Pattern of commit intensity levels: 0 (empty) to 4 (high activity)
            const pattern = [
                0,1,0,2,3,4,1,0,2,3,0,1,2,0,4,3,2,1,0,2,3,4,1,0,1,2,3,0,1,2,0,1,
                1,2,3,4,2,0,1,2,3,4,1,2,0,3,4,2,1,0,3,4,1,2,0,3,4,1,2,3,0,2,3,2,
                0,3,2,1,0,2,3,4,1,2,0,3,4,1,2,3,0,1,2,3,4,2,0,1,2,3,4,1,0,1,2,3,
                2,4,1,0,3,4,1,2,0,3,4,1,2,3,0,2,3,4,1,0,2,3,4,1,2,0,3,4,1,2,0,4,
                3,1,0,2,3,4,1,0,2,3,0,1,2,0,4,3,2,1,0,2,3,4,1,0,1,2,3,0,1,2,3,1,
                1,0,2,3,4,1,2,0,3,4,1,2,3,0,2,3,4,1,0,2,3,4,1,2,0,3,4,1,2,0,4,2,
                0,2,1,0,3,4,1,2,0,3,4,1,2,3,0,2,3,4,1,0,2,3,4,1,2,0,3,4,1,2,0,1
            ];

            let html = "";
            for (let i = 0; i < pattern.length; i++) {
                const level = pattern[i];
                html += '<span class="contrib-cell c-' + level + '" title="Activity Level ' + level + '"></span>';
            }
            contribContainer.innerHTML = html;
        }
    } catch (err) {
        console.warn("SkillLinkX: Contribution heatmap warning", err);
    }
    try {
        const btnScrollToProjects = document.getElementById("btnScrollToProjects");
        if (btnScrollToProjects) {
            btnScrollToProjects.addEventListener("click", function () {
                const target = document.getElementById("sectionFeaturedProjects");
                if (target) {
                    target.scrollIntoView({ behavior: "smooth", block: "start" });
                }
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Scroll to projects warning", err);
    }
    try {
        const catPills = document.querySelectorAll(".opps-cat-pill");
        catPills.forEach(function (pill) {
            pill.addEventListener("click", function () {
                catPills.forEach(p => p.classList.remove("active"));
                pill.classList.add("active");
            });
        });

        const filterPills = document.querySelectorAll(".filter-pill-btn");
        filterPills.forEach(function (pill) {
            pill.addEventListener("click", function () {
                filterPills.forEach(p => p.classList.remove("active"));
                pill.classList.add("active");
            });
        });

        const bookmarkBtns = document.querySelectorAll(".btn-opp-bookmark, .btn-similar-bookmark");
        bookmarkBtns.forEach(function (btn) {
            btn.addEventListener("click", function () {
                const icon = btn.querySelector("i");
                if (icon) {
                    if (icon.classList.contains("fa-regular")) {
                        icon.classList.remove("fa-regular");
                        icon.classList.add("fa-solid");
                        btn.style.color = "#0040A2";
                    } else {
                        icon.classList.remove("fa-solid");
                        icon.classList.add("fa-regular");
                        btn.style.color = "";
                    }
                }
            });
        });
    } catch (err) {
        console.warn("SkillLinkX: Opps filter warning", err);
    }
});

/**
 * 6. Notifications - Mark All as Read
 */
function markAllAsRead() {
    try {
        const unreadItems = document.querySelectorAll(".notif-item.unread");
        unreadItems.forEach(item => item.classList.remove("unread"));

        const unreadDots = document.querySelectorAll(".notif-unread-dot");
        unreadDots.forEach(dot => dot.style.display = "none");

        const unreadVal = document.querySelector(".notif-metric-tile:first-child .notif-metric-val");
        if (unreadVal) {
            unreadVal.textContent = "0";
        }

        const badge = document.querySelector(".notif-badge");
        if (badge) {
            badge.style.display = "none";
        }
    } catch (e) {
        console.warn("SkillLinkX: markAllAsRead error", e);
    }
}

/**
 * 7. AI Career Assistant & Messages Quick Handlers
 */
document.addEventListener("DOMContentLoaded", function () {
    try {
        const btnAiSend = document.getElementById("btnAiSend");
        const aiChatInput = document.getElementById("aiChatInput");
        const aiChatMessages = document.getElementById("aiChatMessages");

        function sendAiMessage() {
            if (!aiChatInput || !aiChatMessages) return;
            const text = aiChatInput.value.trim();
            if (!text) return;

            const timeNow = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            
            // Append User Bubble
            const userMsg = document.createElement("div");
            userMsg.className = "ai-msg-group user";
            userMsg.innerHTML = `
                <div class="ai-msg-body">
                    <div class="ai-msg-sender-meta text-right">You &bull; ${timeNow}</div>
                    <div class="ai-msg-bubble user-bubble">${text}</div>
                </div>
                <div class="ai-msg-avatar user-avatar">
                    <img src="../assets/images/user-male-logo.png" alt="Raviraj Dhadhal" />
                </div>
            `;
            aiChatMessages.appendChild(userMsg);
            aiChatInput.value = "";
            aiChatMessages.scrollTop = aiChatMessages.scrollHeight;

            // Simulated AI Assistant Reply
            setTimeout(function () {
                const aiReply = document.createElement("div");
                aiReply.className = "ai-msg-group assistant";
                aiReply.innerHTML = `
                    <div class="ai-msg-avatar"><i class="fa-solid fa-robot"></i></div>
                    <div class="ai-msg-body">
                        <div class="ai-msg-sender-meta">AI Assistant &bull; ${timeNow}</div>
                        <div class="ai-msg-bubble assistant-bubble">
                            I've received your query about "<strong>${text}</strong>". Analyzing your profile and job market trends... Check the Actionable Insights on the right for tailored recommendations!
                        </div>
                    </div>
                `;
                aiChatMessages.appendChild(aiReply);
                aiChatMessages.scrollTop = aiChatMessages.scrollHeight;
            }, 600);
        }

        if (btnAiSend) {
            btnAiSend.addEventListener("click", sendAiMessage);
        }
        if (aiChatInput) {
            aiChatInput.addEventListener("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    sendAiMessage();
                }
            });
        }
    } catch (e) {
        console.warn("SkillLinkX: AI chat script error", e);
    }

    /* ----------------------------------------------------------------------
       8. Saved Opportunities Tab Filtering (All / Jobs / Internships)
       ---------------------------------------------------------------------- */
    try {
        const savedTabs = document.querySelectorAll(".saved-tab-btn");
        const savedCards = document.querySelectorAll(".saved-opp-card");

        savedTabs.forEach(function (tab) {
            tab.addEventListener("click", function () {
                savedTabs.forEach(t => t.classList.remove("active"));
                tab.classList.add("active");

                const filterText = tab.textContent.trim().toLowerCase();

                savedCards.forEach(function (card) {
                    const category = (card.getAttribute("data-category") || "").toLowerCase();
                    if (filterText === "all") {
                        card.style.display = "";
                    } else if (filterText.includes("job") && category === "job") {
                        card.style.display = "";
                    } else if (filterText.includes("intern") && category === "internship") {
                        card.style.display = "";
                    } else {
                        card.style.display = "none";
                    }
                });
            });
        });
    } catch (err) {
        console.warn("SkillLinkX: Saved opportunities filter error", err);
    }

    /* ----------------------------------------------------------------------
       9. Networking Tabs Switcher (Discover People / My Connections / Pending Requests)
       ---------------------------------------------------------------------- */
    try {
        const netTabs = document.querySelectorAll(".net-tab-item");
        const panelDiscover = document.getElementById("panelDiscoverPeople");
        const panelConnections = document.getElementById("panelMyConnections");
        const panelPending = document.getElementById("panelPendingRequests");

        netTabs.forEach(function (tab) {
            tab.addEventListener("click", function () {
                netTabs.forEach(t => t.classList.remove("active"));
                tab.classList.add("active");

                const tabName = tab.textContent.trim().toLowerCase();

                if (panelDiscover) panelDiscover.style.display = "none";
                if (panelConnections) panelConnections.style.display = "none";
                if (panelPending) panelPending.style.display = "none";

                if (tabName.includes("discover")) {
                    if (panelDiscover) panelDiscover.style.display = "";
                } else if (tabName.includes("connections")) {
                    if (panelConnections) panelConnections.style.display = "";
                } else if (tabName.includes("pending")) {
                    if (panelPending) panelPending.style.display = "";
                }
            });
        });
    } catch (err) {
        console.warn("SkillLinkX: Networking tabs error", err);
    }

    /* ----------------------------------------------------------------------
       10. Applications Filter Pills (All / Jobs / Internships / Statuses)
       ---------------------------------------------------------------------- */
    try {
        const appTabs = document.querySelectorAll(".apps-filter-tabs-wrapper .app-tab-pill");
        const appCards = document.querySelectorAll(".apps-list-container .app-row-card");

        appTabs.forEach(function (tab) {
            tab.addEventListener("click", function (e) {
                e.preventDefault();
                appTabs.forEach(t => t.classList.remove("active"));
                tab.classList.add("active");

                const filterText = tab.textContent.trim().toLowerCase();

                appCards.forEach(function (card) {
                    const typePill = card.querySelector(".app-type-pill");
                    const statusBadge = card.querySelector(".app-status-badge");
                    const typeText = (typePill ? typePill.textContent : "").toLowerCase();
                    const statusText = (statusBadge ? statusBadge.textContent : "").toLowerCase();

                    let shouldShow = false;

                    if (filterText === "all") {
                        shouldShow = true;
                    } else if (filterText.includes("job") && typeText.includes("job")) {
                        shouldShow = true;
                    } else if (filterText.includes("intern") && typeText.includes("intern")) {
                        shouldShow = true;
                    } else if (filterText.includes("review") && statusText.includes("review")) {
                        shouldShow = true;
                    } else if (filterText.includes("shortlisted") && statusText.includes("shortlisted")) {
                        shouldShow = true;
                    } else if (filterText.includes("interview") && statusText.includes("interview")) {
                        shouldShow = true;
                    } else if (filterText.includes("selected") && statusText.includes("selected")) {
                        shouldShow = true;
                    } else if (filterText.includes("rejected") && statusText.includes("rejected")) {
                        shouldShow = true;
                    }

                    if (shouldShow) {
                        card.classList.remove("card-hidden");
                        card.style.setProperty("display", "", "");
                    } else {
                        card.classList.add("card-hidden");
                        card.style.setProperty("display", "none", "important");
                    }
                });
            });
        });
    } catch (err) {
        console.warn("SkillLinkX: Applications filter error", err);
    }

    /* ----------------------------------------------------------------------
       11. Bookmark / Save Toggle with Watchlist Toast Notification
       ---------------------------------------------------------------------- */
    try {
        // Universal toast function
        function showWatchlistToast(message) {
            let toast = document.getElementById("skilllinkxToast");
            if (!toast) {
                toast = document.createElement("div");
                toast.id = "skilllinkxToast";
                toast.style.position = "fixed";
                toast.style.bottom = "24px";
                toast.style.right = "24px";
                toast.style.backgroundColor = "#0F172A";
                toast.style.color = "#FFFFFF";
                toast.style.padding = "12px 20px";
                toast.style.borderRadius = "8px";
                toast.style.fontSize = "13.5px";
                toast.style.fontWeight = "600";
                toast.style.boxShadow = "0 10px 25px -5px rgba(0,0,0,0.25)";
                toast.style.display = "flex";
                toast.style.alignItems = "center";
                toast.style.gap = "10px";
                toast.style.zIndex = "999999";
                toast.style.transition = "opacity 0.25s ease, transform 0.25s ease";
                toast.style.opacity = "0";
                toast.style.transform = "translateY(12px)";
                document.body.appendChild(toast);
            }

            toast.innerHTML = `<i class="fa-solid fa-circle-check" style="color:#10B981; font-size:16px;"></i> <span>${message}</span>`;
            toast.style.opacity = "1";
            toast.style.transform = "translateY(0)";

            if (window._toastTimeout) clearTimeout(window._toastTimeout);
            window._toastTimeout = setTimeout(function () {
                toast.style.opacity = "0";
                toast.style.transform = "translateY(12px)";
            }, 3000);
        }

        // Bookmark buttons across JobDetails, InternshipDetails, Dashboard Top Matches, and Cards
        const saveBtns = document.querySelectorAll(".btn-job-action-box[title*='Save'], .btn-opp-action-pill, .btn-save-bookmark, .card-bookmark-btn, .btn-match-bookmark");
        saveBtns.forEach(btn => {
            const icon = btn.querySelector("i.fa-bookmark");
            if (icon) {
                btn.addEventListener("click", function (e) {
                    e.preventDefault();
                    e.stopPropagation();

                    const isSaved = icon.classList.contains("fa-solid");
                    if (isSaved) {
                        icon.classList.remove("fa-solid");
                        icon.classList.add("fa-regular");
                        icon.style.color = "";
                        showWatchlistToast("Opportunity removed from your watchlist");
                    } else {
                        icon.classList.remove("fa-regular");
                        icon.classList.add("fa-solid");
                        icon.style.color = "#2563EB";
                        showWatchlistToast("Opportunity saved to your watchlist");
                    }
                });
            }
        });
    } catch (err) {
        console.warn("SkillLinkX: Bookmark toggle error", err);
    }

    /* ----------------------------------------------------------------------
       12. Pagination Controls (Prevent Default & Active Switch)
       ---------------------------------------------------------------------- */
    try {
        const userPaginationBtns = document.querySelectorAll(".saved-pagination-wrap a, .opp-pagination-wrap a, .pagination-pages-list a");
        userPaginationBtns.forEach(btn => {
            btn.addEventListener("click", function (e) {
                e.preventDefault();
                if (btn.classList.contains("btn-page-num") || btn.classList.contains("btn-pg-num")) {
                    btn.parentElement.querySelectorAll(".btn-page-num, .btn-pg-num").forEach(b => b.classList.remove("active"));
                    btn.classList.add("active");
                }
            });
        });
    } catch (err) {
        console.warn("SkillLinkX: User pagination error", err);
    }

    /* ----------------------------------------------------------------------
       13. Resume Action Logging (Upload, View, Download) & Portfolio Dialog
       ---------------------------------------------------------------------- */
    try {
        // Profile Page: Upload New Resume
        const btnUploadResume = document.querySelector(".btn-upload-new-resume");
        if (btnUploadResume) {
            btnUploadResume.addEventListener("click", function (e) {
                e.preventDefault();
                console.log("you can upload a new resume");
                alert("You can upload a new resume");
            });
        }

        // Profile Page: View Resume icon
        const btnViewResume = document.querySelector(".btn-resume-action[title*='View']");
        if (btnViewResume) {
            btnViewResume.addEventListener("click", function (e) {
                e.preventDefault();
                console.log("you are seeing resume");
                alert("You are seeing resume");
            });
        }

        // Profile Page: Download Resume icon
        const btnDownloadResume = document.querySelector(".btn-resume-action[title*='Download']");
        if (btnDownloadResume) {
            btnDownloadResume.addEventListener("click", function (e) {
                e.preventDefault();
                console.log("resume is downloading");
                alert("Resume is downloading...");
            });
        }

        // Portfolio Page: Download Resume Button
        const btnPortfolioDownload = document.querySelector(".btn-portfolio-download");
        if (btnPortfolioDownload) {
            btnPortfolioDownload.addEventListener("click", function (e) {
                e.preventDefault();
                console.log("resume is downloading");
                alert("Resume is downloading...");
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Resume actions error", err);
    }

    /* ----------------------------------------------------------------------
       14. Internships Page Filter Chips & Category Tabs (Client-Side Filter)
       ---------------------------------------------------------------------- */
    try {
        // Location filter pills (Remote, Bengaluru, Mumbai)
        const internFilterPills = document.querySelectorAll(".opps-filter-card .filter-pill-btn");
        const internCards = document.querySelectorAll(".opp-featured-card, .opp-standard-card");

        internFilterPills.forEach(pill => {
            pill.addEventListener("click", function () {
                this.classList.toggle("active");
                applyInternshipFilters();
            });
        });

        // Top category pills (All Internships, Software Dev, UI/UX Design, Data Science, Marketing)
        const internCatPills = document.querySelectorAll(".opps-cat-tabs .opps-cat-pill");
        internCatPills.forEach(pill => {
            pill.addEventListener("click", function () {
                internCatPills.forEach(p => p.classList.remove("active"));
                this.classList.add("active");
                applyInternshipFilters();
            });
        });

        function applyInternshipFilters() {
            const activeCat = document.querySelector(".opps-cat-tabs .opps-cat-pill.active");
            const catText = activeCat ? activeCat.textContent.trim().toLowerCase() : "all";

            const activeLocPills = Array.from(document.querySelectorAll(".opps-filter-card .filter-pill-btn.active")).map(p => p.textContent.trim().toLowerCase());

            internCards.forEach(card => {
                const titleText = (card.querySelector(".opp-job-title, .opp-card-title")?.textContent || "").toLowerCase();
                const locText = (card.querySelector(".opp-company-location, .opp-meta-list")?.textContent || "").toLowerCase();

                let matchCat = true;
                if (!catText.includes("all")) {
                    if (catText.includes("software") && !titleText.includes("software") && !titleText.includes("developer") && !titleText.includes("frontend")) matchCat = false;
                    else if (catText.includes("design") && !titleText.includes("design") && !titleText.includes("ui/ux")) matchCat = false;
                    else if (catText.includes("data") && !titleText.includes("data") && !titleText.includes("science")) matchCat = false;
                    else if (catText.includes("market") && !titleText.includes("market")) matchCat = false;
                }

                let matchLoc = true;
                if (activeLocPills.length > 0) {
                    matchLoc = activeLocPills.some(loc => locText.includes(loc));
                }

                if (matchCat && matchLoc) {
                    card.style.display = "";
                } else {
                    card.style.display = "none";
                }
            });
        }
    } catch (err) {
        console.warn("SkillLinkX: Internships filter chips error", err);
    }

    /* ----------------------------------------------------------------------
       15. Notifications Page Filter Tabs
       ---------------------------------------------------------------------- */
    try {
        const notifTabs = document.querySelectorAll(".notif-filter-tabs .notif-tab-pill");
        const notifCards = document.querySelectorAll("#notifFeed .notif-card-item");

        notifTabs.forEach(tab => {
            tab.addEventListener("click", function () {
                notifTabs.forEach(t => t.classList.remove("active"));
                this.classList.add("active");

                const filterName = this.textContent.trim().toLowerCase();

                notifCards.forEach(card => {
                    const text = (card.querySelector(".notif-body-line")?.textContent || "").toLowerCase();

                    if (filterName === "all") {
                        card.style.display = "";
                    } else if (filterName.includes("application") && (text.includes("application") || text.includes("shortlisted"))) {
                        card.style.display = "";
                    } else if (filterName.includes("job") && (text.includes("internship") || text.includes("job") || text.includes("matches"))) {
                        card.style.display = "";
                    } else if (filterName.includes("network") && (text.includes("connection") || text.includes("request"))) {
                        card.style.display = "";
                    } else if (filterName.includes("interview") && text.includes("interview")) {
                        card.style.display = "";
                    } else if (filterName.includes("system") && text.includes("system")) {
                        card.style.display = "";
                    } else {
                        card.style.display = "none";
                    }
                });
            });
        });
    } catch (err) {
        console.warn("SkillLinkX: Notifications filter error", err);
    }
});

/**
 * 10. Reset Filters Function (Jobs & Internships Pages)
 */
function resetFilters() {
    try {
        // Uncheck all filter checkboxes
        const checkboxes = document.querySelectorAll(".opps-filter-card input[type='checkbox']");
        checkboxes.forEach(function (cb) {
            cb.checked = false;
        });

        // Reset radio buttons (e.g. stipend filter to Any)
        const radios = document.querySelectorAll(".opps-filter-card input[type='radio']");
        radios.forEach(function (rb, index) {
            rb.checked = (index === 0);
        });

        // Clear search inputs
        const searchInputs = document.querySelectorAll(".opps-filter-card input[type='text'], .filter-search-input");
        searchInputs.forEach(function (input) {
            input.value = "";
        });

        // Reset active filter pills in filter card
        const filterPills = document.querySelectorAll(".opps-filter-card .filter-pill-btn");
        filterPills.forEach(function (pill) {
            pill.classList.remove("active");
        });

        // Reset category tabs in main header if any
        const catPills = document.querySelectorAll(".opps-cat-pill");
        catPills.forEach(function (pill, index) {
            if (index === 0) pill.classList.add("active");
            else pill.classList.remove("active");
        });
    } catch (err) {
        console.warn("SkillLinkX: resetFilters error", err);
    }
}
