<%@ Page Title="Message" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master" 
    AutoEventWireup="true" CodeBehind="MessageDetail.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.MessageDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .message-header {
            border-bottom: 1px solid rgba(229, 231, 235, 0.5);
        }
        .dark .message-header {
            border-bottom-color: rgba(55, 65, 81, 0.5);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center gap-4">
        <asp:HyperLink runat="server" NavigateUrl="~/UserSite/Views/Messages.aspx" 
            class="flex items-center text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition-colors">
            <i class="fas fa-arrow-left mr-2"></i>Back to Messages
        </asp:HyperLink>
        <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">Message</h1>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">
        <div class="p-6">
            <div class="message-header pb-4 mb-4">
                <div class="flex items-start gap-4">
                    <asp:Image ID="imgSender" runat="server" 
                        class="h-12 w-12 rounded-full object-cover border border-gray-200 dark:border-gray-600" />
                    <div class="flex-1">
                        <div class="flex items-center justify-between">
                            <h2 class="text-xl font-semibold text-gray-800 dark:text-white">
                                <asp:Literal ID="litSenderName" runat="server" />
                            </h2>
                            <span class="text-sm text-gray-500 dark:text-gray-400">
                                <asp:Literal ID="litSentDate" runat="server" />
                            </span>
                        </div>
                        <h3 class="text-lg text-gray-600 dark:text-gray-300 mt-1">
                            <asp:Literal ID="litSubject" runat="server" />
                        </h3>
                    </div>
                </div>
            </div>
            
            <div class="prose dark:prose-invert max-w-none text-gray-600 dark:text-gray-300">
                <asp:Literal ID="litContent" runat="server" />
            </div>
            
            <div class="mt-6 pt-4 border-t border-gray-200 dark:border-gray-700">
                <asp:Button ID="btnReply" runat="server" Text="Reply" 
                    CssClass="px-4 py-2 bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-800 text-white font-medium rounded-lg" />
                <asp:Button ID="btnDelete" runat="server" Text="Delete" 
                    CssClass="ml-2 px-4 py-2 bg-red-600 hover:bg-red-700 dark:bg-red-700 dark:hover:bg-red-800 text-white font-medium rounded-lg" 
                    OnClick="btnDelete_Click" />
            </div>
        </div>
    </div>
</asp:Content>