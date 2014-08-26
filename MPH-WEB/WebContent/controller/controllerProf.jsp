<%@page import="sessionBeans.stateful.ProfessorManagerBean"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date, java.text.DateFormat,java.text.ParseException, java.text.SimpleDateFormat"%>
<%@page import="exceptions.WrongParameterException"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page import="entityBeans.Professor"%>
<%@ page import="entityBeans.Deadline"%>
<%@ page import="exceptions.*"%>
<%@ page import="javax.naming.*, javax.rmi.PortableRemoteObject, java.util.Properties" %>

<%!
private ProfessorManagerBeanRemote getProfessorManager(HttpSession session, HttpServletResponse response){
	Object statefulBean = session.getAttribute("statefulBean");
	if(statefulBean != null && statefulBean instanceof ProfessorManagerBeanRemote) {
		return ((ProfessorManagerBeanRemote)statefulBean);
	} else {
		try {
		forwardToErrorPageWithMessage("Session expired", response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
%>

<%! 
private void forwardToErrorPageWithMessage(String message, HttpServletResponse response) throws Exception {
	response.sendRedirect("../errorPage.jsp?message=" + message);
}
%>
<%!
private boolean checkEmailFormat(String email) {
	
	//final String[] POSSIBLE_DOMAINS = {"@polimi.it", "@mail.polimi.it"};
	if(email == null) return false;
	if (email.isEmpty() || email.equals("") || email.startsWith("@")) return false;
	if (email.startsWith(".")) return false;
	if (numberOfAT(email)>1 || numberOfAT(email)==0 ) return false;
	/* for (String domain: POSSIBLE_DOMAINS) {
		if (email.endsWith(domain)) return true;
	}*/
	return true;
}

private int numberOfAT(String email) {
	int i = 0;
	for(int j = 0; j<email.length(); j++) {
		if (email.charAt(j) == '@') i++;
	}
	return i;
}
%>
<%
// retrieve all possible parameters
String action = request.getParameter("action");
String oldPassword = request.getParameter("oldPassword");
String newPassword = request.getParameter("newPassword");
String confirmNewPassword = request.getParameter("confirmNewPassword");

String projectName = request.getParameter("projectName");
String numDeadline = request.getParameter("numDeadline");

ProfessorManagerBeanRemote professorManager = getProfessorManager(session, response);
String username = professorManager.getProfessorUsername();

if (action == null) {
	forwardToErrorPageWithMessage("something wrong happened", response);

} else if (action.equals("changePassword")) {
	if (!newPassword.equals(confirmNewPassword)) {
		response.sendRedirect("../presentation/professor/profChangePassword.jsp?message=" + "New Password and Confirm New Password are different");
		return;
	}
	try {
		professorManager.changePassword(oldPassword, newPassword);
		response.sendRedirect("../presentation/professor/professorProjectsList.jsp");
	} catch (PasswordException e) {
		if (e.getMessage().equals("short")) {
			response.sendRedirect("../presentation/professor/profChangePassword.jsp?message=" + "New password you have inserted is too short");
		} else if (e.getMessage().equals("oldPasswordInvalid")) {
			response.sendRedirect("../presentation/professor/profChangePassword.jsp?message=" + "Old password you have inserted is wrong");
		} else { 
			response.sendRedirect("../presentation/professor/profChangePassword.jsp?message=" + "Error in changing password");
		}
	} catch (NotLoggedInException e) {
		forwardToErrorPageWithMessage("Session expired", response);
	}

	
} else if(action.equals("checkProjectKeyENumDead")){
	try{
		int numberOfDeadline = Integer.parseInt(numDeadline);
		boolean ok = professorManager.isProjectInitialOk(projectName, numberOfDeadline);
		if(ok) {
			response.sendRedirect("../presentation/professor/newProjectCreation.jsp?canUpload=ok&projectName="+projectName+"&numDeadline="+numDeadline);
			return;
		}
		else {
			response.sendRedirect("../presentation/professor/newProjectCreation.jsp?error="+projectName+" already used. Choose a different name");
			return;
		}
	} catch(NotLoggedInException notLogged){
		forwardToErrorPageWithMessage("login is required", response);
	} catch(WrongParameterException wrongParam){
		response.sendRedirect("../presentation/professor/newProjectCreation.jsp?error="+wrongParam.getMessage());
	} catch(NumberFormatException formatExc){
		response.sendRedirect("../presentation/professor/newProjectCreation.jsp?error=number of deadline must be an integer");
	}
} else if(action.equals("createProject")){
	// it needs projectName, numDeadline
	// it also needs deadName#s, deadlineDate#s, closureDate, emails
	List<String> deadlineNames = new ArrayList<String>();
	List<String> deadlineDates = new ArrayList<String>();
	List<String> enabledStudent = new ArrayList<String>();
	String closureDate = request.getParameter("closureDate");
	String studentsEmails = request.getParameter("studentsEmails");
	
	System.out.println(projectName);
	System.out.println(numDeadline);
	System.out.println(closureDate);
	System.out.println(studentsEmails);
	
	//check closure date
	Date now = new Date();
	DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	//Date closeDate = format.parse(closureDate);
		
	System.out.println(now);
	//System.out.println(closeDate);
	
	if(closureDate == null || closureDate.isEmpty() || format.parse(closureDate).before(now)){
		response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=closure date not valid!" + "&projectName=" + projectName + "&numDeadline=" + numDeadline);
		return;
	}
	//check list of email
	if(studentsEmails == null || studentsEmails.isEmpty()) {
		response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=at least one student email is required!" + "&projectName=" + projectName + "&numDeadline=" + numDeadline);
		return;
	}
	
	StringTokenizer stringTokenizer = new StringTokenizer(studentsEmails,",");	
	byte NEW_LINE = 13;
	//e-mail management
	while(stringTokenizer.hasMoreTokens()){
		String email = stringTokenizer.nextToken();
		System.out.println(email);

		//replace possible empty spaces--da provare con invio-- non funziona
		email = email.replaceAll(" ", "").replaceAll("\n", "").replaceAll(""+(char)NEW_LINE, "");
		email = email.trim();

		boolean emailWellFormed = checkEmailFormat(email);
		if(!emailWellFormed) {
			response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=invalidEmail: "+email + "&projectName=" + projectName + "&numDeadline=" + numDeadline);
			return;
		}
		
		for(int i=0; i<email.length(); i++)
			System.out.println((email.getBytes())[i]);
		
		boolean repetition = false;
		for(int i=0; i < enabledStudent.size(); i++)
			if(enabledStudent.get(i).equals(email))
				repetition = true;
		if(!repetition){
				enabledStudent.add(email);
		}
	}
	
	System.out.println(enabledStudent);
	
	//check deadline names and dates
	for(int i = 1; i <= Integer.parseInt(numDeadline); i++ ){
		String tempDeadline = request.getParameter("deadName"+i);
		System.out.println(tempDeadline);
		if(tempDeadline == null || tempDeadline.equals("")){
			response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=deadline name not valid" + "&projectName=" + projectName + "&numDeadline=" + numDeadline);
			return;
		}
		deadlineNames.add(tempDeadline);
		
		String tempDeadDate = request.getParameter("deadlineDate"+i);
		
		if(tempDeadDate == null || tempDeadDate.equals("")){
			response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=deadline date not inserted or not valid" + "&projectName=" + projectName + "&numDeadline=" + numDeadline);
			return;
		}
		System.out.println(tempDeadDate);
		try {
			if(format.parse(closureDate).before(format.parse(tempDeadDate)) ||
					format.parse(tempDeadDate).before(now)	){
				response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=a deadlineDate was impossible" + "&projectName=" + projectName + "&numDeadline=" + numDeadline);
				return;
			}
		} catch (ParseException e) {
			response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=parsing date exception" + "&projectName=" + projectName + "&numDeadline=" + numDeadline);
		}
		
		
		for(int j= 0; j < deadlineDates.size(); j++){
			if(deadlineDates.get(j).equals(tempDeadDate)){
				response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=two deadlines cannot have exactly same date"+ "&projectName=" + projectName + "&numDeadline=" + numDeadline);
				return;
			}
				
		}
		
		deadlineDates.add(tempDeadDate);
	}
	
	System.out.println(deadlineNames);
	System.out.println(deadlineDates);
	
	//all checks of parameters have successfully passed
	try{
		professorManager.createProject(projectName, Integer.parseInt(numDeadline), deadlineNames,deadlineDates, closureDate, enabledStudent);
	} catch(NotLoggedInException e){
		response.sendRedirect("../errorPage.jsp?message=not logged in");
		return;
	} catch(WrongParameterException e1) {
		response.sendRedirect("../presentation/professor/insertDeadline.jsp?message=Invalid email. Only offical university emails are accepted "+"&projectName=" + projectName + "&numDeadline=" + numDeadline);
		return;
	}
	response.sendRedirect("../presentation/professor/professorProjectsList.jsp");
	return;
	
	
}else if(action.equals("enableVisibility")){
	String viewer = request.getParameter("viewer");
	String viewed = request.getParameter("viewed");
	
	if(viewer == null || viewer.isEmpty() || viewed == null || viewed.isEmpty()){
		response.sendRedirect("../presentation/professor/enableVisibility.jsp?message=group not selected");
		return;
	}
	if(viewer.equals(viewed)){
		response.sendRedirect("../presentation/professor/enableVisibility.jsp?message=a group can not be selected with itself");
		return;
	}
	try{
		int groupID1 = Integer.parseInt(viewer);
		int groupID2 = Integer.parseInt(viewed);
		professorManager.createVisibility(groupID1, groupID2);
		response.sendRedirect("../presentation/professor/enableVisibility.jsp?message=visibility enabled");
		return;
	}catch(NumberFormatException e){
		response.sendRedirect("../presentation/professor/enableVisibility.jsp?message=something went wrong with the selection of group - invalid group id");
		return;
	}catch(NotLoggedInException e1){
		response.sendRedirect("../errorPage.jsp?message=login is required");
		return;
	}catch(NotValidProjectException e2){
		response.sendRedirect("../errorPage.jsp?message=problem with session - project not valid");
		return;
	}catch(PermissionDeniedException e3){
		response.sendRedirect("../presentation/professor/enableVisibility.jsp?message=permission denied");
		return;
	}
	
	
}else if(action.equals("tmpEvaluate")){
	try{
		String deadDate = request.getParameter("deadDate");
		ProfessorManagerBeanRemote prof = getProfessorManager(session, response);
		int score = Integer.parseInt(request.getParameter("score"));
		
		if(score <= 0 || score > 10){
			response.sendRedirect("../presentation/professor/documentOfAGroup.jsp?message=you have to insert a score between 1 and 10");
			return;
		}
		prof.evaluateDeadline(deadDate, score);
		response.sendRedirect("../presentation/professor/documentOfAGroup.jsp");
	}catch(NumberFormatException e){
		response.sendRedirect("../presentation/professor/documentOfAGroup.jsp?message=you have to insert a score between 1 and 10");
		return;
	}catch(NotLoggedInException e1){
		response.sendRedirect("../errorPage.jsp?message=login is required");
		return;
	}catch(NotValidProjectException e2){
		response.sendRedirect("../errorPage.jsp?message=problem with session - project not valid");
		return;
	}catch(WrongParameterException e3){
		response.sendRedirect("../presentation/professor/documentOfAGroup.jsp?message=you entered wrong parameters");
		return;
	}catch(NotValidGroupException e4){
		response.sendRedirect("../errorPage.jsp?message=group not valid");
		return;
	}
	
	
}else if(action.equals("finalEvaluationToConfirm")){
	ProfessorManagerBeanRemote profManager = getProfessorManager(session, response);
	try{
		List<Deadline> deadlines =  profManager.getDeadlines();
		System.out.println("entra final");
		// check parameters
		for(Deadline deadline : deadlines){
			String scoreInText = request.getParameter(deadline.getKey().getDate().toString());
			System.out.println(scoreInText);
			// initialized as minimum evaluation
			int score = 1;
			int penalty = 0;
			if(scoreInText != null){
				score = Integer.parseInt(scoreInText);
				if(score <= 0 || score > 10){
					response.sendRedirect("../presentation/professor/finalEvaluation.jsp?message=you have to insert a score between 1 and 10");
					return;
				}
			}
		}
			
		RequestDispatcher rd = getServletContext().getRequestDispatcher("/presentation/professor/confirmEvaluation.jsp");
		rd.forward(request, response);
			
	}catch(NotLoggedInException e){
		response.sendRedirect("../errorPage.jsp?message=login is required");
		return;
	}catch(NotValidProjectException e2){
		response.sendRedirect("../errorPage.jsp?message=problem with session - project not valid");
		return;
	}catch(NumberFormatException e){
		response.sendRedirect("../presentation/professor/finalEvaluation.jsp?message=you have to insert a score between 1 and 10");
		return;
	}
	
}else if(action.equals("confirmFinalEval")){

	try{
		ProfessorManagerBeanRemote prof = getProfessorManager(session, response);
		prof.confirmFinalEvaluation(Integer.parseInt(request.getParameter("totalScore")));
		response.sendRedirect("../presentation/professor/groupList.jsp?message=login is required");
		return;
	}catch(NotLoggedInException e){
		response.sendRedirect("../errorPage.jsp?message=login is required");
		return;
	}catch(NotValidProjectException e2){
		response.sendRedirect("../errorPage.jsp?message=problem with session - project not valid");
		return;
	}catch(NumberFormatException e){
		response.sendRedirect("../presentation/professor/finalEvaluation.jsp?message=you have to insert a score between 1 and 10");
		return;
	}catch(NotValidGroupException e4){
		response.sendRedirect("../errorPage.jsp?message=group not valid");
		return;
	}
} else if (action.equals("deleteProject")) {
	ProfessorManagerBeanRemote prof = getProfessorManager(session, response);
	try {
		prof.deleteProject();
		response.sendRedirect("../presentation/professor/professorProjectsList.jsp");
		return;
	} catch(NotLoggedInException e){
		response.sendRedirect("../errorPage.jsp?message=login is required");
		return;
	}catch(NotValidProjectException e2){
		response.sendRedirect("../errorPage.jsp?message=problem with session - project not valid");
		return;
	} catch(PermissionDeniedException e3) {
		response.sendRedirect("../errorPage.jsp?message=problem with session - permission denied to delete this project");
		return;
	}
	
}
%> 