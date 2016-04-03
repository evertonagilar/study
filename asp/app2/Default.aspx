<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:DetailsView ID="DetailsView1" runat="server" AllowPaging="True" 
        AutoGenerateRows="False" DataKeyNames="CódigoDoProduto" 
        DataSourceID="BancoDados" Height="50px" 
        onitemupdating="DetailsView1_ItemUpdating" 
        onpageindexchanging="DetailsView1_PageIndexChanging" Width="605px">
        <Fields>
            <asp:BoundField DataField="CódigoDoProduto" HeaderText="CódigoDoProduto" 
                InsertVisible="False" ReadOnly="True" SortExpression="CódigoDoProduto" />
            <asp:BoundField DataField="NomeDoProduto" HeaderText="NomeDoProduto" 
                SortExpression="NomeDoProduto" />
            <asp:BoundField DataField="QuantidadePorUnidade" 
                HeaderText="QuantidadePorUnidade" SortExpression="QuantidadePorUnidade" />
            <asp:BoundField DataField="PreçoUnitário" HeaderText="PreçoUnitário" 
                SortExpression="PreçoUnitário" />
            <asp:BoundField DataField="UnidadesEmEstoque" HeaderText="UnidadesEmEstoque" 
                SortExpression="UnidadesEmEstoque" />
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" 
                ShowInsertButton="True" />
        </Fields>
        <InsertRowStyle BorderStyle="Dashed" />
    </asp:DetailsView>
    <asp:AccessDataSource ID="BancoDados" runat="server" 
        DataFile="~/App_Data/Northwind.mdb" 
        
        SelectCommand="SELECT [CódigoDoProduto], [NomeDoProduto], [QuantidadePorUnidade], [PreçoUnitário], [UnidadesEmEstoque] FROM [Produtos]" 
        ConflictDetection="CompareAllValues" 
        DeleteCommand="DELETE FROM [Produtos] WHERE [CódigoDoProduto] = ? AND [NomeDoProduto] = ? AND (([QuantidadePorUnidade] = ?) OR ([QuantidadePorUnidade] IS NULL AND ? IS NULL)) AND (([PreçoUnitário] = ?) OR ([PreçoUnitário] IS NULL AND ? IS NULL)) AND (([UnidadesEmEstoque] = ?) OR ([UnidadesEmEstoque] IS NULL AND ? IS NULL))" 
        InsertCommand="INSERT INTO [Produtos] ([CódigoDoProduto], [NomeDoProduto], [QuantidadePorUnidade], [PreçoUnitário], [UnidadesEmEstoque]) VALUES (?, ?, ?, ?, ?)" 
        OldValuesParameterFormatString="original_{0}" 
        UpdateCommand="UPDATE [Produtos] SET [NomeDoProduto] = ?, [QuantidadePorUnidade] = ?, [PreçoUnitário] = ?, [UnidadesEmEstoque] = ? WHERE [CódigoDoProduto] = ? AND [NomeDoProduto] = ? AND (([QuantidadePorUnidade] = ?) OR ([QuantidadePorUnidade] IS NULL AND ? IS NULL)) AND (([PreçoUnitário] = ?) OR ([PreçoUnitário] IS NULL AND ? IS NULL)) AND (([UnidadesEmEstoque] = ?) OR ([UnidadesEmEstoque] IS NULL AND ? IS NULL))">
        <DeleteParameters>
            <asp:Parameter Name="original_CódigoDoProduto" Type="Int32" />
            <asp:Parameter Name="original_NomeDoProduto" Type="String" />
            <asp:Parameter Name="original_QuantidadePorUnidade" Type="String" />
            <asp:Parameter Name="original_QuantidadePorUnidade" Type="String" />
            <asp:Parameter Name="original_PreçoUnitário" Type="Decimal" />
            <asp:Parameter Name="original_PreçoUnitário" Type="Decimal" />
            <asp:Parameter Name="original_UnidadesEmEstoque" Type="Int16" />
            <asp:Parameter Name="original_UnidadesEmEstoque" Type="Int16" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="CódigoDoProduto" Type="Int32" />
            <asp:Parameter Name="NomeDoProduto" Type="String" />
            <asp:Parameter Name="QuantidadePorUnidade" Type="String" />
            <asp:Parameter Name="PreçoUnitário" Type="Decimal" />
            <asp:Parameter Name="UnidadesEmEstoque" Type="Int16" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="NomeDoProduto" Type="String" />
            <asp:Parameter Name="QuantidadePorUnidade" Type="String" />
            <asp:Parameter Name="PreçoUnitário" Type="Decimal" />
            <asp:Parameter Name="UnidadesEmEstoque" Type="Int16" />
            <asp:Parameter Name="original_CódigoDoProduto" Type="Int32" />
            <asp:Parameter Name="original_NomeDoProduto" Type="String" />
            <asp:Parameter Name="original_QuantidadePorUnidade" Type="String" />
            <asp:Parameter Name="original_QuantidadePorUnidade" Type="String" />
            <asp:Parameter Name="original_PreçoUnitário" Type="Decimal" />
            <asp:Parameter Name="original_PreçoUnitário" Type="Decimal" />
            <asp:Parameter Name="original_UnidadesEmEstoque" Type="Int16" />
            <asp:Parameter Name="original_UnidadesEmEstoque" Type="Int16" />
        </UpdateParameters>
    </asp:AccessDataSource>
</asp:Content>
