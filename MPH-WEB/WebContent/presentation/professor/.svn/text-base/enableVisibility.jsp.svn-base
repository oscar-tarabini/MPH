<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@page import="exceptions.NotValidProjectException"%>
<%@page import="exceptions.NotLoggedInException"%>
<%@ page import="java.util.List"%>
<%@ page import="entityBeans.Group"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<title>Enable visibility</title>
</head>
<body>
<%
	ProfessorManagerBeanRemote profManager = null;
	List<Group> allGroups = null;
	List<Group> notViewer = null;
	Object objectStateful = session.getAttribute("statefulBean");
	if (objectStateful != null && objectStateful instanceof ProfessorManagerBeanRemote){
		try{
			profManager = (ProfessorManagerBeanRemote) objectStateful;
			allGroups = profManager.getGroups();
			notViewer = profManager.getGroupsNotViewer();
		}catch(NotLoggedInException e){
			response.sendRedirect("../../errorPage.jsp?message=login is required");
			return;
		}catch(NotValidProjectException e2){
			response.sendRedirect("../../errorPage.jsp?message=project name not valid");
			return;
		}
	}
	else{ %>
		<jsp:forward page="../../errorPage.jsp">
			<jsp:param value="login is required" name="message"/>
		</jsp:forward>
	
	<% }%>
	
	<div id="header">
		<div>
		<a href="professorProjectsList.jsp">
			<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
		</a>
		<label class="topLeftLabel">
		<%=profManager.getProject().getName() %> - ENABLE VISIBILITY
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
	
	
	<%if(allGroups == null || allGroups.size() == 0){
		%>
		<div class="listItem">There are not registered group yet</div>
		<%
	}
	else if(notViewer == null || notViewer.size() == 0){
		%>
		<div class="listItem">All groups have already been associated to another group</div>
		<%
	}else{
	%>
	<div class="container_form">
		<form class="form" action="../../controller/controllerProf.jsp?action=enableVisibility" method="post">
		
		<div class="list">
			
			<div class="listTitle">
			<label class="listTitle"><span class="listTitle">group to enable</span> </label>
			</div>
		
		 <select name="viewer">
			<%for(int i = 0; i < notViewer.size(); i++){
				Group group = (Group)(notViewer.get(i));
				int numComponents = group.getStudents().size();
				%>
				<div class="listItem">
				<option value="<%=group.getGroupID()%>"> <%=group.getName()%> / <%=numComponents %></option>
				</div>
				<%
			}%>
		</select>
		</div><br/>
		
			<div class="list">
			
			<div class="listTitle">
			<label class="listTitle"><span class="listTitle">group to be visible </span> </label>
			</div>
		 <select name="viewed">
			<%for(int i = 0; i < allGroups.size(); i++){
				Group group = (Group)(allGroups.get(i));
				int numComponents = group.getStudents().size();
				%>
				<div class="listItem">
				<option value="<%=group.getGroupID()%>"> <%=group.getName()%> / <%=numComponents %></option>
				</div>
				<%
			}%>
		</select>
		</div>
		
		<div class="listItem">
 		<input type="submit" name="button" value="confirm visibility" />
 		</div>
	</form>
	
	</div>
	<%} %>
	<br/>
	<div class="listItem message">
	<%String message = request.getParameter("message");
					if(message != null) { %>
			<br/><p id="errorMessage"> 
			 <br/>
			<%=message %> <%} %>
			
		</div>
			
	<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectList">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				You can select a group to give it the possibility to view the documents of another group. Near the group 
				you can see the number of components of that group.
				(group name / number of components)
			</a>
		</div>
	</div>	
	<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
</body>
</html>