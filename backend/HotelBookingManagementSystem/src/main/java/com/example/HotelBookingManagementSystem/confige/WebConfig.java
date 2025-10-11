package com.example.HotelBookingManagementSystem.confige;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${image.upload.dir}")
    private String uploadDir;


    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        registry.addResourceHandler("/images/**")
                .addResourceLocations("file:" + uploadDir +"/");

//        registry.addResourceHandler("/images/**")
//                .addResourceLocations("classpath:/static/images/");



    }



    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // CORS for static images
        registry.addMapping("/images/**")
                .allowedOrigins("http://localhost:5001", "http://localhost:4200")
                .allowedMethods("GET", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }




}
