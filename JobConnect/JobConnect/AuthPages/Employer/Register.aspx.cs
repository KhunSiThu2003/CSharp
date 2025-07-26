using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobConnect.AuthPages.Employer
{
    public partial class Register : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobConnectDB"].ConnectionString;
        private const string defaultLogoUrl = "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Security headers
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetNoStore();
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                ShowErrorMessage("Please fix the validation errors.");
                return;
            }

            string companyName = txtCompanyName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;

            try
            {
                // Validate email availability
                if (EmailExists(email))
                {
                    ShowErrorMessage("This email is already registered.");
                    return;
                }

                // Hash the password
                string hashedPassword = HashPassword(password);

                // Register the employer
                if (RegisterEmployer(companyName, email, hashedPassword))
                {
                    // Store email in session for verification
                    Session["VerificationEmail"] = email;
                    Response.Redirect("~/AuthPages/Employer/VerifyEmail.aspx", false);
                }
                else
                {
                    ShowErrorMessage("Registration failed. Please try again.");
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627) // Unique constraint violation
                {
                    ShowErrorMessage("This email is already registered.");
                }
                else
                {
                    LogError($"SQL Error during registration: {sqlEx}");
                    ShowErrorMessage("A database error occurred. Please try again."+sqlEx.Message);
                }
            }
            catch (Exception ex)
            {
                LogError($"Error during registration: {ex}");
                ShowErrorMessage("An unexpected error occurred. Please try again.");
            }
            finally
            {
                // Reset the button state
                ScriptManager.RegisterStartupScript(this, GetType(), "enableButton",
                    "document.getElementById('" + btnRegister.ClientID + "').disabled = false;" +
                    "document.getElementById('" + btnRegister.ClientID + "').value = 'Register';", true);
            }
        }

        private bool RegisterEmployer(string name, string email, string hashedPassword)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO Employer 
                                (Employer_Id, Name, Email, Password, Logo, CreatedDate, IsActive, IsEmailVerified,
                                 VerificationAttempts, PasswordResetAttempts) 
                                VALUES 
                                (@Employer_Id, @Name, @Email, @Password, @Logo, @CreatedDate, @IsActive, @IsEmailVerified,
                                 0, 0)";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Generate a new GUID for the employer ID
                    string employerId = Guid.NewGuid().ToString();

                    // Set parameters
                    command.Parameters.Add("@Employer_Id", SqlDbType.NVarChar, 50).Value = employerId;
                    command.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = name;
                    command.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    command.Parameters.Add("@Password", SqlDbType.NVarChar).Value = hashedPassword;
                    command.Parameters.Add("@Logo", SqlDbType.NVarChar, 255).Value = defaultLogoUrl;
                    command.Parameters.Add("@CreatedDate", SqlDbType.DateTime).Value = DateTime.UtcNow;
                    command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = false;
                    command.Parameters.Add("@IsEmailVerified", SqlDbType.Bit).Value = false;

                    connection.Open();
                    int rowsAffected = command.ExecuteNonQuery();
                    return rowsAffected > 0;
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
                string query = "SELECT COUNT(*) FROM Employer WHERE Email = @Email";
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
                $"alert('{HttpUtility.JavaScriptStringEncode(message)}');", true);
        }
    }
}