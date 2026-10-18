<%@ Page Title="Contact Us - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Public.Master"
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="SkillLinksX.Public.Contact" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <!-- Contact Page Title & Metadata -->
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="contact-page-wrapper">

            <!-- 1. Header Intro -->
            <div class="contact-header-section">
                <h1 class="contact-main-heading">Let's Connect</h1>
                <p class="contact-sub-heading">Have a question or feedback? We'd love to hear from you. Get in touch with our team.</p>
            </div>

            <!-- 2. Top 3 Cards Grid -->
            <div class="contact-top-grid">
                <!-- Card 1: Email Support -->
                <div class="contact-top-card">
                    <div class="contact-top-icon-box">
                        <i class="fa-regular fa-envelope"></i>
                    </div>
                    <h3 class="contact-top-card-title">Email Support</h3>
                    <p class="contact-top-card-desc">Reach our team 24/7 for account and general queries.</p>
                    <a href="mailto:support@skilllinkx.com" class="contact-top-card-link">support@skilllinkx.com</a>
                </div>

                <!-- Card 2: Business Inquiries -->
                <div class="contact-top-card">
                    <div class="contact-top-icon-box">
                        <i class="fa-solid fa-briefcase"></i>
                    </div>
                    <h3 class="contact-top-card-title">Business Inquiries</h3>
                    <p class="contact-top-card-desc">Partner with us or explore enterprise hiring solutions.</p>
                    <a href="mailto:business@skilllinkx.com" class="contact-top-card-link">business@skilllinkx.com</a>
                </div>

                <!-- Card 3: Career Support -->
                <div class="contact-top-card">
                    <div class="contact-top-icon-box">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>
                    <h3 class="contact-top-card-title">Career Support</h3>
                    <p class="contact-top-card-desc">Get assistance with internships, applications, and guidance.</p>
                    <a href="mailto:careers@skilllinkx.com" class="contact-top-card-link">careers@skilllinkx.com</a>
                </div>
            </div>

            <!-- 3. Send Us a Message & How Can We Help Grid -->
            <div class="contact-split-grid">
                <!-- Left: Form -->
                <div class="contact-form-panel">
                    <h2 class="form-header-title">Send Us a Message</h2>

                    <asp:Label ID="lblStatusMessage" runat="server" Visible="false"
                        CssClass="form-status-alert success"></asp:Label>
                    <asp:ValidationSummary ID="valSummaryContact" runat="server" CssClass="validation-summary-box"
                        HeaderText="Please fix the following:" ForeColor="#B91C1C" ValidationGroup="vgContact" />

                    <!-- Full Name -->
                    <div class="contact-input-group">
                        <label class="contact-label" for="txtName">Full Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="contact-text-box"
                            placeholder="Mahek Godvani"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                            ErrorMessage="Full Name is required." Text="Full Name is required." ForeColor="#DC2626" Display="Dynamic"
                            ValidationGroup="vgContact" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    </div>

                    <!-- Email Address -->
                    <div class="contact-input-group">
                        <label class="contact-label" for="txtEmail">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="contact-text-box"
                            placeholder="godvanimahek@gmail.com"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email is required." Text="Email is required." ForeColor="#DC2626" Display="Dynamic"
                            ValidationGroup="vgContact" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Enter a valid email address."
                            Text="Enter a valid email address." ForeColor="#DC2626" Display="Dynamic"
                            ValidationGroup="vgContact" CssClass="field-validation-error-msg"></asp:RegularExpressionValidator>
                    </div>

                    <!-- I am a (Dropdown) -->
                    <div class="contact-input-group">
                        <label class="contact-label" for="ddlRole">I am a</label>
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="contact-select-box">
                            <asp:ListItem Value="Student">Student</asp:ListItem>
                            <asp:ListItem Value="Professional">Professional</asp:ListItem>
                            <asp:ListItem Value="Company">Company / Recruiter</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Subject -->
                    <div class="contact-input-group">
                        <label class="contact-label" for="txtSubject">Subject</label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="contact-text-box"
                            placeholder="How can we help?"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject"
                            ErrorMessage="Subject is required." Text="Subject is required." ForeColor="#DC2626" Display="Dynamic"
                            ValidationGroup="vgContact" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    </div>

                    <!-- Message -->
                    <div class="contact-input-group">
                        <label class="contact-label" for="txtMessage">Message</label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="4"
                            CssClass="contact-textarea-box" placeholder="Your message here..."></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage"
                            ErrorMessage="Message is required." Text="Message is required." ForeColor="#DC2626" Display="Dynamic"
                            ValidationGroup="vgContact" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                    </div>

                    <!-- Terms Checkbox -->
                    <div class="contact-checkbox-row">
                        <asp:CheckBox ID="chkAgreeTerms" runat="server" Text="" />
                        <label for="chkAgreeTerms" class="checkbox-text-label">
                            I agree to the <a href="<%= ResolveUrl("~/Public/Privacy.aspx") %>" class="legal-blue-link">Privacy Policy</a> and <a href="<%= ResolveUrl("~/Public/Terms.aspx") %>" class="legal-blue-link">Terms of Service</a>.
                        </label>
                    </div>

                    <!-- Submit Button -->
                    <asp:Button ID="btnSendMessage" runat="server" Text="Send Message" CssClass="btn-send-message-full"
                        ValidationGroup="vgContact" OnClick="btnSendMessage_Click" />
                </div>

                <!-- Right: How Can We Help & Image -->
                <div class="contact-side-column">
                    <!-- How Can We Help Card -->
                    <div class="how-help-card">
                        <h3 class="how-help-title">How Can We Help?</h3>
                        <ul class="how-help-list">
                            <li><i class="fa-regular fa-circle-check" style="color:#0052CC;"></i> Account & Profile</li>
                            <li><i class="fa-regular fa-circle-check" style="color:#0052CC;"></i> Job & Internship matching</li>
                            <li><i class="fa-regular fa-circle-check" style="color:#0052CC;"></i> Recruiter onboarding</li>
                            <li><i class="fa-regular fa-circle-check" style="color:#0052CC;"></i> Technical support</li>
                            <li><i class="fa-regular fa-circle-check" style="color:#0052CC;"></i> Strategic Partnerships</li>
                        </ul>
                    </div>

                    <!-- Office Banner Image Card -->
                    <div class="office-banner-card">
                        <img src='<%= ResolveUrl("~/assets/images/contact-us image.jpg") %>'
                            alt="Empowering Your Career Journey" class="office-banner-img" />
                        <div class="office-banner-overlay-text">Empowering Your Career Journey</div>
                    </div>
                </div>
            </div>

            <!-- 4. Where We Work Section -->
            <div class="where-work-wrapper">
                <h2 class="where-work-main-title">Where We Work</h2>
                <div class="where-work-card-container">
                    <div class="where-work-details">
                        <div class="office-pin-title">
                            <i class="fa-solid fa-location-dot"></i> Ahmedabad, India (HQ)
                        </div>
                        <div class="office-address-lines">
                            SkillLinkX Headquarters<br />
                            SG Highway, Bodakdev,<br />
                            Ahmedabad, Gujarat 380054
                        </div>
                        <div class="office-meta-row">
                            <i class="fa-regular fa-clock"></i> Mon - Fri, 9:00 AM - 6:00 PM IST
                        </div>
                        <div class="office-meta-row">
                            <i class="fa-solid fa-phone"></i> +91 79 4000 1234
                        </div>
                    </div>
                    <div class="where-work-map-box">
                        <img src='<%= ResolveUrl("~/assets/images/ahemdabad.png") %>'
                            alt="Ahmedabad Office Map" class="where-work-map-img" />
                    </div>
                </div>
            </div>

            <!-- 5. Frequently Asked Questions Section -->
            <div class="faq-outer-section">
                <h2 class="faq-section-title">Frequently Asked Questions</h2>
                <div class="faq-accordion-container">
                    <div class="faq-bar-item">
                        <div class="faq-bar-header">
                            <span>How do I create a student account?</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="faq-bar-body">
                            Click on the "Register" button in the navigation header, select the "Student" account type, fill in your personal details, education background, and password, then submit to create your free account.
                        </div>
                    </div>

                    <div class="faq-bar-item">
                        <div class="faq-bar-header">
                            <span>How do companies post internships or jobs?</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="faq-bar-body">
                            Recruiters and companies can register with a Company account. Once verified, you can access your recruiter dashboard to post open roles, manage candidate applications, and schedule interviews.
                        </div>
                    </div>

                    <div class="faq-bar-item">
                        <div class="faq-bar-header">
                            <span>Is SkillLinkX free to use?</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="faq-bar-body">
                            Yes, SkillLinkX is completely free for students and job seekers to browse opportunities, build their profiles, and apply for verified positions and internships.
                        </div>
                    </div>

                    <div class="faq-bar-item">
                        <div class="faq-bar-header">
                            <span>How does the AI Career Assistant work?</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="faq-bar-body">
                            Our AI Career Assistant analyzes your profile, skills, and preferences to recommend tailored job matches, suggest skill enhancements, and optimize your application readiness.
                        </div>
                    </div>

                    <div class="faq-bar-item">
                        <div class="faq-bar-header">
                            <span>How can I reset my forgotten password?</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="faq-bar-body">
                            Go to the Login page and click "Forgot Password?". Enter your registered email address, and a secure password recovery link will be sent to your inbox.
                        </div>
                    </div>

                    <div class="faq-bar-item">
                        <div class="faq-bar-header">
                            <span>How can our college partner with SkillLinkX?</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="faq-bar-body">
                            Educational institutions can partner with SkillLinkX by reaching out via business@skilllinkx.com or filling out our contact form with the "Company / Recruiter" role.
                        </div>
                    </div>

                    <div class="faq-bar-item">
                        <div class="faq-bar-header">
                            <span>What should I do if I experience technical issues?</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="faq-bar-body">
                            You can submit a message using the form above under "Technical support" or directly email support@skilllinkx.com. Our engineering support team responds within 24 hours.
                        </div>
                    </div>
                </div>
            </div>

            <!-- 6. Need Help With Your Career? Card -->
            <div class="career-help-card-box">
                <h3 class="career-help-heading">Need Help With Your Career?</h3>
                <div class="career-help-btn-row">
                    <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="btn-career-blue">Explore Jobs</a>
                    <a href="<%= ResolveUrl("~/Public/Login.aspx") %>" class="btn-career-white-outline">AI Career Assistant</a>
                </div>
                <div class="career-social-text">Follow SkillLinkX</div>
                <div class="career-social-icons">
                    <a href="#" class="social-box-icon"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#" class="social-box-icon"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="social-box-icon"><i class="fa-brands fa-x-twitter"></i></a>
                </div>
            </div>

        </div>
    </asp:Content>