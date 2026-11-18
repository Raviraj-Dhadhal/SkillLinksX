<%@ Page Title="Saved Opportunities - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="SavedOpportunities.aspx.cs" Inherits="SkillLinksX.User.SavedOpportunities" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Saved Opportunities Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-saved-page-container">

        <!-- Page Header -->
        <div class="saved-page-header">
            <h1 class="saved-page-title">Saved Opportunities</h1>
            <p class="saved-page-sub">Keep track of jobs and internships you want to apply for.</p>
        </div>

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Calculated via OOP Collection in code-behind
             ========================================================================= -->
        <div class="saved-metrics-grid">
            <div class="saved-metric-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label">Total Saved</span>
                    <i class="fa-regular fa-bookmark saved-metric-icon"></i>
                </div>
                <span class="saved-metric-val"><%= TotalSavedCount %></span>
            </div>

            <div class="saved-metric-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label">Saved Jobs</span>
                    <i class="fa-solid fa-briefcase saved-metric-icon"></i>
                </div>
                <span class="saved-metric-val"><%= SavedJobsCount %></span>
            </div>

            <div class="saved-metric-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label">Saved Internships</span>
                    <i class="fa-solid fa-graduation-cap saved-metric-icon"></i>
                </div>
                <span class="saved-metric-val"><%= SavedInternshipsCount %></span>
            </div>

            <div class="saved-metric-tile danger-tile">
                <div class="saved-metric-top">
                    <span class="saved-metric-label" style="color: #059669 !important;">Active</span>
                    <i class="fa-solid fa-check-circle saved-metric-icon" style="color: #059669 !important;"></i>
                </div>
                <span class="saved-metric-val" style="color: #059669 !important;"><%= TotalSavedCount %></span>
            </div>
        </div>

        <!-- Main Workspace: Left Listings + Right Closing Soon -->
        <div class="saved-layout-grid">

            <!-- Left Main Column -->
            <div class="saved-main-column">

                <!-- Filter Tabs: All, Jobs, Internships -->
                <div class="saved-filter-tabs">
                    <button type="button" class="saved-tab-btn active" onclick="filterCategory('all', this);">All</button>
                    <button type="button" class="saved-tab-btn" onclick="filterCategory('job', this);">Jobs</button>
                    <button type="button" class="saved-tab-btn" onclick="filterCategory('internship', this);">Internships</button>
                </div>

                <!-- =================================================================
                     [SAVED OPPORTUNITIES REPEATER]: Dynamically loaded from database
                     ================================================================= -->
                <div class="saved-cards-stack">
                    <asp:Repeater ID="rptSavedList" runat="server" OnItemCommand="rptSavedList_ItemCommand">
                        <ItemTemplate>
                            <div class="saved-opp-card" data-category='<%# Eval("Category") %>'>
                                <div class="saved-card-top flex-between">
                                    <div class="saved-brand-info-flex">
                                        <div class="saved-company-avatar">
                                            <i class="fa-solid fa-building" style="font-size:22px; color:#2563eb;"></i>
                                        </div>
                                        <div class="saved-role-meta">
                                            <h3 class="saved-role-title"><%# Eval("Title") %></h3>
                                            <div class="saved-company-name"><%# Eval("CompanyName") %></div>
                                        </div>
                                    </div>
                                    <asp:LinkButton ID="btnRemove" runat="server" CommandName="Remove" CommandArgument='<%# Eval("SavedId") %>' CssClass="btn-saved-bookmark active" ToolTip="Remove from Saved">
                                        <i class="fa-solid fa-bookmark"></i>
                                    </asp:LinkButton>
                                </div>

                                <div class="saved-meta-specs-row">
                                    <span><i class="fa-solid fa-location-dot"></i> <%# Eval("Location") %></span>
                                    <span><i class="fa-solid fa-laptop-code"></i> <%# Eval("JobType") %></span>
                                    <span><i class="fa-solid fa-indian-rupee-sign"></i> <%# Eval("CompensationDisplay") %></span>
                                </div>

                                <div class="saved-bottom-actions flex-between" style="margin-top: 14px;">
                                    <span style="font-size:12px; color:#64748b;">Saved <%# Eval("SavedTime") %></span>
                                    <a href='<%# ResolveUrl("~/User/JobDetails.aspx?id=" + Eval("JobId")) %>' class="btn-saved-apply">Apply Now</a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <!-- Clean Empty State when user has no saved opportunities -->
                    <% if (TotalSavedCount == 0) { %>
                    <div style="padding:48px 20px; text-align:center; color:#64748b; background:#f8fafc; border:1px dashed #cbd5e1; border-radius:12px;">
                        <i class="fa-regular fa-bookmark" style="font-size:36px; color:#94a3b8; margin-bottom:12px; display:block;"></i>
                        <h4 style="font-size:16px; font-weight:700; color:#1e293b; margin-bottom:6px;">No saved opportunities yet</h4>
                        <p style="font-size:13px; color:#64748b; margin:0 0 16px;">You haven't bookmarked any opportunities yet. Explore jobs and internships to save the ones you are interested in.</p>
                        <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" style="display:inline-block; padding:9px 22px; background:#2563eb; color:#fff; border-radius:6px; font-size:13.5px; font-weight:600; text-decoration:none;">Browse Opportunities</a>
                    </div>
                    <% } %>
                </div>

            </div>

            <!-- Right Sidebar: Closing Soon Panel (Dynamic) -->
            <aside class="saved-sidebar-column">
                <div class="closing-soon-card">
                    <div class="closing-card-header">
                        <i class="fa-regular fa-clock color-red"></i>
                        <h3 class="closing-card-title">Closing Soon</h3>
                    </div>

                    <div class="closing-list-stack">
                        <asp:Repeater ID="rptClosingSoon" runat="server">
                            <ItemTemplate>
                                <div class="closing-item-box">
                                    <div class="closing-item-top flex-between">
                                        <div class="closing-brand-wrap">
                                            <div class="closing-company-avatar" style="width:36px; height:36px; border-radius:8px; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#2563eb; margin-right:10px;">
                                                <i class="fa-solid fa-building" style="font-size:16px;"></i>
                                            </div>
                                            <div class="closing-meta">
                                                <h4 class="closing-role-name"><%# Eval("Title") %></h4>
                                                <div class="closing-company-name"><%# Eval("CompanyName") %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="closing-footer-row flex-between">
                                        <span class="closing-timer color-red">
                                            <i class="fa-regular fa-clock"></i> <%# Eval("DaysLeft") %>
                                        </span>
                                        <a href='<%# ResolveUrl("~/User/JobDetails.aspx?id=" + Eval("JobId")) %>' class="btn-closing-apply">Apply</a>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <% if (rptClosingSoon.Items.Count == 0) { %>
                        <div style="padding: 20px; text-align: center; color: #94a3b8; font-size: 13px;">
                            No urgent deadlines right now.
                        </div>
                        <% } %>
                    </div>

                    <div class="closing-card-footer">
                        <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="closing-view-all-link">View all opportunities</a>
                    </div>
                </div>
            </aside>

        </div>

    </div>

    <script type="text/javascript">
        function filterCategory(cat, btn) {
            document.querySelectorAll('.saved-tab-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');

            const cards = document.querySelectorAll('.saved-opp-card');
            cards.forEach(c => {
                const cardCat = c.getAttribute('data-category');
                if (cat === 'all' || cardCat === cat) {
                    c.style.display = 'block';
                } else {
                    c.style.display = 'none';
                }
            });
        }
    </script>
</asp:Content>
