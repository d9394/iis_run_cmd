<%
	d=date()
	date1=year(d) & iif (month(d)<10,"0","") & month(d) & iif(day(d)<10 ,"0","") & day(d)

	dim action
	action=request.form("submitaction")
	set fso=server.CreateObject("wscript.shell")
	dim process
	process=fso.exec("cmd.exe /c tasklist | find " & chr(34) & "rsync" & chr(34)).StdOut.ReadAll()
	set fso=nothing
	dim check
	check=instr(process,"rsync")>0
	url = Request.ServerVariables("SCRIPT_NAME")
	urlParts = Split(url,"/")
	pageName = urlParts(UBound(urlParts))
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	Set fso = CreateObject("Scripting.FileSystemObject")
	if fso.fileexists("Q:\Cluster\0.hive") then
		response.write "<meta http-equiv=" & chr(34) & "Content-Type" & chr(34) & " content=" & chr(34) & "text/html; charset=utf-8" & chr(34) & " />"
	else
		response.write "<meta http-equiv=" & chr(34) & "refresh" & chr(34) & " content=" & chr(34) & "0; url=http://10.0.20.151/default.asp" & chr(34) & " />"
	end if
	set fso=nothing
	if check then
		response.write "<meta http-equiv=" & chr(34) & "refresh" & chr(34) & "content=" & chr(34) & "10" & chr(34) & " />"
	end if
%>
<title>XXXX同步工具</title>
<style type="text/css">
<!--
body {
	color:#000000;
	background-color:#B3B3B3;
	margin:0;
}

#container {
	margin-left:auto;
	margin-right:auto;
	text-align:center;
	}

a img {
	border:none;
}

-->
</style>
</head>
<SCRIPT LANGUAGE="JavaScript">
var sAction="";
function VerifyOP(sAction){
document.form1.submitaction.value = sAction;
document.form1.action = "<%=pageName%>";
document.form1.button1.disabled = true;
document.form1.button2.disabled = true;
document.form1.submit();
}
</SCRIPT>
<body>
<div id="container">
<center>
<form name="form1" method="post">
<table border=1>
	<tr>
		<td colspan=4>今天日期是：<font color=red><%=date1%></font></td>
	</tr>
<%
	if check then
		response.write "<tr><td colspan=4><font color=blue><b>系统正在同步文件，请稍候再试。</b></font><br/>（本页面将会自动刷新）</td></tr>"
	end if
%>
	<tr>
		<td><p>将办公网文件同步到交易网：<input type="button" value="BIZ2SC" name="button1" onClick="VerifyOP('BIZ2SC')" <%=iif(check,"disabled","")%> ></p></td>
	</tr>
	<tr>
		<td><p>将交易网文件同步到办公网：<input type="button" value="SC2BIZ" name="button2" onClick="VerifyOP('SC2BIZ')" <%=iif(check,"disabled","")%> ></p></td>
	</td>
	<input type="hidden" name="submitaction" value="">
</table>
</form>
<table border=1>
<tr><td align=center>执行信息（调试用）</td></tr>
<tr><td align=left>
<%
	if action="BIZ2SC" and not check then	
		response.write "将办公网文件同步到交易网(BIZ->SC)："& now() & "<BR/>"
		Set WshShell = server.CreateObject("Wscript.Shell")
		command1 = chr(34) & Server.MapPath("call_biz2sc.bat") & chr(34)
		Set IsSuccess = WshShell.exec("cmd /c " & command1)
		getLine = Replace(IsSuccess.StdOut.ReadAll(),chr(10),"<BR/>")
		response.write getLine
		Set IsSuccess = Nothing
		Set WshShell = Nothing
	end if
	if action="SC2BIZ" and not check then
		response.write "将交易网文件同步到办公网(SC->BIZ)："& now() & "<BR/>" 
		Set WshShell = server.CreateObject("Wscript.Shell")
		Set IsSuccess = WshShell.exec("cmd /c " & Server.MapPath("call_sc2biz.bat"))
		getLine = Replace(IsSuccess.StdOut.ReadAll(),chr(10),"<BR/>")
		response.write getLine
		Set IsSuccess = Nothing
		Set WshShell = Nothing
	end if
	if check then
		response.write "<font color=blue><b>系统正在同步文件，请稍候再试。</b></font><br/>（本页面将会自动刷新）"
	end if
%>
</td></tr>
</table>
</center>
</div>
</body>
</html>
<%
Function IIf(bExp1, sVal1, sVal2)
    If (bExp1) Then
        IIf = sVal1
    Else
        IIf = sVal2
    End If
End Function
%>
