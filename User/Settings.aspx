<%@ Page Title="Settings - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="SkillLinksX.User.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Settings Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-settings-page-container">

        <!-- Page Header -->
        <div class="user-settings-header">
            <h1 class="user-settings-title">Settings</h1>
            <p class="user-settings-sub">Manage your account, preferences, security and notification settings.</p>
        </div>

        <!-- Settings Main Card -->
        <div class="user-settings-main-card">
            
            <!-- Card Section Header -->
            <div class="settings-card-head">
                <h2 class="settings-card-heading">Account Information</h2>
                <p class="settings-card-description">Update your basic account details.</p>
                <asp:Label ID="lblSettingsFeedback" runat="server" style="margin-top:6px; display:block; font-size:13px; font-weight:600;" EnableViewState="false" />
            </div>

            <!-- Profile Photo Section -->
            <div class="settings-profile-photo-section" style="padding: 24px; border-bottom: 1px solid #e2e8f0; display:flex; align-items:center; gap:24px; flex-wrap:wrap;">
                <div class="settings-avatar-preview-wrap" style="width:90px; height:90px; border-radius:50%; background:#f1f5f9; display:flex; align-items:center; justify-content:center; color:#94a3b8; font-size:42px; border:3px solid #e2e8f0; overflow:hidden; flex-shrink:0;">
                    <% if (!string.IsNullOrEmpty(ProfilePhotoUrl)) { %>
                        <img src="<%= ResolveUrl(ProfilePhotoUrl) %>" alt="Profile Picture" style="width:100%; height:100%; object-fit:cover;" />
                    <% } else { %>
                        <i class="fa-regular fa-user"></i>
                    <% } %>
                </div>
                <div style="flex:1; min-width:240px;">
                    <h3 style="margin:0 0 4px; font-size:16px; font-weight:700; color:#0f172a;">Profile Picture</h3>
                    <p style="margin:0 0 12px; font-size:13px; color:#64748b;">Upload a personal profile picture. If no photo is uploaded, a default user icon is shown.</p>
                    <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                        <asp:FileUpload ID="fileProfilePhoto" runat="server" accept=".jpg,.jpeg,.png" style="font-size:12px; max-width:240px;" />
                        <asp:Button ID="btnUploadPhoto" runat="server" Text="Upload Photo" CssClass="btn-settings-save" style="padding:6px 14px; font-size:12.5px; height:auto;" OnClick="btnUploadPhoto_Click" />
                        <% if (!string.IsNullOrEmpty(ProfilePhotoUrl)) { %>
                            <asp:Button ID="btnRemovePhoto" runat="server" Text="Remove Photo" CssClass="btn-settings-cancel" style="padding:6px 14px; font-size:12.5px; height:auto; color:#ef4444; border-color:#fca5a5;" OnClick="btnRemovePhoto_Click" />
                        <% } %>
                    </div>
                    <asp:Label ID="lblPhotoStatus" runat="server" style="display:block; margin-top:6px; font-size:12.5px; font-weight:600;" EnableViewState="false" />
                </div>
            </div>

            <!-- Form Content Body -->
            <div class="settings-card-form-body">
                <div class="settings-form-grid-2col">
                    
                    <!-- Full Name -->
                    <div class="settings-form-group">
                        <label class="settings-form-label" for="txtFullName">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="settings-form-control" Text="Raviraj Dhadhal" />
                    </div>

                    <!-- Username -->
                    <div class="settings-form-group">
                        <label class="settings-form-label" for="txtUsername">Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="settings-form-control" Text="raviraj_admin" />
                    </div>

                    <!-- Email Address -->
                    <div class="settings-form-group">
                        <label class="settings-form-label" for="txtEmail">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="settings-form-control" Text="raviraj08@gmail.com" />
                    </div>

                    <!-- Phone Number -->
                    <div class="settings-form-group">
                        <label class="settings-form-label" for="txtPhone">Phone Number</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="settings-form-control" Text="+91 98765 43210" />
                    </div>

                </div>
            </div>

            <!-- Card Actions Footer -->
            <div class="settings-card-footer flex-end">
                <a href="<%= ResolveUrl("~/User/Profile.aspx") %>" class="btn-settings-cancel" style="text-decoration:none; display:inline-flex; align-items:center; justify-content:center;">Cancel</a>
                <asp:Button ID="btnSaveSettings" runat="server" CssClass="btn-settings-save" Text="Save Changes" OnClick="btnSaveSettings_Click" />
            </div>

        </div>

    </div>
</asp:Content>
