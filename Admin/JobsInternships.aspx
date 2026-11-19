<%@ Page Title="Manage Jobs & Internships - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="JobsInternships.aspx.cs" Inherits="SkillLinksX.Admin.JobsInternships" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Admin Jobs & Internships Head Styling -->
    <style>
        .btn-opp-toggle {
            font-size: 11.5px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 6px;
            text-decoration: none;
            border: 1px solid;
            display: inline-flex;
            align-items: center;
            transition: all 0.2s ease;
        }
        .btn-opp-toggle.is-pause {
            border-color: #EF4444;
            color: #EF4444;
            background: #FEF2F2;
        }
        .btn-opp-toggle.is-pause:hover {
            background: #EF4444;
            color: #FFFFFF;
        }
        .btn-opp-toggle.is-activate {
            border-color: #10B981;
            color: #10B981;
            background: #ECFDF5;
        }
        .btn-opp-toggle.is-activate:hover {
            background: #10B981;
            color: #FFFFFF;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-page-container">

        <!-- Page Header -->
        <div class="admin-page-header-flex">
            <div>
                <h1 class="admin-page-main-title">Manage Jobs &amp; Internships</h1>
                <p class="admin-page-main-sub">Review and manage all job and internship opportunities on SkillLinkX.</p>
            </div>
        </div>

        <asp:Label ID="lblAdminOppStatus" runat="server" ForeColor="Green" style="margin: 10px 0; display:block; font-size:13px; font-weight:600;" EnableViewState="false" />

        <!-- =========================================================================
             [DYNAMIC OPPORTUNITIES TABLE]: All platform jobs and internships from SQL Server
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
                                <td style="padding:10px; font-weight:600; color:#0F172A;">
                                    <%# Eval("Title") %>
                                    <span style="font-size:10.5px; margin-left:4px; font-weight:500; color:#64748B;">(<%# Eval("OppCategory") %>)</span>
                                </td>
                                <td style="padding:10px; color:#334155;"><%# Eval("CompanyName") %></td>
                                <td style="padding:10px; color:#64748B;"><%# Eval("JobType") %></td>
                                <td style="padding:10px; color:#64748B;"><%# Eval("Location") %></td>
                                <td style="padding:10px;">
                                    <span style='padding:3px 8px; border-radius:6px; font-size:11px; font-weight:600; background:<%# Eval("Status").ToString() == "Active" ? "#dcfce7; color:#15803d;" : "#fee2e2; color:#b91c1c;" %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td style="padding:10px; text-align:right;">
                                    <asp:LinkButton ID="btnToggleOpp" runat="server" CommandName="ToggleStatus" 
                                        CommandArgument='<%# Eval("OppCategory") + "|" + Eval("OpportunityId") + "|" + Eval("Status") %>' 
                                        CssClass='<%# "btn-opp-toggle " + (Eval("Status").ToString() == "Active" ? "is-pause" : "is-activate") %>'>
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
