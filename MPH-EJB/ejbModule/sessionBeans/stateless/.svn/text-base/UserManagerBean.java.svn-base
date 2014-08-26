package sessionBeans.stateless;

import java.io.File;
import java.io.IOException;
import java.security.Security;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.ejb.Stateless;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.jacorb.transaction.Sleeper;

import utility.ConfigurationTools;

import entityBeans.Administrator;
import entityBeans.Professor;
import entityBeans.Student;
import exceptions.LoginFailException;
import exceptions.ProfessorCreationException;
import exceptions.StudentCreationException;
import exceptions.WrongParameterException;

/**
 * Session Bean implementation class UserManagerBean
 */
@Stateless (name="UserManagerBean")
public class UserManagerBean implements UserManagerBeanRemote, UserManagerBeanLocal {

	@PersistenceContext( unitName = "MPH" )
	private EntityManager entityManager;


    /**
     * Default constructor. 
     */
    public UserManagerBean() {
        // TODO Auto-generated constructor stub
    }

	@Override
	public void createNewStudent(String email, String firstName, 
			String lastName, String studentID) throws StudentCreationException {
		
		// checking parameters
		if(		email == null 	  || email.equals("" )    || 
				firstName == null || firstName.equals("") || 
				lastName == null  || lastName.equals("")  ||
				studentID == null || studentID.equals("")  )
			throw new StudentCreationException("wrong parameters");
		
		if (!isEmailFormatCorrect(email))
			throw new StudentCreationException("email not valid");
		
		int studentId = 0;
		try{
			studentId = Integer.parseInt(studentID);
		} catch(NumberFormatException e){
			throw new StudentCreationException("id number not valid");
		}
		
		// check if email is free
		Student stud = entityManager.find(Student.class, email);
		if(stud != null) 
			throw new StudentCreationException("email already used");
		if(entityManager.find(Professor.class, email) != null)
			throw new StudentCreationException("email already used - it's a professor email");
		
		// insertion of fields
		Student studToCreate = new Student();
		studToCreate.setEmail(email);
		studToCreate.setFirstName(firstName);
		studToCreate.setLastName(lastName);
		studToCreate.setStudentID(studentId);
		// get password and send email
		String password = generateRandomPassword();
	
		studToCreate.setPassword(password);
		entityManager.persist(studToCreate);
		entityManager.flush();
		final String studentEmail = email;
		final String studentPassword = password;
		Thread thread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				for (int i = 0; i<3; i++) {
					try {
						sendMail(studentEmail, studentPassword);
						break;
					} catch (Exception e) {
						e.printStackTrace();
						try {
							Thread.sleep(10000);
						} catch (InterruptedException e1) {
							e1.printStackTrace();
						}
						continue;
					}

				}
			}
		});
		thread.start();
	}

	@Override
	public void createNewProfessor(String email,
			String firstName, String lastName, String professorID)
			throws ProfessorCreationException {
		
		if (email == null || firstName == null || lastName == null || professorID == null ||
				email.isEmpty() || firstName.isEmpty() || lastName.isEmpty() || professorID.isEmpty()) 
			throw new ProfessorCreationException("wrong parameters");
		if (!isEmailFormatCorrect(email)) 
			throw new ProfessorCreationException("email not valid");
		if (entityManager.find(Professor.class, email) != null) 
			throw new ProfessorCreationException("email already used");
		if (entityManager.find(Student.class, email) != null)
			throw new ProfessorCreationException("email already used - it's a student email!");
		String password = generateRandomPassword();
		int profId;
		try{
			profId = Integer.parseInt(professorID);
		} catch(NumberFormatException e){
			throw new ProfessorCreationException("id number not valid");
		}
		Professor professor = new Professor(email, password, firstName, lastName, profId);
		entityManager.persist(professor);
		entityManager.flush();
		try {
			sendMail(email, password);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteProfessor(String profEmail) throws WrongParameterException {
		Professor profToDelete = entityManager.find(Professor.class, profEmail);
		if(profToDelete == null)
			throw new WrongParameterException();
		else 
			entityManager.remove(profToDelete);
	}

	@Override
	public String userLogin(String email, String password)
			throws LoginFailException {
		if (email == null || password == null)
			throw new LoginFailException();
		Student student = entityManager.find(Student.class, email);
		Professor professor = null;
		if (student != null) {
			if (student.getPassword().equals(password)) {
				return "s";
			} else {
				throw new LoginFailException();
			}
		} else {
			professor = entityManager.find(Professor.class, email);
			if (professor != null) {
				if (professor.getPassword().equals(password)) {
					return "p";
				} else {
					throw new LoginFailException();
				}
			} else {
				throw new LoginFailException();
			}
		}
	}

	@Override
	public Administrator adminLogin(String username, String password) throws LoginFailException {
		Administrator admin = entityManager.find(Administrator.class, username);
		if(admin == null)
			throw new LoginFailException();
		if(admin.getPassword().equals(password)){
			return admin;
		} else {
			throw new LoginFailException();
		}
	}
	
	private void sendMail(String mail,String password) throws Exception {
        Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        Properties props = new Properties();
        props.setProperty("mail.transport.protocol", "smtp");
        props.setProperty("mail.host", "smtp.gmail.com");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");
        props.put("mail.debug", "true");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");
        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication("mph.project.polimi","mph.project.polimi");
                }
        });
        session.setDebug(true);
        Transport transport = session.getTransport();
        InternetAddress addressFrom = new InternetAddress("mph.project.polimi@gmail.com");
        MimeMessage message = new MimeMessage(session);
        message.setSender(addressFrom);
        message.setSubject("Your account for MPH has been created");
        message.setContent("This is your new password: " + password, "text/plain");
        InternetAddress addressTo = new InternetAddress(mail);
        message.setRecipient(Message.RecipientType.TO, addressTo);
        transport.connect();
        Transport.send(message);
        transport.close();
	}
	
	private String generateRandomPassword(){
		final int PASSWORD_LENGTH = 8;
		char[] symbols = new char[36];
		for (int idx = 0; idx < 10; ++idx)
			symbols[idx] = (char) ('0' + idx);
		for (int idx = 10; idx < 36; ++idx)
			symbols[idx] = (char) ('a' + idx - 10);
		Random random = new Random();
		char[] buf = new char[PASSWORD_LENGTH];
		for (int idx = 0; idx < buf.length ; ++idx) 
		      buf[idx] = symbols[random.nextInt(symbols.length)];
		return new String(buf);
	}
	
	private boolean isEmailFormatCorrect(String email) {
		if(email == null) return false;
		if (email.isEmpty()) return false;
		if (email.startsWith(".")) return false;
		if (numberOfAT(email)>1 || numberOfAT(email)==0 ) return false;
		File file = new File(System.getProperty("jboss.home.dir") + File.separator + "upload"+ File.separator + "MPHconf.csv");
		System.out.println("path conf " + file.getAbsolutePath());
		List<String> possibleDomains = ConfigurationTools.getPossibleDomains(file);
		if (possibleDomains.isEmpty())
			return true;
		for (String domain: possibleDomains) {
			if (email.endsWith(domain)) return true;
		}
		return false;
	}
	
	static private int numberOfAT(String email) {
		int i = 0;
		for(int j = 0; j<email.length(); j++) {
			if (email.charAt(j) == '@') i++;
		}
		return i;
	}

	@Override
	public Professor findProfessorByEmail(String email) {
		Professor professor = entityManager.find(Professor.class, email);
		return professor;
	}

	@Override
	public Student findStudentByEmail(String email) {
		Student student = entityManager.find(Student.class, email);
		return student;
	}

	@Override
	public void recoverPassword(String email) throws WrongParameterException {
		if (email == null)
			throw new WrongParameterException();
		Student student = findStudentByEmail(email);
		Professor professor = null;
		if (student == null) {
			professor = findProfessorByEmail(email);
			if (professor == null) {
				throw new WrongParameterException();
			} else {
				//send email to professor
				String password = generateRandomPassword();
				professor.setPassword(password);
				try {
					sendMail(email, password);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else {
			// send email to student
			String password = generateRandomPassword();
			student.setPassword(password);
			try {
				sendMail(email, password);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public boolean hasAdminConfiguredHisAccount() {
		Query query = entityManager.createQuery("SELECT a FROM Administrator AS a");
		List<Administrator> administrator = query.getResultList();
		if (administrator.isEmpty())
			return false;
		else
			return true;
	}

	@Override
	public void setupAdministrator(String username, String password,
			List<String> domains) throws IOException, WrongParameterException {
		if (username == null && password == null && domains == null) 
			throw new WrongParameterException();
		Administrator administrator = new Administrator();
		administrator.setUsername(username);
		administrator.setPassword(password);
		entityManager.persist(administrator);
		entityManager.flush();
		File file = new File(System.getProperty("jboss.home.dir") + File.separator + "upload"+ File.separator + "MPHconf.csv");
		if (file.exists())
			file.delete();
		ConfigurationTools.setPossibleDomains(file, domains);
	}

	@Override
	public boolean hasUploadedPicture(String username) {
		if (username == null)
			return false;
		File image = new File(System.getProperty("jboss.home.dir") + File.separator + "upload" + File.separator + "pictures" + File.separator + username + ".jpg");
		return image.exists();
	}

}
