using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.AuthPages
{
    public partial class Register : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

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

                if (RegisterUser(username, email, hashedPassword))
                {
                    // Store email in session for verification
                    Session["VerificationEmail"] = email;
                    Response.Redirect("~/UserSite/AuthPages/VerifyEmail.aspx");
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

        private bool RegisterUser(string username, string email, string hashedPassword)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
        INSERT INTO Users 
            (UserId, Username, Email, Password, ProfilePicture, CreatedDate, IsActive, IsEmailVerified) 
        VALUES 
            (@UserId, @Username, @Email, @Password, @ProfilePicture, @CreatedDate, 0, 0)";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    string userId = "user" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + new Random().Next(100, 999);
                    // Example result: 20240625094530123456 (Note: This might still overflow in some cases)

                    command.Parameters.AddWithValue("@UserId", userId);
                    command.Parameters.AddWithValue("@Username", username);
                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@Password", hashedPassword);
                    command.Parameters.AddWithValue("@ProfilePicture", "https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg");
                    command.Parameters.AddWithValue("@CreatedDate", DateTime.UtcNow);

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
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
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