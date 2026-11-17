<%@ Page Title="Interviews - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Interviews.aspx.cs" Inherits="SkillLinksX.Company.Interviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Interviews Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="interviews-page-container">

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Aggregated interview stats from SQL Server
             ========================================================================= -->
        <div class="interviews-metrics-5col">
            <!-- TODAY -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">TOTAL</span>
                    <div class="int-metric-icon-circle c-blue">
                        <i class="fa-regular fa-calendar"></i>
                    </div>
                </div>
                <div class="int-metric-number"><%= TotalInterviewsCount %></div>
            </div>

            <!-- UPCOMING -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">UPCOMING</span>
                    <div class="int-metric-icon-circle c-indigo">
                        <i class="fa-regular fa-clock"></i>
                    </div>
                </div>
                <div class="int-metric-number"><%= UpcomingCount %></div>
            </div>

            <!-- COMPLETED -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">COMPLETED</span>
                    <div class="int-metric-icon-circle c-green">
                        <i class="fa-solid fa-check"></i>
                    </div>
                </div>
                <div class="int-metric-number"><%= CompletedCount %></div>
            </div>

            <!-- PENDING -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">ACTIVE JOBS</span>
                    <div class="int-metric-icon-circle c-gray">
                        <i class="fa-regular fa-hourglass-half"></i>
                    </div>
                </div>
                <div class="int-metric-number"><%= TotalInterviewsCount > 0 ? 1 : 0 %></div>
            </div>

            <!-- VIRTUAL CALLS -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">GOOGLE MEET</span>
                    <div class="int-metric-icon-circle c-red">
                        <i class="fa-solid fa-video"></i>
                    </div>
                </div>
                <div class="int-metric-number"><%= UpcomingCount %></div>
            </div>
        </div>

        <!-- Main Body: Calendar (Left) + Upcoming List (Right) -->
        <div class="interviews-body-grid">
            
            <!-- Calendar Card -->
            <div class="interviews-calendar-card">
                
                <!-- Calendar Controls Header -->
                <div class="cal-header-row">
                    <div class="cal-title-nav">
                        <h2 class="cal-month-title"><%= CurrentMonthYear %></h2>
                        <div class="cal-nav-buttons">
                            <button type="button" class="cal-nav-btn"><i class="fa-solid fa-chevron-left"></i></button>
                            <button type="button" class="cal-nav-btn"><i class="fa-solid fa-chevron-right"></i></button>
                        </div>
                    </div>
                    <div class="cal-view-toggle">
                        <button type="button" class="cal-toggle-btn active">Month</button>
                        <button type="button" class="cal-toggle-btn">Week</button>
                    </div>
                </div>

                <!-- Calendar Grid (7 columns Mon-Sun) -->
                <div class="cal-scroll-wrapper" style="overflow-x: auto;">
                    <div class="cal-grid-table">
                        <div class="cal-day-header">MON</div>
                        <div class="cal-day-header">TUE</div>
                        <div class="cal-day-header">WED</div>
                        <div class="cal-day-header">THU</div>
                        <div class="cal-day-header">FRI</div>
                        <div class="cal-day-header">SAT</div>
                        <div class="cal-day-header">SUN</div>

                        <%= CalendarGridHtml %>
                    </div>
                </div>

            </div>

            <!-- Upcoming List Card (Right Side) -->
            <div class="upcoming-interviews-card">
                <div class="upcoming-header-row" style="display:flex; justify-content:space-between; align-items:center; gap:8px;">
                    <h3 class="upcoming-title" style="margin:0;">Upcoming List</h3>
                    <button type="button" onclick="openScheduleModal(0, '', '', '', 'https://meet.google.com/new', 'Scheduled');" style="background:#2563eb; color:#fff; border:none; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer; display:inline-flex; align-items:center; gap:5px;">
                        <i class="fa-solid fa-pencil"></i> Schedule Interview
                    </button>
                </div>

                <!-- =================================================================
                     [DYNAMIC UPCOMING INTERVIEWS STACK]: Binds from database
                     ================================================================= -->
                <div class="upcoming-cards-stack">
                    <asp:Repeater ID="rptUpcomingInterviews" runat="server">
                        <ItemTemplate>
                            <div class="upcoming-item-box">
                                <div class="upcoming-item-top">
                                    <div class="upcoming-avatar-info">
                                        <img src='<%# ResolveUrl("~/assets/images/user-male-logo.png") %>' alt="Candidate" class="upcoming-avatar-img" />
                                        <div>
                                            <h4 class="upcoming-cand-name"><%# Eval("StudentName") %></h4>
                                            <div class="upcoming-cand-role"><%# Eval("JobTitle") %></div>
                                        </div>
                                    </div>
                                    <div style="display:flex; align-items:center; gap:6px;">
                                        <span class='int-status-badge status-<%# Eval("StatusClass") %>'><%# Eval("Status") %></span>
                                        <button type="button" 
                                                onclick='openScheduleModal(<%# Eval("InterviewId") %>, "<%# Eval("StudentName") %>", "<%# Eval("JobTitle") %>", "<%# Eval("RawInterviewDate") %>", "<%# Eval("MeetingLink") %>", "<%# Eval("Status") %>");'
                                                title="Edit / Reschedule"
                                                style="background:#f8fafc; border:1px solid #cbd5e1; border-radius:6px; padding:4px 8px; cursor:pointer; color:#334155; font-size:12px; display:inline-flex; align-items:center; gap:3px;">
                                            <i class="fa-solid fa-pencil"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="upcoming-details-list">
                                    <div class="upcoming-meta-row">
                                        <i class="fa-regular fa-calendar"></i>
                                        <span><%# Eval("InterviewDateFormatted") %></span>
                                    </div>
                                    <div class="upcoming-meta-row">
                                        <i class="fa-solid fa-video"></i>
                                        <a href='<%# Eval("MeetingLink") %>' target="_blank" rel="noopener noreferrer" style="color:#2563eb; font-weight:600; text-decoration:none;">
                                            Join Google Meet
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Footer CTA -->
                <div class="upcoming-footer-box">
                    <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="btn-view-all-upcoming" style="text-decoration: none; display: block; text-align: center;">View All Upcoming</a>
                </div>

            </div>

        </div>

    </div>

    <!-- Schedule / Edit Interview Modal -->
    <div id="scheduleModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.6); align-items:center; justify-content:center; backdrop-filter:blur(3px);">
        <div style="background:#fff; border-radius:12px; max-width:480px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2); position:relative;">
            <button type="button" onclick="closeScheduleModal();" style="position:absolute; right:16px; top:16px; background:none; border:none; font-size:20px; color:#94a3b8; cursor:pointer;">&times;</button>
            <h3 id="modalTitle" style="margin:0 0 6px; font-size:17px; font-weight:700; color:#0f172a;">Schedule / Edit Interview</h3>
            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px;">Set interview date, time, and meeting link. Candidate will receive a notification.</p>
            <asp:Label ID="lblScheduleMsg" runat="server" style="display:block; margin-bottom:10px; font-size:13px; font-weight:600;" EnableViewState="false" />
            
            <asp:HiddenField ID="hfInterviewId" runat="server" Value="0" />
            
            <div style="display:flex; flex-direction:column; gap:12px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Candidate Name</label>
                    <asp:TextBox ID="txtCandidateName" runat="server" placeholder="e.g. Raviraj Dhadhal" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Job Title / Role</label>
                    <asp:TextBox ID="txtRoleTitle" runat="server" placeholder="e.g. .NET Developer" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Interview Date &amp; Time</label>
                    <asp:TextBox ID="txtInterviewDate" runat="server" TextMode="DateTimeLocal" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Google Meet / Meeting Link</label>
                    <asp:TextBox ID="txtMeetingLink" runat="server" placeholder="https://meet.google.com/..." style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#334155; display:block; margin-bottom:4px;">Status</label>
                    <asp:DropDownList ID="ddlInterviewStatus" runat="server" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;">
                        <asp:ListItem Text="Scheduled" Value="Scheduled" Selected="True" />
                        <asp:ListItem Text="Confirmed" Value="Confirmed" />
                        <asp:ListItem Text="Completed" Value="Completed" />
                        <asp:ListItem Text="Cancelled" Value="Cancelled" />
                    </asp:DropDownList>
                </div>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:18px;">
                <button type="button" onclick="closeScheduleModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                <asp:Button ID="btnSaveInterview" runat="server" Text="Save Interview" OnClick="btnSaveInterview_Click" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openScheduleModal(id, name, role, dateVal, link, status) {
            var modal = document.getElementById("scheduleModal");
            var hfId = document.getElementById("<%= hfInterviewId.ClientID %>");
            var txtName = document.getElementById("<%= txtCandidateName.ClientID %>");
            var txtRole = document.getElementById("<%= txtRoleTitle.ClientID %>");
            var txtDate = document.getElementById("<%= txtInterviewDate.ClientID %>");
            var txtLink = document.getElementById("<%= txtMeetingLink.ClientID %>");
            var ddlStatus = document.getElementById("<%= ddlInterviewStatus.ClientID %>");
            var title = document.getElementById("modalTitle");

            if (hfId) hfId.value = id || 0;
            if (txtName) txtName.value = name || "";
            if (txtRole) txtRole.value = role || "";
            if (txtDate && dateVal) txtDate.value = dateVal;
            if (txtLink) txtLink.value = link || "https://meet.google.com/new";
            if (ddlStatus && status) ddlStatus.value = status;

            if (title) {
                title.innerText = (id && id > 0) ? "Edit / Reschedule Interview" : "Schedule New Interview";
            }

            if (modal) modal.style.display = "flex";
        }

        function closeScheduleModal() {
            var modal = document.getElementById("scheduleModal");
            if (modal) modal.style.display = "none";
        }
    </script>

        </div>

    </div>
</asp:Content>
