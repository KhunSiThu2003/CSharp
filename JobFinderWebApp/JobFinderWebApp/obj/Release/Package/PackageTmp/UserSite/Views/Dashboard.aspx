<%@ Page Title="" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stat-card {
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        .job-card {
            transition: all 0.2s ease;
        }
        .job-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .progress-bar {
            height: 6px;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center">
        <h1 class="text-2xl font-bold text-gray-900">Dashboard</h1>
        <div class="ml-4 text-sm text-gray-500">Welcome back, <asp:Literal ID="litUserName" runat="server" />!</div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="space-y-6">
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- Applications Card -->
            <div class="stat-card bg-white p-6 rounded-lg shadow border border-gray-100">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Applications</p>
                        <p class="text-3xl font-bold text-gray-900">24</p>
                    </div>
                    <div class="p-3 rounded-full bg-indigo-100 text-indigo-600">
                        <i class="fas fa-file-alt text-xl"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="flex items-center text-sm text-green-600">
                        <i class="fas fa-arrow-up mr-1"></i>
                        <span>12% from last month</span>
                    </div>
                </div>
            </div>

            <!-- Interviews Card -->
            <div class="stat-card bg-white p-6 rounded-lg shadow border border-gray-100">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Interviews</p>
                        <p class="text-3xl font-bold text-gray-900">5</p>
                    </div>
                    <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                        <i class="fas fa-handshake text-xl"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="flex items-center text-sm text-green-600">
                        <i class="fas fa-arrow-up mr-1"></i>
                        <span>2 new this week</span>
                    </div>
                </div>
            </div>

            <!-- Saved Jobs Card -->
            <div class="stat-card bg-white p-6 rounded-lg shadow border border-gray-100">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Saved Jobs</p>
                        <p class="text-3xl font-bold text-gray-900">14</p>
                    </div>
                    <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
                        <i class="fas fa-bookmark text-xl"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="flex items-center text-sm text-gray-500">
                        <i class="fas fa-exchange-alt mr-1"></i>
                        <span>3 added recently</span>
                    </div>
                </div>
            </div>

            <!-- Profile Strength Card -->
            <div class="stat-card bg-white p-6 rounded-lg shadow border border-gray-100">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Profile Strength</p>
                        <p class="text-3xl font-bold text-gray-900">85%</p>
                    </div>
                    <div class="p-3 rounded-full bg-green-100 text-green-600">
                        <i class="fas fa-user-check text-xl"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="w-full bg-gray-200 rounded-full h-2.5">
                        <div class="bg-green-600 h-2.5 rounded-full" style="width: 85%"></div>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Complete your profile for better matches</p>
                </div>
            </div>
        </div>

        <!-- Recent Activity and Recommended Jobs -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Recent Activity -->
            <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow border border-gray-100">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-lg font-medium text-gray-900">Recent Activity</h3>
                    <a href="/UserSite/Applications.aspx" class="text-sm text-indigo-600 hover:text-indigo-800">View All</a>
                </div>

                <div class="space-y-4">
                    <!-- Activity Item 1 -->
                    <div class="flex items-start pb-4 border-b border-gray-100">
                        <div class="p-2 rounded-full bg-indigo-100 text-indigo-600 mr-4">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Application submitted</p>
                            <p class="text-sm text-gray-500">Senior Product Designer at TechCorp</p>
                            <p class="text-xs text-gray-400 mt-1">2 hours ago</p>
                        </div>
                        <span class="text-xs px-2 py-1 bg-green-100 text-green-800 rounded-full">New</span>
                    </div>

                    <!-- Activity Item 2 -->
                    <div class="flex items-start pb-4 border-b border-gray-100">
                        <div class="p-2 rounded-full bg-blue-100 text-blue-600 mr-4">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Interview scheduled</p>
                            <p class="text-sm text-gray-500">UX Researcher at DesignHub</p>
                            <p class="text-xs text-gray-400 mt-1">1 day ago</p>
                        </div>
                        <span class="text-xs px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full">Upcoming</span>
                    </div>

                    <!-- Activity Item 3 -->
                    <div class="flex items-start pb-4 border-b border-gray-100">
                        <div class="p-2 rounded-full bg-purple-100 text-purple-600 mr-4">
                            <i class="fas fa-eye"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Profile viewed</p>
                            <p class="text-sm text-gray-500">By HR at CreativeMinds</p>
                            <p class="text-xs text-gray-400 mt-1">2 days ago</p>
                        </div>
                    </div>

                    <!-- Activity Item 4 -->
                    <div class="flex items-start">
                        <div class="p-2 rounded-full bg-green-100 text-green-600 mr-4">
                            <i class="fas fa-bookmark"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Job saved</p>
                            <p class="text-sm text-gray-500">Frontend Developer at WebSolutions</p>
                            <p class="text-xs text-gray-400 mt-1">3 days ago</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recommended Jobs -->
            <div class="bg-white p-6 rounded-lg shadow border border-gray-100">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-lg font-medium text-gray-900">Recommended Jobs</h3>
                    <a href="/UserSite/Jobs.aspx" class="text-sm text-indigo-600 hover:text-indigo-800">View All</a>
                </div>

                <div class="space-y-4">
                    <!-- Job Card 1 -->
                    <div class="job-card p-4 border border-gray-200 rounded-lg hover:border-indigo-200">
                        <div class="flex items-start">
                            <div class="h-12 w-12 bg-indigo-100 rounded-lg flex items-center justify-center mr-4">
                                <i class="fas fa-briefcase text-indigo-600"></i>
                            </div>
                            <div class="flex-1">
                                <h4 class="font-medium text-gray-900">Senior UX Designer</h4>
                                <p class="text-sm text-gray-600">TechVision Inc.</p>
                                <div class="flex items-center mt-2 text-sm text-gray-500">
                                    <i class="fas fa-map-marker-alt mr-1"></i>
                                    <span>Remote</span>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 flex justify-between items-center">
                            <span class="px-2 py-1 bg-indigo-100 text-indigo-800 text-xs font-medium rounded">Full-time</span>
                            <span class="text-sm font-medium text-gray-900">$95k - $120k</span>
                        </div>
                    </div>

                    <!-- Job Card 2 -->
                    <div class="job-card p-4 border border-gray-200 rounded-lg hover:border-indigo-200">
                        <div class="flex items-start">
                            <div class="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
                                <i class="fas fa-code text-blue-600"></i>
                            </div>
                            <div class="flex-1">
                                <h4 class="font-medium text-gray-900">Frontend Developer</h4>
                                <p class="text-sm text-gray-600">WebCraft Studios</p>
                                <div class="flex items-center mt-2 text-sm text-gray-500">
                                    <i class="fas fa-map-marker-alt mr-1"></i>
                                    <span>New York, NY</span>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 flex justify-between items-center">
                            <span class="px-2 py-1 bg-blue-100 text-blue-800 text-xs font-medium rounded">Full-time</span>
                            <span class="text-sm font-medium text-gray-900">$85k - $110k</span>
                        </div>
                    </div>

                    <!-- Job Card 3 -->
                    <div class="job-card p-4 border border-gray-200 rounded-lg hover:border-indigo-200">
                        <div class="flex items-start">
                            <div class="h-12 w-12 bg-green-100 rounded-lg flex items-center justify-center mr-4">
                                <i class="fas fa-server text-green-600"></i>
                            </div>
                            <div class="flex-1">
                                <h4 class="font-medium text-gray-900">DevOps Engineer</h4>
                                <p class="text-sm text-gray-600">CloudScale</p>
                                <div class="flex items-center mt-2 text-sm text-gray-500">
                                    <i class="fas fa-map-marker-alt mr-1"></i>
                                    <span>San Francisco, CA</span>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 flex justify-between items-center">
                            <span class="px-2 py-1 bg-green-100 text-green-800 text-xs font-medium rounded">Contract</span>
                            <span class="text-sm font-medium text-gray-900">$70 - $90/hr</span>
                        </div>
                    </div>
                </div>

                <div class="mt-6">
                    <a href="/UserSite/Jobs.aspx" class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                        See More Recommendations
                    </a>
                </div>
            </div>
        </div>

        <!-- Profile Completion -->
        <div class="bg-white p-6 rounded-lg shadow border border-gray-100">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-lg font-medium text-gray-900">Complete Your Profile</h3>
                <div class="text-sm text-gray-500">85% completed</div>
            </div>

            <div class="w-full bg-gray-200 rounded-full h-2 mb-6">
                <div class="bg-indigo-600 h-2 rounded-full" style="width: 85%"></div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div class="flex items-center">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-green-100 flex items-center justify-center text-green-600 mr-3">
                        <i class="fas fa-check"></i>
                    </div>
                    <div>
                        <p class="text-sm font-medium text-gray-900">Basic Info</p>
                        <p class="text-xs text-gray-500">Completed</p>
                    </div>
                </div>

                <div class="flex items-center">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-green-100 flex items-center justify-center text-green-600 mr-3">
                        <i class="fas fa-check"></i>
                    </div>
                    <div>
                        <p class="text-sm font-medium text-gray-900">Experience</p>
                        <p class="text-xs text-gray-500">3 entries</p>
                    </div>
                </div>

                <div class="flex items-center">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-yellow-100 flex items-center justify-center text-yellow-600 mr-3">
                        <i class="fas fa-exclamation"></i>
                    </div>
                    <div>
                        <p class="text-sm font-medium text-gray-900">Education</p>
                        <p class="text-xs text-gray-500">Add more</p>
                    </div>
                </div>

                <div class="flex items-center">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-red-100 flex items-center justify-center text-red-600 mr-3">
                        <i class="fas fa-times"></i>
                    </div>
                    <div>
                        <p class="text-sm font-medium text-gray-900">Skills</p>
                        <p class="text-xs text-gray-500">Not started</p>
                    </div>
                </div>
            </div>

            <div class="mt-6">
                <a href="/UserSite/Profile.aspx" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700">
                    Complete Profile
                </a>
            </div>
        </div>
    </div>
</asp:Content>
