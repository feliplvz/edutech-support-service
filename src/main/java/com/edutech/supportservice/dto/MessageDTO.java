package com.edutech.supportservice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO para representar mensajes en los tickets de soporte
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MessageDTO {

    private Long id;

    @NotBlank(message = "El contenido del mensaje es obligatorio")
    @Size(min = 1, max = 10000, message = "El contenido debe tener entre 1 y 10000 caracteres")
    private String content;

    @NotNull(message = "El ID del remitente es obligatorio")
    private Long senderId;

    private String senderName;

    private String senderEmail;

    @NotNull(message = "El tipo de remitente es obligatorio")
    private String senderType;

    private String attachmentUrl;

    private String attachmentType;

    private Boolean isInternalNote;

    private LocalDateTime createdAt;

    @NotNull(message = "El ID del ticket es obligatorio")
    private Long ticketId;

    private Boolean isRead;
}
