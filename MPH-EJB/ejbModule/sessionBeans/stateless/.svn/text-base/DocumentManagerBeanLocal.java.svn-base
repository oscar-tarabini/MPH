package sessionBeans.stateless;
import java.util.List;

import javax.ejb.Local;

import entityBeans.Deadline;
import entityBeans.GroupDocument;

@Local
public interface DocumentManagerBeanLocal {

	/**
	 * It returns the path of the document to be downloaded, after checking
	 * that the group has the rights to download it.
	 * @param documentId the id of the document
	 * @param groupId the id of the group that wants to download the documents
	 * @return the path of the document identified by documentId or null if the group
	 * has not the right to download it.
	 */
	public String download(int documentId, int groupId);
	
	/**
	 * Download for the professor. It returns the path of the document to be downloaded
	 * @param documentId document id
	 * @return the path of the document identified by documentId or null if not found
	 */
	public String download(int documentId);
	
	/**
	 * It returns a list of all documents uploaded by a group
	 * @param groupId group id
	 * @return list of group's document
	 */
	public List<GroupDocument> getDocumentsOfAGroup(int groupId);
	
	/**
	 * It returns the last version (if any) of a document uploaded for a certain deadline 
	 * @param groupId the id of the group
	 * @param deadline the deadline
	 * @return the last document (in chronological order) uploaded by the group for 
	 * that deadline. It returns null if no document for that deadline has been uploaded.
	 */
	public GroupDocument getLastDocumentOfAGroup(int groupId, Deadline deadline);
	
	/**
	 * It returns the first version (if any) of a document uploaded for a certain deadline 
	 * @param groupId the id of the group
	 * @param deadline the deadline
	 * @return the first document (in chronological order) uploaded by the group for 
	 * that deadline. It returns null if no document for that deadline has been uploaded.
	 */
	public GroupDocument getFirstDocumentOfAGroup(int groupId, Deadline deadline);
	
	/**
	 * It registers in the database the information related to a new uploaded group document
	 * @param filePath the complete file path of the uploaded document
	 * @param fileName the name of the uploaded document 
	 * @param studentEmail the email of student who uploaded the document
	 * @param groupId the group id of the student who uploaded the document
	 * @param projectName the name of project 
	 * @param deadlineDate the date of the deadline which the document refers to
	 */
	public void studentUpload(String filePath, String fileName, String studentEmail,
			int groupId, String projectName, String deadlineDate);
	
	/**
	 * It registers in the database the information related to an overview document
	 * @param path the path into which the document has been uploaded
	 * @return the id of the file
	 */
	public int overviewUpload(String path);
	
	/**
	 * It returns all documents of a project's deadline uploaded by all groups
	 * @param projectName name of project
	 * @param deadlineDate the date of deadline
	 * @return the list of all documents of the project's deadline uploaded by all groups
	 */
	public List<GroupDocument> getDocumentsByDeadline(String projectName, String deadlineDate);
	
}
