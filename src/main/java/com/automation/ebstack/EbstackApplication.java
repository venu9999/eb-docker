package com.automation.ebstack;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan("com.automation.*")
public class EbstackApplication {

	public static void main(String[] args) {
		SpringApplication.run(EbstackApplication.class, args);
	}
}
