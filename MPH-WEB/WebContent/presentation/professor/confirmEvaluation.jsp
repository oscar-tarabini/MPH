<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="exceptions.NotValidGroupException"%>
<%@ page import="exceptions.NotValidProjectException"%>
<%@ page import="exceptions.NotLoggedInException"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="java.util.List,java.util.ArrayList,java.util.Date,java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@ page import="entityBeans.Deadline"%>
<%@ page import="entityBeans.Group"%>
<%@ page import="entityBeans.Student"%>
<%@ page import="entityBeans.DeadlineScore"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../presentation/css/MPH.css"/>
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<title>Confirm final evaluation</title>
</head>
<body>

<%
	ProfessorManagerBeanRemote profManager = null;
	Object objectStateful = session.getAttribute("statefulBean");
	
	if (objectStateful != null && objectStateful instanceof ProfessorManagerBeanRemote){
		profManager = (ProfessorManagerBeanRemote) objectStateful;
	}
	else{ %>
		<jsp:forward page="../../errorPage.jsp">
			<jsp:param value="login is required" name="message"/>
		</jsp:forward>
	
	<% }%>
	
	<div id="header">
			<div>
			<a href="professorProjectsList.jsp">
				<img id="logo" src="../presentation/images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=profManager.getProject().getName() %> - FINAL EVALUATION - <%=profManager.getCurrentGroup().getName()%>
			</label>
			</div>
			<br>
			<ul class="topLandmarks"> 
				<li>
				<a href="../presentation/professor/finalEvaluation.jsp" class="topLandmark">Final evaluation</a>
				</li>
				<li>
				<a href="../presentation/professor/groupList.jsp" class="topLandmark">Groups</a>
				</li>
				<li>
				<a href="controllerLogin.jsp?action=professorLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
<% 
try{
	List<Deadline> deadlines = profManager.getDeadlines();
	Deadline deadline;
	DateFormat format = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
	
	Group group = profManager.getCurrentGroup();
	boolean definitive = group.isDefinitive();
	
	if(!definitive){
		for(int j = 0; j < group.getStudents().size(); j++){
			String studentEmail = group.getStudents().get(j);
			Student student = profManager.getStudent(studentEmail);
			%>
			<div class="listItem"><%=j+1 %>)  <span="listItem"> <%=student.getStudentID()%> <%=student.getLastName()%> <%=student.getFirstName()%> </span><%=student.getEmail()%> </div>
			<%
		} // end for on students of a group
	
	
		%>
		<form method="post" action="controllerProf.jsp?action=confirmFinalEval" class="form">
		<%
		
		
		for(int i=0; i<deadlines.size(); i++){
			deadline = deadlines.get(i);
			%>
			<div class="list">
			
			<div class="listTitle">
			<label class="listTitle"><span class="listTitle">deadline : <%=deadline.getName() %></span>  expiring date: <%=format.format(deadline.getKey().getDate()) %>
			</div> 
			<%
			DeadlineScore deadScore = profManager.getDeadlineScoreOfAGroup(deadline.getKey().getDate().toString());
			
			if(deadScore == null){
				%>
				<div class="listItem">NO DOCUMENT DELIVERED FOR THIS DEADLINE - AUTOMATICALLY EVALUATED TO <span class="listItem">1</span> </div>
				<%
			
			}else{
				int score = Integer.parseInt(request.getParameter(deadline.getKey().getDate().toString()));
				profManager.evaluateDeadline(deadline.getKey().getDate().toString(), score);
				profManager.computePenalty(deadline.getKey().getDate().toString());
				int penalty = deadScore.getPenalty();
				profManager.evaluateDeadline(deadline.getKey().getDate().toString(), score);
					%>
					<div class="listItem">final evaluation:<span  class="listItem"><%=score %></span>  </div>
					<div class="listItem">PENALTY FOR LATE DELIVERY: <span  class="listItem"><%=penalty %></span></div>
					<%
							
			}
			%>
			</div>
			<% 
		}// end for on deadline
	
		int finalTotal = profManager.computeFinalScore();
	
	%>
	<div class="listItem">
	<h1>TOTAL RESULT = <%=finalTotal %></h1>
	</div>
	<div class="listItem">
	<input type="hidden" name="totalScore" value="<%=finalTotal %>"/>
	</div>
 	<%
 	
 	
	 // close form of insertion of score
	%>
	<br/>
	<div class="listItem">
	<input type="submit" class=""  name="confirm" value="Confirm FINAL EVALUATION">
	</div>
	</form>
	
	
	<br/>
	<div class="listItem">
	<a href="../presentation/professor/finalEvaluation.jsp">re-enter final evaluation</a>
	</div>
	<br/>
	<%
		
		
	}
	
	
	
				
}catch(NumberFormatException e){
	response.sendRedirect("finalEvaluation?message=invalid group identifier");	
}catch(NotLoggedInException e2){
	response.sendRedirect("../../errorPage.jsp?message=login is required");
}catch(NotValidProjectException e3){
	response.sendRedirect("../../errorPage.jsp?message=invalid project name");	
}catch(NotValidGroupException e4){
	response.sendRedirect("../../errorPage.jsp?message=invalid group identifier");
}
%>

<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectList">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				Here you can see also an eventual penalty automatically calculated by the system in case of 
				late delivery for a deadline.
				After confirmation of evaluations, there will be no possibility to modify these evaluations.
				Confirm if you are sure, otherwise come back to "final evaluation" page.
				
			</a>
		</div>
	</div>	
	<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
	
	
</body>
</html>