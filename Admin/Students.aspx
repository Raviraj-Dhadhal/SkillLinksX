<%@ Page Title="Manage Students - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="SkillLinksX.Admin.Students" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Students Head Styling -->
    <style>
        .badge-status-active {
            background-color: #ECFDF5;
            color: #065F46;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .badge-status-pending {
            background-color: #FEF3C7;
            color: #92400E;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .badge-status-suspended {
            background-color: #FEE2E2;
            color: #991B1B;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .student-row {
            cursor: pointer;
            transition: background 0.15s ease;
        }
        .student-row:hover {
            background-color: #F8FAFC;
        }
        .student-row.selected, .student-row.active-row {
            background-color: #EFF6FF !important;
        }
        .btn-filter-clear-link {
            display: inline-flex;
            align-items: center;
            padding: 7px 16px;
            background: #F1F5F9;
            color: #475569;
            font-size: 12.5px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-filter-clear-link:hover {
            background: #E2E8F0;
            color: #0F172A;
        }
        .btn-status-toggle {
            display: inline-flex;
            align-items: center;
            font-size: 11.5px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 6px;
            text-decoration: none;
            border: 1px solid;
            transition: all 0.2s ease;
        }
        .btn-status-toggle.is-suspend {
            border-color: #EF4444;
            color: #EF4444;
            background: #FEF2F2;
        }
        .btn-status-toggle.is-suspend:hover {
            background: #EF4444;
            color: #FFFFFF;
        }
        .btn-status-toggle.is-activate {
            border-color: #10B981;
            color: #10B981;
            background: #ECFDF5;
        }
        .btn-status-toggle.is-activate:hover {
            background: #10B981;
            color: #FFFFFF;
        }

        /* Modal Box Styles */
        .modal-backdrop-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal-dialog-box {
            background: #FFFFFF;
            border-radius: 14px;
            width: 100%;
            max-width: 650px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            padding: 24px;
        }
        .modal-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 16px;
            border-bottom: 1px solid #E2E8F0;
            margin-bottom: 18px;
        }
        .modal-title {
            font-size: 18px;
            font-weight: 700;
            color: #0F172A;
            margin: 0;
        }
        .btn-modal-close {
            background: none;
            border: none;
            font-size: 18px;
            color: #64748B;
            cursor: pointer;
            padding: 4px;
        }
        .btn-modal-close:hover {
            color: #0F172A;
        }
        .admin-form-group {
            margin-bottom: 14px;
        }
        .admin-input-label {
            display: block;
            font-size: 12.5px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 5px;
        }
        .admin-profile-input, .admin-filter-select {
            width: 100%;
            height: 40px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            padding: 0 12px;
            font-size: 13.5px;
            color: #0F172A;
            box-sizing: border-box;
            background-color: #FFFFFF;
        }
        .admin-profile-input:focus, .admin-filter-select:focus {
            outline: none;
            border-color: #0040A2;
            box-shadow: 0 0 0 3px rgba(0, 64, 162, 0.1);
        }
        .form-2col-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        .btn-cancel-modal {
            background: #F1F5F9;
            border: none;
            color: #475569;
            font-weight: 600;
            font-size: 13px;
            padding: 9px 18px;
            border-radius: 8px;
            cursor: pointer;
        }
        .btn-cancel-modal:hover {
            background: #E2E8F0;
            color: #0F172A;
        }
        .btn-submit-modal {
            background: #0040A2;
            border: none;
            color: #FFFFFF;
            font-weight: 600;
            font-size: 13px;
            padding: 9px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.2s ease;
        }
        .btn-submit-modal:hover {
            background: #003080;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Manage Students</h1>
                <p class="admin-page-main-sub">View and manage all students registered on SkillLinkX.</p>
            </div>
            <button type="button" class="btn-admin-primary-add" onclick="document.getElementById('addStudentModal').style.display='flex';">
                <i class="fa-solid fa-plus"></i> Add Student
            </button>
        </div>

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Real-time Student counts from SQL Server Database
             ========================================================================= -->
        <div class="admin-metrics-5grid">
            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">TOTAL STUDENTS</span>
                    <span class="stat-icon-wrap bg-blue-subtle"><i class="fa-solid fa-user-group"></i></span>
                </div>
                <div class="stat-num-val"><%= TotalStudents %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">ACTIVE STUDENTS</span>
                    <span class="stat-icon-wrap bg-green-subtle"><i class="fa-regular fa-circle-check"></i></span>
                </div>
                <div class="stat-num-val color-green"><%= ActiveStudents %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">PENDING APPROVAL</span>
                    <span class="stat-icon-wrap bg-purple-subtle"><i class="fa-solid fa-user-clock"></i></span>
                </div>
                <div class="stat-num-val color-blue"><%= PendingStudents %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">VERIFIED PROFILES</span>
                    <span class="stat-icon-wrap bg-blue-subtle"><i class="fa-regular fa-circle-check"></i></span>
                </div>
                <div class="stat-num-val"><%= VerifiedProfiles %></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">SUSPENDED</span>
                    <span class="stat-icon-wrap bg-red-subtle"><i class="fa-solid fa-user-xmark"></i></span>
                </div>
                <div class="stat-num-val color-red"><%= SuspendedStudents %></div>
            </div>
        </div>

        <!-- Filter Bar Row -->
        <div class="admin-filter-bar-card">
            <div class="admin-search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <asp:TextBox ID="txtSearchStudent" runat="server" placeholder="Search student name, college, degree or skill..." AutoPostBack="true" OnTextChanged="txtSearchStudent_TextChanged" />
            </div>

            <div class="admin-dropdown-wrap">
                <asp:DropDownList ID="ddlGradYear" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlGradYear_SelectedIndexChanged" />
            </div>

            <div class="admin-dropdown-wrap">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                    <asp:ListItem Text="All Statuses" Value="" />
                    <asp:ListItem Text="Active" Value="Active" />
                    <asp:ListItem Text="Pending" Value="Pending" />
                    <asp:ListItem Text="Suspended" Value="Suspended" />
                </asp:DropDownList>
            </div>

            <asp:LinkButton ID="btnClearFilters" runat="server" CssClass="btn-filter-clear-link" OnClick="btnClearFilters_Click">
                <i class="fa-solid fa-rotate-left" style="margin-right: 6px;"></i> Clear
            </asp:LinkButton>
        </div>

        <asp:Label ID="lblAdminMessage" runat="server" ForeColor="Green" style="margin: 8px 12px; display:block; font-size:13px; font-weight:600;" EnableViewState="false" />

        <!-- Workspace Grid: Left Students Table (2.2fr) + Right Student Details Sidebar (1fr) -->
        <div class="admin-workspace-split-grid">

            <!-- Left Main: Dynamic Students Table Card -->
            <div class="admin-table-card">
                <div class="admin-table-responsive">
                    <table class="admin-data-table" id="studentsTable">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="chkSelectAllStudents" /></th>
                                <th>Student</th>
                                <th>College &amp; Location</th>
                                <th>Education</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- =========================================================
                                 [STUDENTS REPEATER]: Binds all dynamic students from DB
                                 Clicking any row dynamically populates the details panel!
                                 ========================================================= -->
                            <asp:Repeater ID="rptStudents" runat="server" OnItemCommand="rptStudents_ItemCommand">
                                <ItemTemplate>
                                    <tr class='student-row <%# (bool)Eval("IsSelected") ? "selected active-row" : "" %>' 
                                        data-student-id='<%# Eval("MemberId") %>'
                                        data-name='<%# Eval("FullName") %>'
                                        data-email='<%# Eval("Email") %>'
                                        data-avatar='<%# Eval("ProfilePhotoUrl") %>'
                                        data-status='<%# Eval("AccountStatus") %>'
                                        data-college='<%# Eval("College") %>'
                                        data-degree='<%# Eval("Degree") %> &bull; <%# Eval("GradYear") %>'
                                        data-cgpa='<%# Eval("Cgpa") %>'
                                        data-skills='<%# Eval("Skills") %>'
                                        data-resume='<%# Eval("ResumeFile") %>'>
                                        
                                        <td><input type="checkbox" /></td>
                                        <td>
                                            <div class="student-cell-flex">
                                                <div class="student-avatar-wrap">
                                                    <%# !string.IsNullOrEmpty(Eval("ProfilePhotoUrl") as string)
                                                        ? "<img src='" + ResolveUrl(Eval("ProfilePhotoUrl").ToString()) + "' alt='Avatar' class='student-avatar-img' />"
                                                        : "<div style='width:100%; height:100%; display:flex; align-items:center; justify-content:center; background:#EFF6FF; color:#0040A2; font-size:15px;'><i class=\"fa-regular fa-user\"></i></div>" %>
                                                </div>
                                                <div>
                                                    <div class="student-name-text"><%# Eval("FullName") %></div>
                                                    <div class="student-sub-email"><%# Eval("Email") %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="student-college-name"><%# Eval("College") %></div>
                                            <div class="student-sub-loc"><i class="fa-solid fa-location-dot"></i> <%# Eval("Location") %></div>
                                        </td>
                                        <td>
                                            <div class="student-degree-text"><%# Eval("Degree") %></div>
                                            <div class="student-sub-class"><%# Eval("GradYear") %></div>
                                        </td>
                                        <td>
                                            <span class='<%# Eval("StatusBadgeClass") %>'>
                                                <%# Eval("AccountStatus") %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href='<%# ResolveUrl("~/Admin/Students.aspx?action=toggle&id=" + Eval("MemberId") + "&status=" + Eval("AccountStatus")) %>' 
                                                class='<%# "btn-status-toggle " + (Eval("AccountStatus").ToString() == "Active" ? "is-suspend" : "is-activate") %>'
                                                onclick="event.stopPropagation();">
                                                <%# Eval("AccountStatus").ToString() == "Active" ? "Suspend" : "Activate" %>
                                            </a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <!-- Dynamic Real-Time Count Footer -->
                <div class="admin-table-pagination flex-between">
                    <span class="pagination-entry-count">Showing <%= FilteredStudentsCount %> of <%= TotalStudents %> registered students</span>
                </div>
            </div>

            <!-- Right Sidebar: 100% Dynamic Student Details Panel -->
            <div class="admin-details-sidebar-card" id="studentDetailsCard">
                <div class="details-card-header flex-between">
                    <h3 class="details-heading">Student Details</h3>
                    <button type="button" class="btn-close-details" id="btnCloseStudentDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <div class="student-profile-center-block">
                    <div class="student-large-avatar-box" style="position:relative; width:72px; height:72px; border-radius:50%; margin:0 auto 12px auto; overflow:hidden; border:2px solid #E2E8F0;">
                        <img src="<%= SelectedStudentPhoto %>" alt="Student" id="sdAvatar" class="student-large-avatar-img" style='width:100%; height:100%; object-fit:cover; <%= string.IsNullOrEmpty(SelectedStudentPhoto) ? "display:none;" : "" %>' />
                        <div id="sdAvatarFallback" style='width:100%; height:100%; display:<%= !string.IsNullOrEmpty(SelectedStudentPhoto) ? "none" : "flex" %>; align-items:center; justify-content:center; background:#EFF6FF; color:#0040A2; font-size:28px;'>
                            <i class="fa-regular fa-user"></i>
                        </div>
                    </div>
                    <h4 class="sd-student-name" id="sdName">Select a student</h4>
                    <div class="sd-student-email" id="sdEmail">Click any student row to view details</div>
                    <div class="sd-status-badge-wrap">
                        <span class="badge-status-active" id="sdStatus">Active</span>
                    </div>
                </div>

                <div class="details-section-divider"></div>

                <!-- Education Details -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">EDUCATION</span>
                    <div class="sd-bold-txt" id="sdCollege">-</div>
                    <div class="sd-sub-txt" id="sdDegree">-</div>
                </div>

                <!-- Academic Performance -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">ACADEMIC PERFORMANCE</span>
                    <div class="sd-bold-txt">CGPA: <span id="sdCgpa">-</span></div>
                </div>

                <!-- Top Skills -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">TOP SKILLS</span>
                    <div class="sd-skills-chips-row" id="sdSkills">
                        <span class="badge-skill">General</span>
                    </div>
                </div>

                <!-- Documents -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">DOCUMENTS</span>
                    <a href="Students.aspx?download_resume=1&uid=<%= rptStudents.Items.Count > 0 ? "1" : "0" %>" class="sd-doc-link" id="sdResumeLink" title="Download Resume">
                        <i class="fa-regular fa-file-lines"></i> <span id="sdResumeName">Student_Resume.pdf</span>
                        <i class="fa-solid fa-download" style="margin-left: 6px; font-size: 11px;"></i>
                    </a>
                </div>

                <!-- Action Buttons -->
                <div class="sd-actions-stack">
                    <button type="button" class="btn-sd-verify" onclick="alert('Student verification status confirmed.');">
                        <i class="fa-regular fa-circle-check"></i> Verify Profile
                    </button>
                </div>
            </div>

        </div>

    </div>

    <!-- Add Student Modal (Dynamic Registration) -->
    <div class="modal-backdrop-overlay" id="addStudentModal" style="display:none;">
        <div class="modal-dialog-box">
            <div class="modal-header-row">
                <h3 class="modal-title"><i class="fa-solid fa-user-plus" style="color:#0040A2; margin-right:8px;"></i> Register New Student</h3>
                <button type="button" class="btn-modal-close" onclick="document.getElementById('addStudentModal').style.display='none';">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <asp:Label ID="lblNewStudentError" runat="server" ForeColor="Red" style="display:block; margin-bottom:12px; font-size:13px; font-weight:600;" EnableViewState="false" />

            <div class="modal-body-content">
                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Full Name *</label>
                        <asp:TextBox ID="txtNewStudentName" runat="server" CssClass="admin-profile-input" placeholder="e.g. Rahul Sharma" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Email Address (Login ID) *</label>
                        <asp:TextBox ID="txtNewStudentEmail" runat="server" CssClass="admin-profile-input" TextMode="Email" placeholder="e.g. rahul@example.com" />
                    </div>
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Password (for login) *</label>
                        <asp:TextBox ID="txtNewStudentPassword" runat="server" CssClass="admin-profile-input" TextMode="Password" placeholder="Minimum 6 characters" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Phone Number *</label>
                        <asp:TextBox ID="txtNewStudentPhone" runat="server" CssClass="admin-profile-input" placeholder="e.g. +91 9876543210" />
                    </div>
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">College / University *</label>
                        <asp:TextBox ID="txtNewStudentCollege" runat="server" CssClass="admin-profile-input" placeholder="e.g. IIT Bombay / Delhi University" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Degree &amp; Major</label>
                        <asp:TextBox ID="txtNewStudentDegree" runat="server" CssClass="admin-profile-input" placeholder="e.g. B.Tech Computer Science" />
                    </div>
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Graduation Year</label>
                        <asp:DropDownList ID="ddlNewStudentGradYear" runat="server" CssClass="admin-filter-select" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Initial Account Status</label>
                        <asp:DropDownList ID="ddlNewStudentStatus" runat="server" CssClass="admin-filter-select">
                            <asp:ListItem Text="Active (Can login immediately)" Value="Active" />
                            <asp:ListItem Text="Pending Approval" Value="Pending" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-2col-row">
                    <div class="admin-form-group">
                        <label class="admin-input-label">City *</label>
                        <asp:TextBox ID="txtNewStudentCity" runat="server" CssClass="admin-profile-input" placeholder="e.g. Mumbai" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">State *</label>
                        <asp:DropDownList ID="ddlNewStudentState" runat="server" CssClass="admin-filter-select">
                            <asp:ListItem Text="Maharashtra" Value="Maharashtra" />
                            <asp:ListItem Text="Delhi" Value="Delhi" />
                            <asp:ListItem Text="Karnataka" Value="Karnataka" />
                            <asp:ListItem Text="Tamil Nadu" Value="Tamil Nadu" />
                            <asp:ListItem Text="Gujarat" Value="Gujarat" />
                            <asp:ListItem Text="Telangana" Value="Telangana" />
                            <asp:ListItem Text="Uttar Pradesh" Value="Uttar Pradesh" />
                            <asp:ListItem Text="West Bengal" Value="West Bengal" />
                            <asp:ListItem Text="Madhya Pradesh" Value="Madhya Pradesh" />
                            <asp:ListItem Text="Rajasthan" Value="Rajasthan" />
                            <asp:ListItem Text="Punjab" Value="Punjab" />
                            <asp:ListItem Text="Kerala" Value="Kerala" />
                            <asp:ListItem Text="Other" Value="Other" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="admin-form-group">
                    <label class="admin-input-label">Key Skills (Comma separated)</label>
                    <asp:TextBox ID="txtNewStudentSkills" runat="server" CssClass="admin-profile-input" placeholder="e.g. C#, ASP.NET, SQL Server, Python, React" />
                </div>
            </div>

            <div class="modal-footer-row" style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px; border-top:1px solid #E2E8F0; padding-top:16px;">
                <button type="button" class="btn-cancel-modal" onclick="document.getElementById('addStudentModal').style.display='none';">Cancel</button>
                <asp:Button ID="btnSaveNewStudent" runat="server" Text="Register Student" CssClass="btn-submit-modal" OnClick="btnSaveNewStudent_Click" />
            </div>
        </div>
    </div>

    <!-- Auto-initialize Sidebar with First Student Data -->
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var firstRow = document.querySelector(".student-row.selected") || document.querySelector(".student-row");
            if (firstRow) {
                firstRow.click();
            }
        });
    </script>
</asp:Content>