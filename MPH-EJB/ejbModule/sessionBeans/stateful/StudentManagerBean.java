package sessionBeans.stateful;

import java.io.File;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.ejb.EJB;
import javax.ejb.Stateful;

import sessionBeans.stateless.DeadlineScoreManagerBeanLocal;
import sessionBeans.stateless.DocumentManagerBeanLocal;
import sessionBeans.stateless.GroupManagerBeanLocal;
import sessionBeans.stateless.ProjectManagerBean;
import sessionBeans.stateless.ProjectManagerBeanLocal;
import sessionBeans.stateless.UserManagerBeanLocal;

import entityBeans.Deadline;
import entityBeans.DeadlineScore;
import entityBeans.Group;
import entityBeans.GroupDocument;
import entityBeans.OverviewDocument;
import entityBeans.Professor;
import entityBeans.Project;
import entityBeans.Student;
import exceptions.NotLoggedInException;
import exceptions.NotValidGroupException;
import exceptions.NotValidProjectException;
import exceptions.PasswordException;
import exceptions.PermissionDeniedException;
import exceptions.WrongParameterException;

/**
 * Session Bean implementation class StudentManagerBean
 */
@Stateful
public class StudentManagerBean implements StudentManagerBeanRemote {

	private String username;
	private String currentProject;
	private int currentGroupID;
	private String currentGroupName;
	final private int MIN_PASSWORD_LENGTH = 6;
	final private int MIN_COMPONENTS_GROUP = 1;
	final private int MAX_COMPONENTS_GROUP = 3;
	
	@EJB
	private UserManagerBeanLocal userManager;

	@EJB
	private ProjectManagerBeanLocal projectManager;
	
	@EJB
	private DocumentManagerBeanLocal documentManager;
	
	@EJB
	private GroupManagerBeanLocal groupManager;
	
	@EJB
	private DeadlineScoreManagerBeanLocal deadlineScoreManager;
    /**
     * Default constructor. 
     */
    public StudentManagerBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public void login(String email) {
		username = email;
		currentProject = null;
		currentGroupID = 0;
		currentGroupName = null;
	}

	@Override
	public void logout() {
		username = null;
		currentProject = null;
		currentGroupID = 0;
		currentGroupName = null;
	}

	@Override
	public void changePassword(String oldPassword, String newPassword)
			throws PasswordException, NotLoggedInException {
		if (username == null)
			throw new NotLoggedInException();
		if (newPassword.length() < MIN_PASSWORD_LENGTH) 
			throw new PasswordException("short");
		Student student = userManager.findStudentByEmail(username);
		if (!student.getPassword().equals(oldPassword)) 
			throw new PasswordException("oldPasswordInvalid");
		student.setPassword(newPassword);		
	}

	@Override
	public void registerToProject(String projectName)
			throws NotLoggedInException, NotValidProjectException {
		if (username == null) {
			throw new NotLoggedInException();
		}
		if (projectName == null) {
			throw new NotValidProjectException();
		}
		Project project = projectManager.findProjectByKey(projectName);
		if (project == null) {
			throw new NotValidProjectException();
		}
		
		Date now = new Date();
		List<Deadline> deadlines = projectManager.getDeadlineListOfAProject(project.getName());
		// deadlines are already ordered. Keep the first
		Deadline firstDeadline = deadlines.get(0);
				
		if(now.after(firstDeadline.getKey().getDate())){
			projectManager.removeAssociation(username,projectName);
			System.out.println("removed association - avoiding registration");
			throw new NotValidProjectException();
		}else{
			projectManager.registerStudentToProject(username, projectName);
		}
	}

	@Override
	public void enterProjectArea(String projectName)
			throws NotLoggedInException, NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(projectName == null || projectName.isEmpty())
			throw new NotValidProjectException();
		// check of association between student and project
		List<Project> projectRegister = projectManager.getListOfRegisterProjectsOfAStudent(username);
		boolean found = false;
		for(int i=0; i<projectRegister.size() && !found; i++)
			if(projectRegister.get(i).getName().equals(projectName)){
				currentProject = projectName;
				found = true;
			}
		if(!found){
			currentProject = null;
			throw new NotValidProjectException();
		}

