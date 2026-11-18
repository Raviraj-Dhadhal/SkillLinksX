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
                    <input type="text" id="txtInternshipSearch" placeholder="Search internships..." oninput="applyInternshipsFilter();" />
                </div>
                <select id="ddlInternshipStatusFilter" class="table-filter-select" onchange="applyInternshipsFilter();">
                    <option value="">Status</option>
                    <option value="Active">Active</option>
                    <option value="Draft">Draft</option>
                    <option value="Closed">Closed</option>
                </select>
                <select id="ddlInternshipLocFilter" class="table-filter-select" onchange="applyInternshipsFilter();">
                    <option value="">Work Mode / Location</option>
                    <option value="Remote">Remote</option>
                    <option value="Hybrid">Hybrid</option>
                    <option value="On-site">On-site</option>
                </select>
                <button type="button" onclick="clearInternshipsFilter();" style="padding:6px 12px; background:#F1F5F9; border:1px solid #CBD5E1; border-radius:6px; font-size:12px; font-weight:600; color:#475569; cursor:pointer;" title="Reset Filters">
                    <i class="fa-solid fa-arrows-rotate"></i> Reset
                </button>
            </div>

            <asp:Label ID="lblActionMessage" runat="server" style="display:block; margin:8px 12px; font-size:13px; font-weight:600;" EnableViewState="false" />

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
                                <tr class="intern-data-row"
                                    data-title='<%# Eval("Title").ToString().ToLower() %>'
                                    data-location='<%# Eval("Location").ToString().ToLower() %>'
                                    data-status='<%# Eval("Status").ToString().ToLower() %>'>
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
                        <tr id="rowNoMatchingInternships" style="display:none;">
                            <td colspan="8" style="text-align:center; padding:32px 16px; color:#64748B;">
                                <i class="fa-solid fa-filter" style="font-size:24px; color:#CBD5E1; margin-bottom:8px; display:block;"></i>
                                <div style="font-weight:600; color:#334155; margin-bottom:4px;">No Internships Match Your Filter</div>
                                <div style="font-size:12px;">Try adjusting your search query, status, or location filter.</div>
                            </td>
                        </tr>
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
                    <select id="ddlInternPageSize" class="pagination-rows-select" onchange="onInternPageSizeChange(this.value);">
                        <option value="10" selected="selected">10</option>
                        <option value="25">25</option>
                        <option value="50">50</option>
                    </select>
                </div>
                <div class="pagination-controls">
                    <span id="lblInternPagination"><%= TotalInternshipsCount > 0 ? $"1-{Math.Min(10, TotalInternshipsCount)} of {TotalInternshipsCount}" : "0 of 0" %></span>
                    <button type="button" id="btnInternPrev" class="pagination-nav-btn" aria-label="Previous Page" onclick="changeInternPage(-1);" <%= TotalInternshipsCount <= 10 ? "disabled" : "" %>>
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <button type="button" id="btnInternNext" class="pagination-nav-btn" aria-label="Next Page" onclick="changeInternPage(1);" <%= TotalInternshipsCount <= 10 ? "disabled" : "" %>>
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>
            </div>

        </div>

    </div>

    <!-- Dynamic Pagination & Filtering Script -->
    <script type="text/javascript">
        var internCurrentPage = 1;
        var internPageSize = 10;
        var matchingInternRows = [];

        function getAllInternRows() {
            var table = document.querySelector(".jobs-data-table tbody");
            if (!table) return [];
            return Array.from(table.querySelectorAll("tr.intern-data-row"));
        }

        function applyInternshipsFilter() {
            var q = (document.getElementById("txtInternshipSearch")?.value || "").trim().toLowerCase();
            var statusFilter = (document.getElementById("ddlInternshipStatusFilter")?.value || "").trim().toLowerCase();
            var locFilter = (document.getElementById("ddlInternshipLocFilter")?.value || "").trim().toLowerCase();

            var allRows = getAllInternRows();
            matchingInternRows = [];

            allRows.forEach(function (row) {
                var title = row.getAttribute("data-title") || "";
                var loc = row.getAttribute("data-location") || "";
                var stat = row.getAttribute("data-status") || "";
                var fullText = (row.innerText || "").toLowerCase();

                var matchSearch = !q || fullText.indexOf(q) !== -1 || title.indexOf(q) !== -1 || loc.indexOf(q) !== -1;
                var matchStatus = !statusFilter || stat === statusFilter || (statusFilter === "closed" && stat !== "active" && stat !== "draft");
                var matchLoc = !locFilter || loc.indexOf(locFilter) !== -1;

                if (matchSearch && matchStatus && matchLoc) {
                    matchingInternRows.push(row);
                } else {
                    row.style.display = "none";
                }
            });

            var noMatchRow = document.getElementById("rowNoMatchingInternships");
            if (noMatchRow) {
                noMatchRow.style.display = (allRows.length > 0 && matchingInternRows.length === 0) ? "" : "none";
            }

            internCurrentPage = 1;
            renderInternPagination();
        }

        function clearInternshipsFilter() {
            var s = document.getElementById("txtInternshipSearch");
            if (s) s.value = "";
            var st = document.getElementById("ddlInternshipStatusFilter");
            if (st) st.value = "";
            var l = document.getElementById("ddlInternshipLocFilter");
            if (l) l.value = "";

            applyInternshipsFilter();
        }

        function renderInternPagination() {
            var total = matchingInternRows.length;
            var totalPages = Math.ceil(total / internPageSize) || 1;

            if (internCurrentPage < 1) internCurrentPage = 1;
            if (internCurrentPage > totalPages) internCurrentPage = totalPages;

            var start = (internCurrentPage - 1) * internPageSize;
            var end = Math.min(start + internPageSize, total);

            matchingInternRows.forEach(function (row, idx) {
                if (idx >= start && idx < end) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });

            var lbl = document.getElementById("lblInternPagination");
            if (lbl) {
                if (total === 0) {
                    lbl.innerText = "0 of 0";
                } else {
                    lbl.innerText = (start + 1) + "-" + end + " of " + total;
                }
            }

            var btnPrev = document.getElementById("btnInternPrev");
            var btnNext = document.getElementById("btnInternNext");

            if (btnPrev) {
                btnPrev.disabled = (internCurrentPage <= 1);
                if (btnPrev.disabled) btnPrev.classList.add("disabled");
                else btnPrev.classList.remove("disabled");
            }
            if (btnNext) {
                btnNext.disabled = (internCurrentPage >= totalPages || total === 0);
                if (btnNext.disabled) btnNext.classList.add("disabled");
                else btnNext.classList.remove("disabled");
            }
        }

        function changeInternPage(delta) {
            internCurrentPage += delta;
            renderInternPagination();
        }

        function onInternPageSizeChange(val) {
            internPageSize = parseInt(val, 10) || 10;
            internCurrentPage = 1;
            renderInternPagination();
        }

        document.addEventListener("DOMContentLoaded", function () {
            matchingInternRows = getAllInternRows();
            applyInternshipsFilter();
        });
    </script>
</asp:Content>
