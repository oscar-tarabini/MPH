package tests;

import static org.junit.Assert.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import exceptions.WrongParameterException;

import utility.ConfigurationTools;

public class ConfigurationToolsTest {

	@Test
	public void testGetPossibleDomains() {
		List<String> domains = ConfigurationTools.getPossibleDomains(null);
		assertTrue(domains.isEmpty());
		File file = new File("MPHconf.csv");
		try {
			PrintWriter printWriter = new PrintWriter(file);
			printWriter.write("@prova1.it,@prova2.it");
			printWriter.flush();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		domains = ConfigurationTools.getPossibleDomains(file);
		assertTrue(domains.get(0).equals("@prova1.it"));
		assertTrue(domains.get(1).equals("@prova2.it"));
	}

	@Test
	public void testSetPossibleDomains() {
		File file = new File("MPHconf.csv");
		List<String> domains = new ArrayList<String>();
		domains.add("@dom1.it");
		domains.add("@dom2.it");
		try {
			ConfigurationTools.setPossibleDomains(file, domains);
		} catch (WrongParameterException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		List<String> domains2 = ConfigurationTools.getPossibleDomains(file);
		assertTrue(domains.get(0).equals(domains2.get(0)));
		assertTrue(domains.get(1).equals(domains2.get(1)));
	}

}
