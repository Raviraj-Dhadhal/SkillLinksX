<%@ Page Title="Find Jobs - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Jobs.aspx.cs" Inherits="SkillLinksX.User.Jobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Jobs Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-opps-page-container">

        <!-- Header Row -->
        <div class="opps-page-header">
            <h1 class="opps-page-title">Find Your Next Opportunity</h1>
            <p class="opps-page-sub">Discover jobs that match your skills, experience and career goals.</p>
        </div>

        <!-- 2-Column Layout: Left Filters + Right Recommended & Listings -->
        <div class="opps-layout-grid">

            <!-- Left Filters Column -->
            <aside class="opps-filter-column">
                <div class="opps-filter-card">
                    <div class="filter-card-header flex-between">
                        <h3 class="filter-card-title">Filters</h3>
                        <a href="javascript:void(0);" class="filter-clear-all" onclick="resetFilters()">Clear all</a>
                    </div>

                    <div class="filter-card-body">
                        <!-- Job Category -->
                        <div class="filter-section-group">
                            <label class="filter-section-label">JOB CATEGORY</label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" checked="checked" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Software Engineering</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">Data Science</span>
                            </label>
                            <label class="filter-checkbox-row">
                                <input type="checkbox" />
                                <span class="custom-checkbox-indicator"></span>
                                <span class="filter-cb-label">UI/UX Design</span>
                            </label>
                        </div>
                    </div>
                </div>
            </aside>

            <!-- Right Main Content Column -->
            <main class="opps-main-column">

                <!-- Recommended For You Hero Banner (.NET Developer at TechFlow Mumbai) -->
                <div class="recommended-hero-banner">
                    <div class="rec-banner-top">
                        <div class="rec-tag-title">
                            <i class="fa-solid fa-sparkles"></i> RECOMMENDED FOR YOU
                        </div>
                        <!-- Match score ring -->
                        <div class="rec-score-chip">
                            <span class="rec-score-number">95%</span>
                        </div>
                    </div>

                    <div class="rec-banner-body">
                        <h2 class="rec-role-title">.NET Developer</h2>
                        <div class="rec-company-loc">
                            <i class="fa-regular fa-building"></i> TechFlow Mumbai
                        </div>

                        <div class="rec-skills-row">
                            <span class="rec-skill-tag"><i class="fa-solid fa-check"></i> C#</span>
                            <span class="rec-skill-tag"><i class="fa-solid fa-check"></i> ASP.NET</span>
                            <span class="rec-skill-tag tag-muted"><i class="fa-regular fa-circle-plus"></i> Azure</span>
                        </div>
                    </div>

                    <div class="rec-banner-actions">
                        <a href="<%= ResolveUrl("~/User/JobDetails.aspx") %>" class="btn-rec-apply">Apply Now</a>
                    </div>
                </div>

            </main>

        </div>

    </div>
</asp:Content>
