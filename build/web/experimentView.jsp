<%-- 
    Document   : experimentView
    Created on : 23 Jul, 2016, 11:13:06 AM
    Author     : ratheeshkv
--%>


<%@page import="java.sql.ResultSet"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page import="java.util.concurrent.CopyOnWriteArrayList"%>
<%@page import="com.iitb.cse.Utils"%>
<%@page import="com.mysql.jdbc.Util"%>
<%@page import="org.eclipse.jdt.internal.compiler.impl.Constant"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.iitb.cse.DeviceInfo"%>
<%@page import="com.iitb.cse.*"%>
<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>CrowdSource-ServerHandler</title>

        <!-- Bootstrap Core CSS -->
        <link href="/serverplus/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

        <!-- MetisMenu CSS -->
        <link href="/serverplus/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="/serverplus/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- Morris Charts CSS -->
        <link href="/serverplus/vendor/morrisjs/morris.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="/serverplus/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    </head>

    <body>

        <div id="wrapper">

            <!-- Navigation -->
            <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="frontpage.jsp">CrowdSource Application - SERVER</a>
                </div>
                <!-- /.navbar-header -->

                <ul class="nav navbar-top-links navbar-right">

                    <!-- /.dropdown -->
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                            <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-user">

                            <li class="divider"></li>
                            <li>

                                <a href="logout.jsp?logout=logout"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                            </li>
                        </ul>
                        <!-- /.dropdown-user -->
                    </li>
                    <!-- /.dropdown -->
                </ul>
                <!-- /.navbar-top-links -->

              
                <!-- /.navbar-static-side -->
                 <div id="links" class="navbar-default sidebar" role="navigation">
                </div>
            </nav>






            <%

            if(session.getAttribute("currentUser")==null){
                response.sendRedirect("login.jsp");
            }else{
            //response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
                String username = (String)session.getAttribute("currentUser");
                Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
                
                  if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
                String expid = request.getParameter("expid");
                
            %>




            <div id="page-wrapper">

                <div class="row">
                    <br/><br/><br/>
                    <div class="col-lg-12">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <b><%out.write("<h3 class='heading'>Experiment No.   " + expid + "</h3>"); %></b>
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">

                                    <thead>
                                        <tr>
                                            <th>Mac Address</th>
                                            <th>File ID</th>
                                            <th>RSSI<br>(dBm)</th>
                                            <th>SSID</th>
                                            <th>BSSID</th>
                                            <th>Exp Req Sent</th>
                                            <th>Exp req retry</th>
                                            <th>Exp req Ack</th>
                                            <th>Experiment Over</th>
                                            <th>Log file received</th>
                                            <th>Status</th>                                                                                                                            
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <%
                                            String path = Constants.experimentDetailsDirectory;

                                            if (!path.endsWith("/")) {
                                                path = path + "/";
                                            }

                                            if (!path.startsWith("/")) {
                                                path = "/" + path;
                                            }
                                            String path1 = path;
                                            path = path +username+ "/controlFile/";

                                            ResultSet rs = DBManager.getExperimentDetails(expid,username);

                                            if (rs != null) {

 //macaddress,fileid,rssi,ssid,bssid,expreqsenddate,retry,expackreceiveddate,expoverDate,logfilereceived,statusmessage                                                
                                                while (rs.next()) {
                                                    out.write("<tr><td><a href=experimentDeviceInformation.jsp?macAddr=" + rs.getString(1) + "&expId=" + expid + ">" + rs.getString(1) + "</a></td>"+
                                                    "<td>"+rs.getString(2)+"</td>"+
                                                    "<td>" + rs.getString(3) + "</td>"+
                                                    "<td>" + rs.getString(4) + "</td>"+
                                                    "<td>" + rs.getString(5) + "</td>"+
                                                    "<td>" + ((rs.getString(6)==null)?"-Not send-":rs.getString(6))+"</td>"+
                                                    "<td>"+ ((rs.getString(7).equals("0"))?"-Not retried-":"Retry")+"</td>"+
                                                    "<td>" + ((rs.getString(8)==null)?"-Not Received-":rs.getString(8))+"</td>"+
                                                    "<td>" + ((rs.getString(9)==null)?"-Not Over-":rs.getString(9))+"</td>"+
                                                    "<td>" + ((rs.getString(10).equals("0"))?"-Not Received-":"Received")+"</td>"+
                                                    "<td>" + rs.getString(11)+"</td></tr>");
                                            
                                                }
//                                                out.write("</table>");
                                            }

                                            //     mgr.closeConnection();
                                        %>

                                    </tbody>
                                </table>
                                <!-- /.table-responsive -->

                            </div>
                            <!-- /.panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>
                    <!-- /.col-lg-12 -->
                </div>
                <!--end Row -->









            </div>
            <%
                }}
            %>
            <!-- /#page-wrapper -->

        </div>
        <!-- /#wrapper -->

        <!-- jQuery -->
        <script src="/serverplus/vendor/jquery/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="/serverplus/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="/serverplus/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- Morris Charts JavaScript -->
        <script src="/serverplus/vendor/raphael/raphael.min.js"></script>
        <script src="/serverplus/vendor/morrisjs/morris.min.js"></script>
        <script src="/serverplus/data/morris-data.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus/dist/js/sb-admin-2.js"></script>
        <!-- DataTables JavaScript -->
        <script src="/serverplus/vendor/datatables/js/jquery.dataTables.min.js"></script>
        <script src="/serverplus/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="/serverplus/vendor/datatables-responsive/dataTables.responsive.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus/dist/js/sb-admin-2.js"></script>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->
        <script>
            $(document).ready(function () {
                $('#dataTables-example').DataTable({
                    responsive: true
                });
            });
        </script>

      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>


    </body>

</html>