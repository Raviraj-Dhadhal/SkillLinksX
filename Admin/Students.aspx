<%@ Page Title="Manage Students - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="SkillLinksX.Admin.Students" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Students Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Manage Students</h1>
                <p class="admin-page-main-sub">View and manage all students registered on SkillLinkX.</p>
            </div>
            <button type="button" class="btn-admin-primary-add" id="btnOpenAddStudentModal">
                <i class="fa-solid fa-plus"></i> Add Student
            </button>
        </div>

        <!-- 5 Summary Metrics Cards -->
        <div class="admin-metrics-5grid">
            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Total Students</span>
                    <span class="stat-icon-wrap bg-blue-subtle"><i class="fa-solid fa-user-group"></i></span>
                </div>
                <div class="stat-num-val">45,231 <span class="stat-trend-green"><i class="fa-solid fa-arrow-up"></i> 12.5%</span></div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Active Students</span>
                    <span class="stat-icon-wrap bg-green-subtle"><i class="fa-regular fa-circle-check"></i></span>
                </div>
                <div class="stat-num-val">38,102</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">New This Month</span>
                    <span class="stat-icon-wrap bg-purple-subtle"><i class="fa-solid fa-user-plus"></i></span>
                </div>
                <div class="stat-num-val">2,450</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Verified Profiles</span>
                    <span class="stat-icon-wrap bg-blue-subtle"><i class="fa-regular fa-circle-check"></i></span>
                </div>
                <div class="stat-num-val">42,100</div>
            </div>

            <div class="admin-stat-card">
                <div class="stat-top-row">
                    <span class="stat-label">Inactive Students</span>
                    <span class="stat-icon-wrap bg-red-subtle"><i class="fa-solid fa-user-xmark"></i></span>
                </div>
                <div class="stat-num-val">681</div>
            </div>
        </div>

        <!-- Filter Bar Row -->
        <div class="admin-filter-bar-card">
            <div class="admin-search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="searchStudentInput" placeholder="Search student..." />
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterCollege">
                    <option value="">College</option>
                    <option value="IIT Bombay">IIT Bombay</option>
                    <option value="NIT Trichy">NIT Trichy</option>
                    <option value="BITS Pilani">BITS Pilani</option>
                    <option value="Delhi University">Delhi University</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterLocation">
                    <option value="">Location</option>
                    <option value="Mumbai">Mumbai</option>
                    <option value="Bengaluru">Bengaluru</option>
                    <option value="Pune">Pune</option>
                    <option value="New Delhi">New Delhi</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterGradYear">
                    <option value="">Grad Year</option>
                    <option value="2024">Class of 2024</option>
                    <option value="2025">Class of 2025</option>
                    <option value="2026">Class of 2026</option>
                </select>
            </div>

            <div class="admin-dropdown-wrap">
                <select id="filterStatus">
                    <option value="">Status</option>
                    <option value="Active">Active</option>
                    <option value="Pending">Pending</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <button type="button" class="btn-filter-clear" id="btnClearStudentFilters">Clear</button>
            <button type="button" class="btn-filter-apply" id="btnApplyStudentFilters">Apply Filters</button>
        </div>

        <!-- Workspace Grid: Left Students Table + Right Student Details Sidebar -->
        <div class="admin-workspace-split-grid">

            <!-- Left Main: Students Table Card -->
            <div class="admin-table-card">
                <div class="admin-table-responsive">
                    <table class="admin-data-table" id="studentsTable">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="chkSelectAllStudents" /></th>
                                <th>Student</th>
                                <th>College &amp; Location</th>
                                <th>Education</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Student 1 (Selected by default) -->
                            <tr class="student-row selected" 
                                data-student-id="1"
                                data-name="Raviraj Dhadhal"
                                data-email="raviraj08@gmail.com"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-male-logo.png") %>'
                                data-status="Active Account"
                                data-college="IIT Bombay"
                                data-degree="B.Tech Computer Science &bull; 2024"
                                data-cgpa="9.2"
                                data-skills="Python,Machine Learning,React"
                                data-resume="Raviraj_Resume_2024.pdf">
                                <td><input type="checkbox" checked="checked" /></td>
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-wrap">
                                            <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj" class="student-avatar-img" />
                                        </div>
                                        <div>
                                            <div class="student-name-text">Raviraj Dhadhal</div>
                                            <div class="student-sub-email">raviraj08@gmail.com</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="student-college-name">IIT Bombay</div>
                                    <div class="student-sub-loc"><i class="fa-solid fa-location-dot"></i> Mumbai</div>
                                </td>
                                <td>
                                    <div class="student-degree-text">B.Tech Computer Science</div>
                                    <div class="student-sub-class">Class of 2024</div>
                                </td>
                            </tr>

                            <!-- Student 2: Priya Sharma -->
                            <tr class="student-row" 
                                data-student-id="2"
                                data-name="Priya Sharma"
                                data-email="priya.s@nit.edu"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-female-logo.png") %>'
                                data-status="Active Account"
                                data-college="NIT Trichy"
                                data-degree="MCA &bull; 2025"
                                data-cgpa="8.9"
                                data-skills="Java,Spring Boot,SQL"
                                data-resume="Priya_Resume_2025.pdf">
                                <td><input type="checkbox" /></td>
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-init">PS</div>
                                        <div>
                                            <div class="student-name-text">Priya Sharma</div>
                                            <div class="student-sub-email">priya.s@nit.edu</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="student-college-name">NIT Trichy</div>
                                    <div class="student-sub-loc"><i class="fa-solid fa-location-dot"></i> Bengaluru</div>
                                </td>
                                <td>
                                    <div class="student-degree-text">MCA</div>
                                    <div class="student-sub-class">Class of 2025</div>
                                </td>
                            </tr>

                            <!-- Student 3: Radhika Gupta -->
                            <tr class="student-row" 
                                data-student-id="3"
                                data-name="Radhika Gupta"
                                data-email="radhika.g@bits.edu"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-female-logo.png") %>'
                                data-status="Active Account"
                                data-college="BITS Pilani"
                                data-degree="B.E. Electronics &bull; 2024"
                                data-cgpa="9.4"
                                data-skills="Embedded Systems,C++,IoT"
                                data-resume="Radhika_Resume_2024.pdf">
                                <td><input type="checkbox" /></td>
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-wrap">
                                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Radhika" class="student-avatar-img" />
                                        </div>
                                        <div>
                                            <div class="student-name-text">Radhika Gupta</div>
                                            <div class="student-sub-email">radhika.g@bits.edu</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="student-college-name">BITS Pilani</div>
                                    <div class="student-sub-loc"><i class="fa-solid fa-location-dot"></i> Pune</div>
                                </td>
                                <td>
                                    <div class="student-degree-text">B.E. Electronics</div>
                                    <div class="student-sub-class">Class of 2024</div>
                                </td>
                            </tr>

                            <!-- Student 4: Neha Kapoor -->
                            <tr class="student-row" 
                                data-student-id="4"
                                data-name="Neha Kapoor"
                                data-email="neha.k@example.com"
                                data-avatar='<%= ResolveUrl("~/assets/images/user-female-logo.png") %>'
                                data-status="Active Account"
                                data-college="Delhi University"
                                data-degree="B.A. Economics &bull; 2026"
                                data-cgpa="8.7"
                                data-skills="Financial Modeling,Excel,Python"
                                data-resume="Neha_Resume_2026.pdf">
                                <td><input type="checkbox" /></td>
                                <td>
                                    <div class="student-cell-flex">
                                        <div class="student-avatar-init bg-navy">NK</div>
                                        <div>
                                            <div class="student-name-text">Neha Kapoor</div>
                                            <div class="student-sub-email">neha.k@example.com</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="student-college-name">Delhi University</div>
                                    <div class="student-sub-loc"><i class="fa-solid fa-location-dot"></i> New Delhi</div>
                                </td>
                                <td>
                                    <div class="student-degree-text">B.A. Economics</div>
                                    <div class="student-sub-class">Class of 2026</div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Footer -->
                <div class="admin-table-pagination flex-between">
                    <span class="pagination-entry-count" id="studentPaginationCount">Showing 1 to 4 of 45,231 entries</span>
                    <div class="pagination-pages-list">
                        <a href="#" class="btn-pg-arrow" aria-label="Previous Page"><i class="fa-solid fa-chevron-left"></i></a>
                        <a href="#" class="btn-pg-num active">1</a>
                        <a href="#" class="btn-pg-num">2</a>
                        <a href="#" class="btn-pg-num">3</a>
                        <span class="pg-dots">&hellip;</span>
                        <a href="#" class="btn-pg-num">452</a>
                        <a href="#" class="btn-pg-arrow" aria-label="Next Page"><i class="fa-solid fa-chevron-right"></i></a>
                    </div>
                </div>
            </div>

            <!-- Right Sidebar: Student Details Panel -->
            <div class="admin-details-sidebar-card" id="studentDetailsCard">
                <div class="details-card-header flex-between">
                    <h3 class="details-heading">Student Details</h3>
                    <button type="button" class="btn-close-details" id="btnCloseStudentDetails" title="Close"><i class="fa-solid fa-xmark"></i></button>
                </div>

                <div class="student-profile-center-block">
                    <div class="student-large-avatar-box">
                        <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Student" id="sdAvatar" class="student-large-avatar-img" />
                    </div>
                    <h4 class="sd-student-name" id="sdName">Raviraj Dhadhal</h4>
                    <div class="sd-student-email" id="sdEmail">raviraj08@gmail.com</div>
                    <div class="sd-status-badge-wrap">
                        <span class="badge-active-account" id="sdStatus">Active Account</span>
                    </div>
                </div>

                <div class="details-section-divider"></div>

                <!-- Education Details -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">EDUCATION</span>
                    <div class="sd-bold-txt" id="sdCollege">IIT Bombay</div>
                    <div class="sd-sub-txt" id="sdDegree">B.Tech Computer Science &bull; 2024</div>
                </div>

                <!-- Academic Performance -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">ACADEMIC PERFORMANCE</span>
                    <div class="sd-bold-txt">CGPA: <span id="sdCgpa">9.2</span></div>
                </div>

                <!-- Top Skills -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">TOP SKILLS</span>
                    <div class="sd-skills-chips-row" id="sdSkills">
                        <span class="sd-skill-pill">Python</span>
                        <span class="sd-skill-pill">Machine Learning</span>
                        <span class="sd-skill-pill">React</span>
                    </div>
                </div>

                <!-- Documents -->
                <div class="sd-info-section">
                    <span class="sd-section-lbl">DOCUMENTS</span>
                    <a href="javascript:void(0);" class="sd-doc-link" id="sdResumeLink">
                        <i class="fa-regular fa-file-lines"></i> <span id="sdResumeName">Raviraj_Resume_2024.pdf</span>
                    </a>
                </div>

                <!-- Action Buttons -->
                <div class="sd-actions-stack">
                    <button type="button" class="btn-sd-verify" onclick="alert('Account verified successfully');">
                        <i class="fa-regular fa-circle-check"></i> Verify Account
                    </button>
                    <button type="button" class="btn-sd-edit" onclick="alert('Open student edit form');">
                        Edit Student
                    </button>
                    <button type="button" class="btn-sd-suspend" onclick="if(confirm('Are you sure you want to suspend this student?')) alert('Student suspended.');">
                        Suspend Account
                    </button>
                </div>
            </div>

        </div>

    </div>

    <!-- Add Student Modal -->
    <div class="modal-backdrop-overlay" id="addStudentModal" style="display:none;">
        <div class="modal-dialog-box">
            <div class="modal-header-row">
                <h3 class="modal-title">Add New Student</h3>
                <button type="button" class="btn-modal-close" onclick="document.getElementById('addStudentModal').style.display='none';">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            <div class="modal-body-content">
                <div class="admin-form-group">
                    <label class="admin-input-label">Full Name *</label>
                    <input type="text" class="admin-profile-input" id="newStudentName" placeholder="e.g. Ananya Sharma" />
                </div>
                <div class="admin-form-group">
                    <label class="admin-input-label">Email Address *</label>
                    <input type="email" class="admin-profile-input" id="newStudentEmail" placeholder="e.g. ananya.s@example.com" />
                </div>
                <div class="admin-form-group">
                    <label class="admin-input-label">College / University *</label>
                    <input type="text" class="admin-profile-input" id="newStudentCollege" placeholder="e.g. IIT Delhi" />
                </div>
                <div class="form-2col-row" style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div class="admin-form-group">
                        <label class="admin-input-label">Degree</label>
                        <input type="text" class="admin-profile-input" id="newStudentDegree" placeholder="e.g. B.Tech CS" />
                    </div>
                    <div class="admin-form-group">
                        <label class="admin-input-label">Grad Year</label>
                        <select class="admin-filter-select" id="newStudentYear">
                            <option value="2026">Class of 2026</option>
                            <option value="2027">Class of 2027</option>
                            <option value="2025">Class of 2025</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer-row" style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <button type="button" class="btn-cancel-modal" onclick="document.getElementById('addStudentModal').style.display='none';">Cancel</button>
                <button type="button" class="btn-submit-modal" id="btnSubmitAddStudent">Add Student</button>
            </div>
        </div>
    </div>
</asp:Content>
