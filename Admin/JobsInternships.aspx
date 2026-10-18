<%@ Page Title="Manage Jobs & Internships - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="JobsInternships.aspx.cs" Inherits="SkillLinksX.Admin.JobsInternships" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Jobs & Internships Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Manage Jobs &amp; Internships</h1>
                <p class="admin-page-main-sub">Review and manage all job and internship opportunities on SkillLinkX.</p>
            </div>
            <a href="<%= ResolveUrl("~/Company/PostJob.aspx?type=job") %>" class="btn-admin-primary-add" style="text-decoration:none;">
                <i class="fa-solid fa-plus"></i> Add Opportunity
            </a>
        </div>

        <!-- Placeholder Box as specified in Figma screenshot -->
        <div class="admin-placeholder-card" style="background:#FFFFFF; border:1px solid #CBD5E1; border-radius:12px; height:320px; display:flex; align-items:center; justify-content:center; color:#64748B; font-size:14px; margin-top:24px;">
            Jobs and Internships Dashboard Content Placeholder
        </div>

    </div>
</asp:Content>
