<%@ page import="com.xerp.common.consts.ConfigConst" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Title</title>
    <jsp:include page="../include/common.jsp" flush="true"/>
</head>
<body>
<div id="winWorkFlow" class="easyui-window" title="Show Work Flow" style="width:1400px;height:700px;padding:1px;"
     data-options="
         modal:true,
         minimizable: false,
         maximizable: false,
         resizable: false,
         closed:true,
         iconCls:'icon-flow',cls:'c8'">
    <iframe id="ifrWorkFlow" name="ifrWorkFlow" src="" width="100%" height="100%" frameborder="0"></iframe>
</div>
<table class="tbl" style="width:100%;height:50px;">
    <tr style="display: none">
        <td class="tblCell" style="width: 100%" colspan="2">
            flowCode:<input value="flow00002" type="Text" name="flowCode" id="flowCode"/><br/>
            flowModule:<input value="vacation" type="Text" name="flowModule" id="flowModule"/><br/>
        </td>
    </tr>
    <tr>
        <td bgColor="#0a589a" style="color: #000000;height:2px" colspan="2"></td>
    </tr>
    <tr>
        <td class="tblTitle" style="width: 10%">
            <img src="<%=basePath%>static/image/flow.png"/>
            <a id="flowInfo" onclick="showFlowGraph()" href="javascript:void(0)"></a>
        </td>
        <td class="tblCell" style="width: 90%">
            <jsp:include page="../include/flowProcessShow.jsp" flush="true"/>
        </td>
    </tr>
</table>
<table class="tbl" style="width:100%;height:200px;">
    <tr>
        <td class="tblCell" style="width: 100%;height: 60px;text-align: center" colspan="2">
            XXXXXX申请
        </td>
    </tr>
    <tr>
        <td class="tblTitle" style="width: 10%">
            备注
        </td>
        <td class="tblCell" style="width: 90%">
            <input class="easyui-textbox" data-options="multiline:true" value="" name="message" type="text" id="message"
                   style="width:80%;height: 99%"/>
        </td>
    </tr>
    <tr>
        <td class="tblTitle" style="width: 100%;height: 45px;" colspan="2">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" style="width:100px">保存</a>
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" style="width:100px"
               onclick="openFlowToNext();">提交</a>
        </td>
    </tr>
</table>
<jsp:include page="../include/flowToNextNode.jsp" flush="true"/>
</body>
</html>

<script>
    var url = "";



</script>