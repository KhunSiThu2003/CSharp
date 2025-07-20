<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master" AutoEventWireup="true" CodeBehind="ContactUsPage.aspx.cs" Inherits="JobBridge.Pages.WebPages.ContactUsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="bg-blue-600 text-white py-20">
        <div class="container mx-auto px-6 text-center">
            <h1 class="text-4xl font-bold mb-6">Contact Us</h1>
            <p class="text-xl mb-8">We'd love to hear from you! Get in touch with our team.</p>
        </div>
    </section>

    <!-- Contact Form and Info -->
    <section class="py-16 bg-white">
        <div class="container mx-auto px-6">
            <div class="flex flex-col lg:flex-row gap-12">
                <!-- Contact Form -->
                <div class="lg:w-1/2">
                    <h2 class="text-3xl font-bold mb-6">Send Us a Message</h2>
                    <div class="space-y-4">
                        <div>
                            <label for="txtName" class="block text-gray-700 font-medium mb-2">Your Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="w-full p-3 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"></asp:TextBox>
                        </div>
                        <div>
                            <label for="txtEmail" class="block text-gray-700 font-medium mb-2">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="w-full p-3 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"></asp:TextBox>
                        </div>
                        <div>
                            <label for="ddlSubject" class="block text-gray-700 font-medium mb-2">Subject</label>
                            <asp:DropDownList ID="ddlSubject" runat="server" CssClass="w-full p-3 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500">
                                <asp:ListItem Text="General Inquiry" Value="General"></asp:ListItem>
                                <asp:ListItem Text="Job Seeker Support" Value="JobSeeker"></asp:ListItem>
                                <asp:ListItem Text="Employer Support" Value="Employer"></asp:ListItem>
                                <asp:ListItem Text="Technical Support" Value="Technical"></asp:ListItem>
                                <asp:ListItem Text="Feedback" Value="Feedback"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <label for="txtMessage" class="block text-gray-700 font-medium mb-2">Message</label>
                            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="w-full p-3 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"></asp:TextBox>
                        </div>
                        <div>
                            <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded transition duration-300" />
                        </div>
                    </div>
                </div>

                <!-- Contact Info -->
                <div class="lg:w-1/2">
                    <h2 class="text-3xl font-bold mb-6">Contact Information</h2>
                    <div class="space-y-6">
                        <div class="flex items-start space-x-4">
                            <div class="text-blue-600 mt-1">
                                <i class="fas fa-map-marker-alt text-2xl"></i>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold mb-2">Our Office</h3>
                                <p class="text-gray-600">123 JobBridge Avenue<br>San Francisco, CA 94107<br>United States</p>
                            </div>
                        </div>
                        <div class="flex items-start space-x-4">
                            <div class="text-blue-600 mt-1">
                                <i class="fas fa-phone-alt text-2xl"></i>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold mb-2">Phone</h3>
                                <p class="text-gray-600">+1 (555) 123-4567<br>Mon-Fri, 9am-5pm PST</p>
                            </div>
                        </div>
                        <div class="flex items-start space-x-4">
                            <div class="text-blue-600 mt-1">
                                <i class="fas fa-envelope text-2xl"></i>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold mb-2">Email</h3>
                                <p class="text-gray-600">info@jobbridge.com<br>support@jobbridge.com</p>
                            </div>
                        </div>
                    </div>

                    <!-- Social Media -->
                    <div class="mt-8">
                        <h3 class="text-xl font-semibold mb-4">Follow Us</h3>
                        <div class="flex space-x-4">
                            <a href="#" class="text-blue-600 hover:text-blue-800 text-2xl"><i class="fab fa-facebook"></i></a>
                            <a href="#" class="text-blue-600 hover:text-blue-800 text-2xl"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="text-blue-600 hover:text-blue-800 text-2xl"><i class="fab fa-linkedin"></i></a>
                            <a href="#" class="text-blue-600 hover:text-blue-800 text-2xl"><i class="fab fa-instagram"></i></a>
                        </div>
                    </div>

                    <!-- Map -->
                    <div class="mt-8">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3153.158560488211!2d-122.4194!3d37.7749!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMzfCsDQ2JzI5LjYiTiAxMjLCsDI1JzA5LjkiVw!5e0!3m2!1sen!2sus!4v1620000000000!5m2!1sen!2sus" width="100%" height="300" style="border:0;" allowfullscreen="" loading="lazy" class="rounded-lg shadow-md"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section class="py-16 bg-gray-50">
        <div class="container mx-auto px-6">
            <h2 class="text-3xl font-bold text-center mb-12">Frequently Asked Questions</h2>
            <div class="max-w-3xl mx-auto space-y-4">
                <div class="bg-white p-6 rounded-lg shadow-md">
                    <h3 class="text-xl font-semibold mb-2">How do I create an account?</h3>
                    <p class="text-gray-600">Click on the "Register" button in the top right corner of the page and follow the instructions to create your account as either a job seeker or employer.</p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md">
                    <h3 class="text-xl font-semibold mb-2">Is there a fee to post jobs?</h3>
                    <p class="text-gray-600">We offer both free and premium job posting options. Basic listings are free, while featured jobs with more visibility require a small fee.</p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md">
                    <h3 class="text-xl font-semibold mb-2">How can I improve my job application?</h3>
                    <p class="text-gray-600">Make sure your profile is complete, upload a well-written resume, and tailor your application to each specific job you apply for.</p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md">
                    <h3 class="text-xl font-semibold mb-2">What industries do you serve?</h3>
                    <p class="text-gray-600">JobBridge serves all industries including technology, healthcare, finance, education, marketing, and many more.</p>
                </div>
            </div>
        </div>
    </section>
</asp:Content>