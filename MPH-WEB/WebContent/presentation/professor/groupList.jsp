<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="exceptions.NotValidProjectException"%>
<%@ page import="exceptions.NotLoggedInException"%>
<%@ page import="java.util.List,java.util.Date,java.sql.Timestamp"%>
<%@ page import="entityBeans.Group"%>
<%@ page import="entityBeans.Project"%>
<%@ page import="entityBeans.Student"%>
<%@ page import="entityBeans.Deadline"%>
<%@ page import="sessionBeans.stateless.UserManagerBeanRemote"%>
<%@ page import="javax.naming.*, javax.rmi.PortableRemoteObject, java.util.Properties" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<script type="text/javascript" src="../../helpTextFunction.js"></script>
<title>Groups</title>
</head>
<body>

<%! 
private Context getInitialContext() {
	Properties env = new Properties();
	env.put(Context.INITIAL_CONTEXT_FACTORY, "org.jnp.interfaces.NamingContextFactory");
	env.put(Context.PROVIDER_URL, "localhost:1099");
	Context ctx = null;
	try {
		ctx = new InitialContext(env);
	} catch (NamingException e) {
		e.printStackTrace();
	}
	return ctx;
}
%>

<%!
private UserManagerBeanRemote getUserManager(Context ctx) {
	Object object = null;
	try {		
		object = ctx.lookup("UserManagerBean/remote");
	} catch (NamingException e) {
		e.printStackTrace();
	}
	System.out.println(object);
	return (UserManagerBeanRemote) object;
}
%>

<%
	ProfessorManagerBeanRemote profManager = null;
	List<Group> allGroups = null;
	Project project = null;
	Object objectStateful = session.getAttribute("statefulBean");
	if (objectStateful != null && objectStateful instanceof ProfessorManagerBeanRemote){
		try{
			profManager = (ProfessorManagerBeanRemote) objectStateful;
			project = profManager.getProject();
			
			%>
		<div id="header">
			<div>
			<a href="professorProjectsList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=project.getName() %> - GROUPS
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<li>
				<a href="profProjectArea.jsp" class="topLandmark">Project Area</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=professorLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
			
			
			
			<%
			Date now = new Date();
			allGroups = profManager.getGroups();
						
			Timestamp closureDate = project.getClosureDate();
			boolean expired = now.after(closureDate);
			if(allGroups == null || allGroups.isEmpty()){
				out.println("<p class=\"listItem\">there is no registered group yet</p>");
			}else{
				for(int i = 0; i < allGroups.size() ; i++){
					Group group = (Group)(allGroups.get(i));
					%>
							
					<div class="list" >
					<div class="listTitle">
					<label class="listTitle">Group name - <%=group.getName()%></label>	
					</div>
						<div class="listItem compact">number of components: <span class="listItem"> <%=group.getStudents().size() %></span></div>
					<%
					if(group.getViewedGroup() != 0){
						for(Group viewedGroupToFind : allGroups){
							if(viewedGroupToFind.getGroupID() == group.getViewedGroup()){
								%>
								<div class="listItem">viewed group: <%=viewedGroupToFind.getName() %></div>
								
								<%
							}
						}
					}	
					
					for(int j = 0; j < group.getStudents().size(); j++){
						String studentEmail = group.getStudents().get(j);
						Student student = profManager.getStudent(studentEmail);
						%>
						<div class="listItem">
						<%
						UserManagerBeanRemote userManager = getUserManager(getInitialContext());
						if (userManager != null && userManager.hasUploadedPicture(studentEmail)) {%>
							<img src="../../controller/controllerUploadDownload.jsp?action=getPicture&email=<%= studentEmail %>" width=20 height=25/>
						<%} else { %>
							<img src="../images/defaultPicture.jpg" width=20 height=25/>
						<%}
						%>
						<%=j+1 %>) <span class="listItem compact"><%=student.getStudentID()%> - <%=student.getLastName()%> <%=student.getFirstName()%> </span> <%=student.getEmail()%> 
						</div>
						<%
					} // end for on students of a group
					%>
						<div class="listItem">
						<a href="documentOfAGroup.jsp?groupId=<%=group.getGroupID() %>">view its documents</a>
						</div>
					<%
										
					if(expired && !group.isDefinitive()){
						%>
						<div class="listItem compact">
						<a href="finalEvaluation.jsp?groupId=<%=group.getGroupID() %>">enter final evaluation</a>
						</div>
						<%
					}else if(expired && group.isDefinitive()){
						%>
						<div class="listItem compact">
						<a href="finalEvaluation.jsp?groupId=<%=group.getGroupID() %>">see final evaluation</a>
						</div>
						<%
					}
					
					
					%>
					</div>
					<%
									
				} // end for on groups
				
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

<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectList">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				Here you can see the list of the groups registered to this project and also their composition.<br/>
				You can select to view the uploaded documents (from that page you can also enter a temporal evaluation).
				When the project closure date has expired, also a link "final evaluation" will appear.
				After you have entered the final evaluation you won't be able to modify it and you can only "see final evaluation".
			</a>
		</div>
	</div>	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->

</body>
</html>