<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <link type="text/css" rel="stylesheet" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

    <title>pagetest</title>
    <script type="text/javascript" >
       $(function (){
           $("#mypage").bs_pagination({
               currentPage: 1,

               rowsPerPage: 10,
               totalRows: 1000,
               totalPages: 100,  //必填

               visiblePageLinks: 10,

               showGoToPage: true,
               showRowsPerPage: true,
               showRowsInfo: true,

               //  $("#element_id").bs_pagination('getOption', 'option_name');
               onChangePage: function (event, data) {
                   // alert(data.currentPage)
                   // alert(data.currentPage)

                   alert($("#mypage").bs_pagination('getOption', 'currentPage'))
                   alert($("#mypage").bs_pagination('getOption', 'rowsPerPage'))
               }
           })
       })

    </script>

</head>
<body>
<div id="mypage"></div>

</body>
</html>
