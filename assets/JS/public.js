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

    /* ----------------------------------------------------------------------
       6. Help Center Real-time Keyword Search & Filtering (No dialogue)
       ---------------------------------------------------------------------- */
    const helpSearchInput = document.querySelector(".help-search-input");
    const helpSearchBtn = document.querySelector(".help-search-container a.btn-search-submit");
    const helpCards = document.querySelectorAll(".help-categories-grid .help-cat-card");
    const helpFaqItems = document.querySelectorAll("#helpFaqList .help-faq-item");
    const helpFaqSection = document.getElementById("helpFaqSection");
    const helpStatus = document.getElementById("helpSearchStatus");
    const helpResultCount = document.getElementById("helpSearchResultCount");
    const helpQueryDisplay = document.getElementById("helpSearchQueryDisplay");
    const helpNoResults = document.getElementById("helpNoResults");
    const noResultsTerm = document.getElementById("noResultsTerm");
    const btnResetHelp = document.getElementById("btnResetHelpSearch");
    const btnClearHelp = document.getElementById("btnClearHelpSearchBtn");
    const popularTagBtns = document.querySelectorAll(".help-popular-tags a.popular-tag-btn");

    function executeHelpSearch(query) {
        const term = (query || "").trim().toLowerCase();

        if (!term) {
            // Restore all category cards and FAQs
            helpCards.forEach(function (card) {
                card.style.display = "";
            });
            helpFaqItems.forEach(function (item) {
                item.style.display = "";
            });
            if (helpFaqSection) helpFaqSection.style.display = "";
            if (helpStatus) helpStatus.style.display = "none";
            if (helpNoResults) helpNoResults.style.display = "none";
            return;
        }

        let matchCount = 0;

        // Match help categories
        helpCards.forEach(function (card) {
            const title = (card.querySelector(".help-cat-title")?.textContent || "").toLowerCase();
            const desc = (card.querySelector(".help-cat-desc")?.textContent || "").toLowerCase();
            const keywords = (card.getAttribute("data-keywords") || "").toLowerCase();

            const isMatch = title.includes(term) || desc.includes(term) || keywords.includes(term);
            card.style.display = isMatch ? "" : "none";
            if (isMatch) matchCount++;
        });

        // Match FAQ items
        let faqMatchCount = 0;
        helpFaqItems.forEach(function (item) {
            const text = item.textContent.toLowerCase();
            const keywords = (item.getAttribute("data-keywords") || "").toLowerCase();

            const isMatch = text.includes(term) || keywords.includes(term);
            item.style.display = isMatch ? "" : "none";
            if (isMatch) {
                faqMatchCount++;
                matchCount++;
            }
        });

        if (helpFaqSection) {
            helpFaqSection.style.display = faqMatchCount > 0 ? "" : "none";
        }

        // Show live status indicator
        if (helpStatus && helpResultCount && helpQueryDisplay) {
            helpStatus.style.display = "flex";
            helpResultCount.textContent = matchCount;
            helpQueryDisplay.textContent = query.trim();
        }

        // Show/hide no results banner
        if (helpNoResults && noResultsTerm) {
            if (matchCount === 0) {
                helpNoResults.style.display = "block";
                noResultsTerm.textContent = query.trim();
            } else {
                helpNoResults.style.display = "none";
            }
        }
    }

    if (helpSearchInput) {
        // Live search on typing
        helpSearchInput.addEventListener("input", function () {
            executeHelpSearch(this.value);
        });

        // Search on Enter key without form submission
        helpSearchInput.addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                e.preventDefault();
                executeHelpSearch(this.value);
            }
        });
    }

    if (helpSearchBtn) {
        helpSearchBtn.addEventListener("click", function (e) {
            e.preventDefault();
            if (helpSearchInput) {
                executeHelpSearch(helpSearchInput.value);
            }
        });
    }

    // Popular tags click triggers search immediately
    popularTagBtns.forEach(function (tag) {
        tag.addEventListener("click", function (e) {
            e.preventDefault();
            const tagText = tag.textContent.trim();
            if (helpSearchInput) {
                helpSearchInput.value = tagText;
                executeHelpSearch(tagText);
                helpSearchInput.focus();
            }
        });
    });

    // Reset search buttons
    function clearHelpSearch() {
        if (helpSearchInput) {
            helpSearchInput.value = "";
            executeHelpSearch("");
            helpSearchInput.focus();
        }
    }

    if (btnResetHelp) btnResetHelp.addEventListener("click", clearHelpSearch);
    if (btnClearHelp) btnClearHelp.addEventListener("click", clearHelpSearch);

});
