<#import "/fragments/header.ftlh" as h>

<@h.header "View Session - ExamVote"/>

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
            <a href="/admin/dashboard" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>
            <#if session.status == 'DRAFT'>
                <form action="/admin/sessions/${session.id}/open" method="post" class="d-inline">
                    <button type="submit" class="btn btn-success"
                            onclick="return confirm('Open this exam for students?')">
                        <i class="fas fa-door-open"></i> Open Session
                    </button>
                </form>
            <#elseif session.status == 'OPEN'>
                <form action="/admin/sessions/${session.id}/close" method="post" class="d-inline">
                    <button type="submit" class="btn btn-warning"
                            onclick="return confirm('Close this exam? No more votes will be accepted.')">
                        <i class="fas fa-door-closed"></i> Close Session
                    </button>
                </form>
            </#if>
            <a href="/admin/sessions/${session.id}/results" class="btn btn-primary">
                <i class="fas fa-chart-bar"></i> View Results
            </a>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-3">
        <div class="card">
            <div class="card-body">
                <h6 class="card-subtitle mb-2 text-muted">Status</h6>
                <h4>
                    <#if session.status == 'DRAFT'>
                        <span class="badge bg-warning">Draft</span>
                    <#elseif session.status == 'OPEN'>
                        <span class="badge bg-success">Open</span>
                    <#elseif session.status == 'CLOSED'>
                        <span class="badge bg-secondary">Closed</span>
                    </#if>
                </h4>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card">
            <div class="card-body">
                <h6 class="card-subtitle mb-2 text-muted">Questions</h6>
                <h4>${session.questions?size}</h4>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card">
            <div class="card-body">
                <h6 class="card-subtitle mb-2 text-muted">Created</h6>
                <#-- Форматируем дату из формата "2026-02-26T22:48:52.840732" -->
                <#assign dateTime = session.createdAt?split("T") />
                <h6>${dateTime[0]}</h6>
                <#if dateTime?size gt 1>
                    <#assign time = dateTime[1]?substring(0, 8) />
                    <small>${time}</small>
                </#if>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card">
            <div class="card-body">
                <h6 class="card-subtitle mb-2 text-muted">Created By</h6>
                <h6>${session.createdBy.fullName}</h6>
                <small>@${session.createdBy.username}</small>
            </div>
        </div>
    </div>
</div>

<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0">
            <i class="fas fa-tasks"></i>
            Questions and Options
        </h5>
    </div>
    <div class="card-body">
        <#list session.questions as question>
            <div class="question-block mb-4">
                <h5 class="mb-3">
                    <span class="badge bg-secondary me-2">${question_index + 1}</span>
                    ${question.questionText}
                </h5>

                <div class="ms-4">
                    <#list question.options as option>
                        <div class="mb-2">
                            <i class="fas fa-circle text-primary me-2" style="font-size: 8px;"></i>
                            ${option.optionText}
                            <#if question.correctOptionId?? && question.correctOptionId == option.id>
                                <span class="badge bg-success ms-2">
                                    <i class="fas fa-check"></i> Correct Answer
                                </span>
                            </#if>
                        </div>
                    </#list>
                </div>

                <#if question_has_next>
                    <hr class="my-4">
                </#if>
            </div>
        </#list>
    </div>
</div>

<@h.footer/>