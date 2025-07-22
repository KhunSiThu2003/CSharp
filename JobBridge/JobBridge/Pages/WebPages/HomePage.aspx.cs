using System;
using System.Web.UI;

namespace JobBridge.Pages.WebPages
{
    public partial class HomePage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        protected void btnPostJob_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/WebPages/PostJob.aspx");
        }

        protected void btnSearchJobs_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/WebPages/JobListings.aspx");
        }
    }
}