using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ClientManagement
{
    public partial class InsertClientForm : System.Web.UI.Page
    {

        string connectionString = @"Data Source=KHUN\SQLEXPRESS;Initial Catalog=ManagementDB;Integrated Security=True;Encrypt=True;TrustServerCertificate=True";
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        private string getGender()
        {
            if (radMale.Checked) return "Male";
            else if (radFemale.Checked) return "Female";
            else return "Other";
        }


        protected void btnAddClient_Click(object sender, EventArgs e)
        {
            string name = txtName.Text;
            string email = txtEmail.Text;
            string phone = txtPhone.Text;
            string address = txtAddress.Text;

            string gender = getGender();

            SqlConnection con = new SqlConnection(connectionString);
            con.Open();

            string insertQuery = "Insert into Client (Name,Email,Phone,Address,Gender) values ('" + name + "','" + email + "','" + phone + "','" + address + "','" + gender + "')";

            SqlCommand cmd = new SqlCommand(insertQuery, con);

            

            int r = cmd.ExecuteNonQuery();

            if (r > 0)
            {
                Response.Redirect("ClientList.aspx");
            } else
            {
                Response.Write("Something is error!");
            }

            con.Close();

        }
    }
}