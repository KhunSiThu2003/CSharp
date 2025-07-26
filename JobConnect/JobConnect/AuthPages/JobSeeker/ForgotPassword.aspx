<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/MasterPages/Auth.Master" AutoEventWireup="true" 
    CodeBehind="ForgotPassword.aspx.cs" Inherits="JobConnect.AuthPages.JobSeeker.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; img-src 'self' data:;" />
    <style>
        .password-toggle {
            transition: all 0.2s ease;
        }
        .password-toggle:hover {
            color: #4f46e5 !important;
            transform: scale(1.1);
        }
        
        #otpCountdown {
            font-weight: bold;
            color: #2563eb;
            margin: 8px 0;
            text-align: center;
            font-size: 0.9rem;
        }
        
        #rateLimitMessage {
            display: none;
            color: #dc2626;
            font-weight: bold;
            text-align: center;
            margin: 10px 0;
            padding: 10px;
            background-color: #fee2e2;
            border-radius: 4px;
            border: 1px solid #fca5a5;
        }
        
        .expired {
            color: #dc2626 !important;
        }

        .success-card {
            background-color: #f0fdf4;
            border: 1px solid #86efac;
        }

        .error-card {
            background-color: #fef2f2;
            border: 1px solid #fca5a5;
        }

        .password-strength {
            height: 4px;
            margin-top: 4px;
            border-radius: 2px;
            transition: all 0.3s ease;
        }

        .strength-0 { width: 20%; background-color: #dc2626; }
        .strength-1 { width: 40%; background-color: #f59e0b; }
        .strength-2 { width: 60%; background-color: #f59e0b; }
        .strength-3 { width: 80%; background-color: #10b981; }
        .strength-4 { width: 100%; background-color: #10b981; }

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
    <div class="login-container min-h-screen bg-gradient-to-b from-indigo-50 to-white flex items-center justify-center p-4">
        <div class="login-card bg-white rounded-xl shadow-md overflow-hidden border border-gray-100 w-full max-w-md">
            <div class="card-content p-6 sm:p-8">
                <div class="text-center mb-6">
                    <h1 class="text-2xl font-bold text-gray-900">Reset Your Password</h1>
                    <p class="mt-2 text-sm text-gray-600">
                        Or <a href="Login.aspx" class="font-medium text-indigo-600 hover:text-indigo-500">return to login</a>
                    </p>
                </div>

                <div id="rateLimitMessage" runat="server" clientidmode="Static">
                    <i class="fas fa-exclamation-circle mr-2"></i>
                    <span id="rateLimitText">Too many attempts. Please try again in <span id="rateLimitTime">5:00</span>.</span>
                </div>

                <asp:Panel ID="pnlEmailForm" runat="server" DefaultButton="btnSendOTP">
                    <div class="mb-6 text-center">
                        <p class="text-sm text-gray-600">
                            Enter your email to receive a verification code
                        </p>
                    </div>

                    <div class="space-y-4">
                        <div>
                            <label for="txtEmail" class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                                        <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" AutoCompleteType="Email"
                                    CssClass="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="you@example.com" autofocus="true"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                                ErrorMessage="Email is required" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" 
                                ErrorMessage="Invalid email format" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>

                        <div>
                            <asp:Button ID="btnSendOTP" runat="server" Text="Send Verification Code" OnClick="btnSendOTP_Click"
                                CssClass="w-full flex justify-center py-2 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200" />
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlOTPForm" runat="server" Visible="false" DefaultButton="btnResetPassword">
                    <div class="mb-6 text-center">
                        <p class="text-sm text-gray-600">
                            We've sent a 6-digit code to your email
                        </p>
                        <div id="otpCountdown" class="mt-2"></div>
                    </div>

                    <div class="space-y-4">
                        <div>
                            <label for="txtOTP" class="block text-sm font-medium text-gray-700 mb-1">Verification Code</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtOTP" runat="server" MaxLength="6" AutoCompleteType="Disabled"
                                    CssClass="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="123456" autocomplete="off"></asp:TextBox>
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
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" AutoCompleteType="Disabled"
                                    CssClass="block w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="••••••••" autocomplete="new-password" onkeyup="checkPasswordStrength(this.value)"></asp:TextBox>
                                <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center"
                                    onclick="togglePassword('<%= txtNewPassword.ClientID %>', 'toggleNewPassword')">
                                    <i id="toggleNewPassword" class="fas fa-eye text-gray-400 password-toggle"></i>
                                </button>
                            </div>
                            <div id="passwordStrength" class="password-strength strength-0"></div>
                            <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" 
                                ErrorMessage="New password is required" CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtNewPassword"
                                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{12,}$"
                                ErrorMessage="Password must be at least 12 characters with uppercase, lowercase, number, and special character"
                                CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>

                        <div>
                            <label for="txtConfirmPassword" class="block text-sm font-medium text-gray-700 mb-1">Confirm Password</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" AutoCompleteType="Disabled"
                                    CssClass="block w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="••••••••" autocomplete="new-password"></asp:TextBox>
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
                                CssClass="w-full flex justify-center py-2 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200" />
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

                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="mt-4">
                    <div class="rounded-lg p-4 success-card">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-green-800">
                                    <asp:Literal ID="litSuccessMessage" runat="server"></asp:Literal>
                                </p>
                                <div class="mt-2 text-sm text-green-700">
                                    <a href="Login.aspx" class="font-medium text-green-800 hover:text-green-600 underline">Return to login</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="mt-4">
                    <div class="rounded-lg p-4 error-card">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
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
                    Don't have an account? <a href="Register.aspx" class="font-medium text-indigo-600 hover:text-indigo-500">
                        Sign up now</a>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function togglePassword(fieldId, toggleId) {
            const field = document.getElementById(fieldId);
            const toggle = document.getElementById(toggleId);
            if (!field || !toggle) return;

            if (field.type === "password") {
                field.type = "text";
                toggle.classList.replace("fa-eye", "fa-eye-slash");
            } else {
                field.type = "password";
                toggle.classList.replace("fa-eye-slash", "fa-eye");
            }
        }

        function checkPasswordStrength(password) {
            const strengthBar = document.getElementById('passwordStrength');
            if (!strengthBar) return;

            // Reset classes
            strengthBar.className = 'password-strength';

            if (!password) {
                strengthBar.classList.add('strength-0');
                return;
            }

            // Calculate strength
            let strength = 0;

            // Length >= 12
            if (password.length >= 12) strength++;

            // Contains lowercase
            if (/[a-z]/.test(password)) strength++;

            // Contains uppercase
            if (/[A-Z]/.test(password)) strength++;

            // Contains number
            if (/\d/.test(password)) strength++;

            // Contains special char
            if (/[^a-zA-Z0-9]/.test(password)) strength++;

            // Cap at 4 (for our CSS classes)
            strength = Math.min(strength, 4);

            // Update UI
            strengthBar.classList.add(`strength-${strength}`);
        }

        function startOTPCountdown(seconds) {
            var countdownElement = document.getElementById('otpCountdown');
            if (!countdownElement) return;

            var endTime = new Date();
            endTime.setSeconds(endTime.getSeconds() + seconds);

            function updateDisplay() {
                var now = new Date();
                var remaining = Math.max(0, Math.floor((endTime - now) / 1000));

                var minutes = Math.floor(remaining / 60);
                var remainingSeconds = remaining % 60;

                var displayMinutes = minutes < 10 ? "0" + minutes : minutes;
                var displaySeconds = remainingSeconds < 10 ? "0" + remainingSeconds : remainingSeconds;

                countdownElement.innerHTML =
                    "Code expires in: <strong>" + displayMinutes + ":" + displaySeconds + "</strong>";

                if (remaining <= 0) {
                    clearInterval(interval);
                    countdownElement.innerHTML = "<strong class='expired'>Code has expired. Please request a new one.</strong>";
                }
            }

            updateDisplay();
            var interval = setInterval(updateDisplay, 1000);
        }

        function showRateLimit(seconds) {
            var rateLimitElement = document.getElementById('rateLimitMessage');
            var timeElement = document.getElementById('rateLimitTime');
            if (!rateLimitElement || !timeElement) return;

            var endTime = new Date();
            endTime.setSeconds(endTime.getSeconds() + seconds);

            function updateDisplay() {
                var now = new Date();
                var remaining = Math.max(0, Math.floor((endTime - now) / 1000));

                var minutes = Math.floor(remaining / 60);
                var remainingSeconds = remaining % 60;

                var displayMinutes = minutes < 10 ? "0" + minutes : minutes;
                var displaySeconds = remainingSeconds < 10 ? "0" + remainingSeconds : remainingSeconds;

                timeElement.textContent = displayMinutes + ":" + displaySeconds;

                if (remaining <= 0) {
                    clearInterval(interval);
                    rateLimitElement.style.display = 'none';
                    enableFormControls();
                }
            }

            function enableFormControls() {
                var btnReset = document.getElementById('<%= btnResetPassword.ClientID %>');
                var btnResend = document.getElementById('<%= btnResendOTP.ClientID %>');
                var txtOTP = document.getElementById('<%= txtOTP.ClientID %>');
                var txtNewPass = document.getElementById('<%= txtNewPassword.ClientID %>');
                var txtConfirmPass = document.getElementById('<%= txtConfirmPassword.ClientID %>');

                if (btnReset) btnReset.disabled = false;
                if (btnResend) btnResend.disabled = false;
                if (txtOTP) txtOTP.disabled = false;
                if (txtNewPass) txtNewPass.disabled = false;
                if (txtConfirmPass) txtConfirmPass.disabled = false;
            }

            rateLimitElement.style.display = 'block';
            updateDisplay();
            var interval = setInterval(updateDisplay, 1000);
        }
    </script>
</asp:Content>