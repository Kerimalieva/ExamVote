package com.examvote.repository;

import com.examvote.model.ExamSession;
import com.examvote.model.SessionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ExamSessionRepository extends JpaRepository<ExamSession, UUID> {

    List<ExamSession> findByStatus(SessionStatus status);

    @Query("SELECT s FROM ExamSession s WHERE s.status = :status AND s.openTime <= :now")
    List<ExamSession> findOpenSessions(@Param("status") SessionStatus status, @Param("now") LocalDateTime now);

    @Query("SELECT s FROM ExamSession s WHERE s.createdBy.id = :userId")
    List<ExamSession> findByCreatedBy(@Param("userId") UUID userId);

    @Query("SELECT COUNT(v) FROM Vote v WHERE v.session.id = :sessionId")
    long countVotesBySession(@Param("sessionId") UUID sessionId);
}