package com.examvote.service;

import com.examvote.dto.*;
import com.examvote.model.*;
import com.examvote.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ExamService {

    private final ExamSessionRepository sessionRepository;
    private final QuestionRepository questionRepository;
    private final OptionRepository optionRepository;
    private final VoteRepository voteRepository;
    private final UserRepository userRepository;

    @Transactional
    public ExamSession createExamSession(ExamSessionDTO sessionDTO, String creatorUsername) {
        User creator = userRepository.findByUsername(creatorUsername)
                .orElseThrow(() -> new RuntimeException("Creator not found"));

        ExamSession session = new ExamSession();
        session.setExamName(sessionDTO.getExamName());
        session.setDescription(sessionDTO.getDescription());
        session.setStatus(SessionStatus.DRAFT);
        session.setCreatedBy(creator);

        // Сначала сохраняем сессию
        ExamSession savedSession = sessionRepository.save(session);
        log.info("Saved exam session with ID: {}", savedSession.getId());

        // Добавляем вопросы и опции
        if (sessionDTO.getQuestions() != null) {
            for (QuestionDTO qDto : sessionDTO.getQuestions()) {
                Question question = new Question();
                question.setQuestionText(qDto.getQuestionText());
                question.setQuestionOrder(qDto.getQuestionOrder());
                question.setSession(savedSession);

                // Сохраняем вопрос
                Question savedQuestion = questionRepository.save(question);
                log.info("Saved question with ID: {}", savedQuestion.getId());

                if (qDto.getOptions() != null) {
                    for (OptionDTO oDto : qDto.getOptions()) {
                        Option option = new Option();
                        option.setOptionText(oDto.getOptionText());
                        option.setOptionOrder(oDto.getOptionOrder());
                        option.setQuestion(savedQuestion);

                        // Сохраняем опцию
                        Option savedOption = optionRepository.save(option);
                        log.info("Saved option with ID: {}", savedOption.getId());

                        // Если это правильный ответ
                        if (oDto.isCorrect()) {
                            savedQuestion.setCorrectOptionId(savedOption.getId());
                            questionRepository.save(savedQuestion);
                            log.info("Set correct option for question: {}", savedQuestion.getId());
                        }
                    }
                }
            }
        }

        log.info("Exam session created: {} by {}", savedSession.getExamName(), creatorUsername);
        return savedSession;
    }

    @Transactional(readOnly = true)
    public boolean isAnswerCorrect(UUID sessionId, UUID questionId, UUID optionId) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        return question.getCorrectOptionId() != null &&
                question.getCorrectOptionId().equals(optionId);
    }

    @Transactional
    public void openSession(UUID sessionId) {
        ExamSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        if (session.getStatus() != SessionStatus.DRAFT) {
            throw new RuntimeException("Session cannot be opened from current status");
        }

        session.setStatus(SessionStatus.OPEN);
        session.setOpenTime(LocalDateTime.now());

        sessionRepository.save(session);
        log.info("Exam session opened: {}", session.getExamName());
    }

    @Transactional
    public void closeSession(UUID sessionId) {
        ExamSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        if (session.getStatus() != SessionStatus.OPEN) {
            throw new RuntimeException("Only open sessions can be closed");
        }

        session.setStatus(SessionStatus.CLOSED);
        session.setCloseTime(LocalDateTime.now());

        sessionRepository.save(session);
        log.info("Exam session closed: {}", session.getExamName());
    }

    @Transactional
    public Vote submitVote(VoteRequest request, String studentUsername, String ipAddress, String userAgent) {
        log.info("Submitting vote - Session: {}, Question: {}, Option: {}, Student: {}",
                request.getSessionId(), request.getQuestionId(), request.getOptionId(), studentUsername);

        ExamSession session = sessionRepository.findById(request.getSessionId())
                .orElseThrow(() -> new RuntimeException("Session not found"));

        if (session.getStatus() != SessionStatus.OPEN) {
            throw new RuntimeException("Session is not open for voting");
        }

        User student = userRepository.findByUsername(studentUsername)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        Question question = questionRepository.findById(request.getQuestionId())
                .orElseThrow(() -> new RuntimeException("Question not found"));

        Option option = optionRepository.findById(request.getOptionId())
                .orElseThrow(() -> new RuntimeException("Option not found"));

        // Check if already voted
        if (voteRepository.existsBySessionIdAndStudentIdAndQuestionId(
                session.getId(), student.getId(), question.getId())) {
            throw new RuntimeException("Student already voted for this question");
        }

        Vote vote = new Vote();
        vote.setSession(session);
        vote.setQuestion(question);
        vote.setSelectedOption(option);
        vote.setStudent(student);
        vote.setIpAddress(ipAddress);
        vote.setUserAgent(userAgent);
        vote.setVoteHash(generateVoteHash(vote));

        Vote saved = voteRepository.save(vote);
        log.info("Vote saved with ID: {}", saved.getId());

        return saved;
    }

