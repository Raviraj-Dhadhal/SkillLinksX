<%@ Page Title="Messages - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="SkillLinksX.User.Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- User Messages Head -->
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
                    <!-- Thread 1: Mahek Godvani (Active) -->
                    <div class="chat-thread-item active">
                        <div class="thread-avatar-wrapper">
                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Mahek Godvani" class="thread-avatar-img" />
                            <span class="thread-online-dot"></span>
                        </div>
                        <div class="thread-info-content">
                            <div class="thread-meta-top">
                                <span class="thread-sender-name">Mahek Godvani</span>
                                <span class="thread-time-label">2m ago</span>
                            </div>
                            <div class="thread-role-sub">Senior Recruiter at Zomato</div>
                            <div class="thread-preview-row">
                                <span class="thread-snippet-text font-semibold">Hi Raviraj, we'd like to schedule a technical round...</span>
                                <span class="thread-badge-unread">1</span>
                            </div>
                        </div>
                    </div>

                    <!-- Thread 2: Raviraj Dhadhal -->
                    <div class="chat-thread-item">
                        <div class="thread-avatar-wrapper">
                            <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" class="thread-avatar-img" />
                        </div>
                        <div class="thread-info-content">
                            <div class="thread-meta-top">
                                <span class="thread-sender-name">Raviraj Dhadhal</span>
                                <span class="thread-time-label">1h ago</span>
                            </div>
                            <div class="thread-role-sub">CS Student at IIT Bombay</div>
                            <div class="thread-preview-row">
                                <span class="thread-snippet-text">Did you check the new internship at Swiggy?</span>
                            </div>
                        </div>
                    </div>

                    <!-- Thread 3: Madhvi Chavda -->
                    <div class="chat-thread-item">
                        <div class="thread-avatar-wrapper">
                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Madhvi Chavda" class="thread-avatar-img" />
                        </div>
                        <div class="thread-info-content">
                            <div class="thread-meta-top">
                                <span class="thread-sender-name">Madhvi Chavda</span>
                                <span class="thread-time-label">Yesterday</span>
                            </div>
                            <div class="thread-role-sub">UX Mentor at Google</div>
                            <div class="thread-preview-row">
                                <span class="thread-snippet-text">Your portfolio is looking great! Let's discuss...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Column 2: Active Chat Thread Window -->
            <div class="chat-main-column">
                <!-- Thread Topbar -->
                <div class="chat-main-header">
                    <div class="chat-header-user">
                        <div class="thread-avatar-wrapper">
                            <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Mahek Godvani" class="chat-header-avatar" />
                        </div>
                        <div>
                            <div class="chat-header-name">Mahek Godvani</div>
                            <div class="chat-header-subtitle">Senior Recruiter at Zomato &bull; <span class="text-online">Online</span></div>
                        </div>
                    </div>
                    <div class="chat-header-actions">
                        <a href="#" class="btn-view-profile-outline">View Profile</a>
                    </div>
                </div>

                <!-- Messages Conversation Flow Area -->
                <div class="chat-scroll-area">
                    <div class="chat-date-pill">Today</div>

                    <!-- Recruiter Bubble 1 -->
                    <div class="message-bubble-row incoming">
                        <img src="<%= ResolveUrl("~/assets/images/user-female-logo.png") %>" alt="Mahek Godvani" class="msg-bubble-avatar" />
                        <div class="msg-bubble-content incoming-bubble">
                            <p>Hello Raviraj, I saw your application for the Software Development Intern position.</p>
                            <span class="msg-time-stamp">10:30 AM</span>
                        </div>
                    </div>

                    <!-- Recruiter Bubble 2 -->
                    <div class="message-bubble-row incoming">
                        <div class="msg-avatar-placeholder"></div>
                        <div class="msg-bubble-content incoming-bubble">
                            <p>Your profile matches our requirements perfectly. Are you available for a quick call tomorrow?</p>
                            <span class="msg-time-stamp">10:32 AM</span>
                        </div>
                    </div>

                    <!-- Sent Bubble (Outgoing) -->
                    <div class="message-bubble-row outgoing">
                        <div class="msg-bubble-content outgoing-bubble">
                            <p>Hi Mahek, thank you for reaching out! I'm definitely available tomorrow afternoon.</p>
                            <span class="msg-time-stamp sent-stamp">10:45 AM</span>
                        </div>
                    </div>
                </div>

                <!-- Message Input Footer -->
                <div class="chat-input-bar">
                    <button type="button" class="btn-chat-tool" aria-label="Attach File">
                        <i class="fa-solid fa-paperclip"></i>
                    </button>
                    <div class="chat-input-wrapper">
                        <input type="text" class="chat-input-field" placeholder="Write a message..." />
                        <button type="button" class="btn-emoji-picker" aria-label="Insert Emoji">
                            <i class="fa-regular fa-face-smile"></i>
                        </button>
                    </div>
                    <button type="button" class="btn-send-message" aria-label="Send Message">
                        <i class="fa-solid fa-paper-plane"></i>
                    </button>
                </div>
            </div>

        </div>

    </div>
</asp:Content>
