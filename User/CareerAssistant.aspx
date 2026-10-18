<%@ Page Title="AI Career Assistant - SkillLinkX" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="CareerAssistant.aspx.cs" Inherits="SkillLinksX.User.CareerAssistant" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- AI Career Assistant Head -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-ai-assistant-container">

        <!-- 2-Column Split Layout: Left AI Chat Area (1.4fr) + Right Actionable Insights Panel (1fr) -->
        <div class="ai-assistant-grid">

            <!-- LEFT COLUMN: AI Assistant Chat Area -->
            <div class="ai-chat-card">

                <!-- Chat Header -->
                <div class="ai-chat-header flex-between">
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
                <div class="ai-chat-messages-area" id="aiChatMessages">

                    <!-- Message 1: AI Greeting -->
                    <div class="ai-msg-group assistant">
                        <div class="ai-msg-avatar">
                            <i class="fa-solid fa-robot"></i>
                        </div>
                        <div class="ai-msg-body">
                            <div class="ai-msg-sender-meta">AI Assistant &bull; 10:42 AM</div>
                            <div class="ai-msg-bubble assistant-bubble">
                                Hi Raviraj! I'm your SkillLinkX Career Assistant. How can I help you accelerate your career today? I can help analyze your profile, find matching jobs, or prepare for interviews.
                            </div>
                        </div>
                    </div>

                    <!-- Message 2: User Prompt -->
                    <div class="ai-msg-group user">
                        <div class="ai-msg-body">
                            <div class="ai-msg-sender-meta text-right">You &bull; 10:45 AM</div>
                            <div class="ai-msg-bubble user-bubble">
                                I'd like to analyze my skill gaps for Software Developer roles.
                            </div>
                        </div>
                        <div class="ai-msg-avatar user-avatar">
                            <img src="<%= ResolveUrl("~/assets/images/user-male-logo.png") %>" alt="Raviraj Dhadhal" />
                        </div>
                    </div>

                    <!-- Message 3: AI Analysis Response with Pill Buttons -->
                    <div class="ai-msg-group assistant">
                        <div class="ai-msg-avatar">
                            <i class="fa-solid fa-robot"></i>
                        </div>
                        <div class="ai-msg-body">
                            <div class="ai-msg-sender-meta">AI Assistant &bull; 10:46 AM</div>
                            <div class="ai-msg-bubble assistant-bubble">
                                <p class="mb-3">Great choice! Based on your profile and target roles in Bengaluru, here is your skill gap analysis for Software Developer positions.</p>
                                <p class="mb-3">I've noticed you have a strong foundation in frontend, but could improve your backend knowledge to increase your match rate. I've updated the Insights panel on the right with specific metrics and learning paths.</p>
                                
                                <div class="ai-chip-actions-row">
                                    <button type="button" class="btn-ai-action-chip">Show me courses for Node.js</button>
                                    <button type="button" class="btn-ai-action-chip">Update my resume</button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Chat Input Footer -->
                <div class="ai-chat-input-wrapper">
                    <div class="ai-chat-input-pill">
                        <button type="button" class="btn-ai-attach" aria-label="Attach File">
                            <i class="fa-solid fa-paperclip"></i>
                        </button>
                        <input type="text" class="ai-chat-text-input" placeholder="Write a message..." id="aiChatInput" />
                        <button type="button" class="btn-ai-send" aria-label="Send prompt" id="btnAiSend">
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </div>
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
                        <span class="ai-metric-num text-blue">87%</span>
                    </div>
                    <div class="ai-metric-stat-card">
                        <span class="ai-metric-label">Profile Strength</span>
                        <span class="ai-metric-num text-green">82%</span>
                    </div>
                    <div class="ai-metric-stat-card">
                        <span class="ai-metric-label">Resume Score</span>
                        <span class="ai-metric-num text-indigo">88%</span>
                    </div>
                </div>

                <!-- Skill Gap Analysis Card -->
                <div class="ai-card-panel">
                    <div class="ai-panel-header flex-between">
                        <h3 class="ai-panel-title">Skill Gap Analysis</h3>
                        <i class="fa-regular fa-circle-question text-muted" title="Based on active market demands"></i>
                    </div>

                    <div class="ai-skill-bars-list">
                        <!-- Skill 1: React.js -->
                        <div class="ai-skill-item">
                            <div class="ai-skill-labels flex-between">
                                <span class="ai-skill-name">React.js</span>
                                <span class="ai-skill-tag-status tag-strong">Strong</span>
                            </div>
                            <div class="ai-skill-track">
                                <div class="ai-skill-fill fill-green" style="width: 95%;"></div>
                            </div>
                        </div>

                        <!-- Skill 2: Node.js -->
                        <div class="ai-skill-item">
                            <div class="ai-skill-labels flex-between">
                                <span class="ai-skill-name">Node.js</span>
                                <span class="ai-skill-meta-right">
                                    <span class="ai-skill-tag-status tag-needs-work">Needs Work</span>
                                    <a href="javascript:void(0);" class="ai-learn-link">Learn</a>
                                </span>
                            </div>
                            <div class="ai-skill-track">
                                <div class="ai-skill-fill fill-orange" style="width: 50%;"></div>
                            </div>
                        </div>

                        <!-- Skill 3: SQL -->
                        <div class="ai-skill-item">
                            <div class="ai-skill-labels flex-between">
                                <span class="ai-skill-name">SQL</span>
                                <span class="ai-skill-meta-right">
                                    <span class="ai-skill-tag-status tag-developing">Developing</span>
                                    <a href="javascript:void(0);" class="ai-learn-link">Learn</a>
                                </span>
                            </div>
                            <div class="ai-skill-track">
                                <div class="ai-skill-fill fill-blue" style="width: 65%;"></div>
                            </div>
                        </div>

                        <!-- Skill 4: Git -->
                        <div class="ai-skill-item">
                            <div class="ai-skill-labels flex-between">
                                <span class="ai-skill-name">Git</span>
                                <span class="ai-skill-tag-status tag-strong">Strong</span>
                            </div>
                            <div class="ai-skill-track">
                                <div class="ai-skill-fill fill-green" style="width: 90%;"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recommended Roles Card -->
                <div class="ai-card-panel">
                    <div class="ai-panel-header flex-between">
                        <h3 class="ai-panel-title">Recommended Roles</h3>
                        <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="ai-view-all-link">View All</a>
                    </div>

                    <div class="ai-roles-list">
                        <!-- Role 1: Software Developer (Fresher) -->
                        <div class="ai-role-item-card">
                            <div class="ai-role-top flex-between">
                                <h4 class="ai-role-name">Software Developer (Fresher)</h4>
                                <span class="badge-role-match">92% Match</span>
                            </div>
                            <div class="ai-role-subline">TechFlow &bull; Bengaluru, KA</div>
                            <div class="ai-role-bottom flex-between">
                                <span class="ai-role-salary">&#8377;6L - &#8377;8L / yr</span>
                                <span class="ai-role-posted">Posted 2d ago</span>
                            </div>
                        </div>

                        <!-- Role 2: Frontend Intern -->
                        <div class="ai-role-item-card">
                            <div class="ai-role-top flex-between">
                                <h4 class="ai-role-name">Frontend Intern</h4>
                                <span class="badge-role-match">89% Match</span>
                            </div>
                            <div class="ai-role-subline">Zomato &bull; Mumbai, MH</div>
                            <div class="ai-role-bottom flex-between">
                                <span class="ai-role-salary">&#8377;25k - &#8377;30k / mo</span>
                                <span class="ai-role-posted">Posted 5h ago</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions Block -->
                <div class="ai-quick-actions-block">
                    <div class="ai-quick-actions-title">Quick Actions</div>
                    <div class="ai-quick-actions-row">
                        <a href="<%= ResolveUrl("~/User/Jobs.aspx") %>" class="btn-ai-quick-action">
                            <i class="fa-solid fa-magnifying-glass"></i> Find Matching Jobs
                        </a>
                        <a href="#" class="btn-ai-quick-action">
                            <i class="fa-solid fa-user-tie"></i> Prepare for Interview
                        </a>
                    </div>
                    <a href="<%= ResolveUrl("~/User/Portfolio.aspx") %>" class="btn-ai-quick-action full-width">
                        <i class="fa-regular fa-file-lines"></i> Improve Profile & Resume
                    </a>
                </div>

            </div>

        </div>

    </div>
</asp:Content>
