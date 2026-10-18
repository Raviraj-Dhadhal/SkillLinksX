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
