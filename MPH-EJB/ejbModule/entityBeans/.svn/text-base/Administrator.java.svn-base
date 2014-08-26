package entityBeans;

import java.io.Serializable;

import javax.persistence.*;

/**
 * this entity represents administrator
 * @author oscar
 *
 */
@Entity
@Table(name="Administrator")
public class Administrator implements Serializable {
	
	@Id
	@Column(name="username")
	private String username;
		
	@Column(name="password")
	private String password;

	/**
	 * getter of username
	 * @return username
	 */
	public String getUsername() {
		return username;
	}

	/**
	 * setter of username
	 * @param username
	 */
	public void setUsername(String username) {
		this.username = username;
	}
	
	/**
	 * getter of password
	 * @return password
	 */
	public String getPassword() {
		return password;
	}
	
	/**
	 * setter of password
	 * @param password
	 */
	public void setPassword(String password) {
		this.password = password;
	}
	
	
}
