using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Management
{
    public partial class Student : System.Web.UI.Page
    {
        // Define your connection string (adjust as needed)
        SqlConnection con = new SqlConnection(@"Data Source=KHUN\SQLEXPRESS;Initial Catalog=ManagementDB;Integrated Security=True;TrustServerCertificate=True");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                btnUpdate.Text = "Insert";
                btnDel.Enabled = false;
                lab.Text = "Student Insert FORM";
                DisplayGridView();
            }
        }

        public void DisplayGridView()
        {
            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Student", con))
            {
                da.Fill(dt);
            }

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        protected void lnk_OKCLICK(object sender, EventArgs e)
        {
            btnUpdate.Text = "Update";
            btnDel.Enabled = true;
            lab.Text = "Student Update and Delete FORM";

            int id = Convert.ToInt32((sender as LinkButton).CommandArgument);
            hfS_Id.Value = id.ToString();

            DataTable dt = new DataTable();
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM Student WHERE S_Id = @ID", con))
            {
                cmd.Parameters.AddWithValue("@ID", id);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            if (dt.Rows.Count > 0)
            {
                txtname.Text = dt.Rows[0]["S_Name"].ToString();
                txtemail.Text = dt.Rows[0]["S_Email"].ToString();
                txtdob.Text = Convert.ToDateTime(dt.Rows[0]["S_DOB"]).ToString("yyyy-MM-dd"); // HTML5 format
                txtphone.Text = dt.Rows[0]["S_Phone"].ToString();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string name = txtname.Text.Trim();
            string email = txtemail.Text.Trim();
            string phone = txtphone.Text.Trim();
            string dobText = txtdob.Text.Trim();

            DateTime dob;
            if (!DateTime.TryParse(dobText, out dob))
            {
                // fallback: show error or skip execution
                return;
            }

            if (btnUpdate.Text == "Insert")
            {
                using (SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Student (S_Name, S_Email, S_DOB, S_Phone) VALUES (@Name, @Email, @DOB, @Phone)", con))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@DOB", dob);
                    cmd.Parameters.AddWithValue("@Phone", phone);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
            else
            {
                int ID = Convert.ToInt32(hfS_Id.Value);
                using (SqlCommand cmd = new SqlCommand(
                    "UPDATE Student SET S_Name=@Name, S_Email=@Email, S_DOB=@DOB, S_Phone=@Phone WHERE S_Id=@ID", con))
                {
                    cmd.Parameters.AddWithValue("@ID", ID);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@DOB", dob);
                    cmd.Parameters.AddWithValue("@Phone", phone);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            clear();
            DisplayGridView();
        }

        protected void btnDel_Click(object sender, EventArgs e)
        {
            int ID = Convert.ToInt32(hfS_Id.Value);
            using (SqlCommand cmd = new SqlCommand("DELETE FROM Student WHERE S_Id = @ID", con))
            {
                cmd.Parameters.AddWithValue("@ID", ID);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            clear();
            DisplayGridView();
        }

        public void clear()
        {
            hfS_Id.Value = "";
            txtname.Text = "";
            txtemail.Text = "";
            txtdob.Text = "";
            txtphone.Text = "";

            btnUpdate.Text = "Insert";
            btnDel.Enabled = false;
            lab.Text = "Student Insert FORM";
        }
    }
}
