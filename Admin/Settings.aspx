<%@ Page Title="Admin Settings - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="SkillLinksX.Admin.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Portal Styles -->
    <link href="<%= ResolveUrl("~/assets/CSS/admin-pages.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-settings-page-container">
        
        <!-- Header -->
        <div class="admin-greeting-header">
            <h1 class="admin-greeting-title">Admin Settings</h1>
            <p class="admin-greeting-sub">Manage platform configuration, security, notifications and administrative preferences.</p>
        </div>

        <!-- 2-Column Layout: Left Navigation Tabs & Right Settings Panes -->
        <div class="admin-settings-layout">
            
            <!-- Left Settings Navigation -->
            <div class="admin-settings-nav">
                <a href="#general-section" class="settings-nav-item active">
                    <span>General</span>
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
                <a href="#platform-section" class="settings-nav-item">
                    <span>Platform Settings</span>
                </a>
                <a href="#user-section" class="settings-nav-item">
                    <span>User Management</span>
                </a>
                <a href="#security-section" class="settings-nav-item">
                    <span>Security</span>
                </a>
                <a href="#danger-section" class="settings-nav-item danger">
                    <span><i class="fa-solid fa-triangle-exclamation"></i> Danger Zone</span>
                </a>
            </div>

            <!-- Right Settings Cards Stack -->
            <div class="admin-settings-content">
                
                <!-- 1. General Settings Card -->
                <div class="admin-settings-card" id="general-section">
                    <div class="settings-card-header">
                        <div class="settings-card-icon icon-blue">
                            <i class="fa-solid fa-sliders"></i>
                        </div>
                        <div>
                            <h2 class="settings-card-title">General Settings</h2>
                            <p class="settings-card-desc">Core platform information and localization</p>
                        </div>
                    </div>

                    <div class="settings-form-grid">
                        <div class="admin-form-group">
                            <label class="admin-input-label">Platform Name</label>
                            <asp:TextBox ID="txtPlatformName" runat="server" CssClass="admin-profile-input" Text="SkillLinkX" />
                        </div>
                        <div class="admin-form-group">
                            <label class="admin-input-label">Platform Email</label>
                            <asp:TextBox ID="txtPlatformEmail" runat="server" CssClass="admin-profile-input" Text="admin@skilllinkx.com" />
                        </div>
                        <div class="admin-form-group">
                            <label class="admin-input-label">Support Email</label>
                            <asp:TextBox ID="txtSupportEmail" runat="server" CssClass="admin-profile-input" Text="support@skilllinkx.com" />
                        </div>
                        <div class="admin-form-group">
                            <label class="admin-input-label">Support Phone</label>
                            <asp:TextBox ID="txtSupportPhone" runat="server" CssClass="admin-profile-input" Text="+91 98765 43210" />
                        </div>
                    </div>

                    <div class="settings-section-divider-title">LOCALIZATION</div>

                    <div class="settings-form-grid">
                        <div class="admin-form-group">
                            <label class="admin-input-label">Default Country</label>
                            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="admin-filter-select">
                                <asp:ListItem Text="India" Value="India" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="United States" Value="United States"></asp:ListItem>
                                <asp:ListItem Text="United Kingdom" Value="United Kingdom"></asp:ListItem>
                                <asp:ListItem Text="Canada" Value="Canada"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="admin-form-group">
                            <label class="admin-input-label">Default City</label>
                            <asp:TextBox ID="txtDefaultCity" runat="server" CssClass="admin-profile-input" Text="Ahmedabad" />
                        </div>
                        <div class="admin-form-group">
                            <label class="admin-input-label">Time Zone</label>
                            <asp:DropDownList ID="ddlTimeZone" runat="server" CssClass="admin-filter-select">
                                <asp:ListItem Text="IST (UTC +5:30)" Value="IST" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="EST (UTC -5:00)" Value="EST"></asp:ListItem>
                                <asp:ListItem Text="PST (UTC -8:00)" Value="PST"></asp:ListItem>
                                <asp:ListItem Text="GMT (UTC +0:00)" Value="GMT"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="admin-form-group">
                            <label class="admin-input-label">Date Format</label>
                            <asp:DropDownList ID="ddlDateFormat" runat="server" CssClass="admin-filter-select">
                                <asp:ListItem Text="DD/MM/YYYY" Value="DD/MM/YYYY" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="MM/DD/YYYY" Value="MM/DD/YYYY"></asp:ListItem>
                                <asp:ListItem Text="YYYY-MM-DD" Value="YYYY-MM-DD"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="settings-card-footer" style="display:flex; justify-content:space-between; align-items:center;">
                        <asp:Label ID="lblGeneralFeedback" runat="server" Font-Bold="true" Font-Size="Small"></asp:Label>
                        <asp:Button ID="btnSaveGeneral" runat="server" CssClass="btn-save-settings" Text="Save Changes" OnClick="btnSaveGeneral_Click" />
                    </div>
                </div>

                <!-- 2. Platform Settings Card -->
                <div class="admin-settings-card" id="platform-section">
                    <div class="settings-card-header">
                        <div class="settings-card-icon icon-blue">
                            <i class="fa-regular fa-window-restore"></i>
                        </div>
                        <div>
                            <h2 class="settings-card-title">Platform Settings</h2>
                            <p class="settings-card-desc">Global feature toggles and operational modes</p>
                        </div>
                    </div>

                    <div class="settings-toggle-list">
                        <!-- Item 1 -->
                        <div class="settings-toggle-row">
                            <div class="toggle-row-info">
                                <div class="toggle-row-title">New User/Company Registration</div>
                                <div class="toggle-row-desc">Allow new accounts to be created on the platform</div>
                            </div>
                            <label class="switch-toggle">
                                <asp:CheckBox ID="chkAllowRegistration" runat="server" Checked="true" />
                                <span class="switch-slider"></span>
                            </label>
                        </div>

                        <!-- Item 2 -->
                        <div class="settings-toggle-row">
                            <div class="toggle-row-info">
                                <div class="toggle-row-title">Email &amp; Company Verification</div>
                                <div class="toggle-row-desc">Require email verification before account activation</div>
                            </div>
                            <label class="switch-toggle">
                                <asp:CheckBox ID="chkRequireVerification" runat="server" Checked="true" />
                                <span class="switch-slider"></span>
                            </label>
                        </div>

                        <!-- Item 3 -->
                        <div class="settings-toggle-row">
                            <div class="toggle-row-info">
                                <div class="toggle-row-title">Job &amp; Internship Posting</div>
                                <div class="toggle-row-desc">Allow verified companies to post new listings</div>
                            </div>
                            <label class="switch-toggle">
                                <asp:CheckBox ID="chkAllowJobPosting" runat="server" Checked="true" />
                                <span class="switch-slider"></span>
                            </label>
                        </div>

                        <!-- Item 4 -->
                        <div class="settings-toggle-row">
                            <div class="toggle-row-info">
                                <div class="toggle-row-title">AI Matching Features <span class="badge-beta-pill">BETA</span></div>
                                <div class="toggle-row-desc">Enable AI-driven candidate recommendations</div>
                            </div>
                            <label class="switch-toggle">
                                <asp:CheckBox ID="chkAIMatching" runat="server" Checked="true" />
                                <span class="switch-slider"></span>
                            </label>
                        </div>

                        <!-- Item 5 -->
                        <div class="settings-toggle-row">
                            <div class="toggle-row-info">
                                <div class="toggle-row-title">AI Career Assistant <span class="badge-beta-pill">BETA</span></div>
                                <div class="toggle-row-desc">Enable generative AI chat for candidates</div>
                            </div>
                            <label class="switch-toggle">
                                <asp:CheckBox ID="chkAIAssistant" runat="server" Checked="true" />
                                <span class="switch-slider"></span>
                            </label>
                        </div>
                    </div>

                    <div class="settings-card-footer" style="display:flex; justify-content:space-between; align-items:center; margin-top:20px;">
                        <asp:Label ID="lblPlatformFeedback" runat="server" Font-Bold="true" Font-Size="Small"></asp:Label>
                        <asp:Button ID="btnSavePlatformSettings" runat="server" CssClass="btn-save-settings" Text="Save Toggles" OnClick="btnSavePlatformSettings_Click" />
                    </div>
                </div>

                <!-- 3. User Management Card -->
                <div class="admin-settings-card" id="user-section">
                    <div class="settings-card-header">
                        <div class="settings-card-icon icon-indigo">
                            <i class="fa-solid fa-users-gear"></i>
                        </div>
                        <div>
                            <h2 class="settings-card-title">User Management</h2>
                            <p class="settings-card-desc">Settings for candidates and normal users</p>
                        </div>
                    </div>

                    <p class="settings-muted-note">
                        User Approval, Profile visibility, File size limits (5MB/10MB) configured here.
                    </p>
                </div>

                <!-- 4. Security Card -->
                <div class="admin-settings-card" id="security-section">
                    <div class="settings-card-header">
                        <div class="settings-card-icon icon-blue">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <div>
                            <h2 class="settings-card-title">Security</h2>
                            <p class="settings-card-desc">Authentication and session management</p>
                        </div>
                    </div>

                    <p class="settings-security-summary">
                        2FA: ON | Timeout: 30 min | Max attempts: 5 | Password expiry: 90 days
                    </p>

                    <div>
                        <button type="button" class="btn-manage-sessions" onclick="alert('Managing active user sessions.');">
                            Manage Sessions
                        </button>
                    </div>
                </div>

                <!-- 5. Danger Zone Card -->
                <div class="admin-danger-zone-box" id="danger-section">
                    <div class="danger-zone-header">
                        <i class="fa-solid fa-triangle-exclamation"></i> Danger Zone
                    </div>
                    <p class="danger-zone-warning">
                        Irreversible administrative actions. Proceed with caution.
                    </p>

                    <div class="danger-zone-card-item">
                        <div>
                            <div class="danger-item-title">Reset Platform Settings</div>
                            <div class="danger-item-desc">Restore all configuration settings to factory defaults. This does not delete user data.</div>
                        </div>
                        <button type="button" class="btn-danger-outline" onclick="if(confirm('Are you sure you want to reset all platform settings?')) alert('Settings reset.');">
                            Reset Settings
                        </button>
                    </div>

                    <div class="danger-zone-card-item">
                        <div>
                            <div class="danger-item-title danger-red">Delete All Data</div>
                            <div class="danger-item-desc">Permanently delete all users, companies, jobs, and applications. This action cannot be undone.</div>
                        </div>
                        <button type="button" class="btn-danger-solid" onclick="if(confirm('WARNING: Are you absolutely sure you want to delete ALL data?')) alert('Operation cancelled for safety.');">
                            Delete Platform Data
                        </button>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
