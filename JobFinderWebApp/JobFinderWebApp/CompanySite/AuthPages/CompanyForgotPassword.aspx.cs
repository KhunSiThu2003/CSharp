using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.AuthPages
{
    public partial class CompanyForgotPassword : System.Web.UI.Page
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
                        if (!IsValidCompany(email, connection))
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
                            UpdateCompanyPassword(email, hashedPassword, connection);

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

        private bool IsValidCompany(string email, SqlConnection connection)
        {
            string query = "SELECT COUNT(*) FROM Companies WHERE CompanyEmail = @Email";
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
            string query = @"UPDATE Companies 
                           SET PasswordResetOTP = @OTP,
                               PasswordResetOTPExpiry = @Expiry,
                               PasswordResetAttempts = 0,
                               LastPasswordResetAttempt = NULL
                           WHERE CompanyEmail = @Email";

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
                    message.From = new MailAddress(ConfigurationManager.AppSettings["FromEmail"], "JobFinder Company Services");
                    message.To.Add(email);
                    message.Subject = "Your Company Password Reset OTP Code";
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
                                background-color: #f5f7fa;
                            }}
                            .email-container {{
                                background: white;
                                border-radius: 8px;
                                padding: 30px;
                                box-shadow: 0 2px 15px rgba(0,0,0,0.08);
                                border-top: 4px solid #4f46e5;
                            }}
                            .header {{
                                text-align: center;
                                padding-bottom: 20px;
                                margin-bottom: 25px;
                                border-bottom: 1px solid #e5e7eb;
                            }}
                            .logo {{
                                font-size: 24px;
                                font-weight: bold;
                                color: #4f46e5;
                                margin-bottom: 5px;
                            }}
                            .tagline {{
                                font-size: 14px;
                                color: #6b7280;
                                font-style: italic;
                            }}
                            .content {{
                                margin: 20px 0;
                            }}
                            .code-box {{
                                background: #f8fafc;
                                border: 1px solid #e2e8f0;
                                padding: 20px;
                                text-align: center;
                                font-size: 28px;
                                font-weight: bold;
                                color: #4f46e5;
                                margin: 25px 0;
                                border-radius: 6px;
                                letter-spacing: 3px;
                                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                            }}
                            .instructions {{
                                background: #f0f9ff;
                                padding: 15px;
                                border-left: 4px solid #38bdf8;
                                margin: 20px 0;
                                border-radius: 4px;
                            }}
                            .footer {{
                                margin-top: 30px;
                                padding-top: 20px;
                                border-top: 1px solid #e5e7eb;
                                font-size: 12px;
                                color: #6b7280;
                                text-align: center;
                            }}
                            .button {{
                                display: inline-block;
                                padding: 12px 24px;
                                background-color: #4f46e5;
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
                            .highlight {{
                                color: #4f46e5;
                                font-weight: 600;
                            }}
                        </style>
                    </head>
                    <body>
                        <div class='email-container'>
                            <div class='header'>
                                <div class='logo'>JobFinder for Companies</div>
                                <div class='tagline'>Find the best talent for your business</div>
                            </div>
                            
                            <div class='content'>
                                <h3 style='margin-bottom: 5px;'>Password Reset Request</h3>
                                <p>We received a request to reset your company account password. Here's your verification code:</p>
                                
                                <div class='code-box'>{otp}</div>
                                
                                <div class='instructions'>
                                    <p><strong>How to use this code:</strong></p>
                                    <ol>
                                        <li>Return to the password reset page</li>
                                        <li>Enter the verification code above</li>
                                        <li>Create and confirm your new password</li>
                                    </ol>
                                </div>
                                
                                <p>This code will expire in <span class='highlight'>{OTPExpiryMinutes} minutes</span>. For security reasons, please do not share this code with anyone.</p>
                                
                                <p style='margin-top: 25px;'>If you didn't request a password reset, please ignore this email or contact our support team immediately.</p>
                            </div>
                            
                            <div class='footer'>
                                <p>Need help with your company account?</p>
                                <div class='contact-info'>
                                    <strong>Company Support:</strong> <a href='mailto:companies@jobfinder.com' style='color: #4f46e5;'>companies@jobfinder.com</a><br>
                                    <strong>Phone:</strong> +1 (555) 123-4567<br>
                                    <strong>Business Hours:</strong> Mon-Fri, 9AM-5PM EST
                                </div>
                                <p style='margin-top: 15px;'>© {DateTime.Now.Year} JobFinder Company Services. All rights reserved.</p>
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
                System.Diagnostics.Trace.TraceError($"[{DateTime.UtcNow}] Error sending OTP email to {email}: {ex}");
                return false;
            }
        }

        private bool IsValidOTP(string email, string otp, SqlConnection connection)
        {
            string query = @"SELECT PasswordResetOTP, PasswordResetOTPExpiry, PasswordResetAttempts
                           FROM Companies WHERE CompanyEmail = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string storedOTP = reader.GetString(0);
                        DateTime expiry = reader.GetDateTime(1);
                        int attempts = reader.GetInt32(2);

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
                           FROM Companies WHERE CompanyEmail = @Email";

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

        private void RecordResetAttempt(string email, SqlConnection connection)
        {
            string query = @"UPDATE Companies 
                           SET PasswordResetAttempts = PasswordResetAttempts + 1,
                               LastPasswordResetAttempt = GETUTCDATE()
                           WHERE CompanyEmail = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private void UpdateCompanyPassword(string email, string hashedPassword, SqlConnection connection)
        {
            string query = "UPDATE Companies SET Password = @Password WHERE CompanyEmail = @Email";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Password", hashedPassword);
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private void ClearResetOTP(string email, SqlConnection connection)
        {
            string query = @"UPDATE Companies 
                           SET PasswordResetOTP = NULL,
                               PasswordResetOTPExpiry = NULL,
                               PasswordResetAttempts = 0,
                               LastPasswordResetAttempt = NULL
                           WHERE CompanyEmail = @Email";

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