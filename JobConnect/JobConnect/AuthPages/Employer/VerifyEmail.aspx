<%@ Page Title="Verify Email" Language="C#" MasterPageFile="~/MasterPages/Auth.Master" AutoEventWireup="true" 
    CodeBehind="VerifyEmail.aspx.cs" Inherits="JobConnect.AuthPages.Employer.VerifyEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; img-src 'self' data:;" />
    <style>
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

        .message-card {
            border-radius: 8px;
            padding: 16px;
            margin-top: 16px;
        }

        .success-card {
            background-color: #f0fdf4;
            border: 1px solid #86efac;
        }

        .error-card {
            background-color: #fef2f2;
            border: 1px solid #fca5a5;
        }

        .info-card {
            background-color: #eff6ff;
            border: 1px solid #93c5fd;
        }

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
            <div class="bg-indigo-600 text-white p-6 text-center">
                <div class="flex justify-center mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                </div>
                <h1 class="text-3xl font-bold">JobConnect</h1>
                <p class="mt-2 text-indigo-100">Find your dream job today</p>
            </div>

            <div class="card-content p-6 sm:p-8">
                <div id="rateLimitMessage" runat="server" clientidmode="Static">
                    <i class="fas fa-exclamation-circle mr-2"></i>
                    <span id="rateLimitText">Too many attempts. Please try again in <span id="rateLimitTime">5:00</span>.</span>
                </div>

                <div class="text-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">Verify Your Email</h2>
                    <p class="mt-2 text-sm text-gray-600">
                        We've sent a verification code to your email address
                    </p>
                    <div id="otpCountdown" class="mt-2"></div>
                </div>

                <div class="space-y-4">
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
                            <asp:TextBox ID="txtVerificationCode" runat="server" MaxLength="6" AutoCompleteType="Disabled"
                                CssClass="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                placeholder="123456" autocomplete="off"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvCode" runat="server"
                            ControlToValidate="txtVerificationCode" ErrorMessage="Verification code is required"
                            CssClass="mt-1 text-xs text-red-600" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <asp:Button ID="btnVerify" runat="server" Text="Verify" OnClick="btnVerify_Click"
                            CssClass="w-full flex justify-center py-2 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200" />
                    </div>

                    <div class="text-center text-sm">
                        <span class="text-gray-500">Didn't receive code?</span>
                        <asp:LinkButton ID="btnResendCode" runat="server" OnClick="btnResendCode_Click"
                            CssClass="font-medium text-indigo-600 hover:text-indigo-500 ml-1">
                            Resend Verification Code
                        </asp:LinkButton>
                    </div>

                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mt-4">
                        <div class="message-card" id="messageContainer" runat="server">
                            <div class="flex items-start">
                                <div class="flex-shrink-0">
                                    <asp:PlaceHolder ID="phIcon" runat="server"></asp:PlaceHolder>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm font-medium" id="messageText" runat="server">
                                        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                <div class="text-sm text-center text-gray-600">
                    Need help? <a href="Contact.aspx" class="font-medium text-indigo-600 hover:text-indigo-500">
                        Contact support</a>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
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
                var btnVerify = document.getElementById('<%= btnVerify.ClientID %>');
                var btnResend = document.getElementById('<%= btnResendCode.ClientID %>');
                var txtCode = document.getElementById('<%= txtVerificationCode.ClientID %>');

                if (btnVerify) btnVerify.disabled = false;
                if (btnResend) btnResend.disabled = false;
                if (txtCode) txtCode.disabled = false;
            }

            rateLimitElement.style.display = 'block';
            updateDisplay();
            var interval = setInterval(updateDisplay, 1000);
        }
    </script>
</asp:Content>