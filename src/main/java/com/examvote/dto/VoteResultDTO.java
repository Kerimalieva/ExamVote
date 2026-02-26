package com.examvote.dto;

import com.examvote.model.SessionStatus;
import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class VoteResultDTO {
    private UUID sessionId;
    private String examName;
    private SessionStatus status;
    private List<QuestionResultDTO> questionResults;
    private long totalVotes;
    private String resultsHash;
    private LocalDateTime calculatedAt;
}