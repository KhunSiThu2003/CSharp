<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Management.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="V_id" DataSourceID="SqlDataSource1">
                <Columns>
                    <asp:BoundField DataField="V_id" HeaderText="V_id" InsertVisible="False" 
                        ReadOnly="True" SortExpression="V_id" />
                    <asp:BoundField DataField="Common_name" HeaderText="Common_name" 
                        SortExpression="Common_name" />
                    <asp:BoundField DataField="Scientific_name" HeaderText="Scientific_name" 
                        SortExpression="Scientific_name" />
                    <asp:BoundField DataField="Variety" HeaderText="Variety" 
                        SortExpression="Variety" />
                    <asp:BoundField DataField="Description" HeaderText="Description" 
                        SortExpression="Description" />
                    <asp:BoundField DataField="Growing_season" HeaderText="Growing_season" 
                        SortExpression="Growing_season" />
                    <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ManagementDBConnectionString %>" 
                SelectCommand="SELECT * FROM [Vegetables]"></asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
