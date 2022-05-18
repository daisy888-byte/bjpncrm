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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<link type="text/css" rel="stylesheet" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript" >
	$(function (){
		$("#create-customerName").typeahead({
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

       $("#create-stage").change(function (){
		   var stageName=$("#create-stage").find("option:selected").text()

		   // alert(stageName)
		   // var stageName2=$("#create-stage>option:selected").text()
		   // alert(stageName2)
		   if(stageName==""){
		   	$("#create-possibility").val("")
			   return
		   }
		   $.ajax({
			   url:"workbench/transaction/getStagePossibility.do",
			   data:{
				   stageName:stageName
			   },
			   dataType: "json",
			   type: "post",
			   success:function (obj){
				    $("#create-possibility").val(obj)

			   }

		   })
	   })

		$("#searchNameBtn").click(function (){
			$("#findContacts").modal("show")
		})
		$("#contactNameInput").keyup(function (){
			var contactsName=this.value
			$.ajax({
				url:"workbench/transaction/queryContactsName.do",
				data:{
					contactsName:contactsName
				},
				dataType:"json",
				type:"post",
				success:function (obj){
					var htmlStr=""
					$.each(obj,function (index,con){
						htmlStr+="<tr>"
						htmlStr+="<td><input type=\"radio\" value=\""+con.id+"\" fullname=\""+con.fullname+"\" name=\"activity\"/></td>"
						htmlStr+="		<td>"+con.fullname+"</td>"
						htmlStr+="		<td>"+con.email+"</td>"
						htmlStr+="<td>"+con.mphone+"</td>"
						htmlStr+="</tr>"
					})
					$("#contactsNametbody").html(htmlStr)

				}
			})

		})
		$('#contactsNametbody').on("click","input[type='radio']",function (){
			// <input type="hidden" id="create-contactsId">
			// 			<input type="text" class="form-control" id="create-contactsName">
			$("#findContacts").modal("hide")
			$("#create-contactsId").val(this.value)
			$("#create-contactsName").val($(this).attr("fullname"))

		})

		$("#searchActivityBtn").click(function (){
			$("#findMarketActivity").modal("show")
		})
		$("#searchActInputName").keyup(function (){
			var activityName=this.value
			$.ajax({
				url:"workbench/transaction/queryActivityName.do",
				data:{
					activityName:activityName
				},
				dataType:"json",
				type:"post",
				success:function (obj){
					var htmlStr=""
					$.each(obj,function (index,act){
						htmlStr+="<tr>"
						htmlStr+="<td><input type=\"radio\" value="+act.id+" actName=\""+act.name+"\" name=\"activity\"/></td>"
						htmlStr+="<td>"+act.name+"</td>"
						htmlStr+="<td>"+act.startDate+"</td>"
						htmlStr+="<td>"+act.endDate+"</td>"
						htmlStr+="<td>"+act.owner+"</td>"
						htmlStr+="</tr>"
					})
					$("#searchActivitytbody").html(htmlStr)
				}
			})

		})
		$("#searchActivitytbody").on("click","input[type='radio']",function (){

			 $("#findMarketActivity").modal("hide")
			$("#create-activityId").val(this.value)
			$("#create-activityName").val($(this).attr("actName"))

		})
		$("#create-nextContactTime").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true
			//http://localhost:8080/crm/jsptest/calendarTest.jsp
		})



		$("#saveCreateActivityBtn").click(function (){

					var owner              =$("#create-owner").val()
					var money              =$.trim($("#create-money").val())
					var name               =$.trim($("#create-transactionName").val())
					var expectedDate      =$("#create-expectedClosingDate").val()
					var customerName        =$("#create-customerName").val()

					var stage              =$("#create-stage").val()
					var type               =$("#create-transactionType").val()
					var source             =$("#create-source").val()
					var activityId        =$("#create-activityId").val()
					var contactsId        =$("#create-contactsId").val()

					var description        =$.trim($("#create-describe").val())
					var contactSummary    =$.trim($("#create-contactSummary").val())
					var nextContactTime  =$("#create-nextContactTime").val()

					if(owner==""){
						alert("所有者不能空")
						return
					}
					if(name==""){
						alert("名称不能空")
						return
					}
					if(expectedDate==""){
						alert("预计成交日期不能空")
						return
					}
					if(customerName==""){
						alert("客户名称不能空")
						return
					}
					if(stage==""){
						alert("阶段不能空")
						return
					}
					var moneyreg=/^(([1-9]\d*)|0)$/
					if(!moneyreg.test(money)){
						alert("金额非负整数")
						return
					}

			$.ajax({
				url:"workbench/transaction/saveCreateTranObject.do",
				data:{
					owner          :owner          ,
					money          :money          ,
					name           :name           ,
					expectedDate   :expectedDate   ,
					customerName   :customerName   ,
					stage          :stage          ,
					type           :type           ,
					source         :source         ,
					activityId     :activityId     ,
					contactsId     :contactsId     ,
					description    :description    ,
					contactSummary :contactSummary ,
					nextContactTime:nextContactTime
				},
				dataType:"json",
				type:"post",
				success:function (data){
					if(data.code=="1"){
						window.location.href="workbench/transaction/index.do"
					}else{
						alert(data.message)
					}


				}

			})

		})



})


