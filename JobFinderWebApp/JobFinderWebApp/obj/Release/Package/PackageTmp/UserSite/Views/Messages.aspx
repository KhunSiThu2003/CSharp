<%@ Page Title="Messages" Language="C#" MasterPageFile="~/UserSite/Views/Views.Master"
    AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="JobFinderWebApp.UserSite.Views.Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
     <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-200">Messages</h1>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="max-w-2xl mx-auto p-4">
        <!-- Search Bar -->
        <div class="mb-4">
            <div class="relative">
                <asp:TextBox ID="txtSearch" runat="server" 
                    CssClass="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" 
                    placeholder="Search for users or companies..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                    </svg>
                </div>
            </div>
        </div>

        <!-- Search Results -->
        <asp:Panel ID="pnlSearchResults" runat="server" Visible="false" CssClass="mb-6 bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
            <div class="p-3 border-b border-gray-100 bg-gray-50">
                <h3 class="text-sm font-semibold text-gray-800">Search Results</h3>
            </div>
            <asp:Repeater ID="rptSearchResults" runat="server">
                <ItemTemplate>
                    <div onclick="location.href='MessageRoom.aspx?id=<%# Eval("Id") %>'" 
                         class="flex items-center p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer transition-colors duration-150">
                        <img src='<%# Eval("Image") %>' 
                             class="w-10 h-10 rounded-full object-cover mr-3 border border-gray-200" 
                             alt='<%# Eval("Name") %>' />
                        <div class="flex-1 min-w-0">
                            <h3 class="text-sm font-semibold text-gray-800 truncate"><%# Eval("Name") %></h3>
                            <p class="text-xs text-gray-500 truncate"><%# Eval("Type") %></p>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:Panel runat="server" Visible='<%# rptSearchResults.Items.Count == 0 %>'>
                        <div class="p-4 text-center">
                            <h3 class="text-sm font-medium text-gray-900">No results found</h3>
                            <p class="text-xs text-gray-500">Try a different search term</p>
                        </div>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>

        <!-- Conversations List -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
            <asp:Repeater ID="rptConversations" runat="server">
                <ItemTemplate>
                    <div onclick="location.href='MessageRoom.aspx?id=<%# Eval("PartnerId") %>'" 
                         class="flex items-center p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer transition-colors duration-150">
                        <img src='<%# Eval("PartnerImage") %>' 
                             class="w-12 h-12 rounded-full object-cover mr-4 border border-gray-200" 
                             alt='<%# Eval("PartnerName") %>' />
                        <div class="flex-1 min-w-0">
                            <div class="flex justify-between items-baseline">
                                <h3 class="text-sm font-semibold text-gray-800 truncate"><%# Eval("PartnerName") %></h3>
                                <span class="text-xs text-gray-500 ml-2 whitespace-nowrap"><%# Eval("LastMessageTime", "{0:g}") %></span>
                            </div>
                            <p class="text-sm text-gray-600 truncate"><%# Eval("DisplayMessage") %></p>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:Panel runat="server" Visible='<%# rptConversations.Items.Count == 0 %>'>
                        <div class="p-8 text-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mx-auto text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
                            </svg>
                            <h3 class="mt-2 text-sm font-medium text-gray-900">No messages yet</h3>
                            <p class="mt-1 text-sm text-gray-500">Start a conversation with someone to see it here.</p>
                        </div>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>