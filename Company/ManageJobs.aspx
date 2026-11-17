<%@ Page Title="Manage Jobs - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="ManageJobs.aspx.cs" Inherits="SkillLinksX.Company.ManageJobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Manage Jobs Specific Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="manage-jobs-container">
        
        <!-- Header Row -->
        <div class="manage-jobs-header">
            <div>
                <h1 class="manage-jobs-title">Manage Jobs</h1>
                <p class="manage-jobs-sub">Create, manage and track all your job opportunities in one place.</p>
            </div>
            <div>
                <a href="<%= ResolveUrl("~/Company/PostJob.aspx?type=job") %>" class="btn-post-new-job-blue">
                    <i class="fa-solid fa-plus"></i> Post New Job
                </a>
            </div>
        </div>

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Aggregated counts from 'jobs' & 'applications'
             ========================================================================= -->
        <div class="manage-metrics-5col">
            <!-- Total Jobs -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-blue">
                    <i class="fa-solid fa-briefcase"></i>
                </div>
                <div class="metric-tile-number"><%= TotalJobsCount %></div>
                <div class="metric-tile-desc">Total Jobs</div>
            </div>

            <!-- Active Jobs -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-green">
                    <i class="fa-solid fa-check"></i>
                </div>
                <div class="metric-tile-number"><%= ActiveJobsCount %></div>
                <div class="metric-tile-desc">Active Jobs</div>
            </div>

            <!-- Drafts / Paused -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-indigo">
                    <i class="fa-regular fa-file-lines"></i>
                </div>
                <div class="metric-tile-number"><%= ClosedJobsCount %></div>
                <div class="metric-tile-desc">Closed / Paused</div>
            </div>

            <!-- Applications -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-purple">
                    <i class="fa-solid fa-user-group"></i>
                </div>
                <div class="metric-tile-number"><%= TotalApplicationsCount %></div>
                <div class="metric-tile-desc">Applications</div>
            </div>

            <!-- Jobs Active (Quick Status) -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-red">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <div class="metric-tile-number"><%= ActiveJobsCount %></div>
                <div class="metric-tile-desc">Live on Portal</div>
            </div>
        </div>

        <!-- Manage Jobs Main Table Section -->
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

            <asp:Label ID="lblActionMessage" runat="server" ForeColor="Green" style="display:block; margin: 10px 14px; font-size:13px; font-weight:600;" EnableViewState="false" />

            <!-- Data Table -->
            <div style="overflow-x: auto;">
                <table class="jobs-data-table">
                    <thead>
                        <tr>
                            <th>Job Title</th>
                            <th>Location</th>
                            <th>Type</th>
                            <th>Applications</th>
                            <th>Posted Date</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- =========================================================
                             [COMPANY JOBS REPEATER]: Binds all jobs for this company
                             ========================================================= -->
                        <asp:Repeater ID="rptCompanyJobs" runat="server" OnItemCommand="rptCompanyJobs_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <a href='<%# ResolveUrl("~/Company/Applicants.aspx") %>' class="job-table-title-link" style="font-weight:600;">
                                            <%# Eval("Title") %>
                                        </a>
                                    </td>
                                    <td><%# Eval("Location") %></td>
                                    <td><%# Eval("JobType") %></td>
                                    <td>
                                        <span style="font-weight:600; color:#2563eb;"><%# Eval("ApplicationCount") %></span>
                                    </td>
                                    <td><%# Eval("PostedDate") %></td>
                                    <td>
                                        <span class='job-status-badge <%# Eval("Status").ToString() == "Active" ? "status-active" : "status-draft" %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </td>
                                    <td style="text-align: right;">
                                        <asp:LinkButton ID="btnToggleStatus" runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("JobId") + "|" + Eval("Status") %>' CssClass="btn btn-sm" style="font-size:12px; margin-right:8px; text-decoration:none; color:#2563eb;">
                                            <%# Eval("Status").ToString() == "Active" ? "Close" : "Reopen" %>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDeleteJob" runat="server" CommandName="DeleteJob" CommandArgument='<%# Eval("JobId") %>' OnClientClick="return confirm('Are you sure you want to delete this job posting?');" CssClass="btn btn-sm" style="font-size:12px; text-decoration:none; color:#dc2626;">
                                            Delete
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
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
