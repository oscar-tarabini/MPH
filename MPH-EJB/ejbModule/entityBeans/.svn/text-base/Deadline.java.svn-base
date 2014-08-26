package entityBeans;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * This entity represents a deadline
 * @author oscar
 *
 */
@Entity
@Table(name="Deadline")
public class Deadline implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4290057610777484349L;

	@EmbeddedId
	private DeadlineKey key;
	
	@Column(name = "name")
	private String name;

	public Deadline() {
		
	}
	
	public Deadline(DeadlineKey key, String name) {
		super();
		this.key = key;
		this.name = name;
	}

	/**
	 * getter of deadline key
	 * @return key
	 */
	public DeadlineKey getKey() {
		return key;
	}

	/**
	 * setter of deadline key
	 * @param key
	 */
	public void setKey(DeadlineKey key) {
		this.key = key;
	}
	
	/**
	 * getter of name of deadline
	 * @return name of deadline
	 */
	public String getName() {
		return name;
	}

	/**
	 * setter of deadline's name
	 * @param name 
	 */
	public void setName(String name) {
		this.name = name;
	}
	
	
}
