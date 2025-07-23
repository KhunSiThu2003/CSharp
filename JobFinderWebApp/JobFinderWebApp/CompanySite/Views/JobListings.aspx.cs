using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class JobListings : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
        private int currentPage = 1;
        private const int pageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CompanyId"] == null || Session["CompanyAuthenticated"] == null)
                {
                    Response.Redirect("~/CompanySite/AuthPages/CompanyLogin.aspx");
                }

                currentPage = 1;
                BindJobs();
            }
        }

        private void BindJobs()
        {
            string companyId = Session["CompanyId"].ToString();
            string searchTerm = txtSearch.Text.Trim();
            string statusFilter = ddlStatus.SelectedValue;
            string jobTypeFilter = ddlJobTypeFilter.SelectedValue;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        j.JobId, j.Title, j.Description, j.Requirements, j.SalaryRange,
                        j.JobType, j.ExperienceLevel, j.Location, j.IsRemote,
                        j.PostedDate, j.ExpiryDate, j.IsActive,
                        (SELECT COUNT(*) FROM Applications WHERE JobId = j.JobId) AS ApplicationCount
                    FROM Jobs j
                    WHERE j.CompanyId = @CompanyId";

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " AND (j.Title LIKE '%' + @SearchTerm + '%' OR j.Description LIKE '%' + @SearchTerm + '%')";
                }

                if (statusFilter == "active")
                {
                    query += " AND j.IsActive = 1 AND j.ExpiryDate >= GETDATE()";
                }
                else if (statusFilter == "expired")
                {
                    query += " AND (j.IsActive = 0 OR j.ExpiryDate < GETDATE())";
                }

                if (jobTypeFilter != "all")
                {
                    query += " AND j.JobType = @JobType";
                }

                query += " ORDER BY j.PostedDate DESC";
                query += $" OFFSET {(currentPage - 1) * pageSize} ROWS FETCH NEXT {pageSize} ROWS ONLY";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@CompanyId", companyId);

                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        command.Parameters.AddWithValue("@SearchTerm", searchTerm);
                    }

                    if (jobTypeFilter != "all")
                    {
                        command.Parameters.AddWithValue("@JobType", jobTypeFilter);
                    }

                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    rptJobs.DataSource = dt;
                    rptJobs.DataBind();
                    pnlEmptyState.Visible = dt.Rows.Count == 0;
                }

                // Pagination logic remains the same
                // ...
            }
        }

        [System.Web.Services.WebMethod]
        public static string DeleteJob(string jobId, string companyId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlTransaction transaction = connection.BeginTransaction();

                    try
                    {
                        // Delete applications first
                        string deleteAppsQuery = "DELETE FROM Applications WHERE JobId = @JobId";
                        using (SqlCommand appsCommand = new SqlCommand(deleteAppsQuery, connection, transaction))
                        {
                            appsCommand.Parameters.AddWithValue("@JobId", jobId);
                            appsCommand.ExecuteNonQuery();
                        }

                        // Then delete the job
                        string deleteJobQuery = "DELETE FROM Jobs WHERE JobId = @JobId AND CompanyId = @CompanyId";
                        using (SqlCommand jobCommand = new SqlCommand(deleteJobQuery, connection, transaction))
                        {
                            jobCommand.Parameters.AddWithValue("@JobId", jobId);
                            jobCommand.Parameters.AddWithValue("@CompanyId", companyId);
                            int rowsAffected = jobCommand.ExecuteNonQuery();

                            if (rowsAffected == 0)
                            {
                                transaction.Rollback();
                                return "error:Job not found or you don't have permission to delete it";
                            }
                        }

                        transaction.Commit();
                        return "success:Job deleted successfully";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return $"error:{ex.Message}";
                    }
                }
            }
            catch (Exception ex)
            {
                return $"error:{ex.Message}";
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            currentPage = 1;
            BindJobs();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                BindJobs();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            currentPage++;
            BindJobs();
        }
    }
}