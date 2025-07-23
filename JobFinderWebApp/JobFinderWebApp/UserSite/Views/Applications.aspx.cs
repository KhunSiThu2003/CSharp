using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.UserSite.Views
{
    public partial class Applications : System.Web.UI.Page
    {
        private string UserId => Session["userId"]?.ToString();
        private int CurrentPage => ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1;
        private const int PageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (UserId == null)
                {
                    Response.Redirect("~/UserSite/AuthPages/Login.aspx");
                    return;
                }
                BindApplications();
            }
        }

        private void BindApplications()
        {
            string statusFilter = ddlStatusFilter.SelectedValue;
            string dateFilter = ddlDateFilter.SelectedValue;
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        SELECT 
                            a.ApplicationId, a.ApplicationDate, a.Status, a.ResumePath,
                            j.JobId, j.Title AS JobTitle, j.Location, j.JobType, 
                            j.ExperienceLevel, j.SalaryRange,
                            c.CompanyId, c.Name AS CompanyName, c.Logo AS CompanyLogo
                        FROM Applications a
                        INNER JOIN Jobs j ON a.JobId = j.JobId
                        INNER JOIN Companies c ON j.CompanyId = c.CompanyId
                        WHERE a.UserId = @UserId
                        {0} {1}
                        ORDER BY a.ApplicationDate DESC
                        OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    // Build filter conditions
                    string statusCondition = statusFilter != "All" ? "AND a.Status = @Status" : "";
                    string dateCondition = dateFilter != "All" ? "AND a.ApplicationDate >= DATEADD(day, -@Days, GETDATE())" : "";

                    query = string.Format(query, statusCondition, dateCondition);

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", UserId);
                        command.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * PageSize);
                        command.Parameters.AddWithValue("@PageSize", PageSize);

                        if (statusFilter != "All")
                            command.Parameters.AddWithValue("@Status", statusFilter);

                        if (dateFilter != "All")
                            command.Parameters.AddWithValue("@Days", int.Parse(dateFilter));

                        DataTable dt = new DataTable();
                        SqlDataAdapter adapter = new SqlDataAdapter(command);
                        adapter.Fill(dt);

                        rptApplications.DataSource = dt;
                        rptApplications.DataBind();

                        // Show no applications message if empty
                        if (dt.Rows.Count == 0)
                        {
                            var footer = (RepeaterItem)rptApplications.Controls[rptApplications.Controls.Count - 1].Controls[0];
                            var pnlNoApplications = (Panel)footer.FindControl("pnlNoApplications");
                            pnlNoApplications.Visible = true;
                        }

                        // Get total count for pagination
                        string countQuery = @"
                            SELECT COUNT(*) 
                            FROM Applications a
                            WHERE a.UserId = @UserId
                            {0} {1}";

                        countQuery = string.Format(countQuery, statusCondition, dateCondition);

                        using (var countCommand = new SqlCommand(countQuery, connection))
                        {
                            countCommand.Parameters.AddWithValue("@UserId", UserId);

                            if (statusFilter != "All")
                                countCommand.Parameters.AddWithValue("@Status", statusFilter);

                            if (dateFilter != "All")
                                countCommand.Parameters.AddWithValue("@Days", int.Parse(dateFilter));

                            int totalRecords = (int)countCommand.ExecuteScalar();

                            litTotalRecords.Text = totalRecords.ToString();
                            litStartRecord.Text = ((CurrentPage - 1) * PageSize + 1).ToString();
                            litEndRecord.Text = Math.Min(CurrentPage * PageSize, totalRecords).ToString();

                            btnPrevPage.Enabled = CurrentPage > 1;
                            btnNextPage.Enabled = CurrentPage * PageSize < totalRecords;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        protected void rptApplications_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Set status badge style
                string status = row["Status"].ToString();
                var litStatus = (Literal)e.Item.FindControl("litStatus");
                litStatus.Text = status;

                var statusBadge = (HtmlGenericControl)e.Item.FindControl("status-badge");
                if (statusBadge != null)
                {
                    statusBadge.Attributes["class"] += GetStatusBadgeClass(status);
                }

                // Set job information controls
                var litJobTitle = (Literal)e.Item.FindControl("litJobTitle");
                litJobTitle.Text = row["JobTitle"].ToString();

                var litCompanyName = (Literal)e.Item.FindControl("litCompanyName");
                litCompanyName.Text = row["CompanyName"].ToString();

                var litLocation = (Literal)e.Item.FindControl("litLocation");
                litLocation.Text = row["Location"].ToString();

                var litJobType = (Literal)e.Item.FindControl("litJobType");
                litJobType.Text = row["JobType"].ToString();

                var litExperienceLevel = (Literal)e.Item.FindControl("litExperienceLevel");
                litExperienceLevel.Text = row["ExperienceLevel"].ToString();

                var litSalaryRange = (Literal)e.Item.FindControl("litSalaryRange");
                litSalaryRange.Text = row["SalaryRange"].ToString();

                var litApplicationDate = (Literal)e.Item.FindControl("litApplicationDate");
                DateTime appDate = Convert.ToDateTime(row["ApplicationDate"]);
                litApplicationDate.Text = appDate.ToString("MMMM dd, yyyy");

                var litDaysSinceApplied = (Literal)e.Item.FindControl("litDaysSinceApplied");
                TimeSpan timeSinceApplied = DateTime.Now - appDate;
                litDaysSinceApplied.Text = $"{timeSinceApplied.Days} days ago";

                var imgCompanyLogo = (Image)e.Item.FindControl("imgCompanyLogo");
                imgCompanyLogo.ImageUrl = row["CompanyLogo"] != DBNull.Value ?
                    row["CompanyLogo"].ToString() :
                    "~/Content/Images/default-company.png";

                var hlViewJob = (HyperLink)e.Item.FindControl("hlViewJob");
                hlViewJob.NavigateUrl = $"~/UserSite/Views/JobDetail.aspx?id={row["JobId"]}";
            }
        }

        private string GetStatusBadgeClass(string status)
        {
            switch (status?.ToLower())
            {
                case "pending":
                    return " bg-yellow-100 dark:bg-yellow-900/40 text-yellow-800 dark:text-yellow-200";
                case "reviewed":
                    return " bg-blue-100 dark:bg-blue-900/40 text-blue-800 dark:text-blue-200";
                case "rejected":
                    return " bg-red-100 dark:bg-red-900/40 text-red-800 dark:text-red-200";
                case "hired":
                    return " bg-green-100 dark:bg-green-900/40 text-green-800 dark:text-green-200";
                default:
                    return " bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200";
            }
        }


        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState["CurrentPage"] = 1;
            BindApplications();
        }

        protected void ddlDateFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState["CurrentPage"] = 1;
            BindApplications();
        }

        protected void btnPrevPage_Click(object sender, EventArgs e)
        {
            ViewState["CurrentPage"] = CurrentPage - 1;
            BindApplications();
        }

        protected void btnNextPage_Click(object sender, EventArgs e)
        {
            ViewState["CurrentPage"] = CurrentPage + 1;
            BindApplications();
        }
    }
}