using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class Views : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CompanyId"] == null || Session["CompanyAuthenticated"] == null)
                {
                    Response.Redirect("~/CompanySite/AuthPages/CompanyLogin.aspx");
                    return;
                }

                InitializeTheme();
                LoadCompanyData();
                UpdateActiveNavLink();
            }
        }

        private void InitializeTheme()
        {
            string themeScript = @"
                const savedTheme = localStorage.getItem('theme') || 
                                 (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
                
                document.documentElement.classList.toggle('dark', savedTheme === 'dark');
                updateThemeIcon();
                
                function updateThemeIcon() {
                    const isDark = document.documentElement.classList.contains('dark');
                    document.getElementById('themeIcon').classList.toggle('hidden', isDark);
                    document.getElementById('themeIconDark').classList.toggle('hidden', !isDark);
                }
            ";

            Page.ClientScript.RegisterStartupScript(GetType(), "InitTheme", themeScript, true);
        }

        private void UpdateActiveNavLink()
        {
            string currentPage = System.IO.Path.GetFileName(Request.Path).ToLower();
            string script = $@"
                document.querySelectorAll('.sidebar-link').forEach(link => {{
                    link.classList.remove('bg-blue-50', 'dark:bg-gray-900', 'text-blue-600', 'dark:text-blue-400');
                    link.classList.add('text-gray-700', 'dark:text-gray-300');
                }});
                
                const currentPage = '{currentPage}';
                const activeLinks = document.querySelectorAll(`.sidebar-link[href*='${{currentPage}}']`);
                if (activeLinks.length > 0) {{
                    activeLinks.forEach(link => {{
                        link.classList.add('bg-blue-50', 'dark:bg-gray-900', 'text-blue-600', 'dark:text-blue-400');
                        link.classList.remove('text-gray-700', 'dark:text-gray-300');
                    }});
                }}
            ";

            Page.ClientScript.RegisterStartupScript(GetType(), "UpdateActiveNav", script, true);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/CompanySite/AuthPages/CompanyLogin.aspx");
        }

        // Update the GetCompanyLogo method in Views.Master.cs
        // Update the GetCompanyLogo method
        public string GetCompanyLogo()
        {
            if (Session["CompanyId"] == null)
                return GetDefaultLogoUrl("Company");

            string companyId = Session["CompanyId"].ToString();
            string companyName = Session["CompanyName"]?.ToString() ?? "Company";
            string logoUrl = string.Empty;

            try
            {
                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString))
                {
                    connection.Open();
                    string query = "SELECT Logo FROM Companies WHERE CompanyId = @CompanyId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@CompanyId", companyId);
                        var result = command.ExecuteScalar();

                        // If logo exists in database, use it
                        if (result != null && result != DBNull.Value)
                        {
                            logoUrl = result.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting company logo: {ex.Message}");
            }

            // If no logo URL, generate default with company name
            return string.IsNullOrEmpty(logoUrl) ? GetDefaultLogoUrl(companyName) : logoUrl;
        }

        public string GetCompanyName()
        {
            return Session["CompanyName"]?.ToString() ?? "Company";
        }

        private string GetDefaultLogoUrl(string companyName)
        {
            string cleanName = string.IsNullOrEmpty(companyName) ? "Company" : companyName.Trim();
            return $"https://ui-avatars.com/api/?name={Uri.EscapeDataString(cleanName)}&background=4f46e5&color=fff&size=128";
        }

        protected void LoadCompanyData()
        {
            if (Session["CompanyId"] == null) return;

            string companyId = Session["CompanyId"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Load company basic info
                    // Load company basic info with logo
                    string query = "SELECT Name, Logo FROM Companies WHERE CompanyId = @CompanyId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@CompanyId", companyId);
                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string companyName = reader["Name"].ToString();
                                Session["CompanyName"] = companyName;
                                litCompanyName.Text = companyName;

                                // Update logo immediately if available
                                if (reader["Logo"] != DBNull.Value)
                                {
                                    string logoUrl = reader["Logo"].ToString();
                                    imgCompanyLogo.ImageUrl = logoUrl;
                                }
                            }
                        }
                    }

                    // Load counts for notifications
                    query = @"
                        SELECT 
                            (SELECT COUNT(*) FROM Jobs WHERE CompanyId = @CompanyId AND IsActive = 1) AS ActiveJobs,
                            (SELECT COUNT(*) FROM Applications a 
                             JOIN Jobs j ON a.JobId = j.JobId 
                             WHERE j.CompanyId = @CompanyId AND a.Status = 'Applied') AS NewApplications,
                            (SELECT COUNT(*) FROM Notifications 
                             WHERE CompanyId = @CompanyId AND IsRead = 0) AS UnreadNotifications";

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@CompanyId", companyId);
                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                litActiveJobsCount.Text = reader["ActiveJobs"].ToString();
                                litNewApplicationsCount.Text = reader["NewApplications"].ToString();
                                
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading company data: {ex.Message}");
            }
        }
    }
}