using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using SkillLinksX.Helpers;

namespace SkillLinksX.Handlers
{
    /// <summary>
    /// SearchHandler is a lightweight backend API endpoint (.ashx).
    /// It receives search queries from JavaScript, queries the SQL Server database,
    /// and sends back clean JSON results for Jobs, Internships, and People.
    /// It does not render any HTML pages; it only sends data.
    /// </summary>
    public class SearchHandler : IHttpHandler, IReadOnlySessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            // Set the response format to JSON so the browser JavaScript knows it is receiving data
            context.Response.ContentType = "application/json";
            context.Response.Charset = "utf-8";

            // Prevent the browser from caching old search results so the search is always fresh
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetNoStore();

            // Read the search keyword passed in the URL (for example: ?q=developer)
            string query = (context.Request.QueryString["q"] ?? "").Trim();

            // If the query is empty or shorter than 2 letters, return an empty result immediately
            if (string.IsNullOrEmpty(query) || query.Length < 2)
            {
                var emptyResult = new
                {
                    success = true,
                    query = query,
                    jobs = new List<object>(),
                    internships = new List<object>(),
                    people = new List<object>()
                };
                context.Response.Write(new JavaScriptSerializer().Serialize(emptyResult));
                return;
            }

            try
            {
                // Prepare the search pattern with wildcards (e.g. %developer%) for SQL LIKE queries
                string searchPattern = "%" + query + "%";

                // Determine the current user's role from Session (e.g. Student, Company, Admin, or Guest)
                // This helps us build appropriate profile or detail links for the user
                string userRole = context.Session["Role"]?.ToString() ?? "Guest";

                // -------------------------------------------------------------
                // 1. QUERY JOBS
                // Database Table: dbo.jobs (joined with dbo.company_table)
                // We check both c.profile_photo and c.logo_url using COALESCE so that
                // whether the company uploaded a logo or set logo_url, we fetch the valid one.
                // -------------------------------------------------------------
                string sqlJobs = @"
                    SELECT TOP 5 
                        j.job_id, 
                        j.job_title, 
                        j.category, 
                        j.job_type, 
                        j.location, 
                        j.requirements,
                        c.comp_name, 
                        COALESCE(NULLIF(c.profile_photo, ''), NULLIF(c.logo_url, '')) AS company_logo
                    FROM jobs j
                    INNER JOIN company_table c ON j.company_id = c.company_id
                    WHERE (j.status = 'Active' OR j.status IS NULL)
                      AND (
                            j.job_title LIKE @q 
                            OR j.requirements LIKE @q 
                            OR j.category LIKE @q 
                            OR c.comp_name LIKE @q
                          )
                    ORDER BY j.job_id DESC";

                DataTable dtJobs = DBHelper.ExecuteQuery(sqlJobs, new SqlParameter("@q", searchPattern));
                var jobList = new List<object>();

                if (dtJobs != null)
                {
                    foreach (DataRow row in dtJobs.Rows)
                    {
                        int jobId = Convert.ToInt32(row["job_id"]);
                        string title = row["job_title"].ToString();
                        string companyName = row["comp_name"].ToString();
                        string location = row["location"] != DBNull.Value ? row["location"].ToString() : "";
                        string requirements = row["requirements"] != DBNull.Value ? row["requirements"].ToString() : "";
                        // Validate and resolve company logo (returns empty string if missing or file not found)
                        string resolvedLogo = CleanLogoUrl(row["company_logo"]);

                        // Determine destination link based on who is logged in
                        string linkUrl = userRole == "Guest" 
                            ? "~/Public/Login.aspx?returnUrl=" + HttpUtility.UrlEncode("~/User/JobDetails.aspx?id=" + jobId)
                            : "~/User/JobDetails.aspx?id=" + jobId;

                        jobList.Add(new
                        {
                            id = jobId,
                            title = title,
                            subtitle = companyName + (string.IsNullOrEmpty(location) ? "" : " • " + location),
                            skills = requirements,
                            logo = resolvedLogo,
                            type = "Job",
                            url = VirtualPathUtility.ToAbsolute(linkUrl)
                        });
                    }
                }

                // -------------------------------------------------------------
                // 2. QUERY INTERNSHIPS
                // Database Table: dbo.internships (joined with dbo.company_table)
                // We check both profile_photo and logo_url so the company logo is fetched
                // correctly regardless of which field stored the image.
                // -------------------------------------------------------------
                string sqlInternships = @"
                    SELECT TOP 5 
                        i.internship_id, 
                        i.internship_title, 
                        i.category, 
                        i.duration_months, 
                        i.stipend_amount, 
                        i.stipend_type, 
                        i.skills_required,
                        c.comp_name, 
                        COALESCE(NULLIF(c.profile_photo, ''), NULLIF(c.logo_url, '')) AS company_logo
                    FROM internships i
                    INNER JOIN company_table c ON i.company_id = c.company_id
                    WHERE (i.status = 'Active' OR i.status IS NULL)
                      AND (
                            i.internship_title LIKE @q 
                            OR i.skills_required LIKE @q 
                            OR i.category LIKE @q 
                            OR c.comp_name LIKE @q
                          )
                    ORDER BY i.internship_id DESC";

                DataTable dtInternships = DBHelper.ExecuteQuery(sqlInternships, new SqlParameter("@q", searchPattern));
                var internshipList = new List<object>();

                if (dtInternships != null)
                {
                    foreach (DataRow row in dtInternships.Rows)
                    {
                        int internshipId = Convert.ToInt32(row["internship_id"]);
                        string title = row["internship_title"].ToString();
                        string companyName = row["comp_name"].ToString();
                        string skillsRequired = row["skills_required"] != DBNull.Value ? row["skills_required"].ToString() : "";
                        int duration = row["duration_months"] != DBNull.Value ? Convert.ToInt32(row["duration_months"]) : 0;
                        string resolvedLogo = CleanLogoUrl(row["company_logo"]);

                        string linkUrl = userRole == "Guest"
                            ? "~/Public/Login.aspx?returnUrl=" + HttpUtility.UrlEncode("~/User/InternshipDetails.aspx?id=" + internshipId)
                            : "~/User/InternshipDetails.aspx?id=" + internshipId;

                        internshipList.Add(new
                        {
                            id = internshipId,
                            title = title,
                            subtitle = companyName + (duration > 0 ? $" • {duration} Months" : ""),
                            skills = skillsRequired,
                            logo = resolvedLogo,
                            type = "Internship",
                            url = VirtualPathUtility.ToAbsolute(linkUrl)
                        });
                    }
                }

                // -------------------------------------------------------------
                // 3. QUERY PEOPLE (Students/Candidates & Companies)
                // Database Table A: dbo.member_master_table (Students)
                // Columns: id, full_name, skills, degree, clg_name, city, profile_photo
                // Database Table B: dbo.company_table (Companies)
                // Columns: company_id, comp_name, industry, city, logo_url
                // -------------------------------------------------------------
                var peopleList = new List<object>();

                // A. Search Student Candidates
                string sqlStudents = @"
                    SELECT TOP 5 
                        m.id, 
                        m.full_name, 
                        m.skills, 
                        m.degree, 
                        m.clg_name, 
                        m.city, 
                        m.profile_photo
                    FROM member_master_table m
                    WHERE (m.category = 'Student' OR m.category IS NULL)
                      AND (
                            m.full_name LIKE @q 
                            OR m.skills LIKE @q 
                            OR m.degree LIKE @q 
                            OR m.clg_name LIKE @q
                          )
                    ORDER BY m.id DESC";

                DataTable dtStudents = DBHelper.ExecuteQuery(sqlStudents, new SqlParameter("@q", searchPattern));
                if (dtStudents != null)
                {
                    foreach (DataRow row in dtStudents.Rows)
                    {
                        int memberId = Convert.ToInt32(row["id"]);
                        string name = row["full_name"].ToString();
                        string skills = row["skills"] != DBNull.Value ? row["skills"].ToString() : "";
                        string degree = row["degree"] != DBNull.Value ? row["degree"].ToString() : "";
                        string college = row["clg_name"] != DBNull.Value ? row["clg_name"].ToString() : "";
                        string resolvedPhoto = CleanPhotoUrl(row["profile_photo"]);

                        // Determine destination link for candidate:
                        // - Admin goes to Admin/Students.aspx?id=...
                        // - Company goes to Company/CandidateProfile.aspx?id=...
                        // - Student goes to User/Networking.aspx
                        string linkUrl = "~/User/Networking.aspx";
                        if (userRole == "Admin") linkUrl = "~/Admin/Students.aspx";
                        else if (userRole == "Company") linkUrl = "~/Company/CandidateProfile.aspx?id=" + memberId;

                        string subtitle = !string.IsNullOrEmpty(degree) ? degree : college;

                        peopleList.Add(new
                        {
                            id = memberId,
                            title = name,
                            subtitle = subtitle,
                            skills = skills,
                            logo = resolvedPhoto,
                            type = "Candidate",
                            url = VirtualPathUtility.ToAbsolute(linkUrl)
                        });
                    }
                }

                // B. Search Companies (as organizations in People category)
                // We check both profile_photo and logo_url to get the company's uploaded or configured logo
                string sqlCompanies = @"
                    SELECT TOP 4 
                        c.company_id, 
                        c.comp_name, 
                        c.industry, 
                        c.city, 
                        COALESCE(NULLIF(c.profile_photo, ''), NULLIF(c.logo_url, '')) AS company_logo
                    FROM company_table c
                    WHERE c.comp_name LIKE @q 
                       OR c.industry LIKE @q 
                       OR c.city LIKE @q
                    ORDER BY c.company_id DESC";

                DataTable dtCompanies = DBHelper.ExecuteQuery(sqlCompanies, new SqlParameter("@q", searchPattern));
                if (dtCompanies != null)
                {
                    foreach (DataRow row in dtCompanies.Rows)
                    {
                        int compId = Convert.ToInt32(row["company_id"]);
                        string compName = row["comp_name"].ToString();
                        string industry = row["industry"] != DBNull.Value ? row["industry"].ToString() : "Company";
                        string city = row["city"] != DBNull.Value ? row["city"].ToString() : "";
                        string resolvedLogo = CleanLogoUrl(row["company_logo"]);

                        string linkUrl = "~/User/Jobs.aspx";
                        if (userRole == "Admin") linkUrl = "~/Admin/Companies.aspx";

                        peopleList.Add(new
                        {
                            id = compId,
                            title = compName,
                            subtitle = industry + (string.IsNullOrEmpty(city) ? "" : " • " + city),
                            skills = "",
                            logo = resolvedLogo,
                            type = "Company",
                            url = VirtualPathUtility.ToAbsolute(linkUrl)
                        });
                    }
                }

                // -------------------------------------------------------------
                // 4. COMBINE AND RETURN FINAL JSON RESPONSE
                // -------------------------------------------------------------
                var responsePayload = new
                {
                    success = true,
                    query = query,
                    jobs = jobList,
                    internships = internshipList,
                    people = peopleList
                };

                string jsonOutput = new JavaScriptSerializer().Serialize(responsePayload);
                context.Response.Write(jsonOutput);
            }
            catch (Exception ex)
            {
                // In case of an unexpected database error, return a clean error JSON
                var errorPayload = new
                {
                    success = false,
                    message = "Search query failed: " + ex.Message
                };
                context.Response.Write(new JavaScriptSerializer().Serialize(errorPayload));
            }
        }

        /// <summary>
        /// Validates company logo. If missing, placeholder, or file does not exist on disk,
        /// returns empty string so the UI displays the clean FontAwesome building icon.
        /// </summary>
        private static string CleanLogoUrl(object raw)
        {
            if (raw == null || raw == DBNull.Value) return "";
            string path = raw.ToString().Trim();
            if (string.IsNullOrEmpty(path)) return "";

            // Ignore placeholder / dummy file names
            if (path.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                path.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                path.IndexOf("placeholder", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return "";
            }

            // Verify if local file actually exists on server
            if (!path.StartsWith("http://", StringComparison.OrdinalIgnoreCase) && 
                !path.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
            {
                try
                {
                    string relative = path.StartsWith("~") ? path : "~/" + path.TrimStart('~', '/');
                    if (HttpContext.Current != null)
                    {
                        string physicalPath = HttpContext.Current.Server.MapPath(relative);
                        if (!System.IO.File.Exists(physicalPath))
                        {
                            return ""; // Broken path: fallback to building icon!
                        }
                    }
                }
                catch
                {
                    return "";
                }
            }

            return DBHelper.ResolveImageUrl(path, "");
        }

        /// <summary>
        /// Validates student photo. If missing, placeholder, or file does not exist on disk,
        /// returns empty string so the UI displays the clean fa-regular fa-user icon.
        /// </summary>
        private static string CleanPhotoUrl(object raw)
        {
            if (raw == null || raw == DBNull.Value) return "";
            string path = raw.ToString().Trim();
            if (string.IsNullOrEmpty(path)) return "";

            if (path.IndexOf("user-male-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                path.IndexOf("user-female-logo", StringComparison.OrdinalIgnoreCase) >= 0 ||
                path.IndexOf("placeholder", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return "";
            }

            if (!path.StartsWith("http://", StringComparison.OrdinalIgnoreCase) && 
                !path.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
            {
                try
                {
                    string relative = path.StartsWith("~") ? path : "~/" + path.TrimStart('~', '/');
                    if (HttpContext.Current != null)
                    {
                        string physicalPath = HttpContext.Current.Server.MapPath(relative);
                        if (!System.IO.File.Exists(physicalPath))
                        {
                            return ""; // Broken path: fallback to fa-regular fa-user icon!
                        }
                    }
                }
                catch
                {
                    return "";
                }
            }

            return DBHelper.ResolveImageUrl(path, "");
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
