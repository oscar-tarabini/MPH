package sessionBeans.stateless;

import java.util.ArrayList;
import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import entityBeans.Group;
import exceptions.NotValidGroupException;
import exceptions.PermissionDeniedException;

/**
 * Session Bean implementation class GroupManagerBean
 */
@Stateless
public class GroupManagerBean implements GroupManagerBeanLocal {

	public final int NULL_ID_GROUP_RESERVED = 0;
	@PersistenceContext( unitName = "MPH" )
	private EntityManager entityManager;
	
	
    /**
     * Default constructor. 
     */
    public GroupManagerBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public boolean hasAGroup(String studEmail, String projectName) {
		//System.out.println("SELECT groupID FROM MPH.Group WHERE project='"+projectName+"' and " +
		//		"(student1='"+studEmail+"' or student2='"+studEmail+"' or student3='"+studEmail+"');");
		Query query = entityManager.createNativeQuery("SELECT groupID FROM MPH.Group WHERE project='"+projectName+"' and " +
				"(student1='"+studEmail+"' or student2='"+studEmail+"' or student3='"+studEmail+"');");
		List<Object> result = query.getResultList();
		if(result == null || result.size() == 0)
			return false;
		return true;
	}

	@Override
	public void createGroup(String student1, String student2, String student3,
			String groupName, String projectName) {
		
		Group group = new Group();
		
		List<String> students = new ArrayList<String>();
		students.add(student1);
		if(student2 != null && !student2.isEmpty())
			students.add(student2);
		if(student3 != null && !student3.isEmpty())
			students.add(student3);
		
		System.out.println(students);
		group.setFinalScore(0);
		group.setName(groupName);
		group.setStudents(students);
		group.setProject(projectName);
		group.setDefinitive(false);
		
		System.out.println("ok");
		entityManager.persist(group);
		System.out.println("qui no");
		entityManager.flush();
	}

	@Override
	public List<Group> getGroupsOfAProject(String projectName) {
		Query query = entityManager.createQuery("SELECT g FROM Group AS g WHERE g.project = :projectName ORDER BY g.name");
		query.setParameter("projectName", projectName);
		List<Group> groups = (List<Group>)(query.getResultList());
		return groups;
	}

	@Override
	public List<Group> getGroupsOfAProjectNotViewer(String projectName) {
		Query query = entityManager.createQuery("SELECT g FROM Group AS g WHERE g.project = :projectName AND g.viewedGroup = "+NULL_ID_GROUP_RESERVED+" ORDER BY g.name");
		query.setParameter("projectName", projectName);
		List<Group> groups = (List<Group>)(query.getResultList());
		return groups;
	}

	@Override
	public void createVisibility(int groupIdViewer, int groupIdViewed)
			throws PermissionDeniedException {
		Group group = entityManager.find(Group.class, groupIdViewer);
		group.setViewedGroup(groupIdViewed);
		entityManager.merge(group);
		
	}

	@Override
	public Group getViewedGroup(int groupIdViewer) {
		Group group = entityManager.find(Group.class, groupIdViewer);
		if (group == null)
			return null;
		Group viewedGroup = entityManager.find(Group.class, group.getViewedGroup());
		return viewedGroup;
	}

	@Override
	public String getGroupName(int groupId) {
		Group group = entityManager.find(Group.class, groupId);
		if (group == null)
			return null;
		return group.getName();
	}

	@Override
	public boolean isThisGroupNameFreeInThisProject(String groupName,
			String projectName) {
		
		Query query = entityManager.createNativeQuery("SELECT groupID FROM MPH.Group WHERE project='"+projectName+"' and " +
				"name='"+groupName+"';");
		System.out.println("SELECT groupID FROM MPH.Group WHERE project='"+projectName+"' and " +
				"name='"+groupName+"';");
		List<Object> result = query.getResultList();
		if(result == null || result.size() == 0)
			return true;
		return false;
	}

	@Override
	public Group findGroupByKey(int groupID) throws NotValidGroupException {
		Group group = entityManager.find(Group.class, groupID);
		if (group == null)
			throw new NotValidGroupException();
		return group;
	}


	@Override
	public Group getGroupOfAStudent(String studentEmail, String projectName) {
		Query query = entityManager.createQuery("SELECT g FROM Group AS g WHERE g.project = :projectName AND (g.student1 = :student1Email OR g.student2 = :student2Email OR g.student3 = :student3Email )");
		query.setParameter("projectName", projectName);
		query.setParameter("student1Email", studentEmail);
		query.setParameter("student2Email", studentEmail);
		query.setParameter("student3Email", studentEmail);
		Group group = (Group)(query.getSingleResult());
		return group;
	}

	@Override
	public void saveFinalEvaluation(int groupID, int score) throws NotValidGroupException {
		Group group = entityManager.find(Group.class, groupID);
		if (group == null)
			throw new NotValidGroupException();
		group.setFinalScore(score);
		group.setDefinitive(true);
		entityManager.merge(group);
		entityManager.flush();
	}

}
