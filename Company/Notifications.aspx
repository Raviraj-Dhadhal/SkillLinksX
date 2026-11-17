<%@ Page Title="Notifications - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="SkillLinksX.Company.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Notifications Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="notifications-page-container">

        <!-- Header Row -->
        <div class="notifications-header-row">
            <div>
                <h1 class="notifications-title">Notifications</h1>
                <p class="notifications-sub">Stay updated with applications, interviews, jobs and important company activity.</p>
            </div>
            <div>
                <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="btn-mark-all-read" OnClick="btnMarkAllRead_Click">
                    <i class="fa-solid fa-check-double"></i> Mark All as Read
                </asp:LinkButton>
            </div>
        </div>

        <!-- Notifications Card Container -->
        <div class="notifications-list-card">
            <asp:Repeater ID="rptCompanyNotifications" runat="server">
                <ItemTemplate>
                    <div class='notif-item <%# Convert.ToBoolean(Eval("is_read")) ? "" : "unread" %>'>
                        <div class='notif-icon-box <%# Eval("category").ToString() == "Interviews" ? "bg-green-soft" : "bg-blue-soft" %>'>
                            <i class='<%# Eval("category").ToString() == "Interviews" ? "fa-regular fa-calendar-check text-green" : "fa-solid fa-user-plus text-blue" %>'></i>
                        </div>
                        <div class="notif-content-wrap">
                            <div class="notif-title-row">
                                <span class="notif-main-text"><strong><%# Eval("title") %>:</strong> <%# Eval("message") %></span>
                                <span class="notif-time-ago"><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM, hh:mm tt") %></span>
                            </div>
                            <div class="notif-quick-actions" style="margin-top: 8px;">
                                <a href='<%# ResolveUrl(Eval("link_url") != DBNull.Value && !string.IsNullOrEmpty(Eval("link_url").ToString()) ? "~/Company/" + Eval("link_url") : "~/Company/Applicants.aspx") %>' class="notif-action-link">
                                    View Details
                                </a>
                            </div>
                        </div>
                        <%# Convert.ToBoolean(Eval("is_read")) ? "" : "<div class=\"notif-dot\"></div>" %>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:Panel ID="pnlNoCompanyNotifs" runat="server" Visible='<%# rptCompanyNotifications.Items.Count == 0 %>' CssClass="text-center" style="padding: 30px; color: #64748b;">
                        <i class="fa-regular fa-bell-slash" style="font-size: 28px; margin-bottom: 8px;"></i>
                        <p>No new company notifications.</p>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </div>

    </div>
</asp:Content>
