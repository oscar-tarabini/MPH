<%@page import="exceptions.NotLoggedInException"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content=""/>
<meta name="description" content="profesor's projects private area " />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<title>Your projects</title>

</head>

<body>

		<div id="header">
			<div>
			<a href="professorProjectsList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			Professor Area
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<li>
				<a href="newProjectCreation.jsp" class="topLandmark createSelection"> Create New Project</a>
				</li>
				<li>
				<a href="profChangePassword.jsp" class="topLandmark changePasswordSelection"> Change Password</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=professorLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>


<%
	ProfessorManagerBeanRemote profManager = null;
	Object objectStateful = session.getAttribute("statefulBean");
	if (objectStateful != null && objectStateful instanceof ProfessorManagerBeanRemote){
		profManager = (ProfessorManagerBeanRemote) objectStateful;
		profManager.resetState(); 
	}
	else{ %>
		<jsp:forward page="../../errorPage.jsp">
			<jsp:param value="login is required" name="message"/>
		</jsp:forward>
	
	<% }%>

	<div class="form projectList">
		<div class="projectListTitle formTitle">
   			<label class="projectListTitle">YOUR PROJECTS</label>
   		</div>	
		<%	
			try{
			List<String> projectNames = profManager.getListOfProjectKeys();
			String currentProject = null;
			for(int i=0; i<projectNames.size(); i++){ 
				currentProject = projectNames.get(i);
				
			if(i%2 == 0){
				out.println("<h2 class=\"projectListItem oddItem\">");
			}else{
				out.println("<h2 class=\"projectListItem evenItem\">");
			}
			%>
				<a class="listItemLink" href="profProjectArea.jsp?projectName=<%if(currentProject != null) out.print(currentProject);%>"> <%=currentProject%> </a>
			</h2>
		
			<%
			}
	
				
			}catch(NotLoggedInException e){
				response.sendRedirect("../errorPage.jsp?message=login is needed");
				return;
			}
	%>
	</div>
	<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectList">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In this page you have the list of your projects to which you can access. <br/>
				You can also create a new project, change you password.
			</a>
		</div>
	
	</div>
	<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->

</body>
</html>