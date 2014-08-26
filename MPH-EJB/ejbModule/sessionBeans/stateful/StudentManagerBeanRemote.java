package sessionBeans.stateful;
import java.sql.Timestamp;
import java.util.List;

import javax.ejb.Remote;
import entityBeans.*;
import exceptions.*;

@Remote
public interface StudentManagerBeanRemote {
	
	/**
	 * Login of a student. Set the username state variable equal to the email of the student
	 * @param email official university email of the student
	 */
	public void login(String email);
	
	/**
	 * Logout of a student. Set the username variable and the state  equal to null
	 */
	public void logout();
	
	/**
	 * Retrieve the list of Projects to which the student is enabled (it also checks that the first deadline date 
	 * has not expired yet, otherwise the registration is no more possible)
	 * @return list of Project of the student to which he's enabled but not registered yet
	 * @throws NotLoggedInException student is not logged in
	 */
	public List<Project> getListOfEnableButNotRegisterProject() throws NotLoggedInException;
	
	/**
	 * Retrieve the list of Project to which the student is registered
	 * @return list of Project of the student to which he's registered to
	 * @throws NotLoggedInException student is not logged in
	 */
	public List<Project> getListOfRegisterProject() throws NotLoggedInException;
	
	/**
	 * Change the password associated with student account
	 * @param oldPassword old student password
	 * @param newPassword new student password
	 * @throws PasswordException if oldPassword is not the same registered in the database
	 * @throws NotLoggedInException student is not logged in
	 */
	public void changePassword(String oldPassword, String newPassword) throws PasswordException, NotLoggedInException;
	
	/**
	 * Register the student to a project for which he is enabled
	 * @param projectName unique name of the project to which the student wants to be registered
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid or student not enabled for this project.
	 */
	public void registerToProject(String projectName) throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Student enters a project area for which he is registered. The state variable currentProject is set
	 * equal to the name of the project selected
	 * @param projectName selected project name
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 */
	public void enterProjectArea(String projectName) throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Check if the student has already a group for the current project
	 * @return true only if the student has already a group for the current project
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 */
	public boolean hasAGroupInCurrentProject() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Retrieve the current project
	 * @return current project
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 */
	public Project getProject() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Retrieve the student group
	 * @return the student group in the current project
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws NotValidGroupException TODO
	 */
	public Group getGroup() throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Retrieve the viewed group of the current group if any
	 * @return the viewed group or null if the group has no visibility relation
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 */
	public Group getViewedGroup() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Retrieve deadline score of a specific deadline for the current group
	 * @param deadlineDate specific deadline date
	 * @return deadline score of the specified deadline or null if not present
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 */
	public DeadlineScore getDeadlineScore(Timestamp deadlineDate) throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Retrieve list of all deadlines of the current project
	 * @return list of all deadlines
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 */
	public List<Deadline> getDeadlines() throws NotLoggedInException, NotValidProjectException;
	
	/**
	 * Creation of a new group for the student, if he does not belong to another one
	 * @param components number of components of the group
	 * @param student1 email of another student or null if 1-person group
	 * @param student2 email of another student or null if 2-person group
	 * @param groupName name of the group
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws WrongParameterException emails not valid or number of components non valid
	 */
	public void createGroup(int components, String student1, String student2, String groupName) throws NotLoggedInException, NotValidProjectException, WrongParameterException;
	
	/**
	 * Retrieve the file path of a specific document. It can be a group document or an overview document 
	 * @param documentID unique ID of the document to be downloaded
	 * @param type "group" if group document or "overview" if project overview document
	 * @return file path of the specified document into the system
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws PermissionDeniedException overview document not of the current project, document not of the current group or document ID not valid
	 * @throws NotValidGroupException group ID not valid
	 */
	public String download(int documentID, String type) throws NotLoggedInException, NotValidProjectException, PermissionDeniedException, NotValidGroupException;
	
	/**
	 * Upload of a new group document
	 * @param deadlineDate date of the deadline associated with the document
	 * @param filePath file path where the document has been saved into the system
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws NotValidGroupException group ID not valid
	 */
	public void upload(String deadlineDate, String filePath) throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Retrieve the last document of the current group associated with a specific deadline
	 * @param deadline a deadline in the current project
	 * @return last document of the specified deadline or null if not present
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws NotValidGroupException group ID not valid
	 */
	public GroupDocument getLastDocument(Deadline deadline) throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Retrieve the list of all documents of the current group
	 * @return list of all documents of the current group
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws NotValidGroupException group ID not valid
	 */
	public List<GroupDocument> getAllDocuments() throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Retrieve the list of all documents of viewed group
	 * @return list of all documents of viewed group
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws NotValidGroupException group ID not valid
	 */
	public List<GroupDocument> getAllDocumentsOfViewedGroup() throws NotLoggedInException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Check if the current group has a relation of visibility with another one
	 * @return "true" only if the current group has a relation of visibility with another one
	 * @throws NotLoggedInException student is not logged in
	 * @throws NotValidProjectException project name not valid
	 * @throws NotValidGroupException group ID not valid
	 */
	public boolean hasViewedGroup() throws NotLoggedInException, NotValidProjectException, NotValidGroupException;

	/**
	 * Retrieve the name of the deadline with the specified date in the current project
	 * @param deadlineDate date of the deadline
	 * @return name of the deadline
	 * @throws WrongParameterException if the date does not correspond to a deadline in the current project
	 */
	public String getDeadlineName(Timestamp deadlineDate) throws WrongParameterException;
	
	/**
	 * getter of username
	 * @return the current username
	 */
	public String getUsername();
	
	/**
	 * reset state except username
	 */
	public void resetState();
	
	
}
