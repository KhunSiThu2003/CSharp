<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InsertClientForm.aspx.cs"
    Inherits="ClientManagement.InsertClientForm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Insert Client</title>
    <!-- Tailwind CDN for demo. Replace with your compiled CSS in production -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 text-gray-900">
    <form id="form1" runat="server">
        <div class="max-w-xl mx-auto p-6 mt-10 bg-white shadow-md rounded-xl space-y-6">

            <h2 class="text-2xl font-bold text-center">Insert Client</h2>

            <!-- Name -->
            <div>
                <asp:Label AssociatedControlID="txtName" ID="Label1" runat="server" CssClass="block font-semibold mb-1" Text="Name"></asp:Label>
                <asp:TextBox ID="txtName" runat="server" CssClass="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="txtName" ID="RequiredFieldValidator1" runat="server" ForeColor="Red" CssClass="text-sm text-red-600" ErrorMessage="Name is required!"></asp:RequiredFieldValidator>
            </div>

            <!-- Email -->
            <div>
                <asp:Label AssociatedControlID="txtEmail" ID="Label2" runat="server" CssClass="block font-semibold mb-1" Text="Email"></asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="txtEmail" ID="RequiredFieldValidator2" runat="server" ForeColor="Red" CssClass="text-sm text-red-600" ErrorMessage="Email is required!"></asp:RequiredFieldValidator>
            </div>

            <!-- Phone -->
            <div>
                <asp:Label AssociatedControlID="txtPhone" ID="Label3" runat="server" CssClass="block font-semibold mb-1" Text="Phone Number"></asp:Label>
                <asp:TextBox ID="txtPhone" runat="server" TextMode="Number" CssClass="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="txtPhone" ID="RequiredFieldValidator3" runat="server" ForeColor="Red" CssClass="text-sm text-red-600" ErrorMessage="Phone number is required!"></asp:RequiredFieldValidator>
            </div>

            <!-- Address -->
            <div>
                <asp:Label AssociatedControlID="txtAddress" ID="Label4" runat="server" CssClass="block font-semibold mb-1" Text="Address"></asp:Label>
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" CssClass="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="txtAddress" ID="RequiredFieldValidator4" runat="server" ForeColor="Red" CssClass="text-sm text-red-600" ErrorMessage="Address is required!"></asp:RequiredFieldValidator>
            </div>

            <!-- Gender -->
            <div>
                <asp:Label ID="Label5" runat="server" CssClass="block font-semibold mb-2" Text="Gender"></asp:Label>
                <div class="flex space-x-6">
                    <label class="inline-flex items-center space-x-2">
                        <asp:RadioButton ID="radMale" runat="server" GroupName="gender" />
                        <span>Male</span>
                    </label>
                    <label class="inline-flex items-center space-x-2">
                        <asp:RadioButton ID="radFemale" runat="server" GroupName="gender" />
                        <span>Female</span>
                    </label>
                    <label class="inline-flex items-center space-x-2">
                        <asp:RadioButton ID="radOther" runat="server" GroupName="gender" />
                        <span>Other</span>
                    </label>
                </div>
            </div>

            <!-- Buttons -->
            <div class="flex justify-end space-x-4 pt-4">
                <a href="ClientList.aspx" class="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400" >Cancel</a>
                <asp:Button ID="btnAddClient" runat="server" Text="Add Client" OnClick="btnAddClient_Click"
                    CssClass="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700" />
            </div>

        </div>
    </form>
</body>
</html>
