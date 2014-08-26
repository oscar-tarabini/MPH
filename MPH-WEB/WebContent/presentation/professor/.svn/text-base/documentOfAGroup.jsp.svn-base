<%@page import="exceptions.NotValidGroupException"%>
<%@page import="exceptions.NotValidProjectException"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="exceptions.NotLoggedInException"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="java.util.List,java.util.ArrayList,java.util.Date,java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@ page import="entityBeans.Deadline"%>
<%@ page import="entityBeans.Group"%>
<%@ page import="entityBeans.Student"%>
<%@ page import="entityBeans.DeadlineScore"%>
<%@ page import="entityBeans.GroupDocument"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<title>Document of 1 Group</title>
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
		if(groupId == 0)
			groupId = profManager.getCurrentGroup().getGroupID();
		
		profManager.enterGroupPage(groupId); 
		
		List<Deadline> deadlines = profManager.getDeadlines();
		Deadline deadline;
		DateFormat format = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
		
		Group group = profManager.getCurrentGroup();
		
		%>
		<div id="header">
			<div>
			<a href="professorProjectsList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=profManager.getProject().getName() %> - <%=group.getName()%>
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
		boolean definitive = group.isDefinitive();
		
		System.out.println(definitive);
		// documents
		List<GroupDocument> documents = profManager.getDocumentsOfAGroup();
		if(documents == null)
			documents = new ArrayList<GroupDocument>();
		
		for(int j = 0; j < group.getStudents().size(); j++){
			String studentEmail = group.getStudents().get(j);
			Student student = profManager.getStudent(studentEmail);
			%>
			<div class="listItem">(<%=j+1 %>)<label class="listItem"> <%=student.getStudentID()%> <%=student.getLastName()%> <%=student.getFirstName()%> </label><%=student.getEmail()%></div>
			<%
		} // end for on students of a group
	
	
		if(definitive){
			%>
			<div id="message" class="listItem">EVALUATED!</div>
			<br/>
			<div class="listItem">The final evaluation of these group can be seen in the proper link "final evaluation" from group list page</div>
			<%
		}

		String message = request.getParameter("message");
		if(message != null) { %>
			<div class="listItem" id="errorMessage"> 
			Attention!: 
			<%=message %></div> <%} 
		%>
		
		<%
		for(int i=0; i<deadlines.size(); i++){
			deadline = deadlines.get(i);
			%>
			<div class="list">
			
			<div class="listTitle">
			<label class="listTitle"><span class="listTitle">deadline <%=i+1 %> : <%=deadline.getName() %></span>  expiring date: <%=format.format(deadline.getKey().getDate()) %> </label>
			</div>
		<%
		
			
			// evaluation
			if(!definitive){
				DeadlineScore deadScore = profManager.getDeadlineScoreOfAGroup(deadline.getKey().getDate().toString());
				System.out.println(deadScore);
				if(deadScore != null){
					int score = deadScore.getScoreNoPenalty();
					%>
					<div class="listItem">current evaluation: <%if(score != 0){ out.println(score);}else{ out.println("<span>not yet evaluated</span>");} %> .You can enter a new evaluation</div>
					<%
				
				%>
			 	<div class="listItem">evaluate:
			 	<form method="post" action="../../controller/controllerProf.jsp?action=tmpEvaluate" class="form">
			 	
			 		<input type="hidden" name="deadDate" value="<%=deadline.getKey().getDate()%>"/>
			 		<input type="text" size="2" name="score"/>score
	        	 	<input type="submit" class=""  name="confirm" value="Confirm evaluation">
			 	
			 	</form>
			 	</div>
				<%
				}else{
					%>
				
					<div class="listItem">no document has been uploaded so far for this deadline</div>
					
					<%
					
				}
			}
			
			//deadline documents
			
			for(int j=0; j < documents.size(); j++){
				if(documents.get(j).getDeadlineDate().equals(deadline.getKey().getDate())){
					%>
					<div class="listItem">download 
						<a href="../../controller/controllerUploadDownload.jsp?action=downloadGroupDocument&professor=yes&fileId=<%=documents.get(j).getDocumentID()%>">
						<%=documents.get(j).getName() %></a>  
					</div>
					<%
				}
			}
			%>
			</div>
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
				Here is the list of documents uploaded so far by this group. You can download them and you can
				also insert a temporal evaluation if this group has not yet received a final evaluation. The 
				final evaluation can be entered only after the project closure date. A link will appear when you 
				can enter the final evaluation in the group list page.
			</a>
		</div>
	</div>	
	<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->

</body>
</html>