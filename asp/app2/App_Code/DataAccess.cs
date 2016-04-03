using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Summary description for DataAccess
/// </summary>
public class DataAccess
{
	public DataAccess()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public DataSet getListaCategorias()
    {
        string conexao = "Database=northwind;server=(local);user id=sa";
        string sql = "SELECT * FROM Categories";
        SqlConnection conn = new SqlConnection(conexao);
        SqlCommand command = new SqlCommand(sql, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(command);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        return ds;
    }

}