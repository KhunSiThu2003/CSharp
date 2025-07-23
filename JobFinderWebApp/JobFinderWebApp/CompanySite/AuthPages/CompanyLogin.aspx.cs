using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.AuthPages
{
    public partial class CompanyLogin : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["registered"] == "true")
                {
                    ShowMessage("Registration successful! Please log in.", "success");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string email = txtEmail.Text;
                    string password = txtPassword.Text;
                    string hashedPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(password, "SHA256");

                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"SELECT CompanyId, Name, IsEmailVerified FROM Companies 
                               WHERE CompanyEmail = @Email AND Password = @Password";

                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@Email", email);
                            command.Parameters.AddWithValue("@Password", hashedPassword);
                            connection.Open();

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    string companyId = reader.GetString(0); // Changed to GetString
                                    string companyName = reader.GetString(1);
                                    bool isEmailVerified = reader.GetBoolean(2);

                                    // Store company data in session
                                    Session["CompanyId"] = companyId;
                                    Session["CompanyEmail"] = email;
                                    Session["CompanyName"] = companyName;

                                    if (isEmailVerified)
                                    {
                                        // Store authentication flag in session
                                        Session["CompanyAuthenticated"] = true;
                                        Response.Redirect("~/CompanySite/Views/Dashboard.aspx");
                                    }
                                    else
                                    {
                                        Session["VerificationEmail"] = email;
                                        Response.Redirect("~/CompanySite/AuthPages/CompanyVerifyEmail.aspx");
                                    }
                                }
                                else
                                {
                                    ShowError("Invalid email or password");
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError($"An error occurred: {ex.Message}");
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showMessage",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowError(string errorMessage)
        {
            pnlError.Visible = true;
            litErrorMessage.Text = errorMessage;
        }
    }
}