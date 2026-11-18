<%@ Page Title="Help & Support - SkillLinksX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="SkillLinksX.User.Help" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .user-help-container {
            max-width: 1140px;
            margin: 0 auto;
            padding: 24px 20px 48px;
        }

        .user-help-hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
            border-radius: 16px;
            padding: 36px 32px;
            color: #ffffff;
            margin-bottom: 28px;
            box-shadow: 0 10px 25px -5px rgba(37, 99, 235, 0.25);
            text-align: center;
        }

        .user-help-hero h1 {
            font-size: 28px;
            font-weight: 700;
            margin: 0 0 10px;
        }

        .user-help-hero p {
            font-size: 15px;
            color: #e0e7ff;
            max-width: 620px;
            margin: 0 auto 20px;
        }

        .user-help-search {
            max-width: 520px;
            margin: 0 auto;
            position: relative;
        }

        .user-help-search input {
            width: 100%;
            padding: 13px 18px 13px 44px;
            border-radius: 10px;
            border: none;
            outline: none;
            font-size: 14px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.1);
        }

        .user-help-search i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 16px;
        }

        .help-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }

        .help-tile-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 24px 20px;
            transition: all 0.2s ease;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
        }

        .help-tile-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06);
            border-color: #cbd5e1;
        }

        .help-tile-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            background: #eff6ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 14px;
        }

        .help-tile-title {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .help-tile-desc {
            font-size: 13px;
            color: #64748b;
            line-height: 1.5;
            margin: 0;
        }

        .help-faq-section {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 28px;
            margin-bottom: 32px;
        }

        .help-faq-title {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .faq-accordion-item {
            border-bottom: 1px solid #f1f5f9;
            padding: 14px 0;
        }

        .faq-accordion-item:last-child {
            border-bottom: none;
        }

        .faq-question {
            font-size: 14.5px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .faq-answer {
            font-size: 13.5px;
            color: #475569;
            line-height: 1.6;
            margin: 0;
            padding-left: 22px;
        }

        .help-contact-box {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            padding: 24px;
            text-align: center;
        }

        .help-contact-box h3 {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 6px;
        }

        .help-contact-box p {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 14px;
        }

        .btn-contact-support {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #2563eb;
            color: #ffffff !important;
            padding: 10px 22px;
            border-radius: 8px;
            font-size: 13.5px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.15s ease;
        }

        .btn-contact-support:hover {
            background: #1d4ed8;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-help-container">
        <!-- Hero Header -->
        <div class="user-help-hero">
            <h1>Student Help &amp; Support</h1>
            <p>Have questions about your applications, portfolio, interview schedules, or profile settings? We're here to help.</p>
            <div class="user-help-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="txtHelpSearch" placeholder="Search guides, FAQs, or topics..." onkeyup="filterHelp(this.value)" />
            </div>
        </div>

        <!-- 6 Quick Help Categories -->
        <div class="help-grid">
            <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="help-tile-card">
                <div class="help-tile-icon"><i class="fa-solid fa-user-pen"></i></div>
                <div class="help-tile-title">Profile &amp; Resume</div>
                <p class="help-tile-desc">Upload your latest resume, fill your education and skills, and increase your profile strength score.</p>
            </a>

            <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="help-tile-card">
                <div class="help-tile-icon"><i class="fa-solid fa-briefcase"></i></div>
                <div class="help-tile-title">Jobs &amp; Internships</div>
                <p class="help-tile-desc">Learn how to search, filter by role/stipend, save opportunities, and submit 1-click applications.</p>
            </a>

            <a href="<%= ResolveUrl("~/User/Applications.aspx") %>" class="help-tile-card">
                <div class="help-tile-icon"><i class="fa-solid fa-file-signature"></i></div>
                <div class="help-tile-title">Tracking Applications</div>
                <p class="help-tile-desc">Understand application statuses (Applied, Shortlisted, In Review, Offered) and next steps.</p>
            </a>

            <a href="<%= ResolveUrl("~/User/Notifications.aspx") %>" class="help-tile-card">
                <div class="help-tile-icon"><i class="fa-solid fa-bell"></i></div>
                <div class="help-tile-title">Interview Notifications</div>
                <p class="help-tile-desc">Interview schedules and meeting links are delivered directly to your Notifications and Messages.</p>
            </a>

            <a href="<%= ResolveUrl("~/User/CareerAssistant.aspx") %>" class="help-tile-card">
                <div class="help-tile-icon"><i class="fa-solid fa-wand-magic-sparkles"></i></div>
                <div class="help-tile-title">AI Career Assistant</div>
                <p class="help-tile-desc">Get personalized AI career advice, discover skill gaps, and improve your role match ratings.</p>
            </a>

            <a href="<%= ResolveUrl("~/User/Networking.aspx") %>" class="help-tile-card">
                <div class="help-tile-icon"><i class="fa-solid fa-users"></i></div>
                <div class="help-tile-title">Networking &amp; Messages</div>
                <p class="help-tile-desc">Connect with students and alumni, send messages to recruiters, and grow your network.</p>
            </a>
        </div>

        <!-- Frequently Asked Questions -->
        <div class="help-faq-section">
            <div class="help-faq-title">
                <i class="fa-solid fa-circle-question text-primary"></i> Frequently Asked Questions
            </div>

            <div class="faq-accordion-item">
                <div class="faq-question"><i class="fa-solid fa-chevron-right text-primary" style="font-size:11px;"></i> How do I apply for jobs or internships?</div>
                <p class="faq-answer">Browse openings from the <strong>Jobs</strong> or <strong>Internships</strong> pages, click on any opening to view details, and hit <strong>Apply Now</strong>. Your saved profile resume will be attached automatically.</p>
            </div>

            <div class="faq-accordion-item">
                <div class="faq-question"><i class="fa-solid fa-chevron-right text-primary" style="font-size:11px;"></i> How is my AI Career Match score calculated?</div>
                <p class="faq-answer">Our AI compares the skills in your profile (e.g. C#, SQL, Python) with the job's requirements. Adding more relevant skills directly boosts your match percentage.</p>
            </div>

            <div class="faq-accordion-item">
                <div class="faq-question"><i class="fa-solid fa-chevron-right text-primary" style="font-size:11px;"></i> Can I update my resume after applying?</div>
                <p class="faq-answer">Yes! Head to your <strong>Profile</strong> or <strong>Settings</strong> to upload an updated resume. Any future applications will automatically use the new document.</p>
            </div>

            <div class="faq-accordion-item">
                <div class="faq-question"><i class="fa-solid fa-chevron-right text-primary" style="font-size:11px;"></i> Where do I see interview links and recruiter messages?</div>
                <p class="faq-answer">Check your <strong>Notifications</strong> tab for scheduled dates and meeting links, and the <strong>Messages</strong> tab to chat directly with recruiters.</p>
            </div>
        </div>

        <!-- Still Need Help Box -->
        <div class="help-contact-box" style="text-align:center; padding:32px 24px; background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; margin-top:36px;">
            <div style="width:48px; height:48px; border-radius:50%; background:#eff6ff; color:#2563eb; display:inline-flex; align-items:center; justify-content:center; font-size:22px; margin-bottom:12px;">
                <i class="fa-solid fa-envelope"></i>
            </div>
            <h3 style="font-size:18px; font-weight:700; color:#0f172a; margin:0 0 6px;">Still have questions or facing technical issues?</h3>
            <p style="font-size:14px; color:#64748b; margin:0 0 16px;">Contact us directly via email and our support team will assist you:</p>
            <div style="display:inline-block; padding:10px 24px; background:#fff; border:1px solid #cbd5e1; border-radius:30px; box-shadow:0 1px 3px rgba(0,0,0,0.04);">
                <a href="mailto:support@skilllinksx.com" style="font-size:15px; font-weight:600; color:#2563eb; text-decoration:none; display:inline-flex; align-items:center; gap:8px;">
                    <i class="fa-regular fa-envelope"></i> support@skilllinksx.com
                </a>
            </div>
        </div>
    </div>

    <script>
        function filterHelp(term) {
            term = term.toLowerCase().trim();
            const cards = document.querySelectorAll('.help-tile-card');
            cards.forEach(card => {
                const text = card.innerText.toLowerCase();
                card.style.display = text.includes(term) ? '' : 'none';
            });
            const faqs = document.querySelectorAll('.faq-accordion-item');
            faqs.forEach(faq => {
                const text = faq.innerText.toLowerCase();
                faq.style.display = text.includes(term) ? '' : 'none';
            });
        }
    </script>
</asp:Content>
