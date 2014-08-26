package sessionBeans.stateless;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import entityBeans.DeadlineScore;
import entityBeans.DeadlineScoreKey;
import entityBeans.GroupDocument;
import exceptions.NotLoggedInException;
import exceptions.NotValidGroupException;
import exceptions.NotValidProjectException;
import exceptions.WrongParameterException;

/**
 * Session Bean implementation class DeadlineScoreManagerBean
 */
@Stateless
public class DeadlineScoreManagerBean implements DeadlineScoreManagerBeanLocal {

	@PersistenceContext( unitName = "MPH" )
	private EntityManager entityManager;
	
    /**
     * Default constructor. 
     */
    public DeadlineScoreManagerBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public void saveDeadlineScore(String projectName, String deadlineDate,
			int groupId, int score) throws NotValidGroupException, NotValidProjectException, WrongParameterException {
		if (projectName == null)
			throw new NotValidProjectException();
		if (deadlineDate == null)
			throw new WrongParameterException();
		if (groupId == 0)
			throw new NotValidGroupException();
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = format.parse(deadlineDate);
		} catch (ParseException e) {
			throw new WrongParameterException();
		}
		if (date == null)
			throw new WrongParameterException();
		Timestamp timestamp = new Timestamp(date.getTime());
		DeadlineScoreKey key = new DeadlineScoreKey(projectName, timestamp, groupId);
		DeadlineScore deadlineScore = entityManager.find(DeadlineScore.class, key);
		if (deadlineScore == null)
			throw new WrongParameterException();
		deadlineScore.setScoreNoPenalty(score);
		entityManager.merge(deadlineScore);
		entityManager.flush();
	}

	@Override
	public int computePenalty(int groupId, String projectName,
			String deadlineDate) throws WrongParameterException, NotValidProjectException, NotValidGroupException {
		if (projectName == null)
			throw new NotValidProjectException();
		if (deadlineDate == null)
			throw new WrongParameterException();
		if (groupId == 0)
			throw new NotValidGroupException();
		DeadlineScore deadlineScore = findDeadlineScoreByKey(projectName, deadlineDate, groupId);
			
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = format.parse(deadlineDate);
		} catch (ParseException e) {
			throw new WrongParameterException();
		}
		if (date == null)
			throw new WrongParameterException();
		Timestamp timestamp = new Timestamp(date.getTime());
		
		Query query = entityManager.createQuery("SELECT d FROM GroupDocument AS d WHERE d.project = :projectName AND d.deadlineDate = :deadlineDate AND d.group = :groupID ORDER BY d.deadlineDate");
		query.setParameter("projectName", projectName);
		query.setParameter("groupID", groupId);
		query.setParameter("deadlineDate", timestamp);
		List<GroupDocument> documents = query.getResultList();
		System.out.println(documents);
		int penalty = 0;
		System.out.println("start computation penalty");
		if (documents != null && !documents.isEmpty()) {
			GroupDocument lastDocument = (GroupDocument)(documents.get(0));
			
			long timeDifference = lastDocument.getUploadDate().getTime() - deadlineScore.getKey().getDeadlineDate().getTime();
			System.out.println("tempDiff " + timeDifference);
			System.out.println("millis upload " + lastDocument.getUploadDate().getTime());
			if (timeDifference > 0) {
				long millisInADay = 3600*24*1000;
				penalty = (int)(timeDifference / millisInADay) + 1;
				if (penalty > 9) {
					penalty = 9;
				}
			} else {
				penalty = 0;
			}
		} else {
			// no penalty to be computed
			penalty = 0;
		}
		System.out.println("penalty calculated : " + penalty);
		deadlineScore.setPenalty(penalty);
		entityManager.merge(deadlineScore);
		entityManager.flush();
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return penalty;
	}

	@Override
	public DeadlineScore findDeadlineScoreByKey(String projectName,
			String deadlineDate, int groupId) throws NotValidProjectException, NotValidGroupException, WrongParameterException {
		if (projectName == null)
			throw new NotValidProjectException();
		if (deadlineDate == null)
			throw new WrongParameterException();
		if (groupId == 0)
			throw new NotValidGroupException();
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = format.parse(deadlineDate);
		} catch (ParseException e) {
			throw new WrongParameterException();
		}
		if (date == null)
			throw new WrongParameterException();
		Timestamp timestamp = new Timestamp(date.getTime());
		DeadlineScoreKey key = new DeadlineScoreKey(projectName, timestamp, groupId);
		DeadlineScore deadlineScore = entityManager.find(DeadlineScore.class, key);
		return deadlineScore;
	}

	@Override
	public void initializeDeadlineScore(String projectName,
			String deadlineDate, int groupId) throws NotValidGroupException, NotValidProjectException, WrongParameterException {
		if (projectName == null)
			throw new NotValidProjectException();
		if (deadlineDate == null)
			throw new WrongParameterException();
		if (groupId == 0)
			throw new NotValidGroupException();
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = format.parse(deadlineDate);
		} catch (ParseException e) {
			throw new WrongParameterException();
		}
		if (date == null)
			throw new WrongParameterException();
		Timestamp timestamp = new Timestamp(date.getTime());
		DeadlineScoreKey key = new DeadlineScoreKey(projectName, timestamp, groupId);
		if (entityManager.find(DeadlineScore.class, key) == null) {
			DeadlineScore score = new DeadlineScore(key, 0, 0);
			entityManager.persist(score);
			entityManager.flush();
		}
	}

}
