<%@ Page Title="Job Overview" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master" 
    AutoEventWireup="true" CodeBehind="JobListings.aspx.cs" Inherits="JobBridge.Pages.WebPages.JobListings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .job-card {
            transition: all 0.3s ease;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }
        .job-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        .urgent-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background-color: #f59e0b;
            color: white;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.5rem;
            border-radius: 9999px;
        }
        .job-type {
            font-size: 0.875rem;
            color: #4f46e5;
            font-weight: 500;
        }
        .company-logo {
            width: 60px;
            height: 60px;
            object-fit: contain;
            border-radius: 8px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="bg-gray-50 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-3xl font-bold text-gray-900 mb-4">Current Job Openings</h1>
            <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                Browse our latest job opportunities across various industries and locations
            </p>
        </div>
    </section>

    <!-- Job Overview Section -->
    <section class="py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                <asp:Repeater ID="rptJobs" runat="server">
                    <ItemTemplate>
                        <div class="job-card bg-white relative">
                            <!-- Urgent badge -->
                            <%# (bool)Eval("IsUrgent") ? 
                                "<div class=\"urgent-badge\">Urgent</div>" : "" %>
                            
                            <div class="p-6">
                                <div class="flex items-start space-x-4">
                                    <!-- Company Logo -->
                                    <div class="flex-shrink-0">
                                        <img src='<%# Eval("Logo").ToString() %>' 
                                            alt='<%# Eval("Company") %>' class="company-logo" />
                                    </div>
                                    
                                    <!-- Job Details -->
                                    <div class="flex-1">
                                        <h3 class="text-lg font-bold text-gray-900 mb-1">
                                            <a href='/Pages/WebPages/JobDetails.aspx?id=<%# Eval("JobId") %>' class="hover:text-primary">
                                                <%# Eval("Title") %>
                                            </a>
                                        </h3>
                                        <p class="text-gray-600 mb-2"><%# Eval("Company") %></p>
                                        
                                        <div class="flex items-center space-x-4 mb-3">
                                            <span class="text-gray-500 text-sm">
                                                <i class="fas fa-map-marker-alt mr-1"></i>
                                                <%# Eval("Location") %>
                                            </span>
                                            <span class="job-type">
                                                <%# Eval("Type") %>
                                            </span>
                                        </div>
                                        
                                        <div class="flex justify-between items-center">
                                            <span class="text-gray-900 font-medium">
                                                <%# Eval("Salary") %>
                                            </span>
                                            <span class="text-sm text-gray-500">
                                                <%# FormatDate((DateTime)Eval("PostedDate")) %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            
            <!-- View All Button -->
            <div class="mt-12 text-center">
                <a href="/Pages/WebPages/AdvancedJobSearch.aspx" 
                    class="btn btn-primary text-white px-8 py-3 rounded-lg text-lg font-semibold">
                    View All Job Opportunities
                </a>
            </div>
        </div>
    </section>

    <!-- Benefits Section -->
    <section class="bg-gray-50 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12">
                <h2 class="text-2xl font-bold text-gray-900 mb-4">Why Apply Through JobBridge?</h2>
                <p class="text-gray-600 max-w-3xl mx-auto">We connect you with the best opportunities and provide support throughout your job search</p>
            </div>
            
            <div class="grid md:grid-cols-3 gap-8">
                <div class="bg-white p-6 rounded-lg text-center">
                    <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-briefcase text-primary text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Quality Opportunities</h3>
                    <p class="text-gray-600">We carefully vet all employers to ensure legitimate, high-quality job openings</p>
                </div>
                
                <div class="bg-white p-6 rounded-lg text-center">
                    <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-lock text-primary text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Secure Process</h3>
                    <p class="text-gray-600">Your personal information is protected throughout the application process</p>
                </div>
                
                <div class="bg-white p-6 rounded-lg text-center">
                    <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-user-tie text-primary text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Career Support</h3>
                    <p class="text-gray-600">Get resume tips and interview preparation resources</p>
                </div>
            </div>
        </div>
    </section>
</asp:Content>