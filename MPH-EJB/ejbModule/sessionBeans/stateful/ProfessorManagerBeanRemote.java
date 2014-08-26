package sessionBeans.stateful;
import java.sql.Timestamp;
import java.util.List;

import javax.ejb.Remote;

import entityBeans.Deadline;
import entityBeans.DeadlineScore;
import entityBeans.Group;
import entityBeans.GroupDocument;
import entityBeans.Project;
import entityBeans.Student;
import exceptions.NotLoggedInException;
import exceptions.NotValidGroupException;
import exceptions.NotValidProjectException;
import exceptions.PasswordException;
import exceptions.PermissionDeniedException;
import exceptions.WrongParameterException;


@Remote
public interface ProfessorManagerBeanRemote {
	
	/**
	 * Login of a professor. Set the state variable username equal to the email of the professor
	 * @param email official university email of the professor
	 */
	public void login(String email);
	
	/**
	 * Logout of a professor. Set the state variable username equal to null
	 */
	public void logout();
	
	/**
	 * Change the password associated with professor account
	 * @param oldPassword old professor password
	 * @param newPassword new professor password
	 * @throws PasswordException if oldPassword is not the same registered in the database
	 * @throws NotLoggedInException professor can not change password if not logged in
	 */
	public void changePassword(String oldPassword, String newPassword) throws PasswordException, NotLoggedInException;
	
	/**
	 * getter of professor username
	 * @return current professor username
	 */
	public String getProfessorUsername();
	
	/**
	 * Retrieve the list of project keys (the project name) created by the professor
	 * @return list of project name created by the professor
	 * @throws NotLoggedInException professor can not see the list of his project if not logged in
	 */
	public List<String> getListOfProjectKeys() throws NotLoggedInException;
	
	/**
	 * Create a new project for the professor, with its deadlines, and enables students to register. 
	 * The availability of project name has already been checked
	 * @param projectName unique project name
	 * @param numberOfDeadlines number of deadlines associated with the project
	 * @param deadlineNames names of the deadlines
	 * @param deadlineDates dates of the deadlines
	 * @param closureDate date of the closure of the project
	 * @param enabledStudEmail list of email of students to enable to the project
	 * @throws NotLoggedInException professor can not create a project if not logged in
	 * @throws WrongParameterException TODO
	 */
	public void createProject(String projectName, int numberOfDeadlines, List<String> deadlineNames, List<String> deadlineDates, String closureDate, List<String> enabledStudEmail) throws NotLoggedInException, WrongParameterException;
	
	/**
	 * It checks name and number of deadline used to create a new project
	 * @param projectName the name to check
	 * @param numDeadline the number of deadline to check 
	 * @return true if name is free and permitted and number of deadline acceptable, false if project name already used
	 * @throws NotLoggedInException if professor not logged in
	 * @throws WrongParameterException the name is bad formed or numDeadline not in allowed range
	 */
	public boolean isProjectInitialOk(String projectName, int numDeadline) throws NotLoggedInException,WrongParameterException;
	
	
	/**
	 * Professor selects a project to manage. The state variable current project is set with
	 * the name of the project selected and currentGroup to null
	 * @param projectName the name of current project to set
	 * @throws NotLoggedInException professor can not enter a project area if not logged in
	 * @throws NotValidProjectException if projectName is not a project of the professor
	 */
	public void enterProjectArea(String projectName) throws NotLoggedInException,NotValidProjectException;
	
	/**
	 * It returns the student identified by his email
	 * @param studentEmail student's email
	 * @return the Student
	 * @throws NotLoggedInException if professor not logged in
	 * @throws WrongParameterException if student doesn't exist
	 */
	public Student getStudent(String studentEmail) throws NotLoggedInException, WrongParameterException;
	/**
	 * Retrieve the list of Deadline associated with the current project
	 * @return list of Deadline of the current project
	 * @throws NotLoggedInException professor can not see the list of deadline if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 */
	public List<Deadline> getDeadlines() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * It resets current group and username
	 * @throws NotLoggedInException  if not logged in
	 */
	public void resetState() throws NotLoggedInException;
	
	/**
	 * Retrieve the current project the professor is managing
	 * @return the current project
	 * @throws NotLoggedInException professor can not get the current project if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 */
	public Project getProject() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Check if the closure date is passed, and if so delete the current project. Set the state
	 * variable currentProject to null
	 * @throws NotLoggedInException professor can not delete a project if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws PermissionDeniedException the closure date is not yet expired
	 */
	public void deleteProject() throws NotLoggedInException, NotValidProjectException, PermissionDeniedException;
	
	/**
	 * Retrieve a list of GroupDocument associated with a specific deadline in the current project
	 * @param deadlineDate deadline date of the current project
	 * @return list of GroupDocument of this deadline
	 * @throws NotLoggedInException professor can not get documents if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws WrongParameterException TODO
	 */
	public List<GroupDocument> getDocumentsByDeadline(String deadlineDate) throws NotLoggedInException, NotValidProjectException, WrongParameterException;
	
	/**
	 * Retrieve a list of Group registered to the current project
	 * @return list of group of the current project
	 * @throws NotLoggedInException professor can not get groups if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 */
	public List<Group> getGroups() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Get the group name given a group ID, which identifies uniquely a group in the system
	 * @param groupID ID of a group
	 * @return name of the specified group
	 * @throws NotLoggedInException professor can not get the group name if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws WrongParameterException TODO
	 */
	public String getGroupName(int groupID) throws NotLoggedInException, NotValidProjectException, WrongParameterException;
	
