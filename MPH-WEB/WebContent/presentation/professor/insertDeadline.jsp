<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.lang.Integer"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="keywords" content=""/>
	<meta name="description" content="deadline insertion page for a new project" /> 
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

     if(hh==70)
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
	
	<title>Insert the deadlines</title>
	
	<script src="datetimepicker_css.js"></script>
</head>
	
	<body>
		
		
		<div id="header">
			<a href="../../index.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
		</div>
		
		<div id="indexForms">
		
			<form id="projectDetails" method="post" action="../../controller/controllerProf.jsp?action=createProject" class="form">
    			<div class="form" id="projectDetails">
   					<div class="formTitle">
   					<label class="formTitle" id="adminLoginForm">Administrator login</label>
   					</div>
	   				
	   				<div class="inlineVoice topAligned">
	        				
	        				<%
	        				String deadlineUpdatedName = null;
						String projectName = request.getParameter("projectName");
	   					int numOfDead = Integer.parseInt(request.getParameter("numDeadline"));
  						for ( int i = 1; i <= numOfDead; i++ ) {
  							deadlineUpdatedName = "deadlineDate" + Integer.toString(i); 
        					%>
	        				
	        				<br>
		   				<div class="formVoice inlineVoice">
		   					Phase name
		   					<br>
		   					<input id="phaseName" type="text" name="deadName<%=i %>" class="longInput"/>
	   					</div>
	   					<div class="formVoice inlineVoice">
		   					Deadline date
		   					<br>
		   					<input id="<%=deadlineUpdatedName%>" type="text" name="<%=deadlineUpdatedName%>" class="date"/>
		   					<img class="calImage" src="../images/cal.gif" onclick="javascript:NewCssCal('<%=deadlineUpdatedName%>','yyyyMMdd','arrow',true,'24',true,'future')" style="cursor:pointer"/>
		   				
	   					</div>
	   					
						<% }%>
	   					
	   					<hr id="closureDateDivider">
	   					<div >
		   					<label id="closureDateLabel" class="inlineVoice">Project closure date:</label>
		   					<div class="inlineVoice">
			   					<input id="closureDate" type="text" name="closureDate" class="date"/>
		   						<img class="calImage" src="../images/cal.gif" onclick="javascript:NewCssCal('closureDate','yyyyMMdd','arrow',true,'24',true,'future')" style="cursor:pointer"/>
		   					</div>
		  
        	 				</div>
        	 			</div>	
        	 			<div id="studentsEmails" class="formVoice inlineVoice">
        	 			Enabled students' e-mails
	   					<br>
        	 			<textarea id="studentsEmails" name="studentsEmails" class=""></textarea>
        	 			</div>
        	 			<br>
        	 			<% String projName = request.getParameter("projectName"); %>
        	 			<% String numDead = request.getParameter("numDeadline"); %>
        	 			<input type="hidden" name="projectName" value="<%if(projName != null) out.print(projName); %>"/>
        	 			<input type="hidden" name="numDeadline" value="<%if(numDead != null) out.print(numDead);%>"/>
        	 			
	   				<input type="submit" class="confirmButton leftButton" id="" name="registrationDataConfirmation" value="Confirm">
   								
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
	
<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="insertDeadline">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				Enter the name of deadlines and the relative dates, than insert the closure date of project (it must follow all deadlines!)
				after which no documents can be uploaded by groups of project. Finally write the list of mail of students that can take part to the project
				in COMMA SEPARATED WAY (first@domain.x, second@domain.x, ...).	
			</a>
		</div>
	</div>
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->

	</body>
</html>