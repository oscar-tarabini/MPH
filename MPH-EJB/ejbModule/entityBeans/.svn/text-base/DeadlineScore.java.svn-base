package entityBeans;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name="DeadlineScore")
public class DeadlineScore implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -736697046014340091L;

	public DeadlineScore() {
		super();
	}
	
	public DeadlineScore(DeadlineScoreKey key, int scoreNoPenalty, int penalty) {
		super();
		this.key = key;
		this.scoreNoPenalty = scoreNoPenalty;
		this.penalty = penalty;
	}

	@EmbeddedId
	private DeadlineScoreKey key;
	
	@Column(name = "scoreNoPenalty")
	private int scoreNoPenalty;
	
	@Column(name = "penalty")
	private int penalty;
	
	/**
	 * getter of key
	 * @return key
	 */
	public DeadlineScoreKey getKey() {
		return key;
	}

	/**
	 * setter of key
	 * @param key
	 */
	public void setKey(DeadlineScoreKey key) {
		this.key = key;
	}

	/**
	 * getter of score without penalty
	 * @return score without penalty
	 */
	public int getScoreNoPenalty() {
		return scoreNoPenalty;
	}

	/**
	 * setter of score without penalty
	 * @param scoreNoPenalty
	 */
	public void setScoreNoPenalty(int scoreNoPenalty) {
		this.scoreNoPenalty = scoreNoPenalty;
	}

	/**
	 * getter of penalty
	 */
	public int getPenalty() {
		return penalty;
	}

	/**
	 * setter of penalty
	 * @param penalty computed penalty
	 */
	public void setPenalty(int penalty) {
		this.penalty = penalty;
	}
		
}
