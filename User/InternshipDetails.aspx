<%@ Page Title="Internship Details - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="InternshipDetails.aspx.cs" Inherits="SkillLinksX.User.InternshipDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Internship Details Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-opp-details-container">

        <!-- Top Breadcrumbs Bar -->
        <div class="opp-details-breadcrumb">
            <a href="<%= ResolveUrl("~/User/Internships.aspx") %>" class="breadcrumb-back-link">
                <i class="fa-solid fa-arrow-left"></i> Back to Internship
            </a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Software Developer</span>
        </div>

        <!-- 2-Column Details Workspace -->
        <div class="opp-details-grid">

            <!-- Left Main Column (Header Banner, About, Responsibilities, Requirements) -->
            <div class="opp-details-main-col">

                <!-- 1. Header Banner Card -->
                <div class="opp-details-header-card">
                    <div class="opp-header-top-row">
                        <div class="opp-header-brand-wrap">
                            <div class="opp-details-avatar-box">
                                <img src="<%= ResolveUrl("~/assets/images/razorpay-logo.svg") %>" alt="Razorpay" class="opp-details-brand-img" />
                            </div>
                            <div class="opp-details-title-wrap">
                                <h1 class="opp-details-role-title"><%= InternshipTitle %></h1>
                                <div class="opp-details-company-name"><%= CompanyName %></div>
                                <div class="opp-details-sub-meta">
                                    <span><i class="fa-solid fa-location-dot"></i> <%= Location %></span>
                                    <span><i class="fa-solid fa-laptop-code"></i> <%= JobType %></span>
                                    <span><i class="fa-regular fa-clock"></i> Active Opening</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="opp-details-stipend-row flex-between" style="display:flex; justify-content:space-between; align-items:center; margin-top:16px; padding-top:14px; border-top:1px solid #f1f5f9;">
                        <div class="opp-stipend-amount" style="font-size:16px; font-weight:700; color:#0f172a; display:inline-flex; align-items:center; gap:8px;">
                            <span style="font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase;">Stipend:</span> <%= SalaryRange %>
                        </div>
                        <div class="opp-header-action-btns">
                            <button type="button" class="btn-opp-action-pill" onclick="alert('Internship link copied!');">
                                <i class="fa-solid fa-share-nodes"></i> Share
                            </button>
                            <asp:Button ID="btnApplyInternship" runat="server" Text="Apply Now" CssClass="btn-opp-apply-primary" OnClick="btnApplyInternship_Click" />
                        </div>
                    </div>
                </div>

                <asp:Label ID="lblApplyFeedback" runat="server" style="display:block; margin: 10px 0; font-size:13.5px; font-weight:600;" EnableViewState="false" />

                <!-- 2. About the Internship Card -->
                <div class="opp-details-section-card">
                    <div class="opp-section-header">
                        <h2 class="opp-section-title">About the Internship</h2>
                    </div>
                    <div class="opp-section-body">
                        <p class="opp-body-paragraph">
                            We are seeking a passionate and driven Software Development Intern to join our dynamic engineering team. In this role, you will get hands-on experience building scalable payment solutions that empower millions of businesses.
                        </p>
                        <p class="opp-body-paragraph">
                            You will be mentored by senior engineers, gaining deep exposure to full-stack development, modern web architectures, and agile methodologies. This is an incredible opportunity to impact real products while honing your technical skills in a fast-paced fintech environment.
                        </p>

                        <!-- Key Responsibilities -->
                        <h3 class="opp-sub-heading mt-4">Key Responsibilities</h3>
                        <ul class="opp-bullets-list">
                            <li>Develop and maintain responsive user interfaces using React and modern CSS frameworks.</li>
                            <li>Collaborate with cross-functional teams to define, design, and ship new features.</li>
                            <li>Write clean, maintainable, and well-tested code.</li>
                            <li>Participate in code reviews and architecture discussions.</li>
                            <li>Create and maintain technical documentation for internal systems.</li>
                        </ul>
                    </div>
                </div>

            </div>

            <!-- Right Sidebar Column (AI Match Score & Internship Details Meta) -->
            <div class="opp-details-sidebar-col">

                <!-- 1. AI Match Score Card (Purple Gradient) -->
                <div class="ai-match-score-card">
                    <div class="ai-match-top-flex">
                        <div class="ai-match-label-group">
                            <i class="fa-solid fa-sparkles ai-stars-icon"></i>
                            <span class="ai-match-card-label">AI Match Score</span>
                        </div>
                        <div class="ai-match-percentage"><%= AiMatchScore %>%</div>
                    </div>
                    <p class="ai-match-description">
                        Calculated by comparing your profile skills with this internship's requirements.
                    </p>
                    <div class="ai-matching-skills-title">REQUIRED SKILLS</div>
                    <div class="ai-skills-tags-row">
                        <asp:Repeater ID="rptRequiredSkills" runat="server">
                            <ItemTemplate>
                                <span class="ai-skill-tag"><%# Container.DataItem %></span>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- 2. Internship Details Info Box -->
                <div class="internship-meta-box-card">
                    <div class="meta-box-header">
                        <h3 class="meta-box-title">Internship Details</h3>
                    </div>
                    <div class="meta-box-body">
                        <div class="meta-field-item">
                            <div class="meta-field-icon">
                                <i class="fa-regular fa-calendar"></i>
                            </div>
                            <div class="meta-field-content">
                                <span class="meta-field-name">Start Date</span>
                                <span class="meta-field-val">08/06/2023</span>
                            </div>
                        </div>

                        <div class="meta-field-item">
                            <div class="meta-field-icon">
                                <i class="fa-regular fa-clock"></i>
                            </div>
                            <div class="meta-field-content">
                                <span class="meta-field-name">Duration</span>
                                <span class="meta-field-val">6 Months</span>
                            </div>
                        </div>

                        <div class="meta-field-item">
                            <div class="meta-field-icon">
                                <i class="fa-regular fa-calendar-xmark"></i>
                            </div>
                            <div class="meta-field-content">
                                <span class="meta-field-name">Apply By</span>
                                <span class="meta-field-val">24 Oct, 2023</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
