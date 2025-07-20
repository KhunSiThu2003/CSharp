using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobBridge.Pages.WebPages
{
    public partial class ContactUsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialization code can go here
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Create and send email
                    MailMessage message = new MailMessage();
                    message.From = new MailAddress(txtEmail.Text);
                    message.To.Add("info@jobbridge.com");
                    message.Subject = $"Contact Form: {ddlSubject.SelectedValue}";
                    message.Body = $"Name: {txtName.Text}\nEmail: {txtEmail.Text}\nSubject: {ddlSubject.SelectedValue}\nMessage:\n{txtMessage.Text}";

                    SmtpClient smtp = new SmtpClient();
                    smtp.Send(message);

                    // Show success message
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Your message has been sent successfully!');", true);

                    // Clear form
                    txtName.Text = "";
                    txtEmail.Text = "";
                    ddlSubject.SelectedIndex = 0;
                    txtMessage.Text = "";
                }
                catch (Exception ex)
                {
                    // Show error message
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error sending message: {ex.Message}');", true);
                }
            }
        }
    }
}