package entityBeans;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import javax.persistence.*;

@Entity
@Table(name="GroupDocument")
public class GroupDocument extends Document implements Serializable  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8378935109118301684L;

	@Id
	@Column(name="documentID")
	private int documentID;
	
	@Column(name="path")
	private String path;

	@Column(name="name")
	private String name;
	
	@Column(name="uploadDate")
	private Timestamp uploadDate;
	
	@Column(name="studentEmail")
	private String studentEmail;
	
	@Column(name="`group`")
	private int group;
	
	@Column(name="project")
	private String project;
	
	@Column(name="deadlineDate")
	private Timestamp deadlineDate;

	/**
	 * @return the documentID
	 */
	public int getDocumentID() {
		return documentID;
	}

	/**
	 * @param documentID the documentID to set
	 */
	public void setDocumentID(int documentID) {
		this.documentID = documentID;
	}

	/**
	 * @return the path
	 */
	public String getPath() {
		return path;
	}

	/**
	 * @param path the path to set
	 */
	public void setPath(String path) {
		this.path = path;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the uploadDate
	 */
	public Timestamp getUploadDate() {
		return uploadDate;
	}

	/**
	 * @param uploadDate the uploadDate to set
	 */
	public void setUploadDate(Timestamp uploadDate) {
		this.uploadDate = uploadDate;
	}

	/**
	 * @return the studentEmail
	 */
	public String getStudentEmail() {
		return studentEmail;
	}

	/**
	 * @param studentEmail the studentEmail to set
	 */
	public void setStudentEmail(String studentEmail) {
		this.studentEmail = studentEmail;
	}

	/**
	 * @return the group
	 */
	public int getGroup() {
		return group;
	}

	/**
	 * @param group the group to set
	 */
	public void setGroup(int group) {
		this.group = group;
	}

	/**
	 * @return the project
	 */
	public String getProject() {
		return project;
	}

	/**
	 * @param project the project to set
	 */
	public void setProject(String project) {
		this.project = project;
	}

	/**
	 * @return the deadlineDate
	 */
	public Timestamp getDeadlineDate() {
		return deadlineDate;
	}

	/**
	 * @param deadlineDate the deadlineDate to set
	 */
	public void setDeadlineDate(Timestamp deadlineDate) {
		this.deadlineDate = deadlineDate;
	}
}
