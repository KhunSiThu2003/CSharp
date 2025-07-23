<%@ Page Title="Job Listings" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master"
    AutoEventWireup="true" CodeBehind="Jobs.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.Jobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .job-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .dark .job-card:hover {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-200">Job Listings</h1>
            <p class="text-sm text-gray-600 dark:text-gray-400">Find your dream job today</p>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-white dark:bg-black rounded-xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">
        <!-- Filters Section -->
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-900/50">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div class="flex flex-wrap items-center gap-4">
                    <div>

                        <asp:DropDownList ID="ddlJobType" runat="server"
                            class="px-3 py-2 border border-gray-300 dark:border-gray-700 dark:bg-gray-800/30 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <asp:ListItem Text="All Types" Value="" Selected="True" />
                            <asp:ListItem Text="Full-time" Value="Full-time" />
                            <asp:ListItem Text="Part-time" Value="Part-time" />
                            <asp:ListItem Text="Contract" Value="Contract" />
                            <asp:ListItem Text="Internship" Value="Internship" />
                            <asp:ListItem Text="Remote" Value="Remote" />
                        </asp:DropDownList>
                    </div>
                    <div>

                        <asp:DropDownList ID="ddlLocation" runat="server"
                            class="px-3 py-2 border border-gray-300 dark:border-gray-700 dark:bg-gray-800/30 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <asp:ListItem Text="All Locations" Value="" Selected="True" />
                            <asp:ListItem Text="New York" Value="New York" />
                            <asp:ListItem Text="San Francisco" Value="San Francisco" />
                            <asp:ListItem Text="Chicago" Value="Chicago" />
                            <asp:ListItem Text="Remote" Value="Remote" />
                        </asp:DropDownList>
                    </div>
                    <div>

                        <asp:DropDownList ID="ddlExperience" runat="server"
                            class="px-3 py-2 border border-gray-300 dark:border-gray-700 dark:bg-gray-800/30 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <asp:ListItem Text="All Levels" Value="" Selected="True" />
                            <asp:ListItem Text="Entry Level" Value="Entry" />
                            <asp:ListItem Text="Mid Level" Value="Mid" />
                            <asp:ListItem Text="Senior Level" Value="Senior" />
                        </asp:DropDownList>
                    </div>
                    <div class="flex flex-col sm:flex-row gap-3 w-full sm:w-auto">
                        <div class="relative flex-grow">
                            <asp:TextBox ID="txtSearch" runat="server" placeholder="Search jobs..."
                                class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-700 dark:bg-gray-800/30 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400"></i>
                            </div>
                        </div>
                        <asp:Button ID="btnSearch" runat="server" Text="Search"
                            class="px-4 py-2 bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-600 text-white font-medium rounded-lg shadow-sm hover:shadow-md transition-colors duration-200"
                            OnClick="btnSearch_Click" />
                    </div>
                </div>

                <div>
                    <asp:Button ID="btnResetFilters" runat="server" Text="Reset Filters"
                        class="px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-100 dark:hover:bg-gray-700 shadow-sm hover:shadow-md transition-colors duration-200"
                        OnClick="btnResetFilters_Click" />
                </div>
            </div>
        </div>

        <!-- Debug Panel -->
        <asp:Panel ID="pnlDebug" runat="server" Visible="false" CssClass="bg-yellow-50 p-4">
            <div class="text-sm text-yellow-800">
                Debug Information:<br />
                <asp:Literal ID="litDebugInfo" runat="server" />
            </div>
        </asp:Panel>

        <!-- Jobs List -->
        <div class="divide-y divide-gray-200 dark:divide-gray-700">
            <asp:Repeater ID="rptJobs" runat="server" OnItemCommand="rptJobs_ItemCommand">
                <ItemTemplate>
                    <div class="p-6 hover:bg-gray-50 dark:hover:bg-gray-900/50 transition-colors duration-200 job-card">
                        <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-6">
                            <div class="flex items-start gap-4 flex-1 min-w-0">
                                <div class="flex-shrink-0">
                                    <img src='<%# Eval("CompanyLogo") ?? ResolveUrl("~/Content/Images/default-company.png") %>'
                                        alt='<%# Eval("CompanyName") %>'
                                        class="h-12 w-12 rounded-lg object-cover border border-gray-200 dark:border-gray-700"
                                        onerror="this.src='<%# ResolveUrl("~/Content/Images/default-company.png") %>'" />
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-1">
                                        <asp:LinkButton runat="server" CommandName="ViewDetail" CommandArgument='<%# Eval("JobId") %>'
                                            class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200">
                                            <%# Eval("JobTitle") %>
                                        </asp:LinkButton>
                                    </h3>
                                    <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">
                                        <%# Eval("CompanyName") %> • <%# Eval("Location") %>
                                    </p>
                                    <div class="flex flex-wrap gap-2 mb-3">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200">
                                            <%# Eval("JobType") %>
                                        </span>
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-200">
                                            <%# Eval("ExperienceLevel") %>
                                        </span>
                                        <%# (bool)Eval("IsRemote") ? 
                                            "<span class='inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 dark:bg-purple-900 text-purple-800 dark:text-purple-200'>Remote</span>" : "" %>
                                    </div>
                                    <p class="text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
                                        <%# Eval("Description") %>
                                    </p>
                                </div>
                            </div>
                            <div class="flex flex-col items-end gap-2">
                                <div class="text-lg font-semibold text-gray-800 dark:text-gray-200">
                                    <%# Eval("SalaryRange", "{0}") %>
                                </div>
                                <div class="flex gap-2">
                                    <asp:Button runat="server" CommandName="SaveJob" CommandArgument='<%# Eval("JobId") %>'
                                        class="px-3 py-1.5 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-700 dark:text-gray-300 text-sm font-medium hover:bg-gray-100 dark:hover:bg-gray-700 shadow-sm hover:shadow-md transition-colors duration-200"
                                        Text='<%# (int)Eval("IsSaved") > 0 ? "Saved" : "Save" %>' />
                                    <asp:Button runat="server" CommandName="ViewDetail" CommandArgument='<%# Eval("JobId") %>'
                                        class="px-3 py-1.5 bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-600 text-white text-sm font-medium rounded-lg shadow-sm hover:shadow-md transition-colors duration-200"
                                        Text="Job Detail" />
                                </div>
                                <div class="text-xs text-gray-500 dark:text-gray-400">
                                    Posted <%# Convert.ToDateTime(Eval("PostedDate")).ToString("MMM dd, yyyy") %>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Empty State -->
            <asp:Panel ID="pnlNoJobs" runat="server" Visible="false" class="p-12 text-center">
                <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
                    <i class="fas fa-briefcase text-gray-500 dark:text-gray-400 text-2xl"></i>
                </div>
                <h3 class="text-lg font-medium text-gray-800 dark:text-gray-200">No jobs found</h3>
                <p class="text-gray-600 dark:text-gray-400 mt-1">
                    Try adjusting your search or filters
                </p>
                <asp:Button ID="btnResetSearch" runat="server" Text="Reset Search"
                    class="mt-4 px-4 py-2 bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-600 text-white font-medium rounded-lg shadow-sm hover:shadow-md transition-colors duration-200"
                    OnClick="btnResetSearch_Click" />
            </asp:Panel>
        </div>

        <!-- Pagination -->
        <div class="px-6 py-4 border-t border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-900/50">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div class="text-sm text-gray-600 dark:text-gray-400">
                    Showing <span class="font-medium text-gray-800 dark:text-gray-200">
                        <asp:Literal ID="litStartItem" runat="server" /></span> to <span class="font-medium text-gray-800 dark:text-gray-200">
                            <asp:Literal ID="litEndItem" runat="server" /></span> of <span class="font-medium text-gray-800 dark:text-gray-200">
                                <asp:Literal ID="litTotalItems" runat="server" /></span> results
                </div>
                <div class="flex gap-2">
                    <asp:Button ID="btnPrevPage" runat="server" Text="Previous"
                        class="px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-100 dark:hover:bg-gray-700 shadow-sm hover:shadow-md transition-colors duration-200 disabled:opacity-50"
                        OnClick="btnPrevPage_Click" Enabled="false" />
                    <asp:Button ID="btnNextPage" runat="server" Text="Next"
                        class="px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-100 dark:hover:bg-gray-700 shadow-sm hover:shadow-md transition-colors duration-200 disabled:opacity-50"
                        OnClick="btnNextPage_Click" Enabled="false" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
