package com.idoit.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/job_posting-img/**")
                .addResourceLocations("file:///C:/job_posting/");
        registry.addResourceHandler("/upload/**")
        .addResourceLocations("file:///C:/upload/");
    }
}
