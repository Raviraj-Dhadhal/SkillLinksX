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

                        <!-- Company Logo Section -->
                        <div class="settings-logo-section" style="padding-bottom:20px; margin-bottom:20px; border-bottom:1px solid #e2e8f0; display:flex; align-items:center; gap:24px; flex-wrap:wrap;">
                            <div class="settings-logo-preview" style="width:84px; height:84px; border-radius:12px; background:#eff6ff; display:flex; align-items:center; justify-content:center; color:#2563eb; font-weight:800; font-size:32px; border:2px solid #bfdbfe; overflow:hidden; flex-shrink:0;">
                                <% if (!string.IsNullOrEmpty(CompanyLogoUrl)) { %>
                                    <img src="<%= ResolveUrl(CompanyLogoUrl) %>" alt="Company Logo" style="width:100%; height:100%; object-fit:cover;" />
                                <% } else { %>
                                    <i class="fa-solid fa-building" style="font-size:36px; color:#94a3b8;"></i>
                                <% } %>
                            </div>
                            <div style="flex:1; min-width:240px;">
                                <h3 style="margin:0 0 4px; font-size:15px; font-weight:700; color:#0f172a;">Company Logo / Profile Picture</h3>
                                <p style="margin:0 0 10px; font-size:12.5px; color:#64748b;">Upload your official company logo. If no logo is uploaded, a default building icon is shown.</p>
                                <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                    <asp:FileUpload ID="fileCompanyLogo" runat="server" accept=".jpg,.jpeg,.png" style="font-size:12px; max-width:240px;" />
                                    <asp:Button ID="btnUploadLogo" runat="server" Text="Upload Logo" CssClass="btn-save" style="padding:6px 14px; font-size:12px; height:auto; cursor:pointer;" OnClick="btnUploadLogo_Click" />
                                    <% if (!string.IsNullOrEmpty(CompanyLogoUrl)) { %>
                                        <asp:Button ID="btnRemoveLogo" runat="server" Text="Remove Logo" CssClass="btn-cancel" style="padding:6px 14px; font-size:12px; height:auto; color:#ef4444; border-color:#fca5a5; cursor:pointer;" OnClick="btnRemoveLogo_Click" />
                                    <% } %>
                                </div>
                                <asp:Label ID="lblLogoStatus" runat="server" style="display:block; margin-top:6px; font-size:12.5px; font-weight:600;" EnableViewState="false" />
                            </div>
                        </div>

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
                        <div>
                            <h2 class="settings-card-title">Team Members</h2>
                            <p style="font-size:12.5px; color:#64748B; margin:4px 0 0 0;">Candidates you select/hire automatically join your company team roster.</p>
                        </div>
                    </div>
                    <asp:Label ID="lblTeamActionMsg" runat="server" EnableViewState="false" style="margin:8px 16px; display:block; font-size:13px;" />
                    <div class="settings-card-body p-0">
                        <div class="team-table-scroll-wrapper" style="overflow-x:auto;">
                            <table class="team-members-table">
                                <thead>
                                    <tr>
                                        <th>USER</th>
                                        <th>ROLE</th>
                                        <th>STATUS</th>
                                        <th style="text-align:right;">ACTION</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptTeamMembers" runat="server" OnItemCommand="rptTeamMembers_ItemCommand">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div class="team-user-cell">
                                                        <div class="member-avatar" style="background:#f1f5f9; color:#64748b; font-size:16px; border:1px solid #cbd5e1; overflow:hidden; display:inline-flex; align-items:center; justify-content:center;">
                                                            <%# (Eval("ProfilePhoto") != null && !string.IsNullOrEmpty(Eval("ProfilePhoto").ToString())) 
                                                                ? "<img src='" + ResolveUrl(Eval("ProfilePhoto").ToString()) + "' style='width:100%; height:100%; border-radius:50%; object-fit:cover;' />" 
                                                                : "<i class=\"fa-regular fa-user\"></i>" %>
                                                        </div>
                                                        <div class="member-info">
                                                            <div class="member-name"><%# Eval("FullName") %></div>
                                                            <div class="member-email"><%# Eval("Email") %></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><span class="member-role-text"><%# Eval("RoleName") %></span></td>
                                                <td><span class="badge-status-active"><%# Eval("Status") %></span></td>
                                                <td style="text-align:right;">
                                                    <asp:LinkButton ID="btnReleaseMember" runat="server" CommandName="ReleaseMember" 
                                                        CommandArgument='<%# Eval("ApplicationId") %>' 
                                                        Visible='<%# Convert.ToInt32(Eval("ApplicationId")) > 0 %>' 
                                                        OnClientClick="return confirm('Release this employee from your company team? They will be able to apply for other jobs.');" 
                                                        style='padding:5px 10px; border-radius:6px; font-size:12px; font-weight:600; background:#FEE2E2; color:#DC2626; border:1px solid #FCA5A5; text-decoration:none; display:inline-flex; align-items:center; gap:4px;'>
                                                        <i class='fa-solid fa-user-minus'></i> Release
                                                    </asp:LinkButton>
                                                    <asp:Label ID="lblOwner" runat="server" 
                                                        Visible='<%# Convert.ToInt32(Eval("ApplicationId")) == 0 %>' 
                                                        Text="Account Owner" 
                                                        style='font-size:11.5px; color:#64748B; font-weight:600;' />
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Panel ID="pnlNoMembers" runat="server" Visible='<%# rptTeamMembers.Items.Count == 0 %>' style="padding:24px; text-align:center; color:#64748b;">
                                                <p style="margin:0; font-size:13px;">No active team members.</p>
                                            </asp:Panel>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
