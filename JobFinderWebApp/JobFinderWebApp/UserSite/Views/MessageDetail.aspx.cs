using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class MessageDetail : System.Web.UI.Page
    {
        private string UserId => Session["UserId"]?.ToString();
        private int MessageId => Request.QueryString["id"] != null ? Convert.ToInt32(Request.QueryString["id"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (UserId == null)
                {
                    Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    return;
                }

                if (MessageId == 0)
                {
                    Response.Redirect("~/UserSite/Views/Messages.aspx");
                    return;
                }

                LoadMessage();
                MarkAsRead();
            }
        }

        private void LoadMessage()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        SELECT 
                            m.Subject, m.Content, m.SentDate,
                            u.UserId as SenderId, u.Username as SenderName, u.ProfilePicture as SenderImage,
                            c.Name as CompanyName, c.Logo as CompanyLogo
                        FROM Messages m
                        LEFT JOIN Users u ON m.SenderId = u.UserId
                        LEFT JOIN Companies c ON u.CompanyId = c.CompanyId
                        WHERE m.MessageId = @MessageId AND m.ReceiverId = @ReceiverId";

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@MessageId", MessageId);
                        command.Parameters.AddWithValue("@ReceiverId", UserId);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Set sender image
                                imgSender.ImageUrl = reader["SenderImage"] != DBNull.Value ?
                                    reader["SenderImage"].ToString() :
                                    reader["CompanyLogo"] != DBNull.Value ?
                                    reader["CompanyLogo"].ToString() :
                                    "~/Content/Images/default-profile.png";

                                // Set sender name
                                litSenderName.Text = reader["CompanyName"] != DBNull.Value ?
                                    reader["CompanyName"].ToString() :
                                    reader["SenderName"].ToString();

                                // Set other fields
                                litSubject.Text = reader["Subject"].ToString();
                                litContent.Text = reader["Content"].ToString();
                                litSentDate.Text = Convert.ToDateTime(reader["SentDate"]).ToString("MMMM dd, yyyy h:mm tt");
                            }
                            else
                            {
                                Response.Redirect("~/UserSite/Views/Messages.aspx");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading message: {ex.Message}");
                Response.Redirect("~/UserSite/Views/Messages.aspx");
            }
        }

        private void MarkAsRead()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "UPDATE Messages SET IsRead = 1 WHERE MessageId = @MessageId AND ReceiverId = @ReceiverId";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@MessageId", MessageId);
                    command.Parameters.AddWithValue("@ReceiverId", UserId);
                    command.ExecuteNonQuery();
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "DELETE FROM Messages WHERE MessageId = @MessageId AND ReceiverId = @ReceiverId";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@MessageId", MessageId);
                    command.Parameters.AddWithValue("@ReceiverId", UserId);
                    command.ExecuteNonQuery();
                }
            }

            Response.Redirect("~/UserSite/Views/Messages.aspx");
        }
    }
}