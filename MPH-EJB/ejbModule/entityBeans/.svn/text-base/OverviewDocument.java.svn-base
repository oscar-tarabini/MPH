package entityBeans;


import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.*;

@Entity
@Table(name="OverviewDocument")
public class OverviewDocument extends Document implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8800856769122672081L;

	@Id
	@Column(name="documentID")
	private int documentID;
	
	@Column(name="path")
	private String path;

	@Column(name="name")
	private String name;
	
	@Column(name="uploadDate")
	private Timestamp uploadDate;

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

}
