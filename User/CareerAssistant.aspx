<%@ Page Title="AI Career Assistant - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="CareerAssistant.aspx.cs" Inherits="SkillLinksX.User.CareerAssistant" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- AI Career Assistant Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-ai-assistant-container">

        <!-- 2-Column Split Layout: Left AI Chat Area (1.4fr) + Right Actionable Insights Panel (1fr) -->
        <div class="ai-assistant-grid">

            <!-- LEFT COLUMN: AI Assistant Chat Area -->
            <div class="ai-chat-card" style="display:flex; flex-direction:column; overflow:hidden;">

                <!-- Chat Header -->
                <div class="ai-chat-header flex-between" style="flex-shrink:0;">
                    <div class="ai-assistant-brand-info">
                        <div class="ai-assistant-avatar-badge">
                            <i class="fa-solid fa-robot"></i>
                            <span class="ai-status-online-dot"></span>
                        </div>
                        <div>
                            <h1 class="ai-assistant-name">AI Career Assistant</h1>
                            <p class="ai-assistant-sub">Your personal AI-powered career guide</p>
                        </div>
                    </div>
                </div>

                <!-- Chat Messages Scroll Area -->
                <div class="ai-chat-messages-area" id="aiChatMessages" style="flex:1 1 auto; min-height:0; overflow-y:auto;">

                    <!-- Message 1: AI Greeting -->
                    <div class="ai-msg-group assistant">
                        <div class="ai-msg-avatar">
                            <i class="fa-solid fa-robot"></i>
                        </div>
                        <div class="ai-msg-body">
                            <div class="ai-msg-sender-meta">AI Assistant &bull; Online</div>
                            <div class="ai-msg-bubble assistant-bubble">
                                Hi <%= (Session["UserName"] != null ? Session["UserName"].ToString() : "there") %>! I'm your SkillLinkX Career Assistant. Ask me anything about your career, interview preparation, or upload your resume (PDF, DOCX, JPG, PNG) using the clip button to get instant skill analysis!
                            </div>
                        </div>
                    </div>

                    <!-- Dynamic Chat History Repeater -->
                    <asp:Repeater ID="rptChatHistory" runat="server">
                        <ItemTemplate>
                            <div class='<%# "ai-msg-group " + (Eval("Sender").ToString() == "user" ? "user" : "assistant") %>'>
                                <asp:Panel runat="server" Visible='<%# Eval("Sender").ToString() == "assistant" %>' CssClass="ai-msg-avatar">
                                    <i class="fa-solid fa-robot"></i>
                                </asp:Panel>
                                <div class="ai-msg-body">
                                    <div class='<%# "ai-msg-sender-meta " + (Eval("Sender").ToString() == "user" ? "text-right" : "") %>'>
                                        <%# Eval("Sender").ToString() == "user" ? "You" : "AI Assistant" %> &bull; <%# Eval("Timestamp") %>
                                    </div>
                                    <div class='<%# "ai-msg-bubble " + (Eval("Sender").ToString() == "user" ? "user-bubble" : "assistant-bubble") %>'>
                                        <%# Eval("Message") %>
                                    </div>
                                </div>
                                <asp:Panel runat="server" Visible='<%# Eval("Sender").ToString() == "user" %>' CssClass="ai-msg-avatar user-avatar">
                                    <% if (!string.IsNullOrEmpty(UserPhotoUrl)) { %>
                                        <img src="<%= ResolveUrl(UserPhotoUrl) %>" alt="<%= UserName %>" style="width:100%; height:100%; border-radius:50%; object-fit:cover;" />
                                    <% } else { %>
                                        <span style="width:100%; height:100%; border-radius:50%; background:#f1f5f9; color:#64748b; display:inline-flex; align-items:center; justify-content:center; font-size:13px; border:1px solid #cbd5e1;">
                                            <i class="fa-regular fa-user"></i>
                                        </span>
                                    <% } %>
                                </asp:Panel>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>

                <!-- Chat Input Footer -->
                <div class="ai-chat-input-wrapper" style="flex-shrink:0; margin-top:auto;">
                    <!-- File Format Support Warning/Notice -->
                    <div class="ai-format-notice" style="font-size:11.5px; color:#6b7280; margin-bottom:6px; display:flex; align-items:center; gap:6px;">
                        <i class="fa-solid fa-circle-info text-blue"></i>
                        <span>Attach Resume: Supported formats: <strong>.pdf</strong>, <strong>.docx</strong>, <strong>.jpg</strong>, <strong>.png</strong> (Max 5MB)</span>
                    </div>

                    <div class="ai-chat-input-pill">
                        <!-- Hidden FileUpload triggered by paperclip -->
                        <asp:FileUpload ID="fileResume" runat="server" accept=".pdf,.docx,.jpg,.jpeg,.png" style="display:none;" onchange="this.form.submit();" />
                        <button type="button" class="btn-ai-attach" aria-label="Attach File" onclick="document.getElementById('<%= fileResume.ClientID %>').click();" title="Upload Resume (.pdf, .docx, .jpg, .png)">
                            <i class="fa-solid fa-paperclip"></i>
                        </button>

                        <asp:TextBox ID="txtMessage" runat="server" CssClass="ai-chat-text-input" placeholder="Ask AI about skills, interview prep, career roadmap..." AutoPostBack="false"></asp:TextBox>

                        <asp:LinkButton ID="btnSend" runat="server" CssClass="btn-ai-send" OnClick="btnSend_Click" aria-label="Send prompt">
                            <i class="fa-solid fa-paper-plane"></i>
                        </asp:LinkButton>
                    </div>

                    <asp:Label ID="lblUploadAlert" runat="server" CssClass="text-danger" style="font-size:12px; display:block; margin-top:4px;" EnableViewState="true"></asp:Label>

                    <div class="ai-chat-disclaimer">
                        AI responses may not be 100% accurate. Verify important career advice.
                    </div>
                </div>

            </div>

            <!-- RIGHT COLUMN: Actionable Insights Sidebar Panel -->
            <div class="ai-insights-sidebar">

                <!-- Header -->
                <div class="ai-insights-header flex-between">
                    <h2 class="ai-insights-title">Actionable Insights</h2>
                    <span class="badge-live-pulse">LIVE</span>
                </div>

                <!-- 3 Top Metric Tiles (Overall Match, Profile Strength, Resume Score) -->
                <div class="ai-metrics-3grid">
                    <div class="ai-metric-stat-card">
                        <span class="ai-metric-label">Overall Match</span>
                        <span class="ai-metric-num text-blue"><%= OverallMatchPct %>%</span>
                    </div>
                    <div class="ai-metric-stat-card">
                        <span class="ai-metric-label">Profile Strength</span>
                        <span class="ai-metric-num text-green"><%= ProfileStrengthPct %>%</span>
                    </div>
                    <div class="ai-metric-stat-card">
                        <span class="ai-metric-label">Resume Score</span>
                        <span class="ai-metric-num text-indigo"><%= ResumeScorePct %>%</span>
                    </div>
                </div>

                <!-- Skill Gap Analysis Card -->
                <div class="ai-card-panel">
                    <div class="ai-panel-header flex-between">
                        <h3 class="ai-panel-title">Skill Gap Analysis</h3>
                        <i class="fa-regular fa-circle-question text-muted" title="Based on active market demands"></i>
                    </div>

                    <div class="ai-skill-bars-list">
                        <asp:Repeater ID="rptSkillGap" runat="server">
                            <ItemTemplate>
                                <div class="ai-skill-item">
                                    <div class="ai-skill-labels flex-between">
                                        <span class="ai-skill-name"><%# Eval("SkillName") %></span>
                                        <span class="ai-skill-meta-right">
                                            <span class='<%# "ai-skill-tag-status " + Eval("TagClass") %>'><%# Eval("StatusText") %></span>
                                            <%# (bool)Eval("ShowLearn") ? "<a href=\"javascript:void(0);\" class=\"ai-learn-link\">Learn</a>" : "" %>
                                        </span>
                                    </div>
                                    <div class="ai-skill-track">
                                        <div class='<%# "ai-skill-fill " + Eval("FillClass") %>' style='<%# "width: " + Eval("Percentage") + "%;" %>'></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- Recommended Roles Card -->
                <div class="ai-card-panel">
                    <div class="ai-panel-header flex-between">
                        <h3 class="ai-panel-title">Recommended Roles</h3>
                        <a href='<%= ResolveUrl("~/User/Jobs.aspx") %>' class="ai-view-all-link">View All</a>
                    </div>

                    <div class="ai-roles-list">
                        <asp:Repeater ID="rptRecommendedRoles" runat="server">
                            <ItemTemplate>
                                <div class="ai-role-item-card">
                                    <div class="ai-role-top flex-between">
                                        <h4 class="ai-role-name"><%# Eval("Title") %></h4>
                                        <span class="badge-role-match"><%# Eval("MatchScore") %>% Match</span>
                                    </div>
                                    <div class="ai-role-subline">
                                        <%# Eval("Company") %> &bull; <%# Eval("Location") %>
                                    </div>
                                    <div class="ai-role-bottom flex-between">
                                        <span class="ai-role-salary">&#8377;<%# Eval("Salary") %></span>
                                        <span class="ai-role-posted">Posted <%# Eval("PostedAgo") %></span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- Quick Actions Block -->
                <div class="ai-quick-actions-block">
                    <div class="ai-quick-actions-title">Quick Actions</div>
                    <div class="ai-quick-actions-row">
                        <a href='<%= ResolveUrl("~/User/Jobs.aspx") %>' class="btn-ai-quick-action">
                            <i class="fa-solid fa-magnifying-glass"></i> Find Matching Jobs
                        </a>
                        <a href='<%= ResolveUrl("~/User/Notifications.aspx") %>' class="btn-ai-quick-action">
                            <i class="fa-solid fa-bell"></i> Interview Notifications
                        </a>
                    </div>
                    <a href='<%= ResolveUrl("~/User/Portfolio.aspx") %>' class="btn-ai-quick-action full-width">
                        <i class="fa-regular fa-file-lines"></i> Improve Profile &amp; Resume
                    </a>
                </div>

            </div>

        </div>

    </div>

    <script type="text/javascript">
        // Auto-scroll chat to latest message on page load and postback
        window.addEventListener('DOMContentLoaded', function () {
            var chatBox = document.getElementById('aiChatMessages');
            if (chatBox) {
                chatBox.scrollTop = chatBox.scrollHeight;
            }
        });
    </script>
</asp:Content>