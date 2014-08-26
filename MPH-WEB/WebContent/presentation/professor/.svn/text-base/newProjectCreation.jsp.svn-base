<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content=""/>
<meta name="description" content="New project creation - first phase" />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<title>New Project</title>


</head>
<body>

		<div id="header">
			<div>
			<a href="professorProjectsList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel newProject">
			New Project Creation
			</label>
			</div>
		</div>

<%	String canUpload = request.getParameter("canUpload");
	String errorMessage = request.getParameter("error");
		
	if(canUpload == null) { %>
	<div>
		<form id="nameOfProject" method="post" action="../../controller/controllerProf.jsp?action=checkProjectKeyENumDead" class="form">
  			<div class="form">
   					<div class="formTitle">
   					<label class="formTitle" id="adminLoginForm">Phase I</label>
   					</div>
   					
	   				<div class="formVoice">
	   				Name of Project
	   				<br>
	   				<input class="longInput" type="text" name="projectName"></input>
   					</div>
        	 			<br>
         				
         			<div class="formVoice">
	   				Number of Deadlines
	   				<br>
	   				<input class="shortInput" type="text" name="numDeadline"></input>
   					<input type="submit" class="confirmButton" value="Confirm"></input>
   					</div>
  
  				</div>

		</form>
		<%if(errorMessage != null){
			%>
			<p class="error message"> <%=errorMessage %></p>
		<%} %>



	<%}else if (canUpload.equals("ok")){ 
	String projectName = request.getParameter("projectName");
	String numDeadline = request.getParameter("numDeadline");
	%>
	<div>	
<form id="projectDetailsForm" action="../../controller/controllerUploadDownload.jsp?action=uploadOverview"
  method="post" enctype="multipart/form-data">
	
	<div class="form" id="projectDetailsForm">
   					<div class="formTitle">
   					<label class="formTitle">Phase II</label>
   					</div>
   					
   					<%if(projectName != null) {%>
			     	<div class="formVoice"> Project in creation:
	   				<br>
	   				<label class="projectName"><%=projectName %></label>
					<%} %>
   					</div>
        	 			<br>
         				
         			<div class="formVoice">
	   				Select the overview document of the project:
	   				<br>
	   				<input class="confirmButton" id="uploadButton" type="file" name="file" />
   					</div>
  					<input type="hidden" name="projectName" value="<%if(projectName != null) out.print(projectName); %>"></input>
				  <input type="hidden" name="numDeadline" value="<%if(numDeadline != null) out.print(numDeadline); %>"></input>
				 
				  <input class="confirmButton projectDetails" type="submit" name="button" value="upload" />
  					
  				</div>
  				
</form>


<% } %>

<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="newProjectCreation">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In order to create a new project, enter the name of project (the system checks if another project with the same name already exists, in this case you 
				have to chose another name) and the number of deadlines of the project (at least one deadline is required).
				After confirmation, proceed with the upload of document that explains and details the project, which will be downloaded by registered students.
			</a>
		</div>
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
</div>
</div>
</body>
</html>