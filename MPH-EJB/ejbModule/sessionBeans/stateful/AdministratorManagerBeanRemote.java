package sessionBeans.stateful;
import javax.ejb.Remote;

import exceptions.NotLoggedInException;
import exceptions.ProfessorCreationException;
import exceptions.WrongParameterException;

@Remote
public interface AdministratorManagerBeanRemote {
	
	/**
	 * Login of administrator. Set the state variable isLoggedIn to true
	 */
	public void login();
	
	/**
	 * Logout of administrator. Set the state variable isLoggedIn to false
	 */
	public void logout();
	
	/**
	 * Create a new account for a professor in such a way that he can login to MPH.
	 * @param email official university email of the professor
	 * @param firstName first name of the professor
	 * @param lastName last name of the professor
	 * @param professorID unique ID assigned by university to the professor
	 * @throws NotLoggedInException administrator can not register a new professor if not logged in
	 * @throws ProfessorCreationException TODO
	 */
	public void registerProfessor(String email,String firstName, 
			String lastName, String professorID) throws NotLoggedInException, ProfessorCreationException;
	
	/**
	 * Delete a MPH account of a professor
	 * @param email official university email of the professor
	 * @throws NotLoggedInException administrator can not delete a professor account if not logged in
	 */
	public void deleteProfessor(String email) throws NotLoggedInException, WrongParameterException;
	
}
