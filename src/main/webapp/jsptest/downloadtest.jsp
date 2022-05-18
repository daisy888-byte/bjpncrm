<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>

<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function (){
            $("#downloadBtn").click(function (){
                window.location.href="download.do"
            })
        })


    </script>

</head>
<body>
<button type="button" id="downloadBtn">下载</button>

</body>
</html>
