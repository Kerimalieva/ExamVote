package com.examvote.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
public class QuestionDTO {
    private UUID id;

    @NotBlank(message = "Question text is required")
    private String questionText;

    @NotNull(message = "Question order is required")
    private Integer questionOrder;

    private UUID correctOptionId; // ID правильного ответа

    private List<OptionDTO> options = new ArrayList<>();
}