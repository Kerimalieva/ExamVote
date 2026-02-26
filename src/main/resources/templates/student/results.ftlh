<#import "/fragments/header.ftlh" as h>

<@h.header "Exam Results - ExamVote"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <i class="fas fa-chart-bar"></i>
            Exam Results
        </h2>
        <p class="text-muted">${results.examName}</p>
    </div>
    <div class="col-auto">
        <a href="/student/dashboard" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-3">
        <div class="card bg-primary text-white">
            <div class="card-body text-center">
                <h5>Total Votes</h5>
                <h2 class="display-4">${results.totalVotes}</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-success text-white">
            <div class="card-body text-center">
                <h5>Questions</h5>
                <h2 class="display-4">${results.questionResults?size}</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-info text-white">
            <div class="card-body text-center">
                <h5>Status</h5>
                <h4>
                    <#if results.status == 'OPEN'>
                        <span class="badge bg-light text-dark">Open</span>
                    <#elseif results.status == 'CLOSED'>
                        <span class="badge bg-secondary">Closed</span>
                    </#if>
                </h4>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-warning text-white">
            <div class="card-body text-center">
                <h5>Calculated</h5>
                <#if results.calculatedAt??>
                    <#assign dateTime = results.calculatedAt?split("T") />
                    <h6>${dateTime[0]}</h6>
                    <#if dateTime?size gt 1>
                        <small>${dateTime[1]?substring(0,5)}</small>
                    </#if>
                </#if>
            </div>
        </div>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0">
            <i class="fas fa-chart-pie"></i>
            Results by Question
        </h5>
    </div>
    <div class="card-body">
        <#list results.questionResults as questionResult>
            <div class="question-result mb-5">
                <h5 class="mb-3">
                    Question ${questionResult_index + 1}: ${questionResult.questionText}
                </h5>

                <div class="row mb-3">
                    <div class="col-md-8">
                        <#list questionResult.optionVotes?keys as optionId>
                        <#-- Проверяем и преобразуем votes в число -->
                            <#assign voteValue = questionResult.optionVotes[optionId] />
                            <#if voteValue?is_string && voteValue == "">
                                <#assign votes = 0 />
                            <#else>
                                <#assign votes = voteValue?number />
                            </#if>

                            <#assign total = questionResult.totalVotesForQuestion?number />
                            <#if total gt 0>
                                <#assign percentage = (votes / total) * 100 />
                            <#else>
                                <#assign percentage = 0 />
                            </#if>

                        <#-- Получаем текст опции -->
                            <#assign optionText = questionResult.optionTexts[optionId]!"" />

                        <#-- Проверяем, является ли эта опция правильным ответом -->
                            <#assign isCorrect = false />
                            <#if session??>
                                <#list session.questions as sq>
                                    <#if sq.id == questionResult.questionId>
                                        <#if sq.correctOptionId?? && sq.correctOptionId?string == optionId>
                                            <#assign isCorrect = true />
                                        </#if>
                                    </#if>
                                </#list>
                            </#if>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1">
                                    <span>
                                        <strong>${optionText}</strong>
                                        <#if isCorrect>
                                            <span class="badge bg-success ms-2">Correct Answer</span>
                                        </#if>
                                    </span>
                                    <span>
                                        ${votes} votes (${percentage?string("0.0")}%)
                                    </span>
                                </div>
                                <div class="progress" style="height: 25px;">
                                    <div class="progress-bar
                                        <#if percentage >= 60>bg-success
                                        <#elseif percentage >= 30>bg-warning
                                        <#else>bg-danger</#if>"
                                         style="width: ${percentage}%"
                                         role="progressbar">
                                        ${votes}
                                    </div>
                                </div>
                            </div>
                        </#list>
                    </div>

                    <div class="col-md-4">
                        <div class="card bg-light">
                            <div class="card-body text-center">
                                <h6>Total for Question</h6>
                                <h3>${questionResult.totalVotesForQuestion}</h3>
                                <small class="text-muted">votes</small>
                            </div>
                        </div>
                    </div>
                </div>

                <#if questionResult_has_next>
                    <hr class="my-4">
                </#if>
            </div>
        </#list>
    </div>
    <div class="card-footer bg-light">
        <small class="text-muted">
            <i class="fas fa-hashtag"></i>
            Results Hash: ${results.resultsHash}
        </small>
    </div>
</div>

<@h.footer/>