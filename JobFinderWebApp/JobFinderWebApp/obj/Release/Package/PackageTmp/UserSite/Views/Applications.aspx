<%@ Page Title="Applications" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master"
    AutoEventWireup="true" CodeBehind="Applications.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.Applications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .application-card {
            transition: all 0.3s ease;
            border-radius: 0.75rem;
            border-left: 4px solid transparent;
        }

            .application-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            }

        .dark .application-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.25), 0 4px 6px -2px rgba(0, 0, 0, 0.1);
        }

        .status-badge {
            transition: all 0.2s ease;
        }

            .status-badge:hover {
                transform: scale(1.05);
            }

        .job-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-dropdown {
            min-width: 160px;
        }

        .pagination-btn {
            min-width: 100px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center justify-between">
        <div class="flex items-center gap-4">
            <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">My Applications</h1>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="w-full flex justify-end p-4">
        <div class="flex gap-3">
            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged"
                CssClass="filter-dropdown px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700/50 shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all">
                <asp:ListItem Text="All Applications" Value="All" Selected="True" />
                <asp:ListItem Text="Pending" Value="Pending" />
                <asp:ListItem Text="Reviewed" Value="Reviewed" />
                <asp:ListItem Text="Rejected" Value="Rejected" />
                <asp:ListItem Text="Hired" Value="Hired" />
            </asp:DropDownList>
            <asp:DropDownList ID="ddlDateFilter" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="ddlDateFilter_SelectedIndexChanged"
                CssClass="filter-dropdown px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700/50 shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all">
                <asp:ListItem Text="All Time" Value="All" Selected="True" />
                <asp:ListItem Text="Last 7 Days" Value="7" />
                <asp:ListItem Text="Last 30 Days" Value="30" />
                <asp:ListItem Text="Last 90 Days" Value="90" />
            </asp:DropDownList>
        </div>
    </div>

    <div class="bg-white dark:bg-black rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">

        <!-- Applications List -->
        <asp:Repeater ID="rptApplications" runat="server" OnItemDataBound="rptApplications_ItemDataBound">
            <HeaderTemplate>
                <div class="grid gap-6 p-6">
            </HeaderTemplate>
            <ItemTemplate>
                <div class="application-card bg-white dark:bg-gray-800/30 p-6 rounded-xl border border-gray-200 dark:border-gray-700">
                    <div class="flex flex-col md:flex-row gap-6">
                        <div class="flex-shrink-0">
                            <asp:Image ID="imgCompanyLogo" runat="server"
                                class="h-16 w-16 rounded-xl object-cover border border-gray-200 dark:border-gray-700 shadow-sm" />
                        </div>
                        <div class="flex-1">
                            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-3">
                                <div>
                                    <h3 class="text-xl font-semibold text-gray-800 dark:text-white mb-1">
                                        <asp:Literal ID="litJobTitle" runat="server" />
                                    </h3>
                                    <p class="text-gray-600 dark:text-gray-300">
                                        <asp:Literal ID="litCompanyName" runat="server" />
                                        <span class="mx-2">•</span>
                                        <asp:Literal ID="litLocation" runat="server" />
                                    </p>
                                </div>
                                <div class="flex-shrink-0">
                                    <span class="status-badge inline-flex items-center px-3 py-1 rounded-full text-sm font-medium">
                                        <asp:Literal ID="litStatus" runat="server" />
                                    </span>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-3 mb-4">
                                <div class="job-meta-item text-gray-600 dark:text-gray-300">
                                    <i class="fas fa-briefcase text-blue-500 dark:text-blue-400"></i>
                                    <asp:Literal ID="litJobType" runat="server" />
                                </div>
                                <div class="job-meta-item text-gray-600 dark:text-gray-300">
                                    <i class="fas fa-chart-line text-blue-500 dark:text-blue-400"></i>
                                    <asp:Literal ID="litExperienceLevel" runat="server" />
                                </div>
                                <div class="job-meta-item text-gray-600 dark:text-gray-300">
                                    <i class="fas fa-money-bill-wave text-blue-500 dark:text-blue-400"></i>
                                    <asp:Literal ID="litSalaryRange" runat="server" />
                                </div>
                                <div class="job-meta-item text-gray-600 dark:text-gray-300">
                                    <i class="fas fa-calendar-alt text-blue-500 dark:text-blue-400"></i>
                                    Applied:
                                    <asp:Literal ID="litApplicationDate" runat="server" />
                                </div>
                            </div>

                            <div class="flex flex-wrap items-center justify-between gap-3">
                                <div class="flex flex-wrap gap-2">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200">
                                        <i class="fas fa-clock mr-1"></i>
                                        <asp:Literal ID="litDaysSinceApplied" runat="server" />
                                    </span>
                                </div>
                                <div class="flex-shrink-0">
                                    <asp:HyperLink ID="hlViewJob" runat="server"
                                        CssClass="inline-flex items-center px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700/50 shadow-sm hover:shadow-md transition-all duration-200">
                                        View Details <i class="fas fa-chevron-right ml-1.5 text-xs"></i>
                                    </asp:HyperLink>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
                <asp:Panel ID="pnlNoApplications" runat="server" Visible="false"
                    CssClass="p-8 text-center text-gray-500 dark:text-gray-400">
                    <i class="fas fa-briefcase text-5xl mb-4 text-gray-300 dark:text-gray-600"></i>
                    <p class="text-xl font-medium mb-2">No applications found</p>
                    <p class="mb-4">You haven't applied to any jobs yet</p>
                    <asp:HyperLink runat="server" NavigateUrl="~/UserSite/Views/Jobs.aspx"
                        CssClass="inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-500 hover:from-blue-700 hover:to-blue-600 dark:from-blue-700 dark:to-blue-600 dark:hover:from-blue-800 dark:hover:to-blue-700 text-white font-medium rounded-lg shadow-sm hover:shadow-md transition-all duration-200">
                        Browse Jobs <i class="fas fa-arrow-right ml-2"></i>
                    </asp:HyperLink>
                </asp:Panel>
            </FooterTemplate>
        </asp:Repeater>

        <!-- Pagination -->
        <div class="px-6 py-4 border-t border-gray-200 dark:border-gray-700 flex items-center justify-between bg-gray-50/50 dark:bg-gray-800/30">
            <div class="text-sm text-gray-500 dark:text-gray-400">
                Showing
                <asp:Literal ID="litStartRecord" runat="server" />
                to
                <asp:Literal ID="litEndRecord" runat="server" />
                of
                <asp:Literal ID="litTotalRecords" runat="server" />
                applications
            </div>
            <div class="flex gap-3">
                <asp:Button ID="btnPrevPage" runat="server" Text="Previous"
                    CssClass="pagination-btn px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700/50 shadow-sm hover:shadow-md transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                    OnClick="btnPrevPage_Click" />
                <asp:Button ID="btnNextPage" runat="server" Text="Next"
                    CssClass="pagination-btn px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700/50 shadow-sm hover:shadow-md transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                    OnClick="btnNextPage_Click" />
            </div>
        </div>
    </div>
</asp:Content>
