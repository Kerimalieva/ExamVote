package com.examvote.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;

import java.util.Properties;

@Configuration
public class FreemarkerConfig {

    @Bean
    public FreeMarkerConfigurer freeMarkerConfigurer() {
        FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
        configurer.setTemplateLoaderPath("classpath:/templates/");
        configurer.setDefaultEncoding("UTF-8");

        Properties settings = new Properties();
        settings.setProperty("default_encoding", "UTF-8");
        settings.setProperty("output_encoding", "UTF-8");
        settings.setProperty("locale", "en_US");
        settings.setProperty("number_format", "0.##");
        settings.setProperty("datetime_format", "yyyy-MM-dd HH:mm:ss");
        settings.setProperty("time_format", "HH:mm:ss");
        settings.setProperty("classic_compatible", "true");
        settings.setProperty("template_exception_handler", "rethrow");
        settings.setProperty("tag_syntax", "auto_detect");

        configurer.setFreemarkerSettings(settings);
        return configurer;
    }

    @Bean
    public FreeMarkerViewResolver freeMarkerViewResolver() {
        FreeMarkerViewResolver resolver = new FreeMarkerViewResolver();
        resolver.setPrefix("");
        resolver.setSuffix(".ftlh");
        resolver.setContentType("text/html;charset=UTF-8");
        resolver.setCache(false);
        resolver.setExposeRequestAttributes(true);
        resolver.setExposeSessionAttributes(true);
        resolver.setExposeSpringMacroHelpers(true);
        resolver.setRequestContextAttribute("request");
        return resolver;
    }
}