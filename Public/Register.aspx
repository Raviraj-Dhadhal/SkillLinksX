<%@ Page Title="Create Student Account - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="SkillLinksX.Public.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .role-tabs-selector {
            display: grid !important;
            grid-template-columns: 1fr 1fr !important;
            background-color: #F1F5F9 !important;
            border-radius: 8px !important;
            padding: 4px !important;
            gap: 6px !important;
            margin-bottom: 22px !important;
        }
        .role-tab-btn {
            border: none !important;
            background: transparent !important;
            padding: 10px 14px !important;
            font-size: 13.5px !important;
            font-weight: 600 !important;
            color: #64748B !important;
            border-radius: 6px !important;
            cursor: pointer !important;
            transition: all 0.2s ease !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 8px !important;
            text-decoration: none !important;
        }
        .role-tab-btn.active {
            background-color: #FFFFFF !important;
            color: #0052CC !important;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08) !important;
        }
        .reg-section-title {
            font-size: 13px;
            font-weight: 700;
            color: #0F172A;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin: 18px 0 10px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .reg-section-title i {
            color: #0052CC;
        }
        .form-status-alert.error {
            background-color: #FEF2F2 !important;
            border: 1px solid #FCA5A5 !important;
            color: #DC2626 !important;
            padding: 10px 14px !important;
            border-radius: 6px !important;
            margin-bottom: 16px !important;
            display: block !important;
            font-size: 13.5px !important;
        }
        .form-status-alert.success {
            background-color: #ECFDF5 !important;
            border: 1px solid #6EE7B7 !important;
            color: #059669 !important;
            padding: 10px 14px !important;
            border-radius: 6px !important;
            margin-bottom: 16px !important;
            display: block !important;
            font-size: 13.5px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="register-page-wrapper">
        <!-- Left Panel -->
        <div class="register-left-panel">
            <div>
                <h2 class="register-left-title">Join SkillLinksX</h2>
                <p class="register-left-desc">
                    Connect students with top companies and internships across India. Elevate your career or build your dream team today.
                </p>
            </div>
            <div class="register-left-img-box">
                <img src='<%= ResolveUrl("~/assets/images/register clipped image.png") %>' alt="Students and Companies Network" class="register-left-img" />
            </div>
        </div>

        <!-- Right: Registration Form Card -->
        <div class="register-form-card">
            <h1 class="register-form-title">Create Your Account</h1>
            <p class="register-form-sub">Choose your account type to get started with tailored features.</p>

            <asp:Label ID="lblRegisterStatus" runat="server" Visible="false" CssClass="form-status-alert success"></asp:Label>

            <!-- Role Selector Tabs: Student vs Company -->
            <div class="role-tabs-selector">
                <span class="role-tab-btn active" id="tabStudent">
                    <i class="fa-solid fa-graduation-cap"></i> Student / Job Seeker
                </span>
                <a href="<%= ResolveUrl("~/Public/CompanyRegister.aspx") %>" class="role-tab-btn" id="tabCompany">
                    <i class="fa-solid fa-building"></i> Company / Recruiter
                </a>
            </div>

            <!-- ========================================================================= -->
            <!-- [STUDENT DETAILS] -->
            <!-- ========================================================================= -->
            <div class="reg-section-title">
                <i class="fa-solid fa-user-graduate"></i> Student Details
            </div>

            <!-- Full Name & College (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegFullName">Full Name <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegFullName" runat="server" CssClass="contact-text-box" placeholder="Raviraj Dhadhal"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegFullName" runat="server" ControlToValidate="txtRegFullName"
                        ErrorMessage="Full name is required." Text="Full name is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCollege">College / University <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCollege" runat="server" CssClass="contact-text-box" placeholder="Gujarat University / IIT Bombay"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCollege" runat="server" ControlToValidate="txtRegCollege"
                        ErrorMessage="College / University is required." Text="College / University is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>
            </div>

            <!-- Graduation Year & Key Skills (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="ddlGradYear">Graduation Year <span style="color:#DC2626;">*</span></label>
                    <asp:DropDownList ID="ddlGradYear" runat="server" CssClass="contact-select-box">
                        <asp:ListItem Value="">Select Year</asp:ListItem>
                        <asp:ListItem Value="2024">2024</asp:ListItem>
                        <asp:ListItem Value="2025">2025</asp:ListItem>
                        <asp:ListItem Value="2026" Selected="True">2026</asp:ListItem>
                        <asp:ListItem Value="2027">2027</asp:ListItem>
                        <asp:ListItem Value="2028">2028</asp:ListItem>
                        <asp:ListItem Value="2029">2029</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvGradYear" runat="server" ControlToValidate="ddlGradYear" InitialValue=""
                        ErrorMessage="Graduation year is required." Text="Graduation year is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegSkills">Key Skills</label>
                    <asp:TextBox ID="txtRegSkills" runat="server" CssClass="contact-text-box" placeholder="e.g. C#, ASP.NET, React, SQL Server"></asp:TextBox>
                </div>
            </div>

            <!-- ========================================================================= -->
            <!-- [ACCOUNT CREDENTIALS & CONTACT] -->
            <!-- ========================================================================= -->
            <div class="reg-section-title">
                <i class="fa-solid fa-lock"></i> Account Credentials & Contact
            </div>

            <!-- Email & Phone (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegEmail">Student Email Address <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegEmail" runat="server" CssClass="contact-text-box" placeholder="raviraj@gmail.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ErrorMessage="Email is required." Text="Email is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Enter a valid email address."
                        Text="Enter a valid email address." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgStudentReg"
                        CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegPhone">Phone Number <span style="color:#DC2626;">*</span></label>
                    <div class="phone-input-combined">
                        <span class="phone-prefix">+91</span>
                        <asp:TextBox ID="txtRegPhone" runat="server" CssClass="phone-text-field" placeholder="98765 43210" MaxLength="10"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvRegPhone" runat="server" ControlToValidate="txtRegPhone"
                        ErrorMessage="Phone number is required." Text="Phone number is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPhone" runat="server" ControlToValidate="txtRegPhone"
                        ValidationExpression="^[0-9]{10}$" ErrorMessage="Phone number must be exactly 10 digits."
                        Text="Phone number must be 10 digits." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgStudentReg"
                        CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>
            </div>

            <!-- Password & City (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegPassword">Password <span style="color:#DC2626;">*</span></label>
                    <div class="input-icon-wrapper">
                        <asp:TextBox ID="txtRegPassword" runat="server" TextMode="Password" CssClass="contact-text-box" placeholder="••••••••"></asp:TextBox>
                        <button type="button" class="password-eye-toggle password-toggle-btn" data-target="<%= txtRegPassword.ClientID %>">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvRegPassword" runat="server" ControlToValidate="txtRegPassword"
                        ErrorMessage="Password is required." Text="Password is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPassword" runat="server" ControlToValidate="txtRegPassword"
                        ValidationExpression="^.{8,}$" ErrorMessage="Password must be at least 8 characters long."
                        Text="Password must be at least 8 characters long." ForeColor="#DC2626" Display="Dynamic"
                        ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCity">City <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCity" runat="server" CssClass="contact-text-box" placeholder="Ahmedabad"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCity" runat="server" ControlToValidate="txtRegCity"
                        ErrorMessage="City is required." Text="City is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgStudentReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>
            </div>

            <!-- State -->
            <div class="contact-input-group">
                <label class="contact-label" for="ddlRegState">State</label>
                <asp:DropDownList ID="ddlRegState" runat="server" CssClass="contact-select-box">
                    <asp:ListItem Value="Gujarat" Selected="True">Gujarat</asp:ListItem>
                    <asp:ListItem Value="Maharashtra">Maharashtra</asp:ListItem>
                    <asp:ListItem Value="Karnataka">Karnataka</asp:ListItem>
                    <asp:ListItem Value="Delhi">Delhi</asp:ListItem>
                    <asp:ListItem Value="Tamil Nadu">Tamil Nadu</asp:ListItem>
                    <asp:ListItem Value="Telangana">Telangana</asp:ListItem>
                    <asp:ListItem Value="Uttar Pradesh">Uttar Pradesh</asp:ListItem>
                    <asp:ListItem Value="Rajasthan">Rajasthan</asp:ListItem>
                    <asp:ListItem Value="Madhya Pradesh">Madhya Pradesh</asp:ListItem>
                    <asp:ListItem Value="West Bengal">West Bengal</asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Submit Button -->
            <asp:Button ID="btnCreateAccount" runat="server" Text="Create Student Account" CssClass="btn-send-message-full btn-create-acct-figma" ValidationGroup="vgStudentReg" OnClick="btnCreateAccount_Click" />

            <!-- Footer Link -->
            <div class="login-footer-switch">
                Already have an account? <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="switch-auth-link">Login here</a>
            </div>
            <div class="login-footer-switch" style="margin-top: 6px;">
                Looking to hire? <a href="<%= ResolveUrl("~/Public/CompanyRegister.aspx") %>" class="switch-auth-link">Register your Company</a>
            </div>
        </div>
    </div>
</asp:Content>
