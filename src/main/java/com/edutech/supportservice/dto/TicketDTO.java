package com.edutech.supportservice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO para representar tickets de soporte
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TicketDTO {

    private Long id;

    @NotBlank(message = "El título del ticket es obligatorio")
    @Size(min = 5, max = 100, message = "El título debe tener entre 5 y 100 caracteres")
    private String title;

    @Size(max = 5000, message = "La descripción no puede exceder los 5000 caracteres")
    private String description;

    @Pattern(regexp = "^(NUEVO|ASIGNADO|EN_PROGRESO|RESUELTO|CERRADO)$", message = "Estado no válido")
    private String status;

    @NotNull(message = "La prioridad es obligatoria")
    @Pattern(regexp = "^(BAJA|MEDIA|ALTA|CRÍTICA)$", message = "Prioridad no válida")
    private String priority;

    @NotNull(message = "El ID del usuario es obligatorio") 
    private Long userId;

    private String userEmail;

    private String userName;
    
    @Pattern(regexp = "^(ESTUDIANTE|INSTRUCTOR|ADMINISTRADOR)$", message = "Tipo de usuario no válido")
    private String userType;

    private Long assignedToId;

    private String assignedToName;

    private Long courseId;

    private String courseName;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private LocalDateTime closedAt;

    private Long categoryId;

    private String categoryName;

    private List<MessageDTO> messages = new ArrayList<>();

    private Integer satisfactionRating;

    private String feedback;

    private Integer responseTimeMinutes;

    private Integer messageCount;

    private Integer unreadMessageCount;
}
