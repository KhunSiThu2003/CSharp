<%@ Page Title="" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Animation for error shake */
        .animate-shake {
            animation: shake 0.5s cubic-bezier(.36,.07,.19,.97) both;
        }
        
        @keyframes shake {
            10%, 90% { transform: translateX(-1px); }
            20%, 80% { transform: translateX(2px); }
            30%, 50%, 70% { transform: translateX(-4px); }
            40%, 60% { transform: translateX(4px); }
        }

        /* Profile picture upload styles */
        .profile-pic-container {
            cursor: pointer;
            position: relative;
            width: 144px;
            height: 144px;
            margin: 0 auto;
        }

        .profile-pic-container > * {
            pointer-events: none;
        }

        .profile-pic-upload {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            cursor: pointer;
        }

        .profile-pic-wrapper {
            position: relative;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid #4f46e5;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .profile-pic-wrapper:hover {
            transform: scale(1.05);
        }

        .profile-pic-overlay {
            position: absolute;
            inset: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .profile-pic-container:hover .profile-pic-overlay {
            opacity: 1;
        }

        /* Dark mode adjustments */
        .dark .profile-pic-wrapper {
            border-color: #818cf8;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center justify-between">
        <div class="flex items-center">
            <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-200">My Profile</h1>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Alert Notification Container -->
    <div class="fixed top-4 right-4 z-50 max-w-xs w-full space-y-2" id="alertContainer"></div>

    <div class="bg-white dark:bg-gray-800/30 rounded-xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">
        <!-- Profile Header -->
        <div class="px-6 py-8 bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-900 dark:to-black border-b border-gray-200 dark:border-gray-800">
            <div class="flex flex-col md:flex-row items-center md:items-start gap-8">
                <!-- Profile Picture Section -->
                <div class="profile-pic-container">
                    <div class="profile-pic-wrapper">
                        <asp:Image ID="imgProfile" runat="server" 
                            CssClass="w-full h-full object-cover transition-opacity duration-300" 
                            onerror="this.src='https://ui-avatars.com/api/?name='+encodeURIComponent(document.getElementById('<%= txtFullName.ClientID %>').value || 'User')+'&background=4f46e5&color=fff&size=256'" />
                        <div class="profile-pic-overlay">
                            <i class="fas fa-camera text-white text-2xl"></i>
                        </div>
                    </div>
                    <asp:FileUpload ID="fileProfilePic" runat="server" CssClass="profile-pic-upload" onchange="previewProfilePic(this)" accept="image/*" />
                    <asp:Label ID="lblProfilePicError" runat="server" CssClass="text-red-500 text-sm mt-2 block text-center hidden"></asp:Label>
                </div>
                
                <!-- Profile Info -->
                <div class="flex-1 text-left">
                    <h2 class="text-2xl font-bold text-gray-800 dark:text-gray-200 mb-2">
                        <asp:Literal ID="litFullName" runat="server" />
                    </h2>
                    <div class="space-y-1">
                        <p class="text-gray-600 dark:text-gray-400">
                            <i class="fas fa-envelope mr-2 text-blue-500 dark:text-blue-400"></i>
                            <asp:Literal ID="litEmail" runat="server" />
                        </p>
                        <p class="text-gray-600 dark:text-gray-400">
                            <i class="fas fa-phone mr-2 text-blue-500 dark:text-blue-400"></i>
                            <asp:Literal ID="litPhone" runat="server" Text="Not provided" />
                        </p>
                        <p class="text-gray-600 dark:text-gray-400">
                            <i class="fas fa-map-marker-alt mr-2 text-blue-500 dark:text-blue-400"></i>
                            <asp:Literal ID="litLocation" runat="server" Text="Location not set" />
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Profile Content -->
        <div class="px-6 py-8 bg-white dark:bg-black">
            <div class="max-w-4xl mx-auto">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Personal Information -->
                    <div class="bg-gray-100/20 dark:bg-gray-900/20 p-6 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-4 pb-2 border-b border-gray-200 dark:border-gray-700 flex items-center">
                            <i class="fas fa-user-circle mr-2 text-blue-500 dark:text-blue-400"></i>
                            Personal Information
                        </h3>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" 
                                    CssClass="w-full rounded px-3 py-2 border border-gray-300 dark:border-gray-700 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800/30 dark:text-gray-200 transition-colors duration-200" />
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" 
                                    CssClass="w-full rounded px-3 py-2 border border-gray-300 dark:border-gray-700 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800/30 dark:text-gray-200 transition-colors duration-200" />
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Phone</label>
                                <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" 
                                    CssClass="w-full rounded px-3 py-2 border border-gray-300 dark:border-gray-700 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800/30 dark:text-gray-200 transition-colors duration-200" />
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Location</label>
                                <asp:TextBox ID="txtLocation" runat="server" 
                                    CssClass="w-full rounded px-3 py-2 border border-gray-300 dark:border-gray-700 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800/30 dark:text-gray-200 transition-colors duration-200" 
                                    placeholder="City, Country" />
                            </div>
                        </div>
                    </div>

                    <!-- About Section -->
                    <div class="bg-gray-100/20 dark:bg-gray-900/20 p-6 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-4 pb-2 border-b border-gray-200 dark:border-gray-700 flex items-center">
                            <i class="fas fa-info-circle mr-2 text-blue-500 dark:text-blue-400"></i>
                            About You
                        </h3>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Professional Title</label>
                            <asp:TextBox ID="txtTitle" runat="server" 
                                CssClass="w-full rounded px-3 py-2 border border-gray-300 dark:border-gray-700 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800/30 dark:text-gray-200 transition-colors duration-200 mb-4" 
                                placeholder="E.g. Software Developer" />
                            
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Bio</label>
                            <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" Rows="6" 
                                CssClass="w-full rounded px-3 py-2 border border-gray-300 dark:border-gray-700 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800/30 dark:text-gray-200 transition-colors duration-200" 
                                placeholder="Tell us about your professional background, skills, and experience..." />
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="mt-8 flex justify-end space-x-3 border-t border-gray-200 dark:border-gray-800 pt-6">
                    <asp:Button ID="btnCancelPersonal" runat="server" Text="Cancel" 
                        CssClass="px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200 shadow-sm font-medium" 
                        OnClick="btnCancelPersonal_Click" CausesValidation="false" />
                    <asp:Button ID="btnSaveBottom" runat="server" Text="Save Changes" 
                        CssClass="px-4 py-2 bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-600 text-white rounded-lg transition-colors duration-200 shadow-sm font-medium" 
                        OnClick="btnSavePersonal_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        // Initialize profile picture upload functionality
        function initProfilePictureUpload() {
            const profilePicContainer = document.querySelector('.profile-pic-container');
            const fileUpload = document.getElementById('<%= fileProfilePic.ClientID %>');

            if (profilePicContainer && fileUpload) {
                profilePicContainer.addEventListener('click', function (e) {
                    // Prevent bubbling if clicking on child elements
                    if (e.target !== fileUpload) {
                        fileUpload.click();
                    }
                });
            }
        }

        // Profile picture preview
        function previewProfilePic(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                const maxSize = 2 * 1024 * 1024; // 2MB

                // Clear any previous errors
                hideError();

                // Validate file type
                if (!validTypes.includes(file.type)) {
                    showError('Only JPG, JPEG, PNG, and GIF files are allowed.');
                    return;
                }

                // Validate file size
                if (file.size > maxSize) {
                    showError('Image size must be less than 2MB');
                    return;
                }

                // Create preview
                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = document.getElementById('<%= imgProfile.ClientID %>');
                    img.src = e.target.result;

                    // Smooth transition
                    img.style.opacity = '0';
                    setTimeout(() => {
                        img.style.transition = 'opacity 0.3s ease';
                        img.style.opacity = '1';
                    }, 10);
                }
                reader.readAsDataURL(file);
            }
        }

        function showError(message) {
            const errorLabel = document.getElementById('<%= lblProfilePicError.ClientID %>');
            errorLabel.textContent = message;
            errorLabel.classList.remove('hidden');

            // Add shake animation
            const uploadArea = document.querySelector('.profile-pic-container');
            uploadArea.classList.add('animate-shake');
            setTimeout(() => {
                uploadArea.classList.remove('animate-shake');
            }, 500);
        }

        function hideError() {
            const errorLabel = document.getElementById('<%= lblProfilePicError.ClientID %>');
            errorLabel.classList.add('hidden');
            errorLabel.textContent = '';
        }

        // Initialize when page loads
        initProfilePictureUpload();

        // Also ensure it runs after every postback
        if (typeof (Sys) !== 'undefined') {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                initProfilePictureUpload();
            });
        }

        // Alert System (only used for save button)
        function showAlert(type, title, message) {
            const alertContainer = document.getElementById('alertContainer');
            const alertId = 'alert-' + Date.now();

            let iconClass, bgClass, borderClass;
            switch (type) {
                case 'success':
                    iconClass = 'fas fa-check-circle text-green-500';
                    bgClass = 'bg-green-50 dark:bg-green-900';
                    borderClass = 'border-l-4 border-green-500';
                    break;
                case 'error':
                    iconClass = 'fas fa-exclamation-circle text-red-500';
                    bgClass = 'bg-red-50 dark:bg-red-900';
                    borderClass = 'border-l-4 border-red-500';
                    break;
                case 'info':
                    iconClass = 'fas fa-info-circle text-blue-500';
                    bgClass = 'bg-blue-50 dark:bg-blue-900';
                    borderClass = 'border-l-4 border-blue-500';
                    break;
                default:
                    iconClass = 'fas fa-info-circle text-blue-500';
                    bgClass = 'bg-blue-50 dark:bg-blue-900';
                    borderClass = 'border-l-4 border-blue-500';
            }

            const alertHTML = `
                <div id="${alertId}" class="${bgClass} ${borderClass} p-4 rounded-lg shadow-lg flex items-start transform transition-all duration-300 translate-x-96 opacity-0">
                    <i class="${iconClass} mr-3 mt-1"></i>
                    <div class="flex-1">
                        <h4 class="font-medium text-gray-900 dark:text-gray-100">${title}</h4>
                        <p class="text-sm text-gray-700 dark:text-gray-300">${message}</p>
                    </div>
                    <button type="button" onclick="closeAlert('${alertId}')" class="ml-4 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            `;

            alertContainer.insertAdjacentHTML('afterbegin', alertHTML);

            const alertElement = document.getElementById(alertId);
            setTimeout(() => {
                alertElement.classList.remove('translate-x-96', 'opacity-0');
                alertElement.classList.add('translate-x-0', 'opacity-100');
            }, 10);

            // Auto-close after 5 seconds
            setTimeout(() => {
                closeAlert(alertId);
            }, 5000);
        }

        function closeAlert(id) {
            const alert = document.getElementById(id);
            if (alert) {
                alert.classList.remove('translate-x-0', 'opacity-100');
                alert.classList.add('translate-x-96', 'opacity-0');

                // Remove after animation
                setTimeout(() => {
                    alert.remove();
                }, 300);
            }
        }

        // Expose alert functions to code-behind
        window.showSuccessMessage = function (message) {
            showAlert('success', 'Success', message);
        };

        window.showErrorMessage = function (message) {
            showAlert('error', 'Error', message);
        };

        window.showInfoMessage = function (title, message) {
            showAlert('info', title, message);
        };
    </script>
</asp:Content>