package com.examvote.repository;

import com.examvote.model.Option;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface OptionRepository extends JpaRepository<Option, UUID> {

    List<Option> findByQuestionIdOrderByOptionOrder(UUID questionId);


    @Query("SELECT COUNT(v) FROM Vote v WHERE v.selectedOption.id = :optionId")
    long countVotesByOption(@Param("optionId") UUID optionId);
}