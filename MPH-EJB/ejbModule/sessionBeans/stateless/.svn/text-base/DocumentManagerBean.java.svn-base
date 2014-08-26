package sessionBeans.stateless;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import entityBeans.Deadline;
import entityBeans.GroupDocument;
import entityBeans.OverviewDocument;
import entityBeans.Group;


/**
 * Session Bean implementation class DocumentManagerBean
 */
@Stateless
public class DocumentManagerBean implements DocumentManagerBeanLocal {

	@PersistenceContext( unitName = "MPH" )
	private EntityManager entityManager;
	
	
    /**
     * Default constructor. 
     */
    public DocumentManagerBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public String download(int documentId, int groupId) {
		GroupDocument document = entityManager.find(GroupDocument.class, documentId);
		int visibileGroup = entityManager.find(Group.class, groupId).getViewedGroup();
		if (document.getGroup() == groupId || document.getGroup() == visibileGroup ) 
			return document.getPath();
		else
			return null;
	}

	@Override
	public List<GroupDocument> getDocumentsOfAGroup(int groupId) {
		Query query = entityManager.createQuery("SELECT d FROM GroupDocument AS d WHERE d.group = :groupID ORDER BY d.deadlineDate, d.uploadDate");
		query.setParameter("groupID", groupId);
		List<GroupDocument> documents = query.getResultList();
		System.out.println(documents.toString());
		return documents;
	}

	@Override
	public GroupDocument getLastDocumentOfAGroup(int groupId, Deadline deadline) {
		Timestamp deadlineDate = deadline.getKey().getDate();
		String projectName = deadline.getKey().getProject();
		Query query = entityManager.createQuery("SELECT d FROM GroupDocument AS d WHERE d.project = :projectName AND d.deadlineDate = :deadlineDate AND d.group = :groupID ORDER BY d.deadlineDate");
		query.setParameter("projectName", projectName);
		query.setParameter("groupID", groupId);
		query.setParameter("deadlineDate", deadlineDate);
		List<GroupDocument> documents = query.getResultList();
		System.out.println(documents );
		if (documents == null || documents.isEmpty()) {
			return null;
		}
		GroupDocument lastDocument = (GroupDocument)(documents.get(documents.size()-1));
		/*Timestamp last = documents.get(0).;
		GroupDocument lastDocument = null;
		for (GroupDocument doc : documents) {
			if (doc.getDeadlineDate().after(last)) {
				last = doc.getDeadlineDate();
				lastDocument = doc;
			}		
		}*/
		return lastDocument;
		//return null;
	}

	@Override
	public GroupDocument getFirstDocumentOfAGroup(int groupId, Deadline deadline) {
		Timestamp deadlineDate = deadline.getKey().getDate();
		String projectName = deadline.getKey().getProject();
		Query query = entityManager.createQuery("SELECT d FROM GroupDocument AS d WHERE d.project = :projectName AND d.deadlineDate = :deadlineDate AND d.group = :groupID ORDER BY d.deadlineDate");
		query.setParameter("projectName", projectName);
		query.setParameter("groupID", groupId);
		query.setParameter("deadlineDate", deadlineDate);
		List<GroupDocument> documents = query.getResultList();
		System.out.println(documents );
		if (documents == null || documents.isEmpty()) {
			return null;
		}
		GroupDocument lastDocument = (GroupDocument)(documents.get(0));
		return lastDocument;
	}

	@Override
	public void studentUpload(String filePath, String fileName,
			String studentEmail, int groupId, String projectName,
			String deadlineDate) {
		GroupDocument groupDocument = new GroupDocument();
		groupDocument.setPath(filePath);
		groupDocument.setName(fileName);
		groupDocument.setStudentEmail(studentEmail);
		groupDocument.setGroup(groupId);
		groupDocument.setProject(projectName);
		Date date = new Date();
		groupDocument.setUploadDate(new Timestamp(date.getTime()));
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date parsedClosureDate = null;
		try {
			parsedClosureDate = format.parse(deadlineDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		groupDocument.setDeadlineDate(new Timestamp(parsedClosureDate.getTime()));
		entityManager.persist(groupDocument);
	}

	@Override
	public int overviewUpload(String path) {
		OverviewDocument document = new OverviewDocument();
		document.setPath(path);
		
		System.out.println("set path: "+path);
		Date date = new Date();
		document.setUploadDate(new Timestamp(date.getTime()));
		System.out.println("set uploadTime");
		document.setName(""); // da valutare
		entityManager.persist(document);
		
		Query query = entityManager.createQuery("SELECT d.documentID FROM OverviewDocument AS d " +
				"WHERE d.path=:path");
		query.setParameter("path", path);
		int documentId = (Integer)query.getSingleResult();
		System.out.println(documentId);
		return documentId;
	
	}

	@Override
	public List<GroupDocument> getDocumentsByDeadline(String projectName,
			String deadlineDate) {
		Query query = entityManager.createQuery("SELECT d FROM GroupDocument AS d WHERE d.deadlineDate = :deadlineDate AND d.project = :projectName ORDER BY d.uploadDate");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
		Date date = null;
		try {
			date = sdf.parse(deadlineDate);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Timestamp timestamp = new Timestamp(date.getTime());
		query.setParameter("deadlineDate", timestamp);
		query.setParameter("projectName", projectName);
		List<GroupDocument> documents = query.getResultList();
		System.out.println(documents.toString());
		return documents;
	}

	@Override
	public String download(int documentId) {
		GroupDocument document = entityManager.find(GroupDocument.class, documentId);
		return document.getPath();
	}

}
