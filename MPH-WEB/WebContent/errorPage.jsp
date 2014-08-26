<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content=""/>
<meta name="description" content="error page" />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="../css/MPH.css"/>
<title>Error</title>
</head>
<body>

	<div id="header">
		
		<a href="../../index.jsp">
			<img id="logo" src="../images/MPHlogo1.png" alt="Logo MPH">
		</a>
		<ul class="topLandmarks">
		<li>
		<a href="../../index.jsp" class="topLandmark">
		home
		</a>
		</li>
		</ul>
	</div>
		
		
<%Object objectStateful = session.getAttribute("statefulBean");	
	if (objectStateful != null && objectStateful instanceof ProfessorManagerBeanRemote){
		((ProfessorManagerBeanRemote)objectStateful).logout();
		session.removeAttribute("statefulBean");
	}
	if (objectStateful != null && objectStateful instanceof StudentManagerBeanRemote){
		((StudentManagerBeanRemote)objectStateful).logout();
		session.removeAttribute("statefulBean");
	}

%>
		
<div id="errorPageMessage">		
<%String message = request.getParameter("message");
					if(message != null) { %>
			<p id="errorMessage"> 
			An error occurred: <br/>
			<label id="errorPageMessage">
			<%=message %> <%} %>
			</label>
			</p>
come back to <a href="index.jsp"> home page</a>
</div>
</body>
</html>