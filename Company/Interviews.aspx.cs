using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using SkillLinksX.Helpers;

namespace SkillLinksX.Company
{
    public class CompanyInterviewItem
    {
        public object InterviewId { get; set; }
        public string StudentName { get; set; }
        public string JobTitle { get; set; }
        public string InterviewDateFormatted { get; set; }
        public string RawInterviewDate { get; set; }
        public string MeetingLink { get; set; }
        public string Status { get; set; }
        public string StatusClass { get; set; }
        public string ProfilePhoto { get; set; }
        public DateTime FullDateTime { get; set; }
    }

    public partial class Interviews : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Interview Metric Counters & Calendar State
        // =========================================================================
        public int TotalInterviewsCount { get; set; }
        public int UpcomingCount { get; set; }
        public int CompletedCount { get; set; }
        public int ActiveJobsCount { get; set; }
        public string CurrentMonthYear { get; set; } = DateTime.Today.ToString("MMMM yyyy");
        public string CalendarGridHtml { get; set; } = "";

        public DateTime CalendarDate
        {
            get
            {
                if (ViewState["CalendarDate"] == null)
                    ViewState["CalendarDate"] = DateTime.Today;
                return (DateTime)ViewState["CalendarDate"];
            }
            set { ViewState["CalendarDate"] = value; }
        }

        public string CalendarViewMode
        {
            get
            {
                if (ViewState["CalendarViewMode"] == null)
                    ViewState["CalendarViewMode"] = "Month";
                return (string)ViewState["CalendarViewMode"];
            }
            set { ViewState["CalendarViewMode"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            // Ensure DB schema has application_id nullable & notification columns present
            DBHelper.EnsureInterviewColumns();
            DBHelper.EnsureNotificationColumns();

            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);

            if (!IsPostBack)
            {
                LoadCompanyInterviews(companyId);

                // Handle pre-fill from query string (e.g. from CandidateProfile or Applicants)
                bool autoOpenModal = false;
                if (Request.QueryString["name"] != null)
                {
                    txtCandidateName.Text = Server.UrlDecode(Request.QueryString["name"]);
                    autoOpenModal = true;
                }
                if (Request.QueryString["role"] != null)
                {
                    txtRoleTitle.Text = Server.UrlDecode(Request.QueryString["role"]);
                    autoOpenModal = true;
                }
                if (string.IsNullOrEmpty(txtInterviewDate.Text))
                {
                    txtInterviewDate.Text = DateTime.Today.AddDays(1).ToString("yyyy-MM-dd") + "T10:00";
                }
                if (string.IsNullOrEmpty(txtMeetingLink.Text))
                {
                    txtMeetingLink.Text = "https://meet.google.com/new";
                }

                if (autoOpenModal)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AutoOpenModal", "setTimeout(function(){ if (typeof openScheduleModal === 'function') openScheduleModal(0, '" + txtCandidateName.Text.Replace("'", "\\'") + "', '" + txtRoleTitle.Text.Replace("'", "\\'") + "', '" + txtInterviewDate.Text + "', '" + txtMeetingLink.Text + "', 'Scheduled'); }, 200);", true);
                }
            }
        }

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "C";
            var parts = name.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Length >= 2 ? parts[0].Substring(0, 2).ToUpper() : parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        // =========================================================================
        // [CALENDAR NAVIGATION HANDLERS]
        // =========================================================================
        protected void btnPrevMonth_Click(object sender, EventArgs e)
        {
            if (CalendarViewMode == "Week")
                CalendarDate = CalendarDate.AddDays(-7);
            else
                CalendarDate = CalendarDate.AddMonths(-1);

            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
            LoadCompanyInterviews(companyId);
        }

        protected void btnNextMonth_Click(object sender, EventArgs e)
        {
            if (CalendarViewMode == "Week")
                CalendarDate = CalendarDate.AddDays(7);
            else
                CalendarDate = CalendarDate.AddMonths(1);

            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
            LoadCompanyInterviews(companyId);
        }

        protected void btnViewMonth_Click(object sender, EventArgs e)
        {
            CalendarViewMode = "Month";
            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
            LoadCompanyInterviews(companyId);
        }

