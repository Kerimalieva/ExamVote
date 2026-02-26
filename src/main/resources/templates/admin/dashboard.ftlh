<#import "/fragments/header.ftlh" as h>

<@h.header "Admin Dashboard - ExamVote"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <i class="fas fa-tachometer-alt"></i>
            Admin Dashboard
        </h2>
        <p class="text-muted">Welcome back, ${user.fullName}!</p>
    </div>
    <div class="col-auto">
        <a href="/admin/sessions/create" class="btn btn-primary btn-lg">
            <i class="fas fa-plus-circle"></i> Create New Exam
        </a>
    </div>
</div>

<#if sessions?size == 0>
    <div class="alert alert-info text-center py-5">
        <i class="fas fa-info-circle fa-3x mb-3"></i>
        <h4>No exam sessions yet</h4>
        <p>Click the button above to create your first exam!</p>
    </div>
<#else>
    <div class="row">
        <#list sessions as session>
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card h-100 shadow-sm hover-shadow">
                    <div class="card-header
                        <#if session.status == 'DRAFT'>bg-warning
                        <#elseif session.status == 'OPEN'>bg-success text-white
                        <#elseif session.status == 'CLOSED'>bg-secondary text-white
                        </#if>">
                        <h5 class="card-title mb-0">
                            <#if session.status == 'DRAFT'>
                                <i class="fas fa-pencil-alt"></i>
                            <#elseif session.status == 'OPEN'>
                                <i class="fas fa-door-open"></i>
                            <#elseif session.status == 'CLOSED'>
                                <i class="fas fa-door-closed"></i>
                            </#if>
                            ${session.examName}
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text text-muted">
                            <#if session.description?has_content>
                                ${session.description?truncate(100)}
                            <#else>
                                <em>No description</em>
                            </#if>
                        </p>

                        <ul class="list-unstyled">
                            <li class="mb-2">
                                <i class="fas fa-question-circle text-primary"></i>
                                <strong>Questions:</strong> ${session.questions?size}
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-calendar-alt text-info"></i>
                                <strong>Created:</strong>
                                <#-- Форматируем дату из формата "2026-02-26T22:48:52.840732" -->
                                <#if session.createdAt??>
                                    <#assign datePart = session.createdAt?split("T") />
                                    ${datePart[0]}
                                    <#if datePart?size gt 1>
                                        <#assign timePart = datePart[1]?substring(0, 5) />
                                        <small class="text-muted">${timePart}</small>
                                    </#if>
                                </#if>
                            </li>
                            <#if session.openTime??>
                                <li class="mb-2">
                                    <i class="fas fa-clock text-success"></i>
                                    <strong>Opened:</strong>
                                    <#assign openDate = session.openTime?split("T") />
                                    ${openDate[0]} ${openDate[1]?substring(0,5)}
                                </li>
                            </#if>
                            <#if session.closeTime??>
                                <li class="mb-2">
                                    <i class="fas fa-clock text-danger"></i>
                                    <strong>Closed:</strong>
                                    <#assign closeDate = session.closeTime?split("T") />
                                    ${closeDate[0]} ${closeDate[1]?substring(0,5)}
                                </li>
                            </#if>
                        </ul>

                        <#-- Убрали прогресс-бар, так как нет totalVotes -->
                        <div class="d-grid gap-2">
                            <a href="/admin/sessions/${session.id}" class="btn btn-outline-primary">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </#list>
    </div>
</#if>

<@h.footer/>