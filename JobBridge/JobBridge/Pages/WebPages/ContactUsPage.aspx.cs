using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace JobBridge.Pages.WebPages
{
    public partial class ContactUsPage : System.Web.UI.Page
    {
            protected void Page_Load(object sender, EventArgs e)
            {
                if (!IsPostBack)
                {
                    InitializeForm();
                }
            }

            private void InitializeForm()
            {
                // Initialize dropdown values
                ddlContactReason.Items.Add(new ListItem("Select a reason", ""));
                ddlContactReason.Items.Add(new ListItem("General Inquiry", "general"));
                ddlContactReason.Items.Add(new ListItem("Support Request", "support"));
                ddlContactReason.Items.Add(new ListItem("Partnership Opportunity", "partnership"));
                ddlContactReason.Items.Add(new ListItem("Press Inquiry", "press"));
                ddlContactReason.Items.Add(new ListItem("Feedback", "feedback"));
                ddlContactReason.Items.Add(new ListItem("Other", "other"));
            }

            protected void btnSubmit_Click(object sender, EventArgs e)
            {
                if (Page.IsValid)
                {
                    try
                    {
                        SendContactEmail();
                        ShowSuccessMessage();
                        ClearForm();
                    }
                    catch (Exception ex)
                    {
                        ShowErrorMessage(ex.Message);
                    }
                }
            }

            private void SendContactEmail()
            {
                // Configure and send email
                MailMessage message = new MailMessage();
                message.From = new MailAddress("noreply@jobbridge.com");
                message.To.Add("contact@jobbridge.com");
                message.Subject = $"New Contact Form Submission: {ddlContactReason.SelectedItem.Text}";

                message.Body = $@"
                <h2>New Contact Form Submission</h2>
                <p><strong>Name:</strong> {txtName.Text}</p>
                <p><strong>Email:</strong> {txtEmail.Text}</p>
                <p><strong>Phone:</strong> {txtPhone.Text}</p>
                <p><strong>Reason:</strong> {ddlContactReason.SelectedItem.Text}</p>
                <p><strong>Message:</strong></p>
                <p>{txtMessage.Text}</p>
            ";

                message.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.yourserver.com"; // Configure in web.config
                smtp.Port = 587;
                smtp.EnableSsl = true;
                smtp.Credentials = new System.Net.NetworkCredential("yourusername", "yourpassword");

                smtp.Send(message);
            }

        protected void btnTryAgain_Click(object sender, EventArgs e)
        {
            // Reset the form and show it again
            pnlError.Visible = false;
            pnlForm.Visible = true;
            pnlSuccess.Visible = false;
        }

        private void ShowSuccessMessage()
            {
                pnlSuccess.Visible = true;
                pnlError.Visible = false;
                pnlForm.Visible = false;
            }

            private void ShowErrorMessage(string message)
            {
                litErrorMessage.Text = message;
                pnlError.Visible = true;
                pnlSuccess.Visible = false;
            }

            private void ClearForm()
            {
                txtName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = "";
                ddlContactReason.SelectedIndex = 0;
                txtMessage.Text = "";
            }
        }

}