		if (hasAGroupInCurrentProject()) {
			Group group = groupManager.getGroupOfAStudent(username, projectName);
			if (group != null) {
				currentGroupID = group.getGroupID();
				currentGroupName = group.getName();
				System.out.println(currentGroupID + " " + currentGroupName);
			}
		}	

	}

	@Override
	public boolean hasAGroupInCurrentProject() throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		return groupManager.hasAGroup(username, currentProject);
	}

	@Override
	public Project getProject() throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		return projectManager.findProjectByKey(currentProject);
		
	}

	@Override
	public Group getGroup() throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroupID == 0)
			throw new NotValidGroupException();
		try{
		
			return groupManager.findGroupByKey(currentGroupID);
		
		}catch(NotValidGroupException e){
			throw e;
		}
	}

	@Override
	public Group getViewedGroup() throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		return groupManager.getViewedGroup(currentGroupID);
	}

	@Override
	public DeadlineScore getDeadlineScore(Timestamp deadlineDate) throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		try {
			DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String parsedDate = null;
			parsedDate = format.format(deadlineDate.getTime());
			return deadlineScoreManager.findDeadlineScoreByKey(currentProject, parsedDate, currentGroupID);
		} catch (NotValidGroupException e) {
			e.printStackTrace();
		} catch (WrongParameterException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Deadline> getDeadlines() throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		List<Deadline> list = projectManager.getDeadlineListOfAProject(currentProject);
		if (list == null)
			list = new ArrayList<Deadline>();
		return list;
	}

	@Override
	public void createGroup(int components, String student2, String student3,
			String groupName) throws NotLoggedInException,
			NotValidProjectException, WrongParameterException {
		
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(	components < MIN_COMPONENTS_GROUP || components > MAX_COMPONENTS_GROUP || 
			components == 2 && (student2 == null || student2.isEmpty() ) ||
			components == 3 && (student2 == null || student2.isEmpty() || student3 == null || student3.isEmpty() )  )
			throw new WrongParameterException("you have forgotten to insert some emails or you have inserted wrong numbers of components");
		if(groupName == null || groupName.isEmpty())
			throw new WrongParameterException("group name not valid");
		
		// make all checks on parameters
		
		// checks name of group is unique in that project
		boolean groupNameAvailable = groupManager.isThisGroupNameFreeInThisProject(groupName, currentProject);
		if(!groupNameAvailable)
			throw new WrongParameterException("this name is already in use in this project, please select another one");
		//checks that all students are registered to the project
		System.out.println("qui arriva");
		System.out.println(student2);
		System.out.println(student3);
		
		boolean found = true;
		
		if(student2 != null && !student2.isEmpty()){
			List<Project> projStud2 = projectManager.getListOfRegisterProjectsOfAStudent(student2);
			found = false;
			for(int i = 0; i < projStud2.size() && !found; i++)
				if(projStud2.get(i).getName().equals(currentProject))
					found = true;
		}
		if(found && student3 != null && !student3.isEmpty()){
			List<Project> projStud3 = projectManager.getListOfRegisterProjectsOfAStudent(student3);
			found = false;
			for(int i = 0; i < projStud3.size() && !found; i++)
				if(projStud3.get(i).getName().equals(currentProject))
					found = true;
		}
		System.out.println(found);
		if(!found){
			throw new WrongParameterException("a student is not registered to this project! you cannot proceed until all members are registered to the project");
		}
		System.out.println("checkpoint 1");
		
		//all students are registered to the project. Check they don't have already a group
		boolean hasAGroup = false;
		if(student2 != null && !student2.isEmpty()){
			hasAGroup = groupManager.hasAGroup(student2, currentProject);
			if(hasAGroup)
				throw new WrongParameterException("a student has already a group in this project! He cannot be a member of another group");
		}
		if(student3 != null && !student3.isEmpty()){
			hasAGroup = groupManager.hasAGroup(student3, currentProject);
			if(hasAGroup)
				throw new WrongParameterException("a student has already a group in this project! He cannot be a member of another group");
		}
		
		System.out.println("start creation");
		groupManager.createGroup(username, student2, student3, groupName, currentProject);
		
	}

	@Override
	public String download(int documentID, String type)
			throws NotLoggedInException, NotValidProjectException,
			PermissionDeniedException, NotValidGroupException {
		if (currentProject == null) 
			throw new NotValidProjectException();
		if (username == null) 
			throw new NotLoggedInException();
		if (documentID == 0)
			throw  new PermissionDeniedException();
		if (type.equals("overview")) {
			OverviewDocument document = projectManager.getOverview(documentID);
			if (document == null) 
				throw new PermissionDeniedException();
			String path = document.getPath();
			return path;
		} else {
			String path = documentManager.download(documentID, currentGroupID);
			if (path == null) 
				throw new PermissionDeniedException();
			return path;
		}
	}

	@Override
	public void upload(String deadlineDate, String filePath)
			throws NotLoggedInException, NotValidProjectException,
			NotValidGroupException {
		if (username == null) {
			throw new NotLoggedInException();
		}
		if (currentGroupID == 0) {
			throw new NotValidGroupException();
		}
		if (currentProject == null) {
			throw new NotValidProjectException();
		}
		String path = filePath.substring(2);
		String filename = filePath.substring(filePath.lastIndexOf(File.separator) + 1, filePath.length()-4);
		System.out.println("Filename length " + filename.length());
		documentManager.studentUpload(path, filename, username, currentGroupID, currentProject, deadlineDate);
	}

	@Override
	public GroupDocument getLastDocument(Deadline deadline)
			throws NotLoggedInException, NotValidProjectException,
			NotValidGroupException {
		if (username == null) {
			throw new NotLoggedInException();
		}
		if (currentGroupID == 0) {
			throw new NotValidGroupException();
		}
		if (currentProject == null) {
			throw new NotValidProjectException();
		}
		return documentManager.getLastDocumentOfAGroup(currentGroupID, deadline);
	}

	@Override
	public List<GroupDocument> getAllDocuments() throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException {
		if (username == null) {
			throw new NotLoggedInException();
		}
		if (currentGroupID == 0) {
			throw new NotValidGroupException();
		}
		if (currentProject == null) {
			throw new NotValidProjectException();
		}
		return documentManager.getDocumentsOfAGroup(currentGroupID);
	}

	@Override
	public List<GroupDocument> getAllDocumentsOfViewedGroup()
			throws NotLoggedInException, NotValidProjectException,
			NotValidGroupException {
		if (username == null) {
			throw new NotLoggedInException();
		}
		if (currentGroupID == 0 || getViewedGroup() == null) {
			throw new NotValidGroupException();
		}
		if (currentProject == null) {
			throw new NotValidProjectException();
		}
		return documentManager.getDocumentsOfAGroup(getViewedGroup().getGroupID());
	}

	@Override
	public boolean hasViewedGroup() throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException {
		if (username == null) {
			throw new NotLoggedInException();
		}
		if (currentGroupID == 0) {
			throw new NotValidGroupException();
		}
		if (currentProject == null) {
			throw new NotValidProjectException();
		}
		Group group = groupManager.findGroupByKey(currentGroupID);
		if (group == null) 
			throw new NotValidGroupException();
		if (group.getViewedGroup() == 0) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	public List<Project> getListOfRegisterProject() throws NotLoggedInException {
		List<Project> projects = projectManager.getListOfRegisterProjectsOfAStudent(username);
		return projects;
	}
	
	@Override
	public List<Project> getListOfEnableButNotRegisterProject() throws NotLoggedInException {
		Date now = new Date();
		List<Project> projects = projectManager.getListOfEnabledButNotRegisterProjectsOfAStudent(username);
		List<Project> permittedProjects = new ArrayList<Project>();
		for(int i = 0; i < projects.size() ; i++){
			List<Deadline> deadlines = projectManager.getDeadlineListOfAProject(projects.get(i).getName());
			
			// deadlines are already ordered. Keep the first
			Deadline firstDeadline = deadlines.get(0);
			
			if(now.before(firstDeadline.getKey().getDate()))
				permittedProjects.add(projects.get(i));
			else
				projectManager.removeAssociation(username,projects.get(i).getName());
			
		}
		return permittedProjects;
	}

	@Override
	public String getDeadlineName(Timestamp deadlineDate)
			throws WrongParameterException {
		if (deadlineDate == null)
			throw new WrongParameterException();
		List<Deadline> list = projectManager.getDeadlineListOfAProject(currentProject);
		Deadline deadline = null;
		for (Deadline d: list) {
			if (d.getKey().getDate().equals(deadlineDate)) {
				deadline = d;
				break;
			}
		}
		if (deadline == null)
			throw new WrongParameterException();
		return deadline.getName();
	}

	@Override
	public String getUsername() {
		return username;
	}

	@Override
	public void resetState() {
		currentGroupID = 0;
		currentGroupName = null;
		currentProject = null;
		
	}

	
}
