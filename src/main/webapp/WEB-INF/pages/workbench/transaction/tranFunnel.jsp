<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function (){
           // text: '交易统计图表',
               // subtext: '交易表中各个阶段的数量'
            $.ajax({
                url:"workbench/transaction/stageCountTranGroupByStageForChart.do",
                dataType:"json",
                type:"post",
                success:function (obj){
                    var myChart = echarts.init($("#mydiv")[0]);
                    var option = {
                        title: {
                            text: '交易统计图表',
                            subtext: '交易表中各个阶段的数量'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b} : {c}'
                        },
                        toolbox: {
                            feature: {
                                dataView: { readOnly: false },
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        /*legend: {
                            data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
                        },*/
                        series: [
                            {
                                name: '数据量',
                                type: 'funnel',
                                left: '10%',
                                // top: 60,
                                // bottom: 60,
                                width: '80%',
                                // min: 0,
                                //max: 100,
                                //minSize: '0%',
                                //maxSize: '100%',
                                // sort: 'descending',
                                // gap: 2,
                                label: {
                                    formatter: '{b}'
                                    // show: true,
                                    // position: 'inside'
                                },
                                labelLine: {
                                    show:true
                                    /*length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }*/
                                },
                                itemStyle: {
                                    opacity:0.7
                                    /*borderColor: '#fff',
                                    borderWidth: 1*/
                                },
                                emphasis: {
                                    label: {
                                        //fontSize: 20
                                        position:'inside',
                                        formatter:'{b}:{c}'
                                    }
                                },
                                data: obj
                            }
                        ]
                    };
                    myChart.setOption(option);
                }
            })

        })

    </script>
    <title>Title</title>
</head>
<body>
<center>
<div style="height: 600px;width: 400px" id="mydiv"></div>
</center>
<%----%>

</body>
</html>
