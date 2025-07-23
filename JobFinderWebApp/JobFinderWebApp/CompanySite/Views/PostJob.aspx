<%@ Page Title="Post New Job" Language="C#" MasterPageFile="~/CompanySite/Views/Views.Master" AutoEventWireup="true" CodeBehind="PostJob.aspx.cs" Inherits="JobFinderWebApp.CompanySite.Views.PostJob" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Post New Job</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Create a new job listing for candidates</p>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false" 
            class="mb-6 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative">
            <strong class="font-bold">Success!</strong>
            <span class="block sm:inline">Your job has been posted successfully.</span>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" Visible="false" 
            class="mb-6 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
            <strong class="font-bold">Error!</strong>
            <span class="block sm:inline"><asp:Literal ID="litError" runat="server"></asp:Literal></span>
        </asp:Panel>

        <!-- Job Details Section -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-6 mb-6">
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white pb-2 mb-4 border-b border-gray-200 dark:border-gray-700">Job Details</h2>
            
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="<%= txtJobTitle.ClientID %>">Job Title *</label>
                <asp:TextBox ID="txtJobTitle" runat="server" 
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white" 
                    placeholder="e.g. Senior Software Engineer" required="true"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvJobTitle" runat="server" ControlToValidate="txtJobTitle"
                    ErrorMessage="Job title is required" class="mt-1 text-sm text-red-600 dark:text-red-400" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="<%= ddlJobType.ClientID %>">Job Type *</label>
                    <asp:DropDownList ID="ddlJobType" runat="server" 
                        class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white" 
                        required="true">
                        <asp:ListItem Value="" Text="Select Job Type" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="Full-time" Text="Full-time"></asp:ListItem>
                        <asp:ListItem Value="Part-time" Text="Part-time"></asp:ListItem>
                        <asp:ListItem Value="Contract" Text="Contract"></asp:ListItem>
                        <asp:ListItem Value="Internship" Text="Internship"></asp:ListItem>
                        <asp:ListItem Value="Temporary" Text="Temporary"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvJobType" runat="server" ControlToValidate="ddlJobType"
                        ErrorMessage="Job type is required" class="mt-1 text-sm text-red-600 dark:text-red-400" Display="Dynamic" InitialValue=""></asp:RequiredFieldValidator>
                </div>

                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="<%= ddlExperienceLevel.ClientID %>">Experience Level *</label>
                    <asp:DropDownList ID="ddlExperienceLevel" runat="server" 
                        class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white" 
                        required="true">
                        <asp:ListItem Value="" Text="Select Experience Level" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="Entry Level" Text="Entry Level"></asp:ListItem>
                        <asp:ListItem Value="Mid Level" Text="Mid Level"></asp:ListItem>
                        <asp:ListItem Value="Senior Level" Text="Senior Level"></asp:ListItem>
                        <asp:ListItem Value="Executive" Text="Executive"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvExperienceLevel" runat="server" ControlToValidate="ddlExperienceLevel"
                        ErrorMessage="Experience level is required" class="mt-1 text-sm text-red-600 dark:text-red-400" Display="Dynamic" InitialValue=""></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="<%= txtLocation.ClientID %>">Location *</label>
                    <asp:TextBox ID="txtLocation" runat="server" 
                        class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white" 
                        placeholder="e.g. New York, NY or Remote" required="true"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLocation" runat="server" ControlToValidate="txtLocation"
                        ErrorMessage="Location is required" class="mt-1 text-sm text-red-600 dark:text-red-400" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div class="mb-6 flex items-end">
                    <label class="flex items-center text-sm font-medium text-gray-700 dark:text-gray-300">
                        <asp:CheckBox ID="cbIsRemote" runat="server" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 dark:border-gray-600 rounded mr-2" />
                        This is a remote position
                    </label>
                </div>
            </div>
        </div>

        <!-- Salary Information Section -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-6 mb-6">
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white pb-2 mb-4 border-b border-gray-200 dark:border-gray-700">Salary Information</h2>
            
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Salary Range</label>
                <div class="flex flex-col sm:flex-row gap-4">
                    <div class="flex-1">
                        <asp:TextBox ID="txtSalaryMin" runat="server" TextMode="Number" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white" 
                            placeholder="Min"></asp:TextBox>
                    </div>
                    <div class="flex-1">
                        <asp:TextBox ID="txtSalaryMax" runat="server" TextMode="Number" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white" 
                            placeholder="Max"></asp:TextBox>
                    </div>
                    <div class="flex-1">
                        <asp:DropDownList ID="ddlSalaryType" runat="server" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white">
                            <asp:ListItem Value="Per Year" Text="Per Year" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="Per Month" Text="Per Month"></asp:ListItem>
                            <asp:ListItem Value="Per Hour" Text="Per Hour"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>

        <!-- Job Description Section -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-6 mb-6">
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white pb-2 mb-4 border-b border-gray-200 dark:border-gray-700">Job Description</h2>
            
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="<%= txtJobDescription.ClientID %>">Job Description *</label>
                <asp:TextBox ID="txtJobDescription" runat="server" 
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white min-h-[200px]" 
                    TextMode="MultiLine" placeholder="Describe the job responsibilities, requirements, and benefits..." required="true"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvJobDescription" runat="server" ControlToValidate="txtJobDescription"
                    ErrorMessage="Job description is required" class="mt-1 text-sm text-red-600 dark:text-red-400" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
        </div>

        <!-- Requirements Section -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-6 mb-6">
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white pb-2 mb-4 border-b border-gray-200 dark:border-gray-700">Requirements</h2>
            
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="<%= txtRequirements.ClientID %>">Requirements *</label>
                <asp:TextBox ID="txtRequirements" runat="server" 
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white min-h-[160px]" 
                    TextMode="MultiLine" placeholder="List the required skills, qualifications, and experience..." required="true"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvRequirements" runat="server" ControlToValidate="txtRequirements"
                    ErrorMessage="Requirements are required" class="mt-1 text-sm text-red-600 dark:text-red-400" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
        </div>

        <!-- Job Expiry Section -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-6 mb-6">
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white pb-2 mb-4 border-b border-gray-200 dark:border-gray-700">Job Expiry</h2>
            
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="<%= txtExpiryDate.ClientID %>">Expiry Date *</label>
                <asp:TextBox ID="txtExpiryDate" runat="server" TextMode="Date" 
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white max-w-[200px]" 
                    required="true"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvExpiryDate" runat="server" ControlToValidate="txtExpiryDate"
                    ErrorMessage="Expiry date is required" class="mt-1 text-sm text-red-600 dark:text-red-400" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
        </div>

        <!-- Submit Button -->
        <div class="flex justify-end">
            <asp:Button ID="btnPostJob" runat="server" Text="Post Job" 
                class="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 dark:bg-indigo-700 dark:hover:bg-indigo-600 text-white font-medium rounded-md shadow-sm transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" 
                OnClick="btnPostJob_Click" />
        </div>
    </div>
</asp:Content>