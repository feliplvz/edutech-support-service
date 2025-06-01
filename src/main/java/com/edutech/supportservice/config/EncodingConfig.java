package com.edutech.supportservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.CharacterEncodingFilter;

/**
 * Configuración para manejo de encoding UTF-8
 */
@Configuration
public class EncodingConfig {

    /**
     * Filtro para asegurar que todas las peticiones HTTP usen encoding UTF-8
     */
    @Bean
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        return filter;
    }
}
