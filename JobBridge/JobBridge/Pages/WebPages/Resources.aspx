<%@ Page Title="Resources" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master" 
    AutoEventWireup="true" CodeBehind="Resources.aspx.cs" Inherits="JobBridge.Pages.WebPages.Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .resource-card {
            transition: all 0.3s ease;
            border-radius: 12px;
            overflow: hidden;
        }
        .resource-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        .resource-type {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            display: inline-block;
        }
        .resource-type.guide {
            background-color: #EFF6FF;
            color: #3B82F6;
        }
        .resource-type.checklist {
            background-color: #ECFDF5;
            color: #10B981;
        }
        .resource-type.article {
            background-color: #FEF2F2;
            color: #EF4444;
        }
        .resource-type.webinar {
            background-color: #F5F3FF;
            color: #8B5CF6;
        }
        .resource-type.template {
            background-color: #FFFBEB;
            color: #F59E0B;
        }
        .resource-type.toolkit {
            background-color: #F0FDF4;
            color: #22C55E;
        }
        .category-tab {
            transition: all 0.2s ease;
        }
        .category-tab.active {
            background-color: #4F46E5;
            color: white;
        }
        .category-tab:not(.active):hover {
            background-color: #EEF2FF;
        }
        .article-card {
            border-left: 4px solid #4F46E5;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="bg-primary text-white py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-4xl font-bold mb-6">Career Resources & Insights</h1>
            <p class="text-xl mb-8 max-w-3xl mx-auto">
                Expert advice and tools to help you succeed in your career or hiring process
            </p>
            <div class="max-w-md mx-auto relative">
                <asp:TextBox ID="txtSearchResources" runat="server" 
                    CssClass="w-full px-5 py-3 rounded-lg border-0 focus:ring-2 focus:ring-white" 
                    placeholder="Search resources..."></asp:TextBox>
                <button type="submit" class="absolute right-3 top-3 text-gray-400 hover:text-white">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>
    </section>

    <!-- Resource Categories -->
    <section class="py-8 bg-white sticky top-16 z-10 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex overflow-x-auto pb-2 -mx-2">
                <button class="category-tab active px-4 py-2 mx-2 rounded-lg font-medium whitespace-nowrap">
                    All Resources
                </button>
                <button class="category-tab px-4 py-2 mx-2 rounded-lg font-medium whitespace-nowrap">
                    Career Development
                </button>
                <button class="category-tab px-4 py-2 mx-2 rounded-lg font-medium whitespace-nowrap">
                    Interviewing
                </button>
                <button class="category-tab px-4 py-2 mx-2 rounded-lg font-medium whitespace-nowrap">
                    Hiring Process
                </button>
                <button class="category-tab px-4 py-2 mx-2 rounded-lg font-medium whitespace-nowrap">
                    Resume Help
                </button>
                <button class="category-tab px-4 py-2 mx-2 rounded-lg font-medium whitespace-nowrap">
                    Workplace Trends
                </button>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <!-- For Job Seekers Section -->
        <section class="mb-16">
            <h2 class="text-2xl font-bold text-gray-900 mb-8 flex items-center">
                <span class="w-4 h-4 bg-primary rounded-full mr-3"></span>
                Resources for Job Seekers
            </h2>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                <asp:Repeater ID="rptCareerResources" runat="server">
                    <ItemTemplate>
                        <a href='<%# Eval("Link") %>' class="resource-card bg-white p-6 block">
                            <div class="flex justify-between items-start mb-3">
                                <h3 class="text-lg font-semibold text-gray-900"><%# Eval("Title") %></h3>
                                <%# FormatResourceType(Eval("Type").ToString()) %>
                            </div>
                            <p class="text-gray-600 text-sm mb-4"><%# Eval("Description") %></p>
                            <div class="text-xs text-gray-500">
                                <span class="font-medium"><%# Eval("Category") %></span>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>

        <!-- For Employers Section -->
        <section class="mb-16">
            <h2 class="text-2xl font-bold text-gray-900 mb-8 flex items-center">
                <span class="w-4 h-4 bg-primary rounded-full mr-3"></span>
                Resources for Employers
            </h2>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                <asp:Repeater ID="rptHiringResources" runat="server">
                    <ItemTemplate>
                        <a href='<%# Eval("Link") %>' class="resource-card bg-white p-6 block">
                            <div class="flex justify-between items-start mb-3">
                                <h3 class="text-lg font-semibold text-gray-900"><%# Eval("Title") %></h3>
                                <%# FormatResourceType(Eval("Type").ToString()) %>
                            </div>
                            <p class="text-gray-600 text-sm mb-4"><%# Eval("Description") %></p>
                            <div class="text-xs text-gray-500">
                                <span class="font-medium"><%# Eval("Category") %></span>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>

        <!-- Latest Articles Section -->
        <section>
            <h2 class="text-2xl font-bold text-gray-900 mb-8 flex items-center">
                <span class="w-4 h-4 bg-primary rounded-full mr-3"></span>
                Latest Articles
            </h2>
            
            <div class="grid md:grid-cols-3 gap-8">
                <asp:Repeater ID="rptLatestArticles" runat="server">
                    <ItemTemplate>
                        <div class="article-card bg-white p-6">
                            <div class="text-sm text-gray-500 mb-2"><%# FormatDate((DateTime)Eval("PublishDate")) %> • <%# Eval("ReadTime") %> read</div>
                            <h3 class="text-xl font-bold text-gray-900 mb-3"><%# Eval("Title") %></h3>
                            <p class="text-gray-600 mb-4"><%# Eval("Summary") %></p>
                            <div class="text-sm text-gray-500">By <%# Eval("Author") %></div>
                            <a href="#" class="mt-4 inline-block text-primary font-medium hover:text-primary-dark">
                                Read Article →
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>
    </div>

    <!-- Newsletter Section -->
    <section class="bg-gray-50 py-16">
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h2 class="text-2xl font-bold text-gray-900 mb-4">Get Career Insights Delivered to Your Inbox</h2>
            <p class="text-gray-600 mb-8">Subscribe to our newsletter for the latest job search tips, hiring trends, and career advice</p>
            
            <div class="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
                <asp:TextBox ID="txtEmail" runat="server" 
                    CssClass="flex-1 px-4 py-3 rounded-lg border border-gray-300 focus:ring-primary focus:border-primary" 
                    placeholder="Your email address" TextMode="Email"></asp:TextBox>
                <asp:Button ID="btnSubscribe" runat="server" Text="Subscribe" 
                    CssClass="btn btn-primary px-6 py-3 rounded-lg" />
            </div>
            <p class="text-xs text-gray-500 mt-3">We respect your privacy. Unsubscribe at any time.</p>
        </div>
    </section>
</asp:Content>