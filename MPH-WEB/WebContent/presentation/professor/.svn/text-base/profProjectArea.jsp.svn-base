<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="exceptions.NotValidProjectException"%>
<%@ page import="exceptions.NotLoggedInException"%>
<%@ page import="java.util.List,java.util.ArrayList,java.util.Date,java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@ page import="entityBeans.Deadline"%>
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

     if(hh==180)
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
<title>Project Area</title>
</head>
<body>
<%
	ProfessorManagerBeanRemote profManager = null;
	String projectName = request.getParameter("projectName");
	Object objectStateful = session.getAttribute("statefulBean");
	if((projectName == null || projectName.isEmpty()) && objectStateful != null && objectStateful instanceof ProfessorManagerBeanRemote)
		projectName = ((ProfessorManagerBeanRemote)objectStateful).getProject().getName();
	
	if (projectName != null && !projectName.isEmpty() && objectStateful != null && 
			objectStateful instanceof ProfessorManagerBeanRemote){
		try{
			profManager = (ProfessorManagerBeanRemote) objectStateful;
			// initialize current project
			profManager.enterProjectArea(projectName); 
			
			Deadline firstDeadline = profManager.getDeadlines().get(0);
			Date now = new Date();
			
			// check if first deadline has expired, and in this case create the group for alone registered students 
			if(now.after(firstDeadline.getKey().getDate())){
				profManager.ensureAllStudentsInAGroup();
			}
						
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
			<%=projectName %>
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<li>
				<a href="groupList.jsp" class="topLandmark">Groups</a>
				</li>
				<li>
				<a href="enableVisibility.jsp" class="topLandmark">Visibility</a>
				</li>
				<li>
				<a href="professorProjectsList.jsp" class="topLandmark">Your Projects</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=professorLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
		
	<div class="list" >
	<div class="listTitle">
	<label class="listTitle">DEADLINES</label>	
	</div>
	
	<% 
	List<Deadline> deadlines = profManager.getDeadlines();
	Deadline deadline;
	DateFormat format = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
	
	for(int i = 0; i < deadlines.size(); i++){
		deadline = deadlines.get(i);
		%>
		<div class="listItem">
		<%=i+1 %> <span class="listItem"><%=deadline.getName() %>  </span>
		 date: <span class="listItem"><%=format.format(deadline.getKey().getDate()) %>  </span>
		</div>
	<%
	}
	%>
	
	</div>
<div class="form">
	<div class="listTitle">
	<label class="listTitle">DOCUMENTS BY DEADLINE</label>
	</div>
	<div class="listItem">
	You can view the whole documents of a certain deadline:
	</div>
	<div class="listItem">
	<form class="form" action="documentByType.jsp" method="post">
		
		<select name="deadlineDate">
			<%for(int i = 0; i < deadlines.size(); i++){
				deadline = deadlines.get(i);
				%>
				
				<option value="<%=deadline.getKey().getDate() %>"> <%=deadline.getName()%></option>
				<%
				}%>
		</select>
		
 		<input type="submit" name="button" value="view documents" />
	</form>
	</div>
</div>
	
	
<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectArea">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In this page you have the list of deadlines of this project. 
				From this page you can select various links.<br/>
				You can choose to view the documents uploaded so far by the groups, filtered by a particular deadline.<br/>
				"Groups" brings you to the list of groups registered to the project. <br/>
				The link "visibility" gives you the possibility to build up a relation of visibility of documents from a 
				group towards another.<br/>
				
				Finally, you can also delete a project: after this operation the project won't exist anymore, both for 
				registered students (and their groups) and you.
			</a>
		</div>
		</div>
	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
	
	
	<a id="deletion" href="deleteProject.html">DELETE PROJECT</a></br>
		
</body>
</html>