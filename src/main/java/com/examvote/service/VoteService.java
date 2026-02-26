package com.examvote.service;

import com.examvote.model.ExamSession;
import com.examvote.model.Vote;
import com.examvote.repository.ExamSessionRepository;
import com.examvote.repository.VoteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class VoteService {

    private final ExamSessionRepository sessionRepository;
    private final VoteRepository voteRepository;

    @Transactional(readOnly = true)
    public ExamSession getSessionForTaking(UUID sessionId, UUID studentId) {
        ExamSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        if (!session.isOpen()) {
            throw new RuntimeException("This exam is not open");
        }

        return session;
    }

    @Transactional(readOnly = true)
    public List<Vote> getStudentVotingHistory(UUID studentId) {
        return voteRepository.findByStudentId(studentId);
    }

    @Transactional(readOnly = true)
    public boolean hasVoted(UUID sessionId, UUID studentId, UUID questionId) {
        return voteRepository.existsBySessionIdAndStudentIdAndQuestionId(sessionId, studentId, questionId);
    }

    @Transactional(readOnly = true)
    public Vote getVoteForQuestion(UUID sessionId, UUID studentId, UUID questionId) {
        return voteRepository.findBySessionIdAndStudentIdAndQuestionId(sessionId, studentId, questionId)
                .orElse(null);
    }
}