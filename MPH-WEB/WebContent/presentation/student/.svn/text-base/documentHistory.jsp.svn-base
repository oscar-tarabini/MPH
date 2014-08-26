<%@page import="java.io.IOException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<%@ page import="entityBeans.GroupDocument"%>
<%@ page import="entityBeans.Deadline"%>
<%@ page import="entityBeans.Group"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.io.IOException"%>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<title>Document History</title>
</head>
<body>

<%
StudentManagerBeanRemote studManager = null;
Object objectStateful = session.getAttribute("statefulBean");
if (objectStateful != null && objectStateful instanceof StudentManagerBeanRemote){
	studManager = (StudentManagerBeanRemote) objectStateful;
}
else{ %>
	<jsp:forward page="../../errorPage.jsp">
		<jsp:param value="login is required" name="message"/>
	</jsp:forward>

<% }%>

<%
String historyOf = request.getParameter("historyOf");
String filteredBy = request.getParameter("filteredBy");
if (historyOf == null || filteredBy == null) {
	response.sendRedirect("studentProjectArea.jsp");
	return;
}
%>

<!-- HEADER -->
<div id="header">
			<div>
			<a href="studentProjectList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=studManager.getProject().getName() %> - Document History <% if (historyOf.equals("viewedGroup")) { %> of Viewed Group <%}%>
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<li>
				<a href="studentProjectArea.jsp?projectName=<%=studManager.getProject().getName()%>" class="topLandmark changePasswordSelection">Project Area</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=studentLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>

<%
if (historyOf.equals("group")) {
	List<GroupDocument> documents = null;
	try {
		documents = studManager.getAllDocuments();
	} catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect("studentProjectArea.jsp?message=error in retrieving the documents");
		return;
	}
	if (documents == null || documents.isEmpty()) {
		out.println("The group has no document uploaded");
		//out.println("<br/><p><a href='studentProjectArea.jsp'>Project area</a></p>");
		return;
	} else {
		if (filteredBy.equals("all")) { %>
			<div class="list">
				<div class="listTitle">
					<label class="listTitle">Document History</label>	
				</div>
		<%
		} else {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
			Date date = sdf.parse(filteredBy);
			Timestamp timestamp = new Timestamp(date.getTime()); %>
			<div class="list">
				<div class="listTitle">
					<label class="listTitle">Document History</label>	
				</div>
				<div class="listItem">
					Deadline: <span class="listItem"><%=studManager.getDeadlineName(timestamp) %></span>
				</div>
				<div class="listItem">
					Expiring date: <span class="listItem"><%=filteredBy %></span>
				</div>
			<%
		}
		
		
		for (GroupDocument doc: documents) {
			if (doc.getDeadlineDate().toString().equals(filteredBy) || filteredBy.equals("all")) {
				String name = doc.getName();
				String uploadDate = doc.getUploadDate().toString();
				String student = doc.getStudentEmail();
				String deadline = studManager.getDeadlineName(doc.getDeadlineDate());
				int fileId = doc.getDocumentID();%>
				<div class="listItem">
					<a href="../../controller/controllerUploadDownload.jsp?action=downloadGroupDocument&fileId=<%=fileId %>"><%=name %></a>, uploaded by <%=student %> on <%=uploadDate %> for the deadline <%=deadline %> 
				</div>
				<%
			}
		}
	%>
	</div>
	
	<%}
	
	
} else if (historyOf.equals("viewedGroup")) {

	List<GroupDocument> documents = null;
	if (!studManager.hasViewedGroup()) {
		response.sendRedirect("studentProjectArea.jsp?message=error in retrieving the viewed group documents");
		return;
	}
	try {
		documents = studManager.getAllDocumentsOfViewedGroup();
	} catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect("studentProjectArea.jsp?message=error in retrieving the viewed group documents");
		return;
	}
	if (documents == null || documents.isEmpty()) {
		out.println("The viewed group has no document uploaded");
		//out.println("<p><a href='studentProjectArea.jsp'>Project area</a></p>");
		return;
	} else {
		Group viewedGroup = studManager.getViewedGroup();
		%>
		
		<div class="list">
			<div class="listTitle">
				<label class="listTitle">Viewed Group</label>	
			</div>
			<div class="listItem">
				Components:<br>
				<%
				if (viewedGroup.getStudent1() != null) {
					out.println("<span class=\"listItem\">" + viewedGroup.getStudent1() + "</span><br>");
				}
				if (viewedGroup.getStudent2() != null) {
					out.println("<span class=\"listItem\">" + viewedGroup.getStudent2() + "</span><br>");
				}
				if (viewedGroup.getStudent3() != null) {
					out.println("<span class=\"listItem\">" + viewedGroup.getStudent3() + "</span><br>");
				}
				%>
			</div>
		</div>
		<div class="list">
			<div class="listTitle">
				<label class="listTitle">Documents of Viewed Group</label>	
			</div>
		<%
		if (!filteredBy.equals("all")) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
			Date date = sdf.parse(filteredBy);
			Timestamp timestamp = new Timestamp(date.getTime()); %>
			
			<div class="listItem">
				Filtered by deadline <span class="listItem"><%=studManager.getDeadlineName(timestamp) %></span>
			</div>
			
			<%
		}
		for (GroupDocument doc: documents) {
			if (doc.getDeadlineDate().toString().equals(filteredBy) || filteredBy.equals("all")) {
				String name = doc.getName();
				String uploadDate = doc.getUploadDate().toString();
				String student = doc.getStudentEmail();
				String deadline = studManager.getDeadlineName(doc.getDeadlineDate());
				int fileId = doc.getDocumentID(); %>
				
				<div class="listItem">
					
				</div>
					<a href="../../controller/controllerUploadDownload.jsp?action=downloadGroupDocument&fileId=<%=fileId %>"><%=name %></a>, uploaded by <%=student %> on <%=deadline %> for the deadline <%=deadline %>
				<%
			}
		}
		%>
		</div>
		<%
	}
	
}
%>
<div class="list">
	<div class="listTitle">
		<label class="listTitle">Filter by Deadline</label>	
	</div>
	<div class="listItem">
		<form>
			<select name="filteredBy">
			<option value="all">All deadlines</option>
			<%
			List<Deadline> list = studManager.getDeadlines();
			for (Deadline d: list) {
				out.println("<option value=\"" + d.getKey().getDate().toString() +"\">" + d.getName() +"</option>");
			}
			%>
			</select>
			<%
			if (historyOf.equals("group")) {
				out.println("<input type=\"hidden\" name=\"historyOf\" value=\"group\">");
			} else {
				out.println("<input type=\"hidden\" name=\"historyOf\" value=\"viewedGroup\">");
			}
			%>
			<input type="submit" name="submitFilter" value="Filter">
		</form>
	</div>
</div>	

<% if (historyOf.equals("viewedGroup")) { %>
<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In this page you can find the information of your viewed group and the complete history of his uploaded document, ordered by uploading date<br/>
				Moreover you can filter the displayed document by deadline, selecting the desired one.  
			</a>
		</div>
		</div>
	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
<%} else { %>
<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In this page you can view the complete history of your uploaded document, ordered by uploading date<br/>
				Moreover you can filter the displayed document by deadline, selecting the desired one.  
			</a>
		</div>
		</div>
	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
<%} %>

</body>
</html>