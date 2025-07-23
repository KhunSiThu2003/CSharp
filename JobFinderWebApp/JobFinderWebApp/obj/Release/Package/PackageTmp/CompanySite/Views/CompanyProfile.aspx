<%@ Page Title="Company Profile" Language="C#" MasterPageFile="~/CompanySite/Views/Views.Master" AutoEventWireup="true" CodeBehind="CompanyProfile.aspx.cs" Inherits="JobFinderWebApp.CompanySite.Views.CompanyProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .logo-upload-container {
            position: relative;
            transition: all 0.3s ease;
            width: 160px;
            height: 160px;
        }
        .logo-upload-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
            border: 3px solid white;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        .logo-upload-overlay {
            position: absolute;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: rgba(79, 70, 229, 0.7);
            opacity: 0;
            transition: opacity 0.3s ease;
            border-radius: 12px;
            cursor: pointer;
        }
        .logo-upload-container:hover .logo-upload-overlay {
            opacity: 1;
        }
        .logo-upload-icon {
            color: white;
            font-size: 1.75rem;
            transition: transform 0.3s ease;
        }
        .logo-upload-container:hover .logo-upload-icon {
            transform: scale(1.1);
        }
        .profile-header {
            background: linear-gradient(135deg, #f0f4ff 0%, #e6f0ff 100%);
        }
        .dark .profile-header {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
        }
        .info-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .dark .info-card {
            background: #1e293b;
        }
        .info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .badge {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.35rem 0.75rem;
        }
        .section-title {
            position: relative;
            padding-bottom: 0.75rem;
        }
        .section-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 3px;
            background: #4f46e5;
            border-radius: 3px;
        }
        .dark .section-title:after {
            background: #818cf8;
        }
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #374151;
        }
        .dark .form-label {
            color: #e5e7eb;
        }
        .form-control {
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            border-radius: 8px;
            padding: 0.6rem 0.75rem;
        }
        .form-control:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.2);
        }
        .dark .form-control {
            background-color: #1f2937;
            border-color: #374151;
            color: #f3f4f6;
        }
        .dark .form-control:focus {
            border-color: #818cf8;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.3);
        }
        .description-textarea {
            min-height: 150px;
        }
        .save-btn {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            border: none;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        .save-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
        }
    </style>
    <script>
        function previewCompanyLogo(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var img = document.getElementById('<%= imgCompanyLogo.ClientID %>');
                    img.src = e.target.result;
                    img.onerror = function () {
                        this.src = 'https://ui-avatars.com/api/?name=' +
                            encodeURIComponent(document.getElementById('<%= txtCompanyName.ClientID %>').value || 'Company') +
                            '&background=4f46e5&color=fff&size=256';
                    }
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Company Profile</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Manage your company information and settings</p>
        </div>
        
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
        <!-- Company Header -->
        <div class="px-8 py-10 profile-header border-b border-gray-200 dark:border-gray-700">
            <div class="max-w-6xl mx-auto">
                <div class="flex flex-col md:flex-row items-center md:items-start gap-8">
                    <div class="logo-upload-container relative shrink-0">
                        <div class="relative rounded-xl bg-white dark:bg-gray-800 shadow-md h-full w-full">
                            <asp:Image ID="imgCompanyLogo" runat="server" 
                                CssClass="logo-upload-image" 
                                onerror="this.src='https://ui-avatars.com/api/?name='+encodeURIComponent(document.getElementById('<%= txtCompanyName.ClientID %>').value || 'Company')+'&background=4f46e5&color=fff&size=256'" />
                            <div class="logo-upload-overlay"
                                 onclick="document.getElementById('<%= fileCompanyLogo.ClientID %>').click()">
                                <i class="fas fa-camera logo-upload-icon"></i>
                            </div>
                        </div>
                        <asp:FileUpload ID="fileCompanyLogo" runat="server" style="display: none;" onchange="previewCompanyLogo(this)" accept="image/*" />
                        <asp:Label ID="lblLogoError" runat="server" CssClass="text-red-500 text-sm mt-2 block text-center" Visible="false"></asp:Label>
                    </div>
                    <div class="flex-1 text-center md:text-left">
                        <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">
                            <asp:Literal ID="litCompanyName" runat="server" />
                        </h2>
                        <div class="flex flex-wrap items-center justify-center md:justify-start gap-2 mb-4">
                            <span class="badge bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200 rounded-full">
                                <i class="fas fa-check-circle mr-1.5"></i> Verified Company
                            </span>
                            <span class="badge bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200 rounded-full">
                                <i class="fas fa-star mr-1.5"></i> Premium Member
                            </span>
                        </div>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div class="flex items-center justify-center md:justify-start">
                                <i class="fas fa-globe mr-3 text-blue-600 dark:text-blue-400 text-lg"></i>
                                <asp:HyperLink ID="lnkWebsite" runat="server" Target="_blank" CssClass="text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 hover:underline truncate" />
                            </div>
                            <div class="flex items-center justify-center md:justify-start">
                                <i class="fas fa-envelope mr-3 text-blue-600 dark:text-blue-400 text-lg"></i>
                                <span class="text-gray-700 dark:text-gray-300 truncate">
                                    <asp:Literal ID="litCompanyEmail" runat="server" />
                                </span>
                            </div>
                            <div class="flex items-center justify-center md:justify-start">
                                <i class="fas fa-phone mr-3 text-blue-600 dark:text-blue-400 text-lg"></i>
                                <span class="text-gray-700 dark:text-gray-300 truncate">
                                    <asp:Literal ID="litCompanyPhone" runat="server" Text="Not provided" />
                                </span>
                            </div>
                            <div class="flex items-center justify-center md:justify-start">
                                <i class="fas fa-map-marker-alt mr-3 text-blue-600 dark:text-blue-400 text-lg"></i>
                                <span class="text-gray-700 dark:text-gray-300 truncate">
                                    <asp:Literal ID="litCompanyLocation" runat="server" Text="Location not set" />
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Company Profile Content -->
        <div class="px-8 py-8">
            <div class="max-w-6xl mx-auto">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- Basic Information -->
                    <div class="info-card p-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-6 section-title">
                            <i class="fas fa-info-circle mr-2 text-blue-600 dark:text-blue-400"></i>
                            Basic Information
                        </h3>
                        <div class="space-y-5">
                            <div>
                                <label class="form-label block">Company Name</label>
                                <asp:TextBox ID="txtCompanyName" runat="server" 
                                    CssClass="form-control w-full border border-gray-300 dark:border-gray-600 focus:ring-blue-500 focus:border-blue-500" />
                            </div>
                            <div>
                                <label class="form-label block">Industry</label>
                                <asp:DropDownList ID="ddlIndustry" runat="server" 
                                    CssClass="form-control w-full border border-gray-300 dark:border-gray-600 focus:ring-blue-500 focus:border-blue-500">
                                    <asp:ListItem Text="Select Industry" Value="" />
                                    <asp:ListItem Text="Technology" Value="Technology" />
                                    <asp:ListItem Text="Finance" Value="Finance" />
                                    <asp:ListItem Text="Healthcare" Value="Healthcare" />
                                    <asp:ListItem Text="Education" Value="Education" />
                                    <asp:ListItem Text="Manufacturing" Value="Manufacturing" />
                                    <asp:ListItem Text="Retail" Value="Retail" />
                                    <asp:ListItem Text="Other" Value="Other" />
                                </asp:DropDownList>
                            </div>
                            <div>
                                <label class="form-label block">Website</label>
                                <div class="flex">
                                    <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 text-gray-500 dark:text-gray-400 text-sm">
                                        https://
                                    </span>
                                    <asp:TextBox ID="txtWebsite" runat="server" 
                                        CssClass="form-control flex-1 rounded-r-md border-l-0 focus:ring-blue-500 focus:border-blue-500" 
                                        placeholder="yourcompany.com" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Information -->
                    <div class="info-card p-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-6 section-title">
                            <i class="fas fa-address-card mr-2 text-blue-600 dark:text-blue-400"></i>
                            Contact Information
                        </h3>
                        <div class="space-y-5">
                            <div>
                                <label class="form-label block">Email</label>
                                <asp:TextBox ID="txtCompanyEmail" runat="server" 
                                    CssClass="form-control w-full border border-gray-300 dark:border-gray-600 focus:ring-blue-500 focus:border-blue-500" 
                                    TextMode="Email" />
                            </div>
                            <div>
                                <label class="form-label block">Phone</label>
                                <asp:TextBox ID="txtCompanyPhone" runat="server" 
                                    CssClass="form-control w-full border border-gray-300 dark:border-gray-600 focus:ring-blue-500 focus:border-blue-500" 
                                    placeholder="+1 (555) 123-4567" />
                            </div>
                            <div>
                                <label class="form-label block">Location</label>
                                <asp:TextBox ID="txtCompanyLocation" runat="server" 
                                    CssClass="form-control w-full border border-gray-300 dark:border-gray-600 focus:ring-blue-500 focus:border-blue-500" 
                                    placeholder="City, Country" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Company Description -->
                <div class="mt-8 info-card p-6">
                    <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-6 section-title">
                        <i class="fas fa-align-left mr-2 text-blue-600 dark:text-blue-400"></i>
                        Company Description
                    </h3>
                    <div>
                        <asp:TextBox ID="txtCompanyDescription" runat="server" 
                            CssClass="form-control w-full border border-gray-300 dark:border-gray-600 focus:ring-blue-500 focus:border-blue-500 description-textarea" 
                            TextMode="MultiLine" Rows="6" placeholder="Tell us about your company's mission, values, and what makes you unique..." />
                    </div>
                </div>

                <!-- Save Changes Button at Bottom -->
                <div class="mt-8 flex justify-end">
                    <asp:Button ID="Button1" runat="server" Text="Save Changes" 
                        CssClass="px-8 py-3 save-btn text-white rounded-lg transition-all duration-200 text-lg font-medium" 
                        OnClick="btnSaveProfile_Click" />
                </div>

            </div>
        </div>
    </div>
</asp:Content>