using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.AuthPages
{
    public partial class AuthPages : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is authenticated via session
                if (Session["userId"] != null)
                {
                    // Check if user is verified
                    bool isVerified = CheckIfUserIsVerified(Session["userId"].ToString());

                    // If on wrong page, redirect appropriately
                    if (isVerified && !IsDashboardPage())
                    {
                        Response.Redirect("~/UserSite/Views/Dashboard.aspx");
                    }
                    else if (!isVerified && !IsVerifyEmailPage())
                    {
                        Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    }
                }
            }
        }

        private bool CheckIfUserIsVerified(string userId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT IsEmailVerified FROM Users WHERE UserId = @UserId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        var result = command.ExecuteScalar();
                        return result != null && Convert.ToBoolean(result);
                    }
                }
            }
            catch
            {
                return false;
            }
        }

        private bool IsDashboardPage()
        {
            return Request.Url.AbsolutePath.EndsWith("Dashboard.aspx", StringComparison.OrdinalIgnoreCase);
        }

        private bool IsVerifyEmailPage()
        {
            return Request.Url.AbsolutePath.EndsWith("VerifyEmail.aspx", StringComparison.OrdinalIgnoreCase);
        }
    }
}