package tests;
import javax.ejb.Remote;

import entityBeans.Professor;
import entityBeans.Student;

@Remote
public interface TestBeanRemote {
	
	public void addProfessor(String email, String password, String firstName, String lastName, int profID);
	
	public void removeProfessor(String email);

	public void setAdmin(String username, String password);

	public Professor retrieveProfessor(String profEmail);

	public void removeAdmin(String adminUsername);

	public boolean checkThereIsAssociation(String projectName, String string);

	public Student retrieveStudent(String studEmail);

	public void removeStudent(String student1);

}
