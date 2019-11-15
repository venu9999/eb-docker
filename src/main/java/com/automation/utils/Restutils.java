package com.automation.utils;

import org.springframework.stereotype.Component;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Component
public class Restutils {

	private static Client client= Client.create();
	
	public String getdata() {
		WebResource webresource=client.resource("http://dummy.restapiexample.com/api/v1/");
		ClientResponse resp= webresource.path("employees").type("application/json").get(ClientResponse.class);
		String respoutput =resp.getEntity(String.class);
		return respoutput;
	}
	

	public String postdata(String json) {
		WebResource webresource=client.resource("http://dummy.restapiexample.com/api/v1/");
		ClientResponse resp= webresource.path("/create").type("application/json").post(ClientResponse.class, "{\"name\":\"devopsuser1\",\"salary\":\"25000\",\"age\":\"28\"}");
		String respoutput =resp.getEntity(String.class);
		return respoutput;
	}

	public String putdata(String json) {
		WebResource webresource=client.resource("https://reqres.in/");
		ClientResponse resp= webresource.path("api/users/2").type("application/json").put(ClientResponse.class, "{\n" + 
				"    \"name\": \"morpheus\",\n" + 
				"    \"job\": \"leader\"\n" + 
				"}");
		String respoutput =resp.getEntity(String.class);
		return respoutput;
	}
	
	public String deletedata() {
		WebResource webresource=client.resource("https://reqres.in/");
		ClientResponse resp= webresource.path("api/users/2").type("application/json").delete(ClientResponse.class);
		String respoutput =resp.getEntity(String.class);
		return respoutput;
	}
	
}
