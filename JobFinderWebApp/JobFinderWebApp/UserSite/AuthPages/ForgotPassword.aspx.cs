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
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
        private const int OTPLength = 6;
        private const int OTPExpiryMinutes = 15;
        private const int MaxAttempts = 5;
        private const int AttemptWindowMinutes = 15;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string email = txtEmail.Text.Trim();

                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        // Check if email exists in the system
                        if (!IsValidUser(email, connection))
                        {
                            // Show generic message (don't reveal if email exists)
                            ShowSuccess("If your email exists in our system, you will receive an OTP code.");
                            return;
                        }

                        // Generate OTP
                        string otp = GenerateRandomOTP(OTPLength);
                        DateTime expiry = DateTime.UtcNow.AddMinutes(OTPExpiryMinutes);

                        // Store OTP in database
                        StorePasswordResetOTP(email, otp, expiry, connection);

                        // Send OTP email
                        if (SendOTPEmail(email, otp))
                        {
                            // Switch to OTP form
                            pnlEmailForm.Visible = false;
                            pnlOTPForm.Visible = true;
                            ViewState["Email"] = email;
                            ShowSuccess($"OTP code has been sent to {email}. Please check your email.");
                        }
                        else
                        {
                            ShowError("Failed to send OTP. Please try again.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError($"An error occurred: {ex.Message}");
                }
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string email = ViewState["Email"]?.ToString();
                string otp = txtOTP.Text.Trim();
                string newPassword = txtNewPassword.Text;
                string confirmPassword = txtConfirmPassword.Text;

                if (string.IsNullOrEmpty(email))
                {
                    ShowError("Invalid request. Please start the password reset process again.");
                    return;
                }

                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        // Check if OTP is valid
                        if (IsValidOTP(email, otp, connection))
                        {
                            // Update password
                            string hashedPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(newPassword, "SHA256");
                            UpdateUserPassword(email, hashedPassword, connection);

                            // Clear OTP data
                            ClearResetOTP(email, connection);

                            // Show success message
                            ShowSuccess("Your password has been reset successfully. You can now login with your new password.");
                            pnlOTPForm.Visible = false;
                        }
                        else
                        {
                            ShowError("Invalid OTP code or it has expired. Please try again.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError($"An error occurred: {ex.Message}");
                }
            }
        }

        protected void btnResendOTP_Click(object sender, EventArgs e)
        {
            string email = ViewState["Email"]?.ToString();
            if (string.IsNullOrEmpty(email))
            {
                ShowError("Invalid request. Please start the password reset process again.");
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (IsRateLimited(email, connection))
                    {
                        ShowError($"Too many attempts. Please try again in {AttemptWindowMinutes} minutes.");
                        return;
                    }

                    // Generate new OTP
                    string newOTP = GenerateRandomOTP(OTPLength);
                    DateTime newExpiry = DateTime.UtcNow.AddMinutes(OTPExpiryMinutes);

                    // Update OTP in database
                    StorePasswordResetOTP(email, newOTP, newExpiry, connection);

                    // Send new OTP email
                    if (SendOTPEmail(email, newOTP))
                    {
                        ShowSuccess($"A new OTP code has been sent to {email}. Please check your email.");
                    }
                    else
                    {
                        ShowError("Failed to resend OTP. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"An error occurred: {ex.Message}");
            }
        }

        private bool IsValidUser(string email, SqlConnection connection)
        {
            string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                return (int)command.ExecuteScalar() > 0;
            }
        }

        private string GenerateRandomOTP(int length)
        {
            const string chars = "0123456789";
            var random = new Random();
            return new string(Enumerable.Repeat(chars, length)
                .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        private void StorePasswordResetOTP(string email, string otp, DateTime expiry, SqlConnection connection)
        {
            string query = @"UPDATE Users 
                           SET PasswordResetOTP = @OTP,
                               PasswordResetOTPExpiry = @Expiry,
                               PasswordResetAttempts = 0,
                               LastPasswordResetAttempt = NULL
                           WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@OTP", otp);
                command.Parameters.AddWithValue("@Expiry", expiry);
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private bool SendOTPEmail(string email, string otp)
        {
            try
            {
                using (MailMessage message = new MailMessage())
                {
                    message.From = new MailAddress(ConfigurationManager.AppSettings["FromEmail"], "JobFinder Team");
                    message.To.Add(email);
                    message.Subject = "Your JobFinder Password Reset OTP Code";
                    message.IsBodyHtml = true;
                    message.Body = $@"
                <!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }}
                        .header {{ color: #2563eb; text-align: center; border-bottom: 2px solid #2563eb; padding-bottom: 10px; }}
                        .logo {{ font-size: 24px; font-weight: bold; margin-bottom: 5px; }}
                        .otp-code {{ 
                            background: #f0f7ff; 
                            border: 1px dashed #2563eb; 
                            padding: 15px; 
                            text-align: center; 
                            font-size: 24px; 
                            font-weight: bold; 
                            color: #2563eb;
                            margin: 20px 0;
                            border-radius: 5px;
                        }}
                        .footer {{ 
                            margin-top: 30px; 
                            padding-top: 15px; 
                            border-top: 1px solid #eee; 
                            font-size: 12px; 
                            color: #666;
                        }}
                        .contact-info {{ margin-top: 15px; }}
                    </style>
                </head>
                <body>
                    <div class='header'>
                        <div class='logo'>JobFinder</div>
                        <div>Your Career Partner</div>
                    </div>
                    
                    <h3>Password Reset OTP</h3>
                    <p>We received a request to reset your JobFinder account password. Please use the following OTP code:</p>
                    
                    <div class='otp-code'>{otp}</div>
                    
                    <p>This code will expire in {OTPExpiryMinutes} minutes. For security reasons, please do not share this code with anyone.</p>
                    <p>If you didn't request this password reset, please ignore this email or contact our support team immediately.</p>
                    
                    <div class='footer'>
                        <p>Thank you for using JobFinder!</p>
                        <div class='contact-info'>
                            <strong>Contact Us:</strong><br>
                            Email: <a href='mailto:khunsithu305@gmail.com'>khunsithu305@gmail.com</a><br>
                            Phone: 09944074981<br>
                            Address: Hpa-An City, Kayin State, Myanmar
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
            catch (Exception ex)
            {
                // Consider logging the exception here for debugging
                return false;
            }
        }

        private bool IsValidOTP(string email, string otp, SqlConnection connection)
        {
            string query = @"SELECT PasswordResetOTP, PasswordResetOTPExpiry, PasswordResetAttempts
                           FROM Users WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string storedOTP = reader["PasswordResetOTP"].ToString();
                        DateTime expiry = Convert.ToDateTime(reader["PasswordResetOTPExpiry"]);
                        int attempts = Convert.ToInt32(reader["PasswordResetAttempts"]);

                        // Check if OTP matches and not expired
                        if (otp == storedOTP && DateTime.UtcNow <= expiry)
                        {
                            return true;
                        }
                    }
                }
            }

            // Record failed attempt
            RecordResetAttempt(email, connection);
            return false;
        }

        private bool IsRateLimited(string email, SqlConnection connection)
        {
            string query = @"SELECT PasswordResetAttempts, LastPasswordResetAttempt 
                           FROM Users WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        int attempts = Convert.ToInt32(reader["PasswordResetAttempts"]);
                        DateTime? lastAttempt = reader["LastPasswordResetAttempt"] as DateTime?;

                        return attempts >= MaxAttempts &&
                               lastAttempt.HasValue &&
                               lastAttempt.Value.AddMinutes(AttemptWindowMinutes) > DateTime.UtcNow;
                    }
                }
            }
            return false;
        }

        private void RecordResetAttempt(string email, SqlConnection connection)
        {
            string query = @"UPDATE Users 
                           SET PasswordResetAttempts = PasswordResetAttempts + 1,
                               LastPasswordResetAttempt = GETUTCDATE()
                           WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private void UpdateUserPassword(string email, string hashedPassword, SqlConnection connection)
        {
            string query = "UPDATE Users SET Password = @Password WHERE Email = @Email";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Password", hashedPassword);
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private void ClearResetOTP(string email, SqlConnection connection)
        {
            string query = @"UPDATE Users 
                           SET PasswordResetOTP = NULL,
                               PasswordResetOTPExpiry = NULL,
                               PasswordResetAttempts = 0,
                               LastPasswordResetAttempt = NULL
                           WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            pnlError.Visible = false;
            litSuccessMessage.Text = message;
        }

        private void ShowError(string errorMessage)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            litErrorMessage.Text = errorMessage;
        }
    }
}