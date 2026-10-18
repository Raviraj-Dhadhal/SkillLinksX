<%@ Page Title="Interviews - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Interviews.aspx.cs" Inherits="SkillLinksX.Company.Interviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Interviews Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="interviews-page-container">

        <!-- Top Metrics Cards Row (5 Tiles) -->
        <div class="interviews-metrics-5col">
            <!-- TODAY -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">TODAY</span>
                    <div class="int-metric-icon-circle c-blue">
                        <i class="fa-regular fa-calendar"></i>
                    </div>
                </div>
                <div class="int-metric-number">4</div>
            </div>

            <!-- UPCOMING -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">UPCOMING</span>
                    <div class="int-metric-icon-circle c-indigo">
                        <i class="fa-regular fa-clock"></i>
                    </div>
                </div>
                <div class="int-metric-number">12</div>
            </div>

            <!-- COMPLETED -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">COMPLETED</span>
                    <div class="int-metric-icon-circle c-green">
                        <i class="fa-solid fa-check"></i>
                    </div>
                </div>
                <div class="int-metric-number">28</div>
            </div>

            <!-- PENDING -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">PENDING</span>
                    <div class="int-metric-icon-circle c-gray">
                        <i class="fa-regular fa-hourglass-half"></i>
                    </div>
                </div>
                <div class="int-metric-number">5</div>
            </div>

            <!-- CANCELLED -->
            <div class="interview-metric-card">
                <div class="int-metric-top">
                    <span class="int-metric-label">CANCELLED</span>
                    <div class="int-metric-icon-circle c-red">
                        <i class="fa-regular fa-circle-xmark"></i>
                    </div>
                </div>
                <div class="int-metric-number">2</div>
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
                            <div class="cal-event-pill">10:00 Technical</div>
                        </div>
                        <div class="cal-day-cell">5</div>
                        <div class="cal-day-cell">
                            <span class="day-num">6</span>
                            <div class="cal-event-pill">14:00 HR: Priya</div>
                        </div>
                        <div class="cal-day-cell weekend-day">7</div>
                        <div class="cal-day-cell weekend-day">8</div>

                        <!-- Week 3: 9, 10 (Active Today), 11, 12, 13, 14, 15 -->
                        <div class="cal-day-cell">9</div>
                        <div class="cal-day-cell active-today-cell">
                            <span class="day-num today-circle">10</span>
                            <div class="cal-event-pill today-event">11:30 Tech: Sarah</div>
                            <div class="cal-event-pill today-event-green">15:00 Final: Rahul</div>
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

                <div class="upcoming-cards-stack">
                    <!-- Item 1: Mahek Godvani (Confirmed) -->
                    <div class="upcoming-item-box">
                        <div class="upcoming-item-top">
                            <div class="upcoming-avatar-info">
                                <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Mahek Godvani" class="upcoming-avatar-img" style="object-position: 50% 12%;" />
                                <div>
                                    <h4 class="upcoming-cand-name">Mahek Godvani</h4>
                                    <div class="upcoming-cand-role">Senior Frontend Developer</div>
                                </div>
                            </div>
                            <span class="int-status-badge status-confirmed">Confirmed</span>
                        </div>
                        <div class="upcoming-details-list">
                            <div class="upcoming-meta-row">
                                <i class="fa-regular fa-calendar"></i>
                                <span>Today, 11:30 AM - 12:30 PM</span>
                            </div>
                            <div class="upcoming-meta-row">
                                <i class="fa-solid fa-code"></i>
                                <span>Technical Interview</span>
                            </div>
                            <div class="upcoming-meta-row">
                                <i class="fa-solid fa-video"></i>
                                <span>Google Meet</span>
                            </div>
                        </div>
                    </div>

                    <!-- Item 2: Rahul Mehta (Pending) -->
                    <div class="upcoming-item-box">
                        <div class="upcoming-item-top">
                            <div class="upcoming-avatar-info">
                                <div class="upcoming-initials-avatar">RM</div>
                                <div>
                                    <h4 class="upcoming-cand-name">Rahul Mehta</h4>
                                    <div class="upcoming-cand-role">Product Manager</div>
                                </div>
                            </div>
                            <span class="int-status-badge status-pending">Pending</span>
                        </div>
                        <div class="upcoming-details-list">
                            <div class="upcoming-meta-row">
                                <i class="fa-regular fa-calendar"></i>
                                <span>Today, 3:00 PM - 4:00 PM</span>
                            </div>
                            <div class="upcoming-meta-row">
                                <i class="fa-solid fa-user-group"></i>
                                <span>Final Culture Fit</span>
                            </div>
                            <div class="upcoming-meta-row">
                                <i class="fa-solid fa-location-dot"></i>
                                <span>Bengaluru Office</span>
                            </div>
                        </div>
                    </div>

                    <!-- Item 3: Raviraj Dhadhal (Completed) -->
                    <div class="upcoming-item-box">
                        <div class="upcoming-item-top">
                            <div class="upcoming-avatar-info">
                                <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" class="upcoming-avatar-img" />
                                <div>
                                    <h4 class="upcoming-cand-name">Raviraj Dhadhal</h4>
                                    <div class="upcoming-cand-role">HR Business Partner</div>
                                </div>
                            </div>
                            <span class="int-status-badge status-completed">Completed</span>
                        </div>
                        <div class="upcoming-details-bottom-row">
                            <div class="upcoming-score-row">
                                <i class="fa-regular fa-star"></i> Score: 92/100
                            </div>
                            <a href="#" class="view-feedback-link">View Feedback</a>
                        </div>
                    </div>
                </div>

                <!-- Footer CTA -->
                <div class="upcoming-footer-box">
                    <a href="<%= ResolveUrl("~/Company/Applicants.aspx") %>" class="btn-view-all-upcoming" style="text-decoration: none; display: block; text-align: center;">View All Upcoming</a>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
