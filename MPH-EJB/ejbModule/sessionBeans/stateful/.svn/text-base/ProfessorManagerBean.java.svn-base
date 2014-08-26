package sessionBeans.stateful;

import java.io.File;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.EJB;
import javax.ejb.Stateful;

import sessionBeans.stateless.DeadlineScoreManagerBeanLocal;
import sessionBeans.stateless.DocumentManagerBeanLocal;
import sessionBeans.stateless.GroupManagerBeanLocal;
import sessionBeans.stateless.ProjectManagerBeanLocal;
import sessionBeans.stateless.UserManagerBeanLocal;
import utility.ConfigurationTools;

import entityBeans.AssociationStudentProject;
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
 * Session Bean implementation class ProfessorManagerBean
 */
@Stateful
public class ProfessorManagerBean implements ProfessorManagerBeanRemote {

	private String username;
	private String currentProject;
	private int currentGroup;
	
	final private int MIN_PASSWORD_LENGTH = 6;
	private final int NULL_ID_GROUP_RESERVED = 0;
	private boolean alreadyEnsuredGroups = false;
	
	@EJB 
	private ProjectManagerBeanLocal projectManager;
	
	@EJB
	private UserManagerBeanLocal userManager;
	
	@EJB
	private DocumentManagerBeanLocal documentManager;
	
	@EJB
	private GroupManagerBeanLocal groupManager;
	
	@EJB
	private DeadlineScoreManagerBeanLocal deadlineScoreManager;
    
	/**
     * Default constructor. 
     */
    public ProfessorManagerBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public void login(String email) {
		username = email;
		currentGroup = 0;
		currentProject = null;
	}

	@Override
	public void logout() {
		username = null;
		currentGroup = 0;
		currentProject = null;
	}

	@Override
	public void changePassword(String oldPassword, String newPassword)
			throws PasswordException, NotLoggedInException {
		if (username == null) 
			throw new NotLoggedInException();
		if (newPassword.length() < MIN_PASSWORD_LENGTH) 
			throw new PasswordException("short");
		Professor professor = userManager.findProfessorByEmail(username);
		if (!professor.getPassword().equals(oldPassword)) 
			throw new PasswordException("oldPasswordInvalid");
		professor.setPassword(newPassword);
	}

	@Override
	public List<String> getListOfProjectKeys() throws NotLoggedInException {
		if(username == null)
			throw new NotLoggedInException();
		List<String> projectKeys = projectManager.getListOfProjectKeysOfAProfessor(username);
		return projectKeys;
	}

	@Override
	public void createProject(String projectName, int numberOfDeadlines,
			List<String> deadlineNames, List<String> deadlineDates,
			String closureDate, List<String> enabledStudEmail) throws NotLoggedInException, WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		File file = new File(System.getProperty("jboss.home.dir") + File.separator + "upload" + File.separator + "MPHconf.csv");
		List<String> possibleDomains = ConfigurationTools.getPossibleDomains(file);
		System.out.println("Possible domains " + possibleDomains);
		System.out.println("Enabled emails "+ enabledStudEmail);
		boolean correctDomain = false;
		if (possibleDomains.isEmpty())
			correctDomain = true;
		for (String email: enabledStudEmail) {
			for (String domain: possibleDomains) {
				if (email.endsWith(domain)){
					correctDomain = true;
					break;
				}
			}
			if (!correctDomain)
				throw new WrongParameterException();
		}
		
		String overviewPath = "/upload/projectOverview/"+projectName+".pdf";
		// store information about overview document
		int overviewId = documentManager.overviewUpload(overviewPath);
		
