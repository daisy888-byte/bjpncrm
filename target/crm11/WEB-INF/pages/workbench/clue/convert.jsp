<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%

String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>

<html>
<head>
	<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$.ajax({
					url:"workbench/clue/tranStage.do",
					dataType:"json",
					success:function (obj){
						var htmlStr="<option></option>"
						$.each(obj,function (index,data){
							htmlStr+="<option value=\""+data.id+"\">"+data.value+"</option>"
						})
						$("#stage").html(htmlStr)
					}
				})

				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$("#searchBtn").click(function (){
			$("#searchActivityModal").modal("show")
		})
		$("#searchBundActivityBtn").keyup(function (){
			var activityName=this.value
			var clueId=$("#clueId").val()
			$.ajax({
				url:"workbench/clue/queryActivityByActivityNameClueId.do",
				data:{
					activityName:activityName,
					clueId:clueId
				},
				dataType: "json",
				type:"post",
				success:function (obj){
					var htmlStr=""
					$.each(obj,function (index,act){
						htmlStr+="<tr>"
						htmlStr+="<td><input value="+act.id+"  activityName=\""+act.name+"\" type=\"radio\" name=\"activity\"/></td>"
						htmlStr+="<td>"+act.name+"</td>"
						htmlStr+="<td>"+act.startDate+"</td>"
						htmlStr+="<td>"+act.endDate+"</td>"
						htmlStr+="<td>"+act.owner+"</td>"
						htmlStr+="</tr>"
					})
					$("#tbody").html(htmlStr)

				}
			})

		})
		$("#tbody").on("click","input",function (){
			var activityId=this.value
			var activityName=$(this).attr("activityName")
			$("#searchActivityModal").modal("hide")
			//<input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			$("#activity").val(activityName)
			$("#activityId").val(activityId)

		})
		//  money  name  expectedDate stage activityId clueId isCreateTransaction
		$("#clueConvertBtn").click(function (){
			var money= $.trim($("#amountOfMoney").val())
			var name= $.trim($("#tradeName").val())
			var expectedDate=$("#expectedClosingDate").val()
			var stage=$("#stage").val()
			//var activityName=$("#activity").val()
			var activityId=$("#activityId").val()
			var clueId=$("#clueId").val()
			var isCreateTransaction=$("#isCreateTransaction").prop("checked")
			//alert(clueId)
			$.ajax({
				url:"workbench/clue/saveClueConvert.do",
				data:{
					money:money,
					name:name,
					expectedDate:expectedDate,
					stage:stage,
					activityId:activityId,
					clueId:clueId,
					isCreateTransaction:isCreateTransaction

				},
				dataType:"json",
				type:"post",
				success:function (obj){
					if(obj.code=="1"){
						window.location.href="workbench/clue/index.do"
					}else{
						alert(obj.message)
					}
				}

			})



		})

		$("#expectedClosingDate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true
			//http://localhost:8080/crm/jsptest/calendarTest.jsp
		})

	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchBundActivityBtn" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tbody">
						<%--<tr>
                            <td><input type="radio" name="activity"/></td>
                            <td>发传单</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                            <td>zhangsan</td>
                        </tr>
                        <tr>
                            <td><input type="radio" name="activity"/></td>
                            <td>发传单</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                            <td>zhangsan</td>
                        </tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<input type="hidden" id="clueId" value="${clue.id}">
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="动力节点-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
				<%--<option></option>
                <option>资质审查</option>
                <option>需求分析</option>
                <option>价值建议</option>
                <option>确定决策者</option>
                <option>提案/报价</option>
                <option>谈判/复审</option>
                <option>成交</option>
                <option>丢失的线索</option>
                <option>因竞争丢失关闭</option>--%>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <input type="hidden" id="activityId">
			  <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" id="clueConvertBtn" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>