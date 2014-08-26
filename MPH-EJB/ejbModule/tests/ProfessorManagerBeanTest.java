package tests;

import static org.junit.Assert.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import entityBeans.Deadline;
import entityBeans.Project;
import exceptions.NotLoggedInException;
import exceptions.NotValidProjectException;
import exceptions.PermissionDeniedException;
import exceptions.WrongParameterException;
import sessionBeans.stateful.ProfessorManagerBeanRemote;

public class ProfessorManagerBeanTest {
	
	private ProfessorManagerBeanRemote professorManager;
	private TestBeanRemote testBean;
	private String email = "professor@polimi.it";
	
	@Before
    public void setUp() {
		// retrieve to professorManager
		professorManager = getProfessorManager(getInitialContext());
		if (professorManager == null) 
			fail("failed to retrieve the professorManager");
			
		// retrieve testBean
		testBean = getTestBean(getInitialContext());
		if (testBean == null)
			fail("failed to retrieve the testBean");
		
		// create professor 
		email = "professor@polimi.it";
		String password = "professor";
		String firstName = "Prof";
		String lastName = "Essor";
		int profID = 12345;
		testBean.addProfessor(email, password, firstName, lastName, profID);
		
		// professor logs in
		professorManager.login(email);
    }
	
	private Context getInitialContext() {
		Properties env = new Properties();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "org.jnp.interfaces.NamingContextFactory");
		env.put(Context.PROVIDER_URL, "localhost:1099");
		Context ctx = null;
		try {
			ctx = new InitialContext(env);
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return ctx;
	}
	
	private ProfessorManagerBeanRemote getProfessorManager(Context ctx){
		Object object = null;
		try {		
			object = ctx.lookup("ProfessorManagerBean/remote");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return (ProfessorManagerBeanRemote) object;
	}
	
	private TestBeanRemote getTestBean(Context ctx) {
		Object object = null;
		try {		
			object = ctx.lookup("TestBean/remote");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return (TestBeanRemote) object;
	}
	
	@Test
	public void testCreateAndDeleteProject() {
		// professor create project
		String projectName = "TestProject";
		int numberOfDeadlines = 3;
		List<String> deadlineNames = new ArrayList<String>();
		List<String> deadlineDates = new ArrayList<String>();
		String closureDate = "2031-05-05 05:05:05";
		List<String> enabledStudEmail = new ArrayList<String>();
		deadlineNames.add("Deadline1");
		deadlineNames.add("Deadline2");
		deadlineNames.add("Deadline3");
		deadlineDates.add("2030-01-01 05:05:05");
		deadlineDates.add("2030-02-02 05:05:05");
		deadlineDates.add("2030-03-03 05:05:05");
		enabledStudEmail.add("teststudent@mail.polimi.it");
		try {
			professorManager.createProject(projectName, numberOfDeadlines, deadlineNames, deadlineDates, closureDate, enabledStudEmail);
		} catch (NotLoggedInException e) {
			fail("error in creating the project, not logged in");
		} catch (WrongParameterException e) {
			fail("error in creating the project, wrong enabled student list");
			e.printStackTrace();
		}
		
		// get list of projects
		List<String> projects = null;
		try {
			projects = professorManager.getListOfProjectKeys();
		} catch (NotLoggedInException e) {
			fail("failed to retrieve the project");
			e.printStackTrace();
		}
		assertNotNull(projects);
		assertTrue(projects.contains(projectName));
		
		// enter project area
		try {
			professorManager.enterProjectArea(projectName);
		} catch (NotLoggedInException e) {
			fail("failed enter project area");
			e.printStackTrace();
		} catch (NotValidProjectException e) {
			fail("failed enter project area");
			e.printStackTrace();
		}
		
		// get the project just created
		Project project = null;
		try {
			project = professorManager.getProject();
		} catch (NotLoggedInException e1) {
			fail("current project not found");
			e1.printStackTrace();
		} catch (NotValidProjectException e1) {
			fail("current project not found");
			e1.printStackTrace();
		}
		assertNotNull(project);
		assertEquals(project.getName(), projectName);
		
		// get deadlines just created
		List<Deadline> deadlines = null;
		try {
			deadlines = professorManager.getDeadlines();
		} catch (NotLoggedInException e) {
			fail("failed to retrieve deadlines");
			e.printStackTrace();
		} catch (NotValidProjectException e) {
			fail("failed to retrieve deadlines");
			e.printStackTrace();
		}
		assertNotNull(deadlines);
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		for (int i=0; i<deadlines.size(); i++) {
			assertEquals(format.format(deadlines.get(i).getKey().getDate()), deadlineDates.get(i));
			assertEquals(deadlines.get(i).getName(), deadlineNames.get(i));
		}
		
		// check there is association
		assertTrue(testBean.checkThereIsAssociation(projectName, "teststudent@mail.polimi.it"));
		
		// delete project
		try {
			professorManager.deleteProject();
		} catch (NotLoggedInException e) {
			fail("failed to delete the project");
			e.printStackTrace();
		} catch (NotValidProjectException e) {
			fail("failed to delete the project");
			e.printStackTrace();
		} catch (PermissionDeniedException e) {
			fail("failed to delete the project");
			e.printStackTrace();
		}
		
		// check deleted project
		boolean deleted = false;
		try {
			professorManager.getProject();
		} catch (NotLoggedInException e) {
			fail("fail to check deleted project");
			e.printStackTrace();
		} catch (NotValidProjectException e) {
			deleted = true;
		}
		assertTrue(deleted);
		
		// check deleted association
		assertFalse(testBean.checkThereIsAssociation(projectName, "teststudent@mail.polimi.it"));
	}
	
	@After
	public void tearDown() {
		// remove professor account
		testBean.removeProfessor(email);
	}

}
