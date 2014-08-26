package sessionBeans.stateless;
import java.util.List;

import javax.ejb.Local;

import entityBeans.Deadline;
import entityBeans.OverviewDocument;
import entityBeans.Project;
import exceptions.NotLoggedInException;
import exceptions.NotValidProjectException;
import exceptions.PermissionDeniedException;
import exceptions.WrongParameterException;

@Local
public interface ProjectManagerBeanLocal {
	
	public final int MIN_NUMBER_OF_DEADLINES = 1;
	
	/**
	 * It makes the student registered to a project which he has been joined to by a professor.
	 * It expects already checked parameters.
	 * @param studEmail student's email
	 * @param projectName name of project
	 * @throws NotValidProjectException projectName not valid
	 * @throws NotLoggedInException studEmail not valid
	 */
	public void registerStudentToProject(String studEmail, String projectName) throws NotValidProjectException, NotLoggedInException;
	
	/**
	 * It removes association if exists between student and project and if it is not yet register
	 * @param studentEMail student email
	 * @param projectName project name
	 */
	public void removeAssociation(String studentEMail,String projectName);
	/**
	 * It enables the students to a project
	 * @param projectName the project name
	 * @param studentEmail list of students' e-mails to enable
	 */
	public void joinStudentsToProject(String projectName, List<String> studentEmail);
	
	/**
	 * It returns the list of projects which the student is registered to 
	 * @param studEmail student's email
	 * @return list of projects of the student
	 */
	public List<Project> getListOfRegisterProjectsOfAStudent(String studEmail);
	
	/**
	 * It returns the list of projects which the student has been joined to by a
	 * professor (and not yet registered)
	 * @param studEmail student's email
	 * @return list of projects of the student
	 */
	public List<Project> getListOfEnabledButNotRegisterProjectsOfAStudent(String studEmail);
	
	/**
	 * It returns the list of deadlines of a given project
	 * @param projectName name of project
	 * @return list of deadlines
	 */
	public List<Deadline> getDeadlineListOfAProject(String projectName);
	
	/**
	 * It returns the list of names of projects created by a given professor
	 * @param profEmail professor's email
	 * @return list of names of projects
	 */
	public List<String> getListOfProjectKeysOfAProfessor(String profEmail);
	
	/**
	 * It checks if the candidate name of a project is free or if there is already
	 * another project with this name
	 * @param projectName the name to check
	 * @return true if the name is free and usable, false otherwise
	 */
	public boolean checkKeyIsFree(String projectName);
	
	/**
	 * It checks the candidate number of deadlines for a project 
	 * @param numOfDeadline number of deadline to check
	 * @return true if the number of deadline is ok, false otherwise
	 */
	public boolean checkNumberOfDeadlines(int numOfDeadline);
	
	/**
	 * It creates a new project. It expects already checked parameters.
	 * @param profEmail email of professor who creates the project
	 * @param projectName name of project
	 * @param numOfDeadline number of deadline of the project to be created
	 * @param deadlineNames names of deadlines
	 * @param deadlineDates dates of deadlines (they are ordered as the deadlines name)
	 * @param closureDate date of closure of the project, after which the upload function
	 * will be disabled
	 * @param fileId file id of the overview document of the project
	 * @throws WrongParameterException TODO
	 */
	public void createProject(String profEmail, String projectName, int numOfDeadline,
			List<String> deadlineNames, List<String> deadlineDates, String closureDate,
			int fileId) throws WrongParameterException;
	
	/**
	 * It deletes the project, after checking that the professor who is trying
	 * to delete the project is the same who created it. 
	 * @param projectName name of project to delete
	 * @param profEmail name of professor who are requesting to delete the project
	 * @throws PermissionDeniedException TODO
	 */
	public void deleteProject(String projectName, String profEmail) throws PermissionDeniedException;
	
	/**
	 * It returns the project overview
	 * @param fileId id of overview document
	 * @return the project overview
	 */
	public OverviewDocument getOverview(int fileId);
	
	/**
	 * It returns the project with the specified project name
	 * @param projectName project name to be retrieved
	 * @return project with the specified name
	 * @throws NotValidProjectException TODO
	 */
	public Project findProjectByKey(String projectName) throws NotValidProjectException;
	
	/**
	 * It returns all the students' e-mails registered to the project
	 * @param projectName project name
	 * @return the e-mails of all registered students
	 */
	public List<String> getRegisteredStudents(String projectName);
	
	/**
	 * Return the deadline or null if not present or wrong parameters 
	 * @param projectName
	 * @param deadlineDate
	 * @return
	 */
	public Deadline findDeadlineByKey(String projectName, String deadlineDate);
	
	/**
	 * Verify if the closure date of a project has expired
	 * @param projectName project name
	 * @return true if expired, false if not
	 */
	public boolean hasClosureDateExpired(String projectName);
}
