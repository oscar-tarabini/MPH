package entityBeans;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * this class represents the key of a deadline score
 * @author oscar
 * 
 */
@Embeddable
public class DeadlineScoreKey implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5789881338392691009L;

	@Column (name = "project")
	private String project;
	
	@Column (name = "deadlineDate")
	private Timestamp deadlineDate;
	
	@Column (name = "groupID")
	private int groupID;

	
	public DeadlineScoreKey() {
		super();
	}

	public DeadlineScoreKey(String project, Timestamp deadlineDate, int groupID) {
		super();
		this.project = project;
		this.deadlineDate = deadlineDate;
		this.groupID = groupID;
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
	 * @param project this is the project name
	 */
	public void setProject(String project) {
		this.project = project;
	}

	/**
	 * getter of the deadline's date
	 * @return deadline's date
	 */
	public Timestamp getDeadlineDate() {
		return deadlineDate;
	}

	/**
	 * setter of deadline date
	 * @param deadlineDate
	 */
	public void setDeadlineDate(Timestamp deadlineDate) {
		this.deadlineDate = deadlineDate;
	}

	/**
	 * getter of group id
	 * @return group id
	 */
	public int getGroupID() {
		return groupID;
	}

	/**
	 * setter of group id
	 * @param groupID
	 */
	public void setGroupID(int groupID) {
		this.groupID = groupID;
	}

	@Override
	public boolean equals(Object obj) {
		if(obj == this) return true;
		if(!(obj instanceof DeadlineScoreKey)) return false;
		DeadlineScoreKey other = (DeadlineScoreKey) obj;
		return (other.getProject().equals(project) &&
				other.getDeadlineDate().equals(deadlineDate) &&
				other.getGroupID() == groupID);
	}

	@Override
	public int hashCode() {
		return (project+deadlineDate+groupID).hashCode();
	}
	
	
	
}
