<%@ Page Title="About Us" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master" AutoEventWireup="true" CodeBehind="AboutUsPage.aspx.cs" Inherits="JobBridge.Pages.WebPages.AboutUsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="bg-blue-600 text-white py-20">
        <div class="container mx-auto px-6 text-center">
            <h1 class="text-4xl font-bold mb-6">About JobBridge</h1>
            <p class="text-xl mb-8">Connecting talent with opportunity since 2023</p>
        </div>
    </section>

    <!-- Our Story -->
    <section class="py-16 bg-white">
        <div class="container mx-auto px-6">
            <div class="flex flex-col md:flex-row items-center">
                <div class="md:w-1/2 mb-8 md:mb-0 md:pr-8">
                    <h2 class="text-3xl font-bold mb-6">Our Story</h2>
                    <p class="text-gray-700 mb-4">Founded in 2023, JobBridge was created with a simple mission: to make the job search process easier and more efficient for both job seekers and employers.</p>
                    <p class="text-gray-700 mb-4">We recognized the challenges in the current job market - qualified candidates struggling to find the right opportunities and companies spending too much time and resources on hiring.</p>
                    <p class="text-gray-700">JobBridge was designed to bridge this gap with innovative technology and a user-friendly platform that benefits both sides of the employment equation.</p>
                </div>
                <div class="md:w-1/2">
                    <img src="https://via.placeholder.com/600x400" alt="Our Team" class="rounded-lg shadow-lg w-full">
                </div>
            </div>
        </div>
    </section>

    <!-- Our Mission -->
    <section class="py-16 bg-gray-50">
        <div class="container mx-auto px-6">
            <div class="flex flex-col md:flex-row items-center">
                <div class="md:w-1/2 mb-8 md:mb-0 md:order-last md:pl-8">
                    <h2 class="text-3xl font-bold mb-6">Our Mission</h2>
                    <p class="text-gray-700 mb-4">To revolutionize the hiring process by creating meaningful connections between talented professionals and forward-thinking companies.</p>
                    <p class="text-gray-700">We believe that everyone deserves to find work they're passionate about, and every company deserves to find employees who will help them grow.</p>
                </div>
                <div class="md:w-1/2 md:order-first">
                    <img src="https://via.placeholder.com/600x400" alt="Our Mission" class="rounded-lg shadow-lg w-full">
                </div>
            </div>
        </div>
    </section>

    <!-- Our Team -->
    <section class="py-16 bg-white">
        <div class="container mx-auto px-6">
            <h2 class="text-3xl font-bold text-center mb-12">Meet Our Team</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                <div class="bg-white p-6 rounded-lg shadow-md text-center">
                    <img src="https://via.placeholder.com/150" alt="Team Member" class="w-32 h-32 rounded-full mx-auto mb-4">
                    <h3 class="text-xl font-semibold mb-2">John Smith</h3>
                    <p class="text-blue-600 mb-2">CEO & Founder</p>
                    <p class="text-gray-600">Visionary leader with 15+ years in HR tech</p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md text-center">
                    <img src="https://via.placeholder.com/150" alt="Team Member" class="w-32 h-32 rounded-full mx-auto mb-4">
                    <h3 class="text-xl font-semibold mb-2">Sarah Johnson</h3>
                    <p class="text-blue-600 mb-2">CTO</p>
                    <p class="text-gray-600">Tech expert building our innovative platform</p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md text-center">
                    <img src="https://via.placeholder.com/150" alt="Team Member" class="w-32 h-32 rounded-full mx-auto mb-4">
                    <h3 class="text-xl font-semibold mb-2">Michael Chen</h3>
                    <p class="text-blue-600 mb-2">Head of Product</p>
                    <p class="text-gray-600">Ensuring our product meets user needs</p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md text-center">
                    <img src="https://via.placeholder.com/150" alt="Team Member" class="w-32 h-32 rounded-full mx-auto mb-4">
                    <h3 class="text-xl font-semibold mb-2">Emily Wilson</h3>
                    <p class="text-blue-600 mb-2">Marketing Director</p>
                    <p class="text-gray-600">Connecting JobBridge with the world</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats -->
    <section class="py-16 bg-blue-700 text-white">
        <div class="container mx-auto px-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
                <div class="p-6">
                    <h3 class="text-5xl font-bold mb-2">10,000+</h3>
                    <p class="text-xl">Jobs Posted</p>
                </div>
                <div class="p-6">
                    <h3 class="text-5xl font-bold mb-2">5,000+</h3>
                    <p class="text-xl">Companies</p>
                </div>
                <div class="p-6">
                    <h3 class="text-5xl font-bold mb-2">50,000+</h3>
                    <p class="text-xl">Job Seekers</p>
                </div>
            </div>
        </div>
    </section>
</asp:Content>