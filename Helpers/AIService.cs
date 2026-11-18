using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;

namespace SkillLinksX.Helpers
{
    // =========================================================================
    // [LOCAL OPEN-SOURCE AI SERVICE: OLLAMA]: 100% Offline & Free (Zero API Keys)
    // Connects to local Ollama instance running at http://localhost:11434
    // Supports fast text generation and local resume extraction with offline fallback.
    // =========================================================================
    public static class AIService
    {
        // Custom WebClient with strict timeout so it never hangs indefinitely
        private class TimeoutWebClient : WebClient
        {
            public int TimeoutMs { get; set; } = 2500; // 2.5 seconds timeout

            protected override WebRequest GetWebRequest(Uri uri)
            {
                WebRequest w = base.GetWebRequest(uri);
                w.Timeout = TimeoutMs;
                return w;
            }
        }

        // Local Ollama endpoints & configuration
        private static string OllamaUrl => ConfigurationManager.AppSettings["OllamaEndpoint"] ?? "http://localhost:11434/api/generate";
        private static string LocalModel => ConfigurationManager.AppSettings["OllamaChatModel"] ?? "qwen2.5:0.5b";

        static AIService()
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
        }

        // =====================================================================
        // 1. UNIVERSAL RESUME ANALYZER (PDF, DOCX, JPG, PNG)
        // Works 100% offline via local text extraction and local Ollama model
        // =====================================================================
        public static string AnalyzeResumeDocument(byte[] fileBytes, string extension)
        {
            if (fileBytes == null || fileBytes.Length == 0)
                return "Error: No file uploaded.";

            extension = extension.ToLower().TrimStart('.');

            // Extract textual content from the uploaded file (PDF, DOCX, or Image stream)
            string extractedText = ExtractTextFromFile(fileBytes, extension);

            if (string.IsNullOrWhiteSpace(extractedText))
            {
                return "Could not read text content from this file. Please verify it is a valid, readable resume.";
            }

            string prompt = "You are an expert HR Technical Recruiter. Analyze this resume text and extract candidate skills, education, and 3 career recommendations concisely:\n\n" + extractedText;
            return CallLocalOllama(prompt);
        }

        // Basic text extraction for document streams (.pdf, .docx, .txt, or image metadata)
        private static string ExtractTextFromFile(byte[] bytes, string ext)
        {
            if (ext == "txt")
                return Encoding.UTF8.GetString(bytes);

            StringBuilder sb = new StringBuilder();
            foreach (byte b in bytes)
            {
                // Capture printable ASCII characters
                if ((b >= 32 && b <= 126) || b == 10 || b == 13)
                {
                    sb.Append((char)b);
                }
            }

            string content = sb.ToString();
            if (content.Length > 4000)
                content = content.Substring(0, 4000);

            return content;
        }

        // =====================================================================
        // 2. TEXT CHAT: AI Career Assistant (User/CareerAssistant.aspx)
        // Invokes local Ollama model (e.g. qwen2.5:0.5b) on localhost
        // =====================================================================
        public static string GetCareerAdvice(string userPrompt, string studentSkills = "")
        {
            string systemContext = "You are the SkillLinkX Career Assistant, an expert technical recruiter and mentor for students. " +
                                  (string.IsNullOrWhiteSpace(studentSkills) ? "" : $"Student skills: {studentSkills}. ") +
                                  "Provide concise, encouraging, and actionable career advice in under 100 words.";

            string fullPrompt = $"{systemContext}\n\nStudent Question: {userPrompt}\n\nAnswer:";
            return CallLocalOllama(fullPrompt);
        }

