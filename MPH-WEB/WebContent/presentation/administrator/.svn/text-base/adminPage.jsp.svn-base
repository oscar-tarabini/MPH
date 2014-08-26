<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="keywords" content=""/>
	<meta name="description" content="administrator private area for the MPH web application" /> 
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
	<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
	<SCRIPT TYPE="text/javascript">
 
var hh=0;
var inter;
 
//we show the box by setting the visibility of the element and incrementing the height smoothly
function ShowBox()
{
 
//Depending on the amount of text, set the maximum height here in pixels
//NB: Qua bisogna cambiare l'altezza delle istruzioni!!!

     if(hh==90)
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
</SCRIPT>
	<title>MPH administrator private area</title>
	
</head>
	
	<body>
		
		
		<div id="header">
			<a href="../../index.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			
			<span id="administratorAreaLabel" class="large">
			Administrator Area
			</span>
		</div>
		
		<div id="indexForms">
		
			<form id="registrationForm" method="post" action="../../controller/controllerAdmin.jsp?action=createProfessor" class="form">
    			<div class="form" id="registrationForm">
   					<div class="formTitle">
   					<label class="formTitle" id="adminLoginForm">Create professor account</label>
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
   					Professor ID
   					<br>
   					<input id="idReg" type="text" name="professorID" value="" class="shortInput"/>

	   				<input type="submit" class="confirmButton" id="" name="registrationDataConfirmation" value="Register">
   					</div>
						
				</div>
			</form>
			
			<form id="profDeletionForm" method="post" action="../../controller/controllerAdmin.jsp?action=deleteProfessor" class="form">
    			<div id="profDeletionForm" class="form">
   					<div class="formTitle">
   					<label class="formTitle" id="adminLoginForm">Delete professor account</label>
   					</div>
         						
	         		<div class="formVoice">
   					Username
   					<br>
   					<input id="professorUsername" type="text" name="professorUsername" value="" class="shortInput"/>

	   				<input type="submit" class="confirmButton" id="" name="loginDataConfirmation" value="Confirm" onclick="return confirm('Are you sure you want to delete the professor account?')">
   					</div>
						
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
	<a href="../../controller/controllerLogin.jsp?action=adminLogout" class="logoutLink">Logout</a>
	
	<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
			<div id="instructionsContainer" class="studentProjectArea">
				<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
				<div id="cover">
					<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
						In this page the administrator can manage all the professor's profiles creating and deleting them. Every professor account has to be created in this way, no other option is possible. All the data both for professor creation and professor deletion for are mandatory. Every kind of error or invalid input will be underlined by a message in the right part of the screen. The professor username and email are considered the same thing, there's no distinction between the two. Finally it is possible to logout from the application by clicking the link on the bottom. 
					</a>
				</div>
			</div>
			<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
	</body>
</html>