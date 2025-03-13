using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace company
{
    public partial class EmployeeDetails : System.Web.UI.Page
    {

        public static string connectionString = ConfigurationManager.ConnectionStrings["conncetions"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGridView();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        string query;

                        // Check if we're inserting or updating
                        if (ViewState["EmployeeID"] == null) // Insert logic
                        {
                            query = "INSERT INTO Employees (Name, Designation, DOJ, Salary, Gender, State) " +
                                    "VALUES (@Name, @Designation, @DOJ, @Salary, @Gender, @State)";
                        }
                        else // Update logic (not triggered during save for a new record)
                        {
                            query = "UPDATE Employees SET Name = @Name, Designation = @Designation, DOJ = @DOJ, " +
                                    "Salary = @Salary, Gender = @Gender, State = @State WHERE EmployeeID = @EmployeeID";
                        }

                        SqlCommand cmd = new SqlCommand(query, conn);

                        // Common parameters for Insert and Update
                        cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Designation", txtDesignation.Text.Trim());
                        cmd.Parameters.AddWithValue("@DOJ", DateTime.Parse(txtDOJ.Text.Trim()));
                        cmd.Parameters.AddWithValue("@Salary", decimal.Parse(txtSalary.Text.Trim()));
                        cmd.Parameters.AddWithValue("@Gender", rbMale.Checked ? "Male" : "Female");
                        cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue);

                        if (ViewState["EmployeeID"] != null) // Add EmployeeID parameter for Update
                        {
                            cmd.Parameters.AddWithValue("@EmployeeID", ViewState["EmployeeID"]);
                        }

                        cmd.ExecuteNonQuery();

                        // Success message
                        lblTotalSalary.Text = ViewState["EmployeeID"] == null ? "New Employee Added Successfully!" : "Employee Updated Successfully!";

                        
                        ViewState["EmployeeID"] = null;

                        // Refresh the GridView
                        BindGridView();
                    }
                }
                catch (Exception ex)
                {
                    lblTotalSalary.Text = "Error: " + ex.Message;
                }
            }

        
        private void BindGridView()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Employees", conn);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                gvEmployees.DataSource = dt;
                gvEmployees.DataBind();

                // Calculate total salary
                if (dt.Rows.Count > 0)
                {
                    decimal totalSalary = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        totalSalary += Convert.ToDecimal(row["Salary"]);
                    }
                    lblTotalSalary.Text = totalSalary.ToString("C");

                }

            }
        }
        protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
             if (e.CommandName == "DeleteRecord")
            {
                // Convert the CommandArgument to an integer EmployeeID
                int employeeId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Employees WHERE EmployeeID = @EmployeeID", conn);
                    cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Refresh the GridView
                BindGridView();
            }
        }


    }
}
