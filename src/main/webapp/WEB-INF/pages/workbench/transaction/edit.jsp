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
<script type="text/javascript" >
	$(function (){

	$("#edit-stage").change(function (){

		var stageName=$("#edit-stage option:selected").text()

		$.ajax({
			url:"workbench/transaction/getStagePossibility.do",
			data:{
				stageName:stageName
			},
			dataType:"json",
			type:"post",
			success:function (obj){
				$("#edit-possibility").val(obj)
			}

		})
	})
		$("#queryActivityBtn").click(function (){
			$("#findMarketActivity").modal("show")
		})
        $("#queryActivityInput").keyup(function (){
        	var activityName=this.value
			$.ajax({
				url:"workbench/transaction/queryActivitiesByNameForList.do",
				data:{
					activityName:activityName
				},
				dataType: "json",
				type:"post",
				success:function (obj){
					var htmlStr=""
					//a.id, u.name as owner, a.name, a.start_date, a.end_date
					$.each(obj,function (index,act){
						htmlStr+="<tr >"
						htmlStr+="	<td><input type=\"radio\" value="+act.id+" actName="+act.name+" name=\"activity\"/></td>"
						htmlStr+="	<td>"+act.name+"</td>"
						htmlStr+="	<td>"+act.startDate+"</td>"

						htmlStr+="	<td>"+act.endDate+"</td>"
						htmlStr+="	<td>"+act.owner+"</td>"
						htmlStr+="</tr>"

					})
					$("#activitytbody").html(htmlStr)

				}

			})
		})
		$("#activitytbody").on("click","input",function (){
			//<input type="hidden" id="edit-activityId">--%>
			//id="edit-activityName"
			$("#findMarketActivity").modal("hide")
			$("#edit-activityId").val(this.value)
			$("#edit-activityName").val($(this).attr("actName"))
		})

		$("#queryContactsBtn").click(function (){
			$("#findContacts").modal("show")
		})
		//id="queryContactsBtn"
		$("#queryContactsInput").keyup(function (){
			var contactsName=this.value
			$.ajax({
				url:"workbench/transaction/queryContactsByNameForList.do",
				data:{
					contactsName:contactsName
				},
				dataType:"json",
				type:"post",
				success:function (obj){
					var htmlStr=""
					$.each(obj,function (index,con){
						
						htmlStr+="<tr>"
						htmlStr+="	<td><input type=\"radio\" value="+con.id+" conName=\""+con.fullname+"\" name=\"activity\"/></td>"
						htmlStr+="	<td>"+con.fullname+"</td>"
						htmlStr+="	<td>"+con.email+"</td>"
						htmlStr+="	<td>"+con.mphone+"</td>"
						htmlStr+="</tr>"
					})
					$("#contactstbody").html(htmlStr)

				}

			})
		})

		$("#contactstbody").on("click","input[type='radio']",function (){
			
			$("#findContacts").modal("hide")
			$("#edit-contactsId").val(this.value)
			$("#edit-contactsName").val($(this).attr("conName"))

		})
		$("#saveBtn").click(function (){
			<%--	<select class="form-control" id="edit-owner">--%>
			<%--<input type="text" class="form-control" id="edit-money" value="${tran.money}">--%>
			<%--<input type="text" class="form-control" id="edit-name" value="${tran.name}">--%>
			<%--<input type="text" class="form-control" id="edit-expectedClosingDate" value="${tran.expectedDate}">--%>
			<%--<input type="text" class="form-control" id="edit-customerId" placeholder="???????????????????????????????????????????????????" value="${tran.customerId}">--%>
			<%--<select class="form-control" id="edit-stage">--%>
			<%--<select class="form-control" id="edit-type">--%>
			<%--<input type="text" class="form-control" id="edit-possibility" value="${tran.possibility}">--%>
			<%--<select class="form-control" id="edit-source">
            <input type="hidden" id="edit-activityId">--%>
			<%--<input type="text" class="form-control" id="edit-activityName" value="${tran.activityId}" readonly>,
            <input type="hidden" id="edit-contactsId">--%>
			<%--    <input type="text" class="form-control" id="edit-contactsName" value="${tran.contactsId}" readonly>
            <textarea class="form-control" rows="3" id="edit-description" >${tran.description}</textarea>
            <textarea class="form-control" rows="3" id="edit-contactSummary" >${tran.contactSummary}</textarea>
            <input type="text" class="form-control" id="edit-nextContactTime" value="${tran.nextContactTime}">
            id="queryActivityBtn"  id="queryContactsBtn"
            --%>
			var id					=$("#tranId").val()
			var owner              =$("#edit-owner").val()
			var money              =$.trim($("#edit-money").val())
			var name               =$.trim($("#edit-name").val())
			var expectedDate      =$("#edit-expectedClosingDate").val()
			var customerName        =$("#edit-customerId").val()//??

			var stage              =$("#edit-stage").val()
			var type               =$("#edit-type").val()
			var source             =$("#edit-source").val()
			var activityId        =$("#edit-activityId").val()
			var contactsId        =$("#edit-contactsId").val()

			var description        =$.trim($("#edit-description").val())
			var contactSummary    =$.trim($("#edit-contactSummary").val())
			var nextContactTime  =$("#edit-nextContactTime").val()

			//alert("activityId:"+activityId+"   contactsId:"+contactsId+"   description:"+description+"   contactSummary:"+contactSummary)
			//alert("type:"+type)

			if(owner==""){
				alert("??????????????????")
				return
			}
			if(name==""){
				alert("???????????????")
				return
			}
			if(expectedDate==""){
				alert("???????????????????????????")
				return
			}
			if(customerName==""){
				alert("?????????????????????")
				return
			}
			if(stage==""){
				alert("???????????????")
				return
			}
			var moneyreg=/^(([1-9]\d*)|0)$/
			if(!moneyreg.test(money)){
				alert("??????????????????")
				return
			}

			$.ajax({
				url:"workbench/transaction/saveEditTranObject.do",
				data:{
					id             :id             ,
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
		
		
		
		
		

	});





</script>


</head>
<body>

	<!-- ?????????????????? -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title">??????????????????</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="queryActivityInput" style="width: 300px;" placeholder="????????????????????????????????????????????????">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>??????</td>
								<td>????????????</td>
								<td>????????????</td>
								<td>?????????</td>
							</tr>
						</thead>
						<tbody id="activitytbody">
							<%--<tr >
								<td><input type="radio" name="activity"/></td>
								<td>?????????</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>?????????</td>
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

	<!-- ??????????????? -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title">???????????????</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="queryContactsInput" style="width: 300px;" placeholder="?????????????????????????????????????????????">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>??????</td>
								<td>??????</td>
								<td>??????</td>
							</tr>
						</thead>
						<tbody id="contactstbody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>??????</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>??????</td>
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
		<h3>????????????</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">??????</button>
			<button type="button" class="btn btn-default">??????</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<input type="hidden" id="tranId" value="${tran.id}">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner">
					<c:forEach items="${userList}" var="u">
						<c:if test="${tran.owner==u.id}">
							<option  value="${u.id}" selected>${u.name}</option>
						</c:if>
						<c:if test="${tran.owner!=u.id}">
							<option  value="${u.id}">${u.name}</option>
						</c:if>
					</c:forEach>
				  <%--<option>zhangsan</option>
				  <option>lisi</option>
				  <option>wangwu</option>--%>
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" value="${tran.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" value="${tran.name}">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">??????????????????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-expectedClosingDate" value="${tran.expectedDate}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerId" class="col-sm-2 control-label">????????????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerId" placeholder="???????????????????????????????????????????????????" value="${tran.customerId}">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">

			<c:if test="${tran.stage=='??????'}">
			  <select class="form-control" id="edit-stage" disabled>
				  <c:forEach items="${stageList}" var="s">
					  <c:if test="${tran.stage==s.value }">
						  <option value="${s.id}" selected>${s.value}</option>
					  </c:if>
					  <c:if test="${tran.stage!=s.value}">
					  	<option value="${s.id}">${s.value}</option>
					  </c:if>
				  </c:forEach>
			  </select>
			</c:if>
				<c:if test="${tran.stage!='??????'}">
					<select class="form-control" id="edit-stage" >
						<c:forEach items="${stageList}" var="s">
							<c:if test="${tran.stage==s.value }">
								<option value="${s.id}" selected>${s.value}</option>
							</c:if>
							<c:if test="${tran.stage!=s.value}">
								<option value="${s.id}">${s.value}</option>
							</c:if>
						</c:forEach>
					</select>
				</c:if>

			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type">
					<option></option>
					<c:forEach items="${tranTypeList}" var="t">
						<c:if test="${tran.type==t.id}">
							<option value="${t.id}" selected>${t.value}</option>
						</c:if>
						<c:if test="${tran.type!=t.id}">
							<option value="${t.id}" >${t.value}</option>
						</c:if>
					</c:forEach>
				  <%--<option></option>
				  <option>????????????</option>
				  <option>?????????</option>--%>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">?????????</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" value="${tran.possibility}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source">
					<option></option>
					<c:forEach items="${sourceList}" var="s">
						<c:if test="${tran.source==s.value}">
							<option value="${s.id}" selected>${s.value}</option>
						</c:if>
						<c:if test="${tran.source!=s.value}">
							<option value="${s.id}" >${s.value}</option>
						</c:if>

					</c:forEach>
				  <%--<option></option>
				  <option>??????</option>
				  <option>????????????</option>
				  <option>????????????</option>
				  <option>????????????</option>
				  <option>????????????</option>
				  <option>????????????</option>
				  <option>????????????</option>
				  <option>????????????</option>
				  <option>?????????????????????</option>
				  <option>???????????????</option>
				  <option>?????????</option>
				  <option>web??????</option>
				  <option>web??????</option>
				  <option>??????</option>--%>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">???????????????&nbsp;&nbsp;<a href="javascript:void(0);" id="queryActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-activityId">
				<input type="text" class="form-control" id="edit-activityName" value="${tran.activityId}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">???????????????&nbsp;&nbsp;<a href="javascript:void(0);" id="queryContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-contactsId">
				<input type="text" class="form-control" id="edit-contactsName" value="${tran.contactsId}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description" >${tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">????????????</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" >${tran.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-nextContactTime" value="${tran.nextContactTime}">
			</div>
		</div>
		
	</form>
</body>
</html>