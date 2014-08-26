package entityBeans;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="Professor")
public class Professor implements Serializable {
		
	/**
	 * 
	 */
	private static final long serialVersionUID = 6567336152796021358L;

	@Id
	@Column(name="email")
	private String email;
		
	@Column(name="password")
	private String password;
		
	@Column(name="firstName")
	private String firstName;
	
	@Column(name="lastName")
	private String lastName;
		
	@Column(name="professorID")
	private int professorID;

	public Professor() {
		
	}
	
	public Professor(String email, String password, String firstName,
			String lastName, int professorID) {
		super();
		this.email = email;
		this.password = password;
		this.firstName = firstName;
		this.lastName = lastName;
		this.professorID = professorID;
	}
	
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public int getProfessorID() {
		return professorID;
	}

	public void setProfessorID(int professorID) {
		this.professorID = professorID;
	}

}
