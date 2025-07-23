<%@ Page Title="Send Message" Language="C#" MasterPageFile="~/CompanySite/Views/Views.Master" AutoEventWireup="true" CodeBehind="SendMessage.aspx.cs" Inherits="JobFinderWebApp.CompanySite.Views.SendMessage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="flex items-center gap-4">
        <asp:HyperLink runat="server" NavigateUrl="~/CompanySite/Views/CompanyApplications.aspx" 
            class="flex items-center text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition-colors">
            <i class="fas fa-arrow-left mr-2"></i>Back to Applications
        </asp:HyperLink>
        <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">Send Message</h1>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">
        <div class="p-6">
            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">To</label>
                    <div class="text-gray-900 dark:text-white font-medium">
                        <asp:Literal ID="litRecipientName" runat="server" />
                    </div>
                </div>
                
                <div>
                    <label for="txtSubject" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Subject</label>
                    <asp:TextBox ID="txtSubject" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-800 rounded-md shadow-sm" />
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject"
                        ErrorMessage="Subject is required" CssClass="text-red-500 text-sm" Display="Dynamic" />
                </div>
                
                <div>
                    <label for="txtContent" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Message</label>
                    <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="8" 
                        CssClass="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-800 rounded-md shadow-sm" />
                    <asp:RequiredFieldValidator ID="rfvContent" runat="server" ControlToValidate="txtContent"
                        ErrorMessage="Message content is required" CssClass="text-red-500 text-sm" Display="Dynamic" />
                </div>
                
                <div class="flex justify-end gap-3 pt-4">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                        CssClass="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md text-sm font-medium" 
                        OnClick="btnCancel_Click" CausesValidation="false" />
                    <asp:Button ID="btnSend" runat="server" Text="Send Message" 
                        CssClass="px-4 py-2 bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-800 text-white font-medium rounded-md" 
                        OnClick="btnSend_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>