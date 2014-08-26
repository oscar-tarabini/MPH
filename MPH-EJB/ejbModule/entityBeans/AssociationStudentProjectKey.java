package entityBeans;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * This class represents the unique identifier for {@link AssociationStudentProjectKey }
 * entity bean's instances.
 * It encapsulates the identifiers of {@link Student} and {@link Project}, indicating
 * that a student has been joined to a project. 
 */
@Embeddable
public class AssociationStudentProjectKey implements Serializable {

	//private static final long serialVersionUID = 1L;
	
	@Column(name = "studentEmail")
	private String studentEmail;
	
	@Column(name = "project")
	private String projectName;
	
	/**
	 * Constructor
	 * @param studentEmail student email
	 * @param projectName project name
	 */
	public AssociationStudentProjectKey(String studentEmail, String projectName) {
		super();
		this.studentEmail = studentEmail;
		this.projectName = projectName;
	}
	
	
	/**
	 * default constructor required by EJB
	 */
	public AssociationStudentProjectKey() {
		
	}


	/**
	 * getter of student email
	 * @return student email
	 */
	public String getStudentEmail() {
		return studentEmail;
	}

	/**
	 * setter of student email
	 * @param studentEmail student email to set
	 */
	public void setStudentEmail(String studentEmail) {
		this.studentEmail = studentEmail;
	}


	/**
	 * getter of project name
	 * @return project name
	 */
	public String getProjectName() {
		return projectName;
	}

	/**
	 * setter of project name
	 * @param projectName project name to set
	 */
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}


	@Override
	public boolean equals(Object obj) {
		if(obj == this) return true;
		if(!(obj instanceof AssociationStudentProjectKey)) return false;
		AssociationStudentProjectKey other = (AssociationStudentProjectKey) obj;
		return (other.getStudentEmail().equals(studentEmail) && other.getProjectName().equals(projectName));
		
	}


	@Override
	public int hashCode() {
		return (studentEmail+projectName).hashCode();
	}
	
	
	

}
