<%@ Page Title="" Language="C#" MasterPageFile="~/CompanySite/AuthPages/AuthPages.Master" AutoEventWireup="true" CodeBehind="CompanyRegister.aspx.cs" Inherits="JobFinderWebApp.CompanySite.AuthPages.CompanyRegister" %>

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
        .password-strength {
            height: 4px;
            margin-top: 8px;
            display: flex;
            gap: 4px;
        }
        .strength-section {
            flex: 1;
            background-color: #e5e7eb;
            border-radius: 2px;
            transition: all 0.3s ease;
        }
        .strength-0 { background-color: #ef4444 !important; }
        .strength-1 { background-color: #f59e0b !important; }
        .strength-2 { background-color: #3b82f6 !important; }
        .strength-3 { background-color: #10b981 !important; }

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

            <div class="card-content p-6 sm:p-8">
                <div class="text-center mb-6">
                    <h1 class="mt-4 text-2xl font-bold text-gray-900">Create Company Account</h1>
                </div>
                
                <asp:Panel ID="pnlRegisterForm" runat="server">
                    <div class="space-y-6">
                        <!-- Company Name Field -->
                        <div>
                            <label for="txtCompanyName" class="block text-sm font-medium text-gray-700 mb-1">Company Name</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtCompanyName" runat="server" 
                                    CssClass="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" 
                                    placeholder="Your Company" MaxLength="100"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvCompanyName" runat="server" 
                                ControlToValidate="txtCompanyName" ErrorMessage="Company name is required"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Email Field -->
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
                                    placeholder="company@example.com" autocomplete="email"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail" ErrorMessage="Email is required"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                ControlToValidate="txtEmail" ErrorMessage="Please enter a valid email address"
                                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RegularExpressionValidator>
                            <asp:CustomValidator ID="cvEmail" runat="server" 
                                ControlToValidate="txtEmail" ErrorMessage="Email is already registered"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic" 
                                OnServerValidate="cvEmail_ServerValidate"></asp:CustomValidator>
                        </div>

                        <!-- Phone Field -->
                        <div>
                            <label for="txtPhone" class="block text-sm font-medium text-gray-700 mb-1">Company Phone</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M7 2a2 2 0 00-2 2v12a2 2 0 002 2h6a2 2 0 002-2V4a2 2 0 00-2-2H7zm3 14a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtPhone" runat="server"
                                    CssClass="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="+1234567890" MaxLength="20"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                                ControlToValidate="txtPhone" ErrorMessage="Phone number is required"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Password Field -->
                        <div>
                            <label for="txtPassword" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                    CssClass="block w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="••••••••" autocomplete="new-password" 
                                    onkeyup="checkPasswordStrength(this.value)"></asp:TextBox>
                                <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center"
                                    onclick="togglePasswordVisibility('<%= txtPassword.ClientID %>', 'togglePassword')">
                                    <i id="togglePassword" class="fas fa-eye text-gray-400 password-toggle"></i>
                                </button>
                            </div>
                            <div class="password-strength" id="passwordStrength">
                                <div class="strength-section" id="strength1"></div>
                                <div class="strength-section" id="strength2"></div>
                                <div class="strength-section" id="strength3"></div>
                                <div class="strength-section" id="strength4"></div>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword" ErrorMessage="Password is required"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revPassword" runat="server"
                                ControlToValidate="txtPassword" ErrorMessage="Password must be 8-20 characters with at least one uppercase, one lowercase, one number and one special character"
                                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{8,20}$"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>

                        <!-- Confirm Password Field -->
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
                                    placeholder="••••••••" autocomplete="new-password"></asp:TextBox>
                                <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center"
                                    onclick="togglePasswordVisibility('<%= txtConfirmPassword.ClientID %>', 'toggleConfirmPassword')">
                                    <i id="toggleConfirmPassword" class="fas fa-eye text-gray-400 password-toggle"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                                ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cvPassword" runat="server"
                                ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
                                ErrorMessage="Passwords do not match" CssClass="mt-1 text-xs text-red-600"
                                Display="Dynamic"></asp:CompareValidator>
                        </div>

                        <!-- Terms Agreement -->
                        <div class="flex items-start">
                            <div class="flex items-center h-5">
                                <asp:CheckBox ID="chkAgree" runat="server" CssClass="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded" />
                            </div>
                            <div class="ml-3 text-sm">
                                <label for="chkAgree" class="font-medium text-gray-700">
                                    I agree to the <a href="Terms.aspx" target="_blank" class="text-indigo-600 hover:text-indigo-500">Terms and Conditions</a>
                                </label>
                                <asp:CustomValidator ID="cvAgree" runat="server" 
                                    ErrorMessage="You must accept the terms and conditions"
                                    CssClass="mt-1 text-xs text-red-600 block" Display="Dynamic"
                                    OnServerValidate="cvAgree_ServerValidate"></asp:CustomValidator>
                            </div>
                        </div>

                        <!-- Register Button -->
                        <div>
                            <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click"
                                CssClass="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200"
                                OnClientClick="if(!Page_ClientValidate()){ return false; } this.disabled=true; this.value='Processing...';" 
                                UseSubmitBehavior="false" />
                        </div>
                    </div>
                </asp:Panel>

                <!-- Success Message -->
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="text-center">
                    <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
                        <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                        </svg>
                    </div>
                    <h3 class="mt-3 text-lg font-medium text-gray-900">Registration successful!</h3>
                    <div class="mt-2 text-sm text-gray-600">
                        <p>We've sent a verification email to <asp:Literal ID="litEmail" runat="server"></asp:Literal>.</p>
                        <p class="mt-1">Please check your email to verify your account.</p>
                    </div>
                    <div class="mt-6">
                        <a href="CompanyLogin.aspx" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Continue to Login
                        </a>
                    </div>
                </asp:Panel>
            </div>

            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                <div class="text-sm text-center text-gray-600">
                    Already have an account? <a href="CompanyLogin.aspx" class="font-medium text-indigo-600 hover:text-indigo-500">Sign in</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

    <script type="text/javascript">
        function togglePasswordVisibility(fieldId, iconId) {
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(iconId);

            if (field.type === "password") {
                field.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                field.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        function checkPasswordStrength(password) {
            let strength = 0;

            // Check length
            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;

            // Check character types
            if (/[A-Z]/.test(password)) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            // Normalize to 0-3 scale
            strength = Math.min(Math.floor(strength / 2), 3);

            // Update UI
            for (let i = 1; i <= 4; i++) {
                const element = document.getElementById('strength' + i);
                element.className = 'strength-section';
                if (i <= strength + 1) {
                    element.classList.add('strength-' + strength);
                }
            }
        }
    </script>
</asp:Content>