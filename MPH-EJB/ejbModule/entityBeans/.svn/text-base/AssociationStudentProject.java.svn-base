package entityBeans;

import java.io.Serializable;

import javax.persistence.*;

/**
 * This class contains a relation between a student and a project which 
 * he has been joined to by the professor. It also says if student has confirm
 * registration to the project
 * 
 * @author oscar
 *
 */
@Entity
@Table(name="AssociationStudentProject")
public class AssociationStudentProject implements Serializable {
	
	//private static final long serialVersionUID = 1L;
	
	@EmbeddedId
	private AssociationStudentProjectKey key;
	
	@Column(name="isRegistered")
	private boolean isRegistered;

	/**
	 * getter of key
	 * @return key
	 */
	public AssociationStudentProjectKey getKey() {
		return key;
	}
	
	/**
	 * setter of key
	 * @param key value to set
	 */
	public void setKey(AssociationStudentProjectKey key) {
		this.key = key;
	}
	
	/**
	 * getter of isRegistered
	 * @return true if student has confirm registration, false otherwise
	 */
	public boolean isRegistered() {
		return isRegistered;
	}

	/**
	 * setter of isRegistered
	 * @param isRegistered value to set
	 */
	public void setRegistered(boolean isRegistered) {
		this.isRegistered = isRegistered;
	}

	
}
