package entityBeans;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.*;

@Entity
@Table(name="Project")
public class Project implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8267399271689510615L;

	@Id
	@Column(name="name")
	private String name;
	
	@Column(name="closureDate")
	private Timestamp closureDate;
	
	@Column(name="professorEmail")
	private String professorEmail;
	
	@Column(name="overviewDocument")
	private int overviewDocument;

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
	 * @return the closureDate
	 */
	public Timestamp getClosureDate() {
		return closureDate;
	}

	/**
	 * @param closureDate the closureDate to set
	 */
	public void setClosureDate(Timestamp closureDate) {
		this.closureDate = closureDate;
	}

	/**
	 * @return the professorEmail
	 */
	public String getProfessorEmail() {
		return professorEmail;
	}

	/**
	 * @param professorEmail the professorEmail to set
	 */
	public void setProfessorEmail(String professorEmail) {
		this.professorEmail = professorEmail;
	}

	/**
	 * @return the overviewDocument
	 */
	public int getOverviewDocument() {
		return overviewDocument;
	}

	/**
	 * @param overviewDocument the overviewDocument to set
	 */
	public void setOverviewDocument(int overviewDocument) {
		this.overviewDocument = overviewDocument;
	}
}
