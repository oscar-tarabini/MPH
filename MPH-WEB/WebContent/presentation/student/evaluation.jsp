<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<%@ page import="entityBeans.Deadline"%>
<%@ page import="entityBeans.DeadlineScore"%>
<%@page import="exceptions.NotValidProjectException"%>
<%@page import="exceptions.NotLoggedInException"%>
<%@page import="exceptions.NotValidGroupException"%>
<%@ page import="java.util.List,java.util.ArrayList,java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@ page import="entityBeans.Group"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
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
</SCRIPT>
<title>Evaluations</title>
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

<!-- HEADER -->
<div id="header">
			<div>
			<a href="studentProjectList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=studManager.getProject().getName() %> - Evaluations
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

<% 	List<Deadline> deadlines = null;
	Group group = null;
	String projectName = null;
	try{
		group = studManager.getGroup();
		deadlines= studManager.getDeadlines();
		projectName = studManager.getProject().getName();
	}catch(NotLoggedInException e){
		response.sendRedirect("../../errorPage.jsp?message=login is required");
		return;
	}catch(NotValidProjectException e2){
		response.sendRedirect("../../errorPage.jsp?message=project not valid");
		return;
	}catch(NotValidGroupException e3){
		response.sendRedirect("../../errorPage.jsp?message=group not valid");
		return;
	}

	%>
	<div class="list">
		<div class="listTitle">
			<label class="listTitle">Evaluations</label>	
		</div>
		<div class="listItem">
			Project: <span class="listItem"><%=projectName %></span>
		</div>
	<%
	DateFormat format = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
	Deadline deadline = null;
	for(int i = 0; i < deadlines.size(); i++){
		deadline = deadlines.get(i);
		DeadlineScore deadlineScore = null;
		try{
			deadlineScore = studManager.getDeadlineScore(deadline.getKey().getDate());
		}catch(Exception e){
			e.printStackTrace();
		}
		%>
		<div class="listItem">
		Deadline: <span class="listItem"><%=deadline.getName() %></span>
		</div>
		<div class="listItem">
		Expiring date: <span class="listItem"><%=format.format(deadline.getKey().getDate()) %></span>
		</div>
		<% if(deadlineScore == null || ( deadlineScore.getScoreNoPenalty() == -1 && !group.isDefinitive())){ %>
		<div class="listItem">
			Gross score: <span class="listItem">not yet evaluated</span>
		</div>
		<% }else{ 
				if( deadlineScore.getScoreNoPenalty() == -1){
					%>
					<div class="listItem">
						Gross score: <span class="listItem">1</span>
					</div>
					<%
				}else{
					%>
					<div class="listItem">
						Gross score: <span class="listItem"><%=deadlineScore.getScoreNoPenalty() %></span>
					</div>
					<%
				} %>
				<div class="listItem">
					Penalty for late delivery: <span class="listItem"> 
										<%if(group.isDefinitive()){
												out.print(deadlineScore.getPenalty());
										}else if(!group.isDefinitive()){ 
											out.print("not yet calculated, visible only after  project closure date");
										}%>
					</span>
				</div>
		<%}
	}
	if(group.isDefinitive()){
	%>	
		<div class="listItem">
			FINAL TOTAL SCORE: <span class="listItem"><%=group.getFinalScore() %>/10</span>
		</div>
   <%} %>
   </div>
   
   <!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="studentProjectArea">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In this page you can view the evaluation for your document given by the professor.<br/>
				Moreover if the project closure date has expired and the professor has confirmed the final
				evaluation for your group, you can view your final score, computed subtracting the penalties 
				for late delivery.  
			</a>
		</div>
		</div>
	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
   
</body>
</html>