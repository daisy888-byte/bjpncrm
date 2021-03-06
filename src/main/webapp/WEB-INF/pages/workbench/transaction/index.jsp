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
<link type="text/css" rel="stylesheet" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		$("#createTranBtn").click(function (){
			window.location.href="workbench/transaction/createTran.do"
		})

		pageForQueryByConditions(1,10)

		$("#queryBtn").click(function (){
			pageForQueryByConditions(1,$("#mypage").bs_pagination('getOption','rowsPerPage'))

		})
		//<tbody id="tbody">
		$("#tbody").on("click","a",function(){
			//<a style=\"text-decoration: none; cursor: pointer;\" tranId=\""+tran.id+"\">"+tran.name+"</a>
			var id=$(this).attr("tranId")

			window.location.href="workbench/transaction/tranDetail.do?id="+id

		})
		//id="editTranBtn"
		/*<input type="checkbox" id="checkAll"/></td>
				<input type=\"checkbox\" id=\""+tran.id+"\" /></td>"*/
			//$("#tbody")
		$("#checkAll").click(function (){
			$("#tbody input[type='checkbox']").prop("checked",$("#checkAll").prop("checked"))
		})
		$("#tbody").on("click","input",function (){
			if($("#tbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked",true)
			}else {
				$("#checkAll").prop("checked",false)
			}
		})


		$("#editTranBtn").click(function (){
			//alert($("#tbody input[type='checkbox']:checked").size())
			if($("#tbody input[type='checkbox']:checked").size()!=1){
				alert("???????????????????????????")
				return
			}
			var id=$("#tbody input[type='checkbox']:checked").val()
			window.location.href="workbench/transaction/queryTranById.do?id="+id


		})

		$("#deleteTranBtn").click(function (){
			if($("#tbody input[type='checkbox']:checked").size()==0){
				alert("??????????????????????????????")
				return
			}
			if(confirm("?????????????????????")){
				var chks=$("#tbody input[type='checkbox']:checked")
				var ids=""
				$.each(chks,function (){
					ids+="id="+this.value+"&"
				})
				//alert(ids)
				ids=ids.substr(0,ids.length-1)
				//alert(ids)
				$.ajax({
					url:"workbench/transaction/deleteTransByIds.do",
					data:ids,
					dataType: "json",
					type:"post",
					success:function (obj){
						if(obj.code=="1"){
							pageForQueryByConditions($("#mypage").bs_pagination('getOption', 'currentPage'),$("#mypage").bs_pagination('getOption', 'rowsPerPage'))

						}else{
							alert(obj.message)
						}
					}

				})


			}



		})



		
	});
	/* alert??????????????????????????????????????????????????????
	window.alert = function(msg, callback) {
		var div = document.createElement("div");
		div.innerHTML = "<style type=\"text/css\">"
				+ ".nbaMask { position: fixed; z-index: 1000; top: 0; right: 0; left: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); }                                                                                                                                                                       "
				+ ".nbaMaskTransparent { position: fixed; z-index: 1000; top: 0; right: 0; left: 0; bottom: 0; }                                                                                                                                                                                            "
				+ ".nbaDialog { position: fixed; z-index: 5000; width: 80%; max-width: 300px; top: 50%; left: 50%; -webkit-transform: translate(-50%, -50%); transform: translate(-50%, -50%); background-color: #fff; text-align: center; border-radius: 8px; overflow: hidden; opacity: 1; color: white; }"
				+ ".nbaDialog .nbaDialogHd { padding: .2rem .27rem .08rem .27rem; }                                                                                                                                                                                                                         "
				+ ".nbaDialog .nbaDialogHd .nbaDialogTitle { font-size: 17px; font-weight: 400; }                                                                                                                                                                                                           "
				+ ".nbaDialog .nbaDialogBd { padding: 0 .27rem; font-size: 15px; line-height: 1.3; word-wrap: break-word; word-break: break-all; color: #000000; }                                                                                                                                          "
				+ ".nbaDialog .nbaDialogFt { position: relative; line-height: 48px; font-size: 17px; display: -webkit-box; display: -webkit-flex; display: flex; }                                                                                                                                          "
				+ ".nbaDialog .nbaDialogFt:after { content: \" \"; position: absolute; left: 0; top: 0; right: 0; height: 1px; border-top: 1px solid #e6e6e6; color: #e6e6e6; -webkit-transform-origin: 0 0; transform-origin: 0 0; -webkit-transform: scaleY(0.5); transform: scaleY(0.5); }               "
				+ ".nbaDialog .nbaDialogBtn { display: block; -webkit-box-flex: 1; -webkit-flex: 1; flex: 1; color: #09BB07; text-decoration: none; -webkit-tap-highlight-color: transparent; position: relative; margin-bottom: 0; }                                                                       "
				+ ".nbaDialog .nbaDialogBtn:after { content: \" \"; position: absolute; left: 0; top: 0; width: 1px; bottom: 0; border-left: 1px solid #e6e6e6; color: #e6e6e6; -webkit-transform-origin: 0 0; transform-origin: 0 0; -webkit-transform: scaleX(0.5); transform: scaleX(0.5); }             "
				+ ".nbaDialog a { text-decoration: none; -webkit-tap-highlight-color: transparent; }"
				+ "</style>"
				+ "<div id=\"dialogs2\" style=\"display: none\">"
				+ "<div class=\"nbaMask\"></div>"
				+ "<div class=\"nbaDialog\">"
				+ "    <div class=\"nbaDialogHd\">"
				+ "        <strong class=\"nbaDialogTitle\"></strong>"
				+ "    </div>"
				+ "    <div class=\"nbaDialogBd\" id=\"dialog_msg2\">????????????????????????????????????????????????????????????????????????????????????????????????</div>"
				+ "    <div class=\"nbaDialogHd\">"
				+ "        <strong class=\"nbaDialogTitle\"></strong>"
				+ "    </div>"
				+ "    <div class=\"nbaDialogFt\">"
				+ "        <a href=\"javascript:;\" class=\"nbaDialogBtn nbaDialogBtnPrimary\" id=\"dialog_ok2\">??????</a>"
				+ "    </div></div></div>";
		document.body.appendChild(div);

		var dialogs2 = document.getElementById("dialogs2");
		dialogs2.style.display = 'block';

		var dialog_msg2 = document.getElementById("dialog_msg2");
		dialog_msg2.innerHTML = msg;

		// var dialog_cancel = document.getElementById("dialog_cancel");
		// dialog_cancel.onclick = function() {
		// dialogs2.style.display = 'none';
		// };
		var dialog_ok2 = document.getElementById("dialog_ok2");
		dialog_ok2.onclick = function() {
			dialogs2.style.display = 'none';
			callback();
		};
	};*/
	function pageForQueryByConditions(pageNum,pageSize){

				var owner           =$("#query-owner").val()
				var name            =$("#query-name").val()
				var customerName      =$("#query-customerName").val()
				var stage           =$("#query-stage").val()
				var type            =$("#query-type").val()
				var source          =$("#query-source").val()
				var fullname =$("#query-contactsName").val()

				//alert("aaaa")
				$.ajax({
					url:"workbench/transaction/queryConditionsForPage.do",
					data:{
						pageNum:pageNum,
						pageSize:pageSize,
						owner          :owner          ,
						 name           :name           ,
						 customerName     :customerName     ,
						 stage          :stage          ,
						 type           :type           ,
						 source         :source         ,
						fullname:fullname,

					},
					dataType:"json",
					type:"post",
					success:function (data){
						var htmlStr=""
						$.each(data.tranList,function (index,tran){
							htmlStr+="<tr>"
							htmlStr+="<td><input type=\"checkbox\" value=\""+tran.id+"\" /></td>"
							htmlStr+="		<td><a style=\"text-decoration: none; cursor: pointer;\" tranId=\""+tran.id+"\">"+tran.name+"</a></td>"
							htmlStr+="<td>"+tran.customerId+"</td>"
							htmlStr+="<td>"+tran.stage+"</td>"
							htmlStr+="<td>"+tran.type+"</td>"
							htmlStr+="<td>"+tran.owner+"</td>"
							htmlStr+="<td>"+tran.source+"</td>"
							htmlStr+="<td>"+tran.contactsId+"</td>"
							htmlStr+="</tr>"
						})
						$("#checkAll").prop("checked",false)
						$("#tbody").html(htmlStr)

						var totalPages=0
						if(data.totalRows%pageSize==0){
							totalPages=data.totalRows/pageSize
						}else{
							totalPages=parseInt(data.totalRows/pageSize)+1
						}

						$("#mypage").bs_pagination({
							currentPage: pageNum,

							rowsPerPage: pageSize,
							totalRows: data.totalRows,
							totalPages: totalPages,  //??????

							visiblePageLinks: 5,

							showGoToPage: true,
							showRowsPerPage: true,
							showRowsInfo: true,

							//  $("#element_id").bs_pagination('getOption', 'option_name');
							onChangePage: function (event, data) {
								// alert(data.currentPage)
								// alert(data.rowsPerPage)
								pageForQueryByConditions($("#mypage").bs_pagination('getOption', 'currentPage'),$("#mypage").bs_pagination('getOption', 'rowsPerPage'))
								// alert($("#mypage").bs_pagination('getOption', 'currentPage'))
								// alert($("#mypage").bs_pagination('getOption', 'rowsPerPage'))
							}
						})


					}
				})


	}
	
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>????????????</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">?????????</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
				      <input class="form-control" type="text" id="query-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
					  <select class="form-control" id="query-stage">
					  	<option></option>
						  <c:forEach items="${dicValueStageList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  	<%--<option>????????????</option>
					  	<option>????????????</option>
					  	<option>????????????</option>
					  	<option>???????????????</option>
					  	<option>??????/??????</option>
					  	<option>??????/??????</option>
					  	<option>??????</option>
					  	<option>???????????????</option>
					  	<option>?????????????????????</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
					  <select class="form-control" id="query-type">
					  	<option></option>
						  <c:forEach items="${dicValueTransactionTypeList}" var="t">
							  <option value="${t.id}">${t.value}</option>
						  </c:forEach>
					  	<%--<option>????????????</option>
					  	<option>?????????</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <select class="form-control" id="query-source">
						  <option></option>
						  <c:forEach items="${dicValueSourceList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
						  <%--<option>??????</option>
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
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">???????????????</div>
				      <input class="form-control" type="text" id="query-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryBtn">??????</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTranBtn"><span class="glyphicon glyphicon-plus"></span> ??????</button>
				  <button type="button" class="btn btn-default" id="editTranBtn"><span class="glyphicon glyphicon-pencil"></span> ??????</button>
				  <button type="button" class="btn btn-danger" id="deleteTranBtn"><span class="glyphicon glyphicon-minus"></span> ??????</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>??????</td>
							<td>????????????</td>
							<td>??????</td>
							<td>??????</td>
							<td>?????????</td>
							<td>??????</td>
							<td>???????????????</td>
						</tr>
					</thead>
					<tbody id="tbody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">????????????-??????01</a></td>
							<td>????????????</td>
							<td>??????/??????</td>
							<td>?????????</td>
							<td>zhangsan</td>
							<td>??????</td>
							<td>??????</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">????????????-??????01</a></td>
                            <td>????????????</td>
                            <td>??????/??????</td>
                            <td>?????????</td>
                            <td>zhangsan</td>
                            <td>??????</td>
                            <td>??????</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="mypage"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 20px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">???<b>50</b>?????????</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">??????</button>
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
					<button type="button" class="btn btn-default" style="cursor: default;">???/???</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">??????</a></li>
							<li class="disabled"><a href="#">?????????</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">?????????</a></li>
							<li class="disabled"><a href="#">??????</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>