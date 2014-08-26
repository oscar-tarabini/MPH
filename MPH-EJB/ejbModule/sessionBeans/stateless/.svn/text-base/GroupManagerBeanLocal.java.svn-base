package sessionBeans.stateless;
import java.util.List;

import javax.ejb.Local;
import entityBeans.Group;
import exceptions.NotValidGroupException;
import exceptions.PermissionDeniedException;


@Local
public interface GroupManagerBeanLocal {

	/**
	 * Verify if a student has a group in a project. It requires that the student is
	 * registered to the project.
	 * @param studEmail the email of student
	 * @param projectName the name of project
	 * @return true if student has already a group, false otherwise
	 */
	public boolean hasAGroup(String studEmail, String projectName);
	
	/**
	 * creates a group in a project. It requires that the student are registered to
	 * the project and are not in other groups in the project.
	 * @param student1 the email of student 1 (cannot be null)
	 * @param student2 the email of student 2 (can be null)
	 * @param student3 the email of student 3 (can be null)
	 * @param groupName the name of the group
	 * @param projectName the name of the project
	 */
	public void createGroup(String student1,String student2, String student3,
			String groupName, String projectName);
	
	/**
	 * It returns the list of groups of a project.
	 * @param projectName the name of the project
	 * @return the list of groups of the project
	 */
	public List<Group> getGroupsOfAProject(String projectName);
	
	/**
	 * It returns the list of groups in a project that cannot see another group.
	 * @param projectName the name of the project
	 * @return the list of groups that cannot see another group
	 */
	public List<Group> getGroupsOfAProjectNotViewer(String projectName);
	
	/**
	 * It checks the name of a group is unique in a project
	 * @param groupName the group name
	 * @param projectName the project name
	 * @return true if group name is available for that project, false if it is already in use
	 */
	public boolean isThisGroupNameFreeInThisProject(String groupName, String projectName);
	
	/**
	 * It creates the visibility relation between two groups in a project
	 * @param groupIdViewer the group id that can view the other
	 * @param groupIdViewed the group id that is viewed by the other
	 * @throws PermissionDeniedException in case the relation cannot be established
	 */
	public void createVisibility(int groupIdViewer, int groupIdViewed) throws PermissionDeniedException;
	
	/**
	 * It returns the group that is viewed by groupIdViewer group
	 * @param groupIdViewer the group id 
	 * @return the group that is viewed by groupIdViewer group
	 */
	public Group getViewedGroup(int groupIdViewer);
	
	/**
	 * It returns the name of the group
	 * @param groupId group id
	 * @return the name of the group
	 */
	public String getGroupName(int groupId);
	
	/**
	 * It returns the group with the specified ID
	 * @param groupID ID of a group
	 * @return Group with the specified ID
	 * @throws NotValidGroupException if the groupID is not valid
	 */
	public Group findGroupByKey(int groupID) throws NotValidGroupException;
	

	/**
	 * Retrieve the group of a student
	 * @param studentEmail student email
	 * @param projectName project in which search the group
	 * @return the group or null if not found
	 */
	public Group getGroupOfAStudent(String studentEmail, String projectName);
	
	/**
	 * Save the final evaluation for the group and set isDefinitive
	 * @param score score of the group
	 * @param groupID group ID
	 * @throws NotValidGroupException TODO
	 */
	public void saveFinalEvaluation(int groupID, int score) throws NotValidGroupException;
}
