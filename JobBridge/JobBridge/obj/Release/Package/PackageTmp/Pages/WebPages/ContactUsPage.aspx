<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master"
    AutoEventWireup="true" CodeBehind="ContactUsPage.aspx.cs" Inherits="JobBridge.Pages.WebPages.ContactUsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .contact-info-card {
            transition: all 0.3s ease;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
        }

            .contact-info-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            }

        .contact-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.1) 0%, rgba(99, 102, 241, 0.1) 100%);
            border-radius: 12px;
        }

        .form-control {
            transition: all 0.3s ease;
            border: 1px solid #e5e7eb;
        }

            .form-control:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }

        .map-container {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="bg-primary py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-4xl font-bold mb-6">Get In Touch</h1>
            <p class="text-xl mb-8 max-w-3xl mx-auto">
                We'd love to hear from you! Reach out with questions, feedback, or partnership opportunities.
            </p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid lg:grid-cols-2 gap-12">
            <!-- Contact Information -->
            <div>
                <h2 class="text-2xl font-bold text-gray-900 mb-8">Contact Information</h2>

                <div class="grid md:grid-cols-2 gap-6 mb-12">
                    <div class="contact-info-card bg-white p-6">
                        <div class="contact-icon mb-4">
                            <i class="fas fa-map-marker-alt text-primary text-xl"></i>
                        </div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Our Office</h3>
                        <p class="text-gray-600">
                            123 Tech Park Drive<br>
                            San Francisco, CA 94107<br>
                            United States
                        </p>
                    </div>

                    <div class="contact-info-card bg-white p-6">
                        <div class="contact-icon mb-4">
                            <i class="fas fa-phone-alt text-primary text-xl"></i>
                        </div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Phone</h3>
                        <p class="text-gray-600">
                            <a href="tel:+18005551234" class="hover:text-primary">+1 (800) 555-1234</a><br>
                            Mon-Fri, 9am-5pm PST
                        </p>
                    </div>

                    <div class="contact-info-card bg-white p-6">
                        <div class="contact-icon mb-4">
                            <i class="fas fa-envelope text-primary text-xl"></i>
                        </div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Email</h3>
                        <p class="text-gray-600">
                            <a href="mailto:info@jobbridge.com" class="hover:text-primary">info@jobbridge.com</a><br>
                            <a href="mailto:support@jobbridge.com" class="hover:text-primary">support@jobbridge.com</a>
                        </p>
                    </div>

                    <div class="contact-info-card bg-white p-6">
                        <div class="contact-icon mb-4">
                            <i class="fas fa-headset text-primary text-xl"></i>
                        </div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Support</h3>
                        <p class="text-gray-600">
                            <a href="/Pages/WebPages/HelpCenter.aspx" class="hover:text-primary">Help Center</a><br>
                            <a href="/Pages/WebPages/FAQs.aspx" class="hover:text-primary">FAQs</a>
                        </p>
                    </div>
                </div>

                <!-- Map -->
                <div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">Find Us</h3>
                    <div class="map-container">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3153.325538058162!2d-122.40334192433162!3d37.78391897189027!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8085807f10f5a0a9%3A0x5a7e5b2a3a3e3b1a!2sTech%20Park!5e0!3m2!1sen!2sus!4v1620000000000!5m2!1sen!2sus"
                            width="100%" height="300" style="border: 0;" allowfullscreen="" loading="lazy">
                        </iframe>
                    </div>
                </div>

            </div>

            <!-- Contact Form -->
            <div>
                <asp:Panel ID="pnlForm" runat="server">
                    <h2 class="text-2xl font-bold text-gray-900 mb-8">Send Us a Message</h2>

                    <div class="space-y-6">
                        <!-- Name -->
                        <div>
                            <label for="txtName" class="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
                            <asp:TextBox ID="txtName" runat="server"
                                CssClass="form-control w-full px-4 py-3 rounded-lg"
                                placeholder="Your name" required></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server"
                                ControlToValidate="txtName" ErrorMessage="Please enter your name"
                                CssClass="text-red-500 text-sm" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Email -->
                        <div>
                            <label for="txtEmail" class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                                CssClass="form-control w-full px-4 py-3 rounded-lg"
                                placeholder="your.email@example.com" required></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail" ErrorMessage="Please enter your email"
                                CssClass="text-red-500 text-sm" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                ControlToValidate="txtEmail" ErrorMessage="Please enter a valid email address"
                                ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                                CssClass="text-red-500 text-sm" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>

                        <!-- Phone -->
                        <div>
                            <label for="txtPhone" class="block text-sm font-medium text-gray-700 mb-1">Phone Number
                                (Optional)</label>
                            <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone"
                                CssClass="form-control w-full px-4 py-3 rounded-lg"
                                placeholder="(123) 456-7890"></asp:TextBox>
                        </div>

                        <!-- Contact Reason -->
                        <div>
                            <label for="ddlContactReason" class="block text-sm font-medium text-gray-700 mb-1">Reason
                                for Contact</label>
                            <asp:DropDownList ID="ddlContactReason" runat="server"
                                CssClass="form-control w-full px-4 py-3 rounded-lg">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvContactReason" runat="server"
                                ControlToValidate="ddlContactReason" InitialValue=""
                                ErrorMessage="Please select a reason for contact"
                                CssClass="text-red-500 text-sm" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Message -->
                        <div>
                            <label for="txtMessage" class="block text-sm font-medium text-gray-700 mb-1">Message</label>
                            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5"
                                CssClass="form-control w-full px-4 py-3 rounded-lg"
                                placeholder="Your message here..." required></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                                ControlToValidate="txtMessage" ErrorMessage="Please enter your message"
                                CssClass="text-red-500 text-sm" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Submit Button -->
                        <div>
                            <asp:Button ID="btnSubmit" runat="server" Text="Send Message"
                                OnClick="btnSubmit_Click"
                                CssClass="btn btn-primary text-white px-8 py-3 rounded-lg text-lg font-semibold" />
                        </div>
                    </div>
                </asp:Panel>

                <!-- Social Media -->
                <div class="mt-12">
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">Connect With Us</h3>
                    <div class="flex space-x-4">
                        <a href="#" class="text-gray-500 hover:text-primary transition">
                            <i class="fab fa-linkedin-in text-2xl"></i>
                        </a>
                        <a href="#" class="text-gray-500 hover:text-primary transition">
                            <i class="fab fa-twitter text-2xl"></i>
                        </a>
                        <a href="#" class="text-gray-500 hover:text-primary transition">
                            <i class="fab fa-facebook-f text-2xl"></i>
                        </a>
                        <a href="#" class="text-gray-500 hover:text-primary transition">
                            <i class="fab fa-instagram text-2xl"></i>
                        </a>
                    </div>
                </div>

                <!-- Success Message -->
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="text-center py-12">
                    <div class="mx-auto max-w-md">
                        <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-check text-green-500 text-2xl"></i>
                        </div>
                        <h3 class="text-2xl font-bold text-gray-900 mb-4">Message Sent Successfully!</h3>
                        <p class="text-gray-600 mb-6">
                            Thank you for contacting us. We've received your message and will respond within
                            24-48 hours.
                        </p>
                        <a href="/Pages/WebPages/HomePage.aspx" class="btn btn-primary">Return to Homepage
                        </a>
                    </div>
                </asp:Panel>

                <!-- Error Message -->
                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="bg-red-50 p-6 rounded-lg mb-8">
                    <div class="flex items-center">
                        <div class="flex-shrink-0">
                            <i class="fas fa-exclamation-circle text-red-500 text-xl"></i>
                        </div>
                        <div class="ml-3">
                            <h3 class="text-sm font-medium text-red-800">There was an error submitting your message
                            </h3>
                            <div class="mt-2 text-sm text-red-700">
                                <asp:Literal ID="litErrorMessage" runat="server"></asp:Literal>
                            </div>
                            <div class="mt-4">
                                <asp:Button ID="btnTryAgain" runat="server" Text="Try Again"
                                    OnClick="btnTryAgain_Click"
                                    CssClass="btn btn-secondary" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
