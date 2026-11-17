<%@ Page Title="Manage Jobs & Internships - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="JobsInternships.aspx.cs" Inherits="SkillLinksX.Admin.JobsInternships" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Jobs & Internships Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Manage Jobs &amp; Internships</h1>
                <p class="admin-page-main-sub">Review and manage all job and internship opportunities on SkillLinkX.</p>
            </div>
            <a href="<%= ResolveUrl("~/Company/PostJob.aspx?type=job") %>" class="btn-admin-primary-add" style="text-decoration:none;">
                <i class="fa-solid fa-plus"></i> Add Opportunity
            </a>
        </div>

        <asp:Label ID="lblAdminOppStatus" runat="server" ForeColor="Green" style="margin: 10px 0; display:block; font-size:13px; font-weight:600;" EnableViewState="false" />

        <!-- =========================================================================
             [DYNAMIC OPPORTUNITIES TABLE]: All platform jobs and internships
             ========================================================================= -->
        <div class="admin-table-card" style="background:#fff; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-top:20px; overflow-x:auto;">
            <table class="admin-data-table" style="width:100%; border-collapse:collapse;">
                <thead>
                    <tr style="border-bottom:1px solid #e2e8f0; text-align:left; font-size:12px; color:#64748b;">
                        <th style="padding:10px;">#</th>
                        <th style="padding:10px;">TITLE</th>
                        <th style="padding:10px;">COMPANY</th>
                        <th style="padding:10px;">TYPE</th>
                        <th style="padding:10px;">LOCATION</th>
                        <th style="padding:10px;">STATUS</th>
                        <th style="padding:10px; text-align:right;">ACTION</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptPlatformOpportunities" runat="server" OnItemCommand="rptPlatformOpportunities_ItemCommand">
                        <ItemTemplate>
                            <tr style="border-bottom:1px solid #f1f5f9; font-size:13px;">
                                <td style="padding:10px;"><%# Container.ItemIndex + 1 %></td>
                                <td style="padding:10px; font-weight:600;"><%# Eval("Title") %></td>
                                <td style="padding:10px;"><%# Eval("CompanyName") %></td>
                                <td style="padding:10px;"><%# Eval("JobType") %></td>
                                <td style="padding:10px;"><%# Eval("Location") %></td>
                                <td style="padding:10px;">
                                    <span style='padding:3px 8px; border-radius:6px; font-size:11px; font-weight:600; background:<%# Eval("Status").ToString() == "Active" ? "#dcfce7; color:#15803d;" : "#fee2e2; color:#b91c1c;" %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td style="padding:10px; text-align:right;">
                                    <asp:LinkButton ID="btnToggleOpp" runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("JobId") + "|" + Eval("Status") %>' CssClass="btn btn-sm" style="font-size:11px; padding:3px 8px; border:1px solid #2563eb; color:#2563eb; border-radius:4px; text-decoration:none;">
                                        <%# Eval("Status").ToString() == "Active" ? "Pause" : "Activate" %>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

    </div>
</asp:Content>
