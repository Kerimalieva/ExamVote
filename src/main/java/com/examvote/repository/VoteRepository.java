package com.examvote.repository;

import com.examvote.model.Vote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface VoteRepository extends JpaRepository<Vote, UUID> {

    // Проверка существования голоса
    boolean existsBySessionIdAndStudentIdAndQuestionId(UUID sessionId, UUID studentId, UUID questionId);

    // Поиск конкретного голоса
    Optional<Vote> findBySessionIdAndStudentIdAndQuestionId(UUID sessionId, UUID studentId, UUID questionId);

    // Все голоса за сессию
    List<Vote> findBySessionId(UUID sessionId);

    // Все голоса студента
    List<Vote> findByStudentId(UUID studentId);

    // Подсчет голосов за сессию (исправлено)
    @Query("SELECT COUNT(v) FROM Vote v WHERE v.session.id = :sessionId")
    long countBySessionId(@Param("sessionId") UUID sessionId);

    // Подсчет голосов студента за сессию (исправлено)
    @Query("SELECT COUNT(v) FROM Vote v WHERE v.session.id = :sessionId AND v.student.id = :studentId")
    long countBySessionIdAndStudentId(@Param("sessionId") UUID sessionId, @Param("studentId") UUID studentId);

    // Подсчет голосов по вопросу
    @Query("SELECT v.selectedOption.id, COUNT(v) FROM Vote v " +
            "WHERE v.session.id = :sessionId AND v.question.id = :questionId " +
            "GROUP BY v.selectedOption.id")
    List<Object[]> countVotesByQuestion(@Param("sessionId") UUID sessionId, @Param("questionId") UUID questionId);

    // Удаление всех голосов за сессию
    @Modifying
    @Query("DELETE FROM Vote v WHERE v.session.id = :sessionId")
    void deleteBySessionId(@Param("sessionId") UUID sessionId);

    // Получение всех голосов студента за сессию
    List<Vote> findBySessionIdAndStudentId(UUID sessionId, UUID studentId);

    // Подсчет всех голосов за вопрос
    @Query("SELECT COUNT(v) FROM Vote v WHERE v.question.id = :questionId")
    long countByQuestionId(@Param("questionId") UUID questionId);

    // Проверка, голосовал ли студент за сессию
    boolean existsBySessionIdAndStudentId(UUID sessionId, UUID studentId);

    // Получение всех голосов за сессию с пагинацией (для больших результатов)
    List<Vote> findBySessionIdOrderByVoteTimestampDesc(UUID sessionId);

    // Статистика по сессии
    @Query("SELECT v.question.id, COUNT(v) FROM Vote v " +
            "WHERE v.session.id = :sessionId " +
            "GROUP BY v.question.id")
    List<Object[]> getVoteCountPerQuestion(@Param("sessionId") UUID sessionId);

    // Статистика по студенту
    @Query("SELECT v.session.id, COUNT(v) FROM Vote v " +
            "WHERE v.student.id = :studentId " +
            "GROUP BY v.session.id")
    List<Object[]> getVoteCountPerSessionByStudent(@Param("studentId") UUID studentId);
}