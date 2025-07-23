<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="JobFinderWebApp._default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Job Finder</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .option-card {
            transition: all 0.3s ease;
            min-height: 220px;
        }
        .option-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        }
        @media (max-width: 640px) {
            .mobile-full {
                min-height: 100vh;
                border-radius: 0;
            }
            .mobile-px {
                padding-left: 1.5rem;
                padding-right: 1.5rem;
            }
            .mobile-py {
                padding-top: 2rem;
                padding-bottom: 2rem;
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-50 to-blue-50 min-h-screen flex items-center justify-center p-0 m-0">
    <form id="form1" runat="server">
        <div class="w-full max-w-md mobile-full mobile-px mobile-py sm:p-8">
            <!-- Logo and Title -->
            <div class="text-center">
                <div class="mx-auto h-20 w-20 bg-indigo-600 rounded-full flex items-center justify-center shadow-lg mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                </div>
                <h1 class="text-3xl font-bold text-gray-900">JobFinder</h1>
                <p class="mt-2 text-gray-600">Find your dream job or the perfect candidate</p>
            </div>

            <!-- Options Container -->
            <div class="mt-10 grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- User Option -->
                <a href="UserSite/AuthPages/Login.aspx" 
                   class="option-card bg-white p-6 rounded-xl shadow-md border border-gray-100 text-center hover:border-indigo-300 flex flex-col justify-between">
                    <div>
                        <div class="h-16 w-16 mx-auto bg-indigo-100 rounded-full flex items-center justify-center mb-4">
                            <i class="fas fa-user text-indigo-600 text-2xl"></i>
                        </div>
                        <h3 class="text-lg font-medium text-gray-900">Job Seeker</h3>
                        <p class="mt-2 text-sm text-gray-500">Find your dream job</p>
                    </div>
                    <div class="mt-4">
                        <span class="inline-flex items-center text-indigo-600 text-sm font-medium">
                            Continue as User
                            <i class="fas fa-arrow-right ml-2"></i>
                        </span>
                    </div>
                </a>

                <!-- Company Option -->
                <a href="CompanySite/AuthPages/CompanyLogin.aspx" 
                   class="option-card bg-white p-6 rounded-xl shadow-md border border-gray-100 text-center hover:border-indigo-300 flex flex-col justify-between">
                    <div>
                        <div class="h-16 w-16 mx-auto bg-blue-100 rounded-full flex items-center justify-center mb-4">
                            <i class="fas fa-building text-blue-600 text-2xl"></i>
                        </div>
                        <h3 class="text-lg font-medium text-gray-900">Employer</h3>
                        <p class="mt-2 text-sm text-gray-500">Find the perfect candidate</p>
                    </div>
                    <div class="mt-4">
                        <span class="inline-flex items-center text-blue-600 text-sm font-medium">
                            Continue as Company
                            <i class="fas fa-arrow-right ml-2"></i>
                        </span>
                    </div>
                </a>
            </div>

            <!-- Footer Links -->
            <div class="mt-8 text-center text-sm text-gray-500">
                <p>Need help? <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">Contact support</a></p>
            </div>
        </div>
    </form>
</body>
</html>