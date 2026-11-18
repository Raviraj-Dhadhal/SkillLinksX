<%@ Page Title="Help Center - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="HelpCenter.aspx.cs" Inherits="SkillLinksX.Public.HelpCenter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="help-page-wrapper">
        <!-- Hero Header -->
        <div class="help-hero-banner">
            <h1 class="help-hero-title">How Can We Help?</h1>
            <p class="help-hero-desc">Find answers, explore helpful resources, or get support with your SkillLinkX experience.</p>

            <div class="help-search-container">
                <i class="fa-solid fa-magnifying-glass" style="color: #64748B; margin-left: 10px;"></i>
                <asp:TextBox ID="txtHelpSearch" runat="server" CssClass="help-search-input" placeholder="Search jobs, internships, people..."></asp:TextBox>
                <a href="#" class="btn-search-submit" style="padding: 9px 24px; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Search</a>
            </div>

            <div class="help-popular-tags">
                <span style="font-weight: 700; color: #475569; letter-spacing: 0.5px; font-size: 11.5px;">POPULAR:</span>
                <a href="javascript:void(0);" class="popular-tag-btn">Jobs</a>
                <a href="javascript:void(0);" class="popular-tag-btn">Internships</a>
                <a href="javascript:void(0);" class="popular-tag-btn">Profile</a>
                <a href="javascript:void(0);" class="popular-tag-btn">Applications</a>
            </div>

            <!-- Live Search Status Indicator -->
            <div id="helpSearchStatus" style="display: none; margin: 16px auto 0; max-width: 620px; align-items: center; justify-content: space-between; font-size: 13.5px; color: #475569; background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 6px; padding: 8px 14px;">
                <span><i class="fa-solid fa-magnifying-glass" style="margin-right: 6px; color: #0052CC;"></i> <span id="helpSearchResultCount" style="font-weight: 700; color: #0F172A;">0</span> results found for "<strong id="helpSearchQueryDisplay"></strong>"</span>
                <a href="javascript:void(0);" id="btnResetHelpSearch" style="color: #0052CC; font-weight: 600; text-decoration: none; font-size: 12.5px;"><i class="fa-solid fa-xmark"></i> Clear</a>
            </div>
        </div>

        <!-- No Results Fallback Banner -->
        <div id="helpNoResults" style="display: none; text-align: center; padding: 48px 20px; background: #FFFFFF; border: 1px dashed #CBD5E1; border-radius: 12px; margin-top: 24px;">
            <div style="width: 56px; height: 56px; background: #F1F5F9; color: #64748B; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 24px; margin-bottom: 12px;">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>
            <h3 style="font-size: 17px; font-weight: 700; color: #0F172A; margin-bottom: 6px;">No help topics found for "<span id="noResultsTerm"></span>"</h3>
            <p style="font-size: 13.5px; color: #64748B; max-width: 480px; margin: 0 auto 18px; line-height: 1.5;">We couldn't find any articles matching your search. Try searching with common keywords like <strong>Jobs</strong>, <strong>Internships</strong>, <strong>Profile</strong>, <strong>Interviews</strong>, or <strong>Applications</strong>.</p>
            <button type="button" id="btnClearHelpSearchBtn" style="background-color: #0052CC; color: #FFFFFF; border: none; padding: 9px 20px; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; transition: background 0.2s;">View All Topics</button>
        </div>

        <!-- 8 Help Categories (4x2 Grid) -->
        <div class="help-categories-grid" id="helpCategoriesGrid">
            <!-- 1. Getting Started -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="getting started new account setup profile register signup login welcome basics">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-rocket"></i>
                </div>
                <h3 class="help-cat-title">Getting Started</h3>
                <p class="help-cat-desc">New to SkillLinkX? Learn account setup, profile creation, and basics.</p>
            </a>

            <!-- 2. Account & Profile -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="account profile update password email privacy settings credentials bio picture photo">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-user-gear"></i>
                </div>
                <h3 class="help-cat-title">Account & Profile</h3>
                <p class="help-cat-desc">Update personal info, change password, and customize privacy settings.</p>
            </a>

            <!-- 3. Jobs & Internships -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="jobs internships search filter opportunities listings roles apply career openings">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-briefcase"></i>
                </div>
                <h3 class="help-cat-title">Jobs & Internships</h3>
                <p class="help-cat-desc">Search opportunities, filter listings, and understand qualifications.</p>
            </a>

            <!-- 4. Applications -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="applications applied status resume cv submitted recruiter tracking updates shortlist">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-file-lines"></i>
                </div>
                <h3 class="help-cat-title">Applications</h3>
                <p class="help-cat-desc">Track status, manage submitted resumes, and receive recruiter updates.</p>
            </a>

            <!-- 5. For Companies -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="for companies company recruiter employer hiring post openings hire talent shortlist candidates job posting">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-building"></i>
                </div>
                <h3 class="help-cat-title">For Companies</h3>
                <p class="help-cat-desc">Post openings, discover candidates, review applications, and hire talent.</p>
            </a>

            <!-- 6. AI Career Assistant -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="ai career assistant resume insights job matches interview suggestions recommendations artificial intelligence">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                </div>
                <h3 class="help-cat-title">AI Career Assistant</h3>
                <p class="help-cat-desc">Get intelligent resume insights, job matches, and interview suggestions.</p>
            </a>

            <!-- 7. Interviews -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="interviews schedule calendar calls technical meetings rounds google meet date time recruiter">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-calendar-check"></i>
                </div>
                <h3 class="help-cat-title">Interviews</h3>
                <p class="help-cat-desc">Schedule calls, prep for technical rounds, and join remote meetings.</p>
            </a>

            <!-- 8. Technical Support -->
            <a href="javascript:void(0);" class="help-cat-card" data-keywords="technical support troubleshoot login bug error platform issue help contact feedback">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-headset"></i>
                </div>
                <h3 class="help-cat-title">Technical Support</h3>
                <p class="help-cat-desc">Troubleshoot login issues, browser errors, and report platform bugs.</p>
            </a>
        </div>

        <!-- Help Articles & FAQs -->
        <div class="help-faq-section" id="helpFaqSection" style="margin-top: 48px;">
            <div style="border-bottom: 1px solid #E2E8F0; padding-bottom: 12px; margin-bottom: 24px;">
                <h2 style="font-size: 20px; font-weight: 700; color: #0F172A; margin-bottom: 4px;">Frequently Asked Questions</h2>
                <p style="font-size: 13.5px; color: #64748B; margin: 0;">Instant answers to common queries on SkillLinkX.</p>
            </div>

            <div class="help-faq-list" id="helpFaqList" style="display: flex; flex-direction: column; gap: 12px;">
                <!-- FAQ 1 -->
                <div class="help-faq-item" data-keywords="jobs apply apply for jobs internship internships search filter opportunities apply button resume" style="background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 8px; padding: 18px 20px;">
                    <h4 style="font-size: 15px; font-weight: 600; color: #0F172A; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-briefcase" style="color: #0052CC; font-size: 14px;"></i>
                        How do I search and apply for jobs and internships?
                    </h4>
                    <p style="font-size: 13.5px; color: #475569; line-height: 1.6; margin: 0;">
                        Navigate to the Jobs or Internships tab, use keyword filters to find positions matching your skills and location, and click <strong>Apply</strong>. Your profile details and uploaded resume will be submitted directly to the recruiter.
                    </p>
                </div>

                <!-- FAQ 2 -->
                <div class="help-faq-item" data-keywords="profile account photo education college skills update edit change resume details" style="background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 8px; padding: 18px 20px;">
                    <h4 style="font-size: 15px; font-weight: 600; color: #0F172A; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-user-gear" style="color: #0052CC; font-size: 14px;"></i>
                        How can I update my profile details and skills?
                    </h4>
                    <p style="font-size: 13.5px; color: #475569; line-height: 1.6; margin: 0;">
                        Log in to your account and go to <strong>Profile</strong>. Here you can edit your bio, college, graduation year, key skills, and upload an updated resume.
                    </p>
                </div>

                <!-- FAQ 3 -->
                <div class="help-faq-item" data-keywords="applications track status reviewed shortlisted accepted rejected recruiter tracking" style="background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 8px; padding: 18px 20px;">
                    <h4 style="font-size: 15px; font-weight: 600; color: #0F172A; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-file-lines" style="color: #0052CC; font-size: 14px;"></i>
                        How do I track the status of my applications?
                    </h4>
                    <p style="font-size: 13.5px; color: #475569; line-height: 1.6; margin: 0;">
                        Visit your <strong>Applications</strong> tab. Each job shows its live status: <em>Applied</em>, <em>Under Review</em>, <em>Shortlisted</em>, or <em>Interview Scheduled</em>.
                    </p>
                </div>

                <!-- FAQ 4 -->
                <div class="help-faq-item" data-keywords="interviews schedule meeting google meet calendar date time call recruiter" style="background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 8px; padding: 18px 20px;">
                    <h4 style="font-size: 15px; font-weight: 600; color: #0F172A; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-calendar-check" style="color: #0052CC; font-size: 14px;"></i>
                        How do interview invitations and Google Meet links work?
                    </h4>
                    <p style="font-size: 13.5px; color: #475569; line-height: 1.6; margin: 0;">
                        When a company schedules an interview, you'll receive notification of the time and date along with a direct Google Meet button in your Interviews calendar.
                    </p>
                </div>

                <!-- FAQ 5 -->
                <div class="help-faq-item" data-keywords="company recruiter employer post job post opening hire candidates shortlist applicants" style="background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 8px; padding: 18px 20px;">
                    <h4 style="font-size: 15px; font-weight: 600; color: #0F172A; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-building" style="color: #0052CC; font-size: 14px;"></i>
                        How do recruiters post openings and find candidates?
                    </h4>
                    <p style="font-size: 13.5px; color: #475569; line-height: 1.6; margin: 0;">
                        Employers register with a Company account to access the recruiter dashboard, post job or internship listings, review candidate applicants, and send interview invitations.
                    </p>
                </div>

                <!-- FAQ 6 -->
                <div class="help-faq-item" data-keywords="technical support contact inquiry bug error help login problem issue message" style="background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 8px; padding: 18px 20px;">
                    <h4 style="font-size: 15px; font-weight: 600; color: #0F172A; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-headset" style="color: #0052CC; font-size: 14px;"></i>
                        How can I report an issue or reach support?
                    </h4>
                    <p style="font-size: 13.5px; color: #475569; line-height: 1.6; margin: 0;">
                        Visit our <a href="Contact.aspx" style="color: #0052CC; font-weight: 600; text-decoration: underline;">Contact Us</a> page and submit your query. Our support team will get back to your registered email promptly.
                    </p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