	/**
	 * Retrieve the list of Group that are not viewer of another group. In another word the groups for which
	 * the professor has not enabled yet visibility over another one.
	 * @return list of group without visibility relation
	 * @throws NotLoggedInException professor can not get groups if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 */
	public List<Group> getGroupsNotViewer() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Create a relation of visibility between two groups. After that group1 can view documents of group2
	 * @param groupID1 viewer group ID
	 * @param groupID2 viewed group ID
	 * @throws NotLoggedInException professor can not create visibility if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws PermissionDeniedException if the group1 views already a group or a group is not part of the
	 * 			project managed by the professor
	 */
	public void createVisibility(int groupID1, int groupID2) throws NotLoggedInException, NotValidProjectException, PermissionDeniedException;
	
	/**
	 * Retrieve the file path where the document is stored into the system
	 * @param documentID unique ID of the document to be downloaded
	 * @return file path of the document chosen
	 * @throws NotLoggedInException professor can not download if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws PermissionDeniedException the document does no belong to the project managed by the professor
	 */
	public String download(int documentID) throws NotLoggedInException, NotValidProjectException, PermissionDeniedException;
	
	/**
	 * Enter the page of a Group. Set the currentGroup state variable equal to the ID of the group
	 * @param groupID ID of the group chosen
	 * @throws NotLoggedInException professor can not enter a group page if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the group ID is not valid
	 * @throws WrongParameterException TODO
	 */
	public void enterGroupPage(int groupID) throws NotLoggedInException, NotValidProjectException, NotValidGroupException, WrongParameterException;
	
	/**
	 * Retrieve the DeadlineScore of the current group
	 * @param deadlineDate date of the deadline
	 * @return deadline score for the current group or null if not present
	 * @throws NotLoggedInException professor can not get deadline score if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the current group ID is not valid
	 * @throws WrongParameterException TODO
	 */
	public DeadlineScore getDeadlineScoreOfAGroup(String deadlineDate) throws NotLoggedInException, NotValidProjectException, NotValidGroupException, WrongParameterException;
	
	/**
	 * Retrieve the list of all documents of the current group
	 * @return list of document of the current group
	 * @throws NotLoggedInException professor can not get documents if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the current group ID is not valid
	 */
	public List<GroupDocument> getDocumentsOfAGroup() throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Create a deadline score for the specified deadline for the current group
	 * @param deadlineDate date of the deadline being evaluated
	 * @param score score assigned by the professor
	 * @throws NotLoggedInException professor can not evaluate documents if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the current group ID is not valid
	 * @throws WrongParameterException deadline date not valid
	 */
	public void evaluateDeadline(String deadlineDate, int score) throws NotLoggedInException, NotValidProjectException, NotValidGroupException, WrongParameterException;
	
	/**
	 * Initialize deadline score not created (setting 0 as score), check scores is between range and set
	 * scores given as parameter to specified deadline
	 * @param deadlineDates list of deadline dates
	 * @param deadlineScores list of score associated with deadlines
	 * @throws NotLoggedInException professor can not evaluate deadlines if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the current group ID is not valid
	 * @throws WrongParameterException some deadline date not valid or some score not valid
	 */
	public void finalEvaluation(List<String> deadlineDates, List<Integer> deadlineScores) throws NotLoggedInException, NotValidProjectException, NotValidGroupException, WrongParameterException;
	
	/**
	 * Compute penalty of a deadline for the current group and save it in deadline score
	 * @param deadlineDate deadline of the current project
	 * @return penalty for the current group on this deadline
	 * @throws NotLoggedInException professor can not compute penalty if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the current group ID is not valid
	 * @throws WrongParameterException TODO
	 */
	public int computePenalty(String deadlineDate) throws NotLoggedInException, NotValidProjectException, NotValidGroupException, WrongParameterException;
	
	/**
	 * Retrieve all deadline score of the current group and compute the final score
	 * @return the computed final score
	 * @throws NotLoggedInException professor can not compute final score if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the current group ID is not valid
	 */
	public int computeFinalScore() throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Confirm the evaluation and it is made definitive. Set the finalScore and isDefinitive on the Group
	 * @param finalScore final score of the current group
	 * @throws NotLoggedInException professor can not confirm evaluation if not logged in
	 * @throws NotValidProjectException professor has not selected a project or currentProject is invalid
	 * @throws NotValidGroupException the current group ID is not valid
	 * @throws WrongParameterException TODO
	 */
	public void confirmFinalEvaluation(int finalScore) throws NotLoggedInException, NotValidProjectException, NotValidGroupException, WrongParameterException;
	
	/**
	 * Retrieve the name of a deadline with the specified date
	 * @param deadlineDate deadline date
	 * @return the name of the deadline
	 * @throws WrongParameterException if the deadline date is not valid
	 */
	public String getDeadlineName(Timestamp deadlineDate) throws WrongParameterException;

	/**
	 * It ensures that all students are in a group, and if it's not the case, it creates single group 
	 * for remaining register student without group
	 * @throws NotLoggedInException if professor not logged in
	 * @throws NotValidProjectException currentProject is invalid
	 *
	 */
	public void ensureAllStudentsInAGroup() throws  NotLoggedInException, NotValidProjectException, NotValidGroupException;

	/**
	 * Retrieve the current Group the professor is viewing
	 * @return current Group or null if the professor is outside the group area
	 * @throws NotLoggedInException if professor not logged in
	 * @throws NotValidProjectException currentProject is invalid
	 * @throws NotValidGroupException currentGroup is invalid
	 */
	public Group getCurrentGroup() throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
}
