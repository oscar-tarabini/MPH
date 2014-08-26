<%@page import="exceptions.NotValidProjectException"%>
<%@page import="exceptions.NotLoggedInException"%>
<%@page import="exceptions.PermissionDeniedException"%>
<%@page import="exceptions.NotValidGroupException"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*"%>
<%@ page
	import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="sessionBeans.stateful.StudentManagerBeanRemote"%>
<%@ page import="sessionBeans.stateful.ProfessorManagerBeanRemote"%>
<%@ page trimDirectiveWhitespaces="true" %>

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
private ProfessorManagerBeanRemote getProfessorManager(HttpSession session, HttpServletResponse response){
	Object statefulBean = session.getAttribute("statefulBean");
	if(statefulBean != null && statefulBean instanceof ProfessorManagerBeanRemote) {
		return ((ProfessorManagerBeanRemote)statefulBean);
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
	response.sendRedirect("../index.jsp?error=" + message);
}
%>

<%!
public boolean uploadPicture(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
Hashtable<String, String> parameters = new Hashtable<String, String>();
String filename = null;
FileItem file = null;
boolean isMultipart = ServletFileUpload.isMultipartContent(request);
if (isMultipart) {
	FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	List items = null;
	try {
		items = upload.parseRequest(request);
	} catch (FileUploadException e) {
		e.printStackTrace();
	}
	Iterator itr = items.iterator();
	while (itr.hasNext()) {
		FileItem item = (FileItem) itr.next();
		if (item.isFormField()) {
			String name = item.getFieldName();
			String value = item.getString();
			parameters.put(name, value);
		} else {
			file = item;
		}
	}
	if (file != null && file.getName().length()>=30) {
		//redirectToProjectList(response, "Picture name too long, maximum 30 characters. Change the filename");
		return false;
	} else if (!(file.getName().contains("jpg") || file.getName().contains("JPG"))) {
		//redirectToProjectList(response, "Only jpg files can be uploaded");
		return false;
	} else {
		String username = getStudentManager(session, response).getUsername();
		if (username == null) {
			//redirectToProjectList(response, "Error in uploading");
			return false;
		}
		File uploadDirectory = new File(".." + File.separator + "upload" + File.separator + "pictures");
		if (!uploadDirectory.exists()) 
			uploadDirectory.mkdirs();
		File image = new File(uploadDirectory.getPath() + File.separator + username + ".jpg");
		if (image.getAbsolutePath().length()>=249) {
			//redirectToProjectList(response, "Error in uploading, path too long");
			return false;
		}
		try {
			file.write(image);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
return false;

}
%>
<%!// type = "overviewDocument" or "groupDocument". Return the parameters of the request
	public Hashtable<String, String> uploadFile(HttpServletRequest request, HttpServletResponse response, String type) {
	Hashtable<String, String> parameters = new Hashtable<String, String>();
	String filename = null;
	FileItem file = null;
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (isMultipart) {
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		List items = null;
		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
		}
		Iterator itr = items.iterator();
		while (itr.hasNext()) {
			FileItem item = (FileItem) itr.next();
			if (item.isFormField()) {
				String name = item.getFieldName();
				String value = item.getString();
				parameters.put(name, value);
			} else {
				file = item;
			}
		}
		if (file != null && file.getName().length()>=30) {
			if (type.equals("overviewDocument")) {
				redirectToNewProjectCreation(response, "Document name too long, maximum 30 characters. Change the filename");
				return null;
			} else if (type.equals("groupDocument")) {
				redirectToProjectArea(response, "Document name too long, maximum 30 characters. Change the filename");
				return null;
			} 
		}
		if (file != null && file.getSize() > 0) { 
			if (type.equals("overviewDocument")) {
				filename = parameters.get("projectName");
			} else if (type.equals("groupDocument")) {
				//extract the last document uploaded from lastDoc parameter, if it is "" v1
				String lastDoc = parameters.get("lastDoc");
				System.out.println("lastdoc " + lastDoc);
				if ( lastDoc == null || lastDoc.equals("")) {
					filename = file.getName().substring(0, file.getName().lastIndexOf(".")) +  "-v1.pdf";
				} else {
					int version = Integer.parseInt(lastDoc.substring(lastDoc.lastIndexOf("v")+1, lastDoc.length()));
					filename = file.getName().substring(0, file.getName().lastIndexOf(".")) + "-v" + (version+1) + ".pdf";
				}
				System.out.println("Filename " + filename + " check file" + checkFilename(filename));
			} 
			if ((file.getName().endsWith(".pdf") || file.getName().endsWith(".PDF")) && checkFilename(filename)) {
				if (type.equals("overviewDocument")) {
					File uploadDirectory = new File(".." + File.separator + "upload" + File.separator + "projectOverview");
					if (!uploadDirectory.exists()) 
						uploadDirectory.mkdirs();
					File projectOverview = new File(uploadDirectory.getPath() + File.separator + filename + ".pdf");
					if (projectOverview.getAbsolutePath().length()>=249) {
							redirectToNewProjectCreation(response, "Document name and path too long. Change the filename");
							return null;
					}
					try {
						file.write(projectOverview);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if (type.equals("groupDocument")) {
					System.out.println("inizio a salvare il file");
					String projectName = parameters.get("projectName");
					String deadlineDate = parameters.get("deadlineDate");
					String groupID = parameters.get("groupID");
					deadlineDate = deadlineDate.replaceAll(":", "-");
					System.out.println(projectName + deadlineDate + groupID);
					File uploadDirectory = new File(".." + File.separator + "upload" + File.separator + "groupDocument" + File.separator + projectName + File.separator + groupID + File.separator + deadlineDate);
					System.out.println("Upload directory " + uploadDirectory);
					if (!uploadDirectory.exists()) 
						uploadDirectory.mkdirs();
					File groupDocument = new File(uploadDirectory.getPath() + File.separator + filename);
					if (groupDocument.getAbsolutePath().length()>=249) {
						redirectToProjectArea(response, "Document name and path too long. Change the filename");
						return null;
					}
					parameters.put("filePath", groupDocument.getPath());
					try {
						file.write(groupDocument);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			} else {
				if (type.equals("overviewDocument")) {
					redirectToNewProjectCreation(response, "Document type not valid. Only PDF files can be uploaded");
					return null;
				} else if (type.equals("groupDocument")) {
					redirectToProjectArea(response, "Document type not valid. Only PDF files can be uploaded");
					return null;
				}
			}
		} else {
			if (type.equals("overviewDocument")) {
				redirectToNewProjectCreation(response, "Error in uploading the document");
				return null;
			} else if (type.equals("groupDocument")) {
				redirectToProjectArea(response, "Error in uploading the document");
				return null;
			}
		}
	}
	return parameters;
}

private void redirectToNewProjectCreation(HttpServletResponse response, String message) {
	try {
		response.sendRedirect("../presentation/professor/newProjectCreation.jsp?error=" + message);
		return;
	} catch (IOException e) {
		e.printStackTrace();
	}
}

private void redirectToProjectArea(HttpServletResponse response, String message) {
	try {
		response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=" + message);
		return;
	} catch (IOException e) {
		e.printStackTrace();
	}
}

private void redirectToProjectList(HttpServletResponse response, String message) {
	try {
		response.sendRedirect("../presentation/student/studentProjectList.jsp?message=" + message);
		
	} catch (IOException e) {
		e.printStackTrace();
	}
}
%>
<%!public boolean checkFilename(String filename) {
		String[] forbiddenCharacters = {"\\", "/", "?", "%", "*", ":",
				"|", "\"", "<", ">" };
		for (String c : forbiddenCharacters) {
			if (filename.contains(c))
				return false;
		}
		return true;
	}%>
<%
	String action = request.getParameter("action");
	if (action.equals("uploadOverview")) {
		Hashtable<String, String> parameters = uploadFile(request, response, "overviewDocument");
		if (parameters != null) 
			response.sendRedirect("../presentation/professor/insertDeadline.jsp?projectName=" + parameters.get("projectName") + "&numDeadline=" + parameters.get("numDeadline"));
	} else if (action.equals("uploadGroupDocument")) {
		System.out.println("upload group document");
		Hashtable<String, String> parameters = uploadFile(request, response, "groupDocument");
		if (parameters != null) {
			String deadlineDate = parameters.get("deadlineDate");
			String filePath = parameters.get("filePath");
			try {
				System.out.println("Upload document deadline " + deadlineDate + "file path " + filePath);
				getStudentManager(session, response).upload(deadlineDate, filePath);
			} catch (Exception e) {
				e.printStackTrace();
				forwardToIndexWithMessage("Session expired", response);
			}
		} else {
			System.out.println("errore nell'upload");
			//response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in uploading the document");
			return;
		}
		response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=upload completed");
		return;
	} else if (action.equals("downloadOverview")) {
		String stringDocumentID = request.getParameter("fileId");
		if (stringDocumentID == null) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the project overview document");
		}
		int documentID = 0;
		try {
			documentID = Integer.parseInt(stringDocumentID);
		} catch (Exception e) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the project overview document");
		}
		String path = null;
		try {
			path = getStudentManager(session, response).download(documentID, "overview");
		} catch (NotLoggedInException e) {
			forwardToIndexWithMessage("Session expired", response);
		} catch (NotValidProjectException e) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the project overview document");
		} catch (PermissionDeniedException e) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the project overview document");
		} catch (NotValidGroupException e ) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the project overview document");
		}
		if (path == null) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the project overview document");
		}
		BufferedInputStream buf=null;
		ServletOutputStream myOut=null;
		try {
			myOut = response.getOutputStream( );
			File file = new File(".." + path);
			response.setContentType("text/pdf");
			response.addHeader("Content-Disposition","attachment; filename="+file.getName());
			response.setContentLength((int)file.length());
			FileInputStream input = new FileInputStream(file);
		    buf = new BufferedInputStream(input);
		    int readBytes = 0;
			while((readBytes = buf.read( )) != -1)
				myOut.write(readBytes);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (myOut != null) {
				myOut.flush();
				myOut.close();
			}
			if (buf != null)
				buf.close();
		}
		return;
	} else if (action.equals("downloadGroupDocument")) {
		String stringDocumentID = request.getParameter("fileId");
		String professor = request.getParameter("professor");
		boolean isAProfessor = false;
		if (professor != null && professor.equals("yes"))
			isAProfessor = true;
		if (stringDocumentID == null) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the document");
		}
		int documentID = 0;
		try {
			documentID = Integer.parseInt(stringDocumentID);
		} catch (Exception e) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the document");
		}
		String path = null;
		try {
			if (isAProfessor)
				path = getProfessorManager(session, response).download(documentID);
			else
				path = getStudentManager(session, response).download(documentID, "group");
		} catch (NotLoggedInException e) {
			forwardToIndexWithMessage("Session expired", response);
		} catch (NotValidProjectException e) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the document");
			return;
		} catch (PermissionDeniedException e) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the document");
			return;
		} catch (NotValidGroupException e ) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the document");
			return;
		}
		if (path == null) {
			response.sendRedirect("../presentation/student/studentProjectArea.jsp?message=error in downloading the document");
			return;
		}
		BufferedInputStream buf=null;
		ServletOutputStream myOut=null;
		try {
			myOut = response.getOutputStream( );
			File file = new File(".." + path);
			response.setContentType("text/pdf");
			response.addHeader("Content-Disposition","attachment; filename="+file.getName());
			response.setContentLength((int)file.length());
			FileInputStream input = new FileInputStream(file);
		    buf = new BufferedInputStream(input);
		    int readBytes = 0;
			while((readBytes = buf.read( )) != -1)
				myOut.write(readBytes);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (myOut != null) {
				myOut.flush();
				myOut.close();
			}
			if (buf != null)
				buf.close();
		}
		return;
	} else if (action.equals("getPicture")) {
		String email = request.getParameter("email");
		if (email != null) {
			File image = new File(".." + File.separator + "upload"+ File.separator + "pictures" + File.separator + email + ".jpg");
			sendImage(response, image);
		} 
	} else if (action.equals("uploadPicture")) {
		boolean uploaded = uploadPicture(request, response, session);
		if (uploaded) {
			redirectToProjectList(response, "upload completed");
		} else {
			redirectToProjectList(response, "Upload error. The photo must be a jpg and the filename no longer than 30 characters");
		}
		
	}
%>

<%!
private void sendImage(HttpServletResponse response, File image) {
	response.setContentType("image/jpeg");
	response.setContentLength((int)image.length());
	BufferedInputStream buf=null;
	ServletOutputStream myOut=null;
	try {
		FileInputStream input = new FileInputStream(image);
		buf = new BufferedInputStream(input);
		myOut = response.getOutputStream();
		int readBytes = 0;
		while((readBytes = buf.read( )) != -1)
			myOut.write(readBytes);
	} catch (IOException e) {
		e.printStackTrace();
	} 
}
%>