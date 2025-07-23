<%@ Page Title="Job Applications" Language="C#" MasterPageFile="~/CompanySite/Views/Views.Master"
    AutoEventWireup="true" CodeBehind="CompanyApplications.aspx.cs" Inherits="JobFinderWebApp.CompanySite.Views.CompanyApplications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .application-card {
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
            border-radius: 0.5rem;
        }

        .application-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        .status-badge {
            padding: 0.35rem 0.65rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
        }

        .status-badge i {
            margin-right: 0.25rem;
            font-size: 0.65rem;
        }

        .status-pending {
            border-left-color: #f59e0b;
        }

        .status-reviewed {
            border-left-color: #3b82f6;
        }

        .status-interview {
            border-left-color: #8b5cf6;
        }

        .status-rejected {
            border-left-color: #ef4444;
        }

        .status-hired {
            border-left-color: #10b981;
        }

        .applicant-avatar {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #e5e7eb;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s ease;
        }

        .action-btn:hover {
            transform: scale(1.1);
        }

        .dropdown-actions {
            min-width: 180px;
        }

        .empty-state {
            padding: 3rem 1rem;
            text-align: center;
        }

        .empty-state-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #9ca3af;
        }

        .filter-dropdown {
            min-width: 160px;
            background-image: none;
            padding: 0.4rem 1rem;
        }

        #resumeViewer {
            width: 100%;
            height: 70vh;
            border: 1px solid #e5e7eb;
            border-radius: 0.375rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Job Applications</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                Review and manage applications for your job postings
            </p>
        </div>
        <div class="flex flex-wrap gap-2">
            <asp:DropDownList ID="ddlJobFilter" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="Filters_Changed"
                CssClass="filter-dropdown border border-gray-200 dark:border-gray-600 dark:bg-gray-800 rounded-lg shadow-sm text-sm">
                <asp:ListItem Text="All Jobs" Value="0" Selected="True" />
            </asp:DropDownList>

            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="Filters_Changed"
                CssClass="filter-dropdown border border-gray-200 dark:border-gray-600 dark:bg-gray-800 rounded-lg shadow-sm text-sm">
                <asp:ListItem Text="All Statuses" Value="All" Selected="True" />
                <asp:ListItem Text="Pending" Value="Pending" />
                <asp:ListItem Text="Reviewed" Value="Reviewed" />
                <asp:ListItem Text="Interview" Value="Interview" />
                <asp:ListItem Text="Rejected" Value="Rejected" />
                <asp:ListItem Text="Hired" Value="Hired" />
            </asp:DropDownList>

            <asp:DropDownList ID="ddlDateFilter" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="Filters_Changed"
                CssClass="filter-dropdown border border-gray-200 dark:border-gray-600 dark:bg-gray-800 rounded-lg shadow-sm text-sm">
                <asp:ListItem Text="All Time" Value="0" Selected="True" />
                <asp:ListItem Text="Today" Value="1" />
                <asp:ListItem Text="Last 7 Days" Value="7" />
                <asp:ListItem Text="Last 30 Days" Value="30" />
            </asp:DropDownList>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
        <asp:GridView ID="gvApplications" runat="server" AutoGenerateColumns="false"
            CssClass="w-full" GridLines="None"
            OnRowDataBound="gvApplications_RowDataBound"
            OnRowCommand="gvApplications_RowCommand"
            DataKeyNames="ApplicationId">
            <Columns>
                <asp:TemplateField HeaderText="Applicant">
                    <ItemTemplate>
                        <div class="flex items-center gap-3">
                            <asp:Image ID="imgApplicant" runat="server"
                                CssClass="applicant-avatar" />
                            <div>
                                <div class="font-medium text-gray-900 dark:text-white">
                                    <asp:Literal ID="litApplicantName" runat="server" />
                                </div>
                                <div class="text-xs text-gray-500 dark:text-gray-400">
                                    <asp:Literal ID="litAppliedDate" runat="server" />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Job Position">
                    <ItemTemplate>
                        <div class="font-medium text-gray-900 dark:text-white">
                            <asp:Literal ID="litJobTitle" runat="server" />
                        </div>
                        <div class="text-xs text-gray-500 dark:text-gray-400">
                            <asp:Literal ID="litJobType" runat="server" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="status-badge">
                            <i class='<%# GetStatusIcon(Eval("Status").ToString()) %>'></i>
                            <asp:Literal ID="litStatus" runat="server" />
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <div class="flex items-center justify-end gap-2">
                            <asp:LinkButton ID="btnViewResume" runat="server" CommandName="ViewResume"
                                CommandArgument='<%# Eval("ApplicationId") %>'
                                ToolTip="View Resume"
                                CssClass="action-btn text-blue-600 dark:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-900/20">
                                <i class="fas fa-file-alt text-sm"></i>
                            </asp:LinkButton>

                            <div class="relative">
                                <asp:DropDownList ID="ddlStatusActions" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlStatusActions_SelectedIndexChanged"
                                    CssClass="dropdown-actions text-xs px-3 py-1.5 border border-gray-200 dark:border-gray-600 rounded-lg shadow-sm"
                                    data-application-id='<%# Eval("ApplicationId") %>'>
                                    <asp:ListItem Text="Change Status" Value="" />
                                    <asp:ListItem Text="Mark as Reviewed" Value="Reviewed" />
                                    <asp:ListItem Text="Schedule Interview" Value="Interview" />
                                    <asp:ListItem Text="Reject Application" Value="Rejected" />
                                    <asp:ListItem Text="Hire Candidate" Value="Hired" />
                                </asp:DropDownList>
                            </div>

                            <asp:LinkButton ID="btnSendMessage" runat="server" CommandName="SendMessage"
                                CommandArgument='<%# Eval("ApplicationId") + "|" + Eval("UserId") %>'
                                ToolTip="Send Message"
                                CssClass="action-btn text-green-600 dark:text-green-400 hover:bg-green-50 dark:hover:bg-green-900/20">
                                <i class="fas fa-envelope text-sm"></i>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-500 dark:text-gray-400">No applications found</h3>
                    <p class="text-sm text-gray-400 mt-1">
                        There are no applications matching your current filters
                    </p>
                </div>
            </EmptyDataTemplate>

            <HeaderStyle CssClass="border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider" />
            <RowStyle CssClass="border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/10 transition-colors" />
            <AlternatingRowStyle CssClass="border-b border-gray-200 dark:border-gray-700 bg-gray-50/30 dark:bg-gray-800/30 hover:bg-gray-50 dark:hover:bg-gray-700/10 transition-colors" />
        </asp:GridView>

        <!-- Pagination -->
        <div class="px-6 py-4 border-t border-gray-200 dark:border-gray-700 flex items-center justify-between bg-white dark:bg-gray-800">
            <div class="text-sm text-gray-500 dark:text-gray-400">
                Showing page <span class="font-medium text-gray-700 dark:text-gray-300"><asp:Literal ID="litCurrentPage" runat="server" /></span>
                of <span class="font-medium text-gray-700 dark:text-gray-300"><asp:Literal ID="litTotalPages" runat="server" /></span>
                <span class="mx-1">•</span>
                <span class="font-medium text-gray-700 dark:text-gray-300"><asp:Literal ID="litTotalApplications" runat="server" /></span> total applications
            </div>
            <div class="flex gap-2">
                <asp:Button ID="btnPrevPage" runat="server" Text="Previous"
                    CssClass="px-3 py-1.5 text-sm font-medium rounded-lg border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed"
                    OnClick="btnPrevPage_Click" />
                <asp:Button ID="btnNextPage" runat="server" Text="Next"
                    CssClass="px-3 py-1.5 text-sm font-medium rounded-lg border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed"
                    OnClick="btnNextPage_Click" />
            </div>
        </div>
    </div>

    <!-- View Resume Modal -->
    <div id="resumeModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" onclick="closeResumeModal()"></div>
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
            <div class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-4xl sm:w-full">
                <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <div class="flex items-start justify-between">
                        <h3 class="text-lg font-medium text-gray-900 dark:text-white" id="modal-title">
                            Applicant Resume
                        </h3>
                        <button type="button" onclick="closeResumeModal()" 
                                class="text-gray-400 hover:text-gray-500 focus:outline-none">
                            <span class="sr-only">Close</span>
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="mt-4">
                        <iframe id="resumeViewer" class="w-full h-[80vh] border border-gray-200 dark:border-gray-700 rounded-md"
                                frameborder="0"></iframe>
                    </div>
                </div>
                <div class="px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse bg-gray-50 dark:bg-gray-700/50">
                    <button type="button" onclick="closeResumeModal()"
                            class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none sm:ml-3 sm:w-auto sm:text-sm">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showResumeModal(resumeUrl) {
            try {
                // Ensure the URL is properly encoded
                const encodedUrl = encodeURI(resumeUrl);
                const iframe = document.getElementById('resumeViewer');

                // Set the iframe source
                iframe.src = encodedUrl;

                // Show the modal
                document.getElementById('resumeModal').classList.remove('hidden');

                // Prevent body scrolling when modal is open
                document.body.style.overflow = 'hidden';
            } catch (error) {
                console.error('Error showing resume:', error);
                alert('Error loading resume. Please try again.');
            }
        }

        function closeResumeModal() {
            try {
                const iframe = document.getElementById('resumeViewer');

                // Clear the iframe source
                iframe.src = '';

                // Hide the modal
                document.getElementById('resumeModal').classList.add('hidden');

                // Restore body scrolling
                document.body.style.overflow = '';
            } catch (error) {
                console.error('Error closing modal:', error);
            }
        }
    </script>
</asp:Content>