using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.CompanySite.AuthPages
{
    public partial class CompanyRegister : System.Web.UI.Page
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
                string companyName = txtCompanyName.Text.Trim();
                string email = txtEmail.Text.Trim().ToLower();
                string phone = txtPhone.Text.Trim();
                string password = txtPassword.Text;

                // Hash the password before storing
                string hashedPassword = HashPassword(password);

                if (RegisterCompany(companyName, email, phone, hashedPassword))
                {
                    // Store email in session for verification
                    Session["VerificationEmail"] = email;
                    Response.Redirect("CompanyVerifyEmail.aspx");
                }
            }
            catch (SqlException sqlEx) when (sqlEx.Number == 2627) // Unique constraint violation
            {
                ShowErrorMessage("This email is already registered.");
            }
            catch (Exception ex)
            {
                LogError($"Error during company registration: {ex}");
                ShowErrorMessage("An error occurred during registration. Please try again.");
            }
        }

        private bool RegisterCompany(string name, string email, string phone, string hashedPassword)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                INSERT INTO Companies 
                    (CompanyId, Name, CompanyEmail, CompanyPhone, Password, Logo, CreatedDate, IsActive, IsEmailVerified) 
                VALUES 
                    (@CompanyId, @Name, @Email, @Phone, @Password, @Logo, @CreatedDate, 0, 0)";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Generate a unique CompanyId based on current DateTime + random suffix
                    string CompanyId = "company" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + new Random().Next(100, 999);
               
                    command.Parameters.AddWithValue("@CompanyId", CompanyId);
                    command.Parameters.AddWithValue("@Name", name);
                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@Phone", phone);
                    command.Parameters.AddWithValue("@Password", hashedPassword);
                    command.Parameters.AddWithValue("@CreatedDate", DateTime.UtcNow);
                    command.Parameters.AddWithValue("@Logo", " https://img.freepik.com/premium-vector/minimalist-logo-design-any-corporate-brand-business-company_1253202-55597.jpg");

                    connection.Open();
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        protected void cvEmail_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !CompanyEmailExists(args.Value);
        }

        protected void cvAgree_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkAgree.Checked;
        }

        private bool CompanyEmailExists(string email)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Companies WHERE CompanyEmail = @Email";
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