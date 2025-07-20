<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="JobBridge.Pages.WebPages.HomePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="bg-blue-600 text-white py-20">
        <div class="container mx-auto px-6 text-center">
            <h1 class="text-4xl font-bold mb-6">Find Your Dream Job Today</h1>
            <p class="text-xl mb-8">Thousands of jobs waiting for you. Search, apply, and get hired.</p>
            
            <!-- Search Form -->
            <div class="max-w-3xl mx-auto bg-white rounded-lg shadow-lg p-4">
                <div class="flex flex-col md:flex-row gap-4">
                    <div class="flex-1">
                        <asp:TextBox ID="txtKeywords" runat="server" CssClass="w-full p-3 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-800" placeholder="Job title, keywords, or company"></asp:TextBox>
                    </div>
                    <div class="flex-1">
                        <asp:TextBox ID="txtLocation" runat="server" CssClass="w-full p-3 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-800" placeholder="City, state, or remote"></asp:TextBox>
                    </div>
                    <div>
                        <asp:Button ID="btnSearch" runat="server" Text="Search Jobs" CssClass="w-full md:w-auto bg-blue-700 hover:bg-blue-800 text-white font-bold py-3 px-6 rounded transition duration-300" />
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="py-16 bg-white">
        <div class="container mx-auto px-6">
            <h2 class="text-3xl font-bold text-center mb-12">Browse by Category</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="bg-gray-100 p-6 rounded-lg hover:shadow-lg transition duration-300">
                    <div class="text-blue-600 mb-4">
                        <i class="fas fa-code text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Technology</h3>
                    <p class="text-gray-600">500+ jobs available</p>
                </div>
                <div class="bg-gray-100 p-6 rounded-lg hover:shadow-lg transition duration-300">
                    <div class="text-blue-600 mb-4">
                        <i class="fas fa-briefcase-medical text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Healthcare</h3>
                    <p class="text-gray-600">300+ jobs available</p>
                </div>
                <div class="bg-gray-100 p-6 rounded-lg hover:shadow-lg transition duration-300">
                    <div class="text-blue-600 mb-4">
                        <i class="fas fa-chart-line text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Finance</h3>
                    <p class="text-gray-600">250+ jobs available</p>
                </div>
                <div class="bg-gray-100 p-6 rounded-lg hover:shadow-lg transition duration-300">
                    <div class="text-blue-600 mb-4">
                        <i class="fas fa-graduation-cap text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Education</h3>
                    <p class="text-gray-600">180+ jobs available</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Jobs -->
    <section class="py-16 bg-gray-50">
        <div class="container mx-auto px-6">
            <h2 class="text-3xl font-bold text-center mb-12">Featured Jobs</h2>
            <div class="space-y-6">
                <!-- Job Listing 1 -->
                <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition duration-300">
                    <div class="flex flex-col md:flex-row md:items-center justify-between">
                        <div class="flex items-start space-x-4">
                            <img src="https://via.placeholder.com/60" alt="Company Logo" class="w-16 h-16 object-contain">
                            <div>
                                <h3 class="text-xl font-semibold">Senior Software Engineer</h3>
                                <div class="flex flex-wrap items-center gap-2 mt-2">
                                    <span class="text-gray-600"><i class="fas fa-building"></i> TechCorp Inc.</span>
                                    <span class="text-gray-600"><i class="fas fa-map-marker-alt"></i> San Francisco, CA (Remote)</span>
                                    <span class="text-gray-600"><i class="fas fa-dollar-sign"></i> $120,000 - $150,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 md:mt-0">
                            <asp:Button ID="btnApply1" runat="server" Text="Apply Now" CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded transition duration-300" />
                        </div>
                    </div>
                </div>

                <!-- Job Listing 2 -->
                <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition duration-300">
                    <div class="flex flex-col md:flex-row md:items-center justify-between">
                        <div class="flex items-start space-x-4">
                            <img src="https://via.placeholder.com/60" alt="Company Logo" class="w-16 h-16 object-contain">
                            <div>
                                <h3 class="text-xl font-semibold">Marketing Manager</h3>
                                <div class="flex flex-wrap items-center gap-2 mt-2">
                                    <span class="text-gray-600"><i class="fas fa-building"></i> BrandVision</span>
                                    <span class="text-gray-600"><i class="fas fa-map-marker-alt"></i> New York, NY</span>
                                    <span class="text-gray-600"><i class="fas fa-dollar-sign"></i> $90,000 - $110,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 md:mt-0">
                            <asp:Button ID="btnApply2" runat="server" Text="Apply Now" CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded transition duration-300" />
                        </div>
                    </div>
                </div>

                <!-- Job Listing 3 -->
                <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition duration-300">
                    <div class="flex flex-col md:flex-row md:items-center justify-between">
                        <div class="flex items-start space-x-4">
                            <img src="https://via.placeholder.com/60" alt="Company Logo" class="w-16 h-16 object-contain">
                            <div>
                                <h3 class="text-xl font-semibold">Data Scientist</h3>
                                <div class="flex flex-wrap items-center gap-2 mt-2">
                                    <span class="text-gray-600"><i class="fas fa-building"></i> DataAnalytics Co.</span>
                                    <span class="text-gray-600"><i class="fas fa-map-marker-alt"></i> Boston, MA (Hybrid)</span>
                                    <span class="text-gray-600"><i class="fas fa-dollar-sign"></i> $130,000 - $160,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 md:mt-0">
                            <asp:Button ID="btnApply3" runat="server" Text="Apply Now" CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded transition duration-300" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-center mt-8">
                <asp:Button ID="btnViewAllJobs" runat="server" Text="View All Jobs" CssClass="bg-white border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white font-bold py-2 px-6 rounded transition duration-300" />
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="py-16 bg-blue-700 text-white">
        <div class="container mx-auto px-6 text-center">
            <h2 class="text-3xl font-bold mb-6">Are You Hiring?</h2>
            <p class="text-xl mb-8 max-w-2xl mx-auto">Post your job openings and find the perfect candidate for your company.</p>
            <asp:Button ID="btnPostJob" runat="server" Text="Post a Job" CssClass="bg-white text-blue-700 hover:bg-gray-100 font-bold py-3 px-8 rounded-lg text-lg transition duration-300" />
        </div>
    </section>
</asp:Content>