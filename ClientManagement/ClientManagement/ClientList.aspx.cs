using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ClientManagement
{
    public partial class ClientList : System.Web.UI.Page
    {
        string connectionString = @"Data Source=KHUN\SQLEXPRESS;Initial Catalog=ManagementDB;Integrated Security=True;Encrypt=True;TrustServerCertificate=True";
        SqlConnection con = new SqlConnection();
        SqlCommand cmd = new SqlCommand();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindClients_Data();
            }
        }

        private void BindClients_Data()
        {
            con = new SqlConnection(connectionString);
            cmd = new SqlCommand("Select * from Client", con);

            con.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable table = new DataTable();
            adapter.Fill(table);
            gvClientList.DataSource = table;
            gvClientList.DataBind();
            con.Close();
        }

        protected void gvClientList_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string deleteId = gvClientList.DataKeys[e.RowIndex].Value.ToString();
            con = new SqlConnection(connectionString);
            cmd = new SqlCommand("Delete from Client where ClientId = " + deleteId, con);

            con.Open();
            int r = cmd.ExecuteNonQuery();

            if (r > 0)
            {
                message.Text = "Client data deleted successfully!";
            }
            else
            {
                message.Text = "Error deleting client!";
            }

            con.Close();
            BindClients_Data();
        }

        protected void gvClientList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvClientList.EditIndex = e.NewEditIndex;
            BindClients_Data();
        }

        protected void gvClientList_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvClientList.Rows[e.RowIndex];
            int clientId = Convert.ToInt32(gvClientList.DataKeys[e.RowIndex].Value);

            // Get updated values from the GridView
            string name = (row.Cells[1].Controls[0] as TextBox).Text;
            string email = (row.Cells[2].Controls[0] as TextBox).Text;
            string phone = (row.Cells[3].Controls[0] as TextBox).Text;
            string address = (row.Cells[4].Controls[0] as TextBox).Text;
            string gender = (row.Cells[5].Controls[0] as TextBox).Text;

            con = new SqlConnection(connectionString);
            cmd = new SqlCommand(
                "UPDATE Client SET Name = @Name, Email = @Email, Phone = @Phone, Address = @Address, Gender = @Gender " +
                "WHERE ClientID = @ClientID", con);

            // Add parameters to prevent SQL injection
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@Phone", phone);
            cmd.Parameters.AddWithValue("@Address", address);
            cmd.Parameters.AddWithValue("@Gender", gender);
            cmd.Parameters.AddWithValue("@ClientID", clientId);

            con.Open();
            int r = cmd.ExecuteNonQuery();
            con.Close();

            if (r > 0)
            {
                message.Text = "Client updated successfully!";
            }
            else
            {
                message.Text = "Error updating client!";
            }

            gvClientList.EditIndex = -1;
            BindClients_Data();
        }

        protected void gvClientList_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvClientList.EditIndex = -1;
            BindClients_Data();
        }
    }
}