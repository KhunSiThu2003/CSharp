using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobConnect.AuthPages.JobSeeker
{
    public partial class Register : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobConnectDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetNoStore();
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string username = txtUsername.Text.Trim();
                string email = txtEmail.Text.Trim().ToLower();
                string password = txtPassword.Text;

                // Hash the password before storing
                string hashedPassword = HashPassword(password);

                if (RegisterJobSeeker(username, email, hashedPassword))
                {
                    // Store email in session for verification
                    Session["VerificationEmail"] = email;
                    Response.Redirect("~/AuthPages/JobSeeker/VerifyEmail.aspx");
                }
            }
            catch (SqlException sqlEx) when (sqlEx.Number == 2627) // Unique constraint violation
            {
                ShowErrorMessage("This email is already registered.");
            }
            catch (Exception ex)
            {
                LogError($"Error during registration: {ex}");
                ShowErrorMessage("An error occurred during registration. Please try again.");
            }
        }

        private bool RegisterJobSeeker(string name, string email, string hashedPassword)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO JobSeeker 
                                    (JobSeeker_Id, Name, Email, Password, ProfilePicture, CreatedDate, IsActive, IsEmailVerified) 
                                VALUES 
                                    (@JobSeeker_Id, @Name, @Email, @Password, @ProfilePicture, @CreatedDate, @IsActive, @IsEmailVerified);";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    string jobSeekerId = Guid.NewGuid().ToString(); // More secure and unique

                    command.Parameters.Add("@JobSeeker_Id", SqlDbType.NVarChar, 50).Value = jobSeekerId;
                    command.Parameters.Add("@Name", SqlDbType.NVarChar, 50).Value = name;
                    command.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    command.Parameters.Add("@Password", SqlDbType.NVarChar).Value = hashedPassword;
                    command.Parameters.Add("@ProfilePicture", SqlDbType.NVarChar, 255).Value =
                        "https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg";
                    command.Parameters.Add("@CreatedDate", SqlDbType.DateTime).Value = DateTime.UtcNow;
                    command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = false;
                    command.Parameters.Add("@IsEmailVerified", SqlDbType.Bit).Value = false;

                    connection.Open();
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }


        protected void cvEmail_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !EmailExists(args.Value);
        }

        protected void cvAgree_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkAgree.Checked;
        }

        private bool EmailExists(string email)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM JobSeeker WHERE Email = @Email";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Email", email.ToLower());
                    connection.Open();
                    return (int)command.ExecuteScalar() > 0;
                }
            }
        }

        private string HashPassword(string password)
        {
            return FormsAuthentication.HashPasswordForStoringInConfigFile(password, "SHA256");
        }

        private void LogError(string errorMessage)
        {
            System.Diagnostics.Trace.TraceError($"[{DateTime.UtcNow}] {errorMessage}");
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"Swal.fire('Error', '{HttpUtility.JavaScriptStringEncode(message)}', 'error');", true);
        }
    }
}