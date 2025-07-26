using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobConnect.AuthPages.Employer
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["JobConnectDB"].ConnectionString;

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
                        string query = @"SELECT Employer_Id, Name, IsEmailVerified FROM Employer 
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
                                    string employerId = reader["Employer_Id"].ToString();
                                    string name = reader["Name"].ToString();
                                    bool isEmailVerified = Convert.ToBoolean(reader["IsEmailVerified"]);

                                    // Store employer data in session
                                    Session["EmployerId"] = employerId;
                                    Session["EmployerEmail"] = email;
                                    Session["EmployerName"] = name;

                                    if (isEmailVerified)
                                    {
                                        Session["IsAuthenticated"] = true;
                                        Response.Redirect("~/Pages/Employer/Dashboard.aspx");
                                    }
                                    else
                                    {
                                        Session["VerificationEmail"] = email;
                                        Response.Redirect("~/AuthPages/Employer/VerifyEmail.aspx");
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