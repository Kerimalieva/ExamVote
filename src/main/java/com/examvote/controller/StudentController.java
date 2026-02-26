package com.examvote.controller;

import com.examvote.dto.VoteRequest;
import com.examvote.model.ExamSession;
import com.examvote.model.User;
import com.examvote.model.Vote;
import com.examvote.repository.ExamSessionRepository;
import com.examvote.service.ExamService;
import com.examvote.service.VoteService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/student")
@RequiredArgsConstructor
@Slf4j
public class StudentController {

    private final ExamService examService;
    private final VoteService voteService;
    private final ExamSessionRepository sessionRepository;

    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal User user, Model model) {
        List<ExamSession> availableSessions = examService.getAvailableSessionsForStudent(user.getUsername());
        model.addAttribute("sessions", availableSessions);
        model.addAttribute("user", user);
        return "student/dashboard";
    }

    @GetMapping("/sessions/{id}/take")
    public String takeExam(@PathVariable UUID id,
                           @AuthenticationPrincipal User user,
                           Model model) {

        ExamSession session = voteService.getSessionForTaking(id, user.getId());
        model.addAttribute("session", session);
        model.addAttribute("voteRequest", new VoteRequest());
        model.addAttribute("voteService", voteService);
        return "student/take-exam";
    }

    @PostMapping("/sessions/{id}/vote")
    public String submitVote(@PathVariable UUID id,
                             @ModelAttribute VoteRequest voteRequest,
                             @AuthenticationPrincipal User user,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {

        log.info("=== VOTE SUBMISSION ===");
        log.info("Session ID from path: {}", id);
        log.info("Question ID from form: {}", voteRequest.getQuestionId());
        log.info("Option ID from form: {}", voteRequest.getOptionId());
        log.info("User: {}", user.getUsername());

        try {
            voteRequest.setSessionId(id);
            Vote vote = examService.submitVote(
                    voteRequest,
                    user.getUsername(),
                    request.getRemoteAddr(),
                    request.getHeader("User-Agent")
            );

            log.info("Vote submitted successfully. Vote ID: {}", vote.getId());
            redirectAttributes.addFlashAttribute("success", "Answer submitted successfully!");

        } catch (Exception e) {
            log.error("Error submitting vote", e);
            redirectAttributes.addFlashAttribute("error", "Error: " + e.getMessage());
        }

        return "redirect:/student/sessions/" + id + "/take";
    }

    @GetMapping("/sessions/{id}/results")
    public String viewResults(@PathVariable UUID id, Model model) {
        var results = examService.getResults(id);

        // Добавляем session для получения правильных ответов
        ExamSession session = sessionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        model.addAttribute("results", results);
        model.addAttribute("session", session); // Добавляем это!

        return "student/results";
    }

    @GetMapping("/history")
    public String history(@AuthenticationPrincipal User user, Model model) {
        var history = voteService.getStudentVotingHistory(user.getId());
        model.addAttribute("history", history);
        return "student/history";
    }
}