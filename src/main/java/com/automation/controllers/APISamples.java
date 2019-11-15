package com.automation.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.automation.utils.Restutils;

@RestController
@RequestMapping("api/v1/users")
public class APISamples {

	private Restutils rutils;

	@Autowired
	public void restutils(Restutils rutils) {
		this.rutils = rutils;
	}

	@RequestMapping("/list")
	public String getusers() {
		return rutils.getdata();
	}

	@RequestMapping("/create")
	public String creatuser() {
		return rutils.postdata("");
	}
	
}
