<%@ Page Title="Sign In - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SkillLinksX.Public.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-split-page">
        <!-- Left Side: Form -->
        <div class="login-form-side">
            <!-- Brand -->
            <a href="<%= ResolveUrl("~/Public/Home.aspx") %>" class="login-brand-logo">
                <img src='<%= ResolveUrl("~/assets/images/logo.svg") %>' alt="SkillLinkX Logo" />
                <div>
                    <span class="login-brand-text">SkillLinkX</span>
                    <span class="login-sub-badge">PROFESSIONAL HUB</span>
                </div>
            </a>

            <h1 class="login-title-h1">Welcome Back</h1>
            <p class="login-subtitle-p">Sign in to continue your career journey.</p>

            <asp:Label ID="lblLoginError" runat="server" Visible="false" CssClass="form-status-alert" ForeColor="Red"></asp:Label>
            <asp:ValidationSummary ID="valSummaryLogin" runat="server" CssClass="validation-summary-box" HeaderText="Please fix the following:" ForeColor="#B91C1C" ValidationGroup="vgLogin" />

            <!-- Email Address -->
            <div class="contact-input-group">
                <label class="contact-label" for="txtLoginEmail">Email address</label>
                <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="contact-text-box" placeholder="name@example.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvLoginEmail" runat="server" ControlToValidate="txtLoginEmail"
                    ErrorMessage="Email address is required." Text="Email address is required." ForeColor="#DC2626"
                    Display="Dynamic" ValidationGroup="vgLogin" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revLoginEmail" runat="server" ControlToValidate="txtLoginEmail"
                    ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Enter a valid email address."
                    Text="Enter a valid email address." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgLogin"
                    CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
            </div>

            <!-- Password -->
            <div class="contact-input-group">
                <label class="contact-label" for="txtLoginPassword">Password</label>
                <div class="input-icon-wrapper">
                    <asp:TextBox ID="txtLoginPassword" runat="server" TextMode="Password" CssClass="contact-text-box" placeholder="Enter your password"></asp:TextBox>
                    <button type="button" class="password-eye-toggle password-toggle-btn" data-target="<%= txtLoginPassword.ClientID %>">
                        <i class="fa-regular fa-eye"></i>
                    </button>
                </div>
                <asp:RequiredFieldValidator ID="rfvLoginPassword" runat="server" ControlToValidate="txtLoginPassword"
                    ErrorMessage="Password is required." Text="Password is required." ForeColor="#DC2626"
                    Display="Dynamic" ValidationGroup="vgLogin" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revLoginPassword" runat="server" ControlToValidate="txtLoginPassword"
                    ValidationExpression="^.{8,}$" ErrorMessage="Password must be at least 8 characters long."
                    Text="Password must be at least 8 characters long." ForeColor="#DC2626" Display="Dynamic"
                    ValidationGroup="vgLogin" CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
            </div>

            <!-- Remember Me & Forgot Password -->
            <div class="login-extras-row">
                <label class="remember-label">
                    <asp:CheckBox ID="chkRememberMe" runat="server" />
                    <span>Remember me</span>
                </label>
                <a href="<%= ResolveUrl("~/Public/ForgotPassword.aspx") %>" class="forgot-link">Forgot your password?</a>
            </div>

            <!-- Submit Button -->
            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login-submit" ValidationGroup="vgLogin" OnClick="btnLogin_Click" />

            <!-- Footer Switch -->
            <div class="login-footer-switch">
                Don't have an account? <a href="<%= ResolveUrl("~/Public/Register.aspx") %>" class="switch-auth-link">Create an account</a>
            </div>
        </div>

        <!-- Right Side: Graphic Illustration -->
        <div class="login-art-side">
            <img src='<%= ResolveUrl("~/assets/images/login right side image.png") %>' alt="SkillLinkX Graphic" class="login-art-img" />
            <div class="login-art-quote">
                "Connecting talent with opportunity."
            </div>
        </div>
    </div>
</asp:Content>
