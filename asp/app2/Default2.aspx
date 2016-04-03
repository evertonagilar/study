<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:FormView ID="FormView1" runat="server" AllowPaging="True" 
            DataKeyNames="CódigoDaCategoria" DataSourceID="AccessDataSource1">
            <EditItemTemplate>
                CódigoDaCategoria:
                <asp:Label ID="CódigoDaCategoriaLabel1" runat="server" 
                    Text='<%# Eval("CódigoDaCategoria") %>' />
                <br />
                NomeDaCategoria:
                <asp:TextBox ID="NomeDaCategoriaTextBox" runat="server" 
                    Text='<%# Bind("NomeDaCategoria") %>' />
                <br />
                Descrição:
                <asp:TextBox ID="DescriçãoTextBox" runat="server" 
                    Text='<%# Bind("Descrição") %>' />
                <br />
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                NomeDaCategoria:
                <asp:TextBox ID="NomeDaCategoriaTextBox" runat="server" 
                    Text='<%# Bind("NomeDaCategoria") %>' />
                <br />
                Descrição:
                <asp:TextBox ID="DescriçãoTextBox" runat="server" 
                    Text='<%# Bind("Descrição") %>' />
                <br />
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                    CommandName="Insert" Text="Insert" />
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                CódigoDaCategoria:
                <asp:Label ID="CódigoDaCategoriaLabel" runat="server" 
                    Text='<%# Eval("CódigoDaCategoria") %>' />
                <br />
                NomeDaCategoria:
                <asp:Label ID="NomeDaCategoriaLabel" runat="server" 
                    Text='<%# Bind("NomeDaCategoria") %>' />
                <br />
                Descrição:
                <asp:Label ID="DescriçãoLabel" runat="server" Text='<%# Bind("Descrição") %>' />
                <br />
                <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" 
                    CommandName="Edit" Text="Edit" />
                &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" 
                    CommandName="Delete" Text="Delete" />
                &nbsp;<asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" 
                    CommandName="New" Text="New" />
            </ItemTemplate>
        </asp:FormView>
        <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
            DataFile="~/App_Data/Northwind.mdb" 
            DeleteCommand="DELETE FROM [Categorias] WHERE [CódigoDaCategoria] = ?" 
            InsertCommand="INSERT INTO [Categorias] ([CódigoDaCategoria], [NomeDaCategoria], [Descrição]) VALUES (?, ?, ?)" 
            SelectCommand="SELECT [CódigoDaCategoria], [NomeDaCategoria], [Descrição] FROM [Categorias]" 
            UpdateCommand="UPDATE [Categorias] SET [NomeDaCategoria] = ?, [Descrição] = ? WHERE [CódigoDaCategoria] = ?">
            <DeleteParameters>
                <asp:Parameter Name="CódigoDaCategoria" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="CódigoDaCategoria" Type="Int32" />
                <asp:Parameter Name="NomeDaCategoria" Type="String" />
                <asp:Parameter Name="Descrição" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="NomeDaCategoria" Type="String" />
                <asp:Parameter Name="Descrição" Type="String" />
                <asp:Parameter Name="CódigoDaCategoria" Type="Int32" />
            </UpdateParameters>
        </asp:AccessDataSource>
    
    </div>
    </form>
</body>
</html>
