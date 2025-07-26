<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Student.aspx.cs" Inherits="Management.Student" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Management</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <form id="form1" runat="server">
        <div class="max-w-4xl mx-auto mt-10 bg-white shadow-md rounded-xl p-8">
            <asp:Label ID="lab" runat="server" CssClass="text-2xl font-bold underline text-blue-600 block mb-6" />

            <asp:HiddenField ID="hfS_Id" runat="server" />

            <!-- Form Inputs -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block mb-1 font-medium text-gray-700">Name</label>
                    <asp:TextBox ID="txtname" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="InUp"
                        ControlToValidate="txtname" CssClass="text-red-500 text-sm" Display="Dynamic"
                        ErrorMessage="Please Enter Your Name" />
                </div>
                <div>
                    <label class="block mb-1 font-medium text-gray-700">Email</label>
                    <asp:TextBox ID="txtemail" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="InUp"
                        ControlToValidate="txtemail" CssClass="text-red-500 text-sm" Display="Dynamic"
                        ErrorMessage="Email field Required" />
                </div>
                <div>
                    <label class="block mb-1 font-medium text-gray-700">Date of Birth</label>
                    <asp:TextBox ID="txtdob" runat="server" TextMode="Date"
                        CssClass="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ValidationGroup="InUp"
                        ControlToValidate="txtdob" CssClass="text-red-500 text-sm" Display="Dynamic"
                        ErrorMessage="DOB field required" />
                </div>

                <div>
                    <label class="block mb-1 font-medium text-gray-700">Phone</label>
                    <asp:TextBox ID="txtphone" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="InUp"
                        ControlToValidate="txtphone" CssClass="text-red-500 text-sm" Display="Dynamic"
                        ErrorMessage="Phone Number Required" />
                </div>
            </div>

            <!-- Buttons -->
            <div class="mt-8 flex gap-4">
                <asp:Button ID="btnUpdate" runat="server" ValidationGroup="InUp" CssClass="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-md font-semibold"
                    OnClick="btnUpdate_Click" Text="Insert" />
                <asp:Button ID="btnDel" runat="server" CssClass="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-md font-semibold disabled:opacity-50"
                    OnClick="btnDel_Click" Text="Delete" />
            </div>

            <asp:ValidationSummary ID="ValidationSummary1" ValidationGroup="InUp" CssClass="text-red-500 mt-4 text-sm"
                runat="server" />

            <!-- GridView -->
            <div class="mt-10">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" DataKeyNames="S_Id"
                    CssClass="w-full text-sm text-left border border-gray-300 rounded-md shadow-sm">
                    <Columns>
                        <asp:BoundField DataField="S_Name" HeaderText="Name" />
                        <asp:BoundField DataField="S_Email" HeaderText="Email" />
                        <asp:BoundField DataField="S_DOB" HeaderText="DOB" />
                        <asp:BoundField DataField="S_Phone" HeaderText="Phone" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="LnkView" runat="server" CommandArgument='<%# Eval("S_Id") %>'
                                    OnClick="lnk_OKCLICK" CssClass="text-blue-500 hover:underline">View</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
