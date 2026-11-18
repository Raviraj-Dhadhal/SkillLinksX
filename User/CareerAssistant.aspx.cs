using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using SkillLinksX.Helpers;

namespace SkillLinksX.User
{
    // =========================================================================
    // [STATE MANAGEMENT & AI CHAT MODEL]: ChatMessageItem
    // Marked [Serializable] to store conversation history inside ViewState.
    // =========================================================================
    [Serializable]
    public class ChatMessageItem
    {
        public string Sender { get; set; } // "user" or "assistant"
        public string Message { get; set; }
        public string Timestamp { get; set; }
    }

    public partial class CareerAssistant : Page
    {
        public int OverallMatchPct { get; set; } = 0;
        public int ProfileStrengthPct { get; set; } = 50;
        public int ResumeScorePct { get; set; } = 0;
        public string UserPhotoUrl { get; set; } = "";
        public string UserName { get; set; } = "You";
        public string UserInitials { get; set; } = "U";

        // =====================================================================
        // [FILE RESTRICTION]: Only these 4 file formats are permitted
        // =====================================================================
        private static readonly string[] AllowedExtensions = { ".pdf", ".docx", ".jpg", ".jpeg", ".png" };

        // =====================================================================
        // [STATE MANAGEMENT: VIEWSTATE]: Keeps chat conversation across postbacks
        // =====================================================================
        private List<ChatMessageItem> ChatHistory
        {
            get
            {
                if (ViewState["ChatHistory"] == null)
                    ViewState["ChatHistory"] = new List<ChatMessageItem>();
                return (List<ChatMessageItem>)ViewState["ChatHistory"];
            }
            set
            {
                ViewState["ChatHistory"] = value;
            }
        }

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "U";
            var parts = name.Trim().Split(new[] { ' ', '.', '_' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Length >= 2 ? parts[0].Substring(0, 2).ToUpper() : parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Session-based authentication check
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            int studentId = Convert.ToInt32(Session["UserId"]);

            // Load user profile photo & name
            try
            {
                DataTable dtUser = DBHelper.ExecuteQuery("SELECT full_name, profile_photo FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                if (dtUser != null && dtUser.Rows.Count > 0)
                {
                    string name = dtUser.Rows[0]["full_name"] != DBNull.Value ? dtUser.Rows[0]["full_name"].ToString().Trim() : "";
                    if (!string.IsNullOrEmpty(name))
                    {
                        UserName = name;
                        UserInitials = GetInitials(name);
                    }
                    if (dtUser.Rows[0]["profile_photo"] != DBNull.Value)
                    {
                        string p = dtUser.Rows[0]["profile_photo"].ToString().Trim();
                        if (!string.IsNullOrEmpty(p)) UserPhotoUrl = p;
                    }
                }
            }
            catch { }

            // Handle file upload immediately when paperclip input changes
            if (IsPostBack && fileResume.HasFile)
            {
                HandleResumeUpload();
            }

            if (!IsPostBack)
            {
                BindChatHistory();
                LoadDynamicSkillGap(studentId);
                LoadCandidateMetrics(studentId);
                LoadRecommendedRoles();
            }
        }

        private void LoadRecommendedRoles()
        {
            try
            {
                string sql = @"
                    SELECT TOP 3 j.job_title AS Title, COALESCE(c.comp_name, 'SkillLinksX Partner') AS Company, 
                           COALESCE(j.location, 'India') AS Location,
                           j.salary_min, j.salary_max
                    FROM jobs j
                    LEFT JOIN company_table c ON j.company_id = c.company_id
                    WHERE j.status = 'Active' OR j.status IS NULL
                    ORDER BY j.job_id DESC";
                DataTable dt = DBHelper.ExecuteQuery(sql);
                var list = new List<dynamic>();
                foreach (DataRow r in dt.Rows)
                {
                    decimal min = r["salary_min"] != DBNull.Value ? Convert.ToDecimal(r["salary_min"]) : 300000;
                    decimal max = r["salary_max"] != DBNull.Value ? Convert.ToDecimal(r["salary_max"]) : 600000;
                    string salStr = min > 0 ? $"{min / 100000:0.#} - {max / 100000:0.#} LPA" : "Competitive";
                    list.Add(new
                    {
                        Title = r["Title"].ToString(),
                        Company = r["Company"].ToString(),
                        Location = r["Location"].ToString(),
                        Salary = salStr,
                        PostedAgo = "Recently",
                        MatchScore = 85
                    });
                }
                rptRecommendedRoles.DataSource = list;
                rptRecommendedRoles.DataBind();
            }
            catch { }
        }

        private void LoadCandidateMetrics(int studentId)
        {
            try
            {
                object strObj = DBHelper.ExecuteScalar("SELECT profile_strength FROM member_master_table WHERE id = @id", new SqlParameter("@id", studentId));
                if (strObj != null && strObj != DBNull.Value)
                {
                    ProfileStrengthPct = Convert.ToInt32(strObj);
                }
                else
                {
                    ProfileStrengthPct = 50;
                }

                string folder = Server.MapPath("~/Uploads/Resumes/");
                if (Directory.Exists(folder))
                {
                    var files = Directory.GetFiles(folder, $"Resume_{studentId}.*");
                    if (files.Length > 0)
                    {
                        byte[] bytes = File.ReadAllBytes(files[0]);
                        string raw = System.Text.Encoding.ASCII.GetString(bytes);
                        bool hasText = System.Text.RegularExpressions.Regex.IsMatch(raw, @"\b(skills?|education|experience|project|developer|engineer|university|college|asp\.net|c#|sql|react|javascript)\b", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                        ResumeScorePct = hasText ? 85 : 15;
                    }
                    else
                    {
                        ResumeScorePct = 0;
                    }
                }
            }
            catch { }
        }

        // =====================================================================
        // [DATABASE CONNECTION]: Load Dynamic Skill Gap Analysis from DB
        // Reads candidate's real skills from member_master_table and benchmarks
        // =====================================================================
        private void LoadDynamicSkillGap(int studentId)
        {
            try
            {
                string sql = "SELECT skills FROM member_master_table WHERE id = @id";
                object skillObj = DBHelper.ExecuteScalar(sql, new SqlParameter("@id", studentId));
                string rawSkills = skillObj != null ? skillObj.ToString() : "";

                var userSkills = rawSkills.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                                          .Select(s => s.Trim().ToLowerInvariant())
                                          .ToList();

                var benchmarkList = new List<string> { "C#", "ASP.NET", "SQL Server", "JavaScript", "React", "Git" };
                var gapList = new List<dynamic>();

                foreach (var bench in benchmarkList)
                {
                    bool hasSkill = userSkills.Any(u => u.Contains(bench.ToLowerInvariant()) || bench.ToLowerInvariant().Contains(u));
                    if (hasSkill)
                    {
                        gapList.Add(new
                        {
                            SkillName = bench,
                            StatusText = "Strong",
                            TagClass = "tag-strong",
                            FillClass = "fill-green",
                            Percentage = 90,
                            ShowLearn = false
                        });
                    }
                    else
                    {
                        gapList.Add(new
                        {
                            SkillName = bench,
                            StatusText = "Needs Work",
                            TagClass = "tag-needs-work",
                            FillClass = "fill-orange",
                            Percentage = 35,
                            ShowLearn = true
                        });
                    }
                }

                rptSkillGap.DataSource = gapList;
                rptSkillGap.DataBind();

                int strongCount = userSkills.Count > 0 ? benchmarkList.Count(b => userSkills.Any(u => u.Contains(b.ToLowerInvariant()) || b.ToLowerInvariant().Contains(u))) : 0;
                OverallMatchPct = benchmarkList.Count > 0 ? (int)Math.Round(((double)strongCount / benchmarkList.Count) * 100) : 0;
            }
            catch
            {
                // Fallback safe binding
            }
        }

        // =====================================================================
        // [AI CHAT BACKEND]: Send prompt to Groq LLM and append to chat
        // =====================================================================
        protected void btnSend_Click(object sender, EventArgs e)
        {
            string query = txtMessage.Text.Trim();
            if (string.IsNullOrEmpty(query)) return;

            lblUploadAlert.Text = "";

            // 1. Add User query to conversation history
            var history = ChatHistory;
            history.Add(new ChatMessageItem
            {
                Sender = "user",
                Message = Server.HtmlEncode(query),
                Timestamp = DateTime.Now.ToString("hh:mm tt")
            });

            // 2. Call AIService to get AI career guidance response
            string aiResponse = AIService.GetCareerAdvice(query);
            history.Add(new ChatMessageItem
            {
                Sender = "assistant",
                Message = aiResponse.Replace("\n", "<br/>"),
                Timestamp = DateTime.Now.ToString("hh:mm tt")
            });

            ChatHistory = history;
            txtMessage.Text = "";
            BindChatHistory();
        }

        // =====================================================================
        // [RESUME UPLOAD & AI VISION/LLM ANALYSIS]:
        // Validates the 4 supported formats (.pdf, .docx, .jpg, .png) and passes
        // file bytes to AIService.AnalyzeResumeDocument.
        // =====================================================================
        private void HandleResumeUpload()
        {
            lblUploadAlert.Text = "";
            string ext = Path.GetExtension(fileResume.FileName).ToLower();

            // Format validation check
            if (!AllowedExtensions.Contains(ext))
            {
                lblUploadAlert.Text = "Invalid file type. Only .pdf, .docx, .jpg, and .png are allowed.";
                return;
            }

            // File size validation (Max 5MB)
            if (fileResume.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                lblUploadAlert.Text = "File size exceeds 5MB. Please upload a smaller file.";
                return;
            }

            try
            {
                byte[] fileBytes = fileResume.FileBytes;
                
                // Call universal AI document analyzer (Vision AI for images, LLM for docs)
                string analysis = AIService.AnalyzeResumeDocument(fileBytes, ext);

                var history = ChatHistory;
                history.Add(new ChatMessageItem
                {
                    Sender = "user",
                    Message = $"Uploaded Resume: <strong>{fileResume.FileName}</strong>",
                    Timestamp = DateTime.Now.ToString("hh:mm tt")
                });

                history.Add(new ChatMessageItem
                {
                    Sender = "assistant",
                    Message = $"<strong>Resume & Skill Analysis:</strong><br/>{analysis.Replace("\n", "<br/>")}",
                    Timestamp = DateTime.Now.ToString("hh:mm tt")
                });

                ChatHistory = history;
                BindChatHistory();
            }
            catch (Exception ex)
            {
                lblUploadAlert.Text = "AI Analysis Error: " + ex.Message;
            }
        }

        // =====================================================================
        // [UI DATA BINDING]: Binds chat history list to ASP.NET Repeater
        // =====================================================================
        private void BindChatHistory()
        {
            rptChatHistory.DataSource = ChatHistory;
            rptChatHistory.DataBind();
        }
    }
}
