using System;
using System.Data;
using System.Web.UI;

namespace JobBridge.Pages.WebPages
{
    public partial class Employers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindFeaturedEmployers();
            }
        }

        private void BindFeaturedEmployers()
        {
            // Sample data - in real app this would come from database
            DataTable dt = new DataTable();
            dt.Columns.Add("EmployerId", typeof(int));
            dt.Columns.Add("CompanyName", typeof(string));
            dt.Columns.Add("Industry", typeof(string));
            dt.Columns.Add("Location", typeof(string));
            dt.Columns.Add("JobCount", typeof(int));
            dt.Columns.Add("Logo", typeof(string));

            // Add sample employers
            dt.Rows.Add(1, "Tech Innovations", "Information Technology", "San Francisco, CA", 12, "https://play-lh.googleusercontent.com/rPq4GMCZy12WhwTlanEu7RzxihYCgYevQHVHLNha1VcY5SU1uLKHMd060b4VEV1r-OQ");
            dt.Rows.Add(2, "Green Solutions", "Environmental Services", "New York, NY", 8, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6TfoASGOcXmB9gLuGfRaAyIM6UQXBox0Jgg&s");
            dt.Rows.Add(3, "Global Finance", "Financial Services", "Chicago, IL", 15, "https://play-lh.googleusercontent.com/sSs5-PJ__TboqURAS0rFAzMMoQzR6cSDYrK65XevRUqCaNdakd9_q4x7-pzAmuIE1w");
            dt.Rows.Add(4, "HealthPlus", "Healthcare", "Boston, MA", 6, "https://img.freepik.com/free-vector/hand-tech-creative-logo-design_474888-2537.jpg?semt=ais_hybrid&w=740");
            dt.Rows.Add(5, "Creative Designs", "Marketing & Advertising", "Austin, TX", 5, "https://st3.depositphotos.com/43745012/44906/i/450/depositphotos_449066958-stock-photo-financial-accounting-logo-financial-logo.jpg");
            dt.Rows.Add(6, "Atom", "Marketing & Advertising", "Remote", 9, "https://play-lh.googleusercontent.com/ClX9e9CngklZTXkej6GyWXbrdv_5r7AcqcMxcn0tV3doIl7KG2tj2CGyatgrC0qy4sN8=w600-h300-pc0xffffff-pd");

            rptFeaturedEmployers.DataSource = dt;
            rptFeaturedEmployers.DataBind();
        }

        protected void btnPostJob_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/WebPages/PostJob.aspx");
        }
    }
}