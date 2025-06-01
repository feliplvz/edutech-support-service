package com.edutech.supportservice.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Componente de utilidad para registrar eventos de auditoría
 */
@Component
public class AuditLogger {
    
    private static final Logger logger = LoggerFactory.getLogger("audit");
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    /**
     * Registra un evento de creación de recurso
     */
    public void logResourceCreation(String resourceType, Long resourceId, String username) {
        log("CREACIÓN", resourceType, resourceId, username, null);
    }
    
    /**
     * Registra un evento de actualización de recurso
     */
    public void logResourceUpdate(String resourceType, Long resourceId, String username, String changes) {
        log("ACTUALIZACIÓN", resourceType, resourceId, username, changes);
    }
    
    /**
     * Registra un evento de eliminación de recurso
     */
    public void logResourceDeletion(String resourceType, Long resourceId, String username) {
        log("ELIMINACIÓN", resourceType, resourceId, username, null);
    }
    
    /**
     * Registra un evento de acceso a recurso
     */
    public void logResourceAccess(String resourceType, Long resourceId, String username) {
        log("ACCESO", resourceType, resourceId, username, null);
    }
    
    /**
     * Registra un evento de seguridad
     */
    public void logSecurityEvent(String eventType, String username, String details) {
        String timestamp = LocalDateTime.now().format(formatter);
        logger.info("[SEGURIDAD][{}][{}] {}", timestamp, username, eventType + (details != null ? " - " + details : ""));
    }
    
    /**
     * Método interno para registrar eventos
     */
    private void log(String action, String resourceType, Long resourceId, String username, String details) {
        String timestamp = LocalDateTime.now().format(formatter);
        String message = String.format("[%s][%s][%s][ID:%d][%s]", 
                timestamp, action, resourceType, resourceId, username);
        
        if (details != null && !details.isEmpty()) {
            message += " " + details;
        }
        
        logger.info(message);
    }
}
