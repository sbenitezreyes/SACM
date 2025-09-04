package co.proyecto.sacm.config;


import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {


    @Bean
    public GroupedOpenApi sacmApi() {
        return GroupedOpenApi.builder()
                .group("sacm")                              // un solo grupo
                .packagesToScan("co.proyecto.sacm.controller") // escanea todos los controllers
                .pathsToMatch("/api/v1/**")                // incluye todas las rutas v1
                .build();
    }
}
