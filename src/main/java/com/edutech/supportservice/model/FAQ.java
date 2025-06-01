package com.edutech.supportservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "faqs")
public class FAQ {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "La pregunta es obligatoria")
    @Size(min = 10, max = 255, message = "La pregunta debe tener entre 10 y 255 caracteres")
    @Column(nullable = false)
    private String question;

    @NotBlank(message = "La respuesta es obligatoria")
    @Column(columnDefinition = "TEXT", nullable = false)
    private String answer;

    @Column(name = "view_count")
    private Integer viewCount = 0;

    @Column(name = "helpful_votes")
    private Integer helpfulVotes = 0;

    @Column(name = "unhelpful_votes")
    private Integer unhelpfulVotes = 0;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id")
    private TicketCategory category;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(nullable = false)
    private Boolean published = false;

    @Column(name = "search_keywords")
    private String searchKeywords;

    @Column(name = "display_order")
    private Integer displayOrder;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public void incrementViewCount() {
        if (viewCount == null) {
            viewCount = 0;
        }
        viewCount++;
    }

    public void addHelpfulVote() {
        if (helpfulVotes == null) {
            helpfulVotes = 0;
        }
        helpfulVotes++;
    }

    public void addUnhelpfulVote() {
        if (unhelpfulVotes == null) {
            unhelpfulVotes = 0;
        }
        unhelpfulVotes++;
    }
}
