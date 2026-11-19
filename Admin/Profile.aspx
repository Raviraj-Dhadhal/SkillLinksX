<%@ Page Title="Admin Profile - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SkillLinksX.Admin.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Portal Styles -->
    <link href="<%= ResolveUrl("~/assets/CSS/admin-pages.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-profile-page-container">
        
        <!-- Top Profile Header Card -->
        <div class="admin-profile-header-card">
            <div class="admin-profile-avatar-wrapper">
                <div style="width:72px; height:72px; border-radius:50%; background:#f1f5f9; color:#64748b; display:flex; align-items:center; justify-content:center; font-size:32px; border:1px solid #cbd5e1; overflow:hidden;">
                    <img src="<%= AdminPhotoUrl %>" alt="<%= AdminFullName %>" style="width:100%; height:100%; object-fit:cover;" />
                </div>
            </div>
            
            <div class="admin-profile-header-meta">
                <div class="admin-name-badge-row">
                    <h1 class="admin-profile-name">
                        <asp:Literal ID="litAdminName" runat="server"></asp:Literal>
                    </h1>
                    <span class="badge-active-pill"><i class="fa-solid fa-circle"></i> Active</span>
                </div>
                <div class="admin-profile-subtitle">
                    Platform Administrator &bull; <asp:Literal ID="litAdminEmail" runat="server"></asp:Literal>
                </div>
            </div>

            <div class="admin-profile-header-actions">
                <a href="<%= ResolveUrl("~/Admin/Settings.aspx") %>" class="btn-edit-admin-profile" id="btnEditAdminProfile" style="text-decoration:none;">
                    <i class="fa-solid fa-pen"></i> Edit Profile
                </a>
            </div>
        </div>

        <!-- Main Profile Grid: Left 2 Columns & Right 1 Column -->
        <div class="admin-profile-grid-layout">
            
            <!-- Left Main Column Stack -->
            <div class="admin-profile-left-stack">
                
                <!-- About Section Card -->
                <div class="admin-section-box">
                    <h2 class="admin-section-heading">About</h2>
                    <p class="admin-about-text">
                        Platform administrator responsible for managing SkillLinkX users, companies, job opportunities, internships, platform activity and system operations. Ensures a seamless experience for both recruiters and candidates while maintaining data integrity and platform security.
                    </p>
                </div>

                <!-- Personal Information & Professional Info Split Row -->
                <div class="admin-info-split-row">
                    
                    <!-- Personal Information Card -->
                    <div class="admin-section-box">
                        <div class="admin-section-subhead">
                            <i class="fa-regular fa-user"></i> Personal Information
                        </div>

                        <div class="admin-form-group">
                            <label class="admin-input-label">Full Name</label>
                            <input type="text" class="admin-profile-input" value="<%= AdminFullName %>" readonly="readonly" />
                        </div>

                        <div class="admin-form-group">
                            <label class="admin-input-label">Email Address</label>
                            <input type="email" class="admin-profile-input" value="<%= AdminEmail %>" readonly="readonly" />
                        </div>

                        <div class="admin-form-group">
                            <label class="admin-input-label">Phone Number</label>
                            <input type="tel" class="admin-profile-input" value="<%= AdminPhone %>" readonly="readonly" />
                        </div>

                        <div class="admin-form-group">
                            <label class="admin-input-label">Location</label>
                            <input type="text" class="admin-profile-input" value="<%= AdminLocation %>" readonly="readonly" />
                        </div>
                    </div>

                    <!-- Professional Info Card -->
                    <div class="admin-section-box">
                        <div class="admin-section-subhead">
                            <i class="fa-solid fa-briefcase"></i> Professional Info
                        </div>

                        <div class="admin-meta-field">
                            <div class="meta-field-tag">JOB TITLE</div>
                            <div class="meta-field-bold">Platform Administrator</div>
                        </div>

                        <div class="admin-meta-field">
                            <div class="meta-field-tag">DEPARTMENT</div>
                            <div class="meta-field-bold">Administration</div>
                        </div>

                        <div class="admin-meta-field">
                            <div class="meta-field-tag">EMPLOYEE ID</div>
                            <div class="meta-field-pill-box">SLX-ADM-001</div>
                        </div>

                        <div class="admin-meta-field">
                            <div class="meta-field-tag">ROLE TYPE</div>
                            <div>
                                <span class="badge-role-superadmin">
                                    <i class="fa-solid fa-shield-halved"></i> Super Admin
                                </span>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <!-- Right Sidebar Stack -->
            <div class="admin-profile-right-stack">
                
                <!-- Profile Completion Card -->
                <div class="admin-section-box">
                    <h2 class="admin-section-heading">Profile Completion</h2>
                    
                    <div class="completion-stat-row">
                        <span class="completion-percent">90%</span>
                        <span class="completion-hint">Almost there!</span>
                    </div>

                    <div class="completion-progress-track">
                        <div class="completion-progress-fill" style="width: 90%;"></div>
                    </div>

                    <div class="completion-checklist">
                        <div class="checklist-item done">
                            <i class="fa-regular fa-circle-check"></i>
                            <span>Basic Information</span>
                        </div>
                        <div class="checklist-item done">
                            <i class="fa-regular fa-circle-check"></i>
                            <span>Profile Photo</span>
                        </div>
                        <div class="checklist-item done">
                            <i class="fa-regular fa-circle-check"></i>
                            <span>Two-Factor Auth</span>
                        </div>
                        <div class="checklist-item pending">
                            <i class="fa-regular fa-circle"></i>
                            <span style="text-decoration: line-through;">Recovery Email</span>
                        </div>
                    </div>
                </div>

                <!-- Security Card -->
                <div class="admin-section-box">
                    <div class="security-card-title">
                        <i class="fa-solid fa-shield-halved"></i> Security
                    </div>

                    <div class="security-item-row">
                        <div class="security-item-text">
                            <div class="security-label">Password</div>
                            <div class="security-sub">Last changed 30 days ago</div>
                        </div>
                        <a href="javascript:void(0);" class="security-link-action">Update</a>
                    </div>

                    <div class="security-item-row">
                        <div class="security-item-text">
                            <div class="security-label">Two-Factor Authentication</div>
                            <div class="security-sub">Recommended</div>
                        </div>
                        <label class="switch-toggle">
                            <input type="checkbox" checked="checked" />
                            <span class="switch-slider"></span>
                        </label>
                    </div>

                    <div class="security-item-row">
                        <div class="security-item-text">
                            <div class="security-label">Login Alerts</div>
                            <div class="security-sub">Notify on new devices</div>
                        </div>
                        <label class="switch-toggle">
                            <input type="checkbox" checked="checked" />
                            <span class="switch-slider"></span>
                        </label>
                    </div>
                </div>

            </div>

        </div>

        <!-- Danger Zone Full Width Card -->
        <div class="admin-danger-zone-box">
            <div class="danger-zone-header">
                <i class="fa-solid fa-triangle-exclamation"></i> Danger Zone
            </div>
            <p class="danger-zone-warning">
                Proceed with caution. These actions are irreversible and affect system access.
            </p>
            <div class="danger-zone-actions">
                <button type="button" class="btn-danger-outline" onclick="alert('All active sessions have been revoked.');">
                    Revoke All Sessions
                </button>
                <button type="button" class="btn-danger-solid" onclick="if(confirm('Are you sure you want to deactivate your admin account?')) alert('Deactivation requested.');">
                    Deactivate Account
                </button>
            </div>
        </div>

    </div>
</asp:Content>
