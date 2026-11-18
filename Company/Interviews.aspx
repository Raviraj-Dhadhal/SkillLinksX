<%@ Page Title="Interviews - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Interviews.aspx.cs" Inherits="SkillLinksX.Company.Interviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Interviews Head -->
    <style>
        .cal-nav-btn {
            text-decoration: none !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
        }
        .cal-view-toggle {
            display: inline-flex !important;
            align-items: center !important;
            background-color: #f1f5f9 !important;
            padding: 3px !important;
            border-radius: 8px !important;
            border: 1px solid #e2e8f0 !important;
            gap: 2px !important;
        }
        .cal-view-toggle a.cal-toggle-btn,
        a.cal-toggle-btn {
            text-decoration: none !important;
            border: none !important;
            background: transparent !important;
            padding: 6px 14px !important;
            font-size: 12.5px !important;
            font-weight: 600 !important;
            color: #64748b !important;
            border-radius: 6px !important;
            cursor: pointer !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            line-height: 1 !important;
            transition: all 0.15s ease !important;
        }
        .cal-view-toggle a.cal-toggle-btn:hover {
            color: #0f172a !important;
        }
        .cal-view-toggle a.cal-toggle-btn.active,
        a.cal-toggle-btn.active {
            background-color: #ffffff !important;
            color: #0f172a !important;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1) !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="interviews-page-container">

        <!-- =========================================================================
             [DYNAMIC METRIC TILES]: Aggregated interview stats from SQL Server
             ========================================================================= -->
        <div class="interviews-metrics-5col">
            <!-- TOTAL -->
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

            <!-- ACTIVE JOBS -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">ACTIVE JOBS</span>
                    <div class="int-metric-icon-circle c-gray">
                        <i class="fa-regular fa-hourglass-half"></i>
                    </div>
                </div>
                <div class="int-metric-number"><%= ActiveJobsCount %></div>
            </div>

            <!-- GOOGLE MEET -->
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
                            <asp:LinkButton ID="btnPrevMonth" runat="server" CssClass="cal-nav-btn" OnClick="btnPrevMonth_Click" ToolTip="Previous" CausesValidation="false"><i class="fa-solid fa-chevron-left"></i></asp:LinkButton>
                            <asp:LinkButton ID="btnNextMonth" runat="server" CssClass="cal-nav-btn" OnClick="btnNextMonth_Click" ToolTip="Next" CausesValidation="false"><i class="fa-solid fa-chevron-right"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div class="cal-view-toggle">
                        <asp:LinkButton ID="btnViewMonth" runat="server" CssClass="cal-toggle-btn" OnClick="btnViewMonth_Click" CausesValidation="false">Month</asp:LinkButton>
                        <asp:LinkButton ID="btnViewWeek" runat="server" CssClass="cal-toggle-btn" OnClick="btnViewWeek_Click" CausesValidation="false">Week</asp:LinkButton>
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
                    <asp:Repeater ID="rptUpcomingInterviews" runat="server" OnItemCommand="rptUpcomingInterviews_ItemCommand">
                        <ItemTemplate>
                            <div class="upcoming-item-box">
                                <div class="upcoming-item-top">
                                    <div class="upcoming-avatar-info">
                                        <%# !string.IsNullOrEmpty(Eval("ProfilePhoto") as string) ? 
                                            $"<img src='{ResolveUrl(Eval("ProfilePhoto").ToString())}' alt='Candidate' class='upcoming-avatar-img' />" :
                                            $"<span class='upcoming-avatar-img' style='display:inline-flex; align-items:center; justify-content:center; background:#f1f5f9; color:#64748b; font-size:16px; border:1px solid #cbd5e1;'><i class=\"fa-regular fa-user\"></i></span>" %>
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
                                        <asp:LinkButton ID="btnRemoveInterview" runat="server"
                                                CommandName="RemoveInterview"
                                                CommandArgument='<%# Eval("InterviewId") %>'
                                                OnClientClick="return confirm('Are you sure you want to remove this interview?');"
                                                title="Remove Interview"
                                                CausesValidation="false"
                                                style="background:#fef2f2; border:1px solid #fecaca; border-radius:6px; padding:4px 8px; cursor:pointer; color:#ef4444; font-size:12px; display:inline-flex; align-items:center; gap:3px; text-decoration:none;">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <div class="upcoming-details-list">
                                    <div class="upcoming-meta-row">
                                        <i class="fa-regular fa-calendar"></i>
                                        <span><%# Eval("InterviewDateFormatted") %></span>
                                    </div>
                                    <div class="upcoming-meta-row">
                                        <i class="fa-solid fa-video text-blue"></i>
                                        <a href='<%# Eval("MeetingLink") %>' target="_blank" class="upcoming-join-link">Join Google Meet</a>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel ID="pnlNoInterviews" runat="server" Visible='<%# rptUpcomingInterviews.Items.Count == 0 %>' style="padding:28px 16px; text-align:center; color:#64748B;">
                                <i class="fa-regular fa-calendar-xmark" style="font-size:28px; margin-bottom:8px; display:block; color:#94A3B8;"></i>
                                <span style="font-size:13px; font-weight:500;">No upcoming interviews scheduled.</span>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

                <!-- Footer CTA -->
                <div class="upcoming-footer-box">
                    <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="btn-view-all-upcoming" style="text-decoration: none; display: block; text-align: center;">View All Applicants</a>
                </div>

            </div>

        </div>

    </div>

    <!-- Candidate Datalist for autocomplete -->
    <datalist id="applicantsDatalist">
        <asp:Repeater ID="rptApplicantsDatalist" runat="server">
            <ItemTemplate>
                <option value='<%# Eval("FullName") %>'><%# Eval("Email") %> - <%# Eval("RoleTitle") %></option>
            </ItemTemplate>
        </asp:Repeater>
    </datalist>

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
                    <asp:TextBox ID="txtCandidateName" runat="server" list="applicantsDatalist" placeholder="e.g. Raviraj Dhadhal" style="width:100%; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
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
                    <div style="display:flex; gap:6px;">
                        <asp:TextBox ID="txtMeetingLink" runat="server" placeholder="https://meet.google.com/..." style="flex:1; padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px;" />
                        <button type="button" onclick="generateNewMeetLink();" style="padding:8px 12px; font-size:12px; font-weight:600; background:#eff6ff; color:#2563eb; border:1px solid #bfdbfe; border-radius:6px; cursor:pointer; white-space:nowrap;">
                            <i class="fa-solid fa-arrows-rotate"></i> New Link
                        </button>
                    </div>
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

            <div style="display:flex; justify-content:space-between; align-items:center; width:100%; margin-top:18px;">
                <asp:Button ID="btnDeleteModalInterview" runat="server" ClientIDMode="Static"
                    Text="Delete Interview" OnClick="btnDeleteModalInterview_Click" CausesValidation="false"
                    OnClientClick="return confirm('Are you sure you want to delete this scheduled interview?');" 
                    style="padding:8px 14px; border-radius:6px; background:#fee2e2; color:#dc2626; border:1px solid #fca5a5; font-size:13px; font-weight:600; cursor:pointer; display:none;" />
                <div style="display:flex; gap:10px; margin-left:auto;">
                    <button type="button" onclick="closeScheduleModal();" style="padding:8px 14px; border-radius:6px; border:1px solid #cbd5e1; background:#fff; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
                    <asp:Button ID="btnSaveInterview" runat="server" Text="Save Interview" OnClick="btnSaveInterview_Click" CausesValidation="false" style="padding:8px 18px; border-radius:6px; background:#2563eb; color:#fff; border:none; font-size:13px; font-weight:600; cursor:pointer;" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function generateNewMeetLink() {
            var txt = document.getElementById("<%= txtMeetingLink.ClientID %>");
            if (txt) {
                var p1 = Math.random().toString(36).substring(2, 5);
                var p2 = Math.random().toString(36).substring(2, 6);
                var p3 = Math.random().toString(36).substring(2, 5);
                txt.value = "https://meet.google.com/" + p1 + "-" + p2 + "-" + p3;
            }
        }

        function openScheduleModal(id, name, role, dateVal, link, status) {
            var modal = document.getElementById("scheduleModal");
            var hfId = document.getElementById("<%= hfInterviewId.ClientID %>");
            var txtName = document.getElementById("<%= txtCandidateName.ClientID %>");
            var txtRole = document.getElementById("<%= txtRoleTitle.ClientID %>");
            var txtDate = document.getElementById("<%= txtInterviewDate.ClientID %>");
            var txtLink = document.getElementById("<%= txtMeetingLink.ClientID %>");
            var ddlStatus = document.getElementById("<%= ddlInterviewStatus.ClientID %>");
            var title = document.getElementById("modalTitle");
            var btnDelete = document.getElementById("btnDeleteModalInterview");
            var lblMsg = document.getElementById("<%= lblScheduleMsg.ClientID %>");

            if (lblMsg) lblMsg.innerText = "";
            if (hfId) hfId.value = id || 0;
            if (txtName) txtName.value = name || "";
            if (txtRole) txtRole.value = role || "";
            if (txtDate) txtDate.value = dateVal || "";
            if (txtLink) txtLink.value = link || "https://meet.google.com/new";
            if (ddlStatus) ddlStatus.value = status || "Scheduled";

            if (title) {
                title.innerText = (id && id > 0) ? "Edit / Reschedule Interview" : "Schedule New Interview";
            }

            if (btnDelete) {
                btnDelete.style.display = (id && id > 0) ? "inline-block" : "none";
            }

            if (modal) modal.style.display = "flex";
        }

        function closeScheduleModal() {
            var modal = document.getElementById("scheduleModal");
            if (modal) modal.style.display = "none";
        }
    </script>
</asp:Content>
