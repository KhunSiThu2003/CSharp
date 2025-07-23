<%@ Page Title="Job Details" Language="C#" MasterPageFile="~/CompanySite/Views/Views.Master" AutoEventWireup="true" CodeBehind="JobDetails.aspx.cs" Inherits="JobFinderWebApp.CompanySite.Views.JobDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Job Details</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400">View and manage this job posting</p>
        </div>
        <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/CompanySite/Views/JobListings.aspx" 
            class="inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200">
            <i class="fas fa-arrow-left mr-2"></i> Back to Jobs
        </asp:HyperLink>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <!-- Job Header -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden mb-8">
            <div class="px-6 py-5 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">
                            <asp:Literal ID="litJobTitle" runat="server"></asp:Literal>
                        </h2>
                        <div class="flex flex-wrap items-center gap-4 mt-2">
                            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                <i class="fas fa-building mr-2 text-indigo-500"></i>
                                <asp:Literal ID="litCompanyName" runat="server"></asp:Literal>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                <i class="fas fa-briefcase mr-2 text-indigo-500"></i>
                                <asp:Literal ID="litJobType" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </div>
                    <span class='inline-flex items-center px-3 py-1 rounded-full text-sm font-medium <%# GetStatusBadgeClass() %>'>
                        <asp:Literal ID="litJobStatus" runat="server"></asp:Literal>
                    </span>
                </div>
            </div>
            
            <!-- Job Meta -->
            <div class="px-6 py-4">
                <div class="flex flex-wrap gap-4">
                    <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                        <i class="fas fa-map-marker-alt mr-2 text-indigo-500"></i>
                        <asp:Literal ID="litLocation" runat="server"></asp:Literal>
                    </div>
                    <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                        <i class="fas fa-money-bill-wave mr-2 text-indigo-500"></i>
                        <asp:Literal ID="litSalaryRange" runat="server"></asp:Literal>
                    </div>
                    <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                        <i class="fas fa-user-tie mr-2 text-indigo-500"></i>
                        <asp:Literal ID="litExperienceLevel" runat="server"></asp:Literal>
                    </div>
                    <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                        <i class="fas fa-clock mr-2 text-indigo-500"></i>
                        Posted: <asp:Literal ID="litPostedDate" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
            
            <!-- Job Actions -->
            <div class="px-6 py-3 bg-gray-50 dark:bg-gray-700/50 border-t border-gray-200 dark:border-gray-700">
                <div class="flex flex-wrap justify-end gap-3">
                    <asp:HyperLink ID="lnkEditJob" runat="server" 
                        class="inline-flex items-center px-4 py-2 bg-indigo-600 hover:bg-indigo-700 dark:bg-indigo-700 dark:hover:bg-indigo-600 text-white font-medium rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md">
                        <i class="fas fa-edit mr-2"></i> Edit Job
                    </asp:HyperLink>
                    <asp:Button ID="btnToggleStatus" runat="server" 
                        class="inline-flex items-center px-4 py-2 text-white font-medium rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2"
                        OnClick="btnToggleStatus_Click" />
                    <asp:Button ID="btnDeleteJob" runat="server" Text="Delete Job"
                        class="inline-flex items-center px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-medium rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                        OnClientClick="return confirm('Are you sure you want to delete this job?');"
                        OnClick="btnDeleteJob_Click" />
                </div>
            </div>
        </div>

        <!-- Job Details Sections -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Main Content -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Job Description -->
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50">
                        <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Job Description</h3>
                    </div>
                    <div class="p-6 prose dark:prose-invert max-w-none">
                        <asp:Literal ID="litJobDescription" runat="server"></asp:Literal>
                    </div>
                </div>

                <!-- Requirements -->
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50">
                        <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Requirements</h3>
                    </div>
                    <div class="p-6 prose dark:prose-invert max-w-none">
                        <asp:Literal ID="litRequirements" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="space-y-6">
                <!-- Job Details Card -->
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50">
                        <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Job Details</h3>
                    </div>
                    <div class="p-6">
                        <div class="space-y-4">
                            <div>
                                <p class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">Posted Date</p>
                                <p class="text-sm font-medium text-gray-900 dark:text-white">
                                    <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                                </p>
                            </div>
                            <div>
                                <p class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">Expiry Date</p>
                                <p class="text-sm font-medium text-gray-900 dark:text-white">
                                    <asp:Literal ID="litExpiryDate" runat="server"></asp:Literal>
                                </p>
                            </div>
                            <div>
                                <p class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">Experience Level</p>
                                <p class="text-sm font-medium text-gray-900 dark:text-white">
                                    <asp:Literal ID="Literal2" runat="server"></asp:Literal>
                                </p>
                            </div>
                            <div>
                                <p class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">Remote Work</p>
                                <p class="text-sm font-medium text-gray-900 dark:text-white">
                                    <asp:Literal ID="litIsRemote" runat="server"></asp:Literal>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Applications Stats -->
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50">
                        <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Applications</h3>
                    </div>
                    <div class="p-6">
                        <div class="grid grid-cols-2 gap-4 mb-4">
                            <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4 text-center">
                                <p class="text-2xl font-bold text-blue-600 dark:text-blue-400">
                                    <asp:Literal ID="litTotalApplications" runat="server"></asp:Literal>
                                </p>
                                <p class="text-xs font-medium text-blue-600 dark:text-blue-400">Total Applications</p>
                            </div>
                            <div class="bg-green-50 dark:bg-green-900/20 rounded-lg p-4 text-center">
                                <p class="text-2xl font-bold text-green-600 dark:text-green-400">
                                    <asp:Literal ID="litNewApplications" runat="server"></asp:Literal>
                                </p>
                                <p class="text-xs font-medium text-green-600 dark:text-green-400">New This Week</p>
                            </div>
                        </div>
                        <asp:HyperLink ID="lnkViewApplications" runat="server" 
                            class="w-full flex justify-center items-center px-4 py-2 bg-indigo-600 hover:bg-indigo-700 dark:bg-indigo-700 dark:hover:bg-indigo-600 text-white font-medium rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md">
                            <i class="fas fa-users mr-2"></i> View Applications
                        </asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>