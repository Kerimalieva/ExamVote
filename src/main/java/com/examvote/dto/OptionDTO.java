package com.examvote.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class OptionDTO {
    private UUID id;

    @NotBlank(message = "Option text is required")
    private String optionText;

    @NotNull(message = "Option order is required")
    private Integer optionOrder;

    private boolean correct; // Изменено с isCorrect на correct для лучшей совместимости
}