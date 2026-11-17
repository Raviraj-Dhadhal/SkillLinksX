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
                    <span class="net-metric-number"><%= ConnectionsCount %></span>
                </div>
                <div class="net-metric-icon-circle bg-blue">
                    <i class="fa-solid fa-user-group"></i>
                </div>
            </div>

            <div class="net-metric-tile">
                <div class="net-metric-content">
                    <span class="net-metric-lbl">PENDING REQUESTS</span>
                    <span class="net-metric-number"><%= PendingCount %></span>
                </div>
                <div class="net-metric-icon-circle bg-green">
                    <i class="fa-solid fa-user-plus"></i>
                </div>
            </div>

            <div class="net-metric-tile">
                <div class="net-metric-content">
                    <span class="net-metric-lbl">TOTAL NETWORK</span>
                    <span class="net-metric-number"><%= FollowersCount %></span>
                </div>
                <div class="net-metric-icon-circle bg-purple">
                    <i class="fa-solid fa-network-wired"></i>
                </div>
            </div>

            <div class="net-metric-tile">
                <div class="net-metric-content">
                    <span class="net-metric-lbl">STATUS</span>
                    <span class="net-metric-number" style="font-size:16px; font-weight:600; color:#10b981;">Active</span>
                </div>
                <div class="net-metric-icon-circle bg-gray">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
            </div>
        </div>

        <!-- Status Feedback Label -->
        <asp:Label ID="lblNetStatus" runat="server" style="display:block; margin: 10px 0; font-size:14px; font-weight:600;" EnableViewState="false"></asp:Label>

        <!-- Navigation Tabs: Discover People, My Connections, Pending Requests -->
        <div class="net-tabs-bar">
            <button type="button" class="net-tab-item active">Discover People</button>
            <button type="button" class="net-tab-item">My Connections (<%= ConnectionsCount %>)</button>
            <button type="button" class="net-tab-item">
                Pending Requests <span class="net-tab-badge"><%= PendingCount %></span>
            </button>
        </div>

        <!-- 2-Column Grid: Left People Cards + Right Recommended Recruiters -->
        <div class="net-content-layout-grid">

            <!-- Left Main Column (People Cards 2-Grid) -->
            <div class="net-tab-panel active" id="panelDiscoverPeople">
                <div class="net-cards-2grid">
                    <asp:Repeater ID="rptDiscoverPeople" runat="server" OnItemCommand="rptDiscoverPeople_ItemCommand">
                        <ItemTemplate>
                            <div class="net-person-card">
                                <div class="person-card-avatar-wrap">
                                    <span style="width:56px; height:56px; border-radius:50%; background:#eff6ff; display:inline-flex; align-items:center; justify-content:center; color:#2563eb; font-weight:700; font-size:20px; border:2px solid #fff; box-shadow:0 2px 6px rgba(0,0,0,0.06);">
                                        <%# Eval("Name").ToString().Length > 0 ? Eval("Name").ToString().Substring(0, 1).ToUpper() : "U" %>
                                    </span>
                                </div>
                                <h3 class="person-name"><%# Eval("Name") %></h3>
                                <div class="person-sub-title"><%# Eval("Subtitle") %></div>
                                <div class="person-institute">
                                    <i class="fa-solid fa-graduation-cap"></i> <%# Eval("Institute") %>
                                </div>

                                <div class="person-skills-chips">
                                    <%# Eval("Skills") != null ? string.Join("", ((System.Collections.Generic.List<string>)Eval("Skills")).Select(s => "<span class='person-skill-pill'>" + s + "</span>")) : "" %>
                                </div>

                                <asp:LinkButton ID="btnConnectUser" runat="server" 
                                    CommandName="SendConnect" 
                                    CommandArgument='<%# Eval("UserId") %>' 
                                    CssClass='<%# Eval("ButtonCss") %>' 
                                    Enabled='<%# !(bool)Eval("IsConnected") && !(bool)Eval("IsPending") %>'
                                    style="text-decoration:none;">
                                    <i class='<%# (bool)Eval("IsConnected") ? "fa-solid fa-check" : ((bool)Eval("IsPending") ? "fa-regular fa-clock" : "fa-solid fa-user-plus") %>'></i>
                                    <%# Eval("ButtonState") %>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Panel 2: My Connections (Hidden by default, switched via JS) -->
            <div class="net-tab-panel" id="panelMyConnections" style="display: none;">
                <div class="net-cards-2grid">
                    <asp:Repeater ID="rptMyConnections" runat="server">
                        <ItemTemplate>
                            <div class="net-person-card">
                                <div class="person-card-avatar-wrap">
                                    <span style="width:56px; height:56px; border-radius:50%; background:#eff6ff; display:inline-flex; align-items:center; justify-content:center; color:#2563eb; font-weight:700; font-size:20px; border:2px solid #fff; box-shadow:0 2px 6px rgba(0,0,0,0.06);">
                                        <%# Eval("Name").ToString().Length > 0 ? Eval("Name").ToString().Substring(0, 1).ToUpper() : "U" %>
                                    </span>
                                </div>
                                <h3 class="person-name"><%# Eval("Name") %></h3>
                                <div class="person-sub-title"><%# Eval("Subtitle") %></div>
                                <div class="person-institute">
                                    <i class="fa-solid fa-circle-check text-green" style="color:#10b981;"></i> Connected
                                </div>
                                <div class="person-skills-chips">
                                    <%# Eval("Skills") != null ? string.Join("", ((System.Collections.Generic.List<string>)Eval("Skills")).Select(s => "<span class='person-skill-pill'>" + s + "</span>")) : "" %>
                                </div>
                                <a href="<%= ResolveUrl("~/User/Messages.aspx") %>" class="btn-net-connect" style="text-decoration:none; display:flex; justify-content:center; align-items:center; gap:6px;">
                                    <i class="fa-regular fa-message"></i> Message
                                </a>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Panel 3: Pending Requests (Hidden by default, switched via JS) -->
            <div class="net-tab-panel" id="panelPendingRequests" style="display: none;">
                <div class="net-cards-2grid">
                    <asp:Repeater ID="rptPendingRequests" runat="server" OnItemCommand="rptPendingRequests_ItemCommand">
                        <ItemTemplate>
                            <div class="net-person-card">
                                <div class="person-card-avatar-wrap">
                                    <span style="width:56px; height:56px; border-radius:50%; background:#eff6ff; display:inline-flex; align-items:center; justify-content:center; color:#2563eb; font-weight:700; font-size:20px; border:2px solid #fff; box-shadow:0 2px 6px rgba(0,0,0,0.06);">
                                        <%# Eval("Name").ToString().Length > 0 ? Eval("Name").ToString().Substring(0, 1).ToUpper() : "U" %>
                                    </span>
                                </div>
                                <h3 class="person-name"><%# Eval("Name") %></h3>
                                <div class="person-sub-title"><%# Eval("Subtitle") %></div>
                                <div class="person-institute">
                                    <i class="fa-regular fa-clock"></i> Connection Request Received
                                </div>
                                <div class="person-skills-chips">
                                    <%# Eval("Skills") != null ? string.Join("", ((System.Collections.Generic.List<string>)Eval("Skills")).Select(s => "<span class='person-skill-pill'>" + s + "</span>")) : "" %>
                                </div>
                                <div style="display:flex; gap:8px; width:100%; margin-top:8px;">
                                    <asp:Button ID="btnAccept" runat="server" 
                                        CommandName="AcceptRequest" 
                                        CommandArgument='<%# Eval("ConnectionId") %>' 
                                        Text="Accept" 
                                        CssClass="btn-net-connect" 
                                        style="flex:1; border:none; cursor:pointer;" />
                                    <asp:Button ID="btnDecline" runat="server" 
                                        CommandName="DeclineRequest" 
                                        CommandArgument='<%# Eval("ConnectionId") %>' 
                                        Text="Decline" 
                                        CssClass="btn-admin-filter" 
                                        style="flex:1; border:1px solid #cbd5e1; background:#fff; border-radius:6px; cursor:pointer;" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
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
