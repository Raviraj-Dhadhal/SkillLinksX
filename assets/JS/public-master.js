// 1. Get references to header elements for mobile navigation
const hamburger = document.getElementById("hamburger");     // Mobile hamburger menu button
const navMenu = document.querySelector(".nav-menu");        // Navigation links container
const authNav = document.querySelector(".auth-nav");        // Login / Register buttons container

// 2. Toggle navigation menu open/close on hamburger button click
if (hamburger) {
    hamburger.addEventListener("click", function () {
        navMenu.classList.toggle("show"); // Show or hide nav links dropdown on mobile
        authNav.classList.toggle("show"); // Show or hide login/register buttons on mobile
    });
}

// 3. Highlight current active navigation link
document.addEventListener("DOMContentLoaded", function () {
    const currentPath = window.location.pathname.toLowerCase();
    const navLinks = document.querySelectorAll(".nav-menu .nav-links");

    navLinks.forEach(link => {
        const href = link.getAttribute("href");
        if (!href || href === "#") return;

        try {
            const linkPath = new URL(link.href, window.location.origin).pathname.toLowerCase();
            if (
                currentPath === linkPath ||
                (linkPath.includes("home.aspx") && (currentPath === "/" || currentPath.endsWith("/home.aspx") || currentPath.endsWith("/public/home"))) ||
                (linkPath.includes("default.aspx") && (currentPath === "/" || currentPath.endsWith("/default.aspx") || currentPath.endsWith("/public/default")))
            ) {
                link.classList.add("active");
            }
        } catch (e) {
            // fallback
            if (href && currentPath.includes(href.toLowerCase())) {
                link.classList.add("active");
            }
        }
    });
});
