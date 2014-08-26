package tests;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import exceptions.LoginFailException;
import exceptions.NotLoggedInException;
import exceptions.NotValidProjectException;
import exceptions.PermissionDeniedException;
import exceptions.StudentCreationException;
import exceptions.WrongParameterException;

import sessionBeans.stateful.ProfessorManagerBeanRemote;
import sessionBeans.stateful.StudentManagerBean;
import sessionBeans.stateful.StudentManagerBeanRemote;
import sessionBeans.stateless.UserManagerBeanRemote;

public class StudentManagerBeanTest {

	private UserManagerBeanRemote userManager;
	private StudentManagerBeanRemote studManager1;
	private StudentManagerBeanRemote studManager2;
	private ProfessorManagerBeanRemote professorManager;
	private TestBeanRemote testBean;	
	private String student1 = "studentProvawwwZZZZZZxxxx@polimi.it";
	private String student2 = "student2ProvaZZZZZxxxxxWWW@polimi.it";
	private String projectName= "projectNameProvaTestxbyy2345678X1";
	
	
	@Before
	public void setUp() throws Exception {
		studManager1 = getStudentManager(getInitialContext());
		if(studManager1 == null)
			fail("failed to retrive student manager 1");
		
		studManager2 = getStudentManager(getInitialContext());
		if(studManager2 == null)
			fail("failed to retrive student manager 2");
		
		professorManager = getProfessorManager(getInitialContext());
		if(professorManager == null)
			fail("failed to retrive professor manager");
		
		userManager = getUserManager(getInitialContext());
		if(userManager == null)
			fail("failed to retrive user manager");
		
		testBean = getTestBean(getInitialContext());
		if (testBean == null)
			fail("failed to retrieve the testBean");
		
		testBean.addProfessor("provaTestInStudent", "provaTest", "provaTest", "provaTest", 123456);
		professorManager.login("provaTestInStudent");
		
	}

	private UserManagerBeanRemote getUserManager(Context ctx) {
		Object object = null;
		try {		
			object = ctx.lookup("UserManagerBean/remote");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return (UserManagerBeanRemote) object;
	}

	private StudentManagerBeanRemote getStudentManager(Context ctx) {
		Object object = null;
		try {		
			object = ctx.lookup("StudentManagerBean/remote");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return (StudentManagerBeanRemote) object;
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
	
	private TestBeanRemote getTestBean(Context ctx) {
		Object object = null;
		try {		
			object = ctx.lookup("TestBean/remote");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return (TestBeanRemote) object;
	}

	private void createProject(){
	
	}
	
	private void deleteProject(){
		
	}
	@Test
	public void test() {
		
		// check failed registration due to wrong parameters
		// not valid email
		boolean checkOk = false;
		try {
			userManager.createNewStudent("qulc@qualc@polimi.it", "some", "some", "123");
		} catch (StudentCreationException e1) {
			checkOk = true;
		}
		assertEquals(true, checkOk);
		
		checkOk = false;
		try {
			userManager.createNewStudent("", "some", "some", "123");
		} catch (StudentCreationException e1) {
			checkOk = true;
		}
		assertEquals(true, checkOk);
		
		// not valid name
		checkOk = false;
		try {
			userManager.createNewStudent("emailOk@polimi.it", "", "some", "123");
		} catch (StudentCreationException e1) {
			checkOk = true;
		}
		assertEquals(true, checkOk);
		
		
		// not valid identifier
		checkOk = false;
		try {
			userManager.createNewStudent("emailOk@polimi.it", "some", "some", "12d3");
		} catch (StudentCreationException e1) {
			checkOk = true;
		}
		assertEquals(true, checkOk);
		
		// test registration of 2 students
		if(testBean.retrieveStudent(student1) != null || testBean.retrieveStudent(student2) != null)
			fail("student test emails already in use .. test cannot be run");
		
		try {
			userManager.createNewStudent(student1, "not important", "not important", "123456");
			userManager.createNewStudent(student2, "not important", "not important", "123456");
		} catch (StudentCreationException e) {
			fail("error in creation student");
		}
	
		assertNotNull(testBean.retrieveStudent(student1));
		assertNotNull(testBean.retrieveStudent(student2));
				
		// test login for student 1
		// password not valid
		checkOk = false;
		try {
			userManager.userLogin(student1, "short");
		} catch (LoginFailException e) {
			checkOk = true;
		}
		assertEquals(true, checkOk);
		
		// username not valid
		String password = testBean.retrieveStudent(student1).getPassword();
		
		checkOk = false;
		try {
			userManager.userLogin(student1+"bo", password);
		} catch (LoginFailException e) {
			checkOk = true;
		}
		assertEquals(true, checkOk);
		
		// login ok
		String s = null;
		try {
			s = userManager.userLogin(student1, password);
		} catch (LoginFailException e) {
			fail("login failed");
		}
		assertEquals("s", s);
		
		// professor create a project
		//createProject();
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
		enabledStudEmail.add(student1);
		enabledStudEmail.add(student2);
		
		try {
			professorManager.login("provaTestInStudent");
			professorManager.createProject(projectName, numberOfDeadlines, deadlineNames, deadlineDates, closureDate, enabledStudEmail);
		} catch (NotLoggedInException e) {
			fail("error in creating the project, not logged in");
		} catch (WrongParameterException e) {
			fail("error in creating the project, wrong enabled student list");
			e.printStackTrace();
		}
		
		
		try {
			professorManager.enterProjectArea(projectName);
			professorManager.deleteProject();
		} catch (NotLoggedInException e) {
			fail("not log in - project deletion");
		} catch (NotValidProjectException e) {
			fail("not valid param - project deletion");
		} catch (PermissionDeniedException e) {
			fail("permission denied - project deletion");
		}
		
		
	}
		
	@After
	public void tearDown() throws Exception {
		testBean.removeProfessor("provaTestInStudent");
		testBean.removeStudent(student1);
		testBean.removeStudent(student2);
	}

}