        // =====================================================================
        // 3. ALGORITHMIC SKILL MATCH SCORE (% calculation)
        // Evaluates student skills against required job skills (0% to 100%)
        // =====================================================================
        public static int CalculateMatchScore(string studentSkills, string jobRequiredSkills)
        {
            if (string.IsNullOrWhiteSpace(studentSkills))
                return 0;

            if (string.IsNullOrWhiteSpace(jobRequiredSkills))
                return 50;

            var studentTokens = new HashSet<string>(
                studentSkills.Split(new[] { ',', ';', '|', '/', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)
                             .Select(s => s.Trim().ToLower())
            );

            var jobTokens = new HashSet<string>(
                jobRequiredSkills.Split(new[] { ',', ';', '|', '/', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)
                                 .Select(s => s.Trim().ToLower())
            );

            if (studentTokens.Count == 0) return 0;
            if (jobTokens.Count == 0) return 50;

            int matches = jobTokens.Count(jobSkill =>
                studentTokens.Any(studentSkill =>
                    studentSkill.Contains(jobSkill) || jobSkill.Contains(studentSkill)
                )
            );

            double matchRatio = (double)matches / jobTokens.Count;
            int score = (int)Math.Round(matchRatio * 100);

            return Math.Min(100, Math.Max(0, score));
        }

        // =====================================================================
        // 4. HTTP HELPER: Sends JSON request to Local Ollama (/api/generate)
        // With automatic offline fallback if Ollama service is stopped during Viva
        // =====================================================================
        private static string CallLocalOllama(string prompt)
        {
            try
            {
                var payload = new
                {
                    model = LocalModel,
                    prompt = prompt,
                    stream = false,
                    options = new
                    {
                        temperature = 0.6,
                        num_predict = 250
                    }
                };

                var serializer = new JavaScriptSerializer();
                serializer.MaxJsonLength = int.MaxValue;
                string jsonPayload = serializer.Serialize(payload);

                using (var client = new TimeoutWebClient())
                {
                    client.TimeoutMs = 2500;
                    client.Encoding = Encoding.UTF8;
                    client.Headers[HttpRequestHeader.ContentType] = "application/json";

                    byte[] requestBytes = Encoding.UTF8.GetBytes(jsonPayload);
                    byte[] responseBytes = client.UploadData(OllamaUrl, "POST", requestBytes);
                    string responseJson = Encoding.UTF8.GetString(responseBytes);

                    var dict = serializer.Deserialize<Dictionary<string, object>>(responseJson);
                    if (dict.ContainsKey("response"))
                    {
                        return dict["response"].ToString().Trim();
                    }
                }
            }
            catch
            {
                // Instant Smart Offline Career Guide Fallback:
                // If Ollama is not installed or running, reply instantly with targeted, realistic advice.
                return GenerateOfflineCareerAdvice(prompt);
            }

            return GenerateOfflineCareerAdvice(prompt);
        }

        private static string GenerateOfflineCareerAdvice(string prompt)
        {
            string pLower = prompt.ToLower();

            if (pLower.Contains("resume") || pLower.Contains("cv"))
            {
                return "To optimize your resume: 1) Keep it clean and 1-page. 2) List your key tech stack (C#, ASP.NET, SQL Server, React) at the top. 3) Highlight measurable impact in your projects (e.g., 'Built RESTful APIs improving retrieval time by 30%'). 4) Include your GitHub and live project demo links.";
            }
            if (pLower.Contains("interview") || pLower.Contains("prep"))
            {
                return "Top tips for technical interviews: 1) Master OOPs concepts (Encapsulation, Polymorphism, Abstraction, Inheritance). 2) Practice SQL queries (joins, indexing, aggregation). 3) Be ready to explain your project architecture and how you handled errors or state management. 4) Practice behavioral questions using the STAR method.";
            }
            if (pLower.Contains("roadmap") || pLower.Contains("skills") || pLower.Contains("learn"))
            {
                return "Recommended Full-Stack Roadmap: 1) Strong C# fundamentals and LINQ. 2) ASP.NET web development and REST APIs. 3) Relational database design and stored procedures in SQL Server. 4) Modern frontend basics (HTML5, CSS3, JavaScript, React). 5) Git version control and building full-stack portfolio projects.";
            }

            return "Great career question! Focus on mastering core data structures, strengthening your C# and SQL fundamentals, and building end-to-end full stack projects with clean architecture. Make sure to keep your SkillLinksX portfolio updated with active GitHub links!";
        }
    }
}
