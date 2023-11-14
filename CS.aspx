
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CS.aspx.cs" Inherits="CS" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            font-family: Arial;
            font-size: 10pt;
        }
        table
        {
            border: 1px solid #ccc;
        }
        table th
        {
            background-color: #F7F7F7;
            color: #333;
            font-weight: bold;
        }
        table th, table td
        {
            padding: 5px;
            border-color: #ccc;
        }
        .Pager span
        {
            color: #333;
            background-color: #F7F7F7;
            font-weight: bold;
            text-align: center;
            display: inline-block;
            width: 20px;
            margin-right: 3px;
            line-height: 150%;
            border: 1px solid #ccc;
        }
        .Pager a
        {
            text-align: center;
            display: inline-block;
            width: 20px;
            border: 1px solid #ccc;
            color: #fff;
            color: #333;
            margin-right: 3px;
            line-height: 150%;
            text-decoration: none;
        }
        .highlight
        {
            background-color: #FFFFAF;
        }
       
    </style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script src="ASPSnippets_Pager.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            GetCustomers(1);
        });
        $("[id*=txtSearch]").live("keyup", function () {
            GetCustomers(parseInt(1));
        });
        $("[id*=lnkModal]").live("click", function () {
            var id = $(this).closest('tr').find('td').eq(18).html();
            $.ajax({
                type: "POST",
                url: "CS.aspx/GetCustomerDetails",
                data: '{id: "' + id + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var xmlDoc = $.parseXML(response.d);
                    var xml = $(xmlDoc);
                    // nickname = serverside name
                    var XML_Data = xml.find("UPF_WorkFlow");
                    if (XML_Data.length > 0) {
                        $.each(XML_Data, function () {
                            var UPF_WorkFlow_Edit = $(this)
                            // nickname = db name //
                            var CaseOwner = $(this).find("Case_Owner").text();
                            var UPF_ID = $(this).find("UPF_ID").text();
                            var Loaded_Date = $(this).find("Loaded_Date").text();
                            var Uploaded_by = $(this).find("Uploaded_by").text();
                            var Region = $(this).find("Region").text();
                            var Scope = $(this).find("Scope").text();
                            var Process = $(this).find("Process").text();
                            var Sub_process = $(this).find("Sub_process").text();
                            var Country = $(this).find("Country").text();
                            var Sales_Order_Number = $(this).find("Sales_Order_Number").text();
                            var Input_source = $(this).find("Input_source").text();
                            var Received_date = $(this).find("Received_date").text();
                            var Order_Priority = $(this).find("Order_Priority").text();
                            var Rework_Revision = $(this).find("Rework_Revision").text();
                            var Pact_Status = $(this).find("Pact_Status").text();
                            var Internal_TAT = $(this).find("Internal_TAT").text();
                            var External_TAT = $(this).find("External_TAT").text();
                            var Rooster_Status = $(this).find("Rooster_Status").text();
                            var ID = $(this).find("Inflowid").text();
                             
                            // update panel control name = var name //
                            $('#txtCase_Owner').val(CaseOwner);
                            $('#txtUPF_ID').val(UPF_ID);
                            $('#txtLoaded_Date').val(Loaded_Date);
                            $('#txtUploaded_by').val(Uploaded_by);
                            $('#txtRegion').val(Region);
                            $('#txtScope').val(Scope);
                            $('#txtProcess').val(Process);
                            $('#txtSub_process').val(Sub_process);
                            $('#txtCountry').val(Country);
                            $('#txtSales_Order_Number').val(Sales_Order_Number);
                            $('#txtInput_source').val(Input_source);
                            $('#txtReceived_date').val(Received_date);
                            $('#txtOrder_Priority').val(Order_Priority);
                            $('#txtRework_Revision').val(Rework_Revision);
                            $('#txtPact_Status').val(Pact_Status);
                            $('#txtInternal_TAT').val(Internal_TAT);
                            $('#txtExternal_TAT').val(External_TAT);
                            $('#txtRooster_Status').val(Rooster_Status);
                            $('#txtInflowid').val(ID);
                        });
                    }
                    $find("popup").show();
                },
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });
        });
        $(".Pager .page").live("click", function () {
            GetCustomers(parseInt($(this).attr('page')));
        });
        function SearchTerm() {
            return jQuery.trim($("[id*=txtSearch]").val());
        };
        function GetCustomers(pageIndex) {
            $.ajax({
                type: "POST",
                url: "CS.aspx/GetCustomers",
                data: '{searchTerm: "' + SearchTerm() + '", pageIndex: ' + pageIndex + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });
        }
        var row;
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var customers = xml.find("Results");
            if (row == null) {
                row = $("[id*=gvCustomers] tr:last-child").clone(true);
            }
            $("[id*=gvCustomers] tr").not($("[id*=gvCustomers] tr:first-child")).remove();
            if (customers.length > 0) {
                $.each(customers, function () {
                    var customer = $(this);
                    $("td", row).eq(0).html($(this).find("Case_Owner").text());
                    $("td", row).eq(1).html($(this).find("UPF_ID").text());
                    $("td", row).eq(2).html($(this).find("Loaded_Date").text());
                    $("td", row).eq(3).html($(this).find("Uploaded_by").text());
                    $("td", row).eq(4).html($(this).find("Region").text());
                    $("td", row).eq(5).html($(this).find("Scope").text());
                    $("td", row).eq(6).html($(this).find("Process").text());
                    $("td", row).eq(7).html($(this).find("Sub_process").text());
                    $("td", row).eq(8).html($(this).find("Country").text());
                    $("td", row).eq(9).html($(this).find("Sales_Order_Number").text());
                    $("td", row).eq(10).html($(this).find("Input_source").text());
                    $("td", row).eq(11).html($(this).find("Received_date").text());
                    $("td", row).eq(12).html($(this).find("Order_Priority").text());
                    $("td", row).eq(13).html($(this).find("Rework_Revision").text());
                    $("td", row).eq(14).html($(this).find("Pact_Status").text());
                    $("td", row).eq(15).html($(this).find("Internal_TAT").text());
                    $("td", row).eq(16).html($(this).find("External_TAT").text());
                    $("td", row).eq(17).html($(this).find("Rooster_Status").text());
                    $("td", row).eq(18).html($(this).find("Inflowid").text());
                    $("td", row).eq(19).html("<a id='lnkModal' href='#'>Edit</a>");
                    $("[id*=gvCustomers]").append(row);
                    row = $("[id*=gvCustomers] tr:last-child").clone(true);
                });
                var pager = xml.find("Pager");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });

                $(".Case_Owner").each(function () {
                    var searchPattern = new RegExp('(' + SearchTerm() + ')', 'ig');
                    $(this).html($(this).text().replace(searchPattern, "<span class = 'highlight'>" + SearchTerm() + "</span>"));
                });
            } else {
                var empty_row = row.clone(true);
                $("td:first-child", empty_row).attr("colspan", $("td", row).length);
                $("td:first-child", empty_row).attr("align", "center");
                $("td:first-child", empty_row).html("No records found for the search criteria.");
                $("td", empty_row).not($("td:first-child", empty_row)).remove();
                $("[id*=gvCustomers]").append(empty_row);
            }
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
<asp:ScriptManager runat="server" />
        
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            Search:
            <asp:TextBox ID="txtSearch" runat="server" />
            <hr />
            <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false">
                <Columns>
                     <asp:BoundField DataField="Case_Owner" HeaderText="Case_Owner" /> <asp:BoundField DataField="UPF_ID" HeaderText="UPF_ID" />
                     <asp:BoundField DataField="Loaded_Date" HeaderText="Loaded_Date" /> <asp:BoundField DataField="Uploaded_by" HeaderText="Uploaded_by" />
                     <asp:BoundField DataField="Region" HeaderText="Region" /> <asp:BoundField DataField="Scope" HeaderText="Scope" />
                     <asp:BoundField DataField="Process" HeaderText="Process" /> <asp:BoundField DataField="Sub_process" HeaderText="Sub_process" /><asp:BoundField DataField="Country" HeaderText="Country" />
                     <asp:BoundField DataField="Sales_Order_Number" HeaderText="Sales_Order_Number" /><asp:BoundField DataField="Input_source" HeaderText="Input_source" />
                    <asp:BoundField DataField="Received_date" HeaderText="Received_date" /><asp:BoundField DataField="Order_Priority" HeaderText="Order_Priority" />
                    <asp:BoundField DataField="Rework_Revision" HeaderText="Rework_Revision" /><asp:BoundField DataField="Pact_Status" HeaderText="Pact_Status" />
                    <asp:BoundField DataField="Internal_TAT" HeaderText="Internal_TAT" /><asp:BoundField DataField="External_TAT" HeaderText="External_TAT" />
                    <asp:BoundField DataField="Rooster_Status" HeaderText="Rooster_Status" /><asp:BoundField DataField="Inflowid" HeaderText="Inflowid" />
                   <%-- <asp:BoundField HeaderStyle-Width="150px" DataField="ContactName" HeaderText="Contact Name"
                        ItemStyle-CssClass="ContactName" />--%>
                   
                    <asp:TemplateField HeaderText="Edit Record">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Panel ID="pnlAddEdit" runat="server" CssClass="modalPopup" Style="display: none">
                <div class="row" align="center" style="background-color: #956dda; margin-top: -10px;
                    width: 444px; height: 50px; margin-top: 1px; margin-left: -11px;">
                    <strong>
                        <br />
                        <asp:Label Font-Bold="true" ID="Label4" runat="server" Text="Edit Project Details"></asp:Label>
                        <br />
                    </strong>
                </div>
                <table align="center">
                    <tr>
                        <td>
                            <asp:Label ID="lblCase_Owner" runat="server" Text="Case_Owner"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtCase_Owner" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblUPF_ID" runat="server" Text="UPF_ID"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtUPF_ID" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblLoaded_Date" runat="server" Text="Loaded_Date"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtLoaded_Date" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblUploaded_by" runat="server" Text="Uploaded_by"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtUploaded_by" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblRegion" runat="server" Text="Region"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtRegion" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblScope" runat="server" Text="Scope"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtScope" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblProcess" runat="server" Text="Process"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtProcess" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblSub_process" runat="server" Text="Sub_process"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtSub_process" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblCountry" runat="server" Text="Country"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtCountry" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblSales_Order_Number" runat="server" Text="Sales_Order_Number"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtSales_Order_Number" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblInput_source" runat="server" Text="Input_source"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtInput_source" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblReceived_date" runat="server" Text="Received_date"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtReceived_date" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblOrder_Priority" runat="server" Text="Order_Priority"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtOrder_Priority" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblRework_Revision" runat="server" Text="Rework_Revision"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtRework_Revision" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblPact_Status" runat="server" Text="Pact_Status"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPact_Status" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td>
                            <asp:Label ID="lblInternal_TAT" runat="server" Text="Internal_TAT"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtInternal_TAT" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblExternal_TAT" runat="server" Text="External_TAT"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtExternal_TAT" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblRooster_Status" runat="server" Text="Rooster_Status"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtRooster_Status" Width="200px" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <br />
                        <td>
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="Save" />
                        </td>
                        <br />
                        <td>
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="return Hidepopup()" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
            <cc1:ModalPopupExtender ID="popup" runat="server" DropShadow="false" PopupControlID="pnlAddEdit"
                TargetControlID="lnkFake" BackgroundCssClass="modalBackground">
            </cc1:ModalPopupExtender>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <div class="Pager">
    </div>
    </form>
</body>
</html>
