<%@ Page Title="Forgot Password? - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="SkillLinksX.Public.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="forgot-page-wrapper">
        <!-- Main Card -->
        <div class="forgot-card">
            <!-- Circular reload/refresh icon -->
            <div class="forgot-key-circle">
                <i class="fa-solid fa-rotate-right"></i>
            </div>

            <h1 class="forgot-card-title">Forgot Password?</h1>
            <p class="forgot-card-sub">
                Enter your email address and we'll send you a link to reset your password.
            </p>

            <asp:Label ID="lblForgotStatus" runat="server" Visible="false" CssClass="form-status-alert success"></asp:Label>

            <div class="forgot-form-container">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtForgotEmail">Email Address</label>
                    <div class="input-icon-wrapper">
                        <i class="fa-regular fa-envelope input-left-icon"></i>
                        <asp:TextBox ID="txtForgotEmail" runat="server" CssClass="contact-text-box has-left-icon" placeholder="Enter your email address"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvForgotEmail" runat="server" ControlToValidate="txtForgotEmail"
                        ErrorMessage="Email is required." Text="Email is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgForgot" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revForgotEmail" runat="server" ControlToValidate="txtForgotEmail"
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Enter a valid email address."
                        Text="Enter a valid email address." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgForgot"
                        CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>

                <asp:Button ID="btnSendResetLink" runat="server" Text="Send Reset Link" CssClass="btn-send-message-full" ValidationGroup="vgForgot" OnClick="btnSendResetLink_Click" style="margin-top: 14px;" />

                <div style="text-align: center; margin-top: 22px;">
                    <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="back-to-login-link">
                        Remember your password? <span style="font-weight: 600; text-decoration: underline;">Back to Login</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Secure Authentication Badge -->
        <div class="secure-badge-row">
            <i class="fa-solid fa-lock"></i>
            <span>SECURE AUTHENTICATION</span>
        </div>
    </div>
</asp:Content>
