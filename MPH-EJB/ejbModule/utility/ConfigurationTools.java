package utility;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import exceptions.WrongParameterException;

public class ConfigurationTools {

	static public List<String> getPossibleDomains(File file) {
		if (file == null || !file.exists()) {
			return getDefaultPossibleDomains();
		} else {
			List<String> domains = new ArrayList<String>();
			try {
				Scanner scanner = new Scanner(file);
				scanner.useDelimiter(",");
				while (scanner.hasNext()) {
					String domain = scanner.next();
					domain = domain.replaceAll("(\\r|\\n)", "");
					domain = domain.trim();
					domains.add(domain);
				}
				if (domains == null || domains.isEmpty()) {
					System.out.println("Non trovo domain");
					return getDefaultPossibleDomains();
				}
				return domains;
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			return domains;
		}
	}

	static private List<String> getDefaultPossibleDomains() {
		List<String> possibleDomains = new ArrayList<String>();
		return possibleDomains;
	}
	
	static public void setPossibleDomains(File file, List<String> domains) throws WrongParameterException, IOException {
		if (file == null)
			throw new WrongParameterException();
		String directory = file.getParent();
		if (directory != null) {
			File dir = new File(directory);
			if (!dir.exists())
				dir.mkdirs();
		}
		if (domains != null && !domains.isEmpty()) {
			String csv = new String();
			for (String domain: domains) {
				csv = csv + "," + domain;
			}
			PrintWriter printWriter = new PrintWriter(file);
			printWriter.write(csv);
			printWriter.flush();
		} else if (domains == null) {
			throw new WrongParameterException();
		}
	}
}
