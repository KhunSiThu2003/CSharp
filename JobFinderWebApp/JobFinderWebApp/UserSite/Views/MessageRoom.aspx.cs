using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class MessageRoom : System.Web.UI.Page
    {
        protected string PartnerId;
        protected string CurrentUserId;
        private string _tempFilePath = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Session["userId"]?.ToString()))
            {
                Response.Redirect("/Login");
                return;
            }

            CurrentUserId = Session["userId"].ToString();
            PartnerId = Request.QueryString["id"];

            if (string.IsNullOrEmpty(PartnerId))
            {
                Response.Redirect("Messages.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadPartnerInfo();
                LoadMessages();
                // Register scroll script for initial load
                ScriptManager.RegisterStartupScript(this, GetType(), "initialScroll", "scrollToBottom();", true);
            }
            else
            {
                CleanUpTempFile();
            }
        }
        private void CleanUpTempFile()
        {
            if (!string.IsNullOrEmpty(_tempFilePath) && File.Exists(Server.MapPath(_tempFilePath)))
            {
                try
                {
                    File.Delete(Server.MapPath(_tempFilePath));
                }
                catch { /* Ignore deletion errors */ }
            }
            _tempFilePath = string.Empty;
        }

        protected string GetAttachmentHtml(string filePath, string fileData, bool isSent)
        {
            if (string.IsNullOrEmpty(filePath)) return string.Empty;

            string fileName = Path.GetFileName(filePath);
            string fileExtension = Path.GetExtension(filePath).ToLower();
            bool isImage = fileExtension == ".jpg" || fileExtension == ".jpeg" || fileExtension == ".png" || fileExtension == ".gif";

            string html = "<div class='mt-2'>";

            if (isImage)
            {
                html += $@"<a href='{filePath}' target='_blank' class='block'>
                            <img src='{filePath}' class='max-w-xs max-h-40 rounded-lg border border-gray-200' alt='{fileName}' />
                          </a>";
            }
            else
            {
                string iconClass = GetFileIconClass(fileExtension);

                html += $@"<div class='flex items-center p-2 bg-{(isSent ? "blue-100" : "gray-100")} rounded-lg'>
                            <div class='mr-3 text-{(isSent ? "blue-500" : "gray-600")}'>
                                <i class='{iconClass}'></i>
                            </div>
                            <div class='flex-1'>
                                <a href='{filePath}' target='_blank' class='text-sm font-medium text-{(isSent ? "blue-800" : "gray-800")}'>{fileName}</a>
                                <div class='text-xs text-{(isSent ? "blue-600" : "gray-500")}'>{fileData}</div>
                            </div>
                          </div>";
            }

            html += "</div>";
            return html;
        }

        private string GetFileIconClass(string fileExtension)
        {
            switch (fileExtension)
            {
                case ".pdf":
                    return "fas fa-file-pdf text-lg";
                case ".doc":
                case ".docx":
                    return "fas fa-file-word text-lg";
                case ".xls":
                case ".xlsx":
                    return "fas fa-file-excel text-lg";
                case ".ppt":
                case ".pptx":
                    return "fas fa-file-powerpoint text-lg";
                case ".zip":
                case ".rar":
                    return "fas fa-file-archive text-lg";
                case ".mp4":
                case ".mov":
                case ".avi":
                    return "fas fa-file-video text-lg";
                default:
                    return "fas fa-file text-lg";
            }
        }

        private void LoadPartnerInfo()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
            string query = @"
                SELECT 
                    CASE 
                        WHEN UserId LIKE 'company%' THEN Name
                        ELSE Username
                    END AS DisplayName,
                    CASE 
                        WHEN UserId LIKE 'company%' THEN ISNULL(Logo, '/images/default-avatar.png')
                        ELSE ISNULL(ProfilePicture, '/images/default-avatar.png')
                    END AS DisplayImage
                FROM (
                    SELECT UserId, Username, ProfilePicture, NULL AS Name, NULL AS Logo FROM Users
                    UNION
                    SELECT CompanyId AS UserId, NULL AS Username, NULL AS ProfilePicture, Name, Logo FROM Companies
                ) AS Combined
                WHERE UserId = @PartnerId";

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@PartnerId", PartnerId);
                        connection.Open();

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                partnerName.InnerText = reader["DisplayName"].ToString();
                                partnerImage.Src = reader["DisplayImage"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowCustomAlert("Error loading partner information: " + ex.Message);
            }
        }

        private void LoadMessages()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
            string query = @"
                SELECT 
                    MessageId, 
                    SenderId, 
                    ReceiverId, 
                    MessageText, 
                    FilePath,
                    FileData,
                    SentDate
                FROM Messages
                WHERE (SenderId = @UserId AND ReceiverId = @PartnerId)
                   OR (SenderId = @PartnerId AND ReceiverId = @UserId)
                ORDER BY SentDate ASC";

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", CurrentUserId);
                        command.Parameters.AddWithValue("@PartnerId", PartnerId);
                        connection.Open();

                        DataTable dt = new DataTable();
                        dt.Load(command.ExecuteReader());

                        rptMessages.DataSource = dt;
                        rptMessages.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowCustomAlert("Error loading messages: " + ex.Message);
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(txtMessage.Text) || fuAttachment.HasFile)
            {
                string filePath = string.Empty;
                string fileData = string.Empty;

                if (fuAttachment.HasFile)
                {
                    HttpPostedFile file = fuAttachment.PostedFile;

                    try
                    {
                        if (file.ContentLength > 50 * 1024 * 1024)
                        {
                            ShowCustomAlert("File size cannot exceed 50MB");
                            return;
                        }

                        string extension = Path.GetExtension(file.FileName).ToLower();
                        string[] allowedExtensions = {
                            ".jpg", ".jpeg", ".png", ".gif",
                            ".pdf", ".doc", ".docx", ".xls",
                            ".xlsx", ".ppt", ".pptx", ".txt",
                            ".mp4", ".mov", ".avi"
                        };

                        if (Array.IndexOf(allowedExtensions, extension) == -1)
                        {
                            ShowCustomAlert("File type not allowed. Allowed types: " +
                                "Images (JPG, PNG, GIF), Documents (PDF, DOC, XLS, PPT, TXT), Videos (MP4, MOV, AVI)");
                            return;
                        }

                        string uploadFolder = "~/Uploads/Messages/";
                        string physicalPath = Server.MapPath(uploadFolder);

                        if (!Directory.Exists(physicalPath))
                        {
                            Directory.CreateDirectory(physicalPath);
                        }

                        string uniqueFileName = Guid.NewGuid().ToString() + extension;
                        string fullPath = Path.Combine(physicalPath, uniqueFileName);
                        file.SaveAs(fullPath);

                        filePath = ResolveUrl(uploadFolder + uniqueFileName);
                        fileData = $"{file.FileName} ({FormatFileSize(file.ContentLength)})";
                    }
                    catch (Exception ex)
                    {
                        ShowCustomAlert("Error uploading file: " + ex.Message);
                        return;
                    }
                }

                try
                {
                    string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
                    string query = @"
                        INSERT INTO Messages (SenderId, ReceiverId, MessageText, FilePath, FileData, SentDate)
                        VALUES (@SenderId, @ReceiverId, @MessageText, @FilePath, @FileData, @SentDate)";

                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@SenderId", CurrentUserId);
                            command.Parameters.AddWithValue("@ReceiverId", PartnerId);
                            command.Parameters.AddWithValue("@MessageText", txtMessage.Text.Trim());
                            command.Parameters.AddWithValue("@FilePath", filePath);
                            command.Parameters.AddWithValue("@FileData", fileData);
                            command.Parameters.AddWithValue("@SentDate", DateTime.Now);

                            connection.Open();
                            command.ExecuteNonQuery();
                        }
                    }

                    // Clear inputs
                    txtMessage.Text = "";
                    fuAttachment.Attributes.Clear();
                    ScriptManager.RegisterStartupScript(this, GetType(), "clearFilePreview",
                        "document.getElementById('filePreviewContainer').classList.add('hidden');", true);

                    // Reload messages and scroll to bottom
                    LoadMessages();
                    ScriptManager.RegisterStartupScript(this, GetType(), "scrollToBottom",
                        "setTimeout(scrollToBottom, 100);", true);
                }
                catch (Exception ex)
                {
                    ShowCustomAlert("Error sending message: " + ex.Message);
                }
            }
        }

        private string FormatFileSize(long bytes)
        {
            string[] sizes = { "B", "KB", "MB", "GB" };
            int order = 0;
            while (bytes >= 1024 && order < sizes.Length - 1)
            {
                order++;
                bytes = bytes / 1024;
            }
            return $"{bytes:0.##} {sizes[order]}";
        }

        private void ShowCustomAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showCustomAlert",
                $"showAlert('{HttpUtility.JavaScriptStringEncode(message)}');", true);
        }
    }
}