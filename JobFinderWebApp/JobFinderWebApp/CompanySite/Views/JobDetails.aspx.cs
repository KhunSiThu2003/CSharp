using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class JobDetails : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
        private string jobId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CompanyId"] == null || Session["CompanyAuthenticated"] == null)
                {
                    Response.Redirect("~/CompanySite/AuthPages/CompanyLogin.aspx");
                }

                if (string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    Response.Redirect("~/CompanySite/Views/JobListings.aspx");
                }
                jobId = Request.QueryString["id"];

                LoadJobDetails(jobId);
            }
        }

        private void LoadJobDetails(string jobId)
        {
            string companyId = Session["CompanyId"].ToString(); // Changed to string

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                j.Title, j.Description, j.Requirements, j.SalaryRange,
                j.JobType, j.ExperienceLevel, j.Location, j.IsRemote,
                j.PostedDate, j.ExpiryDate, j.IsActive,
                c.Name AS CompanyName,
                (SELECT COUNT(*) FROM Applications WHERE JobId = j.JobId) AS TotalApplications,
                (SELECT COUNT(*) FROM Applications WHERE JobId = j.JobId AND ApplicationDate >= DATEADD(day, -7, GETDATE())) AS NewApplications
            FROM Jobs j
            INNER JOIN Companies c ON j.CompanyId = c.CompanyId
            WHERE j.JobId = @JobId AND j.CompanyId = @CompanyId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@JobId", jobId);
                    command.Parameters.AddWithValue("@CompanyId", companyId); // Now string

                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Set job details
                            litJobTitle.Text = reader["Title"].ToString();
                            litCompanyName.Text = reader["CompanyName"].ToString();
                            litJobType.Text = reader["JobType"].ToString();
                            litLocation.Text = reader["IsRemote"].ToString() == "True" ? "Remote" : reader["Location"].ToString();
                            litSalaryRange.Text = reader["SalaryRange"].ToString();
                            litJobDescription.Text = reader["Description"].ToString();
                            litRequirements.Text = reader["Requirements"].ToString();
                            litPostedDate.Text = Convert.ToDateTime(reader["PostedDate"]).ToString("MMM dd, yyyy");
                            litExpiryDate.Text = Convert.ToDateTime(reader["ExpiryDate"]).ToString("MMM dd, yyyy");
                            litExperienceLevel.Text = reader["ExperienceLevel"].ToString();
                            litIsRemote.Text = reader["IsRemote"].ToString() == "True" ? "Yes" : "No";
                            litTotalApplications.Text = reader["TotalApplications"].ToString();
                            litNewApplications.Text = reader["NewApplications"].ToString();

                            // Set job status
                            bool isActive = Convert.ToBoolean(reader["IsActive"]);
                            bool isExpired = Convert.ToDateTime(reader["ExpiryDate"]) < DateTime.Now;

                            if (isActive && !isExpired)
                            {
                                litJobStatus.Text = "Active";
                                btnToggleStatus.Text = "Deactivate Job";
                                btnToggleStatus.CssClass = "bg-yellow-600 hover:bg-yellow-700 focus:ring-yellow-500";
                            }
                            else
                            {
                                litJobStatus.Text = isExpired ? "Expired" : "Inactive";
                                btnToggleStatus.Text = "Activate Job";
                                btnToggleStatus.CssClass = "bg-green-600 hover:bg-green-700 focus:ring-green-500";
                            }

                            // Set edit link
                            lnkEditJob.NavigateUrl = $"~/CompanySite/Views/EditJob.aspx?id={jobId}";
                            lnkViewApplications.NavigateUrl = $"~/CompanySite/Views/Applications.aspx?jobid={jobId}";
                        }
                        else
                        {
                            // Job not found or doesn't belong to company
                            Response.Redirect("~/CompanySite/Views/JobListings.aspx");
                        }
                    }
                }
            }
        }

        protected void btnToggleStatus_Click(object sender, EventArgs e)

        {
            string jobId = Request.QueryString["id"];

            if (string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                Response.Redirect("~/CompanySite/Views/JobListings.aspx");
            }

            string companyId = Session["CompanyId"].ToString();

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Jobs SET
                            IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END
                        WHERE JobId = @JobId AND CompanyId = @CompanyId";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", jobId);
                        command.Parameters.AddWithValue("@CompanyId", companyId);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }

                // Refresh the page to show updated status
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                // Handle error
                Response.Redirect(Request.RawUrl);
            }
        }

        protected void btnDeleteJob_Click(object sender, EventArgs e)
        {
            string jobId = Request.QueryString["id"];

            if (string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                Response.Redirect("~/CompanySite/Views/JobListings.aspx");
            }

            string companyId = Session["CompanyId"].ToString();

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // First delete applications for this job
                    string deleteAppsQuery = "DELETE FROM Applications WHERE JobId = @JobId";
                    using (SqlCommand appsCommand = new SqlCommand(deleteAppsQuery, connection))
                    {
                        appsCommand.Parameters.AddWithValue("@JobId", jobId);
                        connection.Open();
                        appsCommand.ExecuteNonQuery();
                    }

                    // Then delete the job
                    string deleteJobQuery = "DELETE FROM Jobs WHERE JobId = @JobId AND CompanyId = @CompanyId";
                    using (SqlCommand jobCommand = new SqlCommand(deleteJobQuery, connection))
                    {
                        jobCommand.Parameters.AddWithValue("@JobId", jobId);
                        jobCommand.Parameters.AddWithValue("@CompanyId", companyId);
                        jobCommand.ExecuteNonQuery();
                    }
                }

                // Redirect to job listings after deletion
                Response.Redirect("~/CompanySite/Views/JobListings.aspx");
            }
            catch (Exception ex)
            {
                // Handle error
                Response.Redirect(Request.RawUrl);
            }
        }

        public string GetStatusBadgeClass()
        {
            if (litJobStatus.Text == "Active")
                return "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200";
            else if (litJobStatus.Text == "Expired")
                return "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200";
            else
                return "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200";
        }
    }
}