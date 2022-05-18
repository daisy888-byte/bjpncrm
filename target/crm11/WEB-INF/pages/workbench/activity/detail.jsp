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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#create-noteContent").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/

		$("#remarkTotalDivId").on("mouseover",">div",function (){
			$(this).children("div").children("div").show();

		})
		$("#remarkTotalDivId").on("mouseout",">div",function (){
			$(this).children("div").children("div").hide();

		})
		$("#remarkTotalDivId").on("mouseover"," a",function (){
			$(this).children("span").css("color","red");
		})
		$("#remarkTotalDivId").on("mouseout"," a",function (){
			$(this).children("span").css("color","#E6E6E6");
		})
		$("#remarkTotalDivId").on("click"," a[tag='del']",function (){
			var remarkId=$(this).attr("name")

			$.ajax({
				url:"workbench/activity/delActivityRemark.do",
				data:{
					id:remarkId,
				},
				type:"post",
				dataType: "json",
				success:function (obj){
					if(obj.code==1){
						$("#div_"+remarkId).remove()
					}else{
						alert(obj.message)
					}

				}
			})
		})
		$("#remarkTotalDivId").on("click"," a[tag='edit']",function (){
			// <a  name="+obj.retData.id+" tag=\"edit\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\"
			// alert("aaaa")

			var id=$(this).attr("name")
			//alert(id)
			var noteContent=$("#h5_"+id).text()
			//alert(noteContent)

			$("#remarkId").val(id)
		//	alert($("#remarkId").val())
			$("#edit-noteContent").val(noteContent)
			$("#editRemarkModal").modal("show")

		})

		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val()
			var noteContent = $.trim($("#edit-noteContent").val())
			if (noteContent == "") {
				alert("内容不能为空")
				return
			}
			$.ajax({
				url: "workbench/activity/updateActivityRemark.do",
				data: {
					noteContent: noteContent,
					id: id

				},
				type: "post",
				dataType: "json",
				success: function (obj) {
					if (obj.code == 1) {
						$("#div_"+id+" img").attr("title","${sessionScope.sessionUser.name}")
						$("#div_"+id+" h5").text(noteContent)
						$("#div_"+id+" small").text(obj.retData.editTime+" 由${sessionScope.sessionUser.name}修改")

//obj.retData.editTime+" 由${sessionScope.sessionUser.name}修改
						/*var htmlstr=""
						htmlstr+="<div id=div_"+obj.retData.id+" class=\"remarkDiv\" style=\"height: 60px;\">"
						htmlstr+= "<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.webp\" style=\"width: 30px; height:30px;\">"
						htmlstr+= "<div style=\"position: relative; top: -40px; left: 40px;\" >"
						htmlstr+= "<h5 id=h5_"+obj.retData.id+">"+noteContent+"</h5>"
						htmlstr+= "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small style=\"color: gray;\"> "+obj.retData.editTime+" 由${sessionScope.sessionUser.name}修改</small>"
						htmlstr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						htmlstr+="<a  name="+obj.retData.id+" tag=\"edit\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlstr+="&nbsp;&nbsp;&nbsp;&nbsp;"
						htmlstr+="<a name="+obj.retData.id+" tag=\"del\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlstr+="</div>"
						htmlstr+="</div>"
						htmlstr+="</div>"*/
						$("#editRemarkModal").modal("hide")
						// $("#div_"+id).html(htmlstr)


					}else {
						alert(obj.message)
						$("#editRemarkModal").modal("show")
					}
				}

			})
		})




		$("#saveRemarkBtn").click(function (){
			var activityId=$("#activityId").val()
			var noteContent=$.trim($("#create-noteContent").val())
			if(noteContent==""){
				alert("内容不能为空")
				return
			}
			$.ajax({
				url:"workbench/activity/saveActivityRemarkDetail.do",
				data:{
					noteContent:noteContent,
					activityId:activityId

				},
				type:"post",
				dataType:"json",
				success:function (obj){
					//alert(obj.retData.id)
					//alert(obj.retData.createTime)
					if(obj.code==1){
						var htmlstr=""
						htmlstr+="<div id=div_"+obj.retData.id+" class=\"remarkDiv\" style=\"height: 60px;\">"
						htmlstr+= "<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.webp\" style=\"width: 30px; height:30px;\">"
						htmlstr+= "<div style=\"position: relative; top: -40px; left: 40px;\" >"
						htmlstr+= "<h5 id=h5_"+obj.retData.id+">"+noteContent+"</h5>"
						htmlstr+= "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small style=\"color: gray;\"> "+obj.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>"
						htmlstr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						htmlstr+="<a  name="+obj.retData.id+" tag=\"edit\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlstr+="&nbsp;&nbsp;&nbsp;&nbsp;"
						htmlstr+="<a name="+obj.retData.id+" tag=\"del\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlstr+="</div>"
						htmlstr+="</div>"
						htmlstr+="</div>"

						$("#remarkDiv").before(htmlstr)
						$("#create-noteContent").val("")
					}else{
						alert(obj.message)
					}

				}
			})


		})

	});
	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<input type="hidden" id="activityId" value=${activity.id}>
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkTotalDivId" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<c:forEach items="${remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.editFlag==1?remark.editBy:remark.createBy}" src="image/user-thumbnail.webp" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id=h5_${remark.id}>${remark.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> ${remark.editFlag==1?remark.editTime:remark.createTime} 由${remark.editFlag==1?remark.editBy:remark.createBy}${remark.editFlag==1?"修改":"创建"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a name=${remark.id} tag="edit" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a name=${remark.id} tag="del" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.webp" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="create-noteContent" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>