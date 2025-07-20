using JobBridge.Services;
using System;
using System.Web;

namespace JobBridge.Pages.WebPages
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if token exists in session or cookie
            string token = GetUserToken();

            if (string.IsNullOrEmpty(token))
            {
                // Token is null or empty - redirect to home page
                Response.Redirect("~/Pages/WebPages/HomePage.aspx");
            }
            else
            {
                // Token exists - redirect to appropriate dashboard based on user role
                RedirectBasedOnUserRole(token);
            }
        }

        private string GetUserToken()
        {
            // Check for token in multiple possible locations (in order of priority)

            // 1. Check Session first
            if (Session["AuthToken"] != null)
                return Session["AuthToken"].ToString();

            // 2. Check Cookie
            HttpCookie authCookie = Request.Cookies["AuthToken"];
            if (authCookie != null && !string.IsNullOrEmpty(authCookie.Value))
                return authCookie.Value;

            // 3. Check Query String (for email links, etc.)
            if (!string.IsNullOrEmpty(Request.QueryString["token"]))
                return Request.QueryString["token"];

            return null;
        }

        private void RedirectBasedOnUserRole(string token)
        {
            // In a real application, you would decode the token to get user claims/roles
            // For this example, we'll assume you have a method to get the role from the token

            string userRole = TokenService.GetUserRoleFromToken(token);

            switch (userRole)
            {
                case "Admin":
                    Response.Redirect("~/Pages/Admin/Dashboard.aspx");
                    break;
                case "Employer":
                    Response.Redirect("~/Pages/Employer/Dashboard.aspx");
                    break;
                case "JobSeeker":
                    Response.Redirect("~/Pages/JobSeeker/Dashboard.aspx");
                    break;
                default:
                    // If role not recognized, redirect to home
                    Response.Redirect("~/Pages/WebPages/HomePage.aspx");
                    break;
            }
        }
    }
}