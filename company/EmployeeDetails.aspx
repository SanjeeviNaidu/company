<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="~/EmployeeDetails.aspx.cs" Inherits="company.EmployeeDetails" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.1/css/bootstrap.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <form id="form2" runat="server">
        <div class="container mt-5">
            <h2>Employee Details</h2>
            <div class="card p-3">
                <div class="mb-3">
                    <label for="txtName" class="form-label">Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label for="txtDesignation" class="form-label">Designation</label>
                    <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label for="txtDOJ" class="form-label">Date of Joining</label>
                    <asp:TextBox ID="txtDOJ" runat="server" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label for="txtSalary" class="form-label">Salary</label>
                    <asp:TextBox ID="txtSalary" runat="server" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Gender</label>
                    <div>
                        <asp:RadioButton ID="rbMale" runat="server" GroupName="Gender" Text="Male" CssClass="form-check-input" />
                        <label class="form-check-label" for="rbMale"></label>
                        <asp:RadioButton ID="rbFemale" runat="server" GroupName="Gender" Text="Female" CssClass="form-check-input ms-3" />
                        <label class="form-check-label" for="rbFemale"></label>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="ddlState" class="form-label">State</label>
                    <asp:DropDownList ID="ddlState" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Select State" Value="" />
                        <asp:ListItem Text="Andhra Pradesh" Value="Andhra Pradesh" />
                        <asp:ListItem Text="Telangana" Value="Telangana" />
                        <asp:ListItem Text="Karnataka" Value="Karnataka" />
                        <asp:ListItem Text="Tamil Nadu" Value="Tamil Nadu" />
                    </asp:DropDownList>
                </div>
                <div class="mb-3">
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary me-3" OnClick="btnSave_Click" />
                    <asp:Button ID="btnNew" runat="server" Text="New Employee" CssClass="btn btn-secondary" />
                </div>
            </div>

            <h3 class="mt-5">Employee List</h3>
            <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" CssClass="table table-striped mt-3" OnRowCommand="gvEmployees_RowCommand">

                <Columns>
                    <asp:BoundField DataField="EmployeeID" HeaderText="S.No." />
                    <asp:BoundField DataField="Name" HeaderText="Name" />
                    <asp:BoundField DataField="Designation" HeaderText="Designation" />
                    <asp:BoundField DataField="DOJ" HeaderText="Date of Joining" />
                    <asp:BoundField DataField="Salary" HeaderText="Salary" />
                    <asp:BoundField DataField="Gender" HeaderText="Gender" />
                    <asp:BoundField DataField="State" HeaderText="State" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteRecord" CommandArgument='<%# Eval("EmployeeID") %>' CssClass="btn btn-danger btn-sm" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <div class="mt-3">
                <strong>Total Salary: </strong>
                <asp:Label ID="lblTotalSalary" runat="server" Text="0" />
            </div>
        </div>
    </form>
    <script>
        $(document).ready(function () {
            // Basic jQuery validation
            $("#btnSave").click(function (e) {
                if ($("#<%= txtName.ClientID %>").val() === "") {
                    alert("Name is required.");
                    e.preventDefault();
                    return false;
                }
                if ($("#<%= txtDesignation.ClientID %>").val() === "") {
                    alert("Designation is required.");
                    e.preventDefault();
                    return false;
                }
                if ($("#<%= txtSalary.ClientID %>").val() === "" || isNaN($("#<%= txtSalary.ClientID %>").val())) {
                    alert("Valid salary is required.");
                    e.preventDefault();
                    return false;
                }
                if ($("#<%= ddlState.ClientID %>").val() === "") {
                    alert("Please select a state.");
                    e.preventDefault();
                    return false;
                }
            });

            $("#btnNew").click(function () {
                $("#<%= txtName.ClientID %>, #<%= txtDesignation.ClientID %>, #<%= txtDOJ.ClientID %>, #<%= txtSalary.ClientID %>").val("");
                $("input[name='Gender']").prop("checked", false);
                $("#<%= ddlState.ClientID %>").val("");
            });
        });
    </script>
</body>
</html>
