<%@ Page Title="Create Your Account - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="SkillLinksX.Public.Register" %>

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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="register-page-wrapper">
        <!-- Left Panel -->
        <div class="register-left-panel">
            <div>
                <h2 class="register-left-title" id="leftPanelTitle">Join SkillLinksX</h2>
                <p class="register-left-desc" id="leftPanelDesc">
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
            <asp:ValidationSummary ID="valSummaryRegister" runat="server" CssClass="validation-summary-box" HeaderText="Please fix the following:" ForeColor="#B91C1C" ValidationGroup="vgRegister" />

            <!-- Role Selector Tabs: Student vs Company (Professional removed) -->
            <input type="hidden" id="hiddenSelectedRole" name="hiddenSelectedRole" value="Student" />
            <div class="role-tabs-selector">
                <button type="button" class="role-tab-btn active" id="tabStudent" onclick="switchRegRole('Student');">
                    <i class="fa-solid fa-graduation-cap"></i> Student / Job Seeker
                </button>
                <button type="button" class="role-tab-btn" id="tabCompany" onclick="switchRegRole('Company');">
                    <i class="fa-solid fa-building"></i> Company / Recruiter
                </button>
            </div>

            <!-- ========================================================================= -->
            <!-- [STUDENT-SPECIFIC REGISTRATION FIELDS] -->
            <!-- ========================================================================= -->
            <div id="studentFieldsContainer">
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
                            Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    </div>

                    <div class="contact-input-group">
                        <label class="contact-label" for="txtRegCollege">College / University <span style="color:#DC2626;">*</span></label>
                        <asp:TextBox ID="txtRegCollege" runat="server" CssClass="contact-text-box" placeholder="Gujarat University / IIT Bombay"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvRegCollege" runat="server" ControlToValidate="txtRegCollege"
                            ErrorMessage="College / University is required." Text="College / University is required." ForeColor="#DC2626"
                            Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
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
                            Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    </div>

                    <div class="contact-input-group">
                        <label class="contact-label" for="txtRegSkills">Key Skills</label>
                        <asp:TextBox ID="txtRegSkills" runat="server" CssClass="contact-text-box" placeholder="e.g. C#, ASP.NET, React, SQL Server"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- ========================================================================= -->
            <!-- [COMPANY-SPECIFIC REGISTRATION FIELDS] -->
            <!-- ========================================================================= -->
            <div id="companyFieldsContainer" style="display: none;">
                <div class="reg-section-title">
                    <i class="fa-solid fa-briefcase"></i> Company & Recruiter Details
                </div>

                <!-- Company Name & Recruiter Contact Name (2 Columns) -->
                <div class="form-2col-row">
                    <div class="contact-input-group">
                        <label class="contact-label" for="txtRegCompName">Company / Organization Name <span style="color:#DC2626;">*</span></label>
                        <asp:TextBox ID="txtRegCompName" runat="server" CssClass="contact-text-box" placeholder="TechNova Solutions Pvt Ltd"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvRegCompName" runat="server" ControlToValidate="txtRegCompName" Enabled="false"
                            ErrorMessage="Company name is required." Text="Company name is required." ForeColor="#DC2626"
                            Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    </div>

                    <div class="contact-input-group">
                        <label class="contact-label" for="txtRegRecruiterName">Contact Person / Recruiter <span style="color:#DC2626;">*</span></label>
                        <asp:TextBox ID="txtRegRecruiterName" runat="server" CssClass="contact-text-box" placeholder="Arjun Kapoor (HR Head)"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvRegRecruiterName" runat="server" ControlToValidate="txtRegRecruiterName" Enabled="false"
                            ErrorMessage="Recruiter contact name is required." Text="Recruiter contact is required." ForeColor="#DC2626"
                            Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
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
                        <asp:TextBox ID="txtRegCompAddress" runat="server" CssClass="contact-text-box" placeholder="Tower B, Phase 2, SG Highway"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvRegCompAddress" runat="server" ControlToValidate="txtRegCompAddress" Enabled="false"
                            ErrorMessage="Company office address is required." Text="Address is required." ForeColor="#DC2626"
                            Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    </div>

                    <div class="contact-input-group">
                        <label class="contact-label" for="txtRegWebsite">Company Website</label>
                        <asp:TextBox ID="txtRegWebsite" runat="server" CssClass="contact-text-box" placeholder="https://www.technova.in"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- ========================================================================= -->
            <!-- [COMMON CREDENTIALS & CONTACT (FOR BOTH ROLES)] -->
            <!-- ========================================================================= -->
            <div class="reg-section-title">
                <i class="fa-solid fa-lock"></i> Account Credentials & Contact
            </div>

            <!-- Email & Phone (2 Columns) -->
            <div class="form-2col-row">
                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegEmail" id="lblEmailTitle">Email Address <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegEmail" runat="server" CssClass="contact-text-box" placeholder="raviraj@gmail.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ErrorMessage="Email is required." Text="Email is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegEmail" runat="server" ControlToValidate="txtRegEmail"
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Enter a valid email address."
                        Text="Enter a valid email address." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgRegister"
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
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPhone" runat="server" ControlToValidate="txtRegPhone"
                        ValidationExpression="^[0-9]{10}$" ErrorMessage="Phone number must be exactly 10 digits."
                        Text="Phone number must be 10 digits." ForeColor="#DC2626" Display="Dynamic" ValidationGroup="vgRegister"
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
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revRegPassword" runat="server" ControlToValidate="txtRegPassword"
                        ValidationExpression="^.{8,}$" ErrorMessage="Password must be at least 8 characters long."
                        Text="Password must be at least 8 characters long." ForeColor="#DC2626" Display="Dynamic"
                        ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                </div>

                <div class="contact-input-group">
                    <label class="contact-label" for="txtRegCity">City <span style="color:#DC2626;">*</span></label>
                    <asp:TextBox ID="txtRegCity" runat="server" CssClass="contact-text-box" placeholder="Ahmedabad"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvRegCity" runat="server" ControlToValidate="txtRegCity"
                        ErrorMessage="City is required." Text="City is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgRegister" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
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
            <asp:Button ID="btnCreateAccount" runat="server" Text="Create Student Account" CssClass="btn-send-message-full btn-create-acct-figma" ValidationGroup="vgRegister" OnClick="btnCreateAccount_Click" />

            <!-- Footer Link -->
            <div class="login-footer-switch">
                Already have an account? <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="switch-auth-link">Login here</a>
            </div>
        </div>
    </div>

    <!-- Client-Side Role Switcher Script -->
    <script type="text/javascript">
        function switchRegRole(role) {
            var hiddenRole = document.getElementById("hiddenSelectedRole");
            var tabStudent = document.getElementById("tabStudent");
            var tabCompany = document.getElementById("tabCompany");
            var studentFields = document.getElementById("studentFieldsContainer");
            var companyFields = document.getElementById("companyFieldsContainer");
            var lblEmail = document.getElementById("lblEmailTitle");
            var txtEmail = document.getElementById("<%= txtRegEmail.ClientID %>");
            var btnSubmit = document.getElementById("<%= btnCreateAccount.ClientID %>");
            var leftTitle = document.getElementById("leftPanelTitle");
            var leftDesc = document.getElementById("leftPanelDesc");

            if (role === "Company") {
                hiddenRole.value = "Company";
                tabStudent.classList.remove("active");
                tabCompany.classList.add("active");

                studentFields.style.display = "none";
                companyFields.style.display = "block";

                if (lblEmail) lblEmail.innerHTML = 'Official Work Email Address <span style="color:#DC2626;">*</span>';
                if (txtEmail) txtEmail.placeholder = "hr@technova.in";
                if (btnSubmit) btnSubmit.value = "Register Company";
                if (leftTitle) leftTitle.innerText = "Hire Top Talent on SkillLinksX";
                if (leftDesc) leftDesc.innerText = "Connect with qualified candidates, post jobs and internships, schedule interviews, and grow your workforce.";

                // Toggle Validators
                toggleFieldValidators(true);
            } else {
                hiddenRole.value = "Student";
                tabCompany.classList.remove("active");
                tabStudent.classList.add("active");

                studentFields.style.display = "block";
                companyFields.style.display = "none";

                if (lblEmail) lblEmail.innerHTML = 'Student Email Address <span style="color:#DC2626;">*</span>';
                if (txtEmail) txtEmail.placeholder = "raviraj@gmail.com";
                if (btnSubmit) btnSubmit.value = "Create Student Account";
                if (leftTitle) leftTitle.innerText = "Join SkillLinksX";
                if (leftDesc) leftDesc.innerText = "Connect students with top companies and internships across India. Elevate your career journey today.";

                // Toggle Validators
                toggleFieldValidators(false);
            }
        }

        function toggleFieldValidators(isCompany) {
            if (typeof ValidatorEnable === "function") {
                var vFullName = document.getElementById("<%= rfvRegFullName.ClientID %>");
                var vCollege = document.getElementById("<%= rfvRegCollege.ClientID %>");
                var vGradYear = document.getElementById("<%= rfvGradYear.ClientID %>");

                var vCompName = document.getElementById("<%= rfvRegCompName.ClientID %>");
                var vRecruiter = document.getElementById("<%= rfvRegRecruiterName.ClientID %>");
                var vAddress = document.getElementById("<%= rfvRegCompAddress.ClientID %>");

                if (vFullName) ValidatorEnable(vFullName, !isCompany);
                if (vCollege) ValidatorEnable(vCollege, !isCompany);
                if (vGradYear) ValidatorEnable(vGradYear, !isCompany);

                if (vCompName) ValidatorEnable(vCompName, isCompany);
                if (vRecruiter) ValidatorEnable(vRecruiter, isCompany);
                if (vAddress) ValidatorEnable(vAddress, isCompany);
            }
        }

        // Initialize state on page load
        document.addEventListener("DOMContentLoaded", function () {
            var hiddenRole = document.getElementById("hiddenSelectedRole");
            if (hiddenRole && hiddenRole.value === "Company") {
                switchRegRole("Company");
            } else {
                switchRegRole("Student");
            }
        });
    </script>
</asp:Content>
