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

        <!-- =====================================================================
             [STATUS & FEEDBACK ALERT]: Displays success or error messages
             ===================================================================== -->
        <asp:Label ID="lblPostStatus" runat="server" style="display:block; margin: 10px 0; font-size:14px; font-weight:600;" EnableViewState="false" />

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
                    <label class="form-label" id="lblCompensationTitle">Salary Range (&#8377;)</label>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <asp:TextBox ID="txtSalaryMin" runat="server" CssClass="form-control-input" placeholder="Min"
                            TextMode="Number" min="0" step="1"
                            oninput="this.value = this.value.replace(/[^0-9]/g, '');"
                            onkeypress="return (event.charCode >= 48 && event.charCode <= 57);"></asp:TextBox>
                        <span style="color:#94A3B8;">-</span>
                        <asp:TextBox ID="txtSalaryMax" runat="server" CssClass="form-control-input" placeholder="Max"
                            TextMode="Number" min="0" step="1"
                            oninput="this.value = this.value.replace(/[^0-9]/g, '');"
                            onkeypress="return (event.charCode >= 48 && event.charCode <= 57);"></asp:TextBox>
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
                <label class="form-label">Required Skills (Comma-separated)</label>
                <!-- =============================================================
                     [DYNAMIC SKILLS INPUT]: Direct server control for job skills
                     ============================================================= -->
                <asp:TextBox ID="txtRequiredSkills" runat="server" CssClass="form-control-input" placeholder="e.g. C#, ASP.NET, SQL Server, React"></asp:TextBox>
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
                <asp:Button ID="btnSaveDraft" runat="server" Text="Save as Draft" CssClass="btn-post-draft" CausesValidation="false" OnClick="btnSaveDraft_Click" />
                <button type="button" class="btn-post-preview" onclick="openJobPreviewModal();">Preview</button>
                <asp:Button ID="btnPublishOpportunity" runat="server" Text="Publish Opportunity"
                    CssClass="btn-post-publish" ValidationGroup="vgPostOpportunity" OnClick="btnPublishOpportunity_Click" OnClientClick="scrollToFirstInvalid();" />
            </div>
        </div>

        <!-- =============================================================
             [PREVIEW MODAL]: Interactive live preview of the opportunity
             ============================================================= -->
        <div id="jobPreviewModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(15,23,42,0.6); z-index:99999; align-items:center; justify-content:center; padding:20px; backdrop-filter:blur(3px);">
            <div style="background:#FFFFFF; border-radius:12px; width:100%; max-width:680px; max-height:90vh; overflow-y:auto; box-shadow:0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04); border:1px solid #E2E8F0;">
                <div style="display:flex; align-items:center; justify-content:space-between; padding:18px 24px; border-bottom:1px solid #E2E8F0;">
                    <div style="display:flex; align-items:center; gap:10px;">
                        <span style="background:#EEF2FF; color:#4F46E5; font-size:12px; font-weight:700; padding:4px 10px; border-radius:6px; letter-spacing:0.5px;">PREVIEW MODE</span>
                        <h3 style="font-size:17px; font-weight:700; color:#0F172A; margin:0;">Opportunity Preview</h3>
                    </div>
                    <button type="button" onclick="closeJobPreviewModal();" style="background:none; border:none; font-size:18px; color:#64748B; cursor:pointer; padding:4px 8px;">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>
                <div style="padding:24px;">
                    <h2 id="prevTitle" style="font-size:22px; font-weight:700; color:#0F172A; margin:0 0 8px 0;">Opportunity Title</h2>
                    <div style="display:flex; flex-wrap:wrap; gap:8px; margin-bottom:18px;">
                        <span id="prevOppTypeBadge" style="background:#EFF6FF; color:#0052CC; font-size:12px; font-weight:600; padding:4px 10px; border-radius:4px;">Full-time</span>
                        <span id="prevWorkTypeBadge" style="background:#F1F5F9; color:#475569; font-size:12px; font-weight:600; padding:4px 10px; border-radius:4px;">Hybrid</span>
                        <span id="prevExpBadge" style="background:#F1F5F9; color:#475569; font-size:12px; font-weight:600; padding:4px 10px; border-radius:4px;">0-2 Years</span>
                        <span id="prevDeptBadge" style="background:#F1F5F9; color:#475569; font-size:12px; font-weight:600; padding:4px 10px; border-radius:4px;">Engineering</span>
                    </div>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px; background:#F8FAFC; border:1px solid #E2E8F0; border-radius:8px; padding:14px 18px; margin-bottom:20px;">
                        <div>
                            <span style="display:block; font-size:12px; color:#64748B; margin-bottom:2px;">Location</span>
                            <strong id="prevLocation" style="font-size:13.5px; color:#0F172A;">Bengaluru, Karnataka, India</strong>
                        </div>
                        <div>
                            <span style="display:block; font-size:12px; color:#64748B; margin-bottom:2px;">Compensation</span>
                            <strong id="prevCompensation" style="font-size:13.5px; color:#059669;">₹4,00,000 - ₹8,00,000 / year</strong>
                        </div>
                    </div>

                    <div style="margin-bottom:18px;">
                        <h4 style="font-size:14px; font-weight:700; color:#0F172A; margin:0 0 6px 0;">About the Role</h4>
                        <p id="prevDescription" style="font-size:13.5px; color:#475569; line-height:1.6; margin:0; white-space:pre-wrap;">Job description will appear here...</p>
                    </div>

                    <div style="margin-bottom:20px;">
                        <h4 style="font-size:14px; font-weight:700; color:#0F172A; margin:0 0 8px 0;">Required Skills</h4>
                        <div id="prevSkillsContainer" style="display:flex; flex-wrap:wrap; gap:6px;">
                            <span style="background:#F1F5F9; color:#334155; font-size:12px; padding:3px 10px; border-radius:4px;">General</span>
                        </div>
                    </div>
                </div>
                <div style="display:flex; align-items:center; justify-content:flex-end; gap:10px; padding:14px 24px; border-top:1px solid #E2E8F0; background:#F8FAFC; border-radius:0 0 12px 12px;">
                    <button type="button" onclick="closeJobPreviewModal();" style="padding:9px 18px; background:#FFFFFF; border:1px solid #CBD5E1; color:#334155; font-size:13px; font-weight:600; border-radius:6px; cursor:pointer;">Close Preview</button>
                    <button type="button" onclick="closeJobPreviewModal(); document.getElementById('<%= btnPublishOpportunity.ClientID %>').click();" style="padding:9px 20px; background:#0052CC; border:none; color:#FFFFFF; font-size:13px; font-weight:600; border-radius:6px; cursor:pointer;">Publish Now</button>
                </div>
            </div>
        </div>

    </div>

    <!-- Client-Side Form Scripts: Auto-scroll on validation error & Live Preview Modal -->
    <script type="text/javascript">
        function scrollToFirstInvalid() {
            setTimeout(function () {
                if (typeof Page_Validators !== "undefined" && Page_Validators) {
                    for (var i = 0; i < Page_Validators.length; i++) {
                        var val = Page_Validators[i];
                        if (val && !val.isvalid) {
                            var ctrl = document.getElementById(val.controltovalidate);
                            if (ctrl) {
                                ctrl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                                ctrl.focus();
                                ctrl.style.borderColor = "#DC2626";
                                ctrl.style.boxShadow = "0 0 0 3px rgba(220, 38, 38, 0.15)";
                                setTimeout(function () {
                                    ctrl.style.borderColor = "";
                                    ctrl.style.boxShadow = "";
                                }, 3000);
                                return;
                            }
                        }
                    }
                }
            }, 100);
        }

        function openJobPreviewModal() {
            var title = document.getElementById('<%= txtJobTitle.ClientID %>')?.value.trim() || "Untitled Opportunity";
            var empType = document.getElementById('<%= ddlEmploymentType.ClientID %>')?.value || "Full-time";
            var expLevel = document.getElementById('<%= ddlExperienceLevel.ClientID %>')?.value || "Not Specified";
            var dept = document.getElementById('<%= ddlDepartment.ClientID %>')?.value || "General";
            var hfWork = document.getElementById('<%= hfWorkType.ClientID %>')?.value || "Hybrid";

            var city = document.getElementById('<%= ddlCity.ClientID %>')?.value || "";
            var state = document.getElementById('<%= ddlState.ClientID %>')?.value || "";
            var country = document.getElementById('<%= ddlCountry.ClientID %>')?.value || "India";
            var locationParts = [city, state, country].filter(Boolean).join(", ") || "Remote / India";

            var sMin = document.getElementById('<%= txtSalaryMin.ClientID %>')?.value.trim();
            var sMax = document.getElementById('<%= txtSalaryMax.ClientID %>')?.value.trim();
            var period = document.getElementById('<%= ddlSalaryPeriod.ClientID %>')?.value || "Per Year";
            var compText = (sMin && sMax) ? ("₹" + Number(sMin).toLocaleString('en-IN') + " - ₹" + Number(sMax).toLocaleString('en-IN') + " " + period) : "Best in Industry";

            var desc = document.getElementById('<%= txtJobDescription.ClientID %>')?.value.trim() || "No description provided yet.";
            var skills = document.getElementById('<%= txtRequiredSkills.ClientID %>')?.value.trim() || "General";

            document.getElementById("prevTitle").innerText = title;
            document.getElementById("prevOppTypeBadge").innerText = empType;
            document.getElementById("prevWorkTypeBadge").innerText = hfWork;
            document.getElementById("prevExpBadge").innerText = expLevel;
            document.getElementById("prevDeptBadge").innerText = dept;
            document.getElementById("prevLocation").innerText = locationParts;
            document.getElementById("prevCompensation").innerText = compText;
            document.getElementById("prevDescription").innerText = desc;

            var skillsContainer = document.getElementById("prevSkillsContainer");
            if (skillsContainer) {
                skillsContainer.innerHTML = "";
                skills.split(',').forEach(function (s) {
                    var trimmed = s.trim();
                    if (trimmed) {
                        var pill = document.createElement("span");
                        pill.style.cssText = "background:#F1F5F9; color:#334155; font-size:12px; font-weight:500; padding:3px 10px; border-radius:4px;";
                        pill.innerText = trimmed;
                        skillsContainer.appendChild(pill);
                    }
                });
            }

            var modal = document.getElementById("jobPreviewModal");
            if (modal) modal.style.display = "flex";
        }

        function closeJobPreviewModal() {
            var modal = document.getElementById("jobPreviewModal");
            if (modal) modal.style.display = "none";
        }
    </script>
</asp:Content>
