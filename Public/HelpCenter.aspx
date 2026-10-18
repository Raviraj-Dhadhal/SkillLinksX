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
                <asp:Button ID="btnHelpSearch" runat="server" Text="Search" CssClass="btn-search-submit" style="padding: 9px 24px; border-radius: 6px;" OnClick="btnHelpSearch_Click" />
            </div>

            <div class="help-popular-tags">
                <span style="font-weight: 700; color: #475569; letter-spacing: 0.5px; font-size: 11.5px;">POPULAR:</span>
                <a href="#" class="popular-tag-btn">Jobs</a>
                <a href="#" class="popular-tag-btn">Internships</a>
                <a href="#" class="popular-tag-btn">Profile</a>
                <a href="#" class="popular-tag-btn">Applications</a>
            </div>
        </div>

        <!-- 8 Help Categories (4x2 Grid) -->
        <div class="help-categories-grid">
            <!-- 1. Getting Started -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-rocket"></i>
                </div>
                <h3 class="help-cat-title">Getting Started</h3>
                <p class="help-cat-desc">New to SkillLinkX? Learn account setup, profile creation, and basics.</p>
            </a>

            <!-- 2. Account & Profile -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-user-gear"></i>
                </div>
                <h3 class="help-cat-title">Account & Profile</h3>
                <p class="help-cat-desc">Update personal info, change password, and customize privacy settings.</p>
            </a>

            <!-- 3. Jobs & Internships -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-briefcase"></i>
                </div>
                <h3 class="help-cat-title">Jobs & Internships</h3>
                <p class="help-cat-desc">Search opportunities, filter listings, and understand qualifications.</p>
            </a>

            <!-- 4. Applications -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-file-lines"></i>
                </div>
                <h3 class="help-cat-title">Applications</h3>
                <p class="help-cat-desc">Track status, manage submitted resumes, and receive recruiter updates.</p>
            </a>

            <!-- 5. For Companies -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-building"></i>
                </div>
                <h3 class="help-cat-title">For Companies</h3>
                <p class="help-cat-desc">Post openings, discover candidates, review applications, and hire talent.</p>
            </a>

            <!-- 6. AI Career Assistant -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                </div>
                <h3 class="help-cat-title">AI Career Assistant</h3>
                <p class="help-cat-desc">Get intelligent resume insights, job matches, and interview suggestions.</p>
            </a>

            <!-- 7. Interviews -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-calendar-check"></i>
                </div>
                <h3 class="help-cat-title">Interviews</h3>
                <p class="help-cat-desc">Schedule calls, prep for technical rounds, and join remote meetings.</p>
            </a>

            <!-- 8. Technical Support -->
            <a href="#" class="help-cat-card">
                <div class="help-cat-icon">
                    <i class="fa-solid fa-headset"></i>
                </div>
                <h3 class="help-cat-title">Technical Support</h3>
                <p class="help-cat-desc">Troubleshoot login issues, browser errors, and report platform bugs.</p>
            </a>
        </div>
    </div>
</asp:Content>
