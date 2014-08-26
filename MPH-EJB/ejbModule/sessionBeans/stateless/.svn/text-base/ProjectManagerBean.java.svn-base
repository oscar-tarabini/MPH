package sessionBeans.stateless;

import java.io.File;
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

import entityBeans.AssociationStudentProject;
import entityBeans.AssociationStudentProjectKey;
import entityBeans.Deadline;
import entityBeans.DeadlineKey;
import entityBeans.DeadlineScoreKey;
import entityBeans.OverviewDocument;
import entityBeans.Project;
import exceptions.NotLoggedInException;
import exceptions.NotValidProjectException;
import exceptions.PermissionDeniedException;
import exceptions.WrongParameterException;

/**
 * Session Bean implementation class ProjectManagerBean
 */
@Stateless
public class ProjectManagerBean implements ProjectManagerBeanLocal {

	@PersistenceContext( unitName = "MPH" )
	private EntityManager entityManager;
	
	
    /**
     * Default constructor. 
     */
    public ProjectManagerBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public void registerStudentToProject(String studEmail, String projectName) throws NotValidProjectException, NotLoggedInException {
		if (studEmail == null)
			throw new NotLoggedInException();
		if (projectName == null)
			throw new NotValidProjectException();
		AssociationStudentProjectKey key = new AssociationStudentProjectKey(studEmail, projectName);
		AssociationStudentProject association = entityManager.find(AssociationStudentProject.class, key);
		if (association == null)
			throw new NotValidProjectException();
		association.setRegistered(true);
		
	}

	@Override
	public List<Project> getListOfEnabledButNotRegisterProjectsOfAStudent(
			String studEmail) {
		Query query = entityManager.createNativeQuery("SELECT a.project FROM MPH.AssociationStudentProject " +
				"as a  WHERE studentEmail='"+studEmail+"' AND a.isRegistered=false;");
		//query.setParameter("studentEmail", studEmail);
		//query.setParameter("isReg", "false");
		List<String> projectKeys = query.getResultList();
		List<Project> projects = new ArrayList<Project>();
		if(projectKeys != null){
			for(String projectName : projectKeys){
				Project proj = entityManager.find(Project.class, projectName);
				if(proj != null)
					projects.add(proj);
			}
		}
		
		return projects;
	}
	
	@Override
	public List<Project> getListOfRegisterProjectsOfAStudent(String studEmail) {
		Query query = entityManager.createNativeQuery("SELECT a.project FROM AssociationStudentProject AS a " +
				"WHERE a.studentEmail='"+studEmail+"' and a.isRegistered=true;");
		
		List<String> projectKeys = query.getResultList();
		List<Project> projects = new ArrayList<Project>();
		if(projectKeys != null){
			for(String projectName : projectKeys){
				Project proj = entityManager.find(Project.class, projectName);
				if(proj != null)
					projects.add(proj);
			}
		}
		
		return projects;
	}

	@Override
	public List<Deadline> getDeadlineListOfAProject(String projectName) {
		Query query = entityManager.createQuery("SELECT d FROM Deadline AS d WHERE d.key.project = :projectName ORDER BY d.key.date");
		query.setParameter("projectName", projectName);
		List<Deadline> deadlines = query.getResultList();
		return deadlines;
	}

	@Override
	public List<String> getListOfProjectKeysOfAProfessor(String profEmail) {
		Query query = entityManager.createQuery("SELECT p.name FROM Project AS p " +
				"WHERE p.professorEmail=:profEmail");
		query.setParameter("profEmail", profEmail);
		List<String> projectKeys = query.getResultList();
		// System.out.println(projectKeys);
		return projectKeys;
	}

	@Override
	public boolean checkKeyIsFree(String projectName) {
		Project existingProject = entityManager.find(Project.class, projectName);
		System.out.println("trovato progetto : " + existingProject);
		if(existingProject == null)
			return true;
		else
			return false;
	}

