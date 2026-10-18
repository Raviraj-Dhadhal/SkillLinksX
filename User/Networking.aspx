<%@ Page Title="Networking - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Networking.aspx.cs" Inherits="SkillLinksX.User.Networking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Networking Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-networking-page-container">

        <!-- Page Header -->
        <div class="net-page-header">
            <h1 class="net-page-title">Build Your Professional Network</h1>
            <p class="net-page-sub">Connect with students, professionals, recruiters and companies to grow your career.</p>
        </div>

        <!-- 4 Metric Tiles Row -->
        <div class="net-metrics-grid">
            <div class="net-metric-tile">
                <div class="net-metric-content">
                    <span class="net-metric-lbl">CONNECTIONS</span>
                    <span class="net-metric-number">124</span>
                </div>
                <div class="net-metric-icon-circle bg-blue">
                    <i class="fa-solid fa-user-group"></i>
                </div>
            </div>

            <div class="net-metric-tile">
                <div class="net-metric-content">
                    <span class="net-metric-lbl">PROFILE VIEWS</span>
                    <span class="net-metric-number">45</span>
                </div>
                <div class="net-metric-icon-circle bg-purple">
                    <i class="fa-regular fa-eye"></i>
                </div>
            </div>

            <div class="net-metric-tile">
                <div class="net-metric-content">
                    <span class="net-metric-lbl">PENDING</span>
                    <span class="net-metric-number">12</span>
                </div>
                <div class="net-metric-icon-circle bg-green">
                    <i class="fa-solid fa-user-plus"></i>
                </div>
            </div>

            <div class="net-metric-tile">
                <div class="net-metric-content">
                    <span class="net-metric-lbl">FOLLOWERS</span>
                    <span class="net-metric-number">89</span>
                </div>
                <div class="net-metric-icon-circle bg-gray">
                    <i class="fa-solid fa-rss"></i>
                </div>
            </div>
        </div>

        <!-- Navigation Tabs: Discover People, My Connections, Pending Requests -->
        <div class="net-tabs-bar">
            <button type="button" class="net-tab-item active">Discover People</button>
            <button type="button" class="net-tab-item">My Connections</button>
            <button type="button" class="net-tab-item">
                Pending Requests <span class="net-tab-badge">12</span>
            </button>
        </div>

        <!-- 2-Column Grid: Left People Cards + Right Recommended Recruiters -->
        <div class="net-content-layout-grid">

            <!-- Left Main Column (People Cards 2-Grid) -->
            <div class="net-tab-panel active" id="panelDiscoverPeople">
                <div class="net-cards-2grid">

                    <!-- Person 1: Raviraj Dhadhal -->
                    <div class="net-person-card">
                        <div class="person-card-avatar-wrap">
                            <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" class="person-avatar-img" />
                        </div>
                        <h3 class="person-name">Raviraj Dhadhal</h3>
                        <div class="person-sub-title">Final Year CS Student</div>
                        <div class="person-institute">
                            <i class="fa-solid fa-graduation-cap"></i> IIT Bombay
                        </div>

                        <div class="person-skills-chips">
                            <span class="person-skill-pill">React</span>
                            <span class="person-skill-pill">Node.js</span>
                        </div>

                        <button type="button" class="btn-net-connect" onclick="this.innerHTML='<i class=\'fa-solid fa-check\'></i> Request Sent'; this.classList.add('sent');">
                            <i class="fa-solid fa-user-plus"></i> Connect
                        </button>
                    </div>

                    <!-- Person 2: Mahek Godvani -->
                    <div class="net-person-card">
                        <div class="person-card-avatar-wrap">
                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Mahek Godvani" class="person-avatar-img" />
                        </div>
                        <h3 class="person-name">Mahek Godvani</h3>
                        <div class="person-sub-title">UX Designer</div>
                        <div class="person-institute">
                            <i class="fa-regular fa-building"></i> Infosys
                        </div>

                        <div class="person-skills-chips">
                            <span class="person-skill-pill">Figma</span>
                            <span class="person-skill-pill">UI/UX</span>
                        </div>

                        <button type="button" class="btn-net-connect" onclick="this.innerHTML='<i class=\'fa-solid fa-check\'></i> Request Sent'; this.classList.add('sent');">
                            <i class="fa-solid fa-user-plus"></i> Connect
                        </button>
                    </div>

                </div>
            </div>

            <!-- Panel 2: My Connections (Hidden by default, switched via JS) -->
            <div class="net-tab-panel" id="panelMyConnections" style="display: none;">
                <div class="net-cards-2grid">
                    <div class="net-person-card">
                        <div class="person-card-avatar-wrap">
                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Madhvi Chavda" class="person-avatar-img" />
                        </div>
                        <h3 class="person-name">Madhvi Chavda</h3>
                        <div class="person-sub-title">UX Mentor at Google</div>
                        <div class="person-institute">
                            <i class="fa-solid fa-graduation-cap"></i> Connected 2 weeks ago
                        </div>
                        <div class="person-skills-chips">
                            <span class="person-skill-pill">Design Systems</span>
                            <span class="person-skill-pill">Mentorship</span>
                        </div>
                        <a href="<%= ResolveUrl("~/User/Messages.aspx") %>" class="btn-net-connect" style="text-decoration:none; display:flex; justify-content:center; align-items:center; gap:6px;">
                            <i class="fa-regular fa-message"></i> Message
                        </a>
                    </div>
                </div>
            </div>

            <!-- Panel 3: Pending Requests (Hidden by default, switched via JS) -->
            <div class="net-tab-panel" id="panelPendingRequests" style="display: none;">
                <div class="net-cards-2grid">
                    <div class="net-person-card">
                        <div class="person-card-avatar-wrap">
                            <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Anil Sharma" class="person-avatar-img" />
                        </div>
                        <h3 class="person-name">Anil Sharma</h3>
                        <div class="person-sub-title">Full Stack Engineer at TechFlow</div>
                        <div class="person-institute">
                            <i class="fa-regular fa-clock"></i> Received yesterday
                        </div>
                        <div class="person-skills-chips">
                            <span class="person-skill-pill">C# .NET</span>
                            <span class="person-skill-pill">Azure</span>
                        </div>
                        <div style="display:flex; gap:8px; width:100%;">
                            <button type="button" class="btn-net-connect" style="flex:1;" onclick="this.parentElement.innerHTML='<span style=\'color:#10B981; font-weight:700; font-size:12px; margin:auto;\'><i class=\'fa-solid fa-check\'></i> Accepted</span>';">
                                Accept
                            </button>
                            <button type="button" class="btn-admin-filter" style="flex:1;" onclick="this.closest('.net-person-card').style.display='none';">
                                Decline
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Sidebar Column (Recommended Recruiters) -->
            <aside class="net-sidebar-column">
                <div class="rec-recruiters-card">
                    <h3 class="rec-card-heading">Recommended Recruiters</h3>

                    <!-- Recruiter Item 1: Mahek Godvani at TechFlow Mumbai -->
                    <div class="recruiter-box-item">
                        <div class="recruiter-avatar-wrap">
                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Mahek Godvani" class="recruiter-img" />
                        </div>
                        <div class="recruiter-info-wrap">
                            <h4 class="recruiter-name">Mahek Godvani</h4>
                            <div class="recruiter-company">TechFlow Mumbai</div>
                            <div class="recruiter-hiring-badge">Hiring: Software Engineer</div>
                        </div>
                    </div>

                    <div class="recruiter-action-row">
                        <button type="button" class="btn-recruiter-connect" onclick="this.innerHTML='Request Sent';">
                            Connect
                        </button>
                    </div>
                </div>
            </aside>

        </div>

    </div>
</asp:Content>
