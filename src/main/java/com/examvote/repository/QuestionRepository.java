package com.examvote.repository;

import com.examvote.model.Question;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface QuestionRepository extends JpaRepository<Question, UUID> {

    List<Question> findBySessionIdOrderByQuestionOrder(UUID sessionId);

    @Query("SELECT COUNT(v) FROM Vote v WHERE v.question.id = :questionId")
    long countVotesByQuestion(@Param("questionId") UUID questionId);
}