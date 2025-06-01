package com.edutech.supportservice.config;

import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración para habilitar el sistema de caché
 */
@Configuration
@EnableCaching
public class CacheConfig {
    // La configuración detallada se maneja en application.properties
    // usando spring.cache.caffeine.spec
}
