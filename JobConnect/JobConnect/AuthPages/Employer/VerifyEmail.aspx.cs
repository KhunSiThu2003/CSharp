using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JobConnect.AuthPages.Employer
{
    public partial class VerifyEmail : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobConnectDB"].ConnectionString;
        private const int MaxAttempts = 5;
        private const int AttemptWindowMinutes = 1;
        private const int VerificationCodeLength = 6;
        private const int VerificationCodeExpiryMinutes = 5;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Add security headers
            Response.Headers.Add("X-Frame-Options", "DENY");
            Response.Headers.Add("X-Content-Type-Options", "nosniff");
            Response.Headers.Add("X-XSS-Protection", "1; mode=block");
            Response.Headers.Add("Referrer-Policy", "strict-origin-when-cross-origin");

            if (!IsPostBack)
            {
                if (Session["VerificationEmail"] == null)
                {
                    Response.Redirect("~/AuthPages/Employer/Register.aspx", true);
                    return;
                }

                string email = Session["VerificationEmail"].ToString();
                ViewState["Email"] = email;
                SendInitialVerificationCode(email);
            }
            else
            {
                CheckRateLimit();
            }
        }

        private void CheckRateLimit()
        {
            string email = ViewState["Email"]?.ToString();
            if (string.IsNullOrEmpty(email)) return;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                if (IsRateLimited(email, connection))
                {
                    var lockoutEnd = GetLockoutEndTime(email, connection);
                    int remainingSeconds = (int)(lockoutEnd - DateTime.UtcNow).TotalSeconds;
                    RegisterRateLimitScript(remainingSeconds);
                    DisableFormControls();
                }
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            DateTime newExpiry = DateTime.UtcNow.AddMinutes(VerificationCodeExpiryMinutes);
            RegisterOTPExpiryScript(newExpiry);

            string email = ViewState["Email"]?.ToString();
            if (string.IsNullOrEmpty(email))
            {
                Response.Redirect("~/AuthPages/Employer/Register.aspx", true);
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (IsRateLimited(email, connection))
                    {
                        var lockoutEnd = GetLockoutEndTime(email, connection);
                        int remainingSeconds = (int)(lockoutEnd - DateTime.UtcNow).TotalSeconds;
                        RegisterRateLimitScript(remainingSeconds);
                        ShowErrorMessage($"Too many attempts.");
                        return;
                    }

                    string enteredCode = txtVerificationCode.Text.Trim();
                    var (employerId, storedCode, expiryDate) = GetVerificationData(email, connection);
                    RecordVerificationAttempt(email, connection);

                    if (DateTime.UtcNow > expiryDate)
                    {
                        ShowErrorMessage("Verification code has expired. Please request a new one.");
                    }
                    else if (!SecureCompareStrings(enteredCode, storedCode))
                    {
                        int remainingAttempts = GetRemainingAttempts(email, connection);
                        int displayAttempts = Math.Max(0, remainingAttempts);
                        string attemptsText = displayAttempts == 1 ? "1 attempt" : $"{displayAttempts} attempts";

                        ShowErrorMessage($"Invalid verification code. {attemptsText} remaining before temporary lockout.");

                        if (remainingAttempts <= 0)
                        {
                            var lockoutEnd = GetLockoutEndTime(email, connection);
                            int newRemainingSeconds = (int)(lockoutEnd - DateTime.UtcNow).TotalSeconds;
                            RegisterRateLimitScript(newRemainingSeconds);
                        }
                    }
                    else
                    {
                        ActivateUser(employerId, connection);
                        ClearVerificationSession();
                        Session["IsAuthenticated"] = true;
                        Session["EmployerId"] = employerId;
                        Response.Redirect("~/Pages/Employer/Dashboard.aspx", true);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"An error occurred during verification. Please try again.");
                LogError($"Verification error for {email}: {ex}");
            }
        }

        protected void btnResendCode_Click(object sender, EventArgs e)
        {
            string email = ViewState["Email"]?.ToString();
            if (string.IsNullOrEmpty(email))
            {
                Response.Redirect("~/AuthPages/Employer/Register.aspx", true);
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (IsRateLimited(email, connection))
                    {
                        var lockoutEnd = GetLockoutEndTime(email, connection);
                        int remainingSeconds = (int)(lockoutEnd - DateTime.UtcNow).TotalSeconds;
                        RegisterRateLimitScript(remainingSeconds);
                        ShowErrorMessage($"Too many attempts.");
                        return;
                    }

                    if (!IsUserValidForResend(email, connection))
                    {
                        ShowErrorMessage("Account already verified or doesn't exist.");
                        return;
                    }

                    string newCode = GenerateRandomCode(VerificationCodeLength);
                    DateTime newExpiry = DateTime.UtcNow.AddMinutes(VerificationCodeExpiryMinutes);

                    UpdateVerificationCode(email, newCode, newExpiry, connection);

                    if (SendVerificationEmail(email, newCode))
                    {
                        ShowSuccessMessage($"A new verification code has been sent to {email}.");
                        RegisterOTPExpiryScript(newExpiry);
                    }
                    else
                    {
                        ShowErrorMessage("Failed to send verification email. Please try again later.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Failed to resend verification code. Please try again later.");
                LogError($"Resend code error for {email}: {ex}");
            }
        }

        private bool SecureCompareStrings(string a, string b)
        {
            if (a == null || b == null || a.Length != b.Length)
                return false;

            bool result = true;
            for (int i = 0; i < a.Length; i++)
            {
                result &= a[i] == b[i];
            }
            return result;
        }

        private void RegisterOTPExpiryScript(DateTime? expiry = null)
        {
            string email = ViewState["Email"]?.ToString();
            if (string.IsNullOrEmpty(email)) return;

            DateTime actualExpiry;

            if (expiry.HasValue)
            {
                actualExpiry = expiry.Value;
            }
            else
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    var verificationData = GetVerificationData(email, connection);
                    actualExpiry = verificationData.expiry;
                }
            }

            int remainingSeconds = (int)(actualExpiry - DateTime.UtcNow).TotalSeconds;
            string script = $"startOTPCountdown({remainingSeconds});";
            ScriptManager.RegisterStartupScript(this, GetType(), "startOTPCountdown", script, true);
        }

        private void SendInitialVerificationCode(string email)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (!IsUserValidForResend(email, connection))
                    {
                        ShowErrorMessage("Account already verified or doesn't exist.");
                        return;
                    }

                    string newCode = GenerateRandomCode(VerificationCodeLength);
                    DateTime newExpiry = DateTime.UtcNow.AddMinutes(VerificationCodeExpiryMinutes);

                    UpdateVerificationCode(email, newCode, newExpiry, connection);

                    if (SendVerificationEmail(email, newCode))
                    {
                        ShowInfoMessage("A verification code has been sent to your email. Please check your inbox.");
                        RegisterOTPExpiryScript(newExpiry);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Failed to send initial verification code. Please try the resend button.");
                LogError($"Initial code send error for {email}: {ex}");
            }
        }

        private bool IsRateLimited(string email, SqlConnection connection)
        {
            string query = @"SELECT VerificationAttempts, LastVerificationAttempt 
                           FROM Employer WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        int attempts = Convert.ToInt32(reader["VerificationAttempts"]);
                        DateTime? lastAttempt = reader["LastVerificationAttempt"] as DateTime?;

                        return attempts >= MaxAttempts &&
                               lastAttempt.HasValue &&
                               lastAttempt.Value.AddMinutes(AttemptWindowMinutes) > DateTime.UtcNow;
                    }
                }
            }
            return false;
        }

        private (string employerId, string code, DateTime expiry) GetVerificationData(string email, SqlConnection connection)
        {
            string query = @"SELECT Employer_Id, VerificationCode, VerificationCodeExpiry 
                           FROM Employer WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return (
                            reader.GetString(0),  // Employer_Id
                            reader.GetString(1),  // VerificationCode
                            reader.GetDateTime(2)  // VerificationCodeExpiry
                        );
                    }
                }
            }
            throw new Exception("Employer not found");
        }

        private int GetRemainingAttempts(string email, SqlConnection connection)
        {
            string query = @"SELECT VerificationAttempts FROM Employer WHERE Email = @Email";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                int attempts = (int)command.ExecuteScalar();
                return MaxAttempts - attempts;
            }
        }

        private void RecordVerificationAttempt(string email, SqlConnection connection)
        {
            string query = @"UPDATE Employer 
                           SET VerificationAttempts = VerificationAttempts + 1,
                               LastVerificationAttempt = GETUTCDATE()
                           WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private bool IsUserValidForResend(string email, SqlConnection connection)
        {
            string query = @"SELECT COUNT(*) FROM Employer 
                           WHERE Email = @Email AND IsEmailVerified = 0";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                return (int)command.ExecuteScalar() > 0;
            }
        }

        private void UpdateVerificationCode(string email, string code, DateTime expiry, SqlConnection connection)
        {
            string query = @"UPDATE Employer 
                           SET VerificationCode = @Code,
                               VerificationCodeExpiry = @Expiry,
                               VerificationAttempts = 0,
                               LastVerificationAttempt = NULL
                           WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Code", code);
                command.Parameters.AddWithValue("@Expiry", expiry);
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private bool SendVerificationEmail(string email, string verificationCode)
        {
            try
            {
                string emailBody = $@"
        <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333333; line-height: 1.6;'>
            <div style='text-align: center; margin-bottom: 30px;'>
                <h1 style='color: #2563eb; margin: 0 0 5px 0; font-size: 28px;'>JobConnect</h1>
                <p style='color: #64748b; font-size: 16px; margin: 0;'>Connecting Talent with Opportunity</p>
            </div>

            <div style='margin-bottom: 30px;'>
                <h2 style='color: #1e293b; margin: 0 0 20px 0; font-size: 18px; text-align: center;'>Complete Your Employer Registration</h2>
                <p style='margin: 0 0 20px 0;'>
                    Thank you for creating a JobConnect employer account! To get started, please verify your email address by entering the following verification code:
                </p>
                
                <div style='background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 15px; text-align: center; margin: 25px 0; font-size: 28px; font-weight: bold; letter-spacing: 2px; color: #2563eb;'>
                    {verificationCode}
                </div>
                
                <p style='margin: 0 0 20px 0;'>
                    This code will expire in {VerificationCodeExpiryMinutes} minutes. For security reasons, please do not share this code with anyone.
                </p>
                
                <p style='margin: 0; color: #64748b;'>
                    If you didn't create a JobConnect employer account, you can safely ignore this email.
                </p>
            </div>

            <div style='border-top: 1px solid #e2e8f0; padding-top: 20px; text-align: center; font-size: 12px; color: #94a3b8;'>
                <p style='margin: 5px 0;'>Address : Myanmar, Kayin State, Hpa-An City</p>
                <p style='margin: 5px 0;'>Email : khunsithu350@gmail.com</p>
                <p style='margin: 5px 0;'>Phone : +959944074981</p>
                <p style='margin: 5px 0;'>© {DateTime.Now.Year} JobConnect. All rights reserved.</p>
            </div>
        </div>";

                using (MailMessage message = new MailMessage())
                {
                    message.From = new MailAddress(ConfigurationManager.AppSettings["FromEmail"], "JobConnect Team");
                    message.To.Add(email);
                    message.Subject = "Verify Your JobConnect Employer Account";
                    message.IsBodyHtml = true;
                    message.Body = emailBody;

                    using (SmtpClient smtp = new SmtpClient())
                    {
                        smtp.Send(message);
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                LogError($"Error sending verification email to {email}: {ex}");
                return false;
            }
        }

        private void ActivateUser(string employerId, SqlConnection connection)
        {
            // Validate input
            if (string.IsNullOrWhiteSpace(employerId))
                throw new ArgumentException("Employer ID cannot be empty", nameof(employerId));

            if (connection == null)
                throw new ArgumentNullException(nameof(connection));

            // Using parameterized query to prevent SQL injection
            string query = @"UPDATE Employer 
                   SET IsEmailVerified = 1, 
                       IsActive = 1,
                       VerificationCode = NULL,
                       VerificationCodeExpiry = NULL,
                       VerificationAttempts = 0,
                       LastVerificationAttempt = NULL,
                       EmailVerifiedDate = GETUTCDATE(),  
                       LastUpdatedDate = GETUTCDATE()     
                   WHERE Employer_Id = @EmployerId";

            try
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Parameterized query for security
                    command.Parameters.AddWithValue("@EmployerId", employerId);

                    int rowsAffected = command.ExecuteNonQuery();

                    if (rowsAffected == 0)
                    {
                        throw new InvalidOperationException("No employer was updated. Employer_Id may not exist.");
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log the error with additional context
                LogError($"Error activating employer {employerId}: {ex.Message}");
                throw; // Re-throw to handle at higher level
            }
        }

        private string GenerateRandomCode(int length)
        {
            const string chars = "0123456789";
            using (var rng = new RNGCryptoServiceProvider())
            {
                byte[] data = new byte[length];
                rng.GetBytes(data);
                StringBuilder result = new StringBuilder(length);
                foreach (byte b in data)
                {
                    result.Append(chars[b % chars.Length]);
                }
                return result.ToString();
            }
        }

        private void ClearVerificationSession()
        {
            Session.Remove("VerificationEmail");
            ViewState.Remove("Email");
        }

        private DateTime GetLockoutEndTime(string email, SqlConnection connection)
        {
            string query = @"SELECT DATEADD(MINUTE, @AttemptWindowMinutes, LastVerificationAttempt) 
                            FROM Employer WHERE Email = @Email";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                command.Parameters.AddWithValue("@AttemptWindowMinutes", AttemptWindowMinutes);
                return (DateTime)command.ExecuteScalar();
            }
        }

        private void RegisterRateLimitScript(int seconds)
        {
            string script = $"showRateLimit({seconds});";
            ScriptManager.RegisterStartupScript(this, GetType(), "showRateLimit", script, true);
        }

        private void DisableFormControls()
        {
            btnVerify.Enabled = false;
            btnResendCode.Enabled = false;
            txtVerificationCode.Enabled = false;
        }

        private void ShowMessage(string message, string type)
        {
            phIcon.Controls.Clear();
            string containerClasses = "message-card ";
            string textClasses = "text-sm font-medium ";

            switch (type.ToLower())
            {
                case "success":
                    phIcon.Controls.Add(new LiteralControl(
                        @"<svg class=""h-5 w-5 text-green-500"" fill=""currentColor"" viewBox=""0 0 20 20"">
                        <path fill-rule=""evenodd"" d=""M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"" clip-rule=""evenodd"" />
                    </svg>"));
                    containerClasses += "success-card";
                    textClasses += "text-green-800";
                    break;

                case "error":
                    phIcon.Controls.Add(new LiteralControl(
                        @"<svg class=""h-5 w-5 text-red-500"" fill=""currentColor"" viewBox=""0 0 20 20"">
                        <path fill-rule=""evenodd"" d=""M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"" clip-rule=""evenodd"" />
                    </svg>"));
                    containerClasses += "error-card";
                    textClasses += "text-red-800";
                    break;

                default: // info
                    phIcon.Controls.Add(new LiteralControl(
                        @"<svg class=""h-5 w-5 text-blue-500"" fill=""currentColor"" viewBox=""0 0 20 20"">
                        <path fill-rule=""evenodd"" d=""M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2h-1V9z"" clip-rule=""evenodd"" />
                    </svg>"));
                    containerClasses += "info-card";
                    textClasses += "text-blue-800";
                    break;
            }

            litMessage.Text = message;
            ((HtmlGenericControl)pnlMessage.FindControl("messageContainer")).Attributes["class"] = containerClasses;
            ((HtmlGenericControl)pnlMessage.FindControl("messageText")).Attributes["class"] = textClasses;
            pnlMessage.Visible = true;
        }

        private void ShowInfoMessage(string message) => ShowMessage(message, "info");
        private void ShowSuccessMessage(string message) => ShowMessage(message, "success");
        private void ShowErrorMessage(string message) => ShowMessage(message, "error");

        private void LogError(string message)
        {
            System.Diagnostics.Trace.TraceError($"[{DateTime.UtcNow}] {message}");
        }
    }
}