<%@page import="exceptions.NotValidProjectException"%>
<%@page import="exceptions.NotLoggedInException"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<%@ page import="java.util.List,java.util.Date"%>
<%@ page import="entityBeans.Project"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateless.UserManagerBeanRemote"%>
<%@ page import="javax.naming.*, javax.rmi.PortableRemoteObject, java.util.Properties" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content=""/>
<meta name="description" content="student's projects private area " />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<title>Your projects</title>

<SCRIPT TYPE="text/javascript">
 
var hh=0;
var inter;
 
//we show the box by setting the visibility of the element and incrementing the height smoothly
function ShowBox()
{
 
//Depending on the amount of text, set the maximum height here in pixels
//NB: Qua bisogna cambiare l'altezza delle istruzioni!!!

     if(hh==110)
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
				<a href="studentChangePassword.jsp" class="topLandmark changePasswordSelection"> Change Password</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=studentLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
		
<%
	StudentManagerBeanRemote studManager = null;
	Object objectStateful = session.getAttribute("statefulBean");
	if (objectStateful != null && objectStateful instanceof StudentManagerBeanRemote){
		studManager = (StudentManagerBeanRemote) objectStateful;
		studManager.resetState();
	}
	else{ %>
		<jsp:forward page="../../errorPage.jsp">
			<jsp:param value="login is required" name="message"/>
		</jsp:forward>
	
	<% }%>
	<div class="list">
		<div class="listItem">
	<%
		UserManagerBeanRemote userManager = getUserManager(getInitialContext());
		String username = studManager.getUsername();
		if (userManager != null && userManager.hasUploadedPicture(username)) {%>
			<img src="../../controller/controllerUploadDownload.jsp?action=getPicture&email=<%= username %>" width=50 height=50/>
		<%} else { %>
			<img src="../images/defaultPicture.jpg" width=100 height=120/>
		<%}%>
		</div>
		<div class="listItem">
			Upload new photo
			<form class="form" action="../../controller/controllerUploadDownload.jsp?action=uploadPicture" method="post" enctype="multipart/form-data">
				<input type="file" name="file"/>
				<input type="submit" name="button" value="Upload Photo"/>
			</form>
		</div>
	</div>
	<div id="studentListsContainer" class="inlineVoice">
			<div class="form projectList stud">
				<div class="projectListTitle formTitle">
		   			<label class="projectListTitle">YOUR JOINED PROJECTS</label>
		   		</div>
		<% 	
		try{
			List<Project> registeredProjects = studManager.getListOfRegisterProject();
			for(int i=0 ; i < registeredProjects.size(); i++){
				Project project = registeredProjects.get(i);
				
				if(i%2 == 0){
					out.println("<h2 class=\"projectListItem oddItem\">");
				}else{
					out.println("<h2 class=\"projectListItem evenItem\">");
				}
				%>
					<a class="listItemLink" href="studentProjectArea.jsp?projectName=<%=project.getName()%>"><%=project.getName()%></a> 
				</h2>
			<% } %>
			</div>
		
			<div class="form projectList stud">
				<div class="projectListTitle formTitle">
		   			<label class="projectListTitle">YOU CAN REGISTER TO</label>
		   		</div>
			
			<% 
			List<Project> enabledProjects = studManager.getListOfEnableButNotRegisterProject();
			for(int i=0 ; i < enabledProjects.size(); i++){
				Project project = enabledProjects.get(i);
				
				if(i%2 == 0){
					out.println("<h2 class=\"projectListItem oddItem\">");
				}else{
					out.println("<h2 class=\"projectListItem evenItem\">");
				}
				%>
					<a class="listItemLink notJoined" href="../../controller/controllerStudent.jsp?action=registerToProject&projectName=<%=project.getName()%>"><%=project.getName()%></a> 
				</h2>
			<% }
			
		}catch(NotLoggedInException e){
			response.sendRedirect("../../errorPage.jsp?message=login is required");
			return;	
		}
		%>
			</div>
	</div>
		
	<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="projectList stud">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				You can choose one of the projects you joined to reach the private area of that particular project. You can also select one of the projects for which you are enabled to enrole and join it. It's possible for you to change your password selecting the top-right link or logout from the application.  
			</a>
		</div>
	</div>
	<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->

		<%String message = request.getParameter("message");
				if(message != null) { %>
		<p id="indexMessage"> 
		<%=message%>				
		</p>
	    <%
			}
		%>
</body>
</html>