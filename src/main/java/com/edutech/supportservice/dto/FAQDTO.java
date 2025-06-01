package com.edutech.supportservice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FAQDTO {

    private Long id;

    @NotBlank(message = "La pregunta es obligatoria")
    @Size(min = 10, max = 255, message = "La pregunta debe tener entre 10 y 255 caracteres")
    private String question;

    @NotBlank(message = "La respuesta es obligatoria")
    private String answer;

    private Integer viewCount;

    private Integer helpfulVotes;

    private Integer unhelpfulVotes;

    private Long categoryId;

    private String categoryName;

    private Boolean published;

    private String searchKeywords;

    private Integer displayOrder;

    private Double helpfulRatio; // Porcentaje de votos útiles
}
