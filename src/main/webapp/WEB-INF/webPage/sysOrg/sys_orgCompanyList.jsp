<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page import="com.xerp.common.consts.ConfigConst" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>CompanyList</title>
    <jsp:include page="../include/common.jsp" flush="true"/>
</head>
<body style="text-align: center">
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north'" style="height:28px">
        <table style="width: 100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td bgColor="#F9FBFC"
                    style="COLOR: #000000;text-align:left;font-weight:bold; color:#195E8A; height:23px">
                    &nbsp;<img alt="Config" src="<%=basePath%>static/image/config.gif"
                               style="width: 16px; height: 16px"/>&nbsp;公司列表
                </td>
            </tr>
            <tr>
                <td bgColor="#0a589a" style="COLOR: #000000;height:2px"></td>
            </tr>
            <tr>
                <td style="height:1px"></td>
            </tr>
        </table>
    </div>
    <div data-options="region:'center'">
        <table id="dataList" class="easyui-datagrid" style="width:100%;" fit="true"
               data-options="
               singleSelect:true,
               rownumbers:true,
               pagination:true,
               idField:'uuid',
               nowarp:false,
               border:false,
               pageSize:30,
               pageList:[30,50,70],
               collapsible:true,
               method:'get',
                rowStyler: function(index,row){
                    if(row.status=='<%=ConfigConst.STR_STATUS_ACTIVE_NUM%>'){
                        row.statusTxt= '<%=ConfigConst.STR_STATUS_ACTIVE_TXT%>';
                    }
                    if(row.status=='<%=ConfigConst.STR_STATUS_BLOCK_NUM%>'){
                        row.statusTxt = '<b><%=ConfigConst.STR_STATUS_BLOCK_TXT%><b>';
                        }
                    if(row.status=='<%=ConfigConst.STR_STATUS_DELETE_NUM%>'){
                    row.statusTxt = '<b><i><%=ConfigConst.STR_STATUS_DELETE_TXT%><i><b>';
                    }
           },
           toolbar:toolbar">
        </table>
    </div>
    <div id="companyConfig" class="easyui-dialog" style="width:900px;height:670px"
         data-options="
         iconCls:'icon-setting',
         title:'公司配置',
         closed:true,
         modal:true,
         collapsible:true,
         minimizable:false,
         maximizable:false,
         draggable:true,
         resizable:false,
         buttons: [{
					text:'Save',
					iconCls:'icon-save',
					handler:function(){
                        $('#ifrCompanyConfig')[0].contentWindow.saveData();
					}
				},{
					text:'Close',
					iconCls:'icon-close',
					handler:function(){
						$('#companyConfig').dialog('close');
					}
				}],cls:'c8'">
        <iframe id="ifrCompanyConfig" name="ifrCompanyConfig" src="" width="100%" height="100%"
                frameborder="0"></iframe>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    //Toolbar
    var toolbar = [{
        text: 'Add New',
        iconCls: 'icon-add',
        handler: function () {
            showDialogWin('ifrCompanyConfig','companyConfig',
                '<%=basePath %>sysOrg/company/gotoConfPage.action?ws=<%=ConfigConst.STR_WS_CREATE%>');
        }
    }, '-', {
        text: 'Remove',
        iconCls: 'icon-remove',
        handler: function () {
            var selectedRows = $("#dataList").datagrid('getSelections');
            if (selectedRows.length == 0) {
                $.messager.alert("Message", "Please Choose Data First！");
                return;
            }
            var arrayIds = [];
            for (var i = 0; i < selectedRows.length; i++) {
                arrayIds.push(selectedRows[i].uuid);
            }
            var arrayIds = arrayIds.join(",");
            $.messager.confirm("Message", "Are Sure to this option?", function (r) {
                if (r) {
                    $.post("<%=basePath%>sysOrg/company/deleteData.action", {
                        uuids: arrayIds
                    }, function (result) {
                        if (result.success) {
                            //$.messager.alert("系统提示", "操作成功！");
                            $("#dataList").datagrid("reload");
                            $('#dataList').datagrid('clearSelections');
                        } else {
                            $.messager.error("Error", "Please contact system administrator！");
                        }
                    }, "json");
                }
            });
        }
    }, '-', {
        text: 'Refresh',
        iconCls: 'icon-reload',
        handler: function () {
            $("#dataList").datagrid("reload");
        }
    }];

    //dataGrid basic Setting
    $(function () {
        $('#dataList').datagrid({
            url: '<%=basePath%>sysOrg/company/listData.action',
            columns: [[
                {field: 'cb', checkbox: 'true', width: 30},
                {field: 'uuid', title: 'uuid', width: 100, hidden: true},
                {field: 'status', title: 'status', width: 50, hidden: true},
                {field: 'statusTxt', title: '狀態', width: 100},
                {
                    field: 'companyCode', title: '公司編碼', width: 100,
                    formatter: function (value, row, index) {
                        return '<a style="color:blue" href="#" onclick=showDialogWin("ifrCompanyConfig","companyConfig",' +
                            '"<%=basePath %>sysOrg/company/gotoConfPage.action?ws=update&uuid=' + row.uuid + '");>' + row.companyCode + '</a>';
                    }
                },
                {
                    field: 'companyName', title: '公司名稱', width: 250,
                    formatter: function (value, row, index) {
                        return '<a style="color:blue" href="#" onclick=showDialogWin("ifrCompanyConfig","companyConfig",' +
                            '"<%=basePath %>sysOrg/company/gotoConfPage.action?ws=update&uuid=' + row.uuid + '")>' + row.companyName + '</a>';
                    }
                },
                {
                    field: 'parentName', title: '母公司名', width: 230,
                    formatter: function (value, row, index) {
                        var parentName = "";
                        if (row.parentUuid != "") {
                            $.ajax({
                                async: false,
                                type: 'get',
                                url: '<%=basePath%>sysOrg/company/listByUuid.action?uuid=' + row.parentUuid,
                                dataType: 'json',
                                success: function (data) {
                                    if (data != null) {
                                        parentName = data[0].companyName;
                                    }
                                }
                            });
                        }
                        return parentName;
                    }
                },
                {field: 'address', title: '公司地址', width: 400},
                {field: 'city', title: '所在城市', width: 100},
                {field: 'country', title: '所在國家', width: 100},
                {field: 'factory', title: '啟用工廠', width: 80},
                {field: 'warehouse', title: '啟用貨倉', width: 80}
            ]],
            onLoadSuccess: function (data) {
                //加载完毕后获取所有的checkbox遍历
                if (data.rows.length > 0) {
                    //循环判断操作
                    for (var i = 0; i < data.rows.length; i++) {
                        if (data.rows[i].status != '<%=ConfigConst.STR_STATUS_DELETE_NUM%>') {
                            $("input[type='checkbox']")[i + 1].disabled = true;
                        }
                    }
                }
            },
            onClickRow: function (rowIndex, rowData) {
                //加载完毕后获取所有的checkbox遍历
                $("input[type='checkbox']").each(function (index, el) {
                    //如果当前的复选框不可选，则不让其选中
                    if (el.disabled == true) {
                        $('#dataList').datagrid('unselectRow', index - 1);
                    }
                })
            }
        });
    });
</script>