/* ==========================================================================
   SkillLinkX - Public JavaScript File (public.js)
   Contains all interactive behaviors for public-facing pages:
   1. Mobile Hamburger Menu Toggle
   2. Active Navigation Link Detection
   3. Password Visibility Toggle (for Login & Register forms)
   4. Accordion Toggle (for Contact Us FAQ section)
   5. Role Switcher Tabs (for Sign Up page)
   ========================================================================== */

document.addEventListener("DOMContentLoaded", function () {

    /* ----------------------------------------------------------------------
       1. Mobile Hamburger Menu Toggle
       ---------------------------------------------------------------------- */
    const hamburgerBtn = document.getElementById("hamburger");
    const navMenu = document.getElementById("navMenu");
    const authNav = document.getElementById("authNav");

    if (hamburgerBtn && navMenu) {
        hamburgerBtn.addEventListener("click", function () {
            hamburgerBtn.classList.toggle("active");
            navMenu.classList.toggle("show");
            if (authNav) {
                authNav.classList.toggle("show");
            }
        });
    }

    /* ----------------------------------------------------------------------
       2. Active Navigation Link Highlighting
       ---------------------------------------------------------------------- */
    const currentPath = window.location.pathname.toLowerCase();
    const navLinks = document.querySelectorAll(".nav-menu .nav-links");

    // Remove any active class by default
    navLinks.forEach(function (link) {
        link.classList.remove("active");
    });

    // Never highlight navigation items if on Login, Register, or ForgotPassword pages
    const isAuthPage = currentPath.includes("login") || currentPath.includes("register") || currentPath.includes("forgotpassword");

    if (!isAuthPage) {
        navLinks.forEach(function (link) {
            const href = link.getAttribute("href");
            if (!href || href === "#") return;

            // Do not highlight links that redirect to login
            if (href.toLowerCase().includes("login.aspx")) return;

            try {
                const linkPath = new URL(link.href, window.location.origin).pathname.toLowerCase();
                if (
                    currentPath === linkPath ||
                    (linkPath.includes("home.aspx") && (currentPath === "/" || currentPath.endsWith("/home.aspx") || currentPath.endsWith("/public/home")))
                ) {
                    link.classList.add("active");
                }
            } catch (e) {
                if (href && currentPath.includes(href.toLowerCase())) {
                    link.classList.add("active");
                }
            }
        });
    }

    /* ----------------------------------------------------------------------
       3. Password Visibility Toggle (Eye Icon)
       ---------------------------------------------------------------------- */
    const togglePasswordButtons = document.querySelectorAll(".password-toggle-btn");
    togglePasswordButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const targetInputId = button.getAttribute("data-target");
            const targetInput = document.getElementById(targetInputId);
            const icon = button.querySelector("i");

            if (targetInput) {
                if (targetInput.type === "password") {
                    targetInput.type = "text";
                    if (icon) {
                        icon.classList.remove("fa-eye");
                        icon.classList.add("fa-eye-slash");
                    }
                } else {
                    targetInput.type = "password";
                    if (icon) {
                        icon.classList.remove("fa-eye-slash");
                        icon.classList.add("fa-eye");
                    }
                }
            }
        });
    });

    /* ----------------------------------------------------------------------
       4. FAQ Accordion Toggle (For Contact Page)
       ---------------------------------------------------------------------- */
    const faqHeaders = document.querySelectorAll(".faq-bar-header, .faq-item-header");
    faqHeaders.forEach(function (header) {
        header.addEventListener("click", function () {
            const faqItem = header.parentElement;
            const isActive = faqItem.classList.contains("active");

            // Close all sibling accordions in the container
            const container = faqItem.parentElement;
            if (container) {
                container.querySelectorAll(".faq-bar-item, .faq-item").forEach(function (item) {
                    item.classList.remove("active");
                });
            }

            // Toggle clicked item
            if (!isActive) {
                faqItem.classList.add("active");
            }
        });
    });

    /* ----------------------------------------------------------------------
       5. Role Switcher Tabs (For Register Page)
       ---------------------------------------------------------------------- */
    const roleTabs = document.querySelectorAll(".role-tab-btn");
    const hiddenRoleInput = document.getElementById("hiddenSelectedRole");

    roleTabs.forEach(function (tab) {
        tab.addEventListener("click", function () {
            roleTabs.forEach(t => t.classList.remove("active"));
            tab.classList.add("active");

            const selectedRole = tab.getAttribute("data-role");
            if (hiddenRoleInput) {
                hiddenRoleInput.value = selectedRole;
            }
        });
    });

});
