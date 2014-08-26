<%@page import="java.util.Date"%>
<%@page import="exceptions.NotValidProjectException"%>
<%@page import="exceptions.NotLoggedInException"%>
<%@ page import="java.util.List,java.util.ArrayList,java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@ page import="entityBeans.Group"%>
<%@ page import="entityBeans.GroupDocument"%>
<%@ page import="entityBeans.Deadline"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<%@ page import="java.io.IOException"%>
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

     if(hh==170)
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
<title>Project Area</title>
</head>
<body>

<%
	StudentManagerBeanRemote studManager = null;
	String projectName = request.getParameter("projectName");
	Object objectStateful = session.getAttribute("statefulBean");
	if((projectName == null || projectName.isEmpty()) && objectStateful != null && objectStateful instanceof StudentManagerBeanRemote)
		projectName = ((StudentManagerBeanRemote)objectStateful).getProject().getName();
	
	int overviewId = -1;
	boolean hasGroup = false;
	if (projectName != null && !projectName.isEmpty() && objectStateful != null && 
			objectStateful instanceof StudentManagerBeanRemote){
			studManager = (StudentManagerBeanRemote) objectStateful;
		try{
			// initialize also current group if any
			studManager.enterProjectArea(projectName); 
			overviewId = studManager.getProject().getOverviewDocument();
			hasGroup = studManager.hasAGroupInCurrentProject();
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
	
	<!-- HEADER -->
	<div id="header">
			<div>
			<a href="studentProjectList.jsp">
				<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
			</a>
			<label class="topLeftLabel">
			<%=studManager.getProject().getName() %>
			</label>
			</div>
			<br>
			<ul class="topLandmarks">
				<% if (studManager.hasAGroupInCurrentProject()) {%>
				<li>
				<a href="evaluation.jsp" class="topLandmark">Evaluations</a> 
				</li>
				<%} %>
				<%
				if (studManager.hasAGroupInCurrentProject() && studManager.hasViewedGroup()) { %>
					<li>
					<a href="documentHistory.jsp?filteredBy=all&historyOf=viewedGroup" class="topLandmark">Visible Group</a> 
					</li>
				<% }%>
				<% if(studManager.hasAGroupInCurrentProject()) { %>
				<li>
				<a href="documentHistory.jsp?filteredBy=all&historyOf=group" class="topLandmark">Documents</a> 
				</li>
				<%} %>
				<li>
				<a href="studentProjectList.jsp" class="topLandmark changePasswordSelection">Your Projects</a>
				</li>
				<li>
				<a href="../../controller/controllerLogin.jsp?action=studentLogout" class="topLandmark">Logout</a>
				</li>
			</ul>
		</div>
		
	<div class="list">
		<div class="listTitle">
			<label class="listTitle">Project</label>	
		</div>
		<div class="listItem">
			Project name: <span class=listItem><%=projectName %></span>
		</div>
		<div class="listItem">
			Project overview: <span class="listItem"><a href="../../controller/controllerUploadDownload.jsp?action=downloadOverview&fileId=<%if(overviewId != -1) out.print(overviewId); %>">Download</a></span>
		</div>
	</div>
	
	<%if(hasGroup){ //page shown if student has a group
		//deve anche settare il gruppo nello stato _ lo fa enterProjectArea
				
		Group group = null;
		try{
			group = studManager.getGroup();
		}catch(Exception e){
			e.printStackTrace();
		}
		
		%>
		
		<div class="list" >
			<div class="listTitle">
				<label class="listTitle">Your Group</label>	
			</div>
			<div class="listItem">
				Group name: <span class="listItem"><%out.print(group.getName()); %></span>
			</div>
			<div class="listItem">
				Components:
			</div>
		  	
				<%
					List<String> usernames = group.getStudents();
					for(int i=0 ; i < usernames.size(); i++){ %>
							<div class="listItem">
								<span class="listItem"><%out.print(usernames.get(i)); %></span>
							</div>
					<% } %>
			
		</div>
		
		
		
		<%
		
		
		
		/* start displaying deadlines */
				
		List<Deadline> deadlines = studManager.getDeadlines();
		GroupDocument lastDocument = null;
		Deadline deadline;
		DateFormat format = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
		
		for(int i = 0; i < deadlines.size(); i++){
			boolean thereIsLastDoc = false;
			deadline = deadlines.get(i);
			lastDocument = studManager.getLastDocument(deadline); 
			if(lastDocument != null)
				thereIsLastDoc = true;
			%>
			<div class="list">
				<div class="listTitle">
					<label class="listTitle">Deadline</label>	
				</div>
				<div class="listItem">
					Deadline name: <span class="listItem"><%=deadline.getName() %></span>
				</div>
				<div class="listItem">
					Expiring date: <span class="listItem"><%=format.format(deadline.getKey().getDate()) %></span>
				</div>
				<%if(thereIsLastDoc){ %>
				<div class="listItem">
					Last uploaded document: <span class="listItem"><%=format.format(lastDocument.getUploadDate()) %>,  by <%=lastDocument.getStudentEmail() %>
					<a href="../../controller/controllerUploadDownload.jsp?action=downloadGroupDocument&fileId=<%=lastDocument.getDocumentID() %>"> download <%=lastDocument.getName() %> </a></span>
				</div>
				<%} %>
		
				<%
				if(System.currentTimeMillis() < studManager.getProject().getClosureDate().getTime()){ %>
				<div class="listItem">
					<form class="form" action="../../controller/controllerUploadDownload.jsp?action=uploadGroupDocument"
	 			 	method="post" enctype="multipart/form-data">

	 				<input type="file" name="file" />
	  				<input type="hidden" name="projectName" value="<%=deadline.getKey().getProject() %>" /> 
	  			 	<input type="hidden" name="deadlineDate" value="<%=deadline.getKey().getDate() %>" /> 
	  				<input type="hidden" name="groupID" value="<%=group.getGroupID() %>" /> 
	  				<input type="hidden" name="lastDoc" value="<% if(thereIsLastDoc) out.print(lastDocument.getName()); %>" />
			  		<input type="submit" name="button" value="upload" />
	  
					</form>
				</div>
			<%} %>
			</div> 
			<br>
		<%}%>
		<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="studentProjectArea">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In this page you can view your project, your group and deadlines with associated documents.<br/>
				In the "Project" section you can download the project overview document<br/>
				In the "Your Group" you can view the name and the components of your group <br/>
				In the "Deadline" sections you can view the deadline name, expiring date, last document uploaded 
				for this deadline (if any) and upload a new document for the deadline. For doing this just
				select a PDF file on your file system and click upload. <br/>
				From this page you can also reach the "evaluations" page, the "documents" page (containing all the
				history of your documents), view documents of another group (if enabled by the professor),
				returning to your project list or logging out.
				
			</a>
		</div>
		</div>
	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
	<%
	}else{  //page shown if student has to create a group
		
		//before it's necessary to check if project first deadline expired - deadlines are returned already ordered
		Deadline firstDeadline = studManager.getDeadlines().get(0); 
		Date now = new Date();
		if(now.after(firstDeadline.getKey().getDate())){
			studManager.createGroup(1, null, null, "auto-single-group-"+studManager.getUsername());
			response.sendRedirect("studentProjectArea.jsp");
		}
		
		%>
		
		<div class="list">
			<div class="listTitle">
				<label class="listTitle">Group Creation</label>	
			</div>
			<div class="listItem">
				In order to enter the project area and get all the rights to manage your project documents,
				you need to create a group
			</div>
			<div class="listItem">
				<form id="group_Creation" method="post" action="../../controller/controllerStudent.jsp?action=groupCreation" class="form">
  				<div class="formVoice">
	   				Name of the group: 
	   				<br>
	   				<input class="shortInput" type="text" name="groupName"></input>
   					</div>
  				 <br>
  				 <div class="formVoice">
	   				Number of components:  
	   				<br>
	   				<input type="radio" name="numComponents" value="1" /> 1 <br>
  					<input type="radio" name="numComponents" value="2" /> 2 <br>
  					<input type="radio" name="numComponents" value="3" /> 3 <br>
   					</div>
  					<br>
  				
  				<!-- In case of two or three components, write the e-mail (e-mails) of the other student (students) besides you.
  				Otherwise leaves blank and click "create group" <br> -->
  				<div class="formVoice">
	   				2nd e-mail:  
	   				<br>
	   				<input class="longInput" type="text" name="Component2"></input>
   					</div>
  				 <br>
  				<div class="formVoice">
	   				3th e-mail:   
	   				<br>
	   				<input class="longInput" type="text" name="Component3"></input>
   					</div>
  				 <br>
  				
 	 			<input type="submit" class="confirmButton leftButton" value="create group"></input>
				</form>
			</div>
		</div>
		
		<!-- QUA COMINCIA IL BLOCCO DELLE ISTRUZIONI -->
	<div id="instructionsContainer" class="studentProjectArea">
		<a id="instructionsTitle" href="#" onclick="inter=setInterval('ShowBox()',3);return false;">Help</a>
		<div id="cover">
			<a id="instructions" href="#" onclick="inter=setInterval('HideBox()',3);return false;">
				In this page you have to create a group in order to use all the features of MPH.<br/>
				The group can be composed of one, two or three students.<br/>
				If you want to form a group for yourself just enter a name for the group and select one component, 
				leaving blank the space for the emails. <br/>
				Instead if you want to form a group of two or three students, select the choosen components number 
				and fill the emails field with you colleagues official emails. IMPORTANT: your team mate to be have to
				be already registered into the system and not having already created a group on this project.  
				
			</a>
		</div>
		</div>
	
<!-- QUA FINISCE IL BLOCCO DELLE ISTRUZIONI -->
		
	<%}
	%>
	<%String message = request.getParameter("message");
	if(message != null) { %>
			<p id="message"></p> 
	<%out.print(message);}%>
			 
			
<br/>	
</body>
</html>