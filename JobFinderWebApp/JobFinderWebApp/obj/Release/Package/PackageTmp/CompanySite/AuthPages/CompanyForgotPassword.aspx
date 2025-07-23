<%@ Page Title="" Language="C#" MasterPageFile="~/CompanySite/AuthPages/AuthPages.Master" AutoEventWireup="true" CodeBehind="CompanyForgotPassword.aspx.cs" Inherits="JobFinderWebApp.CompanySite.AuthPages.CompanyForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        .password-toggle {
            transition: all 0.2s ease;
        }
            .password-toggle:hover {
                color: #4f46e5 !important;
                transform: scale(1.1);
            }

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
    <script>
        function togglePassword(fieldId, toggleId) {
            const field = document.getElementById(fieldId);
            const toggle = document.getElementById(toggleId);

            if (field.type === "password") {
                field.type = "text";
                toggle.classList.replace("fa-eye", "fa-eye-slash");
            } else {
                field.type = "password";
                toggle.classList.replace("fa-eye-slash", "fa-eye");
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container min-h-screen bg-gradient-to-b from-indigo-50 to-white flex items-center justify-center">
        <!-- Main Card -->
        <div class="login-card bg-white rounded-xl shadow-md overflow-hidden border border-gray-100 w-full max-w-md">

            <div class="card-content p-6 sm:p-8">
                <div class="text-center mb-6">
                    <h1 class="text-2xl font-bold text-gray-900">Reset Company Password</h1>
                    <p class="mt-2 text-sm text-gray-600">
                        Or <a href="CompanyLogin.aspx" class="font-medium text-indigo-600 hover:text-indigo-500">return to login</a>
                    </p>
                </div>

                <asp:Panel ID="pnlEmailForm" runat="server">
                    <div class="mb-6 text-center">
                        <p class="text-sm text-gray-600">
                            Enter your company email to receive a verification code
                        </p>
                    </div>

                    <div class="space-y-6">
                        <div>
                            <label for="txtEmail" class="block text-sm font-medium text-gray-700 mb-1">Company Email</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                                        <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                                    CssClass="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="company@example.com"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                                ErrorMessage="Email is required" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" 
                                ErrorMessage="Invalid email format" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>

                        <div>
                            <asp:Button ID="btnSendOTP" runat="server" Text="Send Verification Code" OnClick="btnSendOTP_Click"
                                CssClass="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200" />
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlOTPForm" runat="server" Visible="false">
                    <div class="mb-6 text-center">
                        <p class="text-sm text-gray-600">
                            We've sent a 6-digit code to your company email
                        </p>
                    </div>

                    <div class="space-y-6">
                        <div>
                            <label for="txtOTP" class="block text-sm font-medium text-gray-700 mb-1">Verification Code</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtOTP" runat="server" MaxLength="6"
                                    CssClass="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="123456"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvOTP" runat="server" ControlToValidate="txtOTP" 
                                ErrorMessage="Verification code is required" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div>
                            <label for="txtNewPassword" class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"
                                    CssClass="block w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="••••••••"></asp:TextBox>
                                <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center"
                                    onclick="togglePassword('<%= txtNewPassword.ClientID %>', 'toggleNewPassword')">
                                    <i id="toggleNewPassword" class="fas fa-eye text-gray-400 password-toggle"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" 
                                ErrorMessage="New password is required" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div>
                            <label for="txtConfirmPassword" class="block text-sm font-medium text-gray-700 mb-1">Confirm Password</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                                    CssClass="block w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="••••••••"></asp:TextBox>
                                <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center"
                                    onclick="togglePassword('<%= txtConfirmPassword.ClientID %>', 'toggleConfirmPassword')">
                                    <i id="toggleConfirmPassword" class="fas fa-eye text-gray-400 password-toggle"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" 
                                ErrorMessage="Please confirm your password" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cvPasswords" runat="server" ControlToValidate="txtConfirmPassword" 
                                ControlToCompare="txtNewPassword" ErrorMessage="Passwords do not match" 
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:CompareValidator>
                        </div>

                        <div>
                            <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" OnClick="btnResetPassword_Click"
                                CssClass="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200" />
                        </div>

                        <div class="text-center text-sm">
                            <span class="text-gray-500">Didn't receive code?</span>
                            <asp:LinkButton ID="btnResendOTP" runat="server" OnClick="btnResendOTP_Click"
                                CssClass="font-medium text-indigo-600 hover:text-indigo-500 ml-1">
                                Resend code
                            </asp:LinkButton>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="mt-6">
                    <div class="rounded-lg bg-green-50 p-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-green-400" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-green-800">
                                    <asp:Literal ID="litSuccessMessage" runat="server"></asp:Literal>
                                </p>
                                <div class="mt-2 text-sm text-green-700">
                                    <a href="CompanyLogin.aspx" class="font-medium text-green-800 hover:text-green-600 underline">Return to login</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="mt-6">
                    <div class="rounded-lg bg-red-50 p-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
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

            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                <div class="text-sm text-center text-gray-600">
                    Don't have a company account? <a href="CompanyRegister.aspx" class="font-medium text-indigo-600 hover:text-indigo-500">
                        Sign up now</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
</asp:Content>