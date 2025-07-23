<%@ Page Title="Message Room" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master"
    AutoEventWireup="true" CodeBehind="MessageRoom.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.MessageRoom" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .message-container {
            scroll-behavior: smooth;
            background-image: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path fill="%23e5e7eb" fill-opacity="0.3" d="M30,10L50,30L70,10L90,30L70,50L90,70L70,90L50,70L30,90L10,70L30,50L10,30L30,10Z" /></svg>');
            background-size: 20px 20px;
        }
        .auto-growing-input {
            transition: height 0.2s ease-out;
            max-height: 120px;
        }
        .typing-indicator:after {
            content: '...';
            animation: typing 1.5s infinite;
        }
        @keyframes typing {
            0% { content: '.'; }
            33% { content: '..'; }
            66% { content: '...'; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center sticky top-0 z-10">
        <a href="Messages.aspx" class="text-gray-600 hover:text-blue-500 mr-2 transition-colors p-1 rounded-full hover:bg-gray-100">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd" />
            </svg>
        </a>
        <div class="flex items-center flex-1">
            <img id="partnerImage" runat="server" src="/images/default-avatar.png" class="w-10 h-10 rounded-full object-cover mr-3 border-2 border-white shadow" alt="Partner" />
            <div class="flex-1">
                <h1 id="partnerName" runat="server" class="font-semibold text-gray-800 text-lg"></h1>
                <div id="typingIndicator" class="text-xs text-gray-500 hidden">
                    <span class="typing-indicator">Typing</span>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="max-w-2xl mx-auto bg-white rounded-t-lg shadow-sm h-screen flex flex-col border border-gray-200">
        <div class="flex-1 overflow-y-auto p-4 message-container pb-20" id="messageContainer" runat="server">
            <div class="text-center text-xs text-gray-500 py-2">
                Today
            </div>
            
            <asp:Repeater ID="rptMessages" runat="server">
                <ItemTemplate>
                    <div class='flex mb-3 <%# Eval("SenderId").ToString() == Session["userId"].ToString() ? "justify-end" : "justify-start" %>'>
                        <div class='max-w-xs md:max-w-md lg:max-w-lg px-4 py-2 rounded-2xl <%# Eval("SenderId").ToString() == Session["userId"].ToString() ? "bg-blue-500 text-white rounded-br-none" : "bg-gray-100 text-gray-800 rounded-bl-none" %> shadow'>
                            <p class="text-sm"><%# Eval("MessageText") %></p>
                            
                            <%# !string.IsNullOrEmpty(Eval("FilePath").ToString()) ? 
                                GetAttachmentHtml(
                                    Eval("FilePath").ToString(), 
                                    Eval("FileData").ToString(),
                                    Eval("SenderId").ToString() == Session["userId"].ToString()
                                ) : "" %>
                            
                            <div class='flex justify-end items-center mt-1'>
                                <p class='text-xs <%# Eval("SenderId").ToString() == Session["userId"].ToString() ? "text-blue-100" : "text-gray-500" %> mr-1'><%# Eval("SentDate", "{0:h:mm tt}") %></p>
                                <%# Eval("SenderId").ToString() == Session["userId"].ToString() ? 
                                    "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-3 w-3 text-blue-300\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path fill-rule=\"evenodd\" d=\"M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z\" clip-rule=\"evenodd\" /></svg>" : "" 
                                %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <div id="newMessageAnchor"></div>
        </div>
        
        <div class="border-t border-gray-200 p-3 bg-white">
            <div id="filePreviewContainer" class="mb-2 hidden">
                <div class="flex items-center justify-between bg-blue-50 p-3 rounded-lg border border-blue-100">
                    <div class="flex items-center truncate">
                        <div id="filePreviewIcon" class="mr-3 text-blue-500">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                            </svg>
                        </div>
                        <div class="truncate">
                            <div id="fileNamePreview" class="text-sm font-medium text-gray-800 truncate"></div>
                            <div id="fileSizePreview" class="text-xs text-gray-500"></div>
                        </div>
                    </div>
                    <button id="removePreviewBtn" class="text-red-500 hover:text-red-700 ml-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                        </svg>
                    </button>
                </div>
            </div>
            
            <div class="flex items-end">
                <div class="file-input-wrapper relative mr-2">
                    <label class="w-10 h-10 flex items-center justify-center bg-white border border-gray-300 rounded-full cursor-pointer hover:bg-gray-50 transition-colors shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
                        </svg>
                        <asp:FileUpload ID="fuAttachment" runat="server" CssClass="absolute inset-0 w-full h-full opacity-0 cursor-pointer" />
                    </label>
                </div>
                
                <div class="flex-1 relative">
                    <asp:TextBox ID="txtMessage" runat="server" CssClass="w-full border border-gray-300 rounded-full py-2 px-4 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none auto-growing-input pr-10" 
                        placeholder="Type your message..." TextMode="MultiLine" Rows="1"></asp:TextBox>
                    <button class="absolute right-2 bottom-2 text-gray-500 hover:text-blue-500">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM7 9a1 1 0 100-2 1 1 0 000 2zm7-1a1 1 0 11-2 0 1 1 0 012 0zm-.464 5.535a1 1 0 10-1.415-1.414 3 3 0 01-4.242 0 1 1 0 00-1.415 1.414 5 5 0 007.072 0z" clip-rule="evenodd" />
                        </svg>
                    </button>
                </div>
                
                <asp:Button ID="btnSend" runat="server" Text="↑" CssClass="w-10 h-10 flex items-center justify-center bg-blue-500 text-white rounded-full cursor-pointer hover:bg-blue-600 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed shadow-sm ml-2"
                    OnClick="btnSend_Click" />
            </div>
        </div>

    </div>

    <script>
        // Auto-growing text input
        const textInput = document.getElementById('<%= txtMessage.ClientID %>');
        textInput.addEventListener('input', function () {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });

        // File preview functionality
        const fileInput = document.getElementById('<%= fuAttachment.ClientID %>');
        const filePreviewContainer = document.getElementById('filePreviewContainer');
        const fileNamePreview = document.getElementById('fileNamePreview');
        const fileSizePreview = document.getElementById('fileSizePreview');
        const filePreviewIcon = document.getElementById('filePreviewIcon');
        const removePreviewBtn = document.getElementById('removePreviewBtn');

        fileInput.addEventListener('change', function (e) {
            const file = e.target.files[0];
            if (!file) return;

            if (file.size > 50 * 1024 * 1024) {
                showAlert('File size cannot exceed 50MB');
                this.value = '';
                return;
            }

            // Update preview
            fileNamePreview.textContent = file.name;
            fileSizePreview.textContent = formatFileSize(file.size);

            // Update icon based on file type
            const fileType = file.type.split('/')[0];
            let iconHtml = '';

            if (fileType === 'image') {
                iconHtml = `<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>`;
            } else if (fileType === 'video') {
                iconHtml = `<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" /></svg>`;
            } else if (file.name.endsWith('.pdf')) {
                iconHtml = `<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" /></svg>`;
            } else if (file.name.endsWith('.doc') || file.name.endsWith('.docx')) {
                iconHtml = `<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>`;
            } else {
                iconHtml = `<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m5 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>`;
            }

            filePreviewIcon.innerHTML = iconHtml;

            // Show preview container
            filePreviewContainer.classList.remove('hidden');
        });

        removePreviewBtn.addEventListener('click', function () {
            fileInput.value = '';
            filePreviewContainer.classList.add('hidden');
        });

        // Auto-scroll to bottom when new messages arrive
        function scrollToBottom() {
            const container = document.getElementById('<%= messageContainer.ClientID %>');
            const anchor = document.getElementById('newMessageAnchor');
            anchor.scrollIntoView({ behavior: 'smooth' });
        }

        // Initial scroll to bottom
        window.addEventListener('load', function () {
            scrollToBottom();
        });

        // Format file size
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        // Alert functions
        function showAlert(message) {
            const alert = document.getElementById('customAlert');
            const alertMessage = document.getElementById('alertMessage');

            alertMessage.textContent = message;
            alert.classList.remove('translate-x-full');

            setTimeout(() => {
                alert.classList.add('translate-x-0');
            }, 10);

            setTimeout(() => {
                closeAlert();
            }, 5000);
        }

        function closeAlert() {
            const alert = document.getElementById('customAlert');
            alert.classList.remove('translate-x-0');

            setTimeout(() => {
                alert.classList.add('translate-x-full');
            }, 300);
        }

        // Register scroll function for use in code-behind
        function registerScrollFunction() {
            window.scrollToBottom = scrollToBottom;
        }
        registerScrollFunction();

        // Simulate typing indicator (for demo purposes)
        setInterval(() => {
            const typingIndicator = document.getElementById('typingIndicator');
            if (Math.random() > 0.7) {
                typingIndicator.classList.remove('hidden');
            } else {
                typingIndicator.classList.add('hidden');
            }
        }, 5000);
    </script>
</asp:Content>