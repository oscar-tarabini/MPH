package entityBeans;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.*;

@Entity
@Table(name="`Group`")
public class Group implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1615842389873038609L;

	@Id
	@Column(name="groupID")
	private int groupID;
	
	@Column(name="name")
	private String name;
	
	@Column(name="project")
	private String project;
	
	@Column(name="student1")
	private String student1;
	
	@Column(name="student2")
	private String student2;
	
	@Column(name="student3")
	private String student3;
	
	@Column(name="viewedGroup")
	private int viewedGroup;
	
	@Column(name="finalScore")
	private int finalScore;
	
	@Column(name="isDefinitive")
	private boolean isDefinitive;
	

	public boolean isDefinitive() {
		return isDefinitive;
	}

	public void setDefinitive(boolean isDefinitive) {
		this.isDefinitive = isDefinitive;
	}

	public String getStudent1() {
		return student1;
	}

	public void setStudent1(String student1) {
		this.student1 = student1;
	}

	public String getStudent2() {
		return student2;
	}

	public void setStudent2(String student2) {
		this.student2 = student2;
	}

	public String getStudent3() {
		return student3;
	}

	public void setStudent3(String student3) {
		this.student3 = student3;
	}

	public int getGroupID() {
		return groupID;
	}

	public void setGroupID(int groupID) {
		this.groupID = groupID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getProject() {
		return project;
	}

	public void setProject(String project) {
		this.project = project;
	}

	public int getViewedGroup() {
		return viewedGroup;
	}

	public void setViewedGroup(int viewedGroup) {
		this.viewedGroup = viewedGroup;
	}

	public int getFinalScore() {
		return finalScore;
	}

	public void setFinalScore(int finalScore) {
		this.finalScore = finalScore;
	}
	
	/**
	 * The list can be of length 1, 2 or 3, depending on the size of the group
	 * @return List of email of students of this group
	 */
	public List<String> getStudents() {
		ArrayList<String> list = new ArrayList<String>();
		if (student1 != null && !student1.isEmpty()) list.add(student1);
		if (student2 != null && !student2.isEmpty()) list.add(student2);
		if (student3 != null && !student3.isEmpty()) list.add(student3);
		return list;
	}
	
	/**
	 * Set student fields of the Group table with emails on the List passed as parameter.
	 * The size of the list can be 1, 2 or 3 depending on the size of the group 
	 * @param students List of 1, 2 or 3 emails of students
	 */
	public void setStudents(List<String> students) {
		student1 = students.get(0);
		setStudent2("");
		setStudent3("");
		if (students.size() >= 2) student2 = students.get(1);
		if (students.size() == 3) student3 = students.get(2);
	}
	
}
