using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class EditJob : System.Web.UI.Page
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
            SELECT Title, Description, Requirements, SalaryRange, 
                   JobType, ExperienceLevel, Location, IsRemote,
                   ExpiryDate, IsActive
            FROM Jobs
            WHERE JobId = @JobId AND CompanyId = @CompanyId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@JobId", jobId);
                    command.Parameters.AddWithValue("@CompanyId", companyId); // Now string

                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtJobTitle.Text = reader["Title"].ToString();
                            txtJobDescription.Text = reader["Description"].ToString();
                            txtRequirements.Text = reader["Requirements"].ToString();

                            // Parse SalaryRange
                            string salaryRange = reader["SalaryRange"].ToString();
                            if (!string.IsNullOrEmpty(salaryRange))
                            {
                                var parts = salaryRange.Split('-');
                                if (parts.Length > 0) txtSalaryMin.Text = parts[0].Trim().Split(' ')[0];
                                if (parts.Length > 1) txtSalaryMax.Text = parts[1].Trim().Split(' ')[0];
                                if (salaryRange.Contains("Per Month")) ddlSalaryType.SelectedValue = "Per Month";
                                else if (salaryRange.Contains("Per Hour")) ddlSalaryType.SelectedValue = "Per Hour";
                            }

                            ddlJobType.SelectedValue = reader["JobType"].ToString();
                            ddlExperienceLevel.SelectedValue = reader["ExperienceLevel"].ToString();
                            txtLocation.Text = reader["Location"].ToString();
                            cbIsRemote.Checked = Convert.ToBoolean(reader["IsRemote"]);

                            DateTime expiryDate = Convert.ToDateTime(reader["ExpiryDate"]);
                            txtExpiryDate.Text = expiryDate.ToString("yyyy-MM-dd");

                            bool isActive = Convert.ToBoolean(reader["IsActive"]);
                            btnDeactivate.Visible = isActive;
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

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string jobId = Request.QueryString["id"];
            if (!Page.IsValid)
                return;

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
                            Title = @Title,
                            Description = @Description,
                            Requirements = @Requirements,
                            SalaryRange = @SalaryRange,
                            JobType = @JobType,
                            ExperienceLevel = @ExperienceLevel,
                            Location = @Location,
                            IsRemote = @IsRemote,
                            ExpiryDate = @ExpiryDate
                        WHERE JobId = @JobId AND CompanyId = @CompanyId";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", jobId);
                        command.Parameters.AddWithValue("@CompanyId", companyId);
                        command.Parameters.AddWithValue("@Title", txtJobTitle.Text.Trim());
                        command.Parameters.AddWithValue("@Description", txtJobDescription.Text.Trim());
                        command.Parameters.AddWithValue("@Requirements", txtRequirements.Text.Trim());

                        // Combine salary min and max into SalaryRange
                        string salaryRange = string.Empty;
                        if (!string.IsNullOrEmpty(txtSalaryMin.Text) || !string.IsNullOrEmpty(txtSalaryMax.Text))
                        {
                            salaryRange = $"{txtSalaryMin.Text}-{txtSalaryMax.Text} {ddlSalaryType.SelectedValue}";
                        }
                        command.Parameters.AddWithValue("@SalaryRange",
                            string.IsNullOrEmpty(salaryRange) ? DBNull.Value : (object)salaryRange);

                        command.Parameters.AddWithValue("@JobType", ddlJobType.SelectedValue);
                        command.Parameters.AddWithValue("@ExperienceLevel", ddlExperienceLevel.SelectedValue);
                        command.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
                        command.Parameters.AddWithValue("@IsRemote", cbIsRemote.Checked);
                        command.Parameters.AddWithValue("@ExpiryDate", Convert.ToDateTime(txtExpiryDate.Text));

                        connection.Open();
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            pnlSuccess.Visible = true;
                            pnlError.Visible = false;
                            btnDeactivate.Visible = true;
                        }
                        else
                        {
                            ShowError("Failed to update job. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while updating the job: " + ex.Message);
            }
        }

        protected void btnDeactivate_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                Response.Redirect("~/CompanySite/Views/JobListings.aspx");
            }
            string jobId = Request.QueryString["id"];

            string companyId = Session["CompanyId"].ToString();

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Jobs SET
                            IsActive = 0
                        WHERE JobId = @JobId AND CompanyId = @CompanyId";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", jobId);
                        command.Parameters.AddWithValue("@CompanyId", companyId);

                        connection.Open();
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            pnlSuccess.Visible = true;
                            pnlError.Visible = false;
                            btnDeactivate.Visible = false;
                            pnlSuccess.GroupingText = "Job has been deactivated successfully.";
                        }
                        else
                        {
                            ShowError("Failed to deactivate job. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while deactivating the job: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            litError.Text = message;
        }
    }
}