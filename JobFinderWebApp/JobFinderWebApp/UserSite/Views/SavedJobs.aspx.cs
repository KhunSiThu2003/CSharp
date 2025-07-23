using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class SavedJobs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userId"] == null)
                {
                    Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    return;
                }

                LoadSavedJobs();
            }
        }

        private void LoadSavedJobs()
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

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        SELECT 
                            sj.SavedJobId,
                            sj.SavedDate,
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
                            ISNULL(c.Logo, '~/Content/Images/default-company.png') AS CompanyLogo
                        FROM SaveJobs sj
                        INNER JOIN Jobs j ON sj.JobId = j.JobId
                        INNER JOIN Companies c ON j.CompanyId = c.CompanyId
                        WHERE sj.UserId = @UserId
                        AND j.IsActive = 1
                        ORDER BY sj.SavedDate DESC";

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(command))
                        {
                            da.Fill(dt);
                        }

                        if (dt.Rows.Count > 0)
                        {
                            rptSavedJobs.DataSource = dt;
                            rptSavedJobs.DataBind();
                            pnlNoSavedJobs.Visible = false;
                        }
                        else
                        {
                            rptSavedJobs.DataSource = null;
                            rptSavedJobs.DataBind();
                            pnlNoSavedJobs.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading saved jobs: {ex.Message}");
                litDebugInfo.Text = $"Error: {ex.Message}";
                pnlDebug.Visible = true;
                pnlNoSavedJobs.Visible = true;
            }
        }

        private void ShowError(string message)
        {
            litDebugInfo.Text = message;
            pnlDebug.Visible = true;
            pnlNoSavedJobs.Visible = true;
        }

        protected void rptSavedJobs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string userId = Session["userId"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (e.CommandName == "UnsaveJob")
                    {
                        string[] args = e.CommandArgument.ToString().Split('|');
                        string savedJobId = args[0];
                        string jobId = args[1];

                        string query = "DELETE FROM SaveJobs WHERE SavedJobId = @SavedJobId AND UserId = @UserId";
                        using (var command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@SavedJobId", savedJobId);
                            command.Parameters.AddWithValue("@UserId", userId);
                            int rowsAffected = command.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                // Reload the saved jobs list
                                LoadSavedJobs();

                                // Still keep the client-side removal for smooth UX
                                ScriptManager.RegisterStartupScript(this, GetType(), "removeItem_" + savedJobId,
                                    $"removeSavedJobItem('{savedJobId}');", true);
                            }
                        }
                    }
                    else if (e.CommandName == "ViewDetail")
                    {
                        string jobId = e.CommandArgument.ToString();
                        Response.Redirect($"~/UserSite/Views/JobDetail.aspx?id={jobId}");
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in saved job command: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                    $"alert('An error occurred: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }
    }
}