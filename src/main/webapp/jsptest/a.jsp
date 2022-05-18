<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" >
        $(function (){
           var obj=[{nama:"zhangsan"},{nama:"zhangsan2"},{nama:"zhangsan3"}]
            alert(obj.length)


        })



    </script>


<body>
 <div id="divId">
     <input type="text" id=btn1 value=abcdmn><br>
     <input type="text" id="btn2" value="abc3"><br><br><br>
 </div>



</body>
</html>
