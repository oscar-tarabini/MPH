<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%@page import="exceptions.WrongParameterException"%>
<%@ page import="sessionBeans.stateless.UserManagerBeanRemote"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<%@ page import="sessionBeans.stateful.AdministratorManagerBeanRemote"%>
<%@ page import="entityBeans.Student"%>
<%@ page import="entityBeans.Professor"%>
<%@ page import="entityBeans.Administrator"%>
<%@ page import="exceptions.LoginFailException"%>
<%@ page import="javax.naming.*, javax.rmi.PortableRemoteObject, java.util.Properties" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
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
UserManagerBeanRemote userManager = getUserManager(getInitialContext());
if (userManager == null) {
	response.sendRedirect("configuration.jsp?message= error in retrieving the session bean");
}
if (!userManager.hasAdminConfiguredHisAccount()) {
%>

<form id="loginForm" method="post" action="../../controller/controllerAdmin.jsp?action=setup" class="form">
ADMIN LOGIN CONFIGURATION <br>
Username <br> 
<input id="usernameLogin" type="text" name="username" value="" class="longInput" /> <br>
Password <br> 
<input id="passwordLogin" type="password" name="password" value="" class="shortInput" /> <br><br>
ACCEPTED EMAIL DOMAINS (comma separeted list, leave empty if you want to allow every domain) <br>
<input id="usernameLogin" type="text" name="domains" value="" class="longInput" />  <br><br>
<input type="submit" class="confirmButton" id="" name="setupDataConfirmation" value="Confirm"><br>
</form>
	<br>

<%} else {
	out.println("System configured. If needed edit the database");
}%>

	<%
		String message = request.getParameter("message");
		if (message != null) {
	%>
	<p id="indexMessage">
		<%=message%>
	</p>
	<%
		}
	%>

</body>
</html>