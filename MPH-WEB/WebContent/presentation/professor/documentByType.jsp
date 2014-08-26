<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="exceptions.NotValidProjectException"%>
<%@ page import="exceptions.NotLoggedInException"%>
<%@ page import="entityBeans.GroupDocument"%>
<%@ page import="entityBeans.Group"%>
<%@ page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<script type="text/javascript">
var hh=0;
var inter;
 
//we show the box by setting the visibility of the element and incrementing the height smoothly
function ShowBox()
{
 
//Depending on the amount of text, set the maximum height here in pixels
//NB: Qua bisogna cambiare l'altezza delle istruzioni!!!

     if(hh==50)
     {
     clearInterval(inter);
     return;
     }
 
     obj = document.getElementById("cover");
     obj.style.visibility = 'visible';
     hh+=2;
     obj.style.height = hh + 'px';
}
 
//same way as above but reversed
function HideBox()
{
     obj = document.getElementById("cover");
 
     if(hh==2)
     {
     obj.style.visibility = 'hidden';
     obj.style.height = '0.1em';
     clearInterval(inter);
     return;
     }
     hh-=2;
     obj.style.height = hh + 'px';
}
</script>
<title>Document By Type</title>
</head>
<body>
<%
	ProfessorManagerBeanRemote profManager = null;
	Object objectStateful = session.getAttribute("statefulBean");
	
	if (objectStateful != null && objectStateful instanceof ProfessorManagerBeanRemote){
			profManager = (ProfessorManagerBeanRemote) objectStateful;
	}
	else{ %>
		<jsp:forward page="../../errorPage.jsp">
			<jsp:param value="login is required" name="message"/>
		</jsp:forward>
	
	<% }%>
	
<%
	String deadlineDate = request.getParameter("deadlineDate");
	if (deadlineDate == null || deadlineDate.isEmpty()) {
		response.sendRedirect("profProjectArea.jsp?message=error in retrieving documents by deadline");
		return;
	}
	List<GroupDocument> documents = null;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
	Date date = sdf.parse(deadlineDate);
	Timestamp timestamp = new Timestamp(date.getTime());
	List<Group> groups = null;
	try {
		documents = profManager.getDocumentsByDeadline(deadlineDate);
		groups = profManager.getGroups();
	} catch (NotLoggedInException e) {
		response.sendRedirect("../../errorPage.jsp?message=login is required");
		return;
	} catch (NotValidProjectException e) {
		response.sendRedirect("profProjectArea.jsp?message=error in retrieving documents by deadline");
		return;
	}
	if (documents == null || groups == null) {
		response.sendRedirect("profProjectArea.jsp?message=error in retrieving documents by deadline");
		return;
	}
	
	%>
		<div id="header">
			<div>
			<a href="professorProjectsList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=profManager.getProject().getName() %> - <%=profManager.getDeadlineName(timestamp)%>
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<li>
				<a href="profProjectArea.jsp" class="topLandmark">Project Area</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=professorLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
	<%
	if(groups == null || groups.isEmpty()){
		%>
		<div class="listItem">There is no group registered so far</div>
		<%
	}
	for (Group g: groups) {
		
		out.println("<div class=\"list\">");
		out.println("<div class=\"listTitle\"><label class=\"listTitle\">Documents of group " + g.getName()+"</label></div>");
		for (GroupDocument doc: documents) {
			if (doc.getGroup() == g.getGroupID()) {
				String name = doc.getName();
				String uploadDate = doc.getUploadDate().toLocaleString();
				String group = profManager.getGroupName(doc.getGroup());
				String student = doc.getStudentEmail();
				String deadline = profManager.getDeadlineName(doc.getDeadlineDate());
				int fileId = doc.getDocumentID();
				out.println("<div class=\"listItem\"><a href=\"../../controller/controllerUploadDownload.jsp?action=downloadGroupDocument&professor=yes&fileId="+ fileId + "\">" + name + "</a> " + "upload: "+uploadDate + "  "+ "by " + student + "</div> ");
			}
		}
		out.println("</div>");
	}
	
	
%>

<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectList">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				You can download the documents you want.
			</a>
		</div>
	</div>
	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
</body>
</html>