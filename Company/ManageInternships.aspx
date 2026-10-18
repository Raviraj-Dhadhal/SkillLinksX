<%@ Page Title="Manage Internships - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="ManageInternships.aspx.cs" Inherits="SkillLinksX.Company.ManageInternships" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Manage Internships Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="manage-jobs-container">
        
        <!-- Header Row -->
        <div class="manage-jobs-header">
            <div>
                <h1 class="manage-jobs-title">Manage Internship</h1>
                <p class="manage-jobs-sub">Create, manage and track all your Internship opportunities in one place.</p>
            </div>
            <div>
                <a href="<%= ResolveUrl("~/Company/PostJob.aspx?type=internship") %>" class="btn-post-new-job-blue">
                    <i class="fa-solid fa-plus"></i> Post New Internship
                </a>
            </div>
        </div>

        <!-- 5-Metric Tiles Grid (Horizontal scrollable on mobile) -->
        <div class="manage-metrics-5col">
            <!-- Total Internship (24) -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-blue">
                    <i class="fa-solid fa-briefcase"></i>
                </div>
                <div class="metric-tile-number">24</div>
                <div class="metric-tile-desc">Total Internship</div>
            </div>

            <!-- Active Internship (16) -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-green">
                    <i class="fa-solid fa-check"></i>
                </div>
                <div class="metric-tile-number">16</div>
                <div class="metric-tile-desc">Active Internship</div>
            </div>

            <!-- Drafts (4) -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-indigo">
                    <i class="fa-regular fa-file-lines"></i>
                </div>
                <div class="metric-tile-number">4</div>
                <div class="metric-tile-desc">Drafts</div>
            </div>

            <!-- Applications (482) -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-purple">
                    <i class="fa-solid fa-user-group"></i>
                </div>
                <div class="metric-tile-number">482</div>
                <div class="metric-tile-desc">Applications</div>
            </div>

            <!-- Internship Expiring Soon (3) -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-red">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div class="metric-tile-number">3</div>
                <div class="metric-tile-desc">Internship Expiring Soon</div>
            </div>
        </div>

        <!-- Manage Internships Main Table Section -->
        <div class="manage-jobs-table-card">
            
            <!-- Filter Bar -->
            <div class="table-filter-bar">
                <div class="table-search-input-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="Search jobs, internships, people..." />
                </div>
                <select class="table-filter-select">
                    <option>Status</option>
                    <option>Active</option>
                    <option>Draft</option>
                    <option>Closed</option>
                </select>
                <select class="table-filter-select">
                    <option>Location</option>
                    <option>Bengaluru</option>
                    <option>Ahmedabad</option>
                    <option>Remote</option>
                </select>
                <select class="table-filter-select">
                    <option>Work Mode</option>
                    <option>Hybrid</option>
                    <option>On-site</option>
                    <option>Remote</option>
                </select>
            </div>

            <!-- Data Table -->
            <div class="table-responsive-box" style="overflow-x: auto;">
                <table class="jobs-data-table">
                    <thead>
                        <tr>
                            <th>Intern Title</th>
                            <th>Location</th>
                            <th>Type</th>
                            <th>Applications</th>
                            <th>Posted Date</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Row 1: Software Engineer -->
                        <tr>
                            <td>
                                <a href="#" class="job-table-title-link">Software Engineer</a>
                            </td>
                            <td>Bengaluru (Hybrid)</td>
                            <td>Full-time</td>
                            <td>124</td>
                            <td>Oct 12, 2026</td>
                            <td>
                                <span class="job-status-badge status-active">Active</span>
                            </td>
                            <td style="text-align: right;">
                                <button type="button" class="btn-table-more" aria-label="More Options">
                                    <i class="fa-solid fa-ellipsis-vertical"></i>
                                </button>
                            </td>
                        </tr>

                        <!-- Row 2: Product Manager -->
                        <tr>
                            <td>
                                <a href="#" class="job-table-title-link">Product Manager</a>
                            </td>
                            <td>Ahmedabad (On-site)</td>
                            <td>Full-time</td>
                            <td>86</td>
                            <td>Oct 10, 2026</td>
                            <td>
                                <span class="job-status-badge status-active">Active</span>
                            </td>
                            <td style="text-align: right;">
                                <button type="button" class="btn-table-more" aria-label="More Options">
                                    <i class="fa-solid fa-ellipsis-vertical"></i>
                                </button>
                            </td>
                        </tr>

                        <!-- Row 3: UX Designer -->
                        <tr>
                            <td>
                                <a href="#" class="job-table-title-link">UX Designer</a>
                            </td>
                            <td>Remote</td>
                            <td>Contract</td>
                            <td>0</td>
                            <td>-</td>
                            <td>
                                <span class="job-status-badge status-draft">Draft</span>
                            </td>
                            <td style="text-align: right;">
                                <button type="button" class="btn-table-more" aria-label="More Options">
                                    <i class="fa-solid fa-ellipsis-vertical"></i>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Table Pagination -->
            <div class="table-pagination-row">
                <div>
                    <span>Rows per page:</span>
                    <select class="pagination-rows-select">
                        <option selected="selected">10</option>
                        <option>25</option>
                        <option>50</option>
                    </select>
                </div>
                <div class="pagination-controls">
                    <span>1-10 of 24</span>
                    <a href="#" class="pagination-nav-btn" aria-label="Previous Page">
                        <i class="fa-solid fa-chevron-left"></i>
                    </a>
                    <a href="#" class="pagination-nav-btn" aria-label="Next Page">
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div>
            </div>

        </div>

    </div>
</asp:Content>
