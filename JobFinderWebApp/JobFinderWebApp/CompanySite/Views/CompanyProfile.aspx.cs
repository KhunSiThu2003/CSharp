using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class CompanyProfile : System.Web.UI.Page
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

                LoadCompanyData();
            }
        }

        private void LoadCompanyData()
        {
            string companyId = Session["CompanyId"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = @"SELECT Name, Industry, Website, CompanyEmail, CompanyPhone, Location, 
                                   Description, Logo FROM Companies WHERE CompanyId = @CompanyId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@CompanyId", companyId);
                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtCompanyName.Text = reader["Name"].ToString();
                                ddlIndustry.SelectedValue = reader["Industry"].ToString();
                                txtWebsite.Text = reader["Website"] != DBNull.Value ?
                                    reader["Website"].ToString().Replace("https://", "") : "";
                                txtCompanyEmail.Text = reader["CompanyEmail"].ToString();
                                txtCompanyPhone.Text = reader["CompanyPhone"] != DBNull.Value ?
                                    reader["CompanyPhone"].ToString() : "";
                                txtCompanyLocation.Text = reader["Location"] != DBNull.Value ?
                                    reader["Location"].ToString() : "";
                                txtCompanyDescription.Text = reader["Description"] != DBNull.Value ?
                                    reader["Description"].ToString() : "";

                                // Set display values
                                litCompanyName.Text = reader["Name"].ToString();
                                litCompanyEmail.Text = reader["CompanyEmail"].ToString();
                                litCompanyPhone.Text = string.IsNullOrEmpty(reader["CompanyPhone"].ToString()) ?
                                    "Not provided" : reader["CompanyPhone"].ToString();
                                litCompanyLocation.Text = string.IsNullOrEmpty(reader["Location"].ToString()) ?
                                    "Location not set" : reader["Location"].ToString();

                                string logoUrl = reader["Logo"] != DBNull.Value ?
                                    reader["Logo"].ToString() :
                                    GetDefaultLogoUrl(reader["Name"].ToString());
                                imgCompanyLogo.ImageUrl = logoUrl;
                                lnkWebsite.NavigateUrl = reader["Website"] != DBNull.Value ?
                                    reader["Website"].ToString() : "#";
                                lnkWebsite.Text = reader["Website"] != DBNull.Value ?
                                    reader["Website"].ToString() : "No website";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Failed to load company data: {ex.Message}");
            }
        }

        private string GetDefaultLogoUrl(string companyName)
        {
            string cleanName = string.IsNullOrEmpty(companyName) ? "Company" : companyName.Trim();
            return $"https://ui-avatars.com/api/?name={Server.UrlEncode(cleanName)}&background=4f46e5&color=fff&size=256";
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (Session["CompanyId"] == null || Session["CompanyAuthenticated"] == null)
            {
                Response.Redirect("~/CompanySite/AuthPages/CompanyLogin.aspx");
                return;
            }

            string companyId = Session["CompanyId"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                // Handle logo upload
                string logoUrl = imgCompanyLogo.ImageUrl;
                if (fileCompanyLogo.HasFile)
                {
                    // Validate file type and size
                    string fileExtension = Path.GetExtension(fileCompanyLogo.FileName).ToLower();
                    if (!(fileExtension == ".jpg" || fileExtension == ".jpeg" || fileExtension == ".png" || fileExtension == ".gif"))
                    {
                        ShowErrorMessage("Only JPG, JPEG, PNG, and GIF files are allowed.");
                        return;
                    }

                    if (fileCompanyLogo.PostedFile.ContentLength > 2097152) // 2MB
                    {
                        ShowErrorMessage("Logo size must be less than 2MB.");
                        return;
                    }

                    // Create uploads directory if it doesn't exist
                    string uploadFolder = Server.MapPath("~/Uploads/CompanyLogos/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Delete old logo if it exists and is a local file
                    if (!string.IsNullOrEmpty(logoUrl) &&
                        logoUrl.StartsWith("/Uploads/CompanyLogos/") &&
                        File.Exists(Server.MapPath(logoUrl)))
                    {
                        File.Delete(Server.MapPath(logoUrl));
                    }

                    // Generate unique filename
                    string fileName = $"{companyId}_{DateTime.Now.Ticks}{Path.GetExtension(fileCompanyLogo.FileName)}";
                    string filePath = Path.Combine(uploadFolder, fileName);

                    // Save the file
                    fileCompanyLogo.SaveAs(filePath);

                    // Set the new URL (relative path)
                    logoUrl = $"/Uploads/CompanyLogos/{fileName}";
                }
                else if (string.IsNullOrEmpty(logoUrl) || !logoUrl.StartsWith("/Uploads/CompanyLogos/"))
                {
                    // If no logo is set or it's an external URL, use default
                    logoUrl = GetDefaultLogoUrl(txtCompanyName.Text.Trim());
                }

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = @"UPDATE Companies SET 
                                   Name = @Name, 
                                   Industry = @Industry, 
                                   Website = @Website, 
                                   CompanyEmail = @Email, 
                                   CompanyPhone = @Phone, 
                                   Location = @Location, 
                                   Description = @Description, 
                                   Logo = @Logo 
                                   WHERE CompanyId = @CompanyId";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Name", txtCompanyName.Text.Trim());
                        command.Parameters.AddWithValue("@Industry", ddlIndustry.SelectedValue);
                        command.Parameters.AddWithValue("@Website", string.IsNullOrEmpty(txtWebsite.Text.Trim()) ?
                            (object)DBNull.Value : $"https://{txtWebsite.Text.Trim()}");
                        command.Parameters.AddWithValue("@Email", txtCompanyEmail.Text.Trim());
                        command.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(txtCompanyPhone.Text.Trim()) ?
                            (object)DBNull.Value : txtCompanyPhone.Text.Trim());
                        command.Parameters.AddWithValue("@Location", string.IsNullOrEmpty(txtCompanyLocation.Text.Trim()) ?
                            (object)DBNull.Value : txtCompanyLocation.Text.Trim());
                        command.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(txtCompanyDescription.Text.Trim()) ?
                            (object)DBNull.Value : txtCompanyDescription.Text.Trim());
                        command.Parameters.AddWithValue("@Logo",
                            logoUrl.StartsWith("/Uploads/CompanyLogos/") ? logoUrl : (object)DBNull.Value);
                        command.Parameters.AddWithValue("@CompanyId", companyId);
                        command.ExecuteNonQuery();
                    }

                    // Update session and display
                    Session["CompanyName"] = txtCompanyName.Text.Trim();
                    litCompanyName.Text = txtCompanyName.Text.Trim();
                    litCompanyEmail.Text = txtCompanyEmail.Text.Trim();
                    litCompanyPhone.Text = string.IsNullOrEmpty(txtCompanyPhone.Text.Trim()) ?
                        "Not provided" : txtCompanyPhone.Text.Trim();
                    litCompanyLocation.Text = string.IsNullOrEmpty(txtCompanyLocation.Text.Trim()) ?
                        "Location not set" : txtCompanyLocation.Text.Trim();
                    lnkWebsite.NavigateUrl = string.IsNullOrEmpty(txtWebsite.Text.Trim()) ?
                        "#" : $"https://{txtWebsite.Text.Trim()}";
                    lnkWebsite.Text = string.IsNullOrEmpty(txtWebsite.Text.Trim()) ?
                        "No website" : $"https://{txtWebsite.Text.Trim()}";

                    // Only update image URL if it's a local path or default URL
                    imgCompanyLogo.ImageUrl = logoUrl.StartsWith("/Uploads/CompanyLogos/") ?
                        logoUrl : GetDefaultLogoUrl(txtCompanyName.Text.Trim());

                    ShowSuccessMessage("Company profile updated successfully!");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Failed to update company profile: {ex.Message}");
            }
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"Swal.fire('Success', '{message.Replace("'", "\\'")}', 'success');", true);
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"Swal.fire('Error', '{message.Replace("'", "\\'")}', 'error');", true);
        }
    }
}