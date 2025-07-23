using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class Messages : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(Session["userId"]?.ToString()))
                {
                    Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    return;
                }

                LoadConversations();
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                SearchUsersAndCompanies(txtSearch.Text.Trim());
                pnlSearchResults.Visible = true;
            }
            else
            {
                pnlSearchResults.Visible = false;
            }
        }

        private void SearchUsersAndCompanies(string searchTerm)
        {
            string userId = Session["userId"]?.ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            string query = @"
                -- Search for users
                SELECT 
                    UserId AS Id,
                    Username AS Name,
                    'User' AS Type,
                    ISNULL(ProfilePicture, '/images/default-avatar.png') AS Image
                FROM Users
                WHERE Username LIKE @SearchTerm AND UserId <> @UserId
                
                UNION ALL
                
                -- Search for companies
                SELECT 
                    CompanyId AS Id,
                    Name,
                    'Company' AS Type,
                    ISNULL(Logo, '/images/default-company.png') AS Image
                FROM Companies
                WHERE Name LIKE @SearchTerm
                
                ORDER BY Name";

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                        command.Parameters.AddWithValue("@UserId", userId);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptSearchResults.DataSource = dt;
                            rptSearchResults.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error searching: {ex.Message}");
                ClientScript.RegisterStartupScript(GetType(), "alert",
                    $"alert('Error performing search. Please try again.');", true);
            }
        }

        private void LoadConversations()
        {
            string userId = Session["userId"]?.ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            string query = @"
        SELECT 
            CASE WHEN m.SenderId = @UserId THEN m.ReceiverId ELSE m.SenderId END AS PartnerId,
            m.MessageText AS LastMessage,
            m.SentDate AS LastMessageTime,
            CASE 
                WHEN m.SenderId = @UserId THEN 'You: ' + m.MessageText
                ELSE m.MessageText
            END AS DisplayMessage,
            CASE
                WHEN m.SenderId LIKE 'company%' OR m.ReceiverId LIKE 'company%' THEN c.Name
                WHEN m.SenderId = @UserId THEN u2.Username
                ELSE u1.Username
            END AS PartnerName,
            CASE
                WHEN m.SenderId LIKE 'company%' OR m.ReceiverId LIKE 'company%' THEN ISNULL(c.Logo, '/images/default-avatar.png')
                WHEN m.SenderId = @UserId THEN ISNULL(u2.ProfilePicture, '/images/default-avatar.png')
                ELSE ISNULL(u1.ProfilePicture, '/images/default-avatar.png')
            END AS PartnerImage
        FROM Messages m
        LEFT JOIN Users u1 ON m.SenderId = u1.UserId AND m.SenderId <> @UserId AND m.SenderId NOT LIKE 'company%'
        LEFT JOIN Users u2 ON m.ReceiverId = u2.UserId AND m.ReceiverId <> @UserId AND m.ReceiverId NOT LIKE 'company%'
        LEFT JOIN Companies c ON (m.SenderId = c.CompanyId OR m.ReceiverId = c.CompanyId)
        WHERE m.MessageId IN (
            SELECT MAX(MessageId)
            FROM Messages
            WHERE SenderId = @UserId OR ReceiverId = @UserId
            GROUP BY 
                CASE 
                    WHEN SenderId = @UserId THEN ReceiverId 
                    ELSE SenderId 
                END
        )
        ORDER BY m.SentDate DESC";

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptConversations.DataSource = dt;
                            rptConversations.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading conversations: {ex.Message}");
                ClientScript.RegisterStartupScript(GetType(), "alert",
                    $"alert('Error loading messages. Please check debug console for details.');", true);
            }
        }
    }
}