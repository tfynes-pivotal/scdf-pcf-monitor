package com.fynesy;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class GuidEnricherApplication {

	public static void main(String[] args) {
		SpringApplication.run(GuidEnricherApplication.class, args);
	}
	
	
	@Value("${cfapi:''}")
	private String cfapi;
	@Value("${cfuser:''}")
	private String cfuser;
	@Value("${cfpass:''}")
	private String cfpass;
	
	private HashMap<String,String> appGuidCache 	= new HashMap<String, String>();
	private HashMap<String,String> spaceGuidCache 	= new HashMap<String, String>();
	private HashMap<String,String> orgGuidCache    	= new HashMap<String, String>();	
	
	@RequestMapping("/")
	public String index() {	
		return "CF Wrapper\n";
	}
	
	@RequestMapping("/AppGuidToName")
	public String appGuidToName(@RequestParam(name="guid") String guid) {
		if (appGuidCache.containsKey(guid)) {
			return appGuidCache.get(guid);
		}
		else {
			if (!loggedIn()) {
				System.out.println("appGuidToName guid not logged in");
				logIn();
			}		
			String s = runCfCurlCommand("/v2/apps/" + guid + " | jq -r .entity.name");
			appGuidCache.put(guid, s);
			return s;
		}
	}
	
	@RequestMapping("/SpaceGuidToName")
	public String spaceGuidToName(@RequestParam(name="guid") String guid) {
		if (spaceGuidCache.containsKey(guid)) {
			return spaceGuidCache.get(guid);
		}
		else {
			if (!loggedIn()) {
				logIn();
			}		
			String s = runCfCurlCommand("/v2/spaces/" + guid + " | jq -r .entity.name");
			spaceGuidCache.put(guid, s);
			return s;
		}
	}
	
	@RequestMapping("/OrgGuidToName")
	public String orgGuidToName(@RequestParam(name="guid") String guid) {
		if (spaceGuidCache.containsKey(guid)) {
			return spaceGuidCache.get(guid);
		}
		else {
			if (!loggedIn()) {
				logIn();
			}		
			String s = runCfCurlCommand("/v2/organizations/" + guid + " | jq -r .entity.name");
			orgGuidCache.put(guid, s);
			return s;
		}
	}
	
	private boolean loggedIn() {
		String[] commands = {"/bin/bash","-c", 	  "export PATH=$PATH:/home/vcap/app/static && "
		+ "cf-linux api " + cfapi + " && "
		+ "cf-linux target"};
		String result = runCommand(commands);
		return !result.contains("Not logged in");
	}
		
	private void logIn() {
		String[] commands = {"/bin/bash","-c", 	  "export PATH=$PATH:/home/vcap/app/static && "
				+ "cf-linux api " + cfapi + " && "
				+ "cf-linux auth " + cfuser + " " + cfpass};
		String output = runCommand(commands);
	}
	
	
	
	private String runCfCurlCommand(String curlCommand) {
		if (!loggedIn()) {
			logIn();
		}
		String[] fullCommand = {"/bin/bash","-c", "/home/vcap/app/static/cf-linux curl " + curlCommand };
		String fullCommandOutput = runCommand(fullCommand);
		return fullCommandOutput;

	}
	
	private String runCommand(String[] commands) {
		StringBuffer output = new StringBuffer();
		Process p;
		try {
			p = Runtime.getRuntime().exec(commands);
			p.waitFor();
			BufferedReader reader = 
						new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line = "";
			while ((line = reader.readLine()) != null ) {
				output.append(line + "\n");
			} 
		}
		catch (Exception e) {
			e.printStackTrace();
			output.append(e.getMessage());
		}
		return output.toString();
	}
	
	
	
//	private String runCommand(String command) {
//		StringBuffer output = new StringBuffer();
//		Process p;
//		try {
//			p = Runtime.getRuntime().exec(command);
//			p.waitFor();
//			BufferedReader reader = 
//						new BufferedReader(new InputStreamReader(p.getInputStream()));
//			String line = "";
//			while ((line = reader.readLine()) != null ) {
//				output.append(line + "\n");
//			} 
//		}
//		catch (Exception e) {
//			e.printStackTrace();
//			output.append(e.getMessage());
//		}
//		return output.toString();
//	}
	
	

}
