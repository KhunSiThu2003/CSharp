using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class JobDetail : System.Web.UI.Page
    {
        private string JobId => Request.QueryString["id"] != null ? Request.QueryString["id"].ToString() : string.Empty;
        private string UserId => Session["userId"]?.ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (UserId == null)
                {
                    Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    return;
                }

                if (string.IsNullOrEmpty(JobId))
                {
                    Response.Redirect("~/UserSite/Views/Jobs.aspx");
                    return;
                }

                LoadJobDetails();
                CheckIfJobSaved();
                CheckIfAlreadyApplied();
                LoadUserData();
            }
        }

        private void LoadJobDetails()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        SELECT 
                            j.JobId, j.Title, j.Description, j.Requirements, j.SalaryRange,
                            j.JobType, j.ExperienceLevel, j.Location, j.IsRemote, j.PostedDate,
                            c.CompanyId, c.Name AS CompanyName, c.Description AS CompanyDescription,
                            c.Logo AS CompanyLogo, c.Website AS CompanyWebsite, c.Industry,
                            c.Location AS CompanyLocation, c.CompanyEmail, c.CompanyPhone
                        FROM Jobs j
                        INNER JOIN Companies c ON j.CompanyId = c.CompanyId
                        WHERE j.JobId = @JobId AND j.IsActive = 1";

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", JobId);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Job Details
                                litJobTitle.Text = reader["Title"].ToString();
                                litDescription.Text = reader["Description"].ToString();
                                litRequirements.Text = reader["Requirements"].ToString();
                                litSalaryRange.Text = reader["SalaryRange"].ToString();
                                litJobType.Text = reader["JobType"].ToString();
                                litExperienceLevel.Text = reader["ExperienceLevel"].ToString();
                                litLocation.Text = reader["Location"].ToString();
                                litPostedDate.Text = Convert.ToDateTime(reader["PostedDate"]).ToString("MMMM dd, yyyy");
                                pnlRemote.Visible = Convert.ToBoolean(reader["IsRemote"]);

                                // Company Details
                                litCompanyName.Text = reader["CompanyName"].ToString();
                                litCompanyNameLarge.Text = reader["CompanyName"].ToString();
                                litCompanyDescription.Text = reader["CompanyDescription"].ToString();
                                litIndustry.Text = reader["Industry"].ToString();
                                litCompanyLocation.Text = reader["CompanyLocation"].ToString();
                                litCompanyEmail.Text = reader["CompanyEmail"].ToString();
                                litCompanyPhone.Text = reader["CompanyPhone"].ToString();

                                string logoPath = reader["CompanyLogo"] != DBNull.Value ?
                                    reader["CompanyLogo"].ToString() :
                                    "~/Content/Images/default-company.png";

                                imgCompanyLogo.ImageUrl = logoPath;
                                imgCompanyLogoLarge.ImageUrl = logoPath;

                                if (reader["CompanyWebsite"] != DBNull.Value)
                                {
                                    hlCompanyWebsite.NavigateUrl = reader["CompanyWebsite"].ToString();
                                }
                                else
                                {
                                    hlCompanyWebsite.Visible = false;
                                }
                            }
                            else
                            {
                                Response.Redirect("~/UserSite/Views/Jobs.aspx");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                litDebugInfo.Text = $"Error loading job details: {ex.Message}";
                pnlDebug.Visible = true;
            }
        }

        private void CheckIfJobSaved()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "SELECT COUNT(*) FROM SaveJobs WHERE JobId = @JobId AND UserId = @UserId";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@JobId", JobId);
                    command.Parameters.AddWithValue("@UserId", UserId);

                    int count = (int)command.ExecuteScalar();
                    btnSaveJob.Text = count > 0 ? "Unsave Job" : "Save Job";
                }
            }
        }

        private void CheckIfAlreadyApplied()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = @"
                    SELECT ApplicationDate 
                    FROM Applications 
                    WHERE JobId = @JobId AND UserId = @UserId";

                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@JobId", JobId);
                    command.Parameters.AddWithValue("@UserId", UserId);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            pnlApplyForm.Visible = false;
                            pnlAlreadyApplied.Visible = true;
                            litApplicationDate.Text = Convert.ToDateTime(reader["ApplicationDate"]).ToString("MMMM dd, yyyy");
                        }
                        else
                        {
                            pnlApplyForm.Visible = true;
                            pnlAlreadyApplied.Visible = false;
                        }
                    }
                }
            }
        }

        private void LoadUserData()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "SELECT Username, Email, Phone, Bio FROM Users WHERE UserId = @UserId";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserId", UserId);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtFullName.Text = reader["Username"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                            txtPhone.Text = reader["Phone"] != DBNull.Value ? reader["Phone"].ToString() : "";
                        }
                    }
                }
            }
        }

        protected void btnSaveJob_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                if (btnSaveJob.Text == "Save Job")
                {
                    string query = "INSERT INTO SaveJobs (JobId, UserId, SavedDate) VALUES (@JobId, @UserId, GETDATE())";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", JobId);
                        command.Parameters.AddWithValue("@UserId", UserId);
                        command.ExecuteNonQuery();
                    }
                    btnSaveJob.Text = "Unsave Job";
                }
                else
                {
                    string query = "DELETE FROM SaveJobs WHERE JobId = @JobId AND UserId = @UserId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", JobId);
                        command.Parameters.AddWithValue("@UserId", UserId);
                        command.ExecuteNonQuery();
                    }
                    btnSaveJob.Text = "Save Job";
                }
            }
        }

        protected void btnSubmitApplication_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string resumePath = SaveUploadedResume();
                if (resumePath == null) return;

                string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        INSERT INTO Applications (
                            JobId, UserId, ApplicationDate, Status, 
                            FullName, Email, Phone, Address,
                            CoverLetter, ResumePath
                        ) VALUES (
                            @JobId, @UserId, GETDATE(), 'Applied', 
                            @FullName, @Email, @Phone, @Address,
                            @CoverLetter, @ResumePath
                        )";

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@JobId", JobId);
                        command.Parameters.AddWithValue("@UserId", UserId);
                        command.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                        command.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        command.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        command.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                        command.Parameters.AddWithValue("@CoverLetter", txtCoverLetter.Text.Trim());
                        command.Parameters.AddWithValue("@ResumePath", resumePath);

                        command.ExecuteNonQuery();
                    }
                }

                // Show success and reload the page to show application status
                CheckIfAlreadyApplied();
                ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                    "alert('Your application has been submitted successfully!');", true);
            }
        }

        private string SaveUploadedResume()
        {
            if (!fuResume.HasFile)
            {
                cvResume.ErrorMessage = "Please upload your resume";
                cvResume.IsValid = false;
                return null;
            }

            string fileName = Path.GetFileName(fuResume.FileName);
            string extension = Path.GetExtension(fileName).ToLower();

            // Validate file type
            if (extension != ".pdf" && extension != ".doc" && extension != ".docx")
            {
                cvResume.ErrorMessage = "Only PDF, DOC, and DOCX files are allowed";
                cvResume.IsValid = false;
                return null;
            }

            // Validate file size (5MB max)
            if (fuResume.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                cvResume.ErrorMessage = "File size must be less than 5MB";
                cvResume.IsValid = false;
                return null;
            }

            // Create uploads directory if it doesn't exist
            string uploadsDir = Server.MapPath("~/Uploads/Resumes");
            if (!Directory.Exists(uploadsDir))
            {
                Directory.CreateDirectory(uploadsDir);
            }

            // Generate unique filename
            string uniqueFileName = $"{UserId}_{DateTime.Now:yyyyMMddHHmmss}_{Guid.NewGuid().ToString("N").Substring(0, 8)}{extension}";
            string filePath = Path.Combine(uploadsDir, uniqueFileName);
            fuResume.SaveAs(filePath);

            return $"/Uploads/Resumes/{uniqueFileName}";
        }

        protected void ValidateResume(object source, ServerValidateEventArgs args)
        {
            args.IsValid = fuResume.HasFile;
        }
    }
}