		projectManager.createProject(username, projectName, numberOfDeadlines, deadlineNames, deadlineDates, closureDate, overviewId);
		projectManager.joinStudentsToProject(projectName, enabledStudEmail);
	}

	@Override
	public void enterProjectArea(String projectName) throws NotLoggedInException,NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(projectName == null || projectName.isEmpty())
			throw new NotValidProjectException();
		// check of association between student and project
		List<String> projects = projectManager.getListOfProjectKeysOfAProfessor(username);
		boolean found = false;
		for(int i=0; i<projects.size() && !found; i++)
			if(projects.get(i).equals(projectName)){
				currentProject = projectName;
				currentGroup = 0;
				found = true;
			}
		if(!found){
			currentProject = null;
			throw new NotValidProjectException();
		}
		
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
	public Project getProject() throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		return projectManager.findProjectByKey(currentProject);
	}

	@Override
	public void deleteProject() throws NotLoggedInException,
			NotValidProjectException, PermissionDeniedException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		projectManager.deleteProject(currentProject, username);
	}

	@Override
	public List<GroupDocument> getDocumentsByDeadline(String deadlineDate)
			throws NotLoggedInException, NotValidProjectException, WrongParameterException {
		if (username == null) 
			throw new NotLoggedInException();
		if (currentProject == null)
			throw new NotValidProjectException();
		if (deadlineDate == null)
			throw new WrongParameterException();
		return documentManager.getDocumentsByDeadline(currentProject, deadlineDate);
	}

	@Override
	public List<Group> getGroups() throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		return groupManager.getGroupsOfAProject(currentProject);
	}

	@Override
	public String getGroupName(int groupID) throws NotLoggedInException,
			NotValidProjectException, WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if (groupID == 0)
			throw new WrongParameterException();
		String groupName = groupManager.getGroupName(groupID);
		if(groupName == null)
			throw new WrongParameterException();
		return groupName;
	}

	@Override
	public List<Group> getGroupsNotViewer() throws NotLoggedInException,
			NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		return groupManager.getGroupsOfAProjectNotViewer(currentProject);
	}

	@Override
	public void createVisibility(int groupID1, int groupID2)
			throws NotLoggedInException, NotValidProjectException,
			PermissionDeniedException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		List<Group> allGroups = groupManager.getGroupsOfAProject(currentProject);
		List<Group>	notViewer = groupManager.getGroupsOfAProjectNotViewer(currentProject);
		boolean found = false;
		for(int i= 0; i < allGroups.size() && !found; i++){
			if(((Group)allGroups.get(i)).getGroupID() == groupID2)
				found = true;
		}
		if(!found)
			throw new PermissionDeniedException();
		
		found = false;
		for(int i= 0; i < notViewer.size() && !found; i++){
			if(((Group)notViewer.get(i)).getGroupID() == groupID1 && ((Group)notViewer.get(i)).getViewedGroup() == NULL_ID_GROUP_RESERVED  )
				found = true;
		}
		if(!found)
			throw new PermissionDeniedException();
		
		groupManager.createVisibility(groupID1, groupID2);
		
	}

	@Override
	public String download(int documentID) throws NotLoggedInException,
			NotValidProjectException, PermissionDeniedException {
		if (currentProject == null) 
			throw new NotValidProjectException();
		if (username == null) 
			throw new NotLoggedInException();
		if (documentID == 0)
			throw  new PermissionDeniedException();
		String path = documentManager.download(documentID);
		if (path == null) 
			throw new PermissionDeniedException();
		return path;
	}

	@Override
	public void enterGroupPage(int groupID) throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException, WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		List<Group> list = groupManager.getGroupsOfAProject(currentProject);
		if (list == null)
			throw new NotValidProjectException();
		boolean found = false;
		for (Group g: list) {
			if (g.getGroupID() == groupID)
				found = true;
		}
		if (!found)
			throw new NotValidGroupException();
		Group group = groupManager.findGroupByKey(groupID);
		if (group == null) {
			throw new WrongParameterException();
		} else {
			currentGroup = groupID;
		}
	}

	@Override
	public DeadlineScore getDeadlineScoreOfAGroup(String deadlineDate)
			throws NotLoggedInException, NotValidProjectException,
			NotValidGroupException, WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		if(deadlineDate == null)
			throw new WrongParameterException();
		//Group group = getCurrentGroup();
		//if (group.isDefinitive())
		//	return null;
		DeadlineScore deadlineScore = deadlineScoreManager.findDeadlineScoreByKey(currentProject, deadlineDate, currentGroup);
		if (deadlineScore == null) {
			//No deadlineScore into the database
			deadlineScoreManager.initializeDeadlineScore(currentProject, deadlineDate, currentGroup);
		}
		Deadline deadline = projectManager.findDeadlineByKey(currentProject, deadlineDate);
		if (deadline == null)
			throw new WrongParameterException();
		GroupDocument document = documentManager.getFirstDocumentOfAGroup(currentGroup, deadline);
		if (document == null && projectManager.hasClosureDateExpired(currentProject)){
			// closure date expired and no document uploaded, so set score for this deadline to -1
			deadlineScoreManager.saveDeadlineScore(currentProject, deadlineDate, currentGroup, -1);
		}
		if (document == null) {
			// No document uploaded
			return null;
		}
		return deadlineScoreManager.findDeadlineScoreByKey(currentProject, deadlineDate, currentGroup);
	}

	@Override
	public List<GroupDocument> getDocumentsOfAGroup()
			throws NotLoggedInException, NotValidProjectException,
			NotValidGroupException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		List<GroupDocument> list = documentManager.getDocumentsOfAGroup(currentGroup);
		return list;
	}

	@Override
	public void evaluateDeadline(String deadlineDate, int score)
			throws NotLoggedInException, NotValidProjectException,
			NotValidGroupException, WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		if(deadlineDate == null)
			throw new WrongParameterException();
		if(score <= 0)
			throw new WrongParameterException();
		deadlineScoreManager.saveDeadlineScore(currentProject, deadlineDate, currentGroup, score);
	}

	@Override
	public void finalEvaluation(List<String> deadlineDates,
			List<Integer> deadlineScores) throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException,
			WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		if(deadlineDates == null || deadlineScores == null || deadlineDates.size() != deadlineScores.size())
			throw new WrongParameterException();
		for(int i=0; i<deadlineDates.size(); i++) {
			deadlineScoreManager.saveDeadlineScore(currentProject, deadlineDates.get(i), currentGroup, deadlineScores.get(i));
		}
	}

	@Override
	public int computePenalty(String deadlineDate) throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException, WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		if(deadlineDate == null)
			throw new WrongParameterException();
		return deadlineScoreManager.computePenalty(currentGroup, currentProject, deadlineDate);
	}

	@Override
	public int computeFinalScore() throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		List<Deadline> deadlines = getDeadlines();
		int numberOfDeadline = deadlines.size();
		int finalScore = 0;
		if (deadlines == null || deadlines.isEmpty())
			throw new NotValidProjectException();
		for (Deadline deadline: deadlines) {
			DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = new Date(deadline.getKey().getDate().getTime());
			String stringDate = format.format(date);
			try {
				DeadlineScore deadlineScore = getDeadlineScoreOfAGroup(stringDate);
				int scoreNoPenalty = 1;
				int penalty = 0;
				//at least one document uploaded
				if(deadlineScore != null){
					scoreNoPenalty = deadlineScore.getScoreNoPenalty();
					penalty = deadlineScore.getPenalty();
				}
				finalScore = (finalScore + scoreNoPenalty - penalty);
			} catch (WrongParameterException e) {
				e.printStackTrace();
			}
		}
		return finalScore / numberOfDeadline;
	}

	@Override
	public void confirmFinalEvaluation(int finalScore)
			throws NotLoggedInException, NotValidProjectException,
			NotValidGroupException, WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		if(finalScore<=0 || finalScore>10)
			throw new WrongParameterException();
		groupManager.saveFinalEvaluation(currentGroup, finalScore);
	}

	@Override
	public boolean isProjectInitialOk(String projectName, int numDeadline)
			throws NotLoggedInException, WrongParameterException {
		
		if (username == null) 
			throw new NotLoggedInException();
		boolean deadlineOk = projectManager.checkNumberOfDeadlines(numDeadline);
		if (!deadlineOk)
			throw new WrongParameterException("number of deadline must be greater than 1");
		if (projectName == null || projectName.equals("") )
			throw new WrongParameterException("project name not valid");
		for(int i = 0; i < projectName.length(); i++){
			char c = projectName.charAt(i);
			if(c == '?' || c == '=' || c == '|' || c == '!' || c == '.' ||  c == '\\' || c == '%' || c == '/' || c == '*' || c == ':' || c == '<' || c == '>' )
				throw new WrongParameterException("project name contains not allowed symbols: '"+c+"'");
		}
		
		return projectManager.checkKeyIsFree(projectName);
	}

	@Override
	public String getProfessorUsername() {
		return username;
	}

	@Override
	public void resetState() throws NotLoggedInException {
		currentProject = null;
		currentGroup = 0;
		
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
	public Student getStudent(String studentEmail) throws NotLoggedInException,
			WrongParameterException {
		if(username == null)
			throw new NotLoggedInException();
		Student student = userManager.findStudentByEmail(studentEmail);
		if(student == null)
			throw new WrongParameterException();
		return student;
	}

	@Override
	public void ensureAllStudentsInAGroup() throws NotLoggedInException,NotValidProjectException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(alreadyEnsuredGroups)
			return;
		List<String> registeredStudents = projectManager.getRegisteredStudents(currentProject);
		for(int i=0; i < registeredStudents.size(); i++){
			if(!groupManager.hasAGroup(registeredStudents.get(i), currentProject))
				groupManager.createGroup(registeredStudents.get(i), null, null, "auto-single-group-"+registeredStudents.get(i), currentProject);
		}
		alreadyEnsuredGroups = true;
	}

	@Override
	public Group getCurrentGroup() throws NotLoggedInException,
			NotValidProjectException, NotValidGroupException {
		if(username == null)
			throw new NotLoggedInException();
		if(currentProject == null)
			throw new NotValidProjectException();
		if(currentGroup == 0)
			throw new NotValidGroupException();
		Group group = groupManager.findGroupByKey(currentGroup);
		if(group == null)
			throw new NotValidGroupException();
		return group;
	}

}
