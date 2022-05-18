<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%

    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>

<html>
<head>
    <base href="<%=basePath%>"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <title>Title</title>
    <script type="text/javascript">
        $(function (){
            $("#aheadBtn").typeahead({
                // source:["动力1","动力2","动力3","软1","软2","软3"]
                source:function (jquery,process){
                    $.ajax({
                        url:"workbench/transaction/queryCustomerByName.do",
                        data:{
                            name:jquery
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data){
                            process(data)
                        }
                    })

                }
            })
        })
    </script>
</head>
<body>
<input type="text" id="aheadBtn">

</body>
</html>
