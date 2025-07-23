using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;

namespace JobFinderWebApp.UserSite.AuthPages
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check for registration success message
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
                        string query = @"SELECT UserId, Username, IsEmailVerified FROM Users 
                               WHERE Email = @Email AND Password = @Password";

                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@Email", email);
                            command.Parameters.AddWithValue("@Password", hashedPassword);
                            connection.Open();

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    string userId = reader["UserId"].ToString(); // Changed to handle string UserId
                                    string username = reader["Username"].ToString();
                                    bool isEmailVerified = Convert.ToBoolean(reader["IsEmailVerified"]);

                                    // Store user data in session
                                    Session["userId"] = userId;
                                    Session["userEmail"] = email;
                                    Session["username"] = username;

                                    if (isEmailVerified)
                                    {
                                        // Store authentication flag in session
                                        Session["IsAuthenticated"] = true;
                                        Response.Redirect("~/UserSite/Views/Dashboard.aspx");
                                    }
                                    else
                                    {
                                        Session["VerificationEmail"] = email;
                                        Response.Redirect("~/UserSite/AuthPages/VerifyEmail.aspx");
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