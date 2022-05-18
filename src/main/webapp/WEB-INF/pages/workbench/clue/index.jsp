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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link type="text/css" rel="stylesheet" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		$("#createClueBtn").click(function (){
			$("#createClueForm").get(0).reset()
			$("#createClueModal").modal("show")

		})
		//id="create-nextContactTime"
		$("#create-nextContactTime").datetimepicker({
			language:'zh-CN',
			//format:'yyyy-mm-dd',
			format:'yyyy-mm-dd',
			//minView:'month',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true
			//http://localhost:8080/crm/jsptest/calendarTest.jsp
		})


		$("#saveClueBtn").click(function (){

		//var	 id                =$("#").val()
			// var	 create_by         =$("#").val()
			// var	 create_time       =$("#").val()
			// var	 edit_by           =$("#").val()
			// var	 edit_time         =$("#").val()
		var	 fullname          =$.trim($("#create-surname").val())
		var	 appellation       =$("#create-call").val()
		var	 owner             =$("#create-clueOwner").val()
		var	 company           =$.trim($("#create-company").val())
		var	 job               =$.trim($("#create-job").val())
		var	 email             =$.trim($("#create-email").val())
		var	 phone             =$.trim($("#create-phone").val())
		var	 website           =$.trim($("#create-website").val())
		var	 mphone            =$.trim($("#create-mphone").val())
		var	 state             =$("#create-status").val()
		var	 source            =$("#create-source").val()
		var	 description       =$.trim($("#create-describe").val())
		var	 contactSummary   =$.trim($("#create-contactSummary").val())
		var	 nextContactTime  =$.trim($("#create-nextContactTime").val())
		var	 address           =$.trim($("#create-address").val())

			if(company==""){
				alert("公司不能为空")
				return
			}
			if(fullname==""){
				alert("姓名不能为空")
				return
			}
			var websiteregx=/^((https|http|ftp|rtsp|mms){0,1}(:\/\/){0,1})www\.(([A-Za-z0-9-~]+)\.)+([A-Za-z0-9-~\/])+$/
			if(website!=""&&!websiteregx.test(website)){
				alert("网站格式不合法")
				return
			}
			var phoneregx=/^(0\d{2,3}-\d{7,8})(-\d{1,4})?$/
			if(phone!=""&&!phoneregx.test(phone)){
				alert("公司座机格式不合法")
				return
			}
			var emailregx=/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/
			if(email!=""&&!emailregx.test(email)){
				alert("邮箱格式不合法")
				return
			}
			var mphoneregx=/^1[3|4|5|6|7|8|9][0-9]{9}$/
			if(mphone!=""&&!mphoneregx.test(mphone)){
				alert("手机格式不合法")
				return
			}


			$.ajax({
				url:"workbench/clue/saveCreateClue.do",
				data:{
					 fullname       :fullname       ,
					 appellation    :appellation    ,
					 owner          :owner          ,
					 company        :company        ,
					 job            :job            ,
					 email          :email          ,
					 phone          :phone          ,
					 website        :website        ,
					 mphone         :mphone         ,
					 state          :state          ,
					 source         :source         ,
					 description    :description    ,
					 contactSummary :contactSummary ,
					 nextContactTime:nextContactTime,
					 address        :address

				},
				type:"post",
				dataType:"json",
				success:function (obj){
					if(obj.code=="1"){
						$("#createClueModal").modal("hide")
						queryByConditionsForPage(1,$("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert(obj.message)
						$("#createClueModal").modal("show")
					}

				}
			})
		})
		queryByConditionsForPage(1,10)

		$("#queryBtn").click(function (){
			//alert($("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
			queryByConditionsForPage(1,$("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
		})
		//$("#tbody")
		$("#tbody").on("click","a",function (){
			var clueId=$(this).attr("clueId")
			window.location.href="workbench/clue/detail.do?id="+clueId

		})
		$("#checkAll").click(function (){
			$("#tbody input[type='checkbox']").prop("checked",$("#checkAll").prop("checked"))
		})
		$("#tbody").on("click","input[type='checkbox']",function (){
			if($("#tbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked",true)
			}else{
				$("#checkAll").prop("checked",false)
			}

		})


		$("#editClueBtn").click(function (){//checkAll
			if($("#tbody input[type='checkbox']:checked").size()!="1"){
				alert("请选择1条线索修改")
				return
			}
			var id=$("#tbody input[type='checkbox']:checked").attr("id")
			$.ajax({
				url:"workbench/clue/queryClueById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (obj){
					/*id="edit-clueOwner" id="edit-company" id="edit-call" id="edit-fullname"id="edit-job"
					id="edit-email"id="edit-phone"id="edit-website"id="edit-mphone"
					id="edit-status" id="edit-source"  id="edit-describe" id="edit-contactSummary"  id="edit-nextContactTime"
					id="edit-address"
					<input type="hidden" id="edit-id">
							<button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>*/
					$("#edit-id").val(obj.id)
					$("#edit-clueOwner").val(obj.owner)
					$("#edit-company").val(obj.company)
					$("#edit-call").val(obj.appellation)
					$("#edit-fullname").val(obj.fullname)
					$("#edit-job").val(obj.job)
					$("#edit-email").val(obj.email)
					$("#edit-phone").val(obj.phone)
					$("#edit-website").val(obj.website)
					$("#edit-mphone").val(obj.mphone)
					$("#edit-status").val(obj.state)
					$("#edit-source").val(obj.source)
					$("#edit-describe").val(obj.description)
					$("#edit-contactSummary").val(obj.contactSummary)
					$("#edit-nextContactTime").val(obj.nextContactTime)
					$("#edit-address").val(obj.address)

					$("#editClueModal").modal("show")
				}

			})

		})

		$("#updateClueBtn").click(function (){
			var id =$("#edit-id").val()
			var owner=$("#edit-clueOwner").val()
			var company=$.trim($("#edit-company").val())
			var appellation=$("#edit-call").val()
			var fullname=$.trim($("#edit-fullname").val())
			var job=$.trim($("#edit-job").val())
			var email=$.trim($("#edit-email").val())
			var phone=$.trim($("#edit-phone").val())
			var website=$.trim($("#edit-website").val())
			var mphone=$.trim($("#edit-mphone").val())
			var state=$("#edit-status").val()
			var source=$("#edit-source").val()
			var description=$.trim($("#edit-describe").val())
			var contactSummary=$.trim($("#edit-contactSummary").val())
			var nextContactTime=$("#edit-nextContactTime").val()
			var address=$.trim($("#edit-address").val())

			$.ajax({
				url:"workbench/clue/updateClueById.do",
				data:{
					id:id,
					owner:owner,
					company:company,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				dataType:"json",
				type:"post",
				success:function (obj){
					if(obj.code=="1"){
						$("#editClueModal").modal("hide")
						queryByConditionsForPage($("#mypagination").bs_pagination('getOption', 'currentPage'),$("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert(obj.message)
						$("#editClueModal").modal("show")
					}
				}

			})

		})

	});
	function queryByConditionsForPage(pageNum,pageSize){
		//        fullname, appellation, owner, company,  phone,  mphone, state, source ,pageStart,pageSize
		// query-name  query-company  query-phone query-source query-owner query-mphone query-state
		var	 name   =$("#query-name").val()
		var	 owner  =$("#query-owner").val()
		var	 company=$("#query-company").val()
		var	 phone  =$("#query-phone").val()
		var	 mphone =$("#query-mphone").val()
		var	 state  =$("#query-state").val()
		var	 source =$("#query-source").val()
		//alert(name)

		$.ajax({
			url:"workbench/clue/queryByConditionsForPage.do",
			data:{
				name   :name   ,
				owner  :owner  ,
				company:company,
				phone  :phone  ,
				mphone :mphone ,
				state  :state  ,
				source :source ,
				pageNum:pageNum,
				pageSize:pageSize
			},
			type:"post",
			dataType: "json",
			success:function (obj){ //clueList:[{},{},],totalCount:XX
				var htmlStr=""
				$.each(obj.clueList,function (index,clue){
					//<tbody id="tbody">

					htmlStr+="<tr>"
					htmlStr+="<td><input type=\"checkbox\" id=\""+clue.id+"\"/></td>"
					htmlStr+="<td><a clueId="+clue.id+" style=\"text-decoration: none; cursor: pointer;\" >"+clue.fullname+clue.appellation+"</a></td>"
					htmlStr+="<td>"+clue.company+"</td>"
					htmlStr+="<td>"+clue.phone+"</td>"
					htmlStr+="<td>"+clue.mphone+"</td>"
					htmlStr+="<td>"+clue.source+"</td>"
					htmlStr+="<td>"+clue.owner+"</td>"
					htmlStr+="<td>"+clue.state+"</td>"
					htmlStr+="</tr>"
				})
				$("#tbody").html(htmlStr)
				$("#checkAll").prop("checked",false)

				var totalPages=0
				if(obj.totalCount%pageSize==0){
					totalPages=obj.totalCount/pageSize
				}else {
					totalPages=parseInt(obj.totalCount/pageSize)+1
				}

				$("#mypagination").bs_pagination({
					currentPage: pageNum,

					rowsPerPage: pageSize,
					totalRows: obj.totalCount,
					totalPages: totalPages,  //必填

					visiblePageLinks: 10,

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,

					//  $("#element_id").bs_pagination('getOption', 'option_name');
					onChangePage: function (event, data) {
						// alert(data.currentPage)
						// alert(data.rowsPerPage)    pageNum,pageSize
//
						// alert($("#mypage").bs_pagination('getOption', 'currentPage'))
						// alert($("#mypage").bs_pagination('getOption', 'rowsPerPage'))
						queryByConditionsForPage(data.currentPage,data.rowsPerPage)

					}
				})
			}
		})
	}

</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								 <%-- <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${appellationList}" var="appe">
										<option value="${appe.id}">${appe.value}</option>
									</c:forEach>
								  <%--<option>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
								  <option></option>
									<c:forEach items="${clueStateList}" var="cs">
										<option value="${cs.id}">${cs.value}</option>
									</c:forEach>
								  <%--<option>试图联系</option>
								  <option>将来联系</option>
								  <option>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
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
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createClueForm">
					
						<div class="form-group">
							<input type="hidden" id="edit-id">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${appellationList}" var="appe">
										<option value="${appe.id}">${appe.value}</option>
									</c:forEach>

								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach items="${clueStateList}" var="cs">
										<option value="${cs.id}">${cs.value}</option>
									</c:forEach>

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="query-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="query-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="source">
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
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="query-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-state">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="cs">
							  <option value="${cs.id}">${cs.value}</option>
						  </c:forEach>
					  	<%--<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>--%>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tbody">
						<%--<c:forEach items="${clueList}" var="clue">
							<tr>
								<td><input type="checkbox" id="${clue.id}"/></td>
								<td><a style="text-decoration: none; cursor: pointer;" >${clue.fullname}${clue.appellation}</a></td>
								<td>${clue.company}</td>
								<td>${clue.phone}</td>
								<td>${clue.mphone}</td>
								<td>${clue.source}</td>
								<td>${clue.owner}</td>
								<td>${clue.state}</td>
							</tr>
						</c:forEach>--%>


						<%-- fullname, appellation, owner, company,  phone,  mphone, state, source ,pageStart,pageSize
							<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
<%--				<div style="height: 50px; position: relative;top: 60px;" id="mypagination">--%>
				<div  id="mypagination">
					<%--<div>
                        <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
                    </div>
                    <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                        <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                        <div class="btn-group">
                            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                10
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="#">20</a></li>
                                <li><a href="#">30</a></li>
                            </ul>
                        </div>
                        <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
                    </div>
                    <div style="position: relative;top: -88px; left: 285px;">
                        <nav>
                            <ul class="pagination">
                                <li class="disabled"><a href="#">首页</a></li>
                                <li class="disabled"><a href="#">上一页</a></li>
                                <li class="active"><a href="#">1</a></li>
                                <li><a href="#">2</a></li>
                                <li><a href="#">3</a></li>
                                <li><a href="#">4</a></li>
                                <li><a href="#">5</a></li>
                                <li><a href="#">下一页</a></li>
                                <li class="disabled"><a href="#">末页</a></li>
                            </ul>
                        </nav>
                    </div>--%>
				</div>
			</div>
			

			
		</div>
		
	</div>
</body>
</html>