using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobBridge.Pages.WebPages
{
    public partial class Resources : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCareerResources();
                BindHiringResources();
                BindLatestArticles();
            }
        }

        private void BindCareerResources()
        {
            // Sample data - in real app this would come from database
            DataTable dt = new DataTable();
            dt.Columns.Add("ResourceId", typeof(int));
            dt.Columns.Add("Title", typeof(string));
            dt.Columns.Add("Description", typeof(string));
            dt.Columns.Add("Category", typeof(string));
            dt.Columns.Add("Type", typeof(string));
            dt.Columns.Add("Link", typeof(string));

            dt.Rows.Add(1, "Resume Writing Guide", "Learn how to create a resume that stands out to employers", "Career Development", "Guide", "/resources/resume-guide");
            dt.Rows.Add(2, "Interview Preparation Checklist", "Everything you need to prepare for your next interview", "Interviewing", "Checklist", "/resources/interview-checklist");
            dt.Rows.Add(3, "Salary Negotiation Tips", "How to negotiate your salary with confidence", "Career Development", "Article", "/resources/salary-negotiation");
            dt.Rows.Add(4, "Career Change Webinar", "Recording of our popular career transition workshop", "Career Transition", "Webinar", "/resources/career-change-webinar");

            rptCareerResources.DataSource = dt;
            rptCareerResources.DataBind();
        }

        private void BindHiringResources()
        {
            // Sample data - in real app this would come from database
            DataTable dt = new DataTable();
            dt.Columns.Add("ResourceId", typeof(int));
            dt.Columns.Add("Title", typeof(string));
            dt.Columns.Add("Description", typeof(string));
            dt.Columns.Add("Category", typeof(string));
            dt.Columns.Add("Type", typeof(string));
            dt.Columns.Add("Link", typeof(string));

            dt.Rows.Add(1, "Effective Job Descriptions", "How to write job postings that attract top talent", "Hiring Process", "Guide", "/resources/job-descriptions");
            dt.Rows.Add(2, "Interview Scorecard Template", "Structured interview evaluation template", "Interviewing", "Template", "/resources/interview-scorecard");
            dt.Rows.Add(3, "Diversity Hiring Toolkit", "Resources for building a more inclusive hiring process", "Diversity", "Toolkit", "/resources/diversity-hiring");
            dt.Rows.Add(4, "Remote Hiring Best Practices", "Strategies for effectively hiring remote employees", "Remote Work", "Guide", "/resources/remote-hiring");

            rptHiringResources.DataSource = dt;
            rptHiringResources.DataBind();
        }

        private void BindLatestArticles()
        {
            // Sample data - in real app this would come from database
            DataTable dt = new DataTable();
            dt.Columns.Add("ArticleId", typeof(int));
            dt.Columns.Add("Title", typeof(string));
            dt.Columns.Add("Summary", typeof(string));
            dt.Columns.Add("PublishDate", typeof(DateTime));
            dt.Columns.Add("Author", typeof(string));
            dt.Columns.Add("ReadTime", typeof(string));

            dt.Rows.Add(1, "The Future of Work: 2024 Trends", "Explore the key trends shaping the workplace in 2024 and beyond", DateTime.Now.AddDays(-5), "Sarah Johnson", "5 min");
            dt.Rows.Add(2, "Building a Strong Employer Brand", "How to create an employer brand that attracts top candidates", DateTime.Now.AddDays(-12), "Michael Chen", "7 min");
            dt.Rows.Add(3, "Navigating Career Transitions", "Strategies for successfully changing careers or industries", DateTime.Now.AddDays(-8), "Emily Rodriguez", "6 min");

            rptLatestArticles.DataSource = dt;
            rptLatestArticles.DataBind();
        }

        protected string FormatResourceType(string type)
        {
            switch (type.ToLower())
            {
                case "guide": return "<span class='resource-type guide'>Guide</span>";
                case "checklist": return "<span class='resource-type checklist'>Checklist</span>";
                case "article": return "<span class='resource-type article'>Article</span>";
                case "webinar": return "<span class='resource-type webinar'>Webinar</span>";
                case "template": return "<span class='resource-type template'>Template</span>";
                case "toolkit": return "<span class='resource-type toolkit'>Toolkit</span>";
                default: return $"<span class='resource-type'>{type}</span>";
            }
        }

        protected string FormatDate(DateTime date)
        {
            return date.ToString("MMMM d, yyyy");
        }
    }
}