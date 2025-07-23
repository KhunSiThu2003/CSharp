<%@ Page Title="" Language="C#" MasterPageFile="~/CompanySite/AuthPages/AuthPages.Master" AutoEventWireup="true" CodeBehind="CompanyVerifyEmail.aspx.cs" Inherits="JobFinderWebApp.CompanySite.AuthPages.CompanyVerifyEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        /* Mobile-specific styles */
        @media (max-width: 640px) {
            .login-container {
                min-height: 100vh;
                padding: 0;
                align-items: stretch;
            }
            .login-card {
                width: 100%;
                max-width: 100%;
                height: 100vh;
                border-radius: 0;
                border: none;
                box-shadow: none;
                flex: 1;
                display: flex;
                flex-direction: column;
            }
            .card-content {
                flex: 1;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container min-h-screen bg-gradient-to-b from-indigo-50 to-white flex items-center justify-center">

        <!-- Main Card -->
        <div class="login-card bg-white md:rounded-xl shadow-md overflow-hidden border border-gray-100 w-full max-w-md">

            <!-- Header -->
            <div class="bg-indigo-600 text-white p-6 text-center">
                <div class="flex justify-center mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                    </svg>
                </div>
                <h1 class="text-3xl font-bold">JobFinder</h1>
                <p class="mt-2 text-indigo-100">For Companies</p>
            </div>

            <div class="card-content p-6 sm:p-8">
                <div class="text-center mb-6">
                    <h1 class="mt-4 text-2xl font-bold text-gray-900">Verify Your Email</h1>
                    <p class="mt-2 text-sm text-gray-600">
                        We've sent a verification code to your company email address
                    </p>
                </div>

                <div class="space-y-6">
                    <div>
                        <label for="txtVerificationCode" class="block text-sm font-medium text-gray-700 mb-1">
                            Verification Code
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                </svg>
                            </div>
                            <asp:TextBox ID="txtVerificationCode" runat="server" MaxLength="6"
                                CssClass="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                placeholder="123456"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvCode" runat="server"
                            ControlToValidate="txtVerificationCode" ErrorMessage="Verification code is required"
                            CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <asp:Button ID="btnVerify" runat="server" Text="Verify" OnClick="btnVerify_Click"
                            CssClass="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200" />
                    </div>

                    <div class="text-center text-sm">
                        <span class="text-gray-600">Didn't receive code?</span>
                        <asp:LinkButton ID="btnResendCode" runat="server" OnClick="btnResendCode_Click"
                            CssClass="font-medium text-indigo-600 hover:text-indigo-500 ml-1">
                            Resend Verification Code
                        </asp:LinkButton>
                    </div>

                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="mt-6">
                        <div class="rounded-lg bg-red-50 p-4">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"
                                        fill="currentColor">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm font-medium text-red-800">
                                        <asp:Literal ID="litErrorMessage" runat="server"></asp:Literal>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                <div class="text-sm text-center text-gray-600">
                    Need help? <a href="Contact.aspx" class="font-medium text-indigo-600 hover:text-indigo-500">Contact support</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
</asp:Content>