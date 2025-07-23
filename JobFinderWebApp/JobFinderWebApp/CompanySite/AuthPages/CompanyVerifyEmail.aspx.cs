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
    public partial class CompanyVerifyEmail : System.Web.UI.Page
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
                    Response.Redirect("~/CompanySite/AuthPages/CompanyRegister.aspx");
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

                    if (!IsCompanyValidForResend(email, connection))
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
                Response.Redirect("~/CompanySite/AuthPages/CompanyRegister.aspx");
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

                    var (companyId, storedCode, expiryDate) = GetVerificationData(email, connection);
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
                        ActivateCompany(companyId, connection);
                        ClearVerificationSession();

                        // Set authenticated flag in session
                        Session["CompanyAuthenticated"] = true;
                        Response.Redirect("~/CompanySite/Views/Dashboard.aspx");
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
                Response.Redirect("~/CompanySite/AuthPages/CompanyRegister.aspx");
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (!IsCompanyValidForResend(email, connection))
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

        private (string companyId, string code, DateTime expiry) GetVerificationData(string email, SqlConnection connection)
        {
            string query = @"SELECT CompanyId, VerificationCode, VerificationCodeExpiry 
                           FROM Companies WHERE CompanyEmail = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return (
                            reader.GetString(0), // Changed to GetString
                            reader.GetString(1),
                            reader.GetDateTime(2)
                        );
                    }
                }
            }
            throw new Exception("Company not found");
        }

        private int GetRemainingAttempts(string email, SqlConnection connection)
        {
            string query = @"SELECT VerificationAttempts FROM Companies WHERE CompanyEmail = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                int attempts = (int)command.ExecuteScalar();
                return MaxAttempts - attempts;
            }
        }

        private void RecordVerificationAttempt(string email, SqlConnection connection)
        {
            string query = @"UPDATE Companies 
                           SET VerificationAttempts = VerificationAttempts + 1,
                               LastVerificationAttempt = GETUTCDATE()
                           WHERE CompanyEmail = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private bool IsCompanyValidForResend(string email, SqlConnection connection)
        {
            string query = @"SELECT COUNT(*) FROM Companies 
                           WHERE CompanyEmail = @Email AND IsEmailVerified = 0";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                return (int)command.ExecuteScalar() > 0;
            }
        }

        private void UpdateVerificationCode(string email, string code, DateTime expiry, SqlConnection connection)
        {
            string query = @"UPDATE Companies 
                           SET VerificationCode = @Code,
                               VerificationCodeExpiry = @Expiry,
                               VerificationAttempts = 0,
                               LastVerificationAttempt = NULL
                           WHERE CompanyEmail = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Code", code);
                command.Parameters.AddWithValue("@Expiry", expiry);
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private void ActivateCompany(string companyId, SqlConnection connection)
        {
            string query = @"UPDATE Companies 
                           SET IsEmailVerified = 1, 
                               IsActive = 1,
                               VerificationCode = NULL,
                               VerificationCodeExpiry = NULL,
                               VerificationAttempts = 0,
                               LastVerificationAttempt = NULL
                           WHERE CompanyId = @CompanyId";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@CompanyId", companyId);
                command.ExecuteNonQuery();
            }
        }

        private bool SendVerificationEmail(string email, string verificationCode)
        {
            try
            {
                using (MailMessage message = new MailMessage())
                {
                    message.From = new MailAddress(ConfigurationManager.AppSettings["FromEmail"], "JobFinder Company Services");
                    message.To.Add(email);
                    message.Subject = "Verify Your Company Account";
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
                            <h3 style='margin-bottom: 5px;'>Complete Your Company Registration</h3>
                            <p>Thank you for registering your company on JobFinder! To complete your registration and start posting jobs, please verify your email address by entering the following verification code:</p>
                            
                            <div class='code-box'>{verificationCode}</div>
                            
                            <div class='instructions'>
                                <p><strong>How to use this code:</strong></p>
                                <ol>
                                    <li>Return to the JobFinder website</li>
                                    <li>Enter the verification code above</li>
                                    <li>Click 'Verify' to complete your registration</li>
                                </ol>
                            </div>
                            
                            <p>This code will expire in <span class='highlight'>{VerificationCodeExpiryMinutes} minutes</span>. For security reasons, please do not share this code with anyone.</p>
                            
                            <p style='margin-top: 25px;'>If you didn't register your company on JobFinder, please ignore this email or contact our support team immediately.</p>
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
            catch (SmtpException smtpEx)
            {
                LogError($"SMTP Error sending company verification to {email}: {smtpEx.StatusCode} - {smtpEx.Message}");
                return false;
            }
            catch (Exception ex)
            {
                LogError($"General Error sending company verification to {email}: {ex}");
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