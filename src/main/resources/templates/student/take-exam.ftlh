<#import "/fragments/header.ftlh" as h>

<@h.header "${session.examName} - ExamVote"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <i class="fas fa-file-alt"></i>
            ${session.examName}
        </h2>
        <#if session.description?has_content>
            <p class="text-muted">${session.description}</p>
        </#if>
    </div>
    <div class="col-auto">
        <div class="btn-group">
            <a href="/student/dashboard" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </div>
</div>

<#if success??>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i>
        ${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</#if>

<#if error??>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle"></i>
        ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</#if>

<div class="row">
    <div class="col-md-8">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="fas fa-question-circle"></i>
                    Exam Questions
                </h5>
            </div>
            <div class="card-body">
                <#list session.questions as question>
                    <div class="question-card mb-4 p-3 border rounded
                        <#if voteService?? && voteService.hasVoted(session.id, user.id, question.id)>bg-light</#if>">

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">
                                Question ${question.questionOrder + 1}
                                <#if voteService?? && voteService.hasVoted(session.id, user.id, question.id)>
                                    <span class="badge bg-success ms-2">
                                        <i class="fas fa-check"></i> Answered
                                    </span>
                                </#if>
                            </h5>
                        </div>

                        <p class="fw-bold mb-3">${question.questionText}</p>

                        <#if session.open && (!voteService?? || !voteService.hasVoted(session.id, user.id, question.id))>
                            <form action="/student/sessions/${session.id}/vote" method="post" class="mb-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="questionId" value="${question.id}">

                                <div class="options-container">
                                    <#list question.options as option>
                                        <div class="form-check mb-2">
                                            <input class="form-check-input"
                                                   type="radio"
                                                   name="optionId"
                                                   id="option_${question.id}_${option.id}"
                                                   value="${option.id}"
                                                   required>
                                            <label class="form-check-label" for="option_${question.id}_${option.id}">
                                                ${option.optionText}
                                            </label>
                                        </div>
                                    </#list>
                                </div>

                                <div class="mt-3">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-check-circle"></i> Submit Answer for Question ${question.questionOrder + 1}
                                    </button>
                                </div>
                            </form>
                        <#else>
                            <div class="options-container">
                                <#list question.options as option>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input"
                                               type="radio"
                                               disabled
                                                <#if voteService?? && voteService.getVoteForQuestion(session.id, user.id, question.id)??
                                        && voteService.getVoteForQuestion(session.id, user.id, question.id).selectedOption.id == option.id>
                                        checked
                                                </#if>>
                                        <label class="form-check-label <#if !session.open>text-muted</#if>">
                                            ${option.optionText}
                                            <#if voteService?? && voteService.getVoteForQuestion(session.id, user.id, question.id)??
                                            && voteService.getVoteForQuestion(session.id, user.id, question.id).selectedOption.id == option.id>
                                                <span class="badge bg-success ms-2">Your answer</span>
                                            </#if>
                                        </label>
                                    </div>
                                </#list>
                            </div>
                        </#if>
                    </div>
                </#list>

                <#if session.open>
                    <div class="text-center mt-4">
                        <a href="/student/sessions/${session.id}/results" class="btn btn-outline-primary">
                            <i class="fas fa-chart-bar"></i> View Live Results
                        </a>
                    </div>
                </#if>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card shadow sticky-top" style="top: 20px;">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">
                    <i class="fas fa-info-circle"></i>
                    Exam Progress
                </h5>
            </div>
            <div class="card-body">
                <#assign answeredCount = 0 />
                <#list session.questions as q>
                    <#if voteService?? && voteService.hasVoted(session.id, user.id, q.id)>
                        <#assign answeredCount = answeredCount + 1 />
                    </#if>
                </#list>

                <div class="text-center mb-4">
                    <h1 class="display-4">${answeredCount}/${session.questions?size}</h1>
                    <p class="text-muted">Questions Answered</p>
                </div>

                <div class="progress mb-4" style="height: 20px;">
                    <#assign progressPercent = (answeredCount / session.questions?size) * 100 />
                    <div class="progress-bar bg-success"
                         style="width: ${progressPercent}%"
                         role="progressbar">
                        ${progressPercent?string("0")}%
                    </div>
                </div>

                <#if session.open>
                    <div class="alert alert-info">
                        <i class="fas fa-clock"></i>
                        <strong>Exam Status:</strong> Open for submissions
                    </div>
                <#elseif session.status == 'CLOSED'>
                    <div class="alert alert-secondary">
                        <i class="fas fa-door-closed"></i>
                        <strong>Exam Status:</strong> Closed
                    </div>
                </#if>

                <#if session.closeTime??>
                    <p class="small text-muted mb-0">
                        <i class="fas fa-calendar-alt"></i>
                        Closes:
                        <#assign closeDateTime = session.closeTime?split("T") />
                        ${closeDateTime[0]}
                        <#if closeDateTime?size gt 1>
                            ${closeDateTime[1]?substring(0,5)}
                        </#if>
                    </p>
                </#if>
            </div>
        </div>
    </div>
</div>

<@h.footer/>