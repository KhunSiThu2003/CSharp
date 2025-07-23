<%@ Page Title="Saved Jobs" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master" AutoEventWireup="true" CodeBehind="SavedJobs.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.SavedJobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .job-card {
            transition: all 0.3s ease;
            border-radius: 0.75rem;
        }
        .job-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .dark .job-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.25), 0 4px 6px -2px rgba(0, 0, 0, 0.1);
        }
        .tag {
            transition: all 0.2s ease;
        }
        .tag:hover {
            transform: scale(1.05);
        }
        .unsave-btn:hover {
            background-color: rgba(220, 38, 38, 0.1) !important;
            color: #dc2626 !important;
        }
        .dark .unsave-btn:hover {
            background-color: rgba(220, 38, 38, 0.2) !important;
        }
        .btn-with-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
    </style>
    
    <script type="text/javascript">
        function removeSavedJobItem(savedJobId) {
            const jobCard = document.querySelector(`div[data-savedjobid="${savedJobId}"]`);
            if (jobCard) {
                jobCard.style.transition = 'opacity 0.3s ease';
                jobCard.style.opacity = '0';
                setTimeout(() => {
                    jobCard.style.display = 'none';
                    const visibleCards = document.querySelectorAll('.job-card[style*="display: block"], .job-card:not([style*="display"])');
                    if (visibleCards.length === 0) {
                        document.getElementById('<%= pnlNoSavedJobs.ClientID %>').style.display = 'block';
                    }
                }, 300);
            }
        }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex flex-col">
        <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">Saved Jobs</h1>
        <p class="text-sm text-gray-600 dark:text-gray-300">Your collection of saved opportunities</p>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-white dark:bg-black rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">
        <!-- Debug Panel -->
        <asp:Panel ID="pnlDebug" runat="server" Visible="false" CssClass="bg-yellow-50/90 dark:bg-yellow-900/20 p-4 border-b border-yellow-200 dark:border-yellow-800">
            <div class="text-sm text-yellow-800 dark:text-yellow-200">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                Debug Information:<br />
                <asp:Literal ID="litDebugInfo" runat="server" />
            </div>
        </asp:Panel>

        <!-- Jobs List -->
        <div class="divide-y divide-gray-200/80 dark:divide-gray-800/80">
            <asp:Repeater ID="rptSavedJobs" runat="server" OnItemCommand="rptSavedJobs_ItemCommand">
                <ItemTemplate>
                    <div class="p-6 hover:bg-gray-50/50 dark:hover:bg-gray-800/30 transition-colors duration-200 job-card" data-savedjobid='<%# Eval("SavedJobId") %>'>
                        <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-6">
                            <div class="flex items-start gap-4 flex-1 min-w-0">
                                <div class="flex-shrink-0">
                                    <img src='<%# Eval("CompanyLogo") ?? ResolveUrl("~/Content/Images/default-company.png") %>' 
                                        alt='<%# Eval("CompanyName") %>' 
                                        class="h-14 w-14 rounded-xl object-cover border border-gray-200 dark:border-gray-700 shadow-sm" 
                                        onerror="this.src='<%# ResolveUrl("~/Content/Images/default-company.png") %>'" />
                                </div>
                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center gap-2 mb-1">
                                        <h3 class="text-lg font-bold text-gray-800 dark:text-gray-100">
                                            <asp:LinkButton runat="server" CommandName="ViewDetail" CommandArgument='<%# Eval("JobId") %>' 
                                                class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200">
                                                <%# Eval("JobTitle") %>
                                            </asp:LinkButton>
                                        </h3>
                                        <span class="text-xs px-2 py-1 bg-blue-100 dark:bg-blue-900/50 text-blue-800 dark:text-blue-200 rounded-full">
                                            Saved
                                        </span>
                                    </div>
                                    <p class="text-sm text-gray-600 dark:text-gray-300 mb-2">
                                        <i class="fas fa-building mr-1.5 opacity-70"></i>
                                        <%# Eval("CompanyName") %>
                                        <span class="mx-2">•</span>
                                        <i class="fas fa-map-marker-alt mr-1.5 opacity-70"></i>
                                        <%# Eval("Location") %>
                                    </p>
                                    <div class="flex flex-wrap gap-2 mb-3">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 dark:bg-blue-900/40 text-blue-800 dark:text-blue-200 tag">
                                            <i class="fas fa-briefcase mr-1.5 text-xs"></i>
                                            <%# Eval("JobType") %>
                                        </span>
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 dark:bg-green-900/40 text-green-800 dark:text-green-200 tag">
                                            <i class="fas fa-chart-line mr-1.5 text-xs"></i>
                                            <%# Eval("ExperienceLevel") %>
                                        </span>
                                        <%# (bool)Eval("IsRemote") ? 
                                            "<span class='inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-purple-100 dark:bg-purple-900/40 text-purple-800 dark:text-purple-200 tag'><i class='fas fa-home mr-1.5 text-xs'></i>Remote</span>" : "" %>
                                    </div>
                                    <p class="text-sm text-gray-600 dark:text-gray-400 line-clamp-2 mb-3">
                                        <%# Eval("Description") %>
                                    </p>
                                    <div class="flex items-center text-xs text-gray-500 dark:text-gray-400">
                                        <i class="fas fa-calendar-alt mr-1.5"></i>
                                        Posted <%# Convert.ToDateTime(Eval("PostedDate")).ToString("MMM dd, yyyy") %>
                                        <span class="mx-2">•</span>
                                        <i class="fas fa-bookmark mr-1.5"></i>
                                        Saved on <%# Convert.ToDateTime(Eval("SavedDate")).ToString("MMM dd, yyyy") %>
                                    </div>
                                </div>
                            </div>
                            <div class="flex flex-col items-end gap-3">
                                <div class="text-lg font-bold text-gray-800 dark:text-gray-100">
                                    <%# Eval("SalaryRange", "{0}") %>
                                </div>
                                <div class="flex flex-col sm:flex-row gap-2 w-full sm:w-auto">
                                    <asp:LinkButton runat="server" CommandName="UnsaveJob" CommandArgument='<%# Eval("SavedJobId") + "|" + Eval("JobId") %>'
                                        CssClass="btn-with-icon px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl text-gray-700 dark:text-gray-300 text-sm font-medium hover:bg-gray-100 dark:hover:bg-gray-700/50 shadow-sm hover:shadow-md transition-all duration-200 unsave-btn">
                                        <i class="fas fa-trash-alt mr-2 text-red-500"></i> Remove
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CommandName="ViewDetail" CommandArgument='<%# Eval("JobId") %>'
                                        CssClass="btn-with-icon px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-500 hover:from-blue-700 hover:to-blue-600 dark:from-blue-700 dark:to-blue-600 dark:hover:from-blue-800 dark:hover:to-blue-700 text-white text-sm font-medium rounded-xl shadow-sm hover:shadow-md transition-all duration-200">
                                        <i class="fas fa-arrow-right mr-2"></i> View Details
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <!-- Empty State -->
            <asp:Panel ID="pnlNoSavedJobs" runat="server" Visible="false" class="p-12 text-center">
                <div class="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-blue-50 dark:bg-blue-900/30 text-blue-500 dark:text-blue-400 mb-4">
                    <i class="fas fa-bookmark text-3xl"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-800 dark:text-gray-100 mb-2">No saved jobs yet</h3>
                <p class="text-gray-600 dark:text-gray-400 max-w-md mx-auto mb-6">When you find jobs you're interested in, save them to view and compare here.</p>
                <asp:HyperLink ID="hlBrowseJobs" runat="server" NavigateUrl="~/UserSite/Views/Jobs.aspx" 
                    class="mt-4 px-5 py-2.5 bg-gradient-to-r from-blue-600 to-blue-500 hover:from-blue-700 hover:to-blue-600 dark:from-blue-700 dark:to-blue-600 dark:hover:from-blue-800 dark:hover:to-blue-700 text-white font-medium rounded-xl shadow-sm hover:shadow-md transition-all duration-200 inline-flex items-center">
                    <i class="fas fa-search mr-2"></i> Browse Jobs
                </asp:HyperLink>
            </asp:Panel>
        </div>
    </div>
</asp:Content>