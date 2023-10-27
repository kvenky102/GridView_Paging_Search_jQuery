using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;


public partial class CS : System.Web.UI.Page
{
    private static int PageSize = 5;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDummyRow();
        }
    }

    private void BindDummyRow()
    {
        // static datatable //
        DataTable dummy = new DataTable();
        dummy.Columns.Add("Case_Owner");
        dummy.Columns.Add("UPF_ID");
        dummy.Columns.Add("Loaded_Date"); dummy.Columns.Add("Uploaded_by"); dummy.Columns.Add("Region"); dummy.Columns.Add("Scope"); dummy.Columns.Add("Process"); dummy.Columns.Add("Sub_process");
        dummy.Columns.Add("Country"); dummy.Columns.Add("Sales_Order_Number"); dummy.Columns.Add("Input_source"); dummy.Columns.Add("Received_date"); dummy.Columns.Add("Order_Priority");
        dummy.Columns.Add("Rework_Revision"); dummy.Columns.Add("Pact_Status"); dummy.Columns.Add("Internal_TAT"); dummy.Columns.Add("External_TAT"); dummy.Columns.Add("Rooster_Status");
        dummy.Columns.Add("Inflowid"); 
        
        dummy.Rows.Add();
        gvCustomers.DataSource = dummy;
        gvCustomers.DataBind();
    }

   // static Web Method //
    [WebMethod]
    public static string GetCustomers(string searchTerm, int pageIndex)
    {
        string query = "[GetMatrics_Select]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@SearchTerm", searchTerm);
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

// static Web Method //
    private static DataSet GetData(SqlCommand cmd, int pageIndex)
    {
        string strConnString = ConfigurationManager.ConnectionStrings["conString"].ConnectionString;
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "Results");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

// static GetCustomerDetails Method //
    [WebMethod]
    public static string GetCustomerDetails(string id)
    {
        string constr = ConfigurationManager.ConnectionStrings["conString"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
            //using (SqlCommand cmd = new SqlCommand("SELECT CustomerID,ContactName,City,Country FROM Customers WHERE CustomerID=@CustomerID", con))
            //{
            //    cmd.Parameters.AddWithValue("@CustomerID", id);
            //    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            //    {
            //        DataSet ds = new DataSet();
            //        da.Fill(ds, "UPF_WorkFlow");

            //        return ds.GetXml();
            //    }
            //}

            using (SqlCommand cmd = new SqlCommand("spSSRoster_UpfWorkflow_SelectViewByID"))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;
                cmd.Parameters.Add("@ID", SqlDbType.VarChar,250);
                cmd.Parameters["@ID"].Value = id;
                
                
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    con.Open();    
                    DataSet ds = new DataSet();
                    da.Fill(ds, "UPF_WorkFlow");
                    con.Close();
                    return ds.GetXml();
                    
                }
                
            }
        }
    }

    protected void Save(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsoluteUri);
    }

     protected void Save_old(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsoluteUri);
    }

}