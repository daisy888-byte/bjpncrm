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
                $("#uploadActivityBtn").click(function (){
                    var filename=$("#fileBtn").val()
                    var suffix=filename.substr(filename.lastIndexOf(".")+1).toLowerCase()
                    alert(suffix)
                    if(!((suffix=="xlsx") ||(suffix=="xls"))){ //xlsx
                        alert("只能上传xls,xlsx格式文件")
                        return
                    }
                    var fileContent=$("#fileBtn")[0].files[0]
                   // alert(filesize.size)
                    if(fileContent.size>1024*1024*5){
                        alert("文件大小不能大于5MB")
                        return
                    }
                    var formData=new FormData()
                    formData.append("multipartFile",fileContent)
                    formData.append("username","zhangsan")
                    $.ajax({
                        url:"workbench/activity/uploadFileForActivities.do",
                        data:formData,
                        type:"post",
                        dataType:"text",
                        processData:false,
                        contentType:false,
                        success:function (data){
                            alert(data)
                        }
                    })
                })
            })

    </script>

</head>
<body>

<input type="file" id="fileBtn" ></input><br><br>

<button type="button" id="uploadActivityBtn">上传</button>

</body>
</html>
