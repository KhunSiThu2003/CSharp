using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobBridge.Pages.WebPages
{
    public partial class HomePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialization code can go here
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Handle search functionality
            string keywords = txtKeywords.Text.Trim();
            string location = txtLocation.Text.Trim();

            // Redirect to search results page with parameters
            Response.Redirect($"SearchResults.aspx?keywords={Server.UrlEncode(keywords)}&location={Server.UrlEncode(location)}");
        }

        protected void btnPostJob_Click(object sender, EventArgs e)
        {
            // Redirect to job posting page
            Response.Redirect("PostJob.aspx");
        }
    }
}