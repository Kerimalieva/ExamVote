package com.examvote.dto;

import com.examvote.model.SessionStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
public class ExamSessionDTO {
    private UUID id;

    @NotBlank(message = "Exam name is required")
    @Size(max = 200, message = "Exam name must not exceed 200 characters")
    private String examName;

    @Size(max = 1000, message = "Description must not exceed 1000 characters")
    private String description;

    private SessionStatus status;
    private LocalDateTime openTime;
    private LocalDateTime closeTime;
    private String createdBy;
    private LocalDateTime createdAt;
    private List<QuestionDTO> questions = new ArrayList<>();
    private long totalVotes;
}