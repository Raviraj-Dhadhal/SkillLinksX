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

                <!-- Recommended For You Hero Banner (Dynamic AI Match) -->
                <div class="recommended-hero-banner">
                    <div class="rec-banner-top">
                        <div class="rec-tag-title">
                            <i class="fa-solid fa-sparkles"></i> RECOMMENDED FOR YOU
                        </div>
                        <!-- Match score ring -->
                        <div class="rec-score-chip">
                            <span class="rec-score-number"><%= RecommendedScore %>%</span>
                        </div>
                    </div>

                    <div class="rec-banner-body">
                        <h2 class="rec-role-title"><%= RecommendedTitle %></h2>
                        <div class="rec-company-loc">
                            <i class="fa-regular fa-building"></i> <%= RecommendedCompany %> &bull; <%= RecommendedLocation %>
                        </div>

                        <div class="rec-skills-row">
                            <asp:Repeater ID="rptRecommendedSkills" runat="server">
                                <ItemTemplate>
                                    <span class="rec-skill-tag"><i class="fa-solid fa-check"></i> <%# Container.DataItem %></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <div class="rec-banner-actions">
                        <a href='<%= ResolveUrl("~/User/JobDetails.aspx?id=" + RecommendedJobId) %>' class="btn-rec-apply">View &amp; Apply</a>
                    </div>
                </div>

                <!-- Dynamic Jobs Listing Section -->
                <div class="opps-listings-list" style="margin-top: 24px; display: flex; flex-direction: column; gap: 16px;">
                    <asp:Repeater ID="rptJobsList" runat="server">
                        <ItemTemplate>
                            <div class="job-list-card" style="background:#fff; border:1px solid #e2e8f0; border-radius:12px; padding:18px; display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="display:flex; align-items:center; gap:8px; margin-bottom:4px;">
                                        <h3 style="font-size:16px; font-weight:600; color:#0f172a; margin:0;"><%# Eval("Title") %></h3>
                                        <span class="badge-role-match" style="font-size:11px; padding:2px 8px; background:#eff6ff; color:#2563eb; border-radius:6px; font-weight:600;">
                                            <%# Eval("AiMatchScore") %>% Match
                                        </span>
                                    </div>
                                    <div style="font-size:13px; color:#64748b; margin-bottom:8px;">
                                        <i class="fa-regular fa-building"></i> <%# Eval("CompanyName") %> &bull; <i class="fa-solid fa-location-dot"></i> <%# Eval("Location") %> &bull; <i class="fa-solid fa-money-bill-wave"></i> <%# Eval("SalaryRange") %>
                                    </div>
                                    <div style="font-size:12px; color:#475569;">
                                        <strong>Skills:</strong> <%# Eval("RequiredSkills") %>
                                    </div>
                                </div>
                                <div>
                                    <a href='<%# ResolveUrl("~/User/JobDetails.aspx?id=" + Eval("JobId")) %>' class="btn btn-primary" style="padding:8px 16px; font-size:13px; border-radius:8px; text-decoration:none; background:#2563eb; color:#fff; font-weight:500;">
                                        View Details
                                    </a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

            </main>

        </div>

    </div>
</asp:Content>
