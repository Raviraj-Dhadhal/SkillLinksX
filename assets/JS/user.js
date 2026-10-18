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
    const sidebarLinks = document.querySelectorAll(".sidebar-link, .sidebar-footer-link");

    sidebarLinks.forEach(function (link) {
        // Skip logout link
        if (link.classList.contains("logout")) return;

        const href = link.getAttribute("href");
        if (href) {
            try {
                const linkUrl = new URL(link.href, window.location.origin);
                const linkPath = linkUrl.pathname.toLowerCase();
                if (currentPath === linkPath || currentPath.endsWith(linkPath)) {
                    link.classList.add("active");
                }
            } catch (e) {
                const linkPath = href.toLowerCase();
                if (currentPath.endsWith(linkPath) || currentPath.includes(linkPath)) {
                    link.classList.add("active");
                }
            }
        }
    });
});