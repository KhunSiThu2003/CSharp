using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobBridge.Pages.WebPages
{
    public partial class AboutUsPage : System.Web.UI.Page
    {

            protected void Page_Load(object sender, EventArgs e)
            {
                if (!IsPostBack)
                {
                    BindMilestones();
                    BindTestimonials();
                }
            }


            private void BindMilestones()
            {
                // Sample data - in real app this would come from database
                DataTable dt = new DataTable();
                dt.Columns.Add("Year", typeof(int));
                dt.Columns.Add("Title", typeof(string));
                dt.Columns.Add("Description", typeof(string));

                dt.Rows.Add(2018, "Founded", "JobBridge was launched with a vision to transform hiring");
                dt.Rows.Add(2019, "First Major Client", "Secured TechCorp as our first enterprise customer");
                dt.Rows.Add(2020, "AI Matching Engine", "Launched our proprietary matching algorithm");
                dt.Rows.Add(2021, "10,000 Jobs Posted", "Milestone of 10,000 jobs posted on our platform");
                dt.Rows.Add(2022, "Series B Funding", "Raised $20M to expand our services globally");
                dt.Rows.Add(2023, "Mobile App Launch", "Released our iOS and Android applications");

                rptMilestones.DataSource = dt;
                rptMilestones.DataBind();
            }

            private void BindTestimonials()
            {
                // Sample data - in real app this would come from database
                DataTable dt = new DataTable();
                dt.Columns.Add("Id", typeof(int));
                dt.Columns.Add("Name", typeof(string));
                dt.Columns.Add("Company", typeof(string));
                dt.Columns.Add("Role", typeof(string));
                dt.Columns.Add("Quote", typeof(string));
                dt.Columns.Add("Photo", typeof(string));

                dt.Rows.Add(1, "James Wilson", "InnovateCo", "HR Director",
                    "JobBridge helped us reduce our hiring time by 40% while improving candidate quality.",
                    "https://img.freepik.com/free-photo/horizontal-shot-serious-dissatisfied-male-model-smirks-face-looks-straightly-doubts-he-can-trust-you-wears-spectacles-red-sweater-isolated-pink-wall-feels-intense_273609-42349.jpg?semt=ais_hybrid&w=740");
                dt.Rows.Add(2, "Lisa Thompson", "GrowthMarketing", "Talent Acquisition",
                    "The platform's matching algorithm finds candidates we wouldn't have discovered otherwise.",
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCktwMug7b_gk7QNsU4__iK4EPgd36gl0OFQ&s");
                dt.Rows.Add(3, "Robert Zhang", "CloudSystems", "Engineering Manager",
                    "We've hired 15 engineers through JobBridge - all excellent cultural fits.",
                    "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTA5L3Jhd3BpeGVsX29mZmljZV8zNl9hX3Bob3RvX29mX2FfcG9ydHJhaXRfb2ZfYV9mYXNoaW9uYWJsZV9zbWlsaV8xYmRlMDQwNy01YTE4LTQ4MTItYmNjOS1lZjBhYWVmMTE3NmZfMS5qcGc.jpg");

                rptTestimonials.DataSource = dt;
                rptTestimonials.DataBind();
            }

}
}