<%@ Page Title="Messages - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/Company.Master" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="SkillLinksX.Company.Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Messages Head -->
    <link href="<%= ResolveUrl("~/assets/CSS/company-pages.css") %>" rel="stylesheet" />
    <style>
        .chat-thread-item {
            text-decoration: none;
            color: inherit;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 14px 18px;
            border-bottom: 1px solid #F1F5F9;
            cursor: pointer;
            transition: background-color 0.15s ease;
            width: 100%;
            text-align: left;
            background: transparent;
            border-left: 3px solid transparent;
            border-top: none;
            border-right: none;
        }
        .chat-thread-item:hover {
            background-color: #F8FAFC;
        }
        .chat-thread-item.active {
            background-color: #EEF4FF;
            border-left: 3px solid #0040A2;
        }
        .thread-badge-unread {
            background-color: #0040A2;
            color: #FFFFFF;
            font-size: 11px;
            font-weight: 700;
            padding: 2px 7px;
            border-radius: 10px;
            margin-left: auto;
        }
        .message-bubble-row {
            display: flex;
            gap: 10px;
            max-width: 80%;
            margin-bottom: 12px;
        }
        .message-bubble-row.incoming {
            align-self: flex-start;
        }
        .message-bubble-row.outgoing {
            align-self: flex-end;
            margin-left: auto;
        }
        .msg-bubble-content {
            padding: 12px 16px;
            border-radius: 14px;
            font-size: 13.5px;
            line-height: 1.45;
            word-break: break-word;
        }
        .incoming-bubble {
            background-color: #FFFFFF;
            border: 1px solid #E2E8F0;
            color: #0F172A;
            border-top-left-radius: 2px;
        }
        .outgoing-bubble {
            background-color: #0040A2;
            color: #FFFFFF;
            border-top-right-radius: 2px;
        }
        .outgoing-bubble p {
            color: #FFFFFF;
            margin: 0 0 4px 0;
        }
        .incoming-bubble p {
            color: #0F172A;
            margin: 0 0 4px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="company-messages-page">

        <!-- 2-Column Chat Layout Container -->
        <div class="chat-workspace-grid" style="min-height: calc(100vh - 120px); display:grid; grid-template-columns: 320px 1fr; background:#fff; border-radius:12px; border:1px solid #E2E8F0; overflow:hidden;">

            <!-- Column 1: Conversations List -->
            <div class="chat-sidebar-column" style="border-right: 1px solid #E2E8F0; display:flex; flex-direction:column; background:#fff;">
                <div class="chat-sidebar-header" style="padding:16px 20px; border-bottom:1px solid #E2E8F0; display:flex; justify-content:space-between; align-items:center;">
                    <h2 class="chat-column-title" style="margin:0; font-size:18px; font-weight:700; color:#0F172A;">Candidate Chats</h2>
                    <span style="font-size: 12px; color: #64748B; font-weight: 500;">
                        Talent Pool
                    </span>
                </div>

                <div class="chat-threads-list" style="flex:1; overflow-y:auto;">
                    <!-- Dynamic Candidate Threads -->
                    <asp:Repeater ID="rptCandidateThreads" runat="server">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnSelectCandidate" runat="server"
                                CssClass='<%# "chat-thread-item " + (Convert.ToInt32(Eval("candidate_id")) == ActiveCandidateId ? "active" : "") %>'
                                CommandArgument='<%# Eval("candidate_id") %>' OnClick="btnSelectCandidate_Click">
                                <div class="thread-avatar-wrapper">
                                    <span class="thread-avatar-circle" style="width:40px; height:40px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:16px; border:1px solid #cbd5e1; overflow:hidden;">
                                        <%# (Eval("profile_photo") != DBNull.Value && !string.IsNullOrEmpty(Eval("profile_photo").ToString())) 
                                            ? "<img src='" + ResolveUrl(Eval("profile_photo").ToString()) + "' style='width:100%; height:100%; border-radius:50%; object-fit:cover;' />"
                                            : "<i class=\"fa-regular fa-user\"></i>" %>
                                    </span>
                                </div>
                                <div class="thread-info-content" style="flex:1; min-width:0; margin-left: 4px;">
                                    <div class="thread-meta-top" style="display:flex; justify-content:space-between; align-items:baseline;">
                                        <span class="thread-sender-name" style="font-weight:700; color:#0F172A; font-size:13.5px;"><%# Eval("full_name") %></span>
                                        <%# Convert.ToInt32(Eval("unread_count")) > 0 ? "<span class='thread-badge-unread'>" + Eval("unread_count") + "</span>" : "" %>
                                    </div>
                                    <div class="thread-role-sub" style="font-size:11.5px; color:#64748B;">
                                        <%# Eval("email") %>
                                    </div>
                                    <div class="thread-preview-row" style="margin-top:2px;">
                                        <span class="thread-snippet-text" style="font-size:12px; color:#64748b; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; display:block;">
                                            <%# Eval("last_message") != DBNull.Value && !string.IsNullOrEmpty(Eval("last_message").ToString()) ? Eval("last_message") : (Eval("skills") != DBNull.Value ? "Skills: " + Eval("skills") : "Start conversation") %>
                                        </span>
                                    </div>
                                </div>
                            </asp:LinkButton>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel ID="pnlNoCandidates" runat="server" Visible='<%# rptCandidateThreads.Items.Count == 0 %>' style="padding: 24px; text-align: center; color: #94a3b8;">
                                <i class="fa-regular fa-user" style="font-size: 28px; margin-bottom: 8px;"></i>
                                <p style="font-size: 13px; margin: 0;">No candidates found.</p>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Column 2: Active Chat Thread Window -->
            <div class="chat-main-column" style="display:flex; flex-direction:column; background:#fafafc;">
                <!-- Thread Topbar -->
                <div class="chat-main-header" style="padding:14px 20px; background:#fff; border-bottom:1px solid #E2E8F0; display:flex; justify-content:space-between; align-items:center;">
                    <div class="chat-header-user" style="display:flex; align-items:center; gap:12px;">
                        <div class="thread-avatar-wrapper">
                            <span class="thread-avatar-circle" style="width:40px; height:40px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:16px; border:1px solid #cbd5e1; overflow:hidden;">
                                <asp:Literal ID="litActiveCandidateInitial" runat="server"><i class="fa-regular fa-user"></i></asp:Literal>
                            </span>
                        </div>
                        <div>
                            <div class="chat-header-name" style="font-size:15px; font-weight:700; color:#0F172A;">
                                <asp:Literal ID="litActiveCandidateName" runat="server">Candidate</asp:Literal>
                            </div>
                            <div class="chat-header-subtitle" style="font-size:12px; color:#64748B;">
                                <asp:Literal ID="litActiveCandidateEmail" runat="server">candidate@skilllinkx.com</asp:Literal> &bull; <span style="color:#10B981; font-weight:600;">Active</span>
                            </div>
                        </div>
                    </div>
                    <div class="chat-header-actions">
                        <a href='<%= ResolveUrl("~/Company/CandidateProfile.aspx?id=" + ActiveCandidateId) %>' class="btn-view-profile-outline" 
                            style="padding:6px 14px; border:1px solid #CBD5E1; border-radius:6px; font-size:12.5px; font-weight:600; color:#1E293B; text-decoration:none; background:#fff; display:inline-flex; align-items:center; gap:6px;">
                            <i class="fa-regular fa-user"></i> View Profile
                        </a>
                    </div>
                </div>

                <!-- Messages Conversation Flow Area -->
                <div class="chat-scroll-area" id="chatScrollArea" style="flex:1; overflow-y:auto; padding:20px; display:flex; flex-direction:column;">
                    <div class="chat-date-pill" style="align-self:center; background:#E2E8F0; color:#475569; font-size:11px; font-weight:600; padding:3px 12px; border-radius:9999px; margin-bottom:12px;">Conversation History</div>

                    <!-- Conversation Repeater -->
                    <asp:Repeater ID="rptCompanyChatMessages" runat="server">
                        <ItemTemplate>
                            <div class='<%# Convert.ToInt32(Eval("sender_id")) == CurrentCompanyUserId ? "message-bubble-row outgoing" : "message-bubble-row incoming" %>'>
                                <%# Convert.ToInt32(Eval("sender_id")) == CurrentCompanyUserId ? "" : 
                                    ("<span class='msg-bubble-avatar' style='width:30px; height:30px; border-radius:50%; background:#e2e8f0; display:inline-flex; align-items:center; justify-content:center; color:#475569; font-size:12px; margin-right:6px; flex-shrink:0; overflow:hidden;'>" + 
                                    (!string.IsNullOrEmpty(ActiveCandidatePhoto) ? "<img src='" + ResolveUrl(ActiveCandidatePhoto) + "' style='width:100%; height:100%; border-radius:50%; object-fit:cover;' />" : "<i class=\"fa-regular fa-user\"></i>") + 
                                    "</span>") %>
                                <div class='<%# Convert.ToInt32(Eval("sender_id")) == CurrentCompanyUserId ? "msg-bubble-content outgoing-bubble" : "msg-bubble-content incoming-bubble" %>'>
                                    <p><%# Eval("message_text") %></p>
                                    <span class='<%# "msg-time-stamp " + (Convert.ToInt32(Eval("sender_id")) == CurrentCompanyUserId ? "sent-stamp" : "") %>' style="font-size:10px; opacity:0.8; display:block; text-align:right;">
                                        <%# Convert.ToDateTime(Eval("sent_at")).ToString("hh:mm tt") %>
                                    </span>
                                </div>
                                <%# Convert.ToInt32(Eval("sender_id")) == CurrentCompanyUserId ? 
                                    ("<span class='msg-bubble-avatar' style='width:30px; height:30px; border-radius:50%; background:#e2e8f0; display:inline-flex; align-items:center; justify-content:center; color:#475569; font-size:12px; margin-left:6px; flex-shrink:0; overflow:hidden;'>" + 
                                    (!string.IsNullOrEmpty(CurrentCompanyPhoto) ? "<img src='" + ResolveUrl(CurrentCompanyPhoto) + "' style='width:100%; height:100%; border-radius:50%; object-fit:cover;' />" : "<i class=\"fa-solid fa-building\"></i>") + 
                                    "</span>") : "" %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <!-- Empty state panel when no messages yet -->
                    <asp:Panel ID="pnlNoCompanyMessages" runat="server" Visible="false" style="padding: 40px 20px; color: #94a3b8; text-align: center;">
                        <i class="fa-regular fa-comment-dots" style="font-size: 36px; margin-bottom: 12px; display:block; color:#cbd5e1;"></i>
                        <p style="margin: 0; font-size: 14px;">No messages exchanged with this candidate yet.</p>
                        <p style="margin-top: 4px; font-size: 12px; color: #64748B;">Send an inquiry, interview invitation, or follow-up note below!</p>
                    </asp:Panel>
                </div>

                <!-- Message Input Footer -->
                <div class="chat-input-bar" style="padding: 14px 20px; background: #FFFFFF; border-top: 1px solid #E2E8F0; display: flex; align-items: center; gap: 10px;">
                    <div class="chat-input-wrapper" style="flex: 1; display: flex; align-items: center; background: #F8FAFC; border: 1px solid #CBD5E1; border-radius: 24px; padding: 6px 16px;">
                        <asp:TextBox ID="txtCompanyMessageInput" runat="server" ClientIDMode="Static"
                            style="border:none; outline:none; background:transparent; width:100%; font-size:13.5px; padding:6px 0;"
                            placeholder="Write a message to candidate..." onkeydown="handleEnterKey(event)" />
                    </div>
                    <asp:LinkButton ID="btnSendCompanyMessage" runat="server" ClientIDMode="Static"
                        style="width:42px; height:42px; border-radius:50%; background:#0040A2; color:#fff; display:inline-flex; align-items:center; justify-content:center; text-decoration:none; font-size:15px; border:none; cursor:pointer;"
                        aria-label="Send Message" OnClick="btnSendCompanyMessage_Click">
                        <i class="fa-solid fa-paper-plane"></i>
                    </asp:LinkButton>
                </div>
            </div>

        </div>

    </div>

    <script type="text/javascript">
        window.addEventListener('DOMContentLoaded', function () {
            scrollToChatBottom();
        });

        function scrollToChatBottom() {
            var area = document.getElementById('chatScrollArea');
            if (area) {
                area.scrollTop = area.scrollHeight;
            }
        }

        function handleEnterKey(event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                var sendBtn = document.getElementById('btnSendCompanyMessage');
                if (sendBtn) {
                    sendBtn.click();
                }
            }
        }
    </script>
</asp:Content>