        protected void btnViewWeek_Click(object sender, EventArgs e)
        {
            CalendarViewMode = "Week";
            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
            LoadCompanyInterviews(companyId);
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Company Interviews
        // Queries 'interviews' joined with 'member_master_table'
        // =========================================================================
        private void LoadCompanyInterviews(int companyId)
        {
            string sql = @"
                SELECT i.interview_id, i.interview_date, i.interview_time, i.mode, i.meeting_link_or_venue, i.status,
                       m.full_name AS StudentName,
                       m.profile_photo AS ProfilePhoto,
                       COALESCE(
                           (SELECT TOP 1 j.job_title FROM applications a INNER JOIN jobs j ON a.job_id = j.job_id WHERE a.user_id = i.user_id AND j.company_id = i.company_id),
                           (SELECT TOP 1 i2.internship_title FROM applications a INNER JOIN internships i2 ON a.internship_id = i2.internship_id WHERE a.user_id = i.user_id AND i2.company_id = i.company_id),
                           (SELECT TOP 1 j.job_title FROM jobs j WHERE j.company_id = i.company_id),
                           'Applicant'
                       ) AS JobTitle
                FROM interviews i
                INNER JOIN member_master_table m ON i.user_id = m.id
                WHERE i.company_id = @cid
                ORDER BY i.interview_date DESC, i.interview_time DESC";

            DataTable dt = null;
            try
            {
                dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));
            }
            catch
            {
                // Fallback query if interview_time or mode column missing in legacy test table
                dt = DBHelper.ExecuteQuery(@"
                    SELECT i.interview_id, i.interview_date, i.meeting_link_or_venue, i.status,
                           m.full_name AS StudentName,
                           m.profile_photo AS ProfilePhoto,
                           'Applicant' AS JobTitle
                    FROM interviews i
                    INNER JOIN member_master_table m ON i.user_id = m.id
                    WHERE i.company_id = @cid
                    ORDER BY i.interview_date DESC", new SqlParameter("@cid", companyId));
            }

            TotalInterviewsCount = dt != null ? dt.Rows.Count : 0;
            UpcomingCount = 0;
            CompletedCount = 0;

            try
            {
                object jobCountObj = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM jobs WHERE company_id = @cid AND status = 'Active'", new SqlParameter("@cid", companyId));
                ActiveJobsCount = (jobCountObj != null && jobCountObj != DBNull.Value) ? Convert.ToInt32(jobCountObj) : 0;
            }
            catch { ActiveJobsCount = 0; }

            var list = new List<CompanyInterviewItem>();
            var dayInterviewMap = new Dictionary<DateTime, List<CompanyInterviewItem>>();

            if (dt != null)
            {
                foreach (DataRow r in dt.Rows)
                {
                    string status = r["status"] != DBNull.Value ? r["status"].ToString().Trim() : "Scheduled";
                    DateTime iDate = r["interview_date"] != DBNull.Value ? Convert.ToDateTime(r["interview_date"]) : DateTime.Today;

                    TimeSpan iTime = new TimeSpan(10, 0, 0);
                    if (r.Table.Columns.Contains("interview_time") && r["interview_time"] != DBNull.Value)
                    {
                        if (TimeSpan.TryParse(r["interview_time"].ToString(), out TimeSpan parsedTime))
                        {
                            iTime = parsedTime;
                        }
                    }

                    DateTime fullDateTime = iDate.Date.Add(iTime);

                    if (fullDateTime >= DateTime.Today && !status.Equals("Completed", StringComparison.OrdinalIgnoreCase) && !status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase))
                        UpcomingCount++;
                    else
                        CompletedCount++;

                    string statusClass = "pending";
                    if (status.Equals("Confirmed", StringComparison.OrdinalIgnoreCase) || status.Equals("Scheduled", StringComparison.OrdinalIgnoreCase)) statusClass = "confirmed";
                    else if (status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) statusClass = "completed";
                    else if (status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase)) statusClass = "rejected";

                    string meetLink = r["meeting_link_or_venue"] != DBNull.Value ? r["meeting_link_or_venue"].ToString() : "https://meet.google.com/new";
                    string role = r.Table.Columns.Contains("JobTitle") && r["JobTitle"] != DBNull.Value ? r["JobTitle"].ToString() : "Candidate Interview";
                    string photo = r.Table.Columns.Contains("ProfilePhoto") && r["ProfilePhoto"] != DBNull.Value ? r["ProfilePhoto"].ToString() : "";
                    string studentName = r["StudentName"] != DBNull.Value ? r["StudentName"].ToString() : "Candidate";

                    var item = new CompanyInterviewItem
                    {
                        InterviewId = r["interview_id"],
                        StudentName = studentName,
                        JobTitle = role,
                        InterviewDateFormatted = fullDateTime.ToString("MMM dd, yyyy - hh:mm tt"),
                        RawInterviewDate = fullDateTime.ToString("yyyy-MM-ddTHH:mm"),
                        MeetingLink = meetLink,
                        Status = status,
                        StatusClass = statusClass,
                        ProfilePhoto = photo,
                        FullDateTime = fullDateTime
                    };

                    list.Add(item);

                    DateTime dateKey = iDate.Date;
                    if (!dayInterviewMap.ContainsKey(dateKey))
                        dayInterviewMap[dateKey] = new List<CompanyInterviewItem>();
                    dayInterviewMap[dateKey].Add(item);
                }
            }

            rptUpcomingInterviews.DataSource = list;
            rptUpcomingInterviews.DataBind();

            // Load candidate list for datalist auto-suggest
            LoadApplicantsDatalist(companyId);

            // Update view button styling
            btnViewMonth.CssClass = CalendarViewMode == "Month" ? "cal-toggle-btn active" : "cal-toggle-btn";
            btnViewWeek.CssClass = CalendarViewMode == "Week" ? "cal-toggle-btn active" : "cal-toggle-btn";

            // Generate Calendar based on active view mode
            if (CalendarViewMode == "Week")
            {
                int diff = (7 + (int)CalendarDate.DayOfWeek - 1) % 7;
                DateTime startOfWeek = CalendarDate.AddDays(-1 * diff).Date;
                DateTime endOfWeek = startOfWeek.AddDays(6).Date;
                CurrentMonthYear = $"{startOfWeek:MMM dd} - {endOfWeek:MMM dd, yyyy}";
                GenerateWeeklyCalendarHtml(startOfWeek, dayInterviewMap);
            }
            else
            {
                CurrentMonthYear = CalendarDate.ToString("MMMM yyyy");
                GenerateMonthlyCalendarHtml(CalendarDate, dayInterviewMap);
            }
        }

        private void LoadApplicantsDatalist(int companyId)
        {
            try
            {
                string candListSql = @"
                    SELECT DISTINCT m.id AS UserId, m.full_name AS FullName, m.email_add AS Email,
                           ISNULL(j.job_title, i.internship_title) AS RoleTitle
                    FROM applications a
                    INNER JOIN member_master_table m ON a.user_id = m.id
                    LEFT JOIN jobs j ON a.job_id = j.job_id
                    LEFT JOIN internships i ON a.internship_id = i.internship_id
                    WHERE a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid";

                DataTable dtCands = DBHelper.ExecuteQuery(candListSql, new SqlParameter("@cid", companyId));
                rptApplicantsDatalist.DataSource = dtCands;
                rptApplicantsDatalist.DataBind();
            }
            catch { }
        }

        private void GenerateMonthlyCalendarHtml(DateTime currentMonth, Dictionary<DateTime, List<CompanyInterviewItem>> dayInterviewMap)
        {
            var sb = new StringBuilder();
            DateTime firstDay = new DateTime(currentMonth.Year, currentMonth.Month, 1);
            int daysInMonth = DateTime.DaysInMonth(currentMonth.Year, currentMonth.Month);
            
            // In C# Sunday = 0, Monday = 1, ... Saturday = 6 -> convert to Mon=0 ... Sun=6
            int startOffset = ((int)firstDay.DayOfWeek + 6) % 7;

            DateTime prevMonth = firstDay.AddMonths(-1);
            int daysInPrevMonth = DateTime.DaysInMonth(prevMonth.Year, prevMonth.Month);

            // Previous month padding days
            for (int p = startOffset - 1; p >= 0; p--)
            {
                int prevDay = daysInPrevMonth - p;
                DateTime padDate = new DateTime(prevMonth.Year, prevMonth.Month, prevDay);
                string padDateStr = padDate.ToString("yyyy-MM-ddT10:00");
                sb.AppendFormat("<div class=\"cal-day-cell other-month\" style=\"cursor:pointer;\" onclick=\"openScheduleModal(0, '', '', '{0}', 'https://meet.google.com/new', 'Scheduled');\" title=\"Schedule on {1}\"><span class=\"day-num\" style=\"opacity:0.4;\">{2}</span></div>\n",
                    padDateStr, padDate.ToString("MMM dd"), prevDay);
            }

            // Current month days
            for (int day = 1; day <= daysInMonth; day++)
            {
                DateTime dayDate = new DateTime(currentMonth.Year, currentMonth.Month, day);
                bool isToday = (dayDate.Date == DateTime.Today);
                bool isWeekend = (dayDate.DayOfWeek == DayOfWeek.Saturday || dayDate.DayOfWeek == DayOfWeek.Sunday);

                string cellClass = "cal-day-cell";
                if (isToday) cellClass += " active-today-cell";
                else if (isWeekend) cellClass += " weekend-day";

                string dateStr = dayDate.ToString("yyyy-MM-ddT10:00");

                sb.AppendFormat("<div class=\"{0}\" style=\"cursor:pointer; min-height:85px; position:relative;\" onclick=\"if(event.target.closest('.cal-event-pill')) return; openScheduleModal(0, '', '', '{1}', 'https://meet.google.com/new', 'Scheduled');\" title=\"Click to schedule on {2}\">\n", 
                    cellClass, dateStr, dayDate.ToString("MMM dd"));

                if (isToday)
                {
                    sb.AppendFormat("    <span class=\"day-num today-circle\">{0}</span>\n", day);
                }
                else
                {
                    sb.AppendFormat("    <span class=\"day-num\">{0}</span>\n", day);
                }

                if (dayInterviewMap.ContainsKey(dayDate.Date))
                {
                    var dayList = dayInterviewMap[dayDate.Date];
                    foreach (var iv in dayList)
                    {
                        string pillClass = isToday ? "cal-event-pill today-event" : "cal-event-pill";
                        if (iv.Status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) pillClass += " today-event-green";
                        
                        string timeStr = iv.FullDateTime.ToString("hh:mm tt");
                        sb.AppendFormat("    <div class=\"{0}\" onclick=\"event.stopPropagation(); openScheduleModal({1}, '{2}', '{3}', '{4}', '{5}', '{6}');\" title=\"{2} ({3}) at {7} - Status: {6}\">\n",
                            pillClass, iv.InterviewId, iv.StudentName.Replace("'", "\\'"), iv.JobTitle.Replace("'", "\\'"), iv.RawInterviewDate, iv.MeetingLink.Replace("'", "\\'"), iv.Status, timeStr);
                        sb.AppendFormat("        <span>{0} - {1}</span>\n", timeStr, iv.StudentName);
                        sb.AppendFormat("    </div>\n");
                    }
                }

                sb.Append("</div>\n");
            }

            // Next month padding days to complete grid
            int totalCells = startOffset + daysInMonth;
            int remaining = (7 - (totalCells % 7)) % 7;
            DateTime nextMonth = firstDay.AddMonths(1);
            for (int n = 1; n <= remaining; n++)
            {
                DateTime nextDate = new DateTime(nextMonth.Year, nextMonth.Month, n);
                string nextDateStr = nextDate.ToString("yyyy-MM-ddT10:00");
                sb.AppendFormat("<div class=\"cal-day-cell other-month\" style=\"cursor:pointer;\" onclick=\"openScheduleModal(0, '', '', '{0}', 'https://meet.google.com/new', 'Scheduled');\" title=\"Schedule on {1}\"><span class=\"day-num\" style=\"opacity:0.4;\">{2}</span></div>\n",
                    nextDateStr, nextDate.ToString("MMM dd"), n);
            }

            CalendarGridHtml = sb.ToString();
        }

        private void GenerateWeeklyCalendarHtml(DateTime startOfWeek, Dictionary<DateTime, List<CompanyInterviewItem>> dayInterviewMap)
        {
            var sb = new StringBuilder();

            for (int i = 0; i < 7; i++)
            {
                DateTime dayDate = startOfWeek.AddDays(i);
                bool isToday = (dayDate.Date == DateTime.Today);
                bool isWeekend = (dayDate.DayOfWeek == DayOfWeek.Saturday || dayDate.DayOfWeek == DayOfWeek.Sunday);

                string cellClass = "cal-day-cell";
                if (isToday) cellClass += " active-today-cell";
                else if (isWeekend) cellClass += " weekend-day";

                string dateStr = dayDate.ToString("yyyy-MM-ddT10:00");

                sb.AppendFormat("<div class=\"{0}\" style=\"cursor:pointer; min-height:220px; position:relative; padding:10px;\" onclick=\"if(event.target.closest('.cal-event-pill')) return; openScheduleModal(0, '', '', '{1}', 'https://meet.google.com/new', 'Scheduled');\" title=\"Click to schedule on {2}\">\n", 
                    cellClass, dateStr, dayDate.ToString("MMM dd"));

                sb.Append("<div style=\"display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;\">\n");
                if (isToday)
                    sb.AppendFormat("    <span class=\"day-num today-circle\">{0}</span>\n", dayDate.Day);
                else
                    sb.AppendFormat("    <span class=\"day-num\" style=\"font-size:13px; font-weight:700;\">{0}</span>\n", dayDate.Day);

                sb.AppendFormat("    <span style=\"font-size:11px; color:#64748b;\">{0}</span>\n", dayDate.ToString("MMM dd"));
                sb.Append("</div>\n");

                if (dayInterviewMap.ContainsKey(dayDate.Date))
                {
                    var dayList = dayInterviewMap[dayDate.Date];
                    foreach (var iv in dayList)
                    {
                        string pillClass = isToday ? "cal-event-pill today-event" : "cal-event-pill";
                        if (iv.Status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) pillClass += " today-event-green";

                        string timeStr = iv.FullDateTime.ToString("hh:mm tt");
                        sb.AppendFormat("<div class=\"{0}\" style=\"margin-bottom:6px; padding:6px 8px; border-radius:6px; cursor:pointer;\" onclick=\"event.stopPropagation(); openScheduleModal({1}, '{2}', '{3}', '{4}', '{5}', '{6}');\" title=\"Edit {2}\">\n",
                            pillClass, iv.InterviewId, iv.StudentName.Replace("'", "\\'"), iv.JobTitle.Replace("'", "\\'"), iv.RawInterviewDate, iv.MeetingLink.Replace("'", "\\'"), iv.Status);
                        sb.AppendFormat("    <div style=\"font-weight:700;\">{0}</div>\n", iv.StudentName);
                        sb.AppendFormat("    <div style=\"font-size:10px; opacity:0.9;\">{0} • {1}</div>\n", timeStr, iv.JobTitle);
                        sb.Append("</div>\n");
                    }
                }
                else
                {
                    sb.Append("<div style=\"text-align:center; padding-top:40px; color:#94a3b8; font-size:11px;\"><i class=\"fa-regular fa-calendar-plus\" style=\"font-size:16px; margin-bottom:4px; display:block;\"></i>+ Book Slot</div>\n");
                }

                sb.Append("</div>\n");
            }

            CalendarGridHtml = sb.ToString();
        }

        // =========================================================================
        // [EVENT HANDLER]: Save / Reschedule Interview
        // Inserts all required columns into 'dbo.interviews' per schema reference
        // =========================================================================
        protected void btnSaveInterview_Click(object sender, EventArgs e)
        {
            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
            int interviewId = 0;
            int.TryParse(hfInterviewId.Value, out interviewId);

            string candName = txtCandidateName.Text.Trim();
            string role = txtRoleTitle.Text.Trim();
            string meetLink = txtMeetingLink.Text.Trim();
            string status = ddlInterviewStatus.SelectedValue;

            DateTime interviewDateTime = DateTime.Today.AddDays(1).AddHours(10);
            if (!string.IsNullOrEmpty(txtInterviewDate.Text))
            {
                string dtStr = txtInterviewDate.Text.Trim();
                string[] dateFormats = new[] {
                    "yyyy-MM-ddTHH:mm", "yyyy-MM-ddTHH:mm:ss",
                    "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss",
                    "dd-MM-yyyy HH:mm", "dd-MM-yyyy HH:mm:ss",
                    "dd/MM/yyyy HH:mm", "dd/MM/yyyy HH:mm:ss",
                    "MM/dd/yyyy HH:mm", "MM/dd/yyyy HH:mm:ss",
                    "yyyy-MM-dd", "dd-MM-yyyy", "dd/MM/yyyy"
                };

                if (DateTime.TryParseExact(dtStr, dateFormats, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out DateTime exactDt))
                {
                    interviewDateTime = exactDt;
                }
                else if (DateTime.TryParse(dtStr, out DateTime parsedDt))
                {
                    interviewDateTime = parsedDt;
                }
            }

            TimeSpan interviewTime = interviewDateTime.TimeOfDay;
            if (interviewTime == TimeSpan.Zero)
            {
                interviewTime = new TimeSpan(10, 0, 0); // 10:00 AM default
            }

            DateTime interviewDateOnly = interviewDateTime.Date;

            if (string.IsNullOrEmpty(meetLink))
            {
                meetLink = "https://meet.google.com/new";
            }

            string mode = "Google Meet";
            string interviewerName = Session["UserName"] != null ? Session["UserName"].ToString() : "Hiring Team";
            string interviewNotes = !string.IsNullOrEmpty(role) ? "Interview round for " + role : "Candidate Interview";

            try
            {
                if (interviewId > 0)
                {
                    // Update existing interview
                    string sql = @"
                        UPDATE interviews 
                        SET interview_date = @idate,
                            interview_time = @itime,
                            meeting_link_or_venue = @link,
                            mode = @mode,
                            interviewer_name = @interviewer,
                            notes = @notes,
                            status = @stat
                        WHERE interview_id = @iid AND company_id = @cid";

                    DBHelper.ExecuteNonQuery(sql,
                        new SqlParameter("@idate", interviewDateOnly),
                        new SqlParameter("@itime", SqlDbType.Time) { Value = interviewTime },
                        new SqlParameter("@link", meetLink),
                        new SqlParameter("@mode", mode),
                        new SqlParameter("@interviewer", interviewerName),
                        new SqlParameter("@notes", interviewNotes),
                        new SqlParameter("@stat", status),
                        new SqlParameter("@iid", interviewId),
                        new SqlParameter("@cid", companyId));

                    lblScheduleMsg.ForeColor = System.Drawing.Color.Green;
                    lblScheduleMsg.Text = "Interview updated successfully!";
                }
                else
                {
                    // New interview: find user by candidate name or fallback
                    int candidateUserId = 0;
                    if (!string.IsNullOrEmpty(candName))
                    {
                        object uObj = DBHelper.ExecuteScalar(
                            "SELECT TOP 1 id FROM member_master_table WHERE full_name LIKE @q OR email_add LIKE @q",
                            new SqlParameter("@q", "%" + candName + "%"));
                        if (uObj != null && uObj != DBNull.Value)
                            candidateUserId = Convert.ToInt32(uObj);
                    }

                    if (candidateUserId <= 0)
                    {
                        // Look for any candidate who applied to this company
                        object appUserObj = DBHelper.ExecuteScalar(@"
                            SELECT TOP 1 a.user_id 
                            FROM applications a 
                            WHERE a.company_id = @cid OR EXISTS (SELECT 1 FROM jobs j WHERE j.job_id = a.job_id AND j.company_id = @cid)
                            ORDER BY a.applied_at DESC", new SqlParameter("@cid", companyId));
                        if (appUserObj != null && appUserObj != DBNull.Value)
                            candidateUserId = Convert.ToInt32(appUserObj);
                        else
                        {
                            object firstMember = DBHelper.ExecuteScalar("SELECT TOP 1 id FROM member_master_table ORDER BY id ASC");
                            if (firstMember != null && firstMember != DBNull.Value)
                                candidateUserId = Convert.ToInt32(firstMember);
                            else
                                candidateUserId = 1;
                        }
                    }

                    // Attempt to resolve application_id for this candidate and company
                    int targetAppId = 0;
                    try
                    {
                        object appObj = DBHelper.ExecuteScalar(@"
                            SELECT TOP 1 a.application_id 
                            FROM applications a
                            LEFT JOIN jobs j ON a.job_id = j.job_id
                            LEFT JOIN internships i ON a.internship_id = i.internship_id
                            WHERE a.user_id = @uid AND (a.company_id = @cid OR j.company_id = @cid OR i.company_id = @cid)
                            ORDER BY a.applied_at DESC",
                            new SqlParameter("@uid", candidateUserId),
                            new SqlParameter("@cid", companyId));

                        if (appObj != null && appObj != DBNull.Value)
                        {
                            targetAppId = Convert.ToInt32(appObj);
                        }
                    }
                    catch { }

                    string insertSql = @"
                        INSERT INTO interviews (company_id, user_id, application_id, interview_date, interview_time, mode, meeting_link_or_venue, interviewer_name, notes, status)
                        VALUES (@cid, @uid, @appid, @idate, @itime, @mode, @link, @interviewer, @notes, @stat)";

                    DBHelper.ExecuteNonQuery(insertSql,
                        new SqlParameter("@cid", companyId),
                        new SqlParameter("@uid", candidateUserId),
                        new SqlParameter("@appid", targetAppId > 0 ? (object)targetAppId : DBNull.Value),
                        new SqlParameter("@idate", interviewDateOnly),
                        new SqlParameter("@itime", SqlDbType.Time) { Value = interviewTime },
                        new SqlParameter("@mode", mode),
                        new SqlParameter("@link", meetLink),
                        new SqlParameter("@interviewer", interviewerName),
                        new SqlParameter("@notes", interviewNotes),
                        new SqlParameter("@stat", status));

                    // If linked to an application, update application status to 'Interview Scheduled'
                    if (targetAppId > 0)
                    {
                        try
                        {
                            DBHelper.ExecuteNonQuery(
                                "UPDATE applications SET status = 'Interview Scheduled', updated_at = GETDATE() WHERE application_id = @aid",
                                new SqlParameter("@aid", targetAppId));
                        }
                        catch { }
                    }

                    // Send notification to candidate
                    DBHelper.SendNotification(candidateUserId, 
                        "Interview Scheduled 📅", 
                        $"An interview for {role} has been scheduled on {interviewDateTime:MMM dd, yyyy - hh:mm tt}. Join link: {meetLink}", 
                        "~/User/Applications.aspx");

                    lblScheduleMsg.ForeColor = System.Drawing.Color.Green;
                    lblScheduleMsg.Text = "Interview scheduled successfully! Candidate notified.";
                }

                // Close modal and refresh interviews
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseScheduleModal", "setTimeout(function(){ closeScheduleModal(); }, 1200);", true);
            }
            catch (Exception ex)
            {
                lblScheduleMsg.ForeColor = System.Drawing.Color.Red;
                lblScheduleMsg.Text = "Error: " + ex.Message;
                // Keep modal open so company can see the error
                ScriptManager.RegisterStartupScript(this, GetType(), "KeepModalOpen", "document.getElementById('scheduleModal').style.display='flex';", true);
            }

            LoadCompanyInterviews(companyId);
        }

        // =========================================================================
        // [EVENT HANDLER]: Remove / Delete Interview from Upcoming List
        // =========================================================================
        protected void rptUpcomingInterviews_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveInterview")
            {
                int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
                int interviewId = 0;
                if (int.TryParse(e.CommandArgument?.ToString(), out interviewId) && interviewId > 0)
                {
                    try
                    {
                        DBHelper.ExecuteNonQuery(
                            "DELETE FROM interviews WHERE interview_id = @iid AND company_id = @cid",
                            new SqlParameter("@iid", interviewId),
                            new SqlParameter("@cid", companyId));
                    }
                    catch { }
                }

                LoadCompanyInterviews(companyId);
            }
        }

        // =========================================================================
        // [EVENT HANDLER]: Delete Interview from Schedule / Reschedule Modal
        // =========================================================================
        protected void btnDeleteModalInterview_Click(object sender, EventArgs e)
        {
            int companyId = DBHelper.GetCurrentCompanyId(Convert.ToInt32(Session["UserId"]), Session);
            int interviewId = 0;
            if (int.TryParse(hfInterviewId.Value, out interviewId) && interviewId > 0)
            {
                try
                {
                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM interviews WHERE interview_id = @iid AND company_id = @cid",
                        new SqlParameter("@iid", interviewId),
                        new SqlParameter("@cid", companyId));
                }
                catch { }
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "CloseScheduleModal", "closeScheduleModal();", true);
            LoadCompanyInterviews(companyId);
        }
    }
}
