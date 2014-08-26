<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="keywords" content=""/>
	<meta name="description" content="Login and registration page to the MPH web application" /> 
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
	<link type="text/css" rel="stylesheet" href="presentation/css/MPH.css"/>
	
	<title>Index - Login or register to MPH web application service</title>
	
</head>
	
	<body class="index">
		
		
		<div id="header">
			<a href="index.jsp">
				<img id="logo" src="presentation/images/MPHlogo1.png" alt="Logo MPH">
			</a>
			
			<a href="presentation/administrator/loginAdminPage.html" id="adminLoginLink">
			admin
			</a>
		</div>
		
		
		<div id="indexForms">
		
			<div id="messageContainer">
			<form id="loginForm" method="post" action="controller/controllerLogin.jsp?action=userLogin" class="form">
    			<div class="form">
   					<div class="formTitle">

   					<label class="formTitle" id="adminLoginForm">USER LOGIN</label>
   					</div>
	   				<div class="formVoice">
	   				Username
	   				<br>
	   				<input id="usernameLogin" type="text" name="username" value="" class="longInput"/>
   					</div>
        	 		<br>
         						
	         		<div class="formVoice">
   					Password
   					<br>
   					<input id="passwordLogin" type="password" name="password" value="" class="shortInput"/>

	   				<input type="submit" class="confirmButton" id="" name="loginDataConfirmation" value="Confirm">
   					</div>
						
				</div>
			</form>
			<br>
			<%String message = request.getParameter("message");
					if(message != null) { %>
			<p id="indexMessage"> 
			<%=message%>				
		    </p>
		    <%
			}
			%>
			</div>
		
			<form id="registrationForm" method="post" action="controller/controllerStudent.jsp?action=registration" class="form">
    			<div class="form" id="registrationForm">
   					<div class="formTitle">

   					<label class="formTitle" id="adminLoginForm">NEW USER REGISTRATION</label>
   					</div>
	   				<div class="formVoice">
	   				e-Mail
	   				<br>
	   				<input id="emailReg" type="text" name="email" value="" class="longInput"/>
   					</div>
        	 		<br>
         			
         			<div class="formVoice">
	   				First Name
	   				<br>
	   				<input id="firstNameReg" type="text" name="firstName" value="" class="longInput"/>
   					</div>
        	 		<br>
        	 		
        	 		<div class="formVoice">
	   				Last Name
	   				<br>
	   				<input id="lastNameReg" type="text" name="lastName" value="" class="longInput"/>
   					</div>
        	 		<br>
        	 					
	         		<div class="formVoice">
   					Student ID
   					<br>
   					<input id="idReg" type="text" name="studentID" value="" class="shortInput"/>

	   				<input type="submit" class="confirmButton" id="" name="registrationDataConfirmation" value="Register">
   					</div>
						
				</div>
			</form>
		
		</div>
	
	</body>
</html>