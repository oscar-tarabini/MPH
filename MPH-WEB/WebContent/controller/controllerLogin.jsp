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
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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

<%!
private AdministratorManagerBeanRemote getAdministratorManager(Context ctx) {
	Object object = null;
	try {		
		object = ctx.lookup("AdministratorManagerBean/remote");
	} catch (NamingException e) {
		e.printStackTrace();
	}
	System.out.println(object);
	return (AdministratorManagerBeanRemote) object;
}
%>

<%!
private ProfessorManagerBeanRemote getProfessorManager(Context ctx){
	Object object = null;
	try {		
		object = ctx.lookup("ProfessorManagerBean/remote");
	} catch (NamingException e) {
		e.printStackTrace();
	}
	System.out.println(object);
	return (ProfessorManagerBeanRemote) object;

}
%>

<%!
private StudentManagerBeanRemote getStudentManager(Context ctx){
	Object object = null;
	try {		
		object = ctx.lookup("StudentManagerBean/remote");
	} catch (NamingException e) {
		e.printStackTrace();
	}
	System.out.println(object);
	return (StudentManagerBeanRemote) object;

}
%>

<%! 
private void forwardToIndexWithMessage(String message, HttpServletResponse response) throws Exception {
	response.sendRedirect("../index.jsp?message=" + message);
}
%>

<%
// retrieve all possible parameters
String action = request.getParameter("action");
String confirmEraseSession = request.getParameter("confirmEraseSession");
String username = request.getParameter("username");
String password = request.getParameter("password");


Context ctx = getInitialContext();

if (action == null || action.equals("")) {
	System.out.println("action == null");
	forwardToIndexWithMessage("Error in parameter action passed to controller", response);
	return;
} else if (action.endsWith("Login")) {
	
	// check if a session already exists on that client browser
	Object anyUserSession = session.getAttribute("statefulBean");
	System.out.println(anyUserSession);
	
	if(anyUserSession != null){
		// check if the client has confermed to erase the previous session
		/*-----------------------------------------------------------
		if (confirmEraseSession != null && confirmEraseSession.equals("yes")){
			if(anyUserSession instanceof StudentManagerBeanRemote ){
				((StudentManagerBeanRemote)anyUserSession).logout();
			}
			if(anyUserSession instanceof ProfessorManagerBeanRemote ){
				((ProfessorManagerBeanRemote)anyUserSession).logout();
			}
			if(anyUserSession instanceof AdministratorManagerBeanRemote ){
				((AdministratorManagerBeanRemote)anyUserSession).logout();
			}
			session.removeAttribute("statefulBean");			
		} else if (confirmEraseSession != null && confirmEraseSession.equals("no")){
			forwardToIndexWithMessage("Another session is still active (either it is open or "+
					"it has been badly closed without logout - if you want to delete it, "+
					"and start a new one, confirm to erase session after login. \n Attention: "+
					"the other session will be lost",response);
			return;
		}
		-------------------------------------------------------*/
		

		// has not confirmed yet
		//-----------------if(confirmEraseSession == null || confirmEraseSession.isEmpty() ){
		%>
			<!--  //request.setAttribute("username", username);
			//request.setAttribute("password", password);
			//response.sendRedirect("../presentation/confirmEraseSession.jsp");
			//return;
			-->
			<jsp:forward page="../presentation/confirmEraseSession.jsp">
			<jsp:param value="<%=action %>" name="action"/>
			<jsp:param value="<%=username%>" name="username"/>
			<jsp:param value="<%=password%>" name="password"/>
			</jsp:forward>
			<%
		//---------------}
	
	}
	
	if(action.equals("userLogin")){
	
		System.out.println("session doesn't exist");	
		
		if(username == null || password == null || username.isEmpty() || password.isEmpty()){
			forwardToIndexWithMessage("username or password not valid or not inserted",response);
			return;
		}
	
		try{
			String user = getUserManager(ctx).userLogin(username, password);
			System.out.println(user);
			if(user.equals("p")){			
				ProfessorManagerBeanRemote profManager = getProfessorManager(ctx);
				profManager.login(username);
				session.setAttribute("statefulBean", profManager);
				System.out.println("e' un prof ");
				response.sendRedirect("../presentation/professor/professorProjectsList.jsp");
			}
			if(user.equals("s")){
				StudentManagerBeanRemote studManager = getStudentManager(ctx);
				studManager.login(username);
				session.setAttribute("statefulBean", studManager);
				response.sendRedirect("../presentation/student/studentProjectList.jsp");
			}
			
		} catch(LoginFailException lfe){
			response.sendRedirect(response.encodeRedirectURL("../index.jsp?message=Error - login failed. Check username and password. Lost your password? <a href=\"controller/controllerLogin.jsp%3Faction=recoverPassword%26username=" + username + "\">Click here</a>"));
			return;
		}
	} else if(action.equals("adminLogin")){
	
		//if a session already exists, it denies login
		//if(session.getAttribute("statefulBean") != null)
		//forwardToIndexWithMessage("Login denied - a session is already active",response);
						
		//String username = request.getParameter("username");
		//String password = request.getParameter("password");
	
		if(username == null || password == null || username.isEmpty() || password.isEmpty()){
			forwardToIndexWithMessage("username or password not valid or not inserted",response);
			return;
		}
		try{
			Administrator admin = getUserManager(ctx).adminLogin(username,password);
			System.out.println(admin);
			AdministratorManagerBeanRemote adminManager = getAdministratorManager(ctx);
			adminManager.login();
			session.setAttribute("statefulBean", adminManager);
			response.sendRedirect("../presentation/administrator/adminPage.jsp");
			
		} catch(LoginFailException e){
			forwardToIndexWithMessage("Error - admin login failed. Check username and password",response);
		}
	 }
} else if (action.equals("adminLogout")) {
	Object statefulBean = session.getAttribute("statefulBean");
	if(statefulBean instanceof AdministratorManagerBeanRemote) {
		((AdministratorManagerBeanRemote)statefulBean).logout();
	}
	session.removeAttribute("statefulBean");
	forwardToIndexWithMessage("Logout completed", response);
} else if (action.equals("studentLogout")) {
	Object statefulBean = session.getAttribute("statefulBean");
	if(statefulBean instanceof StudentManagerBeanRemote) {
		((StudentManagerBeanRemote)statefulBean).logout();
	}
	session.removeAttribute("statefulBean");
	forwardToIndexWithMessage("Logout completed", response);
} else if (action.equals("professorLogout")) {
	Object statefulBean = session.getAttribute("statefulBean");
	if(statefulBean instanceof ProfessorManagerBeanRemote) {
		((ProfessorManagerBeanRemote)statefulBean).logout();
	}
	session.removeAttribute("statefulBean");
	forwardToIndexWithMessage("Logout completed", response);
} else if (action.equals("recoverPassword")) {
	if (username != null) {
		try {
			getUserManager(ctx).recoverPassword(username);
			forwardToIndexWithMessage("A new password has been sent to your email", response);
		} catch (WrongParameterException e) {
			forwardToIndexWithMessage("Error in recovering the password", response);
		}
	} else {
		forwardToIndexWithMessage("Error in recovering the password", response);
	}
}

%>
</body>
</html>