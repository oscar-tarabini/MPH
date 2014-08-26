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
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<title>Final evaluation</title>
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
<% 

try{
	int groupId = 0;
	
	if(request.getParameter("groupId") != null && !request.getParameter("groupId").isEmpty())
		groupId = Integer.parseInt(request.getParameter("groupId"));
	if(groupId == 0 && profManager.getCurrentGroup().getGroupID() != 0)
		groupId = profManager.getCurrentGroup().getGroupID();
	// in case groupId is not passed as paremeter, there will be exception in the following statement
	profManager.enterGroupPage(groupId); 
	
	%>
	<div id="header">
			<div>
			<a href="professorProjectsList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=profManager.getProject().getName() %> - FINAL EVALUATION - <%=profManager.getCurrentGroup().getName()%>
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<li>
				<a href="profProjectArea.jsp" class="topLandmark">Project Area</a>
				</li>
				<li>
				<a href="groupList.jsp" class="topLandmark">Groups</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=professorLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
	
	<%
	Date now = new Date();
	if(now.before(profManager.getProject().getClosureDate())){
		%>
		<div class="listItem" id="message" > YOU CANNOT ENTER FINAL EVALUATIONS AS THE CLOSURE DATE OF PROJECT HAS NOT EXPIRED YET </div>
		<%
		return;
	}
	List<Deadline> deadlines = profManager.getDeadlines();
	Deadline deadline;
	DateFormat format = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
	
	Group group = profManager.getCurrentGroup();
	boolean definitive = group.isDefinitive();
	
	for(int j = 0; j < group.getStudents().size(); j++){
		String studentEmail = group.getStudents().get(j);
		Student student = profManager.getStudent(studentEmail);
		%>
		<div class="listItem"><%=j+1 %>)  <span="listItem"> <%=student.getStudentID()%> <%=student.getLastName()%> <%=student.getFirstName()%> </span><%=student.getEmail()%> </div>
		<%
	} // end for on students of a group
	
	String message = request.getParameter("message");
	if(message != null) { %>
		<div id="errorMessage"> 
		Attention!: 
		<%=message %> </div><%} 
	
	
	if(!definitive){ //open a form to insert scores for each deadline
		%>
		
		<form method="post" action="../../controller/controllerProf.jsp?action=finalEvaluationToConfirm" class="form">
		<%
	}
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
			int score = deadScore.getScoreNoPenalty();
			if(!definitive){
				// create page to enter final evaluations
							
				%>
				<div class="listItem">current evaluation: <%if(score != 0){ out.println(score);}else{ out.println("<span class=\"listItem\">not yet evaluated</span>");} %> </div>
				<div class="listItem">score<input type="text" size ="2" name="<%=deadline.getKey().getDate()%>" value="<%if(score != 0) out.print(score);%>"/></div>
			 	
			 	<%
		
			}else{
				%>
				<div class="listItem">FINAL EVALUATION: <span class="listItem"> <%=score %> </span></div>
					<div class="listItem">PENALTY FOR LATE DELIVERY:<span class="listItem"> <%=deadScore.getPenalty() %></span> <%if(deadScore.getPenalty() == 0) out.print(" DELIVERED IN TIME!"); %></div>
				 <%
			}
		}
		
		%>
		</div>
		<%
	}// end for on deadline

	if(!definitive){ // close form of insertion of score
		%>
		<br/>
		<div class="listItem">
		<input type="submit" class=""  name="confirm" value="Confirm FINAL EVALUATION">
		</div>
		</form>
		<%
	}
	if(definitive){
		%>
		<div class="listItem"><span class="listItem">TOTAL FINAL EVALUATION: <%=profManager.getCurrentGroup().getFinalScore() %></span> </div> 
		<%
	}
	
}catch(NumberFormatException e){
	response.sendRedirect("../../errorPage.jsp?message=invalid group identifier");	
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
				You can enter an evaluation between 1 and 10 for each deadline with at least an uploaded document
				of this group. Confirm when you are sure.<br/>
				If you have already inserted a final evaluation, you can only see it, without the possibility to change it.
			</a>
		</div>
	</div>	
	<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
</body>
</html>