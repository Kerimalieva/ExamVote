<#import "/fragments/header.ftlh" as h>

<@h.header "Admin Results - ExamVote"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <i class="fas fa-chart-line"></i>
            Exam Results: ${results.examName}
        </h2>
    </div>
    <div class="col-auto">
        <a href="/admin/sessions/${results.sessionId}" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left"></i> Back to Session
        </a>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-3">
        <div class="card bg-primary text-white">
            <div class="card-body">
                <h5>Total Votes</h5>
                <h2>${results.totalVotes}</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-success text-white">
            <div class="card-body">
                <h5>Participation Rate</h5>
                <#assign totalPossible = results.questionResults?size * 10 />
                <#if totalPossible gt 0>
                    <#assign participationRate = (results.totalVotes / totalPossible) * 100 />
                <#else>
                    <#assign participationRate = 0 />
                </#if>
                <h2>${participationRate?string("0.0")}%</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-info text-white">
            <div class="card-body">
                <h5>Questions</h5>
                <h2>${results.questionResults?size}</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-warning text-white">
            <div class="card-body">
                <h5>Status</h5>
                <h4>
                    <#if results.status == 'OPEN'>
                        <span class="badge bg-light">OPEN</span>
                    <#elseif results.status == 'CLOSED'>
                        <span class="badge bg-secondary">CLOSED</span>
                    </#if>
                </h4>
            </div>
        </div>
    </div>
</div>

<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0">
            <i class="fas fa-chart-pie"></i>
            Results by Question
        </h5>
    </div>
    <div class="card-body">
        <#-- Используем session.questions для получения текстов опций -->
        <#list session.questions as question>
        <#-- Находим соответствующий результат по вопросу -->
            <#assign questionResult = results.questionResults[question_index]! />

            <div class="question-result mb-5">
                <h5 class="mb-3">
                    Question ${question_index + 1}: ${question.questionText}
                </h5>
                <p class="text-muted">Total votes: ${questionResult.totalVotesForQuestion!0}</p>

                <div class="row">
                    <div class="col-md-8">
                        <#-- Используем опции из session для отображения текстов -->
                        <#list question.options as option>
                        <#-- Получаем голоса из results по ID опции -->
                            <#assign votesNum = 0 />
                            <#if questionResult?? && questionResult.optionVotes[option.id]??>
                                <#assign voteValue = questionResult.optionVotes[option.id] />
                                <#if voteValue?is_string>
                                    <#if voteValue?has_content>
                                        <#assign votesNum = voteValue?number />
                                    </#if>
                                <#else>
                                    <#assign votesNum = voteValue />
                                </#if>
                            </#if>

                        <#-- Вычисляем процент -->
                            <#assign percentage = 0 />
                            <#if questionResult?? && questionResult.totalVotesForQuestion gt 0>
                                <#assign percentage = (votesNum / questionResult.totalVotesForQuestion) * 100 />
                            </#if>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1">
                                    <span>
                                        <strong>${option.optionText}</strong>
                                        <#if question.correctOptionId?? && question.correctOptionId == option.id>
                                            <span class="badge bg-success ms-2">Correct Answer</span>
                                        </#if>
                                    </span>
                                    <span>${votesNum} votes (${percentage?string("0.0")}%)</span>
                                </div>
                                <div class="progress" style="height: 25px;">
                                    <div class="progress-bar
                                        <#if percentage >= 60>bg-success
                                        <#elseif percentage >= 30>bg-warning
                                        <#else>bg-danger</#if>"
                                         style="width: ${percentage}%"
                                         role="progressbar">
                                        ${votesNum}
                                    </div>
                                </div>
                            </div>
                        </#list>
                    </div>
                </div>

                <#if question_has_next>
                    <hr class="my-4">
                </#if>
            </div>
        </#list>
    </div>
    <div class="card-footer bg-light">
        <div class="row">
            <div class="col-md-6">
                <small class="text-muted">
                    <i class="fas fa-clock"></i>
                    Results calculated:
                    <#if results.calculatedAt??>
                        <#if results.calculatedAt?is_string>
                            <#assign dateTime = results.calculatedAt?split("T") />
                            ${dateTime[0]}
                            <#if dateTime?size gt 1>
                                ${dateTime[1]?substring(0,5)}
                            </#if>
                        <#else>
                            ${results.calculatedAt}
                        </#if>
                    </#if>
                </small>
            </div>
            <div class="col-md-6 text-end">
                <small class="text-muted">
                    <i class="fas fa-hashtag"></i>
                    Hash: ${results.resultsHash}
                </small>
            </div>
        </div>
    </div>
</div>

<script>
    function exportToCSV() {
        let csv = "Question,Option,Votes,Percentage\n";

        <#list session.questions as question>
        <#assign questionResult = results.questionResults[question_index]! />
        <#list question.options as option>
        <#assign votesNum = 0 />
        <#if questionResult?? && questionResult.optionVotes[option.id]??>
        <#assign voteValue = questionResult.optionVotes[option.id] />
        <#if voteValue?is_string>
        <#if voteValue?has_content>
        <#assign votesNum = voteValue?number />
        </#if>
        <#else>
        <#assign votesNum = voteValue />
        </#if>
        </#if>

        <#assign percentage = 0 />
        <#if questionResult?? && questionResult.totalVotesForQuestion gt 0>
        <#assign percentage = (votesNum / questionResult.totalVotesForQuestion) * 100 />
        </#if>

        csv += "Question ${question_index + 1}: ${question.questionText},";
        csv += "${option.optionText},";
        csv += "${votesNum},";
        csv += "${percentage?string("0.0")}%\n";
        </#list>
        </#list>

        const blob = new Blob([csv], { type: 'text/csv' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'exam_results_${results.sessionId}.csv';
        a.click();
    }
</script>

<@h.footer/>