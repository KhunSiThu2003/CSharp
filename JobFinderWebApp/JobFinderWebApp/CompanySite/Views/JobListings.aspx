<%@ Page Title="Job Listings" Language="C#" MasterPageFile="~/CompanySite/Views/Views.Master" AutoEventWireup="true" 
    CodeBehind="JobListings.aspx.cs" Inherits="JobFinderWebApp.CompanySite.Views.JobListings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- SweetAlert CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        .job-card {
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }
        .job-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            border-left: 4px solid #6366f1;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.35em 0.65em;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Job Listings</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage your posted jobs</p>
        </div>
        <asp:HyperLink ID="lnkPostJob" runat="server" NavigateUrl="~/CompanySite/Views/PostJob.aspx" 
            class="inline-flex items-center px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors duration-200">
            <i class="fas fa-plus mr-2"></i> Post New Job
        </asp:HyperLink>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Search and Filter Section -->
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-6 mb-8 border border-gray-200 dark:border-gray-700">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Search</label>
                <asp:TextBox ID="txtSearch" runat="server" 
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white"
                    placeholder="Job title or description"></asp:TextBox>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" 
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white">
                    <asp:ListItem Text="All Statuses" Value="all" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Active" Value="active"></asp:ListItem>
                    <asp:ListItem Text="Expired" Value="expired"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Job Type</label>
                <asp:DropDownList ID="ddlJobTypeFilter" runat="server" 
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-700 dark:text-white">
                    <asp:ListItem Text="All Types" Value="all" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Full-time" Value="Full-time"></asp:ListItem>
                    <asp:ListItem Text="Part-time" Value="Part-time"></asp:ListItem>
                    <asp:ListItem Text="Contract" Value="Contract"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="flex items-end">
                <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" 
                    class="w-full px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                    OnClick="btnFilter_Click" />
            </div>
        </div>
    </div>

    <!-- Job Listings -->
    <asp:Repeater ID="rptJobs" runat="server">
        <ItemTemplate>
            <div class="job-card bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 mb-6">
                <div class="flex flex-col sm:flex-row gap-6">
                    <div class="flex-1">
                        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 mb-3">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white"><%# Eval("Title") %></h3>
                            <span class='status-badge inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium <%# (bool)Eval("IsActive") && DateTime.Now <= (DateTime)Eval("ExpiryDate") ? "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200" : "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200" %>'>
                                <%# (bool)Eval("IsActive") && DateTime.Now <= (DateTime)Eval("ExpiryDate") ? "Active" : "Expired" %>
                            </span>
                        </div>
                        
                        <div class="flex flex-wrap gap-x-4 gap-y-2 mb-4">
                            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                <i class="fas fa-briefcase mr-2 text-indigo-500"></i>
                                <%# Eval("JobType") %>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                <i class="fas fa-map-marker-alt mr-2 text-indigo-500"></i>
                                <%# (bool)Eval("IsRemote") ? "Remote" : Eval("Location") %>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                <i class="fas fa-money-bill-wave mr-2 text-indigo-500"></i>
                                <%# Eval("SalaryRange") %>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                <i class="fas fa-clock mr-2 text-indigo-500"></i>
                                Posted: <%# ((DateTime)Eval("PostedDate")).ToString("MMM dd, yyyy") %>
                            </div>
                        </div>
                        
                        <p class="text-gray-600 dark:text-gray-400 mb-4 line-clamp-2"><%# Eval("Description") %></p>
                        
                        <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                            <i class="fas fa-users mr-2 text-indigo-500"></i>
                            <%# Eval("ApplicationCount") %> applicants
                        </div>
                    </div>
                    
                    <div class="flex sm:flex-col gap-2 sm:w-40">
                        <asp:HyperLink ID="btnView" runat="server" NavigateUrl='<%# $"~/CompanySite/Views/JobDetails.aspx?id={Eval("JobId")}" %>'
                            class="flex items-center justify-center px-4 py-2 bg-indigo-50 hover:bg-indigo-100 dark:bg-indigo-900/30 dark:hover:bg-indigo-800/50 text-indigo-600 dark:text-indigo-300 rounded-lg transition-colors duration-200">
                            <i class="fas fa-eye mr-2"></i> View
                        </asp:HyperLink>
                        <asp:HyperLink ID="btnEdit" runat="server" NavigateUrl='<%# $"~/CompanySite/Views/EditJob.aspx?id={Eval("JobId")}" %>'
                            class="flex items-center justify-center px-4 py-2 bg-green-50 hover:bg-green-100 dark:bg-green-900/30 dark:hover:bg-green-800/50 text-green-600 dark:text-green-300 rounded-lg transition-colors duration-200">
                            <i class="fas fa-edit mr-2"></i> Edit
                        </asp:HyperLink>
                        <button type="button" onclick='confirmDelete("<%# Eval("JobId") %>")'
                            class="flex items-center justify-center px-4 py-2 bg-red-50 hover:bg-red-100 dark:bg-red-900/30 dark:hover:bg-red-800/50 text-red-600 dark:text-red-300 rounded-lg transition-colors duration-200">
                            <i class="fas fa-trash-alt mr-2"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Empty State -->
    <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-12 text-center border border-gray-200 dark:border-gray-700">
        <div class="mx-auto max-w-md">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
                <i class="fas fa-briefcase text-gray-500 dark:text-gray-400"></i>
            </div>
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">No jobs found</h3>
            <p class="text-gray-500 dark:text-gray-400 mb-6">You haven't posted any jobs yet or no jobs match your filters.</p>
            <asp:HyperLink ID="lnkEmptyPostJob" runat="server" NavigateUrl="~/CompanySite/Views/PostJob.aspx" 
                class="inline-flex items-center px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md">
                <i class="fas fa-plus mr-2"></i> Post Your First Job
            </asp:HyperLink>
        </div>
    </asp:Panel>

    <!-- Pagination -->
    <div class="flex justify-center mt-8" runat="server" id="divPagination" visible="false">
        <div class="flex items-center gap-2">
            <asp:Button ID="btnPrev" runat="server" Text="Previous" 
                class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" 
                OnClick="btnPrev_Click" />
            <span class="px-4 py-2 text-gray-700 dark:text-gray-300 text-sm font-medium">
                Page <asp:Literal ID="litCurrentPage" runat="server"></asp:Literal> of <asp:Literal ID="litTotalPages" runat="server"></asp:Literal>
            </span>
            <asp:Button ID="btnNext" runat="server" Text="Next" 
                class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" 
                OnClick="btnNext_Click" />
        </div>
    </div>

    <!-- SweetAlert JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function confirmDelete(jobId) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!',
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    return fetch('<%= ResolveUrl("~/CompanySite/Views/JobListings.aspx/DeleteJob") %>', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            jobId: jobId,
                            companyId: '<%= Session["CompanyId"] %>'
                        })
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(response.statusText)
                        }
                        return response.json()
                    })
                    .then(data => {
                        if (data.d.includes('error:')) {
                            throw new Error(data.d.replace('error:', ''))
                        }
                        return data.d.replace('success:', '')
                    })
                    .catch(error => {
                        Swal.showValidationMessage(
                            `Request failed: ${error}`
                        )
                    })
                },
                allowOutsideClick: () => !Swal.isLoading()
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire(
                        'Deleted!',
                        'The job has been deleted.',
                        'success'
                    ).then(() => {
                        window.location.reload();
                    })
                }
            })
        }
    </script>
</asp:Content>