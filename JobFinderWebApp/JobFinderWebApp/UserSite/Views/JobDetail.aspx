<%@ Page Title="Job Details" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master" AutoEventWireup="true" CodeBehind="JobDetail.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.JobDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .job-header {
            background: linear-gradient(135deg, #f5f7fa 0%, #e6e9f0 100%);
            border-radius: 0.75rem;
        }
        .dark .job-header {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .apply-form {
            border-left: 1px solid rgba(229, 231, 235, 0.5);
        }
        .dark .apply-form {
            border-left: 1px solid rgba(55, 65, 81, 0.5);
        }
        .info-card {
            transition: all 0.3s ease;
            border-radius: 0.75rem;
        }
        .info-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .dark .info-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.25), 0 4px 6px -2px rgba(0, 0, 0, 0.1);
        }
        .tag {
            transition: all 0.2s ease;
        }
        .tag:hover {
            transform: scale(1.05);
        }
        .save-btn {
            min-width: 120px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center gap-4">
        <asp:HyperLink runat="server" NavigateUrl="~/UserSite/Views/Jobs.aspx" 
            class="flex items-center text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition-colors">
            <i class="fas fa-arrow-left mr-2"></i>Back to Jobs
        </asp:HyperLink>
        <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">Job Details</h1>
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

        <!-- Job Details -->
        <div class="flex flex-col lg:flex-row">
            <!-- Job Information -->
            <div class="flex-1 p-6">
                <div class="job-header p-6 mb-6">
                    <div class="flex flex-col md:flex-row md:items-center gap-6">
                        <div class="flex-shrink-0">
                            <asp:Image ID="imgCompanyLogo" runat="server" 
                                class="h-16 w-16 rounded-xl object-cover border border-gray-200 dark:border-gray-700 shadow-sm" />
                        </div>
                        <div class="flex-1">
                            <h2 class="text-2xl font-bold text-gray-800 dark:text-gray-100 mb-2">
                                <asp:Literal ID="litJobTitle" runat="server" />
                            </h2>
                            <p class="text-lg text-gray-600 dark:text-gray-300 mb-1">
                                <asp:Literal ID="litCompanyName" runat="server" />
                                <span class="mx-2">•</span>
                                <asp:Literal ID="litLocation" runat="server" />
                            </p>
                            <div class="flex flex-wrap gap-2 mt-3">
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 dark:bg-blue-900/40 text-blue-800 dark:text-blue-200 tag">
                                    <i class="fas fa-briefcase mr-1.5 text-xs"></i>
                                    <asp:Literal ID="litJobType" runat="server" />
                                </span>
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 dark:bg-green-900/40 text-green-800 dark:text-green-200 tag">
                                    <i class="fas fa-chart-line mr-1.5 text-xs"></i>
                                    <asp:Literal ID="litExperienceLevel" runat="server" />
                                </span>
                                <asp:Panel ID="pnlRemote" runat="server" Visible="false" CssClass="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-purple-100 dark:bg-purple-900/40 text-purple-800 dark:text-purple-200 tag">
                                    <i class="fas fa-home mr-1.5 text-xs"></i>Remote
                                </asp:Panel>
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 dark:bg-yellow-900/40 text-yellow-800 dark:text-yellow-200 tag">
                                    <i class="fas fa-money-bill-wave mr-1.5 text-xs"></i>
                                    <asp:Literal ID="litSalaryRange" runat="server" />
                                </span>
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gray-100 dark:bg-gray-700/50 text-gray-800 dark:text-gray-200 tag">
                                    <i class="fas fa-calendar-alt mr-1.5 text-xs"></i>
                                    Posted: <asp:Literal ID="litPostedDate" runat="server" />
                                </span>
                            </div>
                        </div>
                        <div class="flex-shrink-0">
                            <asp:Button ID="btnSaveJob" runat="server" 
                                OnClick="btnSaveJob_Click"
                                CssClass="save-btn px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700/50 shadow-sm hover:shadow-md transition-all duration-200 flex items-center justify-center"
                                Text="Save Job" />
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <div class="info-card bg-gray-50/50 dark:bg-gray-800/30 p-6 rounded-xl border border-gray-200 dark:border-gray-700">
                        <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-100 mb-4 flex items-center">
                            <i class="fas fa-file-alt mr-2 text-blue-500 dark:text-blue-400"></i>
                            Job Description
                        </h3>
                        <div class="prose dark:prose-invert max-w-none text-gray-600 dark:text-gray-300">
                            <asp:Literal ID="litDescription" runat="server" />
                        </div>
                    </div>

                    <div class="info-card bg-gray-50/50 dark:bg-gray-800/30 p-6 rounded-xl border border-gray-200 dark:border-gray-700">
                        <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-100 mb-4 flex items-center">
                            <i class="fas fa-list-check mr-2 text-blue-500 dark:text-blue-400"></i>
                            Requirements
                        </h3>
                        <div class="prose dark:prose-invert max-w-none text-gray-600 dark:text-gray-300">
                            <asp:Literal ID="litRequirements" runat="server" />
                        </div>
                    </div>
                </div>

                <!-- Company Details Card -->
                <div class="info-card bg-gray-50/50 dark:bg-gray-800/30 p-6 rounded-xl border border-gray-200 dark:border-gray-700 mb-8">
                    <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-100 mb-4 flex items-center">
                        <i class="fas fa-building mr-2 text-blue-500 dark:text-blue-400"></i>
                        About the Company
                    </h3>
                    <div class="flex flex-col md:flex-row gap-6">
                        <asp:Image ID="imgCompanyLogoLarge" runat="server" 
                            class="h-24 w-24 rounded-xl object-cover border border-gray-200 dark:border-gray-700 shadow-sm" />
                        <div class="flex-1">
                            <h4 class="text-lg font-medium text-gray-800 dark:text-gray-100 mb-2">
                                <asp:Literal ID="litCompanyNameLarge" runat="server" />
                            </h4>
                            <div class="text-gray-600 dark:text-gray-300 mb-4">
                                <asp:Literal ID="litCompanyDescription" runat="server" />
                            </div>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <p class="text-sm text-gray-500 dark:text-gray-400">Industry</p>
                                    <p class="text-gray-700 dark:text-gray-200">
                                        <asp:Literal ID="litIndustry" runat="server" />
                                    </p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500 dark:text-gray-400">Location</p>
                                    <p class="text-gray-700 dark:text-gray-200">
                                        <asp:Literal ID="litCompanyLocation" runat="server" />
                                    </p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500 dark:text-gray-400">Email</p>
                                    <p class="text-gray-700 dark:text-gray-200">
                                        <asp:Literal ID="litCompanyEmail" runat="server" />
                                    </p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500 dark:text-gray-400">Phone</p>
                                    <p class="text-gray-700 dark:text-gray-200">
                                        <asp:Literal ID="litCompanyPhone" runat="server" />
                                    </p>
                                </div>
                            </div>
                            <div class="mt-4 flex flex-wrap gap-2">
                                <asp:HyperLink ID="hlCompanyWebsite" runat="server" Target="_blank"
                                    CssClass="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gray-100 dark:bg-gray-700/50 text-gray-800 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors">
                                    <i class="fas fa-globe mr-2"></i>Website
                                </asp:HyperLink>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Application Form -->
            <div class="lg:w-96 p-6 apply-form">
                <div class="sticky top-6">
                    <asp:Panel ID="pnlAlreadyApplied" runat="server" Visible="false" 
                        CssClass="bg-green-50/80 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-xl p-4 mb-6">
                        <div class="flex items-center gap-3">
                            <i class="fas fa-check-circle text-green-500 dark:text-green-400 text-xl"></i>
                            <div>
                                <h3 class="text-lg font-medium text-green-800 dark:text-green-200">Application Submitted</h3>
                                <p class="text-sm text-green-600 dark:text-green-300">
                                    You applied on <asp:Literal ID="litApplicationDate" runat="server" />
                                </p>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlApplyForm" runat="server" CssClass="info-card bg-gray-50/50 dark:bg-gray-800/30 border border-gray-200 dark:border-gray-700 rounded-xl p-6">
                        <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-100 mb-4 flex items-center">
                            <i class="fas fa-paper-plane mr-2 text-blue-500 dark:text-blue-400"></i>
                            Apply for this position
                        </h3>
                        
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" 
                                    CssClass="w-full px-3 py-2 border border-gray-200 dark:border-gray-700 dark:bg-gray-800/50 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors" />
                                <asp:RequiredFieldValidator ID="rfvFullName" runat="server" 
                                    ControlToValidate="txtFullName" ErrorMessage="Required" 
                                    CssClass="text-red-500 text-sm" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                                    CssClass="w-full px-3 py-2 border border-gray-200 dark:border-gray-700 dark:bg-gray-800/50 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors" />
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                    ControlToValidate="txtEmail" ErrorMessage="Required" 
                                    CssClass="text-red-500 text-sm" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                    ControlToValidate="txtEmail" ErrorMessage="Invalid email format"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                    CssClass="text-red-500 text-sm" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Phone</label>
                                <asp:TextBox ID="txtPhone" runat="server" 
                                    CssClass="w-full px-3 py-2 border border-gray-200 dark:border-gray-700 dark:bg-gray-800/50 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Address</label>
                                <asp:TextBox ID="txtAddress" runat="server" 
                                    CssClass="w-full px-3 py-2 border border-gray-200 dark:border-gray-700 dark:bg-gray-800/50 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Cover Letter</label>
                                <asp:TextBox ID="txtCoverLetter" runat="server" TextMode="MultiLine" Rows="4"
                                    CssClass="w-full px-3 py-2 border border-gray-200 dark:border-gray-700 dark:bg-gray-800/50 dark:text-gray-200 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Resume/CV</label>
                                <div class="mt-1 flex items-center">
                                    <asp:FileUpload ID="fuResume" runat="server" 
                                        CssClass="block w-full text-sm text-gray-500 dark:text-gray-400
                                        file:mr-4 file:py-2 file:px-4
                                        file:rounded-lg file:border-0
                                        file:text-sm file:font-semibold
                                        file:bg-blue-50 dark:file:bg-blue-900/50 file:text-blue-700 dark:file:text-blue-300
                                        hover:file:bg-blue-100 dark:hover:file:bg-blue-900/30" />
                                </div>
                                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">PDF, DOC, or DOCX (Max. 5MB)</p>
                                <asp:CustomValidator ID="cvResume" runat="server" 
                                    OnServerValidate="ValidateResume"
                                    ErrorMessage="Please upload a valid resume file (PDF, DOC, or DOCX)"
                                    CssClass="text-red-500 text-sm" Display="Dynamic" />
                            </div>

                            <div>
                                <asp:Button ID="btnSubmitApplication" runat="server" Text="Submit Application" 
                                    OnClick="btnSubmitApplication_Click"
                                    CssClass="w-full px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-500 hover:from-blue-700 hover:to-blue-600 dark:from-blue-700 dark:to-blue-600 dark:hover:from-blue-800 dark:hover:to-blue-700 text-white font-medium rounded-lg shadow-sm hover:shadow-md transition-all duration-200" />
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>