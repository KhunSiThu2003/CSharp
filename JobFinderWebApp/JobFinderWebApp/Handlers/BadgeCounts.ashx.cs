
using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;

namespace JobFinderWebApp.Handlers
{
    public class BadgeCounts : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                // 1. Check authentication
                if (context.Session["userId"] == null)
                {
                    ReturnZeroCounts(context);
                    return;
                }

                // 2. Get counts from database
                var counts = new
                {
                    applications = GetCount("Applications", "UserId", context.Session["userId"].ToString()),
                    savedJobs = GetCount("SaveJobs", "UserId", context.Session["userId"].ToString()),
                    messages = GetCount("Messages", "ReceiverId", context.Session["userId"].ToString(), "AND IsRead = 0")
                };

                // 3. Return JSON response
                context.Response.Write(JsonConvert.SerializeObject(counts));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"BadgeCounts Error: {ex.Message}");
                ReturnZeroCounts(context);
            }
        }

        private int GetCount(string tableName, string idColumn, string userId, string additionalConditions = "")
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;
            string query = $"SELECT COUNT(*) FROM {tableName} WHERE {idColumn} = @UserId {additionalConditions}";

            using (var connection = new SqlConnection(connectionString))
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@UserId", userId);
                connection.Open();
                return (int)command.ExecuteScalar();
            }
        }

        private void ReturnZeroCounts(HttpContext context)
        {
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                applications = 0,
                savedJobs = 0,
                messages = 0
            }));
        }

        public bool IsReusable => false;
    }
}