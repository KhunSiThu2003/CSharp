using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class Jobs : System.Web.UI.Page
    {
        private const int PageSize = 10;
        private int CurrentPage
        {
            get => ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1;
            set => ViewState["CurrentPage"] = value;
        }
        private int TotalJobs
        {
            get => ViewState["TotalJobs"] != null ? (int)ViewState["TotalJobs"] : 0;
            set => ViewState["TotalJobs"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userId"] == null)
                {
                    Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    return;
                }

                BindJobList();
            }
        }

        private void BindJobList()
        {
            string userId = Session["userId"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"]?.ConnectionString;
            if (string.IsNullOrEmpty(connectionString))
            {
                ShowError("Database connection error");
                return;
            }

            string searchTerm = txtSearch.Text.Trim();
            string jobType = ddlJobType.SelectedValue;
            string location = ddlLocation.SelectedValue;
            string experience = ddlExperience.SelectedValue;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Get total count for pagination
                    string countQuery = @"
                        SELECT COUNT(*) 
                        FROM Jobs j
                        INNER JOIN Companies c ON j.CompanyId = c.CompanyId
                        WHERE j.IsActive = 1
                        AND (@SearchTerm = '' OR j.Title LIKE '%' + @SearchTerm + '%' OR j.Description LIKE '%' + @SearchTerm + '%')
                        AND (@JobType = '' OR j.JobType = @JobType)
                        AND (@Location = '' OR j.Location = @Location OR (@Location = 'Remote' AND j.IsRemote = 1))
                        AND (@Experience = '' OR j.ExperienceLevel LIKE '%' + @Experience + '%')";

                    using (var countCommand = new SqlCommand(countQuery, connection))
                    {
                        countCommand.Parameters.AddWithValue("@SearchTerm", searchTerm);
                        countCommand.Parameters.AddWithValue("@JobType", jobType);
                        countCommand.Parameters.AddWithValue("@Location", location);
                        countCommand.Parameters.AddWithValue("@Experience", experience);

                        TotalJobs = (int)countCommand.ExecuteScalar();
                    }

                    // Get paginated job data
                    string query = @"
                        WITH JobResults AS (
                            SELECT 
                                j.JobId, 
                                j.Title AS JobTitle, 
                                j.Description, 
                                ISNULL(j.SalaryRange, 'Not specified') AS SalaryRange, 
                                j.JobType, 
                                j.ExperienceLevel, 
                                j.Location, 
                                j.IsRemote, 
                                j.PostedDate,
                                c.CompanyId, 
                                c.Name AS CompanyName, 
                                ISNULL(c.Logo, '~/Content/Images/default-company.png') AS CompanyLogo,
                                (SELECT COUNT(*) FROM SaveJobs WHERE JobId = j.JobId AND UserId = @UserId) AS IsSaved,
                                ROW_NUMBER() OVER (ORDER BY j.PostedDate DESC) AS RowNum
                            FROM Jobs j
                            INNER JOIN Companies c ON j.CompanyId = c.CompanyId
                            WHERE j.IsActive = 1
                            AND (@SearchTerm = '' OR j.Title LIKE '%' + @SearchTerm + '%' OR j.Description LIKE '%' + @SearchTerm + '%')
                            AND (@JobType = '' OR j.JobType = @JobType)
                            AND (@Location = '' OR j.Location = @Location OR (@Location = 'Remote' AND j.IsRemote = 1))
                            AND (@Experience = '' OR j.ExperienceLevel LIKE '%' + @Experience + '%')
                        )
                        SELECT * FROM JobResults
                        WHERE RowNum BETWEEN @StartIndex AND @EndIndex";

                    int startIndex = (CurrentPage - 1) * PageSize + 1;
                    int endIndex = CurrentPage * PageSize;

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        command.Parameters.AddWithValue("@SearchTerm", searchTerm);
                        command.Parameters.AddWithValue("@JobType", jobType);
                        command.Parameters.AddWithValue("@Location", location);
                        command.Parameters.AddWithValue("@Experience", experience);
                        command.Parameters.AddWithValue("@StartIndex", startIndex);
                        command.Parameters.AddWithValue("@EndIndex", endIndex);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(command))
                        {
                            da.Fill(dt);
                        }

                        if (dt.Rows.Count > 0)
                        {
                            rptJobs.DataSource = dt;
                            rptJobs.DataBind();
                            pnlNoJobs.Visible = false;
                        }
                        else
                        {
                            rptJobs.DataSource = null;
                            rptJobs.DataBind();
                            pnlNoJobs.Visible = true;
                        }

                        // Update pagination info
                        litStartItem.Text = startIndex.ToString();
                        litEndItem.Text = Math.Min(endIndex, TotalJobs).ToString();
                        litTotalItems.Text = TotalJobs.ToString();

                        btnPrevPage.Enabled = CurrentPage > 1;
                        btnNextPage.Enabled = endIndex < TotalJobs;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading jobs: {ex.Message}");
                litDebugInfo.Text = $"Error: {ex.Message}";
                pnlDebug.Visible = true;
                pnlNoJobs.Visible = true;
            }
        }

        private void ShowError(string message)
        {
            litDebugInfo.Text = message;
            pnlDebug.Visible = true;
            pnlNoJobs.Visible = true;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
            BindJobList();
        }

        protected void btnResetSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlJobType.SelectedIndex = 0;
            ddlLocation.SelectedIndex = 0;
            ddlExperience.SelectedIndex = 0;
            CurrentPage = 1;
            BindJobList();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            ddlJobType.SelectedIndex = 0;
            ddlLocation.SelectedIndex = 0;
            ddlExperience.SelectedIndex = 0;
            CurrentPage = 1;
            BindJobList();
        }

        protected void btnPrevPage_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                BindJobList();
            }
        }

        protected void btnNextPage_Click(object sender, EventArgs e)
        {
            if ((CurrentPage * PageSize) < TotalJobs)
            {
                CurrentPage++;
                BindJobList();
            }
        }

        protected void rptJobs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string jobId = e.CommandArgument.ToString();
            string userId = Session["userId"].ToString();

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (e.CommandName == "SaveJob")
                    {
                        // Toggle save/unsave
                        string query = @"
                            IF EXISTS (SELECT 1 FROM SaveJobs WHERE JobId = @JobId AND UserId = @UserId)
                                DELETE FROM SaveJobs WHERE JobId = @JobId AND UserId = @UserId
                            ELSE
                                INSERT INTO SaveJobs (JobId, UserId, SavedDate) VALUES (@JobId, @UserId, GETDATE())";

                        using (var command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@JobId", jobId);
                            command.Parameters.AddWithValue("@UserId", userId);
                            int rowsAffected = command.ExecuteNonQuery();

                            // Update the button text immediately
                            Button btnSave = (Button)e.CommandSource;
                            if (btnSave.Text == "Save")
                            {
                                btnSave.Text = "Saved";
                            }
                            else
                            {
                                btnSave.Text = "Save";
                            }
                        }
                    }
                    else if (e.CommandName == "ViewDetail")
                    {
                        Response.Redirect($"~/UserSite/Views/JobDetail.aspx?id={jobId}");
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in job command: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                    $"alert('An error occurred: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }
    }
}