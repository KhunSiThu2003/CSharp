using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class Views : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerifyUserAuthentication();
                LoadUserData();
                UpdateBadgeCounts();
            }
        }

        private void VerifyUserAuthentication()
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                return;
            }

            if (!CheckIfUserIsVerified(Session["userId"].ToString()))
            {
                Response.Redirect("~/UserSite/AuthPages/Login.aspx");
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
                    string query = "SELECT IsEmailVerified, ProfilePicture FROM Users WHERE UserId = @UserId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                if (reader["ProfilePicture"] != DBNull.Value)
                                {
                                    Session["userProfileImage"] = reader["ProfilePicture"].ToString();
                                }
                                return Convert.ToBoolean(reader["IsEmailVerified"]);
                            }
                            return false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error verifying user: {ex.Message}");
                return false;
            }
        }

        private void LoadUserData()
        {
            if (Session["userId"] == null) return;

            string userId = Session["userId"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT Username, Email, ProfilePicture FROM Users WHERE UserId = @UserId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["userName"] = reader["Username"].ToString();
                                Session["userEmail"] = reader["Email"].ToString();

                                if (reader["ProfilePicture"] != DBNull.Value)
                                {
                                    Session["userProfileImage"] = reader["ProfilePicture"].ToString();
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading user data: {ex.Message}");
            }
        }

        private void UpdateBadgeCounts()
        {
            if (Session["userId"] == null) return;

            string userId = Session["userId"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            Session["appCount"] = GetCount(connectionString,
                "SELECT COUNT(*) FROM Applications WHERE UserId = @UserId", userId);
            Session["savedCount"] = GetCount(connectionString,
                "SELECT COUNT(*) FROM SaveJobs WHERE UserId = @UserId", userId);
            Session["messageCount"] = GetCount(connectionString,
                "SELECT COUNT(*) FROM Messages WHERE ReceiverId = @UserId AND IsRead = 0", userId);
        }

        private int GetCount(string connectionString, string query, string userId)
        {
            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        return (int)command.ExecuteScalar();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting count: {ex.Message}");
                return 0;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            Response.Redirect("~/UserSite/AuthPages/Login.aspx");
        }

        public string GetUserName()
        {
            return Session["userName"]?.ToString() ?? "User";
        }

        public string GetUserProfileImage()
        {
            if (Session["userProfileImage"] != null && !string.IsNullOrEmpty(Session["userProfileImage"].ToString()))
            {
                return Session["userProfileImage"].ToString();
            }
            return "https://ui-avatars.com/api/?name=" + HttpUtility.UrlEncode(GetUserName()) + "&background=4f46e5&color=fff&size=128";
        }

        public void RefreshUserData()
        {
            LoadUserData();
            DataBind();
        }
    }
}