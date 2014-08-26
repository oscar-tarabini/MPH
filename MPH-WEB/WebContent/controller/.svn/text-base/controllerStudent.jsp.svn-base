<%@page import="exceptions.WrongParameterException"%>
<%@page import="exceptions.NotValidProjectException"%>
<%@page import="exceptions.StudentCreationException"%>
<%@page import="sessionBeans.stateless.UserManagerBeanRemote"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<%@ page import="entityBeans.Student"%>
<%@ page import="entityBeans.Project"%>
<%@ page import="exceptions.PasswordException"%>
<%@ page import="exceptions.NotLoggedInException"%>
<%@ page import="exceptions.NotValidProjectException"%>
<%@ page import="javax.naming.*, javax.rmi.PortableRemoteObject, java.util.Properties" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%!
private UserManagerBeanRemote getUserManager() {
	Properties env = new Properties();
	env.put(Context.INITIAL_CONTEXT_FACTORY, "org.jnp.interfaces.NamingContextFactory");
	env.put(Context.PROVIDER_URL, "localhost:1099");
	Object object = null;
	try {
		Context ctx = new InitialContext(env);
		object = ctx.lookup("UserManagerBean/remote");
	} catch (NamingException e) {
		e.printStackTrace();
	}
	System.out.println(object);
	return (UserManagerBeanRemote) object;
}
%>

<%!
private StudentManagerBeanRemote getStudentManager(HttpSession session, HttpServletResponse response){
	Object statefulBean = session.getAttribute("statefulBean");
	if(statefulBean != null && statefulBean instanceof StudentManagerBeanRemote) {
		return ((StudentManagerBeanRemote)statefulBean);
	} else {
		try {
		forwardToIndexWithMessage("Session expired", response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
%>

<%! 
private void forwardToIndexWithMessage(String message, HttpServletResponse response) throws Exception {
	response.sendRedirect("../index.jsp?message=" + message);
}
%>

<%
//retrieve all possible parameters
String action = request.getParameter("action");
String oldPassword = request.getParameter("oldPassword");
String newPassword = request.getParameter("newPassword");
String confirmNewPassword = request.getParameter("confirmNewPassword");

if (action == null) {
	forwardToIndexWithMessage("Error in the creation of a new account (request == null)", response);
	System.out.println("action == null");
} else if (action.equals("registration")) {
	//new student registration!
	
	String email = request.getParameter("email");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String studentID = request.getParameter("studentID");
	try {
		getUserManager().createNewStudent(email, firstName, lastName, studentID);
		forwardToIndexWithMessage("Registration completed, check your email for the password", response);
	} catch (StudentCreationException e) {
		forwardToIndexWithMessage("Error in the creation of a new account", response);
	}
}else if(action.equals("changePassword")){
	if (!newPassword.equals(confirmNewPassword)) {
		response.sendRedirect("../presentation/student/studentChangePassword.jsp?message=" + "New Password and Confirm New Password are different");
		return;
	}
	StudentManagerBeanRemote studentManager = getStudentManager(session, response);
	try {
		studentManager.changePassword(oldPassword, newPassword);
		response.sendRedirect("../presentation/student/studentProjectList.jsp");
	} catch (PasswordException e) {
		if (e.getMessage().equals("short")) {
			response.sendRedirect("../presentation/student/studentChangePassword.jsp?message=" + "New password you have inserted is too short");
		} else if (e.getMessage().equals("oldPasswordInvalid")) {
			response.sendRedirect("../presentation/student/studentChangePassword.jsp?message=" + "Old password you have inserted is wrong");
		} else { 
			response.sendRedirect("../presentation/student/studentChangePassword.jsp?message=" + "Error in changing password");
		}
	} catch (NotLoggedInException e) {
		forwardToIndexWithMessage("Session expired", response);
	}
}else if(action.equals("groupCreation")){
	// retrive other specific parameters
	String username2 = request.getParameter("Component2");
	String username3 = request.getParameter("Component3");
	String groupName = request.getParameter("groupName");
	String numComponents = request.getParameter("numComponents");
	int numComp = -1;
	//check if groupName already used in the same project
	if(numComponents == null || numComponents.isEmpty()){
		response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=number of components not valid");
		return;
	}
	try{
		numComp = Integer.parseInt(numComponents);
	}catch(NumberFormatException e){
		response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=number of components not valid");
		return;
	}
	if(numComp<1 || numComp >3 || numComp == 2 && username2 == null || numComp == 3 && username2 == null && username3 == null){
		response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=inserted data not consistent");
		return;
	}
	try{
		getStudentManager(session, response).createGroup(numComp, username2, username3, groupName);
	}catch(NotLoggedInException e){
		response.sendRedirect("../errorPage.jsp?message=login is required");
		return;
	}catch(NotValidProjectException e2){
		response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=project name not valid");
		return;
	}catch(WrongParameterException e3){
		response.sendRedirect("../presentation/student/studentProjectArea.jsp?message="+e3.getMessage());
		return;
	}
	
	response.sendRedirect("../presentation/student/studentProjectArea.jsp?");
	return;
} else if (action.equals("registerToProject")) {
	String projectName = request.getParameter("projectName");
	if (projectName == null) {
		response.sendRedirect("../presentation/student/studentProjectList.jsp?something went wrong. "+
		"If the problem persist logout and login again ");
		return;
	} 
	StudentManagerBeanRemote studentManager = getStudentManager(session, response);
	try {
		studentManager.registerToProject(projectName);
		response.sendRedirect("../presentation/student/studentProjectList.jsp");
		return;
	} catch (NotLoggedInException e) {
		response.sendRedirect("../errorPage.jsp?message=login is required");
		return;
	} catch (NotValidProjectException e) {
		response.sendRedirect("../presentation/student/studentProjectList.jsp?message=something went wrong. "+
				"The project is not valid or the time for registration (its first deadline) expired "+
				"and you lost the right to register to it");
		return;
	}
}


%>