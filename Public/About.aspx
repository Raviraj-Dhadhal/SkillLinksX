<%@ Page Title="About Us - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="SkillLinksX.Public.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="about-figma-container">
        <!-- Left Side: Content & Buttons -->
        <div class="about-figma-content">
            <h1 class="about-figma-title">Connecting Talent With Opportunity</h1>
            <p class="about-figma-desc">
                SkillLinkX connects students, professionals, recruiters and companies through jobs, internships, networking and AI-powered career tools.
            </p>
            <div class="about-figma-btn-group">
                <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="btn-figma-primary">Explore Opportunities</a>
                <a href="<%= ResolveUrl("~/Public/Register.aspx") %>" class="btn-figma-secondary">Join SkillLinkX</a>
            </div>
        </div>

        <!-- Right Side: Natural Image Card -->
        <div class="about-figma-image-box">
            <img src='<%= ResolveUrl("~/assets/images/about-us image.jpg") %>' alt="Connecting Talent With Opportunity" class="about-figma-img" />
        </div>
    </div>
</asp:Content>
