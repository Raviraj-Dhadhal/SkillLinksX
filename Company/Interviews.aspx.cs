using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
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
    }

    public partial class Interviews : Page
    {
        // =========================================================================
        // [PAGE PROPERTIES]: Real-time Interview Metric Counters & Calendar State
        // =========================================================================
        public int TotalInterviewsCount { get; set; }
        public int UpcomingCount { get; set; }
        public int CompletedCount { get; set; }
        public string CurrentMonthYear { get; set; } = DateTime.Today.ToString("MMMM yyyy");
        public string CalendarGridHtml { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Company Authentication
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Company")
            {
                Response.Redirect("~/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
                LoadCompanyInterviews(companyId);
            }
        }

        // =========================================================================
        // [DATABASE & BACKEND CONNECTION]: Load Company Interviews
        // Queries 'interviews' joined with 'member_master_table'
        // =========================================================================
        private void LoadCompanyInterviews(int companyId)
        {
            CurrentMonthYear = DateTime.Today.ToString("MMMM yyyy");

            string sql = @"
                SELECT i.interview_id, i.interview_date, i.meeting_link_or_venue, i.status,
                       m.full_name AS StudentName,
                       ISNULL(i.role_title, (SELECT TOP 1 job_title FROM jobs WHERE company_id = i.company_id)) AS JobTitle
                FROM interviews i
                INNER JOIN member_master_table m ON i.user_id = m.id
                WHERE i.company_id = @cid
                ORDER BY i.interview_date DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter("@cid", companyId));

            TotalInterviewsCount = dt.Rows.Count;
            UpcomingCount = 0;
            CompletedCount = 0;

            var list = new List<CompanyInterviewItem>();
            var dayCounts = new Dictionary<int, int>();

            DateTime today = DateTime.Today;

            foreach (DataRow r in dt.Rows)
            {
                string status = r["status"] != DBNull.Value ? r["status"].ToString() : "Scheduled";
                DateTime iDate = r["interview_date"] != DBNull.Value ? Convert.ToDateTime(r["interview_date"]) : DateTime.Today;

                if (iDate >= DateTime.Today && !status.Equals("Completed", StringComparison.OrdinalIgnoreCase) && !status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase))
                    UpcomingCount++;
                else
                    CompletedCount++;

                string statusClass = "pending";
                if (status.Equals("Confirmed", StringComparison.OrdinalIgnoreCase) || status.Equals("Scheduled", StringComparison.OrdinalIgnoreCase)) statusClass = "confirmed";
                else if (status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) statusClass = "completed";

                string meetLink = r["meeting_link_or_venue"] != DBNull.Value ? r["meeting_link_or_venue"].ToString() : "https://meet.google.com/new";
                string role = r["JobTitle"] != DBNull.Value ? r["JobTitle"].ToString() : "Candidate Interview";

                list.Add(new CompanyInterviewItem
                {
                    InterviewId = r["interview_id"],
                    StudentName = r["StudentName"] != DBNull.Value ? r["StudentName"].ToString() : "Candidate",
                    JobTitle = role,
                    InterviewDateFormatted = iDate.ToString("MMM dd, yyyy - hh:mm tt"),
                    RawInterviewDate = iDate.ToString("yyyy-MM-ddTHH:mm"),
                    MeetingLink = meetLink,
                    Status = status,
                    StatusClass = statusClass
                });

                // Count interviews in current month for calendar display
                if (iDate.Year == today.Year && iDate.Month == today.Month)
                {
                    int day = iDate.Day;
                    if (!dayCounts.ContainsKey(day)) dayCounts[day] = 0;
                    dayCounts[day]++;
                }
            }

            rptUpcomingInterviews.DataSource = list;
            rptUpcomingInterviews.DataBind();

            // Generate Calendar HTML dynamically
            GenerateDynamicCalendarHtml(today, dayCounts);
        }

        private void GenerateDynamicCalendarHtml(DateTime currentMonth, Dictionary<int, int> dayCounts)
        {
            var sb = new StringBuilder();
            DateTime firstDay = new DateTime(currentMonth.Year, currentMonth.Month, 1);
            int daysInMonth = DateTime.DaysInMonth(currentMonth.Year, currentMonth.Month);
            
            // In C# Sunday = 0, Monday = 1, ... Saturday = 6
            // We want Monday = 0, ... Sunday = 6
            int startOffset = ((int)firstDay.DayOfWeek + 6) % 7;

            DateTime prevMonth = firstDay.AddMonths(-1);
            int daysInPrevMonth = DateTime.DaysInMonth(prevMonth.Year, prevMonth.Month);

            // Previous month padding days
            for (int p = startOffset - 1; p >= 0; p--)
            {
                int prevDay = daysInPrevMonth - p;
                sb.AppendFormat("<div class=\"cal-day-cell other-month\">{0}</div>\n", prevDay);
            }

            // Current month days
            for (int day = 1; day <= daysInMonth; day++)
            {
                DateTime dayDate = new DateTime(currentMonth.Year, currentMonth.Month, day);
                bool isToday = (dayDate.Date == DateTime.Today);
                bool isWeekend = (dayDate.DayOfWeek == DayOfWeek.Saturday || dayDate.DayOfWeek == DayOfWeek.Sunday);
                int count = dayCounts.ContainsKey(day) ? dayCounts[day] : 0;

                string cellClass = "cal-day-cell";
                if (isToday) cellClass += " active-today-cell";
                else if (isWeekend) cellClass += " weekend-day";

                string dateStr = dayDate.ToString("yyyy-MM-ddT10:00");

                sb.AppendFormat("<div class=\"{0}\" style=\"cursor:pointer;\" onclick=\"openScheduleModal(0, '', '', '{1}', 'https://meet.google.com/new', 'Scheduled');\" title=\"Click to schedule on {2}\">\n", 
                    cellClass, dateStr, dayDate.ToString("MMM dd"));

                if (isToday)
                {
                    sb.AppendFormat("    <span class=\"day-num today-circle\">{0}</span>\n", day);
                }
                else
                {
                    sb.AppendFormat("    <span class=\"day-num\">{0}</span>\n", day);
                }

                if (count > 0)
                {
                    sb.AppendFormat("    <div class=\"cal-event-pill today-event\">{0} Scheduled</div>\n", count);
                }

                sb.Append("</div>\n");
            }

            // Next month padding days to complete grid (up to multiple of 7)
            int totalCells = startOffset + daysInMonth;
            int remaining = (7 - (totalCells % 7)) % 7;
            for (int n = 1; n <= remaining; n++)
            {
                sb.AppendFormat("<div class=\"cal-day-cell other-month\">{0}</div>\n", n);
            }

            CalendarGridHtml = sb.ToString();
        }

        // =========================================================================
        // [EVENT HANDLER]: Save / Reschedule Interview
        // =========================================================================
        protected void btnSaveInterview_Click(object sender, EventArgs e)
        {
            int companyId = Session["CompanyId"] != null ? Convert.ToInt32(Session["CompanyId"]) : 1;
            int interviewId = 0;
            int.TryParse(hfInterviewId.Value, out interviewId);

            string candName = txtCandidateName.Text.Trim();
            string role = txtRoleTitle.Text.Trim();
            string meetLink = txtMeetingLink.Text.Trim();
            string status = ddlInterviewStatus.SelectedValue;

            DateTime interviewDate = DateTime.Now.AddDays(1);
            if (!string.IsNullOrEmpty(txtInterviewDate.Text))
            {
                DateTime.TryParse(txtInterviewDate.Text, out interviewDate);
            }

            if (string.IsNullOrEmpty(meetLink))
            {
                meetLink = "https://meet.google.com/new";
            }

            try
            {
                if (interviewId > 0)
                {
                    // Update existing interview
                    string sql = @"
                        UPDATE interviews 
                        SET interview_date = @idate, 
                            meeting_link_or_venue = @link, 
                            status = @stat,
                            role_title = @role
                        WHERE interview_id = @iid AND company_id = @cid";

                    DBHelper.ExecuteNonQuery(sql,
                        new SqlParameter("@idate", interviewDate),
                        new SqlParameter("@link", meetLink),
                        new SqlParameter("@stat", status),
                        new SqlParameter("@role", (object)role ?? DBNull.Value),
                        new SqlParameter("@iid", interviewId),
                        new SqlParameter("@cid", companyId));

                    lblScheduleMsg.ForeColor = System.Drawing.Color.Green;
                    lblScheduleMsg.Text = "Interview updated successfully!";
                }
                else
                {
                    // New interview: find user by candidate name
                    int candidateUserId = 1;
                    if (!string.IsNullOrEmpty(candName))
                    {
                        object uObj = DBHelper.ExecuteScalar(
                            "SELECT TOP 1 id FROM member_master_table WHERE full_name LIKE @q",
                            new SqlParameter("@q", "%" + candName + "%"));
                        if (uObj != null && uObj != DBNull.Value)
                            candidateUserId = Convert.ToInt32(uObj);
                    }

                    string insertSql = @"
                        INSERT INTO interviews (company_id, user_id, role_title, interview_date, meeting_link_or_venue, status)
                        VALUES (@cid, @uid, @role, @idate, @link, @stat)";

                    DBHelper.ExecuteNonQuery(insertSql,
                        new SqlParameter("@cid", companyId),
                        new SqlParameter("@uid", candidateUserId),
                        new SqlParameter("@role", (object)role ?? "Candidate Interview"),
                        new SqlParameter("@idate", interviewDate),
                        new SqlParameter("@link", meetLink),
                        new SqlParameter("@stat", status));

                    // Send notification to candidate
                    try
                    {
                        string notifSql = @"
                            INSERT INTO notifications (user_id, title, message, created_at, is_read)
                            VALUES (@uid, 'Interview Scheduled', @msg, GETDATE(), 0)";
                        string msg = $"An interview for {role} has been scheduled on {interviewDate:MMM dd, yyyy - hh:mm tt}.";
                        DBHelper.ExecuteNonQuery(notifSql,
                            new SqlParameter("@uid", candidateUserId),
                            new SqlParameter("@msg", msg));
                    }
                    catch { }

                    lblScheduleMsg.ForeColor = System.Drawing.Color.Green;
                    lblScheduleMsg.Text = "Interview scheduled successfully!";
                }
            }
            catch (Exception ex)
            {
                lblScheduleMsg.ForeColor = System.Drawing.Color.Red;
                lblScheduleMsg.Text = "Error: " + ex.Message;
            }

            LoadCompanyInterviews(companyId);
        }
    }
}
