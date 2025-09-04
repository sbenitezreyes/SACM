package co.proyecto.sacm;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

@SpringBootApplication(scanBasePackages = "co.proyecto.sacm")
public class SacmApplication {

	public static void main(String[] args) {

        SpringApplication.run(SacmApplication.class, args);
	}

}
