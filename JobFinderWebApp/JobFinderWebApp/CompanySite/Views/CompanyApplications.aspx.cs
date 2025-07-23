using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web;

namespace JobFinderWebApp.CompanySite.Views
{
    public partial class CompanyApplications : System.Web.UI.Page
    {
        private string CompanyId => Session["CompanyId"]?.ToString() ?? string.Empty;
        private int CurrentPage => ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1;
        private const int PageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(CompanyId))
                {
                    Response.Redirect("~/CompanySite/AuthPages/Login.aspx");
                    return;
                }

                LoadJobFilter();
                BindApplications();
            }
        }

        private void LoadJobFilter()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "SELECT JobId, Title FROM Jobs WHERE CompanyId = @CompanyId AND IsActive = 1 ORDER BY PostedDate DESC";

                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@CompanyId", CompanyId);

                    SqlDataReader reader = command.ExecuteReader();
                    ddlJobFilter.DataSource = reader;
                    ddlJobFilter.DataTextField = "Title";
                    ddlJobFilter.DataValueField = "JobId";
                    ddlJobFilter.DataBind();
                }
            }
        }

        private void BindApplications()
        {
            string jobId = ddlJobFilter.SelectedValue;
            string statusFilter = ddlStatusFilter.SelectedValue ?? "All";

            int daysFilter = 0;
            if (!string.IsNullOrWhiteSpace(ddlDateFilter.SelectedValue))
            {
                if (!int.TryParse(ddlDateFilter.SelectedValue, out daysFilter))
                {
                    daysFilter = 0;
                }
            }

            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        SELECT 
                            a.ApplicationId, a.ApplicationDate, a.Status, a.ResumePath,
                            a.FullName, a.Email, a.Phone, a.UserId,
                            u.ProfilePicture,
                            j.JobId, j.Title AS JobTitle, j.JobType
                        FROM Applications a
                        INNER JOIN Jobs j ON a.JobId = j.JobId
                        LEFT JOIN Users u ON a.UserId = u.UserId
                        WHERE j.CompanyId = @CompanyId
                        {0} {1} {2}
                        ORDER BY a.ApplicationDate DESC
                        OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    string jobCondition = !string.IsNullOrEmpty(jobId) && jobId != "0" ? "AND j.JobId = @JobId" : "";
                    string statusCondition = statusFilter != "All" ? "AND a.Status = @Status" : "";
                    string dateCondition = daysFilter > 0 ? "AND a.ApplicationDate >= DATEADD(day, -@Days, GETDATE())" : "";

                    query = string.Format(query, jobCondition, statusCondition, dateCondition);

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@CompanyId", CompanyId);
                        command.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * PageSize);
                        command.Parameters.AddWithValue("@PageSize", PageSize);

                        if (!string.IsNullOrEmpty(jobId) && jobId != "0")
                            command.Parameters.AddWithValue("@JobId", jobId);

                        if (statusFilter != "All")
                            command.Parameters.AddWithValue("@Status", statusFilter);

                        if (daysFilter > 0)
                            command.Parameters.AddWithValue("@Days", daysFilter);

                        DataTable dt = new DataTable();
                        SqlDataAdapter adapter = new SqlDataAdapter(command);
                        adapter.Fill(dt);

                        gvApplications.DataSource = dt;
                        gvApplications.DataBind();

                        string countQuery = @"
                            SELECT COUNT(*) 
                            FROM Applications a
                            INNER JOIN Jobs j ON a.JobId = j.JobId
                            WHERE j.CompanyId = @CompanyId
                            {0} {1} {2}";

                        countQuery = string.Format(countQuery, jobCondition, statusCondition, dateCondition);

                        using (var countCommand = new SqlCommand(countQuery, connection))
                        {
                            countCommand.Parameters.AddWithValue("@CompanyId", CompanyId);

                            if (!string.IsNullOrEmpty(jobId) && jobId != "0")
                                countCommand.Parameters.AddWithValue("@JobId", jobId);

                            if (statusFilter != "All")
                                countCommand.Parameters.AddWithValue("@Status", statusFilter);

                            if (daysFilter > 0)
                                countCommand.Parameters.AddWithValue("@Days", daysFilter);

                            int totalRecords = (int)countCommand.ExecuteScalar();
                            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);

                            litTotalApplications.Text = totalRecords.ToString();
                            litCurrentPage.Text = CurrentPage.ToString();
                            litTotalPages.Text = totalPages.ToString();

                            btnPrevPage.Enabled = CurrentPage > 1;
                            btnNextPage.Enabled = CurrentPage < totalPages;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading applications: {ex.Message}");
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error loading applications: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void gvApplications_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;

                var litApplicantName = (Literal)e.Row.FindControl("litApplicantName");
                litApplicantName.Text = row["FullName"].ToString();

                var litAppliedDate = (Literal)e.Row.FindControl("litAppliedDate");
                litAppliedDate.Text = "Applied " + Convert.ToDateTime(row["ApplicationDate"]).ToString("MMM dd, yyyy");

                var imgApplicant = (Image)e.Row.FindControl("imgApplicant");
                imgApplicant.ImageUrl = row["ProfilePicture"] != DBNull.Value ?
                    row["ProfilePicture"].ToString() :
                    "~/Content/Images/default-user.png";

                var litJobTitle = (Literal)e.Row.FindControl("litJobTitle");
                litJobTitle.Text = row["JobTitle"].ToString();

                var litJobType = (Literal)e.Row.FindControl("litJobType");
                litJobType.Text = row["JobType"].ToString();

                var litStatus = (Literal)e.Row.FindControl("litStatus");
                litStatus.Text = row["Status"].ToString();

                var statusBadge = e.Row.FindControl("status-badge") as HtmlGenericControl;
                if (statusBadge != null)
                {
                    statusBadge.Attributes["class"] += GetStatusBadgeClass(row["Status"].ToString());
                }

                var btnViewResume = (LinkButton)e.Row.FindControl("btnViewResume");
                if (btnViewResume != null)
                {
                    if (row["ResumePath"] != DBNull.Value && !string.IsNullOrEmpty(row["ResumePath"].ToString()))
                    {
                        string resumePath = VirtualPathUtility.ToAbsolute(row["ResumePath"].ToString());
                        btnViewResume.Attributes["onclick"] = $"showResumeModal('{resumePath}'); return false;";
                    }
                    else
                    {
                        btnViewResume.Enabled = false;
                        btnViewResume.ToolTip = "No resume available";
                        btnViewResume.CssClass += " opacity-50 cursor-not-allowed";
                    }
                }

                var btnSendMessage = (LinkButton)e.Row.FindControl("btnSendMessage");
                if (btnSendMessage != null && row["UserId"] != DBNull.Value)
                {
                    btnSendMessage.CommandArgument = $"{row["ApplicationId"]}|{row["UserId"]}";
                }
            }
        }

        protected string GetStatusIcon(string status)
        {
            switch (status?.ToLower())
            {
                case "pending":
                    return "fas fa-clock";
                case "reviewed":
                    return "fas fa-eye";
                case "interview":
                    return "fas fa-calendar-alt";
                case "rejected":
                    return "fas fa-times-circle";
                case "hired":
                    return "fas fa-check-circle";
                default:
                    return "fas fa-question-circle";
            }
        }

        private string GetStatusBadgeClass(string status)
        {
            switch (status?.ToLower())
            {
                case "pending":
                    return " bg-yellow-100 dark:bg-yellow-900 text-yellow-800 dark:text-yellow-200";
                case "reviewed":
                    return " bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200";
                case "interview":
                    return " bg-purple-100 dark:bg-purple-900 text-purple-800 dark:text-purple-200";
                case "rejected":
                    return " bg-red-100 dark:bg-red-900 text-red-800 dark:text-red-200";
                case "hired":
                    return " bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-200";
                default:
                    return " bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200";
            }
        }

        protected void ddlStatusActions_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            string newStatus = ddl.SelectedValue;
            string applicationId = ddl.Attributes["data-application-id"];

            if (!string.IsNullOrEmpty(newStatus))
            {
                UpdateApplicationStatus(applicationId, newStatus);
                ddl.SelectedIndex = 0;
                BindApplications();
            }
        }

        private void UpdateApplicationStatus(string applicationId, string newStatus)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "UPDATE Applications SET Status = @Status WHERE ApplicationId = @ApplicationId";

                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Status", newStatus);
                    command.Parameters.AddWithValue("@ApplicationId", applicationId);
                    command.ExecuteNonQuery();
                }
            }
        }

        protected void Filters_Changed(object sender, EventArgs e)
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

        protected void gvApplications_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewResume")
            {
                string applicationId = e.CommandArgument.ToString();
                // Handled by client-side JavaScript
            }
            else if (e.CommandName == "SendMessage")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length == 2)
                {
                    string applicationId = args[0];
                    string userId = args[1];
                    Response.Redirect($"~/CompanySite/Views/SendMessage.aspx?applicationId={applicationId}&userId={userId}");
                }
            }
        }
    }
}