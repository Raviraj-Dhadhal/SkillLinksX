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

            <% if (TotalJobsCount == 0) { %>
                <div style="padding:32px 16px; text-align:center; color:#64748b;">
                    <i class="fa-solid fa-briefcase" style="font-size:32px; color:#cbd5e1; margin-bottom:8px; display:block;"></i>
                    <h4 style="font-size:15px; font-weight:600; color:#334155; margin-bottom:4px;">No Jobs Posted Yet</h4>
                    <p style="font-size:13px; margin:0 0 12px;">Create a job opportunity to start receiving candidate applications.</p>
                    <a href="<%= ResolveUrl("~/Company/PostJob.aspx") %>" class="btn-post-new-job-blue" style="display:inline-block;">Post New Job</a>
                </div>
            <% } %>

            <!-- Table Pagination -->
            <div class="table-pagination-row">
                <div>
                    <span>Rows per page:</span>
                    <select id="ddlJobsPageSize" class="pagination-rows-select" onchange="onJobsPageSizeChange(this.value);">
                        <option value="10" selected="selected">10</option>
                        <option value="25">25</option>
                        <option value="50">50</option>
                    </select>
                </div>
                <div class="pagination-controls">
                    <span id="lblJobsPagination"><%= TotalJobsCount > 0 ? $"1-{Math.Min(10, TotalJobsCount)} of {TotalJobsCount}" : "0 of 0" %></span>
                    <button type="button" id="btnJobsPrev" class="pagination-nav-btn" aria-label="Previous Page" onclick="changeJobsPage(-1);" <%= TotalJobsCount <= 10 ? "disabled" : "" %>>
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <button type="button" id="btnJobsNext" class="pagination-nav-btn" aria-label="Next Page" onclick="changeJobsPage(1);" <%= TotalJobsCount <= 10 ? "disabled" : "" %>>
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>
            </div>

        </div>

    </div>

    <!-- Dynamic Pagination & Filtering Script -->
    <script type="text/javascript">
        var jobsCurrentPage = 1;
        var jobsPageSize = 10;

        function getJobsRows() {
            var table = document.querySelector(".jobs-data-table tbody");
            if (!table) return [];
            return Array.from(table.querySelectorAll("tr"));
        }

        function renderJobsPagination() {
            var rows = getJobsRows();
            var total = rows.length;
            var totalPages = Math.ceil(total / jobsPageSize) || 1;

            if (jobsCurrentPage < 1) jobsCurrentPage = 1;
            if (jobsCurrentPage > totalPages) jobsCurrentPage = totalPages;

            var start = (jobsCurrentPage - 1) * jobsPageSize;
            var end = Math.min(start + jobsPageSize, total);

            rows.forEach(function (row, idx) {
                if (idx >= start && idx < end) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });

            var lbl = document.getElementById("lblJobsPagination");
            if (lbl) {
                if (total === 0) {
                    lbl.innerText = "0 of 0";
                } else {
                    lbl.innerText = (start + 1) + "-" + end + " of " + total;
                }
            }

            var btnPrev = document.getElementById("btnJobsPrev");
            var btnNext = document.getElementById("btnJobsNext");

            if (btnPrev) {
                btnPrev.disabled = (jobsCurrentPage <= 1);
                if (btnPrev.disabled) btnPrev.classList.add("disabled");
                else btnPrev.classList.remove("disabled");
            }
            if (btnNext) {
                btnNext.disabled = (jobsCurrentPage >= totalPages || total === 0);
                if (btnNext.disabled) btnNext.classList.add("disabled");
                else btnNext.classList.remove("disabled");
            }
        }

        function changeJobsPage(delta) {
            jobsCurrentPage += delta;
            renderJobsPagination();
        }

        function onJobsPageSizeChange(val) {
            jobsPageSize = parseInt(val, 10) || 10;
            jobsCurrentPage = 1;
            renderJobsPagination();
        }

        document.addEventListener("DOMContentLoaded", function () {
            renderJobsPagination();
        });
    </script>
</asp:Content>