</script>

</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
<div class="modal-dialog" role="document" style="width: 80%;">
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal">
   <span aria-hidden="true">×</span>
</button>
<h4 class="modal-title">查找市场活动</h4>
</div>
<div class="modal-body">
<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
   <form class="form-inline" role="form">
     <div class="form-group has-feedback">
       <input type="text" class="form-control" style="width: 300px;" id="searchActInputName" placeholder="请输入市场活动名称，支持模糊查询">
       <span class="glyphicon glyphicon-search form-control-feedback"></span>
     </div>
   </form>
</div>
<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
   <thead>
       <tr style="color: #B3B3B3;">
           <td></td>
           <td>名称</td>
           <td>开始日期</td>
           <td>结束日期</td>
           <td>所有者</td>
       </tr>
   </thead>
   <tbody id="searchActivitytbody">
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

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
<div class="modal-dialog" role="document" style="width: 80%;">
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal">
   <span aria-hidden="true">×</span>
</button>
<h4 class="modal-title">查找联系人</h4>
</div>
<div class="modal-body">
<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
   <form class="form-inline" role="form">
     <div class="form-group has-feedback">
       <input type="text" class="form-control" style="width: 300px;" id="contactNameInput" placeholder="请输入联系人名称，支持模糊查询">
       <span class="glyphicon glyphicon-search form-control-feedback" ></span>
     </div>
   </form>
</div>
<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
   <thead>
       <tr style="color: #B3B3B3;">
           <td></td>
           <td>名称</td>
           <td>邮箱</td>
           <td>手机</td>
       </tr>
   </thead>
   <tbody id="contactsNametbody">
       <%--<tr>
           <td><input type="radio" name="activity"/></td>
           <td>李四</td>
           <td>lisi@bjpowernode.com</td>
           <td>12345678901</td>
       </tr>
       <tr>
           <td><input type="radio" name="activity"/></td>
           <td>李四</td>
           <td>lisi@bjpowernode.com</td>
           <td>12345678901</td>
       </tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
					<c:forEach items="${userList}" var="user">
						<option value="${user.id}">${user.name}</option>
					</c:forEach>
				  <%--<option>zhangsan</option>
				  <option>lisi</option>
				  <option>wangwu</option>--%>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
			  	<option></option>
				  <c:forEach items="${dicValueStageList}" var="stage">
					  <option value="${stage.id}">${stage.value}</option>
				  </c:forEach>
			  	<%--<option>资质审查</option>
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
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${dicValueTransactionTypeList}" var="type">
						<option value="${type.id}">${type.value}</option>
					</c:forEach>
				  <%--<option>已有业务</option>
				  <option>新业务</option>--%>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
				  <option></option>
					<c:forEach items="${dicValueSourceList}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				  <%--<option>广告</option>
				  <option>推销电话</option>
				  <option>员工介绍</option>
				  <option>外部介绍</option>
				  <option>在线商场</option>
				  <option>合作伙伴</option>
				  <option>公开媒介</option>
				  <option>销售邮件</option>
				  <option>合作伙伴研讨会</option>
				  <option>内部研讨会</option>
				  <option>交易会</option>
				  <option>web下载</option>
				  <option>web调研</option>
				  <option>聊天</option>--%>
				</select>
			</div>
			<label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">

				<input type="hidden" class="form-control" id="create-activityId">
				<input type="text" class="form-control" id="create-activityName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchNameBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsId">
				<input type="text" class="form-control" id="create-contactsName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime" readonly/>
			</div>
		</div>
		
	</form>
</body>
</html>