package sessionBeans.stateless;
import java.util.List;

import javax.ejb.Local;

import entityBeans.DeadlineScore;
import exceptions.NotValidGroupException;
import exceptions.NotValidProjectException;
import exceptions.WrongParameterException;

@Local
public interface DeadlineScoreManagerBeanLocal {
	
	/**
	 * It updates the deadlineScore of a group (or it creates a new one if it doesn't exist yet).
	 * It expects correct parameters.
	 * @param projectName the name of the project
	 * @param deadlineDate the date of the evaluated deadline
	 * @param groupId the id of the evaluated group
	 * @param score the evaluation 
	 * @throws NotValidGroupException TODO
	 * @throws NotValidProjectException TODO
	 * @throws WrongParameterException TODO
	 */
	public void saveDeadlineScore(String projectName, String deadlineDate, int groupId, int score) throws NotValidGroupException, NotValidProjectException, WrongParameterException;

	/**
	 * compute the penalty for late delivery for a group w.r.t. a deadline. The method
	 * requires that at least one document of the group for that deadline exists. The
	 * penalty is zero if the document was delivered punctually, otherwise it's computed
	 * proportionally to the delay of delivery.
	 * @param groupId the group id
	 * @param projectName the project name
	 * @param deadlineDate the date of deadline over which the penalty is computed
	 * @return the penalty a value between 0 (no penalty) and 7 (max penalty)
	 * @throws WrongParameterException TODO
	 * @throws NotValidProjectException TODO
	 * @throws NotValidGroupException TODO
	 */
	public int computePenalty(int groupId, String projectName, String deadlineDate ) throws WrongParameterException, NotValidProjectException, NotValidGroupException;
	
	/**
	 * Retrieve the deadlineScore associated with the specified key.
	 * @param projectName project name
	 * @param deadlineDate date of the deadline
	 * @param groupId group id
	 * @return score for the group for the specified deadline or null if not present
	 * @throws NotValidProjectException TODO
	 * @throws NotValidGroupException TODO
	 * @throws WrongParameterException if deadlineDate is invalid
	 */
	public DeadlineScore findDeadlineScoreByKey(String projectName, String deadlineDate, int groupId) throws NotValidProjectException, NotValidGroupException, WrongParameterException;
	
	/**
	 * Create, if not already present, an empty deadline score for the group for the specified deadline.
	 * @param projectName project name
	 * @param deadlineDate deadline date
	 * @param groupId group id
	 * @throws NotValidGroupException TODO
	 * @throws NotValidProjectException TODO
	 * @throws WrongParameterException TODO
	 */
	public void initializeDeadlineScore(String projectName, String deadlineDate, int groupId) throws NotValidGroupException, NotValidProjectException, WrongParameterException;
	
}
