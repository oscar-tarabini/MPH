<%@page import="java.util.ArrayList"%>
<%@page import="exceptions.ProfessorCreationException"%>
<%@page import="exceptions.WrongParameterException"%>
<%@page import="exceptions.NotLoggedInException"%>
<%@ page import="sessionBeans.stateless.UserManagerBeanRemote"%>
<%@page import="sessionBeans.stateful.AdministratorManagerBeanRemote"%>
<%@ page import="javax.naming.*, javax.rmi.PortableRemoteObject, Test.*, java.util.Properties, java.util.Scanner, java.util.ArrayList, java.util.List" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%!
private AdministratorManagerBeanRemote getAdministratorManager(HttpSession session) throws NotLoggedInException {
	if (session.getAttribute("statefulBean") != null &&
			session.getAttribute("statefulBean") instanceof AdministratorManagerBeanRemote) { 
		return (AdministratorManagerBeanRemote) session.getAttribute("statefulBean");
	} else {
		throw new NotLoggedInException();
	}
}
%>

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
private void forwardToAdminPageWithMessage(String message, HttpServletResponse response) throws Exception {
	response.sendRedirect("../presentation/administrator/adminPage.jsp?message=" + message);
}
%>

<%
String action = request.getParameter("action");
if (action == null) {
	forwardToAdminPageWithMessage("Error in the creation/deletion of a new professor account (request == null)", response);
	System.out.println("action == null");
} else if (action.equals("createProfessor")) {
	String email = request.getParameter("email");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String professorID = request.getParameter("professorID");
	try {
		getAdministratorManager(session).registerProfessor(email, firstName, lastName, professorID);
		forwardToAdminPageWithMessage("Registration completed, the new professor account is now available", response);
	} catch (ProfessorCreationException e) {
		forwardToAdminPageWithMessage("Error in the creation of a new professor account : "+ e.getMessage(), response);
	}catch (NotLoggedInException e) {
		forwardToAdminPageWithMessage("You are not logged in, your session is out of date", response);
	}
}else if(action.equals("deleteProfessor")){
	String email = request.getParameter("professorUsername");
	try {
		getAdministratorManager(session).deleteProfessor(email);
		forwardToAdminPageWithMessage("Professor deleted", response);
	} catch (WrongParameterException e) {
		forwardToAdminPageWithMessage("Error in the deletion, no professor account has been found with this username", response);
	}catch (NotLoggedInException e) {
		forwardToAdminPageWithMessage("You are not logged in, your session is out of date", response);
	}
} else if(action.equals("setup")) {
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String domainsString = request.getParameter("domains");
	if (username == null || password == null) {
		response.sendRedirect("../presentation/administrator/configuration.jsp?message=error in the parameters");
		return;
	}
	List<String> domains = new ArrayList<String>();
	if (domainsString != null) {
		Scanner scanner = new Scanner(domainsString);
		scanner.useDelimiter(",");
		while (scanner.hasNext()) {
			String domain = scanner.next();
			domain = domain.replaceAll("(\\r|\\n)", "");
			domain = domain.trim();
			if(!domain.contains("@") || !domain.contains(".")) {
				response.sendRedirect("../presentation/administrator/configuration.jsp?message=insert valid domains separated by commas");
				return;
			}
			domains.add(domain);
		}
	}
	UserManagerBeanRemote userManager = getUserManager(getInitialContext());
	if (userManager == null) {
		response.sendRedirect("../presentation/administrator/configuration.jsp?message=error in retrieving the session bean");
		return;
	}
	try {
		userManager.setupAdministrator(username, password, domains);
	} catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect("../presentation/administrator/configuration.jsp?message=error in saving the configuration");
		return;
	}
	response.sendRedirect("../presentation/administrator/configuration.jsp?message=configuration completed");
	return;
}
%>