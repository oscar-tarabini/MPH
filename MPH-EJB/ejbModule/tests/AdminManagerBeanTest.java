package tests;

import static org.junit.Assert.*;

import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import exceptions.NotLoggedInException;
import exceptions.ProfessorCreationException;
import exceptions.WrongParameterException;

import sessionBeans.stateful.AdministratorManagerBeanRemote;

public class AdminManagerBeanTest {

	private AdministratorManagerBeanRemote adminManager;
	private TestBeanRemote testBean;
	
	private String adminUsername = "testAdminTestAdminTestAdmin";
	
	@Before
	public void setUp() throws Exception {
		adminManager = getAdministratorManager(getInitialContext());
		if (adminManager == null) 
			fail("failed to retrieve the adminManager");
		
		// retrieve testBean
		testBean = getTestBean(getInitialContext());
		if (testBean == null)
			fail("failed to retrieve the testBean");
		
		
		String password = "password";
		
		testBean.setAdmin(adminUsername,password);
	
	}

	private AdministratorManagerBeanRemote getAdministratorManager(Context ctx) {
		Object object = null;
		try {		
			object = ctx.lookup("AdministratorManagerBean/remote");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return (AdministratorManagerBeanRemote) object;
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
	
	@Test
	public void testRegisterAndDeleteProfessor() {
		String profName = "provaNameProf";
		String profLast = "provaLastProf";
		String profEmail = "provaTestProfwwwwwxywmy2892990dasf@polimi.it";
		String profID = "123456";
		boolean checkOk = false; 
		
		// check  login Exception
		try {
			adminManager.registerProfessor(profEmail, profName, profLast, profID);
		} catch (NotLoggedInException e) {
			checkOk = true;
		} catch (ProfessorCreationException e) {
			fail("failed to retrieve the adminManager");
		}
		assertEquals(true, checkOk);
		
		adminManager.login();
		
		if(testBean.retrieveProfessor(profEmail) != null)
			fail("test cannot be run because a professor with profTestEmail already exist.. change test prof mail");
		
		// check professor Creation Exception
		checkOk = false;
		try {
			adminManager.registerProfessor(profEmail, "", profLast, profID);
		} catch (NotLoggedInException e) {
			fail("not login - failed to retrieve the prof");
		} catch (ProfessorCreationException e) {
			checkOk = true;
		}
		
		assertEquals(true, checkOk);
		
		checkOk = false;
		try {
			adminManager.registerProfessor(profEmail, profName, profLast, "2n3l");
		} catch (NotLoggedInException e) {
			fail("not login - failed to create the prof");
		} catch (ProfessorCreationException e) {
			checkOk = true;
		}
		
		assertEquals(true, checkOk);
		
		try {
			adminManager.registerProfessor(profEmail, profName, profLast, profID);
		} catch (NotLoggedInException e) {
			fail("not login - failed to create professor");
		} catch (ProfessorCreationException e) {
			fail("prof creation exception - failed to create professor");
		}
		
		assertNotNull(testBean.retrieveProfessor(profEmail));
		
		// check deletion professor
		adminManager.logout();
		
		checkOk = false;
		try {
			adminManager.deleteProfessor(profEmail);
		} catch (NotLoggedInException e) {
			checkOk = true;
		} catch (WrongParameterException e) {
			fail("prof deletion exception - failed to delete the prof");
			e.printStackTrace();
		}
		
		assertEquals(true, checkOk);
		assertNotNull(testBean.retrieveProfessor(profEmail));
		
		adminManager.login();
		
		checkOk = false;
		try {
			adminManager.deleteProfessor("inventedPasswordInexistent666soso");
		} catch (NotLoggedInException e) {
			fail("not login - failed to delete the prof");
		} catch (WrongParameterException e) {
			checkOk = true;
		}
		
		assertEquals(true, checkOk);
		
		
		
		try {
			adminManager.deleteProfessor(profEmail);
		} catch (NotLoggedInException e) {
			fail("not login - failed to delete the prof");
		} catch (WrongParameterException e) {
			fail("prof deletion exception - failed to delete the prof");
			e.printStackTrace();
		}
		assertNull(testBean.retrieveProfessor(profEmail));
		
		
	}


	
	@After
	public void tearDown() throws Exception {
		testBean.removeAdmin(adminUsername);
	}
}
