package entityBeans;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * this class represents the key of a deadline
 * @author oscar
 *
 */
@Embeddable
public class DeadlineKey implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9011311699161275868L;

	@Column(name = "project")
	private String project;
	
	// -------------------------------date sql ??? o date util ???-----------------
	// -----Cris: io direi date sql ha un getter che ritorna il formato jdbc-----;)
	@Column(name = "date")
	private Timestamp date;

	/**
	 * default constructor
	 */
	public DeadlineKey() {
		super();
	}

	/**
	 * constructor
	 * @param project the project name
	 * @param date the date of deadline
	 */
	public DeadlineKey(String project, Timestamp date) {
		super();
		this.project = project;
		this.date = date;
	}

	/**
	 * getter of project name
	 * @return project name
	 */
	public String getProject() {
		return project;
	}

	/**
	 * setter of project name
	 * @param project the project name
	 */
	public void setProject(String project) {
		this.project = project;
	}

	/**
	 * getter of date
	 * @return date
	 */
	public Timestamp getDate() {
		return date;
	}

	/**
	 * setter of date
	 * @param date 
	 */
	public void setDate(Timestamp date) {
		this.date = date;
	}


	@Override
	public boolean equals(Object obj) {
		if(obj == this) return true;
		if(!(obj instanceof DeadlineKey)) return false;
		DeadlineKey other = (DeadlineKey) obj;
		return (other.getProject().equals(project) && other.getDate().equals(date));
	}


	@Override
	public int hashCode() {
		return (project+date).hashCode();
	}
	


}
