<%@ Page Title="Edit Job" Language="C#" MasterPageFile="~/CompanySite/Views/Views.Master" AutoEventWireup="true" CodeBehind="EditJob.aspx.cs" Inherits="JobFinderWebApp.CompanySite.Views.EditJob" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Edit Job</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Update your job listing</p>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="max-w-4xl mx-auto">
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false" class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6">
            <strong class="font-bold">Success!</strong>
            <span class="block sm:inline">Your job has been updated successfully.</span>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" Visible="false" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6">
            <strong class="font-bold">Error!</strong>
            <span class="block sm:inline"><asp:Literal ID="litError" runat="server"></asp:Literal></span>
        </asp:Panel>

        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
            <!-- Job Details Section -->
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Job Details</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Job Title *</label>
                        <asp:TextBox ID="txtJobTitle" runat="server" 
                            class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm"
                            placeholder="e.g. Senior Software Engineer" required="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvJobTitle" runat="server" ControlToValidate="txtJobTitle"
                            ErrorMessage="Job title is required" CssClass="text-red-500 text-sm mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Job Type *</label>
                        <asp:DropDownList ID="ddlJobType" runat="server" 
                            class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm" required="true">
                            <asp:ListItem Text="Select Job Type" Value="" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Full-time" Value="Full-time"></asp:ListItem>
                            <asp:ListItem Text="Part-time" Value="Part-time"></asp:ListItem>
                            <asp:ListItem Text="Contract" Value="Contract"></asp:ListItem>
                            <asp:ListItem Text="Internship" Value="Internship"></asp:ListItem>
                            <asp:ListItem Text="Temporary" Value="Temporary"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvJobType" runat="server" ControlToValidate="ddlJobType"
                            ErrorMessage="Job type is required" CssClass="text-red-500 text-sm mt-1" Display="Dynamic" InitialValue=""></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Experience Level *</label>
                        <asp:DropDownList ID="ddlExperienceLevel" runat="server" 
                            class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm" required="true">
                            <asp:ListItem Text="Select Experience Level" Value="" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Entry Level" Value="Entry Level"></asp:ListItem>
                            <asp:ListItem Text="Mid Level" Value="Mid Level"></asp:ListItem>
                            <asp:ListItem Text="Senior Level" Value="Senior Level"></asp:ListItem>
                            <asp:ListItem Text="Executive" Value="Executive"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvExperienceLevel" runat="server" ControlToValidate="ddlExperienceLevel"
                            ErrorMessage="Experience level is required" CssClass="text-red-500 text-sm mt-1" Display="Dynamic" InitialValue=""></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Location *</label>
                        <asp:TextBox ID="txtLocation" runat="server" 
                            class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm"
                            placeholder="e.g. New York, NY or Remote" required="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvLocation" runat="server" ControlToValidate="txtLocation"
                            ErrorMessage="Location is required" CssClass="text-red-500 text-sm mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="flex items-center">
                        <asp:CheckBox ID="cbIsRemote" runat="server" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded" />
                        <label for="<%= cbIsRemote.ClientID %>" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">This is a remote position</label>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Expiry Date *</label>
                        <asp:TextBox ID="txtExpiryDate" runat="server" TextMode="Date"
                            class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm" required="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvExpiryDate" runat="server" ControlToValidate="txtExpiryDate"
                            ErrorMessage="Expiry date is required" CssClass="text-red-500 text-sm mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>

            <!-- Salary Information Section -->
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Salary Information</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Minimum Salary</label>
                        <div class="relative rounded-md shadow-sm">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <span class="text-gray-500 dark:text-gray-400 sm:text-sm">$</span>
                            </div>
                            <asp:TextBox ID="txtSalaryMin" runat="server" TextMode="Number"
                                class="block w-full pl-7 pr-12 rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500"
                                placeholder="0.00"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Maximum Salary</label>
                        <div class="relative rounded-md shadow-sm">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <span class="text-gray-500 dark:text-gray-400 sm:text-sm">$</span>
                            </div>
                            <asp:TextBox ID="txtSalaryMax" runat="server" TextMode="Number"
                                class="block w-full pl-7 pr-12 rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500"
                                placeholder="0.00"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Salary Type</label>
                        <asp:DropDownList ID="ddlSalaryType" runat="server" 
                            class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm">
                            <asp:ListItem Text="Per Year" Value="Per Year" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Per Month" Value="Per Month"></asp:ListItem>
                            <asp:ListItem Text="Per Hour" Value="Per Hour"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Job Description Section -->
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Job Description *</h2>
                <asp:TextBox ID="txtJobDescription" runat="server" TextMode="MultiLine" Rows="8"
                    class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm"
                    placeholder="Describe the job responsibilities, requirements, and benefits..." required="true"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvJobDescription" runat="server" ControlToValidate="txtJobDescription"
                    ErrorMessage="Job description is required" CssClass="text-red-500 text-sm mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <!-- Requirements Section -->
            <div class="p-6">
                <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Requirements *</h2>
                <asp:TextBox ID="txtRequirements" runat="server" TextMode="MultiLine" Rows="8"
                    class="w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:border-indigo-500 focus:ring-indigo-500 shadow-sm"
                    placeholder="List the required skills, qualifications, and experience..." required="true"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvRequirements" runat="server" ControlToValidate="txtRequirements"
                    ErrorMessage="Requirements are required" CssClass="text-red-500 text-sm mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <!-- Form Actions -->
            <div class="bg-gray-50 dark:bg-gray-700 px-6 py-4 flex justify-between border-t border-gray-200 dark:border-gray-700">
                <asp:HyperLink ID="lnkCancel" runat="server" NavigateUrl="~/CompanySite/Views/JobListings.aspx"
                    class="inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Cancel
                </asp:HyperLink>
                <div class="flex gap-3">
                    <asp:Button ID="btnDeactivate" runat="server" Text="Deactivate Job" 
                        class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                        OnClick="btnDeactivate_Click" Visible="false" />
                    <asp:Button ID="btnUpdate" runat="server" Text="Update Job" 
                        class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        OnClick="btnUpdate_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>