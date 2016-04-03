<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default3.aspx.cs" Inherits="Default3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:DataList ID="DataList1" runat="server" BackColor="LightGoldenrodYellow" 
            BorderColor="Tan" BorderWidth="1px" CellPadding="2" 
            DataKeyField="CódigoDaCategoria" DataSourceID="AccessDataSource1" 
            ForeColor="Black" RepeatColumns="3" Width="656px">
            <AlternatingItemStyle BackColor="PaleGoldenrod" />
            <FooterStyle BackColor="Tan" />
            <HeaderStyle BackColor="Tan" Font-Bold="True" />
            <ItemTemplate>
                CódigoDaCategoria:
                <asp:Label ID="CódigoDaCategoriaLabel" runat="server" 
                    Text='<%# Eval("CódigoDaCategoria") %>' />
                <br />
                NomeDaCategoria:
                <asp:Label ID="NomeDaCategoriaLabel" runat="server" 
                    Text='<%# Eval("NomeDaCategoria") %>' />
                <br />
                Descrição:
                <asp:Label ID="DescriçãoLabel" runat="server" Text='<%# Eval("Descrição") %>' />
                <br />
                Figura:
                <asp:Label ID="FiguraLabel" runat="server" Text='<%# Eval("Figura") %>' />
                <br />
<br />
            </ItemTemplate>
            <SelectedItemStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
        </asp:DataList>
        <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
            ConflictDetection="CompareAllValues" DataFile="~/App_Data/Northwind.mdb" 
            DeleteCommand="DELETE FROM [Categorias] WHERE [CódigoDaCategoria] = ? AND [NomeDaCategoria] = ? AND (([Descrição] = ?) OR ([Descrição] IS NULL AND ? IS NULL)) AND (([Figura] = ?) OR ([Figura] IS NULL AND ? IS NULL))" 
            InsertCommand="INSERT INTO [Categorias] ([CódigoDaCategoria], [NomeDaCategoria], [Descrição], [Figura]) VALUES (?, ?, ?, ?)" 
            OldValuesParameterFormatString="original_{0}" 
            SelectCommand="SELECT [CódigoDaCategoria], [NomeDaCategoria], [Descrição], [Figura] FROM [Categorias]" 
            UpdateCommand="UPDATE [Categorias] SET [NomeDaCategoria] = ?, [Descrição] = ?, [Figura] = ? WHERE [CódigoDaCategoria] = ? AND [NomeDaCategoria] = ? AND (([Descrição] = ?) OR ([Descrição] IS NULL AND ? IS NULL)) AND (([Figura] = ?) OR ([Figura] IS NULL AND ? IS NULL))">
            <DeleteParameters>
                <asp:Parameter Name="original_CódigoDaCategoria" Type="Int32" />
                <asp:Parameter Name="original_NomeDaCategoria" Type="String" />
                <asp:Parameter Name="original_Descrição" Type="String" />
                <asp:Parameter Name="original_Descrição" Type="String" />
                <asp:Parameter Name="original_Figura" Type="Object" />
                <asp:Parameter Name="original_Figura" Type="Object" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="CódigoDaCategoria" Type="Int32" />
                <asp:Parameter Name="NomeDaCategoria" Type="String" />
                <asp:Parameter Name="Descrição" Type="String" />
                <asp:Parameter Name="Figura" Type="Object" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="NomeDaCategoria" Type="String" />
                <asp:Parameter Name="Descrição" Type="String" />
                <asp:Parameter Name="Figura" Type="Object" />
                <asp:Parameter Name="original_CódigoDaCategoria" Type="Int32" />
                <asp:Parameter Name="original_NomeDaCategoria" Type="String" />
                <asp:Parameter Name="original_Descrição" Type="String" />
                <asp:Parameter Name="original_Descrição" Type="String" />
                <asp:Parameter Name="original_Figura" Type="Object" />
                <asp:Parameter Name="original_Figura" Type="Object" />
            </UpdateParameters>
        </asp:AccessDataSource>
    
    </div>
    </form>
</body>
</html>
