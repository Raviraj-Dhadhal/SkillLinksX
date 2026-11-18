<%@ Page Title="Register Company - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="CompanyRegister.aspx.cs" Inherits="SkillLinksX.Public.CompanyRegister" %>

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
                <h2 class="register-left-title">Hire Top Talent on SkillLinksX</h2>
                <p class="register-left-desc">
                    Connect with qualified candidates, post jobs and internships, schedule interviews, and build your dream team today.
                </p>
            </div>
            <div class="register-left-img-box">
                <img src='<%= ResolveUrl("~/assets/images/register clipped image.png") %>' alt="Companies Network" class="register-left-img" />
            </div>
        </div>

        <!-- Right: Registration Form Card -->
        <div class="register-form-card">
            <h1 class="register-form-title">Register Your Company</h1>
            <p class="register-form-sub">Create your employer account to find, interview, and hire talented candidates.</p>

            <asp:Label ID="lblRegisterStatus" runat="server" Visible="false" CssClass="form-status-alert success"></asp:Label>

            <!-- Role Selector Tabs: Student vs Company -->
            <div class="role-tabs-selector">
                <a href="<%= ResolveUrl("~/Public/Register.aspx") %>" class="role-tab-btn" id="tabStudent">
                    <i class="fa-solid fa-graduation-cap"></i> Student / Job Seeker
                </a>
                <span class="role-tab-btn active" id="tabCompany">
                    <i class="fa-solid fa-building"></i> Company / Recruiter
                </span>
            </div>

            <!-- ========================================================================= -->
            <!-- [COMPANY & RECRUITER DETAILS] -->
            <!-- ========================================================================= -->
            <div class="reg-section-title">
                <i class="fa-solid fa-briefcase"></i> Company & Recruiter Details
            </div>

            <!-- Company Name & Recruiter Contact Name (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCompName">Company / Organization Name <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCompName" runat="server" CssClass="contact-text-box" placeholder="e.g. Acme Innovations Pvt Ltd"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCompName" runat="server" ControlToValidate="txtRegCompName"
                        ErrorMessage="Company name is required." Text="Company name is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegRecruiterName">Contact Person / Recruiter <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegRecruiterName" runat="server" CssClass="contact-text-box" placeholder="Arjun Kapoor (HR Head)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegRecruiterName" runat="server" ControlToValidate="txtRegRecruiterName"
                        ErrorMessage="Recruiter contact name is required." Text="Recruiter contact is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>
            </div>

            <!-- Industry & Company Size (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="ddlRegIndustry">Industry / Domain</label>
                    <asp:DropDownList ID="ddlRegIndustry" runat="server" CssClass="contact-select-box">
                        <asp:ListItem Value="Information Technology & Services" Selected="True">Information Technology & Services</asp:ListItem>
                        <asp:ListItem Value="Software Development & SaaS">Software Development & SaaS</asp:ListItem>
                        <asp:ListItem Value="Financial Services & FinTech">Financial Services & FinTech</asp:ListItem>
                        <asp:ListItem Value="Healthcare & Biotechnology">Healthcare & Biotechnology</asp:ListItem>
                        <asp:ListItem Value="Manufacturing & Engineering">Manufacturing & Engineering</asp:ListItem>
                        <asp:ListItem Value="E-Commerce & Retail">E-Commerce & Retail</asp:ListItem>
                        <asp:ListItem Value="Education & EdTech">Education & EdTech</asp:ListItem>
                        <asp:ListItem Value="Consulting & Business Strategy">Consulting & Business Strategy</asp:ListItem>
                        <asp:ListItem Value="Media & Advertising">Media & Advertising</asp:ListItem>
                        <asp:ListItem Value="Other">Other Industry</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="ddlRegEmployeeCount">Company Size</label>
                    <asp:DropDownList ID="ddlRegEmployeeCount" runat="server" CssClass="contact-select-box">
                        <asp:ListItem Value="1-10">1-10 employees (Startup)</asp:ListItem>
                        <asp:ListItem Value="11-50" Selected="True">11-50 employees (Small Business)</asp:ListItem>
                        <asp:ListItem Value="51-200">51-200 employees (Mid-Size)</asp:ListItem>
                        <asp:ListItem Value="201-500">201-500 employees (Large)</asp:ListItem>
                        <asp:ListItem Value="500+">500+ employees (Enterprise)</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <!-- Company Office Address & Website (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCompAddress">Company Office Address <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCompAddress" runat="server" CssClass="contact-text-box" placeholder="e.g. Tower B, Phase 2, SG Highway"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCompAddress" runat="server" ControlToValidate="txtRegCompAddress"
                        ErrorMessage="Company office address is required." Text="Address is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegWebsite">Company Website</label>
                    <asp:TextBox ID="txtRegWebsite" runat="server" CssClass="contact-text-box" placeholder="https://www.company.com"></asp:TextBox>
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
                    <label class="contact-label" for="txtRegEmail">Official Work Email Address <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegEmail" runat="server" CssClass="contact-text-box" placeholder="hr@company.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ErrorMessage="Work email is required." Text="Work email is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Enter a valid email address."
                        Text="Enter a valid email address." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgCompanyReg"
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
                        Display="Dynamic" ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPhone" runat="server" ControlToValidate="txtRegPhone"
                        ValidationExpression="^[0-9]{10}$" ErrorMessage="Phone number must be exactly 10 digits."
                        Text="Phone number must be 10 digits." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgCompanyReg"
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
                        Display="Dynamic" ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPassword" runat="server" ControlToValidate="txtRegPassword"
                        ValidationExpression="^.{8,}$" ErrorMessage="Password must be at least 8 characters long."
                        Text="Password must be at least 8 characters long." ForeColor="#DC2626" Display="Dynamic"
                        ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCity">City <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCity" runat="server" CssClass="contact-text-box" placeholder="Ahmedabad"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCity" runat="server" ControlToValidate="txtRegCity"
                        ErrorMessage="City is required." Text="City is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgCompanyReg" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
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
            <asp:Button ID="btnRegisterCompany" runat="server" Text="Register Company" CssClass="btn-send-message-full btn-create-acct-figma" ValidationGroup="vgCompanyReg" OnClick="btnRegisterCompany_Click" />

            <!-- Footer Link -->
            <div class="login-footer-switch">
                Already have an account? <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="switch-auth-link">Login here</a>
            </div>
            <div class="login-footer-switch" style="margin-top: 6px;">
                Looking for a student account? <a href="<%= ResolveUrl("~/Public/Register.aspx") %>" class="switch-auth-link">Register as Student</a>
            </div>
        </div>
    </div>
</asp:Content>
