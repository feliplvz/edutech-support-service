package com.edutech.supportservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tickets")
public class Ticket {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "El título del ticket es obligatorio")
    @Size(min = 5, max = 100, message = "El título debe tener entre 5 y 100 caracteres")
    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private String status;  // NUEVO, ASIGNADO, EN_PROGRESO, RESUELTO, CERRADO

    @Column(nullable = false)
    private String priority;  // BAJA, MEDIA, ALTA, CRÍTICA

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "user_email")
    private String userEmail;

    @Column(name = "user_name")
    private String userName;

    @Column(name = "user_type")
    private String userType;  // ESTUDIANTE, INSTRUCTOR, ADMINISTRADOR

    @Column(name = "assigned_to")
    private Long assignedToId;

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_name")
    private String courseName;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "closed_at")
    private LocalDateTime closedAt;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id")
    private TicketCategory category;

    @OneToMany(mappedBy = "ticket", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("created_at ASC")
    private List<Message> messages = new ArrayList<>();

    @Column(name = "satisfaction_rating")
    private Integer satisfactionRating;  // 1-5 estrellas

    @Column(name = "feedback")
    private String feedback;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = "NUEVO";
        }
        if (priority == null) {
            priority = "MEDIA";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();

        // Si el estado cambia a CERRADO, registrar la fecha de cierre
        if ("CERRADO".equals(status) && closedAt == null) {
            closedAt = LocalDateTime.now();
        }
    }
}
