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
            <!-- Total Internship -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-blue">
                    <i class="fa-solid fa-briefcase"></i>
                </div>
                <div class="metric-tile-number"><%= TotalInternshipsCount %></div>
                <div class="metric-tile-desc">Total Internship</div>
            </div>

            <!-- Active Internship -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-green">
                    <i class="fa-solid fa-check"></i>
                </div>
                <div class="metric-tile-number"><%= ActiveInternshipsCount %></div>
                <div class="metric-tile-desc">Active Internship</div>
            </div>

            <!-- Drafts / Closed -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-indigo">
                    <i class="fa-regular fa-file-lines"></i>
                </div>
                <div class="metric-tile-number"><%= DraftsCount %></div>
                <div class="metric-tile-desc">Drafts / Closed</div>
            </div>

            <!-- Applications -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-purple">
                    <i class="fa-solid fa-user-group"></i>
                </div>
                <div class="metric-tile-number"><%= TotalApplicationsCount %></div>
                <div class="metric-tile-desc">Applications</div>
            </div>

            <!-- Active Rate -->
            <div class="manage-metric-tile">
                <div class="metric-tile-icon-box c-red">
                    <i class="fa-solid fa-chart-line"></i>
                </div>
                <div class="metric-tile-number"><%= TotalInternshipsCount > 0 ? (int)((double)ActiveInternshipsCount / TotalInternshipsCount * 100) : 100 %>%</div>
                <div class="metric-tile-desc">Active Rate</div>
            </div>
        </div>

        <!-- Manage Internships Main Table Section -->
        <div class="manage-jobs-table-card">
            
            <!-- Filter Bar -->
            <div class="table-filter-bar">
                <div class="table-search-input-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="Search internships..." />
                </div>
            </div>

            <!-- Data Table -->
            <div class="table-responsive-box" style="overflow-x: auto;">
                <table class="jobs-data-table">
                    <thead>
                        <tr>
                            <th>Intern Title</th>
                            <th>Location</th>
                            <th>Duration</th>
                            <th>Stipend</th>
                            <th>Applications</th>
                            <th>Posted Date</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptInternships" runat="server" OnItemCommand="rptInternships_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <a href='<%# ResolveUrl("~/Company/Applicants.aspx") %>' class="job-table-title-link" style="font-weight:600;">
                                            <%# Eval("Title") %>
                                        </a>
                                    </td>
                                    <td><%# Eval("Location") %></td>
                                    <td><%# Eval("Duration") %></td>
                                    <td><%# Eval("Stipend") %></td>
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
                                        <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("InternshipId") %>' ToolTip="Toggle Status" style="color:#64748b; margin-right:8px;">
                                            <i class="fa-solid fa-power-off"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteInternship" CommandArgument='<%# Eval("InternshipId") %>' OnClientClick="return confirm('Delete this internship?');" ToolTip="Delete Internship" style="color:#ef4444;">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <% if (TotalInternshipsCount == 0) { %>
                <div style="padding:32px 16px; text-align:center; color:#64748b;">
                    <i class="fa-solid fa-graduation-cap" style="font-size:32px; color:#cbd5e1; margin-bottom:8px; display:block;"></i>
                    <h4 style="font-size:15px; font-weight:600; color:#334155; margin-bottom:4px;">No Internships Posted Yet</h4>
                    <p style="font-size:13px; margin:0 0 12px;">Create an internship opportunity to start receiving candidate applications.</p>
                    <a href="<%= ResolveUrl("~/Company/PostJob.aspx?type=internship") %>" class="btn-post-new-job-blue" style="display:inline-block;">Post New Internship</a>
                </div>
            <% } %>

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
