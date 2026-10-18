<%@ Page Title="Create Your Account - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="SkillLinksX.Public.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="register-page-wrapper">
        <!-- Left Panel -->
        <div class="register-left-panel">
            <div>
                <h2 class="register-left-title">Join the Professional Network</h2>
                <p class="register-left-desc">
                    Connect with top companies in Mumbai, Bengaluru, and across India. Elevate your career journey today.
                </p>
            </div>
            <div class="register-left-img-box">
                <img src='<%= ResolveUrl("~/assets/images/register clipped image.png") %>' alt="Students and Professionals Network" class="register-left-img" />
            </div>
        </div>

        <!-- Right: Registration Form Card -->
        <div class="register-form-card">
            <h1 class="register-form-title">Create Your Account</h1>
            <p class="register-form-sub">Build your professional profile and discover the right opportunities.</p>

            <asp:Label ID="lblRegisterStatus" runat="server" Visible="false" CssClass="form-status-alert success"></asp:Label>
            <asp:ValidationSummary ID="valSummaryRegister" runat="server" CssClass="validation-summary-box" HeaderText="Please fix the following:" ForeColor="#B91C1C" ValidationGroup="vgRegister" />

            <!-- Role Selector Tabs -->
            <input type="hidden" id="hiddenSelectedRole" name="hiddenSelectedRole" value="Student" />
            <div class="role-tabs-selector">
                <button type="button" class="role-tab-btn active" data-role="Student">Student</button>
                <button type="button" class="role-tab-btn" data-role="Professional">Professional</button>
                <button type="button" class="role-tab-btn" data-role="Company">Company / Recruiter</button>
            </div>

            <!-- Full Name & Email (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegFullName">Full Name <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegFullName" runat="server" CssClass="contact-text-box" placeholder="Raviraj Dhadhal"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegFullName" runat="server" ControlToValidate="txtRegFullName"
                        ErrorMessage="Full name is required." Text="Full name is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegEmail">Email Address <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegEmail" runat="server" CssClass="contact-text-box" placeholder="raviraj@gmail.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ErrorMessage="Email is required." Text="Email is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Enter a valid email address."
                        Text="Enter a valid email address." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgRegister"
                        CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>
            </div>

            <!-- Phone Number & Password (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegPhone">Phone Number <span style="color:#DC2626;">*</span></label>
                    <div class="phone-input-combined">
                        <span class="phone-prefix">+91</span>
                        <asp:TextBox ID="txtRegPhone" runat="server" CssClass="phone-text-field" placeholder="98765 43210" MaxLength="10"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvRegPhone" runat="server" ControlToValidate="txtRegPhone"
                        ErrorMessage="Phone number is required." Text="Phone number is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPhone" runat="server" ControlToValidate="txtRegPhone"
                        ValidationExpression="^[0-9]{10}$" ErrorMessage="Phone number must be exactly 10 digits."
                        Text="Phone number must be 10 digits." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgRegister"
                        CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegPassword">Password <span style="color:#DC2626;">*</span></label>
                    <div class="input-icon-wrapper">
                        <asp:TextBox ID="txtRegPassword" runat="server" TextMode="Password" CssClass="contact-text-box" placeholder="*****"></asp:TextBox>
                        <button type="button" class="password-eye-toggle password-toggle-btn" data-target="<%= txtRegPassword.ClientID %>">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvRegPassword" runat="server" ControlToValidate="txtRegPassword"
                        ErrorMessage="Password is required." Text="Password is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPassword" runat="server" ControlToValidate="txtRegPassword"
                        ValidationExpression="^.{8,}$" ErrorMessage="Password must be at least 8 characters long."
                        Text="Password must be at least 8 characters long." ForeColor="#DC2626" Display="Dynamic"
                        ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>
            </div>

            <!-- City & State (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCity">City <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCity" runat="server" CssClass="contact-text-box" placeholder="Ahmedabad"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCity" runat="server" ControlToValidate="txtRegCity"
                        ErrorMessage="City is required." Text="City is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="ddlRegState">State</label>
                    <asp:DropDownList ID="ddlRegState" runat="server" CssClass="contact-select-box">
                        <asp:ListItem Value="Gujarat" Selected="True">Gujarat</asp:ListItem>
                        <asp:ListItem Value="Maharashtra">Maharashtra</asp:ListItem>
                        <asp:ListItem Value="Karnataka">Karnataka</asp:ListItem>
                        <asp:ListItem Value="Delhi">Delhi</asp:ListItem>
                        <asp:ListItem Value="Tamil Nadu">Tamil Nadu</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <!-- College/University & Graduation Year (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCollege">College / University <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCollege" runat="server" CssClass="contact-text-box" placeholder="IIT Bombay"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCollege" runat="server" ControlToValidate="txtRegCollege"
                        ErrorMessage="College / University is required." Text="College / University is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="ddlGradYear">Graduation Year <span style="color:#DC2626;">*</span></label>
                    <asp:DropDownList ID="ddlGradYear" runat="server" CssClass="contact-select-box">
                        <asp:ListItem Value="">Select Year</asp:ListItem>
                        <asp:ListItem Value="2025">2025</asp:ListItem>
                        <asp:ListItem Value="2026">2026</asp:ListItem>
                        <asp:ListItem Value="2027">2027</asp:ListItem>
                        <asp:ListItem Value="2028">2028</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvGradYear" runat="server" ControlToValidate="ddlGradYear" InitialValue=""
                        ErrorMessage="Graduation year is required." Text="Graduation year is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>
            </div>

            <!-- Key Skills (Figma Box with Tags + Input) -->
            <div class="contact-input-group">
                <label class="contact-label" for="txtRegSkills">Key Skills</label>
                <div class="figma-skills-box">
                    <div class="skills-tags-display">
                        <span class="tag-badge-figma">React <i class="fa-solid fa-xmark"></i></span>
                        <span class="tag-badge-figma">Python <i class="fa-solid fa-xmark"></i></span>
                    </div>
                    <asp:TextBox ID="txtRegSkills" runat="server" CssClass="figma-skills-inline-input" placeholder="Add a skill (e.g., Data Analysis)"></asp:TextBox>
                </div>
            </div>

            <!-- Submit Button -->
            <asp:Button ID="btnCreateAccount" runat="server" Text="Create Account" CssClass="btn-send-message-full btn-create-acct-figma" ValidationGroup="vgRegister" OnClick="btnCreateAccount_Click" />

            <!-- Footer Link -->
            <div class="login-footer-switch">
                Already have an account? <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="switch-auth-link">Login here</a>
            </div>
        </div>
    </div>
</asp:Content>
