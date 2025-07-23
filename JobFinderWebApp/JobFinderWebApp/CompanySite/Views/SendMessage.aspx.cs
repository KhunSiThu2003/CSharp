using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class SendMessage : System.Web.UI.Page
    {
        private string CompanyId => Session["CompanyId"] != null ? Session["CompanyId"].ToString() : string.Empty;
        private int ApplicationId => Request.QueryString["applicationId"] != null ? Convert.ToInt32(Request.QueryString["applicationId"]) : 0;
        private string ApplicantUserId => Request.QueryString["userId"] != null ? Request.QueryString["userId"] : string.Empty;
        private string CompanyUserId => Session["CompanyUserId"]?.ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(CompanyId) || ApplicationId == 0 || string.IsNullOrEmpty(ApplicantUserId))
                {
                    // Show more detailed error information for debugging
                    string errorMsg = $"Missing parameters: CompanyId={CompanyId}, ApplicationId={ApplicationId}, ApplicantUserId={ApplicantUserId}";
                    System.Diagnostics.Debug.WriteLine(errorMsg);
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{errorMsg}');", true);
                    Response.Redirect("~/CompanySite/Views/CompanyApplications.aspx");
                    return;
                }

                LoadRecipientInfo();
            }
        }

        private void LoadRecipientInfo()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        SELECT 
                            a.FullName, 
                            j.Title AS JobTitle,
                            u.UserId,
                            u.ProfilePicture
                        FROM Applications a
                        INNER JOIN Jobs j ON a.JobId = j.JobId
                        INNER JOIN Users u ON a.UserId = u.UserId
                        WHERE a.ApplicationId = @ApplicationId 
                        AND a.UserId = @ApplicantUserId
                        AND j.CompanyId = @CompanyId";

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@ApplicationId", ApplicationId);
                        command.Parameters.AddWithValue("@ApplicantUserId", ApplicantUserId);
                        command.Parameters.AddWithValue("@CompanyId", CompanyId);

                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                litRecipientName.Text = $"{reader["FullName"]} (Applicant for {reader["JobTitle"]})";
                            }
                            else
                            {
                                string errorMsg = "Application not found or you don't have permission.";
                                System.Diagnostics.Debug.WriteLine(errorMsg);
                                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{errorMsg}');", true);
                                Response.Redirect("~/CompanySite/Views/CompanyApplications.aspx");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading recipient info: {ex.Message}");
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error loading recipient information: {ex.Message.Replace("'", "\\'")}');", true);
                Response.Redirect("~/CompanySite/Views/CompanyApplications.aspx");
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // First verify the application still belongs to this company
                    string verifyQuery = @"
                        SELECT COUNT(*) 
                        FROM Applications a
                        INNER JOIN Jobs j ON a.JobId = j.JobId
                        WHERE a.ApplicationId = @ApplicationId
                        AND a.UserId = @ApplicantUserId
                        AND j.CompanyId = @CompanyId";

                    using (var verifyCommand = new SqlCommand(verifyQuery, connection))
                    {
                        verifyCommand.Parameters.AddWithValue("@ApplicationId", ApplicationId);
                        verifyCommand.Parameters.AddWithValue("@ApplicantUserId", ApplicantUserId);
                        verifyCommand.Parameters.AddWithValue("@CompanyId", CompanyId);

                        int validApplication = (int)verifyCommand.ExecuteScalar();

                        if (validApplication == 0)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                                "alert('Invalid application or permissions changed.');", true);
                            return;
                        }
                    }

                    // Insert the message
                    string insertQuery = @"
                        INSERT INTO Messages (SenderId, ReceiverId, Subject, Content, SentDate, IsRead)
                        VALUES (@SenderId, @ReceiverId, @Subject, @Content, GETDATE(), 0)";

                    using (var command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@SenderId", CompanyId);
                        command.Parameters.AddWithValue("@ReceiverId", ApplicantUserId);
                        command.Parameters.AddWithValue("@Subject", txtSubject.Text.Trim());
                        command.Parameters.AddWithValue("@Content", txtContent.Text.Trim());

                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            Response.Redirect("~/CompanySite/Views/CompanyApplications.aspx");
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                                "alert('Failed to send message.');", true);
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Message.Contains("FK_Messages_Sender"))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        "alert('Invalid sender ID. Please log in again.');", true);
                }
                else if (sqlEx.Message.Contains("FK_Messages_Receiver"))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        "alert('Invalid recipient ID.');", true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        $"alert('Database error: {sqlEx.Message.Replace("'", "\\'")}');", true);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error sending message: {ex.Message}");
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    $"alert('Error: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/CompanySite/Views/CompanyApplications.aspx");
        }
    }
}