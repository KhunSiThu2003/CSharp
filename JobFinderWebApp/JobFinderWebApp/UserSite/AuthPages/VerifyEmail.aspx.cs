using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace JobFinderWebApp.UserSite.AuthPages
{
    public partial class VerifyEmail : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
        private const int MaxAttempts = 5;
        private const int AttemptWindowMinutes = 15;
        private const int VerificationCodeLength = 6;
        private const int VerificationCodeExpiryMinutes = 15;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["VerificationEmail"] == null)
                {
                    Response.Redirect("~/UserSite/AuthPages/Register.aspx");
                    return;
                }

                string email = Session["VerificationEmail"].ToString();
                ViewState["Email"] = email;

                // Automatically send verification code on initial page load
                SendInitialVerificationCode(email);
            }
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
                    }
                    else
                    {
                        ShowErrorMessage("Failed to send verification email. Please try the resend button.");
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"Initial code send error for {email}: {ex}");
                ShowErrorMessage("Failed to send initial verification code. Please try the resend button.");
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string email = ViewState["Email"]?.ToString();
            if (string.IsNullOrEmpty(email))
            {
                Response.Redirect("~/UserSite/AuthPages/Register.aspx");
                return;
            }

            string enteredCode = txtVerificationCode.Text.Trim();

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (IsRateLimited(email, connection))
                    {
                        ShowErrorMessage($"Too many attempts. Please try again in {AttemptWindowMinutes} minutes.");
                        return;
                    }

                    var (userId, storedCode, expiryDate) = GetVerificationData(email, connection);
                    RecordVerificationAttempt(email, connection);

                    if (DateTime.UtcNow > expiryDate)
                    {
                        ShowErrorMessage("Verification code has expired. Please request a new one.");
                    }
                    else if (enteredCode != storedCode)
                    {
                        ShowErrorMessage("Invalid verification code. " +
                                       $"{GetRemainingAttempts(email, connection)} attempts remaining.");
                    }
                    else
                    {
                        ActivateUser(userId, connection);
                        ClearVerificationSession();

                        // Set authenticated flag in session
                        Session["IsAuthenticated"] = true;
                        Response.Redirect("~/UserSite/Views/Dashboard.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"Verification error for {email}: {ex}");
                ShowErrorMessage("An error occurred during verification. Please try again.");
            }
        }

        protected void btnResendCode_Click(object sender, EventArgs e)
        {
            string email = ViewState["Email"]?.ToString();
            if (string.IsNullOrEmpty(email))
            {
                Response.Redirect("~/UserSite/AuthPages/Register.aspx");
                return;
            }

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
                        ShowSuccessMessage("A new verification code has been sent to your email.");
                    }
                    else
                    {
                        ShowErrorMessage("Failed to send verification email. Please try again later.");
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"Resend code error for {email}: {ex}");
                ShowErrorMessage("Failed to resend verification code. Please try again later.");
            }
        }

        private bool IsRateLimited(string email, SqlConnection connection)
        {
            string query = @"SELECT VerificationAttempts, LastVerificationAttempt 
                           FROM Users WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        int attempts = reader.GetInt32(0);
                        DateTime? lastAttempt = reader.IsDBNull(1) ? null : (DateTime?)reader.GetDateTime(1);

                        return attempts >= MaxAttempts &&
                               lastAttempt.HasValue &&
                               lastAttempt.Value.AddMinutes(AttemptWindowMinutes) > DateTime.UtcNow;
                    }
                }
            }
            return false;
        }

        private (string userId, string code, DateTime expiry) GetVerificationData(string email, SqlConnection connection)
        {
            string query = @"SELECT UserId, VerificationCode, VerificationCodeExpiry 
                           FROM Users WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return (
                            reader.GetString(0),  // Changed from GetInt32 to GetString
                            reader.GetString(1),
                            reader.GetDateTime(2)
                        );
                    }
                }
            }
            throw new Exception("User not found");
        }

        private int GetRemainingAttempts(string email, SqlConnection connection)
        {
            string query = @"SELECT VerificationAttempts FROM Users WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                int attempts = (int)command.ExecuteScalar();
                return MaxAttempts - attempts;
            }
        }

        private void RecordVerificationAttempt(string email, SqlConnection connection)
        {
            string query = @"UPDATE Users 
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
            string query = @"SELECT COUNT(*) FROM Users 
                           WHERE Email = @Email AND IsEmailVerified = 0";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                return (int)command.ExecuteScalar() > 0;
            }
        }

        private void UpdateVerificationCode(string email, string code, DateTime expiry, SqlConnection connection)
        {
            string query = @"UPDATE Users 
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

        private void ActivateUser(string userId, SqlConnection connection)  // Changed parameter type from int to string
        {
            string query = @"UPDATE Users 
                           SET IsEmailVerified = 1, 
                               IsActive = 1,
                               VerificationCode = NULL,
                               VerificationCodeExpiry = NULL,
                               VerificationAttempts = 0,
                               LastVerificationAttempt = NULL
                           WHERE UserId = @UserId";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@UserId", userId);
                command.ExecuteNonQuery();
            }
        }

        private bool SendVerificationEmail(string email, string verificationCode)
        {
            try
            {
                using (MailMessage message = new MailMessage())
                {
                    message.From = new MailAddress(ConfigurationManager.AppSettings["FromEmail"], "JobFinder Team");
                    message.To.Add(email);
                    message.Subject = "Verify Your JobFinder Account";
                    message.IsBodyHtml = true;
                    message.Body = $@"
                <!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {{ 
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
                            line-height: 1.6; 
                            color: #333; 
                            max-width: 600px; 
                            margin: 0 auto; 
                            padding: 20px;
                            background-color: #f9f9f9;
                        }}
                        .email-container {{
                            background: white;
                            border-radius: 8px;
                            padding: 30px;
                            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                        }}
                        .header {{ 
                            color: #2563eb; 
                            text-align: center; 
                            padding-bottom: 15px;
                            margin-bottom: 20px;
                        }}
                        .logo {{
                            font-size: 28px;
                            font-weight: bold;
                            margin-bottom: 5px;
                            color: #2563eb;
                        }}
                        .tagline {{
                            font-size: 14px;
                            color: #666;
                        }}
                        .code-box {{ 
                            background: #f0f7ff; 
                            border: 1px dashed #2563eb; 
                            padding: 20px; 
                            text-align: center; 
                            font-size: 28px; 
                            font-weight: bold; 
                            color: #2563eb;
                            margin: 25px 0;
                            border-radius: 6px;
                            letter-spacing: 3px;
                        }}
                        .footer {{ 
                            margin-top: 30px; 
                            padding-top: 20px; 
                            border-top: 1px solid #eee; 
                            font-size: 12px; 
                            color: #777;
                            text-align: center;
                        }}
                        .button {{
                            display: inline-block;
                            padding: 12px 24px;
                            background-color: #2563eb;
                            color: white !important;
                            text-decoration: none;
                            border-radius: 4px;
                            font-weight: bold;
                            margin: 15px 0;
                        }}
                        .contact-info {{ 
                            margin-top: 15px;
                            line-height: 1.4;
                        }}
                    </style>
                </head>
                <body>
                    <div class='email-container'>
                        <div class='header'>
                            <div class='logo'>JobFinder</div>
                            <div class='tagline'>Connecting Talent with Opportunity</div>
                        </div>
                        
                        <h3 style='margin-bottom: 5px;'>Complete Your Registration</h3>
                        <p>Thank you for creating a JobFinder account! To get started, please verify your email address by entering the following verification code:</p>
                        
                        <div class='code-box'>{verificationCode}</div>
                        
                        <p>This code will expire in {VerificationCodeExpiryMinutes} minutes. For security reasons, please do not share this code with anyone.</p>
                        
                        <p style='margin-top: 25px;'>If you didn't create a JobFinder account, you can safely ignore this email.</p>
                        
                        <div class='footer'>
                            <p>Need help? Contact our support team:</p>
                            <div class='contact-info'>
                                <strong>Email:</strong> <a href='mailto:khunsithu305@gmail.com' style='color: #2563eb;'>khunsithu305@gmail.com</a><br>
                                <strong>Phone:</strong> 09944074981<br>
                                <strong>Address:</strong> Hpa-An City, Kayin State, Myanmar
                            </div>
                            <p style='margin-top: 15px;'>© {DateTime.Now.Year} JobFinder. All rights reserved.</p>
                        </div>
                    </div>
                </body>
                </html>";

                    using (SmtpClient smtp = new SmtpClient())
                    {
                        smtp.Timeout = 10000; // 10 seconds timeout
                        smtp.Send(message);
                    }
                }
                return true;
            }
            catch (SmtpException smtpEx)
            {
                LogError($"SMTP Error sending verification email to {email}: {smtpEx.StatusCode} - {smtpEx.Message}");
                return false;
            }
            catch (Exception ex)
            {
                LogError($"General Error sending verification email to {email}: {ex}");
                return false;
            }
        }

        private string GenerateRandomCode(int length)
        {
            const string chars = "0123456789";
            var random = new Random();
            return new string(Enumerable.Repeat(chars, length)
                .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        private void ClearVerificationSession()
        {
            Session.Remove("VerificationEmail");
            ViewState.Remove("Email");
        }

        private void LogError(string message)
        {
            System.Diagnostics.Trace.TraceError($"[{DateTime.UtcNow}] {message}");
        }

        private void ShowInfoMessage(string message)
        {
            pnlError.CssClass = "bg-blue-50 border-l-4 border-blue-400 p-4";
            litErrorMessage.Text = message;
            pnlError.Visible = true;
        }

        private void ShowSuccessMessage(string message)
        {
            pnlError.CssClass = "bg-green-50 border-l-4 border-green-400 p-4";
            litErrorMessage.Text = message;
            pnlError.Visible = true;
        }

        private void ShowErrorMessage(string message)
        {
            pnlError.CssClass = "bg-red-50 border-l-4 border-red-400 p-4";
            litErrorMessage.Text = message;
            pnlError.Visible = true;
        }
    }
}