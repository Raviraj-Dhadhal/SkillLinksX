<%@ Page Title="Messages - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="SkillLinksX.User.Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Messages Head -->
    <link href="<%= ResolveUrl("~/assets/CSS/user-pages.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-messages-page">

        <!-- 2-Column Chat Layout Container -->
        <div class="chat-workspace-grid">

            <!-- Column 1: Conversations List -->
            <div class="chat-sidebar-column">
                <div class="chat-sidebar-header">
                    <h2 class="chat-column-title">Messages</h2>
                    <button type="button" class="btn-new-message-blue">
                        <i class="fa-regular fa-pen-to-square"></i> New Message
                    </button>
                </div>

                <div class="chat-threads-list">
                    <!-- Dynamic Contact Repeater: Loads available recruiter/peer threads from member_master_table -->
                    <asp:Repeater ID="rptContactThreads" runat="server">
                        <ItemTemplate>
                            <!-- Clickable Contact Card: LinkButton raises btnSelectThread_Click to switch active chat conversation -->
                            <asp:LinkButton ID="btnSelectThread" runat="server"
                                CssClass='<%# "chat-thread-item " + (Convert.ToInt32(Eval("member_id")) == ActiveContactId ? "active" : "") %>'
                                CommandArgument='<%# Eval("member_id") %>' OnClick="btnSelectThread_Click">
                                <div class="thread-avatar-wrapper">
                                    <span class="thread-avatar-circle" style="width:36px; height:36px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:16px;">
                                        <i class="fa-regular fa-user"></i>
                                    </span>
                                    <span class="thread-online-dot"></span>
                                </div>
                                <div class="thread-info-content">
                                    <div class="thread-meta-top">
                                        <span class="thread-sender-name"><%# Eval("full_name") %></span>
                                    </div>
                                    <div class="thread-role-sub"><%# Eval("email") %></div>
                                    <div class="thread-preview-row">
                                        <span class="thread-snippet-text font-semibold">Active Conversation</span>
                                    </div>
                                </div>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Column 2: Active Chat Thread Window -->
            <div class="chat-main-column">
                <!-- Thread Topbar -->
                <div class="chat-main-header">
                    <div class="chat-header-user">
                        <div class="thread-avatar-wrapper">
                            <span class="thread-avatar-circle" style="width:40px; height:40px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:18px;">
                                <i class="fa-regular fa-user"></i>
                            </span>
                        </div>
                        <div>
                            <!-- Dynamic Contact Name & Status -->
                            <div class="chat-header-name">
                                <asp:Literal ID="litActiveContactName" runat="server">Recruiter</asp:Literal>
                            </div>
                            <div class="chat-header-subtitle">
                                <asp:Literal ID="litActiveContactEmail" runat="server">recruiter@skilllinkx.com</asp:Literal> &bull; <span class="text-online">Online</span>
                            </div>
                        </div>
                    </div>
                    <div class="chat-header-actions">
                        <a href="javascript:void(0);" class="btn-view-profile-outline">View Profile</a>
                    </div>
                </div>

                <!-- Messages Conversation Flow Area -->
                <div class="chat-scroll-area" id="chatScrollArea">
                    <div class="chat-date-pill">Today</div>

                    <!-- Conversation Repeater: Binds conversation history between student and selected recruiter -->
                    <asp:Repeater ID="rptChatMessages" runat="server">
                        <ItemTemplate>
                            <!-- Evaluates whether current message is outgoing (sent by current student) or incoming (sent by recruiter) -->
                            <div class='<%# Convert.ToInt32(Eval("sender_id")) == CurrentUserId ? "message-bubble-row outgoing" : "message-bubble-row incoming" %>'>
                                <%# Convert.ToInt32(Eval("sender_id")) == CurrentUserId ? "" : "<span class='msg-bubble-avatar' style='width:28px; height:28px; border-radius:50%; background:#f1f5f9; display:inline-flex; align-items:center; justify-content:center; color:#64748b; font-size:13px; margin-right:8px;'><i class='fa-regular fa-user'></i></span>" %>
                                <div class='<%# Convert.ToInt32(Eval("sender_id")) == CurrentUserId ? "msg-bubble-content outgoing-bubble" : "msg-bubble-content incoming-bubble" %>'>
                                    <p><%# Eval("message_text") %></p>
                                    <span class='<%# "msg-time-stamp " + (Convert.ToInt32(Eval("sender_id")) == CurrentUserId ? "sent-stamp" : "") %>'>
                                        <%# Convert.ToDateTime(Eval("sent_at")).ToString("hh:mm tt") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel ID="pnlNoMessages" runat="server" Visible='<%# rptChatMessages.Items.Count == 0 %>' CssClass="text-center" style="padding: 30px; color: #94a3b8;">
                                <i class="fa-regular fa-comment-dots" style="font-size: 30px; margin-bottom: 8px;"></i>
                                <p>No messages yet. Say hello to start the conversation!</p>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

                <!-- Message Input Footer -->
                <div class="chat-input-bar">
                    <button type="button" class="btn-chat-tool" aria-label="Attach File">
                        <i class="fa-solid fa-paperclip"></i>
                    </button>
                    <div class="chat-input-wrapper">
                        <!-- Message Input TextBox: Accepts chat message text -->
                        <asp:TextBox ID="txtMessageInput" runat="server" ClientIDMode="Static" CssClass="chat-input-field" placeholder="Write a message..." onkeydown="handleEnterKey(event)" />
                        <button type="button" class="btn-emoji-picker" aria-label="Insert Emoji">
                            <i class="fa-regular fa-face-smile"></i>
                        </button>
                    </div>
                    <!-- Send Button: Performs standard ASP.NET server postback to insert message and refresh conversation -->
                    <asp:LinkButton ID="btnSend" runat="server" ClientIDMode="Static" CssClass="btn-send-message" aria-label="Send Message" OnClick="btnSend_Click">
                        <i class="fa-solid fa-paper-plane"></i>
                    </asp:LinkButton>
                </div>
            </div>

        </div>

    </div>

    <script type="text/javascript">
        // Auto-scroll chat area to the bottom whenever page loads or postback finishes
        window.addEventListener('DOMContentLoaded', function () {
            scrollToChatBottom();
        });

        // Auto-scrolls the conversation container to the latest message
        function scrollToChatBottom() {
            const area = document.getElementById('chatScrollArea');
            if (area) {
                area.scrollTop = area.scrollHeight;
            }
        }

        // Allows pressing Enter to send message
        function handleEnterKey(event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                const sendBtn = document.getElementById('btnSend');
                if (sendBtn) {
                    sendBtn.click();
                }
            }
        }
    </script>
</asp:Content>
