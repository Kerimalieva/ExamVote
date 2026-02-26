package com.examvote.controller;

import com.examvote.dto.ExamSessionDTO;
import com.examvote.dto.OptionDTO;
import com.examvote.dto.QuestionDTO;
import com.examvote.model.ExamSession;
import com.examvote.model.User;
import com.examvote.repository.ExamSessionRepository;
import com.examvote.service.ExamService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

    private final ExamService examService;
    private final ExamSessionRepository sessionRepository;

    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal User user, Model model) {
        List<ExamSession> sessions = sessionRepository.findByCreatedBy(user.getId());
        model.addAttribute("sessions", sessions);
        model.addAttribute("user", user);
        return "admin/dashboard";
    }

    @GetMapping("/sessions/create")
    public String createSessionForm() {
        return "admin/create-session";
    }

    @PostMapping("/sessions/create")
    @ResponseBody
    public ResponseEntity<?> createSession(@RequestBody ExamSessionDTO sessionDTO,
                                           @AuthenticationPrincipal User user) {
        try {
            log.info("Received session creation request: {}", sessionDTO);

            // Валидация
            if (sessionDTO.getExamName() == null || sessionDTO.getExamName().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Exam name is required"));
            }

            if (sessionDTO.getQuestions() == null || sessionDTO.getQuestions().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "At least one question is required"));
            }

            for (int i = 0; i < sessionDTO.getQuestions().size(); i++) {
                QuestionDTO q = sessionDTO.getQuestions().get(i);
                if (q.getQuestionText() == null || q.getQuestionText().trim().isEmpty()) {
                    return ResponseEntity.badRequest().body(Map.of("error", "Question " + (i + 1) + " text is required"));
                }

                if (q.getOptions() == null || q.getOptions().size() < 2) {
                    return ResponseEntity.badRequest().body(Map.of("error", "Question " + (i + 1) + " must have at least 2 options"));
                }

                boolean hasCorrect = false;
                for (int j = 0; j < q.getOptions().size(); j++) {
                    OptionDTO o = q.getOptions().get(j);
                    if (o.getOptionText() == null || o.getOptionText().trim().isEmpty()) {
                        return ResponseEntity.badRequest().body(Map.of("error", "Option " + (j + 1) + " of Question " + (i + 1) + " text is required"));
                    }
                    if (o.isCorrect()) {
                        hasCorrect = true;
                    }
                }

                if (!hasCorrect) {
                    return ResponseEntity.badRequest().body(Map.of("error", "Question " + (i + 1) + " must have a correct answer"));
                }
            }

            ExamSession session = examService.createExamSession(sessionDTO, user.getUsername());
            Map<String, String> response = new HashMap<>();
            response.put("redirect", "/admin/sessions/" + session.getId());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Error creating session", e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/sessions/{id}")
    public String viewSession(@PathVariable UUID id, Model model) {
        ExamSession session = sessionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Session not found"));
        model.addAttribute("session", session);
        return "admin/view-session";
    }

    @PostMapping("/sessions/{id}/open")
    public String openSession(@PathVariable UUID id, RedirectAttributes redirectAttributes) {
        try {
            examService.openSession(id);
            redirectAttributes.addFlashAttribute("success", "Session opened successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/sessions/" + id;
    }

    @PostMapping("/sessions/{id}/close")
    public String closeSession(@PathVariable UUID id, RedirectAttributes redirectAttributes) {
        try {
            examService.closeSession(id);
            redirectAttributes.addFlashAttribute("success", "Session closed successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/sessions/" + id;
    }

    @GetMapping("/sessions/{id}/results")
    public String viewResults(@PathVariable UUID id, Model model) {
        try {
            // Получаем сессию для доступа к оригинальным вопросам и опциям
            ExamSession session = sessionRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Session not found"));

            // Получаем результаты голосования
            var results = examService.getResults(id);

            log.info("Results for session {}: {}", id, results);
            log.info("Question results size: {}", results.getQuestionResults().size());

            // Передаем в модель оба объекта
            model.addAttribute("session", session);
            model.addAttribute("results", results);

            return "admin/results";
        } catch (Exception e) {
            log.error("Error viewing results", e);
            return "redirect:/admin/dashboard";
        }
    }

}