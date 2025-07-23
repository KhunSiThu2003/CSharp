using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobFinderWebApp.CompanySite.AuthPages
{
    public partial class AuthPages : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["JobFinderDB"].ConnectionString))
                {
                    conn.Open();
                    
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                Response.Write("ERROR: " + ex.Message);
            }
        }
    }
}