//    @Transactional(readOnly = true)
//    public VoteResultDTO getResults(UUID sessionId) {
//        log.info("Getting results for session: {}", sessionId);
//
//        ExamSession session = sessionRepository.findById(sessionId)
//                .orElseThrow(() -> new RuntimeException("Session not found"));
//
//        List<Question> questions = questionRepository.findBySessionIdOrderByQuestionOrder(sessionId);
//        log.info("Found {} questions", questions.size());
//
//        long totalVotes = voteRepository.countBySessionId(sessionId);
//        log.info("Total votes: {}", totalVotes);
//
//        List<QuestionResultDTO> questionResults = new ArrayList<>();
//
//        for (Question question : questions) {
//            log.info("Processing question: {} - {}", question.getId(), question.getQuestionText());
//
//            Map<UUID, Long> voteCounts = new HashMap<>();
//            Map<UUID, String> optionTexts = new HashMap<>();
//
//            // Получаем все опции для вопроса
//            List<Option> options = optionRepository.findByQuestionIdOrderByOptionOrder(question.getId());
//            log.info("Found {} options for question", options.size());
//
//            // Инициализируем все опции с 0 голосов
//            for (Option option : options) {
//                optionTexts.put(option.getId(), option.getOptionText());
//                voteCounts.put(option.getId(), 0L);
//                log.info("Option: {} - {}", option.getId(), option.getOptionText());
//            }
//
//            // Получаем реальные голоса
//            List<Object[]> counts = voteRepository.countVotesByQuestion(sessionId, question.getId());
//            log.info("Found {} vote counts for question", counts.size());
//
//            for (Object[] count : counts) {
//                UUID optionId = (UUID) count[0];
//                Long voteCount = (Long) count[1];
//                voteCounts.put(optionId, voteCount);
//                log.info("Vote count for option {}: {}", optionId, voteCount);
//            }
//
//            questionResults.add(QuestionResultDTO.builder()
//                    .questionId(question.getId())
//                    .questionText(question.getQuestionText())
//                    .optionVotes(voteCounts)
//                    .optionTexts(optionTexts)
//                    .totalVotesForQuestion(voteCounts.values().stream().mapToLong(Long::longValue).sum())
//                    .build());
//        }
//
//        String resultsHash = generateResultsHash(sessionId, questionResults);
//
//        VoteResultDTO result = VoteResultDTO.builder()
//                .sessionId(sessionId)
//                .examName(session.getExamName())
//                .status(session.getStatus())
//                .questionResults(questionResults)
//                .totalVotes(totalVotes)
//                .resultsHash(resultsHash)
//                .calculatedAt(LocalDateTime.now())
//                .build();
//
//        log.info("Returning results with {} questions", result.getQuestionResults().size());
//        return result;
//    }

    @Transactional(readOnly = true)
    public VoteResultDTO getResults(UUID sessionId) {
        log.info("Getting results for session: {}", sessionId);

        ExamSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        List<Question> questions = questionRepository.findBySessionIdOrderByQuestionOrder(sessionId);
        long totalVotes = voteRepository.countBySessionId(sessionId);

        List<QuestionResultDTO> questionResults = new ArrayList<>();

        for (Question question : questions) {
            Map<UUID, Long> voteCounts = new HashMap<>();
            Map<UUID, String> optionTexts = new HashMap<>();

            // Получаем все опции для вопроса
            List<Option> options = optionRepository.findByQuestionIdOrderByOptionOrder(question.getId());
            log.info("Found {} options for question: {}", options.size(), question.getId());

            // Заполняем optionTexts и инициализируем voteCounts
            for (Option option : options) {
                String optionText = option.getOptionText();
                optionTexts.put(option.getId(), optionText);
                voteCounts.put(option.getId(), 0L);
                log.info("Added to optionTexts: ID={}, Text='{}'", option.getId(), optionText);
            }

            // Получаем реальные голоса
            List<Object[]> counts = voteRepository.countVotesByQuestion(sessionId, question.getId());
            log.info("Found {} vote counts for question", counts.size());

            for (Object[] count : counts) {
                UUID optionId = (UUID) count[0];
                Long voteCount = (Long) count[1];
                voteCounts.put(optionId, voteCount);
                log.info("Vote count for option {}: {}", optionId, voteCount);
            }

            // Используем вспомогательный метод для создания DTO
            QuestionResultDTO questionResult = QuestionResultDTO.from(
                    question.getId(),
                    question.getQuestionText(),
                    voteCounts,
                    optionTexts,
                    voteCounts.values().stream().mapToLong(Long::longValue).sum()
            );

            log.info("Created QuestionResultDTO for question: {}", question.getId());
            questionResults.add(questionResult);
        }

        String resultsHash = generateResultsHash(sessionId, questionResults);

        VoteResultDTO result = VoteResultDTO.builder()
                .sessionId(sessionId)
                .examName(session.getExamName())
                .status(session.getStatus())
                .questionResults(questionResults)
                .totalVotes(totalVotes)
                .resultsHash(resultsHash)
                .calculatedAt(LocalDateTime.now())
                .build();

        log.info("Returning results with {} questions", result.getQuestionResults().size());
        return result;
    }

    @Transactional(readOnly = true)
    public List<ExamSession> getAvailableSessionsForStudent(String studentUsername) {
        User student = userRepository.findByUsername(studentUsername)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        List<ExamSession> openSessions = sessionRepository.findByStatus(SessionStatus.OPEN);

        // Filter sessions where student hasn't completed all questions
        return openSessions.stream()
                .filter(session -> {
                    long totalQuestions = session.getQuestions().size();
                    long votedQuestions = voteRepository.countBySessionIdAndStudentId(session.getId(), student.getId());
                    return votedQuestions < totalQuestions;
                })
                .collect(Collectors.toList());
    }

    private String generateVoteHash(Vote vote) {
        try {
            String data = vote.getSession().getId().toString() +
                    vote.getStudent().getId().toString() +
                    vote.getQuestion().getId().toString() +
                    vote.getSelectedOption().getId().toString() +
                    vote.getVoteTimestamp().toString();

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(data.getBytes());

            return bytesToHex(hash);
        } catch (Exception e) {
            log.error("Error generating vote hash", e);
            return UUID.randomUUID().toString();
        }
    }

    private String generateResultsHash(UUID sessionId, List<QuestionResultDTO> results) {
        try {
            StringBuilder data = new StringBuilder(sessionId.toString());
            for (QuestionResultDTO qr : results) {
                data.append(qr.getQuestionId());
                for (Map.Entry<String, Long> entry : qr.getOptionVotes().entrySet()) {
                    data.append(entry.getKey()).append(entry.getValue());
                }
            }

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(data.toString().getBytes());

            return bytesToHex(hash);
        } catch (Exception e) {
            log.error("Error generating results hash", e);
            return UUID.randomUUID().toString();
        }
    }

    private String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
}