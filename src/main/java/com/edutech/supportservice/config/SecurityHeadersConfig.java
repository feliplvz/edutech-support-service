package com.edutech.supportservice.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Configuración para agregar cabeceras de seguridad a las respuestas HTTP
 */
@Component
public class SecurityHeadersConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(@NonNull InterceptorRegistry registry) {
        registry.addInterceptor(new SecurityHeadersInterceptor());
    }

    /**
     * Interceptor para agregar cabeceras de seguridad
     */
    public static class SecurityHeadersInterceptor implements HandlerInterceptor {
        
        @Override
        public boolean preHandle(@NonNull HttpServletRequest request, 
                                @NonNull HttpServletResponse response, 
                                @NonNull Object handler) {
                                    
            // Añadir cabeceras de seguridad
            response.setHeader("X-Content-Type-Options", "nosniff");
            response.setHeader("X-Frame-Options", "DENY");
            response.setHeader("X-XSS-Protection", "1; mode=block");
            response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
            
            // Si CORS está habilitado, Spring se encarga automáticamente
            return true;
        }
    }
}
