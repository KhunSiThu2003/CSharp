using System;
using System.Data;
using System.Web.UI;

namespace JobBridge.Pages.WebPages
{
    public partial class JobListings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindJobOverview();
            }
        }

        private void BindJobOverview()
        {
            // Sample data - in real app this would come from database
            DataTable dt = new DataTable();
            dt.Columns.Add("JobId", typeof(int));
            dt.Columns.Add("Title", typeof(string));
            dt.Columns.Add("Company", typeof(string));
            dt.Columns.Add("Location", typeof(string));
            dt.Columns.Add("Type", typeof(string));
            dt.Columns.Add("Salary", typeof(string));
            dt.Columns.Add("PostedDate", typeof(DateTime));
            dt.Columns.Add("IsUrgent", typeof(bool));
            dt.Columns.Add("Logo", typeof(string));

            // Add sample jobs
            dt.Rows.Add(101, "Senior Software Engineer", "Tech Innovations", "San Francisco, CA", "Full-time", "$120K - $150K", DateTime.Now.AddDays(-2), true, "https://st3.depositphotos.com/43745012/44906/i/450/depositphotos_449066958-stock-photo-financial-accounting-logo-financial-logo.jpg");
            dt.Rows.Add(102, "Marketing Manager", "Digital Solutions", "Remote", "Full-time", "$90K - $110K", DateTime.Now.AddDays(-5), false, "https://play-lh.googleusercontent.com/rPq4GMCZy12WhwTlanEu7RzxihYCgYevQHVHLNha1VcY5SU1uLKHMd060b4VEV1r-OQ");
            dt.Rows.Add(103, "UX Designer", "Creative Minds", "New York, NY", "Contract", "$45 - $65/hr", DateTime.Now.AddDays(-1), false, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6TfoASGOcXmB9gLuGfRaAyIM6UQXBox0Jgg&s");
            dt.Rows.Add(104, "Data Analyst", "Analytics Pro", "Chicago, IL", "Full-time", "$85K - $100K", DateTime.Now.AddDays(-3), true, "https://img.freepik.com/free-vector/hand-tech-creative-logo-design_474888-2537.jpg?semt=ais_hybrid&w=740");
            dt.Rows.Add(105, "DevOps Engineer", "Cloud Systems", "Remote", "Full-time", "$110K - $130K", DateTime.Now, false, "https://play-lh.googleusercontent.com/ClX9e9CngklZTXkej6GyWXbrdv_5r7AcqcMxcn0tV3doIl7KG2tj2CGyatgrC0qy4sN8=w600-h300-pc0xffffff-pd");

            rptJobs.DataSource = dt;
            rptJobs.DataBind();
        }

        protected string FormatDate(DateTime date)
        {
            TimeSpan span = DateTime.Now - date;
            if (span.Days > 30) return date.ToString("MMM d, yyyy");
            if (span.Days > 1) return $"{span.Days} days ago";
            if (span.Days == 1) return "Yesterday";
            if (span.Hours > 1) return $"{span.Hours} hours ago";
            return "Just posted";
        }
    }
}