	@Override
	public boolean checkNumberOfDeadlines(int numOfDeadline) {
		if(numOfDeadline < MIN_NUMBER_OF_DEADLINES)
			return false;
		return true;
	}

	
	@Override
	public void createProject(String profEmail, String projectName,
			int numOfDeadline, List<String> deadlineNames,
			List<String> deadlineDates, String closureDate, int fileId) throws WrongParameterException {
		
		//project storage in database
		Project projectToCreate = new Project();
		projectToCreate.setName(projectName);
	
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date parsedClosureDate = null;
		try {
			parsedClosureDate = format.parse(closureDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		projectToCreate.setClosureDate(new Timestamp(parsedClosureDate.getTime()));
		projectToCreate.setOverviewDocument(fileId);
		projectToCreate.setProfessorEmail(profEmail);
		entityManager.persist(projectToCreate);
		
		//deadline storage in database
		for (int i = 0; i < deadlineNames.size(); i++) {
			Date date = null;
			try {
				date = format.parse(deadlineDates.get(i));
				Deadline deadline = new Deadline(new DeadlineKey(projectName, new Timestamp(date.getTime())), deadlineNames.get(i));
				entityManager.persist(deadline);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
		}
		entityManager.flush();
	}

	@Override
	public void deleteProject(String projectName, String profEmail) throws PermissionDeniedException {
		Project project = entityManager.find(Project.class, projectName);
		if (project == null)
			throw new PermissionDeniedException();
		if (!project.getProfessorEmail().equals(profEmail))
			throw new PermissionDeniedException();
		String currentDir = System.getProperty("jboss.home.dir");
		System.out.println("Current dir "+ currentDir);
		OverviewDocument overDocument = entityManager.find(OverviewDocument.class, project.getOverviewDocument());
		File documents = new File(currentDir + File.separator + "upload" + File.separator + "groupDocument" + File.separator +  projectName);
		System.out.println("Cancello " + documents.getAbsolutePath());
		Boolean hasDeleted = deleteDirectory(documents);
		if (!hasDeleted)
			System.out.println("GroupDocument not found");
		File overviewDocument = new File(currentDir + File.separator + "upload" + File.separator + "projectOverview" + File.separator + projectName + ".pdf");
		System.out.println("Cancello " + overviewDocument.getAbsolutePath());
		hasDeleted = overviewDocument.delete();
		if (!hasDeleted)
			System.out.println("OverviewDocument not found");
		System.out.println("Cancello " + project);
		entityManager.remove(project);
		entityManager.remove(overDocument);
		entityManager.flush();
	}

	@Override
	public OverviewDocument getOverview(int fileId) {
		return entityManager.find(OverviewDocument.class, fileId);
	}

	@Override
	public void joinStudentsToProject(String projectName,
			List<String> studentEmail) {
	
		if(studentEmail == null || studentEmail.size() == 0)
			return;
		System.out.println("begin join");
		for(int i=0; i< studentEmail.size(); i++){
			AssociationStudentProject association = new AssociationStudentProject();
			association.setKey(new AssociationStudentProjectKey(studentEmail.get(i), projectName));
			System.out.println("set key");
			association.setRegistered(false);
			entityManager.persist(association);
			System.out.println("persist done");
		}
		
	}

	@Override
	public Project findProjectByKey(String projectName) throws NotValidProjectException {
		Project project = entityManager.find(Project.class, projectName);
		if (project == null) 
			throw new NotValidProjectException();
		return project;
	}

	@Override
	public void removeAssociation(String studentEMail, String projectName) {
		//Query query = entityManager.createNativeQuery("SELECT a FROM MPH.AssociationStudentProject " +
		//		"as a  WHERE a.studentEmail='"+studentEMail+"' AND a.isRegistered=false AND a.project='"+projectName+"'");
		
		AssociationStudentProjectKey key = new AssociationStudentProjectKey(studentEMail, projectName);
		AssociationStudentProject association = entityManager.find(AssociationStudentProject.class, key);
		if (association != null && !association.isRegistered()){
			entityManager.remove(association);
			entityManager.flush();
		}
		
	}

	@Override
	public List<String> getRegisteredStudents(String projectName) {
		ArrayList<String> students = new ArrayList<String>();
		if(projectName == null)
			return students;
		Query query = entityManager.createNativeQuery("SELECT a.studentEmail FROM MPH.AssociationStudentProject AS a" +
						" WHERE a.project='"+projectName+"' AND a.isRegistered=true;");
		System.out.println("SELECT a.studentEmail FROM MPH.AssociationStudentProject AS a" +
						" WHERE a.project='"+projectName+"' AND a.isRegistered=true;");
		List<String> registeredStudents = query.getResultList();
		if(registeredStudents != null)
			return registeredStudents;
		return students;
	}

	@Override
	public Deadline findDeadlineByKey(String projectName, String deadlineDate) {
		if (projectName == null)
			return null;
		if (deadlineDate == null)
			return null;
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = format.parse(deadlineDate);
		} catch (ParseException e) {
			return null;
		}
		Timestamp timestamp = new Timestamp(date.getTime());
		DeadlineKey key = new DeadlineKey(projectName, timestamp);
		return entityManager.find(Deadline.class, key);
	}

	@Override
	public boolean hasClosureDateExpired(String projectName) {
		if (projectName == null)
			return false;
		Project project = entityManager.find(Project.class, projectName);
		if (project == null)
			return false;
		return project.getClosureDate().before(new Date(System.currentTimeMillis()));
	}

	private boolean deleteDirectory(File path) {
		if( path.exists() ) {
			File[] files = path.listFiles();
		    for(int i=0; i<files.length; i++) {
		    	if(files[i].isDirectory()) {
		    		deleteDirectory(files[i]);
		         }
		         else {
		        	 files[i].delete();
		         }
		    }
		}
		return( path.delete() );
	}


}
