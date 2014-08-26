package sessionBeans.stateful;

import javax.ejb.EJB;
import javax.ejb.Stateful;

import sessionBeans.stateless.UserManagerBeanLocal;

import exceptions.NotLoggedInException;
import exceptions.ProfessorCreationException;
import exceptions.WrongParameterException;

/**
 * Session Bean implementation class AdministratorManagerBean
 */
@Stateful
public class AdministratorManagerBean implements AdministratorManagerBeanRemote {

	private boolean isLoggedIn;
	
	@EJB 
	private UserManagerBeanLocal userManager;
	
    /**
     * Default constructor. 
     */
    public AdministratorManagerBean() {
        isLoggedIn = false;
    }

	@Override
	public void login() {
		isLoggedIn = true;
		
	}

	@Override
	public void logout() {
		isLoggedIn = false;
		
	}

	@Override
	public void registerProfessor(String email, String firstName, String lastName, String professorID)
			throws NotLoggedInException, ProfessorCreationException {
		
		if (!isLoggedIn) 
			throw new NotLoggedInException();
		try{
			userManager.createNewProfessor(email, firstName, lastName, professorID);
		} catch (ProfessorCreationException pce){
			throw pce;
		}
	}

	@Override
	public void deleteProfessor(String email) throws NotLoggedInException, WrongParameterException {
		if(!isLoggedIn)
			throw new NotLoggedInException();
		try{
			userManager.deleteProfessor(email);
		} catch (WrongParameterException wpe){
			throw wpe;
		}
		
	}

}
