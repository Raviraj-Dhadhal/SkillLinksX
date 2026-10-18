<%@ Page Title="Create a New Opportunity - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="PostJob.aspx.cs" Inherits="SkillLinksX.Company.PostJob" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Post Job Specific Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="post-opp-container">
        
        <!-- Header -->
        <div class="post-opp-header">
            <h1 class="post-opp-title">Create a New Opportunity</h1>
            <p class="post-opp-sub">Post a job or internship and connect with the right talent.</p>
        </div>

        <!-- Hidden field to hold selected Opportunity Type and Work Type -->
        <asp:HiddenField ID="hfOpportunityType" runat="server" Value="Job" />
        <asp:HiddenField ID="hfWorkType" runat="server" Value="Hybrid" />

        <!-- 1. Opportunity Type -->
        <div class="form-step-card">
            <div class="form-step-header">
                <div class="form-step-num">1</div>
                <h2 class="form-step-title">Opportunity Type</h2>
            </div>
            <div class="pill-selector-row" id="oppTypeSelector">
                <button type="button" class="pill-btn active" data-type="Job" id="btnTypeJob">
                    <i class="fa-solid fa-briefcase"></i> Job
                </button>
                <button type="button" class="pill-btn" data-type="Internship" id="btnTypeInternship">
                    <i class="fa-solid fa-graduation-cap"></i> Internship
                </button>
            </div>
        </div>

        <!-- 2. Basic Information -->
        <div class="form-step-card">
            <div class="form-step-header">
                <div class="form-step-num">2</div>
                <h2 class="form-step-title">Basic Information</h2>
            </div>
            
            <div class="form-group-item">
                <label class="form-label" for="<%= txtJobTitle.ClientID %>">Job / Internship Title <span class="req-star">*</span></label>
                <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control-input" placeholder="e.g. Senior Frontend Developer"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvJobTitle" runat="server" ControlToValidate="txtJobTitle"
                    ErrorMessage="Job or internship title is required." Text="Title is required." ForeColor="#DC2626"
                    Display="Dynamic" ValidationGroup="vgPostOpportunity" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
            </div>

            <div class="form-2col-row">
                <div class="form-group-item">
                    <label class="form-label" for="<%= ddlDepartment.ClientID %>">Department</label>
                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-control-select">
                        <asp:ListItem Value="">Select Department</asp:ListItem>
                        <asp:ListItem Value="Engineering">Engineering</asp:ListItem>
                        <asp:ListItem Value="Product Design">Product Design</asp:ListItem>
                        <asp:ListItem Value="Marketing">Marketing</asp:ListItem>
                        <asp:ListItem Value="Data Science">Data Science</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group-item">
                    <label class="form-label" for="<%= ddlEmploymentType.ClientID %>">Employment Type <span class="req-star">*</span></label>
                    <asp:DropDownList ID="ddlEmploymentType" runat="server" CssClass="form-control-select">
                        <asp:ListItem Value="">Select Type</asp:ListItem>
                        <asp:ListItem Value="Full-time">Full-time</asp:ListItem>
                        <asp:ListItem Value="Part-time">Part-time</asp:ListItem>
                        <asp:ListItem Value="Contract">Contract</asp:ListItem>
                        <asp:ListItem Value="Internship">Internship</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvEmploymentType" runat="server" ControlToValidate="ddlEmploymentType" InitialValue=""
                        ErrorMessage="Employment type is required." Text="Employment type is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgPostOpportunity" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-3col-row">
                <div class="form-group-item">
                    <label class="form-label" for="<%= ddlExperienceLevel.ClientID %>">Experience Level <span class="req-star">*</span></label>
                    <asp:DropDownList ID="ddlExperienceLevel" runat="server" CssClass="form-control-select">
                        <asp:ListItem Value="">Select Experience</asp:ListItem>
                        <asp:ListItem Value="Entry Level (0-2 yrs)">Entry Level (0-2 yrs)</asp:ListItem>
                        <asp:ListItem Value="Mid Level (2-5 yrs)">Mid Level (2-5 yrs)</asp:ListItem>
                        <asp:ListItem Value="Senior Level (5+ yrs)">Senior Level (5+ yrs)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvExperienceLevel" runat="server" ControlToValidate="ddlExperienceLevel" InitialValue=""
                        ErrorMessage="Experience level is required." Text="Experience level is required." ForeColor="#DC2626"
                        Display="Dynamic" ValidationGroup="vgPostOpportunity" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group-item">
                    <label class="form-label" for="<%= txtOpenings.ClientID %>">Number of Openings</label>
                    <asp:TextBox ID="txtOpenings" runat="server" TextMode="Number" CssClass="form-control-input" Text="1"></asp:TextBox>
                </div>
                <div class="form-group-item">
                    <label class="form-label" for="<%= txtDeadline.ClientID %>">Application Deadline</label>
                    <asp:TextBox ID="txtDeadline" runat="server" TextMode="Date" CssClass="form-control-input"></asp:TextBox>
                </div>
            </div>
        </div>

        <!-- 3. Location & Work Type -->
        <div class="form-step-card">
            <div class="form-step-header">
                <div class="form-step-num">3</div>
                <h2 class="form-step-title">Location &amp; Work Type</h2>
            </div>

            <div class="form-group-item">
                <label class="form-label">Work Type <span class="req-star">*</span></label>
                <div class="pill-selector-3col" id="workTypeSelector">
                    <button type="button" class="pill-btn" data-work="Remote">Remote</button>
                    <button type="button" class="pill-btn active" data-work="Hybrid">Hybrid</button>
                    <button type="button" class="pill-btn" data-work="On-site">On-site</button>
                </div>
            </div>

            <div class="form-2col-row">
                <div class="form-group-item">
                    <label class="form-label" for="<%= ddlCountry.ClientID %>">Country</label>
                    <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control-select">
                        <asp:ListItem Value="India" Selected="True">India</asp:ListItem>
                        <asp:ListItem Value="United States">United States</asp:ListItem>
                        <asp:ListItem Value="United Kingdom">United Kingdom</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group-item">
                    <label class="form-label" for="<%= ddlState.ClientID %>">State</label>
                    <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control-select">
                        <asp:ListItem Value="">Select State</asp:ListItem>
                        <asp:ListItem Value="Karnataka" Selected="True">Karnataka</asp:ListItem>
                        <asp:ListItem Value="Gujarat">Gujarat</asp:ListItem>
                        <asp:ListItem Value="Maharashtra">Maharashtra</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="form-2col-row" style="margin-bottom:0;">
                <div class="form-group-item">
                    <label class="form-label" for="<%= ddlCity.ClientID %>">City</label>
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control-select">
                        <asp:ListItem Value="">Select City</asp:ListItem>
                        <asp:ListItem Value="Bengaluru" Selected="True">Bengaluru</asp:ListItem>
                        <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                        <asp:ListItem Value="Ahmedabad">Ahmedabad</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group-item">
                    <label class="form-label" for="<%= txtOfficeLocation.ClientID %>">Office Location</label>
                    <asp:TextBox ID="txtOfficeLocation" runat="server" CssClass="form-control-input" placeholder="e.g. HQ Building A"></asp:TextBox>
                </div>
            </div>
        </div>

        <!-- 4. Compensation -->
        <div class="form-step-card">
            <div class="form-step-header">
                <div class="form-step-num">4</div>
                <h2 class="form-step-title">Compensation</h2>
            </div>

            <div class="form-2col-row" style="margin-bottom:0;">
                <div class="form-group-item">
                    <label class="form-label">Salary Range (&#8377;)</label>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <asp:TextBox ID="txtSalaryMin" runat="server" CssClass="form-control-input" placeholder="Min"></asp:TextBox>
                        <span style="color:#94A3B8;">-</span>
                        <asp:TextBox ID="txtSalaryMax" runat="server" CssClass="form-control-input" placeholder="Max"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group-item">
                    <label class="form-label" for="<%= ddlSalaryPeriod.ClientID %>">Period</label>
                    <asp:DropDownList ID="ddlSalaryPeriod" runat="server" CssClass="form-control-select">
                        <asp:ListItem Value="Per Year" Selected="True">Per Year</asp:ListItem>
                        <asp:ListItem Value="Per Month">Per Month</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <!-- 5. Description & Qualifications -->
        <div class="form-step-card">
            <div class="form-step-header">
                <div class="form-step-num">5</div>
                <h2 class="form-step-title">Description &amp; Qualifications</h2>
            </div>

            <div class="form-group-item">
                <label class="form-label" for="<%= txtJobDescription.ClientID %>">Job Description <span class="req-star">*</span></label>
                <!-- Clean, simple text box without B I toolbar buttons -->
                <asp:TextBox ID="txtJobDescription" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control-input" 
                    style="min-height: 120px; font-family: inherit; resize: vertical;" 
                    placeholder="Describe the role, responsibilities, and impact..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvJobDescription" runat="server" ControlToValidate="txtJobDescription"
                    ErrorMessage="Job description is required." Text="Description is required." ForeColor="#DC2626"
                    Display="Dynamic" ValidationGroup="vgPostOpportunity" CssClass="field-validation-error-msg"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group-item">
                <label class="form-label">Required Skills</label>
                <div class="skills-input-wrapper">
                    <div class="skills-tags-list" id="skillsTagList">
                        <span class="skill-tag-pill">React <i class="fa-solid fa-xmark" onclick="this.parentElement.remove()"></i></span>
                        <span class="skill-tag-pill">TypeScript <i class="fa-solid fa-xmark" onclick="this.parentElement.remove()"></i></span>
                        <span class="skill-tag-pill">Tailwind CSS <i class="fa-solid fa-xmark" onclick="this.parentElement.remove()"></i></span>
                    </div>
                    <div class="skills-input-bottom-row">
                        <input type="text" id="inputNewSkill" class="skills-add-input" placeholder="Type a skill and press Enter" />
                        <button type="button" id="btnAddSkill" class="btn-add-skill-tag">Add Skill</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 6. Benefits & Perks -->
        <div class="form-step-card">
            <div class="form-step-header">
                <div class="form-step-num">6</div>
                <h2 class="form-step-title">Benefits &amp; Perks</h2>
            </div>

            <div class="benefits-checkbox-grid">
                <label class="benefit-checkbox-tile">
                    <input type="checkbox" />
                    <span>Health Insurance</span>
                </label>
                <label class="benefit-checkbox-tile checked">
                    <input type="checkbox" checked="checked" />
                    <span>Flexible Work Hours</span>
                </label>
                <label class="benefit-checkbox-tile">
                    <input type="checkbox" />
                    <span>Paid Time Off (PTO)</span>
                </label>
                <label class="benefit-checkbox-tile">
                    <input type="checkbox" />
                    <span>Learning Budget</span>
                </label>
                <label class="benefit-checkbox-tile">
                    <input type="checkbox" />
                    <span>Remote Work Options</span>
                </label>
            </div>
        </div>

        <!-- 7. Hiring Process -->
        <div class="form-step-card">
            <div class="form-step-header">
                <div class="form-step-num">7</div>
                <h2 class="form-step-title">Hiring Process</h2>
            </div>
            <p style="font-size:12.5px; color:#64748B; margin-bottom:14px;">Select the stages candidates will go through for this role.</p>

            <div class="process-steps-list">
                <div class="process-step-row">
                    <div class="process-step-left">
                        <input type="checkbox" checked="checked" />
                        <span>Application Screening</span>
                    </div>
                    <span class="process-step-right-badge">Required</span>
                </div>
                <div class="process-step-row">
                    <div class="process-step-left">
                        <input type="checkbox" checked="checked" />
                        <span>Initial HR Call</span>
                    </div>
                </div>
                <div class="process-step-row">
                    <div class="process-step-left">
                        <input type="checkbox" checked="checked" />
                        <span>Online Assessment / Take-home Task</span>
                    </div>
                </div>
                <div class="process-step-row">
                    <div class="process-step-left">
                        <input type="checkbox" checked="checked" />
                        <span>Technical Interview</span>
                    </div>
                </div>
                <div class="process-step-row">
                    <div class="process-step-left">
                        <input type="checkbox" />
                        <span>Culture Fit / Final Interview</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 8. AI Candidate Matching Callout -->
        <div class="ai-matching-callout">
            <div class="ai-matching-top">
                <div class="ai-matching-title-box">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                    <span>AI Candidate Matching</span>
                    <span class="ai-beta-tag">BETA</span>
                </div>
                <label style="cursor:pointer; display:inline-flex; align-items:center;">
                    <input type="checkbox" checked="checked" style="accent-color: #4F46E5; width:18px; height:18px;" />
                </label>
            </div>
            <p class="ai-matching-sub">
                Automatically match and rank existing candidates in our talent pool based on your requirements.
            </p>
            <div>
                <div class="ai-score-label-row">
                    <span>Required Minimum Match Score: <strong style="color:#312E81;">75%</strong></span>
                </div>
                <div class="ai-score-slider-track">
                    <div class="ai-score-slider-fill" style="width: 75%;"></div>
                </div>
                <div class="ai-slider-minmax-row">
                    <span>Loose (50%)</span>
                    <span>Strict (90%)</span>
                </div>
            </div>
        </div>

        <!-- Footer Actions Bar -->
        <div class="post-opp-footer">
            <a href="<%= ResolveUrl("~/Company/Dashboard.aspx") %>" class="btn-post-cancel">Cancel</a>
            <div class="post-footer-right-buttons">
                <button type="button" class="btn-post-draft">Save as Draft</button>
                <button type="button" class="btn-post-preview">Preview</button>
                <asp:Button ID="btnPublishOpportunity" runat="server" Text="Publish Opportunity"
                    CssClass="btn-post-publish" ValidationGroup="vgPostOpportunity" OnClick="btnPublishOpportunity_Click" />
            </div>
        </div>

    </div>

    <!-- Interactive script for Opportunity Type, Work Type, and Skill Tags -->
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            // 1. Opportunity Type Toggle (Job / Internship)
            const oppButtons = document.querySelectorAll("#oppTypeSelector .pill-btn");
            const hfOppType = document.getElementById("<%= hfOpportunityType.ClientID %>");
            oppButtons.forEach(function (btn) {
                btn.addEventListener("click", function () {
                    oppButtons.forEach(b => b.classList.remove("active"));
                    btn.classList.add("active");
                    if (hfOppType) {
                        hfOppType.value = btn.getAttribute("data-type");
                    }
                });
            });

            // 2. Work Type Toggle (Remote / Hybrid / On-site)
            const workButtons = document.querySelectorAll("#workTypeSelector .pill-btn");
            const hfWorkType = document.getElementById("<%= hfWorkType.ClientID %>");
            workButtons.forEach(function (btn) {
                btn.addEventListener("click", function () {
                    workButtons.forEach(b => b.classList.remove("active"));
                    btn.classList.add("active");
                    if (hfWorkType) {
                        hfWorkType.value = btn.getAttribute("data-work");
                    }
                });
            });

            // 3. Add Skill Tag
            const inputSkill = document.getElementById("inputNewSkill");
            const btnAddSkill = document.getElementById("btnAddSkill");
            const skillsList = document.getElementById("skillsTagList");

            function addSkillTag() {
                if (!inputSkill || !skillsList) return;
                const val = inputSkill.value.trim();
                if (val) {
                    const span = document.createElement("span");
                    span.className = "skill-tag-pill";
                    span.innerHTML = val + ' <i class="fa-solid fa-xmark"></i>';
                    span.querySelector("i").addEventListener("click", function () {
                        span.remove();
                    });
                    skillsList.appendChild(span);
                    inputSkill.value = "";
                }
            }

            if (btnAddSkill) {
                btnAddSkill.addEventListener("click", addSkillTag);
            }
            if (inputSkill) {
                inputSkill.addEventListener("keydown", function (e) {
                    if (e.key === "Enter") {
                        e.preventDefault();
                        addSkillTag();
                    }
                });
            }
        });
    </script>
</asp:Content>
