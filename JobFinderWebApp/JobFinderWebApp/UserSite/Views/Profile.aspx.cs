using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userId"] == null)
                {
                    Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    return;
                }

                LoadProfileData();
            }
        }

        private void LoadProfileData()
        {
            string userId = Session["userId"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string userQuery = @"SELECT Username, Email, Phone, Bio, ProfilePicture, Title, Address 
                                        FROM Users 
                                        WHERE UserId = @UserId";
                    using (var command = new SqlCommand(userQuery, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Basic Information
                                litFullName.Text = reader["Username"].ToString();
                                txtFullName.Text = reader["Username"].ToString();
                                litEmail.Text = reader["Email"].ToString();
                                txtEmail.Text = reader["Email"].ToString();

                                // Contact Information
                                txtPhone.Text = reader["Phone"] != DBNull.Value ? reader["Phone"].ToString() : "";
                                litPhone.Text = string.IsNullOrEmpty(txtPhone.Text) ? "Not provided" : txtPhone.Text;

                                // Professional Information
                                txtTitle.Text = reader["Title"] != DBNull.Value ? reader["Title"].ToString() : "";
                                txtBio.Text = reader["Bio"] != DBNull.Value ? reader["Bio"].ToString() : "";

                                // Location Information
                                txtLocation.Text = reader["Address"] != DBNull.Value ? reader["Address"].ToString() : "";
                                litLocation.Text = string.IsNullOrEmpty(txtLocation.Text) ? "Location not set" : txtLocation.Text;

                                // Profile Picture
                                string profilePic = reader["ProfilePicture"] != DBNull.Value ?
                                    reader["ProfilePicture"].ToString() :
                                    GetDefaultProfileImageUrl(reader["Username"].ToString());
                                imgProfile.ImageUrl = profilePic;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Failed to load profile data: {ex.Message}");
            }
        }

        private string GetDefaultProfileImageUrl(string username)
        {
            string cleanName = string.IsNullOrEmpty(username) ? "User" : username.Trim();
            return $"https://ui-avatars.com/api/?name={Server.UrlEncode(cleanName)}&background=4f46e5&color=fff&size=256";
        }

        protected void btnSavePersonal_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                return;
            }

            string userId = Session["userId"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
            string profilePictureUrl = imgProfile.ImageUrl;

            try
            {
                // Handle profile picture upload if exists
                if (fileProfilePic.HasFile)
                {
                    // Validate file type and size
                    string fileExtension = Path.GetExtension(fileProfilePic.FileName).ToLower();
                    if (!(fileExtension == ".jpg" || fileExtension == ".jpeg" || fileExtension == ".png" || fileExtension == ".gif"))
                    {
                        ShowErrorMessage("Only JPG, JPEG, PNG, and GIF files are allowed.");
                        return;
                    }

                    if (fileProfilePic.PostedFile.ContentLength > 2097152) // 2MB
                    {
                        ShowErrorMessage("Profile picture size must be less than 2MB.");
                        return;
                    }

                    // Create uploads directory if it doesn't exist
                    string uploadFolder = Server.MapPath("~/Uploads/ProfilePictures/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Delete old profile picture if it exists and is a local file
                    if (!string.IsNullOrEmpty(profilePictureUrl) &&
                        profilePictureUrl.StartsWith("/Uploads/ProfilePictures/") &&
                        File.Exists(Server.MapPath(profilePictureUrl)))
                    {
                        File.Delete(Server.MapPath(profilePictureUrl));
                    }

                    // Generate unique filename
                    string fileName = $"{userId}_{DateTime.Now.Ticks}{Path.GetExtension(fileProfilePic.FileName)}";
                    string filePath = Path.Combine(uploadFolder, fileName);

                    // Save the file
                    fileProfilePic.SaveAs(filePath);

                    // Set the new URL (relative path)
                    profilePictureUrl = $"/Uploads/ProfilePictures/{fileName}";
                }
                else if (string.IsNullOrEmpty(profilePictureUrl) || !profilePictureUrl.StartsWith("/Uploads/ProfilePictures/"))
                {
                    // If no image is set or it's an external URL, use default
                    profilePictureUrl = GetDefaultProfileImageUrl(txtFullName.Text.Trim());
                }

                // Update profile information
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = @"UPDATE Users SET 
                                Username = @Username, 
                                Email = @Email, 
                                Phone = @Phone, 
                                Bio = @Bio, 
                                ProfilePicture = @ProfilePicture,
                                Title = @Title,
                                Address = @Address
                            WHERE UserId = @UserId";

                    using (var command = new SqlCommand(query, connection))
                    {
                        // Basic Information
                        command.Parameters.AddWithValue("@Username", txtFullName.Text.Trim());
                        command.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                        // Contact Information
                        command.Parameters.AddWithValue("@Phone",
                            string.IsNullOrEmpty(txtPhone.Text.Trim()) ?
                            (object)DBNull.Value : txtPhone.Text.Trim());

                        // Professional Information
                        command.Parameters.AddWithValue("@Bio",
                            string.IsNullOrEmpty(txtBio.Text.Trim()) ?
                            (object)DBNull.Value : txtBio.Text.Trim());
                        command.Parameters.AddWithValue("@Title",
                            string.IsNullOrEmpty(txtTitle.Text.Trim()) ?
                            (object)DBNull.Value : txtTitle.Text.Trim());

                        // Location Information
                        command.Parameters.AddWithValue("@Address",
                            string.IsNullOrEmpty(txtLocation.Text.Trim()) ?
                            (object)DBNull.Value : txtLocation.Text.Trim());

                        // Profile Picture
                        command.Parameters.AddWithValue("@ProfilePicture",
                            profilePictureUrl.StartsWith("/Uploads/ProfilePictures/") ?
                            profilePictureUrl : (object)DBNull.Value);

                        // User ID
                        command.Parameters.AddWithValue("@UserId", userId);

                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Update session and display
                            Session["userName"] = txtFullName.Text.Trim();
                            Session["userEmail"] = txtEmail.Text.Trim();

                            // Update displayed values
                            litFullName.Text = txtFullName.Text.Trim();
                            litEmail.Text = txtEmail.Text.Trim();
                            litPhone.Text = string.IsNullOrEmpty(txtPhone.Text.Trim()) ?
                                "Not provided" : txtPhone.Text.Trim();
                            litLocation.Text = string.IsNullOrEmpty(txtLocation.Text.Trim()) ?
                                "Location not set" : txtLocation.Text.Trim();
                            imgProfile.ImageUrl = profilePictureUrl.StartsWith("/Uploads/ProfilePictures/") ?
                                profilePictureUrl : GetDefaultProfileImageUrl(txtFullName.Text.Trim());

                            ShowSuccessMessage("Profile updated successfully!");
                        }
                        else
                        {
                            ShowErrorMessage("Failed to update profile. No rows affected.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Failed to update profile: {ex.Message}");
            }
        }

        protected void btnCancelPersonal_Click(object sender, EventArgs e)
        {
            LoadProfileData();
            ShowInfoMessage("Changes Discarded", "Your changes were not saved");
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"showSuccessMessage('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"showErrorMessage('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowInfoMessage(string title, string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showInfo",
                $"showInfoMessage('{title.Replace("'", "\\'")}', '{message.Replace("'", "\\'")}');", true);
        }
    }
}