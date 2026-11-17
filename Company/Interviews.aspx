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
                        <h2 class="cal-month-title">October 2026</h2>
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

                        <!-- Week 1: 25, 26, 27, 28, 29, 30, 1 -->
                        <div class="cal-day-cell other-month">25</div>
                        <div class="cal-day-cell other-month">26</div>
                        <div class="cal-day-cell other-month">27</div>
                        <div class="cal-day-cell other-month">28</div>
                        <div class="cal-day-cell other-month">29</div>
                        <div class="cal-day-cell other-month">30</div>
                        <div class="cal-day-cell weekend-day">1</div>

                        <!-- Week 2: 2, 3, 4, 5, 6, 7, 8 -->
                        <div class="cal-day-cell">2</div>
                        <div class="cal-day-cell">3</div>
                        <div class="cal-day-cell">
                            <span class="day-num">4</span>
                        </div>
                        <div class="cal-day-cell">5</div>
                        <div class="cal-day-cell">
                            <span class="day-num">6</span>
                        </div>
                        <div class="cal-day-cell weekend-day">7</div>
                        <div class="cal-day-cell weekend-day">8</div>

                        <!-- Week 3: 9, 10 (Active Today), 11, 12, 13, 14, 15 -->
                        <div class="cal-day-cell">9</div>
                        <div class="cal-day-cell active-today-cell">
                            <span class="day-num today-circle">10</span>
                            <% if (UpcomingCount > 0) { %>
                                <div class="cal-event-pill today-event"><%= UpcomingCount %> Scheduled</div>
                            <% } %>
                        </div>
                        <div class="cal-day-cell">11</div>
                        <div class="cal-day-cell">12</div>
                        <div class="cal-day-cell">13</div>
                        <div class="cal-day-cell">14</div>
                        <div class="cal-day-cell">15</div>

                        <!-- Week 4: 16, 17, 18, 19, 20, 21, 22 -->
                        <div class="cal-day-cell">16</div>
                        <div class="cal-day-cell">17</div>
                        <div class="cal-day-cell">18</div>
                        <div class="cal-day-cell">19</div>
                        <div class="cal-day-cell">20</div>
                        <div class="cal-day-cell">21</div>
                        <div class="cal-day-cell">22</div>

                        <!-- Week 5: 23, 24, 25, 26, 27, 28, 29 -->
                        <div class="cal-day-cell">23</div>
                        <div class="cal-day-cell">24</div>
                        <div class="cal-day-cell">25</div>
                        <div class="cal-day-cell">26</div>
                        <div class="cal-day-cell">27</div>
                        <div class="cal-day-cell">28</div>
                        <div class="cal-day-cell">29</div>

                        <!-- Week 6: 30, 31, 1, 2, 3, 4, 5 -->
                        <div class="cal-day-cell">30</div>
                        <div class="cal-day-cell">31</div>
                        <div class="cal-day-cell other-month">1</div>
                        <div class="cal-day-cell other-month">2</div>
                        <div class="cal-day-cell other-month">3</div>
                        <div class="cal-day-cell other-month">4</div>
                        <div class="cal-day-cell other-month">5</div>
                    </div>
                </div>

            </div>

            <!-- Upcoming List Card (Right Side) -->
            <div class="upcoming-interviews-card">
                <div class="upcoming-header-row">
                    <h3 class="upcoming-title">Upcoming List</h3>
                    <button type="button" class="btn-cal-filter" aria-label="Filter List">
                        <i class="fa-solid fa-sliders"></i>
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
                                    <span class='int-status-badge status-<%# Eval("StatusClass") %>'><%# Eval("Status") %></span>
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
</asp:Content>
