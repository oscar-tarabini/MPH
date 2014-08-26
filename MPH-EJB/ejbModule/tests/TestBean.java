package tests;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import entityBeans.Administrator;
import entityBeans.AssociationStudentProject;
import entityBeans.AssociationStudentProjectKey;
import entityBeans.Professor;
import entityBeans.Student;

/**
 * Session Bean implementation class TestBean
 */
@Stateless
public class TestBean implements TestBeanRemote {

	@PersistenceContext( unitName = "MPH" )
	private EntityManager entityManager;
	
    /**
     * Default constructor. 
     */
    public TestBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public void addProfessor(String email, String password, String firstName,
			String lastName, int profID) {
		Professor professor = new Professor(email, password, firstName, lastName, profID);
		entityManager.persist(professor);
		entityManager.flush();
	}

	@Override
	public void removeProfessor(String email) {
		Professor professor = entityManager.find(Professor.class, email);
		if (professor != null) {
			entityManager.remove(professor);
			entityManager.flush();
		}
	}

	@Override
	public void setAdmin(String username, String password) {
		Administrator admin = new Administrator();
		admin.setUsername(username);
		admin.setPassword(password);
		entityManager.persist(admin);
		entityManager.flush();
		
	}

	@Override
	public Professor retrieveProfessor(String profEmail) {
		return entityManager.find(Professor.class, profEmail);
		
	}

	@Override
	public void removeAdmin(String adminUsername) {
		Administrator admin = entityManager.find(Administrator.class, adminUsername);
		if(admin != null)
			entityManager.remove(admin);
		entityManager.flush();
		
	}

	@Override
	public boolean checkThereIsAssociation(String projectName, String studentEmail) {
		AssociationStudentProjectKey associationKey = new AssociationStudentProjectKey();
		associationKey.setProjectName(projectName);
		associationKey.setStudentEmail(studentEmail);
		AssociationStudentProject association = entityManager.find(AssociationStudentProject.class, associationKey);
		if(association == null)
			return false;
		else
			return true;
		
	}

	@Override
	public Student retrieveStudent(String studEmail) {
		return entityManager.find(Student.class, studEmail);
	}

	@Override
	public void removeStudent(String studEmail) {
		Student student = entityManager.find(Student.class, studEmail);
		if(student != null)
			entityManager.remove(student);
		entityManager.flush();
		
	}

	
}
