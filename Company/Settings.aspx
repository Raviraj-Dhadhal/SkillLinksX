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
                        <!-- Logo Upload Row (Technova Logo Box) -->
                        <div class="company-logo-uploader-row">
                            <div class="company-avatar-box">
                                <img src="<%= ResolveUrl("~/assets/images/technova-logo.svg") %>" alt="Company Logo" class="settings-company-logo-img" />
                            </div>
                            <div class="logo-uploader-meta">
                                <button type="button" class="btn-change-logo">Change Logo</button>
                                <span class="upload-hint-text">JPG, GIF or PNG. Max size of 800K</span>
                            </div>
                        </div>

                        <!-- Form 2x2 fields -->
                        <div class="settings-form-grid">
                            <!-- Company Name -->
                            <div class="settings-form-group">
                                <label class="settings-label">Company Name</label>
                                <input type="text" class="settings-input" value="TechNova Solutions" />
                            </div>

                            <!-- Industry -->
                            <div class="settings-form-group">
                                <label class="settings-label">Industry</label>
                                <div class="settings-select-wrapper">
                                    <select class="settings-select">
                                        <option selected="selected">Information Technology</option>
                                        <option>Software Development</option>
                                        <option>Finance &amp; Banking</option>
                                        <option>Healthcare &amp; Biotech</option>
                                        <option>E-Commerce</option>
                                    </select>
                                    <i class="fa-solid fa-chevron-down select-chevron"></i>
                                </div>
                            </div>

                            <!-- Company Size -->
                            <div class="settings-form-group">
                                <label class="settings-label">Company Size</label>
                                <div class="settings-select-wrapper">
                                    <select class="settings-select">
                                        <option selected="selected">201-500 employees</option>
                                        <option>1-10 employees</option>
                                        <option>11-50 employees</option>
                                        <option>51-200 employees</option>
                                        <option>500+ employees</option>
                                    </select>
                                    <i class="fa-solid fa-chevron-down select-chevron"></i>
                                </div>
                            </div>

                            <!-- Founded Year -->
                            <div class="settings-form-group">
                                <label class="settings-label">Founded Year</label>
                                <input type="text" class="settings-input" value="2012" />
                            </div>

                            <!-- Website -->
                            <div class="settings-form-group">
                                <label class="settings-label">Website</label>
                                <input type="text" class="settings-input" value="https://technovasolutions.in" />
                            </div>

                            <!-- Location (Moved below Website field as requested) -->
                            <div class="settings-form-group">
                                <label class="settings-label">Location</label>
                                <input type="text" class="settings-input" value="Titanium Business Park, SG Highway, Ahmedabad, Gujarat 380015, India" />
                            </div>

                            <!-- Contact Email -->
                            <div class="settings-form-group">
                                <label class="settings-label">Contact Email</label>
                                <input type="email" class="settings-input" value="careers@technovasolutions.in" />
                            </div>
                        </div>

                        <!-- Save Changes Button Row -->
                        <div class="settings-actions-row">
                            <button type="button" class="btn-save-settings">Save Changes</button>
                        </div>
                    </div>
                </div>

                <!-- 2. Team Members Card -->
                <div class="settings-section-card" id="sectionTeamMembers">
                    <div class="settings-card-header flex-between">
                        <h2 class="settings-card-title">Team Members</h2>
                        <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="btn-add-member" style="text-decoration: none;">
                            <i class="fa-solid fa-user-plus"></i> Add Member
                        </a>
                    </div>
                    <div class="settings-card-body p-0">
                        <div class="team-table-scroll-wrapper">
                            <table class="team-members-table">
                                <thead>
                                    <tr>
                                        <th>USER</th>
                                        <th>ROLE</th>
                                        <th>STATUS</th>
                                        <th class="text-right">ACTION</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Member 1: Arjun Kapoor -->
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
                                        <td>
                                            <span class="member-role-text">Company Admin</span>
                                        </td>
                                        <td>
                                            <span class="badge-status-active">Active</span>
                                        </td>
                                        <td class="text-right">
                                            <button type="button" class="btn-member-action" aria-label="Action Menu">
                                                <i class="fa-solid fa-ellipsis-vertical"></i>
                                            </button>
                                        </td>
                                    </tr>

                                    <!-- Member 2: Priya Sharma -->
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
                                        <td>
                                            <span class="member-role-text">Senior Recruiter</span>
                                        </td>
                                        <td>
                                            <span class="badge-status-active">Active</span>
                                        </td>
                                        <td class="text-right">
                                            <button type="button" class="btn-member-action" aria-label="Action Menu">
                                                <i class="fa-solid fa-ellipsis-vertical"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
