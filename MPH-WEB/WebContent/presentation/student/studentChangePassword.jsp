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
	
	<title>Student Change Password</title>
	
</head>
	
	<body>
		
		
		<div id="header">
			<div>
			<a href="studentProjectList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			Student Area
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<li>
				<a href="../../controller/controllerLogin.jsp?action=studentLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
		
		<div id="indexForms">
		
			<form id="changePasswordForm" method="post" action="../../controller/controllerStudent.jsp?action=changePassword" class="form">
    			<div class="form" id="changePasswordForm">
   					<div class="formTitle">
   					<label class="formTitle" id="adminLoginForm">Administrator login</label>
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
        	 					
	   				<input type="submit" class="confirmButton alone" id="" name="registrationDataConfirmation" value="Submit">
						
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
		
		</div>
	</body>
</html>