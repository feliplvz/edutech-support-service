package com.edutech.supportservice.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.regex.Pattern;

/**
 * Clase de utilidad para validaciones y seguridad
 */
public class ValidationUtil {

    // Patrones para validación
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    
    private static final Pattern URL_PATTERN = 
        Pattern.compile("^(https?://)[\\w-]+(\\.[\\w-]+)+([\\w.,@?^=%&:/~+#-]*[\\w@?^=%&/~+#-])?$");

    private static final Pattern FILENAME_PATTERN = 
        Pattern.compile("^[\\w\\-. ]+\\.(jpg|jpeg|png|gif|pdf|doc|docx|xls|xlsx|txt|zip|rar)$");

    // Estados y prioridades válidas
    public static final String[] VALID_TICKET_STATUSES = 
        {"NUEVO", "ASIGNADO", "EN_PROGRESO", "RESUELTO", "CERRADO"};
    
    public static final String[] VALID_PRIORITIES = 
        {"BAJA", "MEDIA", "ALTA", "CRÍTICA"};
    
    public static final String[] VALID_USER_TYPES = 
        {"ESTUDIANTE", "INSTRUCTOR", "ADMINISTRADOR", "SOPORTE"};

    /**
     * Valida si un texto está en la lista de valores permitidos
     */
    public static boolean isValidEnum(String value, String[] validValues) {
        if (value == null) {
            return false;
        }
        
        for (String validValue : validValues) {
            if (validValue.equals(value)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Valida si un email tiene formato correcto
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Valida si una URL tiene formato correcto
     */
    public static boolean isValidUrl(String url) {
        return url != null && URL_PATTERN.matcher(url).matches();
    }
    
    /**
     * Valida si un nombre de archivo tiene extensión permitida
     */
    public static boolean isValidFilename(String filename) {
        return filename != null && FILENAME_PATTERN.matcher(filename).matches();
    }
    
    /**
     * Formatea una fecha para mostrar en la interfaz
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
    }
    
    /**
     * Sanitiza texto para prevenir ataques XSS
     */
    public static String sanitizeHtml(String html) {
        if (html == null) {
            return null;
        }
        return html.replaceAll("<[^>]*>", "");
    }
    
    /**
     * Encripta un texto simple para almacenamiento seguro
     */
    public static String encodeBase64(String text) {
        return Base64.getEncoder().encodeToString(text.getBytes());
    }
    
    /**
     * Desencripta un texto codificado en Base64
     */
    public static String decodeBase64(String encodedText) {
        return new String(Base64.getDecoder().decode(encodedText));
    }
    
    /**
     * Previene la instanciación de esta clase de utilidad
     */
    private ValidationUtil() {
        throw new UnsupportedOperationException("Esta es una clase de utilidad y no debe ser instanciada");
    }
}
