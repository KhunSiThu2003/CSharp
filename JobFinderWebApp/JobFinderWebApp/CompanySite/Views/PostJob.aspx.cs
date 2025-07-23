using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class PostJob : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CompanyId"] == null || Session["CompanyAuthenticated"] == null)
                {
                    Response.Redirect("~/CompanySite/AuthPages/CompanyLogin.aspx");
                }

                // Set default expiry date to 30 days from now
                txtExpiryDate.Text = DateTime.Now.AddDays(30).ToString("yyyy-MM-dd");
            }
        }

        protected void btnPostJob_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (Session["CompanyId"] == null)
            {
                ShowError("Company session expired. Please log in again.");
                return;
            }

            string companyId = Session["CompanyId"].ToString(); // Changed to string
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = @"INSERT INTO Jobs (
                JobId, CompanyId, Title, Description, Requirements, SalaryRange,
                JobType, ExperienceLevel, Location, IsRemote,
                PostedDate, ExpiryDate, IsActive
            ) VALUES (
                 @JobId, @CompanyId, @Title, @Description, @Requirements, @SalaryRange,
                @JobType, @ExperienceLevel, @Location, @IsRemote,
                GETDATE(), @ExpiryDate, 1
            )";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", Guid.NewGuid().ToString());
                        command.Parameters.AddWithValue("@CompanyId", companyId); // Now string
                                                                                  // Rest of the parameters remain the same
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

                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            // Clear form and show success message
                            ClearForm();
                            pnlSuccess.Visible = true;
                            pnlError.Visible = false;
                        }
                        else
                        {
                            ShowError("Failed to post job. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while posting the job: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            txtJobTitle.Text = "";
            ddlJobType.SelectedIndex = 0;
            ddlExperienceLevel.SelectedIndex = 0;
            txtLocation.Text = "";
            cbIsRemote.Checked = false;
            txtSalaryMin.Text = "";
            txtSalaryMax.Text = "";
            ddlSalaryType.SelectedIndex = 0;
            txtJobDescription.Text = "";
            txtRequirements.Text = "";
            txtExpiryDate.Text = DateTime.Now.AddDays(30).ToString("yyyy-MM-dd");
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            litError.Text = message;
        }
    }
}