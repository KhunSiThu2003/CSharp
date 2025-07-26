using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobConnect.AuthPages.JobSeeker
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobConnectDB"].ConnectionString;
        private const int OTPLength = 6;
        private const int OTPExpiryMinutes = 5;
        private const int MaxAttempts = 5;
        private const int AttemptWindowMinutes = 1;
        private const int PasswordResetTokenSize = 3;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Add security headers
                Response.Headers.Add("X-Frame-Options", "DENY");
                Response.Headers.Add("X-Content-Type-Options", "nosniff");
                Response.Headers.Add("X-XSS-Protection", "1; mode=block");
                Response.Headers.Add("Referrer-Policy", "strict-origin-when-cross-origin");

                if (Request.QueryString["otp"] == "true" && Session["ResetEmail"] != null)
                {
                    pnlEmailForm.Visible = false;
                    pnlOTPForm.Visible = true;
                    ViewState["Email"] = Session["ResetEmail"].ToString();
                    RegisterOTPExpiryScript();
                }
            }
            else if (pnlOTPForm.Visible)
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

        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Always return success message to prevent email enumeration
                    if (!IsValidJobSeeker(email, connection))
                    {
                        ShowSuccess("If your email exists in our system, you will receive an OTP code.");
                        return;
                    }

                    if (IsRateLimited(email, connection))
                    {
                        var lockoutEnd = GetLockoutEndTime(email, connection);
                        int remainingSeconds = (int)(lockoutEnd - DateTime.UtcNow).TotalSeconds;
                        RegisterRateLimitScript(remainingSeconds);
                        ShowError($"Too many attempts. Please try again in {FormatTime(remainingSeconds)}.");
                        return;
                    }

                    string otp = GenerateRandomOTP(OTPLength);
                    DateTime expiry = DateTime.UtcNow.AddMinutes(OTPExpiryMinutes);

                    StorePasswordResetOTP(email, otp, expiry, connection);

                    if (SendOTPEmail(email, otp))
                    {
                        pnlEmailForm.Visible = false;
                        pnlOTPForm.Visible = true;
                        ViewState["Email"] = email;
                        Session["ResetEmail"] = email;

                        RegisterOTPExpiryScript(expiry);
                        ShowSuccess($"OTP code has been sent to {email}. Please check your email.");
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"Error in btnSendOTP_Click for {email}: {ex}");
                ShowError("An error occurred. Please try again.");
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
                        var lockoutEnd = GetLockoutEndTime(email, connection);
                        int remainingSeconds = (int)(lockoutEnd - DateTime.UtcNow).TotalSeconds;
                        RegisterRateLimitScript(remainingSeconds);
                        ShowError($"Too many attempts. Please try again in {FormatTime(remainingSeconds)}.");
                        return;
                    }

                    string newOTP = GenerateRandomOTP(OTPLength);
                    DateTime newExpiry = DateTime.UtcNow.AddMinutes(OTPExpiryMinutes);

                    StorePasswordResetOTP(email, newOTP, newExpiry, connection);

                    if (SendOTPEmail(email, newOTP))
                    {
                        ShowSuccess($"A new OTP code has been sent to {email}. Please check your email.");
                        RegisterOTPExpiryScript(newExpiry);
                    }
                    else
                    {
                        ShowError("Failed to resend OTP. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"Error in btnResendOTP_Click for {email}: {ex}");
                ShowError("An error occurred. Please try again.");
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            RegisterOTPExpiryScript();

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
                        var lockoutEnd = GetLockoutEndTime(email, connection);
                        int remainingSeconds = (int)(lockoutEnd - DateTime.UtcNow).TotalSeconds;
                        RegisterRateLimitScript(remainingSeconds);
                        ShowError($"Too many attempts.");
                        return;
                    }

                    string enteredCode = txtOTP.Text.Trim();
                    var (isValid, message) = ValidateOTP(email, enteredCode, connection);

                    if (!isValid)
                    {
                        ShowError(message);
                        return;
                    }

                    string newPassword = txtNewPassword.Text;
                    string hashedPassword = HashPassword(newPassword);
                    UpdateJobSeekerPassword(email, hashedPassword, connection);
                    ClearResetOTP(email, connection);

                    ShowSuccess("Your password has been reset successfully. You can now login with your new password.");
                    pnlOTPForm.Visible = false;
                    Session.Remove("ResetEmail");
                }
            }
            catch (Exception ex)
            {
                LogError($"Error in btnResetPassword_Click for {email}: {ex}");
                ShowError("An error occurred. Please try again.");
            }
        }

        private string HashPassword(string password)
        {
            using (var deriveBytes = new Rfc2898DeriveBytes(password, 32, 10000))
            {
                byte[] salt = deriveBytes.Salt;
                byte[] hash = deriveBytes.GetBytes(32);

                return Convert.ToBase64String(salt) + "|" + Convert.ToBase64String(hash);
            }
        }

        private (bool isValid, string message) ValidateOTP(string email, string otp, SqlConnection connection)
        {
            string query = @"SELECT PasswordResetOTP, PasswordResetOTPExpiry, 
                   PasswordResetAttempts FROM JobSeeker WHERE Email = @Email";

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

                        reader.Close();

                        if (DateTime.UtcNow > expiry)
                        {
                            return (false, "OTP has expired. Please request a new one.");
                        }

                        if (!SecureCompareStrings(otp, storedOTP))
                        {
                            RecordResetAttempt(email, connection);
                            int remainingAttempts = MaxAttempts - attempts - 1;
                            return (false, $"Invalid OTP. {remainingAttempts} attempts remaining.");
                        }

                        return (true, "OTP is valid");
                    }
                }
            }
            return (false, "Invalid request. Please start the process again.");
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

        private bool IsRateLimited(string email, SqlConnection connection)
        {
            string query = @"SELECT PasswordResetAttempts, LastPasswordResetAttempt 
                           FROM JobSeeker WHERE Email = @Email";

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

        private bool IsValidJobSeeker(string email, SqlConnection connection)
        {
            string query = "SELECT COUNT(*) FROM JobSeeker WHERE Email = @Email AND IsEmailVerified = 1";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                return (int)command.ExecuteScalar() > 0;
            }
        }

        private string GenerateRandomOTP(int length)
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

        private void StorePasswordResetOTP(string email, string otp, DateTime expiry, SqlConnection connection)
        {
            string query = @"UPDATE JobSeeker 
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
                string emailBody = $@"
        <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333333; line-height: 1.6;'>
            <div style='text-align: center; margin-bottom: 30px;'>
                <h1 style='color: #2563eb; margin: 0 0 5px 0; font-size: 28px;'>JobConnect</h1>
                <p style='color: #64748b; font-size: 16px; margin: 0;'>Connecting Talent with Opportunity</p>
            </div>

            <div style='margin-bottom: 30px;'>
                <h2 style='color: #1e293b; margin: 0 0 20px 0; font-size: 18px; text-align: center;'>Password Reset Request</h2>
                <p style='margin: 0 0 20px 0;'>
                    We received a request to reset your JobConnect account password. Please use the following verification code:
                </p>
                
                <div style='background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 15px; text-align: center; margin: 25px 0; font-size: 28px; font-weight: bold; letter-spacing: 2px; color: #2563eb;'>
                    {otp}
                </div>
                
                <p style='margin: 0 0 20px 0;'>
                    This code will expire in {OTPExpiryMinutes} minutes. For security reasons, please do not share this code with anyone.
                </p>
                
                <p style='margin: 0; color: #64748b;'>
                    If you didn't request this password reset, you can safely ignore this email.
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
                    message.From = new MailAddress(ConfigurationManager.AppSettings["FromEmail"], "JobConnect Support");
                    message.To.Add(email);
                    message.Subject = "Your JobConnect Password Reset Code";
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
                LogError($"Error sending OTP email to {email}: {ex}");
                return false;
            }
        }

        private void RecordResetAttempt(string email, SqlConnection connection)
        {
            string query = @"UPDATE JobSeeker 
                           SET PasswordResetAttempts = PasswordResetAttempts + 1,
                               LastPasswordResetAttempt = GETUTCDATE()
                           WHERE Email = @Email";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                command.ExecuteNonQuery();
            }
        }

        private void UpdateJobSeekerPassword(string email, string hashedPassword, SqlConnection connection)
        {
            // Input validation
            if (string.IsNullOrWhiteSpace(email))
                throw new ArgumentException("Email cannot be empty", nameof(email));

            if (string.IsNullOrWhiteSpace(hashedPassword))
                throw new ArgumentException("Hashed password cannot be empty", nameof(hashedPassword));

            if (connection == null)
                throw new ArgumentNullException(nameof(connection));

            // Update query matching your current table schema
            string query = @"UPDATE JobSeeker 
                   SET Password = @Password,
                       PasswordResetOTP = NULL,         
                       PasswordResetOTPExpiry = NULL,  
                       PasswordResetAttempts = 0         
                   WHERE Email = @Email";

            try
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Parameterized query for security
                    command.Parameters.AddWithValue("@Password", hashedPassword);
                    command.Parameters.AddWithValue("@Email", email);

                    int rowsAffected = command.ExecuteNonQuery();

                    if (rowsAffected == 0)
                    {
                        throw new InvalidOperationException("No user was updated. Email may not exist.");
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log the error with additional context
                LogError($"Error updating password for {email}: {ex.Message}");
                throw; // Re-throw to handle at higher level
            }
        }

        private void ClearResetOTP(string email, SqlConnection connection)
        {
            string query = @"UPDATE JobSeeker 
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
                    var otpInfo = GetOTPInfo(email, connection);
                    if (!otpInfo.HasOTP || otpInfo.ExpiryDate <= DateTime.UtcNow) return;
                    actualExpiry = otpInfo.ExpiryDate;
                }
            }

            int remainingSeconds = (int)(actualExpiry - DateTime.UtcNow).TotalSeconds;
            string script = $"startOTPCountdown({remainingSeconds});";
            ScriptManager.RegisterStartupScript(this, GetType(), "startOTPCountdown", script, true);
        }

        private (bool HasOTP, DateTime ExpiryDate) GetOTPInfo(string email, SqlConnection connection)
        {
            string query = @"SELECT PasswordResetOTPExpiry FROM JobSeeker 
                           WHERE Email = @Email AND PasswordResetOTP IS NOT NULL";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Email", email);
                object result = command.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    return (true, Convert.ToDateTime(result));
                }
            }
            return (false, DateTime.MinValue);
        }

        private DateTime GetLockoutEndTime(string email, SqlConnection connection)
        {
            string query = @"SELECT DATEADD(MINUTE, @AttemptWindowMinutes, LastPasswordResetAttempt) 
                            FROM JobSeeker WHERE Email = @Email";
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
            btnResetPassword.Enabled = false;
            txtOTP.Enabled = false;
            txtNewPassword.Enabled = false;
            txtConfirmPassword.Enabled = false;
        }

        private string FormatTime(int totalSeconds)
        {
            int minutes = totalSeconds / 60;
            int seconds = totalSeconds % 60;
            return $"{minutes}m {seconds}s";
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

        private void LogError(string message)
        {
            System.Diagnostics.Trace.TraceError($"[{DateTime.UtcNow}] {message}");
        }
    }
}