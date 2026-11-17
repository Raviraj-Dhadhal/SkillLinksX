<%@ Page Title="Company Settings - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="SkillLinksX.Company.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Company Settings Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="company-settings-container">

        <!-- Top Header Row -->
        <div class="company-settings-header">
            <h1 class="settings-page-title">Company Settings</h1>
            <p class="settings-page-sub">Manage your company account, preferences, security, and recruitment settings.</p>
        </div>

        <!-- 2-Column Settings Layout: Left Nav + Right Content Cards -->
        <div class="settings-layout-grid">

            <!-- Left Navigation Menu (Company Information, Team Members, Notifications, Delete Account) -->
            <aside class="settings-nav-card">
                <ul class="settings-nav-list">
                    <li class="settings-nav-item active">
                        <a href="javascript:void(0);" class="settings-nav-link" onclick="showSettingsTab('company-info-tab', this)">
                            <span class="nav-active-bar"></span>
                            Company Information
                        </a>
                    </li>
                    <li class="settings-nav-item">
                        <a href="javascript:void(0);" class="settings-nav-link" onclick="showSettingsTab('team-members-tab', this)">
                            Team Members
                        </a>
                    </li>
                    <li class="settings-nav-item">
                        <a href="<%= ResolveUrl("~/Company/Notifications.aspx") %>" class="settings-nav-link">
                            Notifications
                        </a>
                    </li>
                    <li class="settings-nav-item danger-item">
                        <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="settings-nav-link text-danger" onclick="return confirm('Are you sure you want to delete your account? This action cannot be undone.');">
                            Delete Account
                        </a>
                    </li>
                </ul>
            </aside>

            <!-- Right Content Sections Column -->
            <div class="settings-content-column">

                <!-- 1. Company Profile / Information Card -->
                <div class="settings-section-card" id="sectionCompanyInfo">
                    <div class="settings-card-header">
                        <h2 class="settings-card-title">Company Profile</h2>
                    </div>
                    <div class="settings-card-body">
                        <asp:Label ID="lblSettingsStatus" runat="server" style="display:block; margin-bottom:12px; font-size:14px; font-weight:600;" EnableViewState="false" />

                        <!-- Form 2x2 fields -->
                        <div class="settings-form-grid">
                            <!-- Company Name -->
                            <div class="settings-form-group">
                                <label class="settings-label">Company Name</label>
                                <asp:TextBox ID="txtCompanyName" runat="server" CssClass="settings-input" />
                            </div>

                            <!-- Industry -->
                            <div class="settings-form-group">
                                <label class="settings-label">Industry</label>
                                <div class="settings-select-wrapper">
                                    <asp:DropDownList ID="ddlIndustry" runat="server" CssClass="settings-select">
                                        <asp:ListItem Text="Information Technology" Value="Information Technology" />
                                        <asp:ListItem Text="Software Development" Value="Software Development" />
                                        <asp:ListItem Text="Finance & Banking" Value="Finance & Banking" />
                                        <asp:ListItem Text="Healthcare & Biotech" Value="Healthcare & Biotech" />
                                        <asp:ListItem Text="E-Commerce" Value="E-Commerce" />
                                        <asp:ListItem Text="Manufacturing" Value="Manufacturing" />
                                        <asp:ListItem Text="Consulting & Services" Value="Consulting & Services" />
                                    </asp:DropDownList>
                                    <i class="fa-solid fa-chevron-down select-chevron"></i>
                                </div>
                            </div>

                            <!-- Company Size -->
                            <div class="settings-form-group">
                                <label class="settings-label">Company Size</label>
                                <div class="settings-select-wrapper">
                                    <asp:DropDownList ID="ddlCompanySize" runat="server" CssClass="settings-select">
                                        <asp:ListItem Text="1-10 employees" Value="1-10 employees" />
                                        <asp:ListItem Text="11-50 employees" Value="11-50 employees" />
                                        <asp:ListItem Text="51-200 employees" Value="51-200 employees" />
                                        <asp:ListItem Text="201-500 employees" Value="201-500 employees" />
                                        <asp:ListItem Text="500+ employees" Value="500+ employees" />
                                    </asp:DropDownList>
                                    <i class="fa-solid fa-chevron-down select-chevron"></i>
                                </div>
                            </div>

                            <!-- Website -->
                            <div class="settings-form-group">
                                <label class="settings-label">Website</label>
                                <asp:TextBox ID="txtWebsite" runat="server" CssClass="settings-input" />
                            </div>

                            <!-- Location -->
                            <div class="settings-form-group">
                                <label class="settings-label">Location / Address</label>
                                <asp:TextBox ID="txtLocation" runat="server" CssClass="settings-input" />
                            </div>

                            <!-- Contact Email -->
                            <div class="settings-form-group">
                                <label class="settings-label">Contact Email</label>
                                <asp:TextBox ID="txtContactEmail" runat="server" CssClass="settings-input" TextMode="Email" />
                            </div>

                            <!-- Company Description -->
                            <div class="settings-form-group" style="grid-column: 1 / -1;">
                                <label class="settings-label">About Company</label>
                                <asp:TextBox ID="txtCompanyDesc" runat="server" CssClass="settings-input" TextMode="MultiLine" Rows="3" style="resize:vertical;" />
                            </div>
                        </div>

                        <!-- Save Changes Button Row -->
                        <div class="settings-actions-row">
                            <asp:Button ID="btnSaveSettings" runat="server" Text="Save Changes" CssClass="btn-save-settings" OnClick="btnSaveSettings_Click" />
                        </div>
                    </div>
                </div>

                <!-- 2. Team Members Card -->
                <div class="settings-section-card" id="sectionTeamMembers">
                    <div class="settings-card-header flex-between">
                        <h2 class="settings-card-title">Team Members</h2>
                    </div>
                    <div class="settings-card-body p-0">
                        <% if (IsTechNova) { %>
                            <div class="team-table-scroll-wrapper">
                                <table class="team-members-table">
                                    <thead>
                                        <tr>
                                            <th>USER</th>
                                            <th>ROLE</th>
                                            <th>STATUS</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div class="team-user-cell">
                                                    <div class="member-avatar bg-blue-dark">AK</div>
                                                    <div class="member-info">
                                                        <div class="member-name">Arjun Kapoor</div>
                                                        <div class="member-email">arjun@technova.in</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="member-role-text">Company Admin</span></td>
                                            <td><span class="badge-status-active">Active</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="team-user-cell">
                                                    <div class="member-avatar bg-blue-light">P</div>
                                                    <div class="member-info">
                                                        <div class="member-name">Priya Sharma</div>
                                                        <div class="member-email">priya@technova.in</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="member-role-text">Senior Recruiter</span></td>
                                            <td><span class="badge-status-active">Active</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div style="padding:28px 16px; text-align:center; color:#64748b; background:#f8fafc;">
                                <i class="fa-solid fa-users" style="font-size:28px; color:#94a3b8; margin-bottom:8px; display:block;"></i>
                                <h4 style="font-size:14px; font-weight:600; color:#334155; margin-bottom:4px;">No Additional Members</h4>
                                <p style="font-size:13px; margin:0;">You are currently the primary administrator for this company workspace.</p>
                            </div>
                        <% } %>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
