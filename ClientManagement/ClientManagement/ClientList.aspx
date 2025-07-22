<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClientList.aspx.cs" Inherits="ClientManagement.ClientList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Client List</title>
    <!-- Tailwind CSS CDN for quick styling -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
        rel="stylesheet">
</head>
<body class="bg-gray-100 text-gray-900">
    <form id="form1" runat="server">

        <div class="max-w-6xl mx-auto mt-10 px-6">

            <!-- Success/Info/Error message area -->
            <div 
                class="mb-4 px-4 py-3 rounded relative  bg-blue-50 text-blue-700"
                role="alert">
                <asp:Literal ID="message" runat="server"></asp:Literal>
            </div>


            <!-- Header -->
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-3xl font-bold">Client List</h1>
                <a href="InsertClientForm.aspx" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition">
                    Add New Client
                </a>
            </div>

            <!-- GridView Styling -->
            <!-- Update the GridView in ClientList.aspx to include proper edit controls -->
<asp:GridView ID="gvClientList" runat="server" DataKeyNames="ClientID" AutoGenerateColumns="False"
    OnRowCancelingEdit="gvClientList_RowCancelingEdit"
    OnRowDeleting="gvClientList_RowDeleting"
    OnRowEditing="gvClientList_RowEditing"
    OnRowUpdating="gvClientList_RowUpdating"
    CssClass="min-w-full divide-y divide-gray-200 shadow-md rounded-lg overflow-hidden bg-white"
    GridLines="None" HeaderStyle-CssClass="bg-gray-200 text-left text-sm font-semibold text-gray-700"
    RowStyle-CssClass="text-sm text-gray-800 hover:bg-gray-100 transition">

    <Columns>
        <asp:BoundField DataField="ClientID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="px-4 py-2"/>
        <asp:BoundField DataField="Name" HeaderText="Name" ItemStyle-CssClass="px-4 py-2"/>
        <asp:BoundField DataField="Email" HeaderText="Email" ItemStyle-CssClass="px-4 py-2"/>
        <asp:BoundField DataField="Phone" HeaderText="Phone No" ItemStyle-CssClass="px-4 py-2"/>
        <asp:BoundField DataField="Address" HeaderText="Address" ItemStyle-CssClass="px-4 py-2"/>
        <asp:BoundField DataField="Gender" HeaderText="Gender" ItemStyle-CssClass="px-4 py-2"/>

        <asp:CommandField 
            ButtonType="Button" 
            ShowEditButton="True" 
            HeaderText="Edit"
            EditText="Edit"
            UpdateText="Update"
            CancelText="Cancel"
            ControlStyle-CssClass="px-3 py-1 bg-blue-500 text-white rounded hover:bg-blue-600 mr-2"
            ItemStyle-CssClass="px-4 py-2"/>

        <asp:CommandField 
            ButtonType="Button" 
            ShowDeleteButton="True" 
            HeaderText="Delete"
            DeleteText="Delete"
            ControlStyle-CssClass="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600"
            ItemStyle-CssClass="px-4 py-2"/>
    </Columns>

    <HeaderStyle CssClass="bg-gray-200 text-left text-sm font-semibold text-gray-700"/>
    <RowStyle CssClass="text-sm text-gray-800 hover:bg-gray-100 transition"/>
</asp:GridView>

        </div>

    </form>
</body>
</html>
