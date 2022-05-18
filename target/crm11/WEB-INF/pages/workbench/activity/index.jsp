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
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link type="text/css" rel="stylesheet" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>


<script type="text/javascript">

	$(function(){
		//alert("入口函数执行一遍")
		$("#saveActivityBtn").click(function (){
			var  owner =$("#create-marketActivityOwner").val()
			var  name =$.trim($("#create-marketActivityName").val())
			var  startDate =$("#create-startTime").val()
			var  endDate =$("#create-endTime").val()
			var  cost =$.trim($("#create-cost").val())
			var  description =$.trim($("#create-describe").val())

			if(owner==""){
				alert("所有者不能空")
				return
			}
			if(name==""){
				alert("名称不能空")
				return
			}
			if(startDate!="" && endDate!="" &&startDate>endDate){
				alert("结束日期不能比开始日期早")
				return
			}
			var regex=/^(([1-9]\d*)|0)$/
			if(!regex.test(cost)){
				alert("成本只能非负整数")
				return
			}
			$.ajax({
				url:"workbench/activity/saveCreateActivity.do",
				data:{
					"owner":owner,
					"name":name,
					"startDate":startDate,
					"endDate":endDate,
					"cost":cost,
					description:description,

				},
				dataType:"json",
				type:"post",
				success:function (obj){
					if(obj.code==1){
						$("#createActivityForm")[0].reset()
						$("#createActivityModal").modal("hide")
						queryActivityByConditionForPage(1,$("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
					}else{
						alert(obj.message)
						$("#createActivityModal").modal("show")
					}
				}

			})

		})


		$("input[name='myActivityDate']").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true
		})
		//alert("执行这里了：queryActivityByConditionForPage(1,10)")
		queryActivityByConditionForPage(1,10)

		$("#queryActivityBtn").click(function (){
			//alert("每页条数："+$("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
			queryActivityByConditionForPage(1,$("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
		})


		//修改市场活动
		$("#editActivityBtn").click(function (){
            if($("input[name='checkRow']:checked").size()!=1){
            	alert("请选择1条活动进行修改")
				return
			}
			var id =$("input[name='checkRow']:checked").val()
			//alert(id)
			$.ajax({
				url:"workbench/activity/queryActivityById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function(obj){
					//alert(obj.code)
					if(obj.code==1){
						//alert(obj.retData.id)
						$("#edit-marketActivityId").val(obj.retData.id)
						$("#edit-marketActivityOwner").val(obj.retData.owner)
						$("#edit-marketActivityName").val(obj.retData.name)
						$("#edit-startDate").val(obj.retData.startDate)
						$("#edit-endDate").val(obj.retData.endDate)
						$("#edit-cost").val(obj.retData.cost)
						$("#edit-description").val(obj.retData.description)

						$("#editActivityModal").modal("show")

					}else {
						alert(obj.message)
					}
				}
			})

		})
		//修改后，进行保存
		$("#updateActivityById").click(function () {
			var id = $("#edit-marketActivityId").val()
			var owner = $("#edit-marketActivityOwner").val()
			var name = $.trim($("#edit-marketActivityName").val())
			var startDate = $("#edit-startDate").val()
			var endDate = $("#edit-endDate").val()
			var cost = $.trim($("#edit-cost").val())
			var description = $.trim($("#edit-description").val())
			if (name == "") {
				alert("名称不能为空")
				return

			}
			if (startDate != "" && endDate != "" && startDate > endDate) {
				alert("开始日期不能晚于结束日期")
				return
			}
			var regex = /^(([1-9]\d*)|0)$/
			if (!regex.test(cost)) {
				alert("成本只能非负整数")
				return
			}
			$.ajax({
				url: "workbench/activity/updateActivityById.do",
				data: {
					id: id,
					"owner": owner,
					"name": name,
					"startDate": startDate,
					"endDate": endDate,
					"cost": cost,
					description: description,

				},
				dataType: "json",
				type: "post",
				success: function (obj) {
					if (obj.code == 1) {
						$("#editActivityModal").modal("hide")
						queryActivityByConditionForPage($("#mypagination").bs_pagination('getOption', 'currentPage'), $("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
					} else {
						alert(obj.message)
						$("#editActivityModal").modal("show")

					}

				}
			})

		})




		$("#checkAll").click(function (){
			//alert($("#checkAll").prop("checked"))
			$("input[name='checkRow']").prop("checked",$("#checkAll").prop("checked"))
		})
		$("#queryForPagetbody").on("click","input[name='checkRow']",function (){
			var allRows=$("input[name='checkRow']").size()
			var checkRows=$("input[name='checkRow']:checked").size()
			if(allRows==checkRows){
				$("#checkAll").prop("checked",true)

			}else {
				$("#checkAll").prop("checked",false)
			}
		})
		$("#delActivityBtn").click(function (){
			if($("input[name='checkRow']:checked").size()==0){
				alert("请选择您要删除的数据")
				return
			}
			if(confirm("您确定删除吗？")){
				var checkedRows=$("input[name='checkRow']:checked")
				var ids=""
				$.each(checkedRows,function (){
					ids+="id="+this.value+"&"
				})
				ids=ids.substr(0,ids.length-1)
				alert(ids)
				$.ajax({
					url:"workbench/activity/delActivityByIds.do",
					data:ids,
					type:"post",
					dataType:"json",
					success:function (obj){
						if(obj.code==1){
							queryActivityByConditionForPage(1,$("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
						}else{
							alert(obj.message)
						}
					}
				})
			}
		})

		/*<input type="file" id="activityFile">
		<button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>*/
		$("#importActivityBtn").click(function (){
			var filename=$("#activityFile").val()
			var myFile=$("#activityFile")[0].files[0]
			var suffix=filename.substring(filename.lastIndexOf('.')+1).toLocaleLowerCase()

			if(suffix!="xls"){
				alert("仅支持xls格式文件上传")
				return
			}
			if(myFile.size>5*1024*1024){
				alert("文件大小不能超过5MB")
				return
			}
			//alert(myFile.size)
			var formdata=new FormData();
			formdata.append("myFile",myFile)
			$.ajax({
				url:"workbench/activity/importActivity.do",
				data:formdata,
				type:"post",
				dataType:"json",
				processData:false,
				contentType:false,
				success:function (obj){
					if(obj.code==1){
						alert("成功导入"+obj.retData+"条数据")
						queryActivityByConditionForPage($("#mypagination").bs_pagination('getOption', 'currentPage'), $("#mypagination").bs_pagination('getOption', 'rowsPerPage'))
						$("#importActivityModal").modal("hide")
					}else {
						alert(obj.message)
						$("#importActivityModal").modal("show")
					}

				}

			})
		})

		$("#exportActivityAllBtn").click(function (){
			window.location.href="workbench/activity/exportAllActivities.do"
		})
		$("#exportActivityXzBtn").click(function (){
			var checkedIdStr=""
			var objs=$("input[name='checkRow']:checked")
			if(objs.size()==0){
				alert("请您选择导出活动")
				return
			}
			$.each(objs,function (){
				checkedIdStr+="id="+this.value+"&"
			})
			checkedIdStr=checkedIdStr.substring(0,checkedIdStr.length-1)
			//alert(checkedIdStr)
			window.location.href="workbench/activity/exportXzActivity.do?"+checkedIdStr

		})

		$("#queryForPagetbody").on("click"," a",function (){
			//stringhtml+="<td><a name="+element.id+" style=\"text-decoration: none; cursor: pointer;\" >"+element.
			var id=$(this).attr("name")
			//alert(id)
			window.location.href="workbench/activity/activityDetail.do?id="+id
		})

	});
	function queryActivityByConditionForPage(pageNum,pageSize){
		var name=$.trim($("#query-name").val())
		var owner=$.trim($("#query-owner").val())
		var startDate=$.trim($("#query-startDate").val())
		var endDate=$.trim($("#query-endDate").val())
		// alert(pageNum)
		// alert(pageSize)
		//alert("每页条数："+pageSize)
		//alert("结束日期："+endDate)

		$.ajax({
			url:"workbench/activity/queryActivityByConditionForPage.do",
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNum:pageNum,
				pageSize:pageSize
			},
			type:"post",
			dataType: "json",
			beforeSend:function (){
				// alert(pageNum)
				// alert(pageSize)
				return true
			},
			success:function (obj){
				 //显示总条数，和查询到的数据；
				var stringhtml=""
				$.each(obj.activityList,function (index,element){
					stringhtml+="<tr class=\"active\">"
					stringhtml+="<td><input type=\"checkbox\" name=\"checkRow\" value="+element.id+"></td>"
					stringhtml+="<td><a name="+element.id+" style=\"text-decoration: none; cursor: pointer;\" >"+element.name+"</a></td>"
					stringhtml+="<td>"+element.owner+"</td>"
					stringhtml+="<td>"+element.startDate+"</td>"
					stringhtml+="<td>"+element.endDate+"</td>"
					stringhtml+="</tr>"

				})
				$("#queryForPagetbody").html(stringhtml)
				$("#checkAll").prop("checked",false)

				var totalPages=1
				if(obj.totalRows%pageSize==0) {
					totalPages=obj.totalRows/pageSize
				}else {
					totalPages=parseInt(obj.totalRows/pageSize)+1
				}
				//alert(totalPages)

				$("#mypagination").bs_pagination({
					currentPage: pageNum,

					rowsPerPage: pageSize,
					totalRows: obj.totalRows,
					totalPages: totalPages,  //必填

					visiblePageLinks: 5,

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,

					onChangePage: function (event, pageObj) {
						// alert(data.currentPage)
						// alert(data.rowsPerPage)
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)

					}
				})

			}
		})

	}

	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="myActivityDate" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="myActivityDate" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					    <input type="hidden" id="edit-marketActivityId">
						<div class="form-group">

							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="myActivityDate" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="myActivityDate" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateActivityById">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createActivityModal" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default"  id="editActivityBtn"><span class="glyphicon glyphicon-pencil" ></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="delActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;" id="dataTable">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="queryForPagetbody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="mypagination" ></div>
			</div>

			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
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
				</div>
			</div>--%>


			
		</div>
		
	</div>
</body>
</html>