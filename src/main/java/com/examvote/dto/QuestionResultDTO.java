package com.examvote.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Map;
import java.util.UUID;
import java.util.HashMap;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuestionResultDTO {
    private UUID questionId;
    private String questionText;

    @JsonProperty("optionVotes")
    private Map<String, Long> optionVotes;  // Изменяем на Map<String, Long>

    @JsonProperty("optionTexts")
    private Map<String, String> optionTexts; // Изменяем на Map<String, String>

    private long totalVotesForQuestion;

    // Вспомогательные методы для конвертации
    public static QuestionResultDTO from(UUID questionId, String questionText,
                                         Map<UUID, Long> uuidVotes,
                                         Map<UUID, String> uuidTexts,
                                         long totalVotes) {
        Map<String, Long> stringVotes = new HashMap<>();
        for (Map.Entry<UUID, Long> entry : uuidVotes.entrySet()) {
            stringVotes.put(entry.getKey().toString(), entry.getValue());
        }

        Map<String, String> stringTexts = new HashMap<>();
        for (Map.Entry<UUID, String> entry : uuidTexts.entrySet()) {
            stringTexts.put(entry.getKey().toString(), entry.getValue());
        }

        return QuestionResultDTO.builder()
                .questionId(questionId)
                .questionText(questionText)
                .optionVotes(stringVotes)
                .optionTexts(stringTexts)
                .totalVotesForQuestion(totalVotes)
                .build();
    }
}