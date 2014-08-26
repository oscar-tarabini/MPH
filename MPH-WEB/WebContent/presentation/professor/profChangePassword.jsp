<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="keywords" content=""/>
	<meta name="description" content="student's private area for changing the password" /> 
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
	<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
	<script type="text/javascript" src="../../helpTextFunction.js"></script>
	
	<title>Professor Change Password</title>
	
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
				<a href="professorProjectsList.jsp" class="topLandmark">Your Projects</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=professorLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
		
		<div id="indexForms">
		
			<form id="changePasswordForm" method="post" action="../../controller/controllerProf.jsp?action=changePassword" class="form">
    			<div class="form" id="changePasswordForm">
   					<div class="formTitle">
   					<label class="formTitle" id="adminLoginForm">Change password</label>
   					</div>
	   				<div class="formVoice">
	   				Old Password
	   				<br>
	   				<input id="oldPassword" type="password" name="oldPassword" value="" class="longInput"/>
   					</div>
        	 		<br>
         			
         			<div class="formVoice">
	   				New Password
	   				<br>
	   				<input id="newPassword" type="password" name="newPassword" value="" class="longInput"/>
   					</div>
        	 		<br>
        	 		
        	 		<div class="formVoice">
	   				Confirm New Password
	   				<br>
	   				<input id="confirmNewPassword" type="password" name="confirmNewPassword" value="" class="longInput"/>
   					</div>
        	 		<br>
        	 					
	   				<input type="submit" class="confirmButton alone" id="" name="changePasswordConfirmation" value="Submit">
						
				</div>
			</form>
			
			<div id="messageContainer">
		   		<%String message = request.getParameter("message");
					if(message != null) {%>
					<p id='indexMessage' class='adminMessages'>
					<%=message%>
					</p>
					<% } %>
			</div>
			
	<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectList">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				You can change your password, by inserting the current password and by writing twice the new password you would like to have.	
			</a>
		</div>
	</div>
	<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
		
		
	
	</body>
</html>