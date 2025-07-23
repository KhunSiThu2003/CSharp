<%@ Page Title="For Employers" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master"
    AutoEventWireup="true" CodeBehind="Employers.aspx.cs" Inherits="JobBridge.Pages.WebPages.Employers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .employer-card {
            transition: all 0.3s ease;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }

            .employer-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            }

        .company-logo {
            height: 80px;
            width: 80px;
            object-fit: contain;
            border-radius: 8px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }


        .benefit-icon {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.1) 0%, rgba(99, 102, 241, 0.1) 100%);
            border-radius: 12px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="hero-section py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-2 gap-12 items-center">
                <div class="text-center md:text-left">
                    <h1 class="text-4xl md:text-5xl font-bold mb-6">Hire the Best Talent</h1>
                    <p class="text-xl mb-8 max-w-lg mx-auto md:mx-0">
                        Connect with qualified candidates and streamline your hiring process with JobBridge's
                        powerful recruitment platform.
                    </p>
                    <div class="flex flex-col sm:flex-row gap-4 justify-center md:justify-start">
                        <asp:Button ID="btnPostJob" runat="server" Text="Post a Job Now"
                            OnClick="btnPostJob_Click"
                            CssClass="btn btn-primary text-white px-8 py-3 rounded-lg text-lg font-semibold" />
                    </div>
                </div>
                <div class="relative hidden md:block">
                    <div class="relative z-10">
                        <img src="https://www.aventec.net/images/meeting.jpg" alt="Team working together"
                            class="rounded-xl shadow-xl border border-gray-100 w-full max-w-lg mx-auto" />
                    </div>
                    <div class="absolute -bottom-6 -left-6 w-24 h-24 bg-blue-200 rounded-lg shadow-lg floating-delay hidden lg:block">
                    </div>
                    <div class="absolute -top-6 -right-6 w-20 h-20 bg-blue-100 rounded-full shadow-lg floating-delay hidden lg:block">
                    </div>
                </div>

            </div>
        </div>
    </section>

        <!-- Featured Employers Section -->
    <section class="py-16 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12">
                <h2 class="text-3xl font-bold text-gray-900 mb-4">Featured Employers</h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">Join these leading companies who
                    trust JobBridge for their hiring needs</p>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <asp:Repeater ID="rptFeaturedEmployers" runat="server">
                    <ItemTemplate>
                        <div class="employer-card bg-white p-6">
                            <div class="flex items-center mb-4">
                                <img src='<%# Eval("Logo") %>'
                                    alt='<%# Eval("CompanyName") %>' class="company-logo mr-4" />
                                <div>
                                    <h3 class="text-lg font-bold text-gray-900"><%# Eval("CompanyName") %></h3>
                                    <p class="text-gray-600 text-sm"><%# Eval("Industry") %></p>
                                </div>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500 text-sm">
                                    <i class="fas fa-map-marker-alt mr-1"></i>
                                    <%# Eval("Location") %>
                                </span>
                                <span class="text-primary font-medium">
                                    <%# Eval("JobCount") %> jobs
                                </span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Benefits Section -->
    <section class="py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-gray-900 mb-4">Why Choose JobBridge?</h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">Our platform is designed to make
                    your hiring process faster and more effective</p>
            </div>

            <div class="grid md:grid-cols-3 gap-8">
                <div class="p-8 rounded-xl">
                    <div class="benefit-icon mb-6">
                        <i class="fas fa-bullseye text-primary text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Targeted Matching</h3>
                    <p class="text-gray-600">Our AI matches your job requirements with qualified candidates,
                        saving you time.</p>
                </div>

                <div class="p-8 rounded-xl">
                    <div class="benefit-icon mb-6">
                        <i class="fas fa-tachometer-alt text-primary text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Faster Hiring</h3>
                    <p class="text-gray-600">Reduce time-to-hire with our streamlined application and review
                        process.</p>
                </div>

                <div class="p-8 rounded-xl">
                    <div class="benefit-icon mb-6">
                        <i class="fas fa-chart-line text-primary text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Quality Candidates</h3>
                    <p class="text-gray-600">Access pre-vetted professionals who match your specific requirements.
                    </p>
                </div>
            </div>
        </div>
    </section>


</asp:Content>
