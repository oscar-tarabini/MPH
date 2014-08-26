package sessionBeans.stateless;
import javax.ejb.Local;

import entityBeans.Administrator;
import entityBeans.Professor;
import entityBeans.Student;
import exceptions.LoginFailException;
import exceptions.ProfessorCreationException;
import exceptions.StudentCreationException;
import exceptions.WrongParameterException;

@Local
public interface UserManagerBeanLocal {
	
	/**
	 * This method registers in the database a new student's account and send
	 * a mail with a random generated password to the student email 
	 * @param email the student's institutional email
	 * @param firstName student's first name
	 * @param lastName student's last name
	 * @param studentID institutional id number of the student
	 * @throws StudentCreationException in case of something went wrong in creation 
	 * (e.g. wrong or missing parameters, email already existent...), the student is not created 
	 */
	public void createNewStudent(String email,String firstName,
			String lastName, String studentID) throws StudentCreationException;
	
	/**
	 * This method registers in the database a new professor's account
	 * and send a mail with a random generated password to the professor email 
	 * @param email the professor's institutional email
	 * @param firstName professor's first name
	 * @param lastName professor's last name
	 * @param professorID institutional id number of the professor
	 * @throws ProfessorCreationException in case of something went wrong in creation 
	 * (e.g. wrong or missing parameters, email already existent...), the professor is not created
	 */
	public void createNewProfessor(String email, String firstName,
			String lastName, String professorID) throws ProfessorCreationException;
	
	/**
	 * It deletes the professor associated with profEmail. If profEmail doesn't exist in
	 * database it returns normally. 
	 * @param profEmail the email of the professor to be deleted from the database
	 * @throws WrongParameterException if profEmail doesn't exist
	 */
	public void deleteProfessor(String profEmail) throws WrongParameterException;
	
	/**
	 * It retrieves user from database, checks password and return the type of user
	 * @param email the email of user 
	 * @param password the user's password
	 * @return "s" if the user is a student, "p" if is a professor 
	 * @throws LoginFailException in case user not found or wrong password
	 */
	public String userLogin(String email, String password) throws LoginFailException;
	
	/**
	 * It check username and password of administrator, returning the administrator if it matches
	 * @param username the username of administrator
	 * @param password the password
	 * @return the administrator if all parameters are correct, null otherwise
	 * @throws LoginFailException TODO
	 */
	public Administrator adminLogin(String username, String password) throws LoginFailException;
	
	/**
	 * Retrieve the professor registered with the given email
	 * @param email email of the professor
	 * @return Professor or null if not found
	 */
	public Professor findProfessorByEmail(String email);
	
	/**
	 * Retrieve the student registered with the given email
	 * @param email email of the student
	 * @return Student or null if not found
	 */
	public Student findStudentByEmail(String email);
	
}
