package com.examvote.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class VoteRequest {

    @NotNull(message = "Session ID is required")
    private UUID sessionId;

    @NotNull(message = "Question ID is required")
    private UUID questionId;

    @NotNull(message = "Option ID is required")
    private UUID optionId;
}