<#import "/fragments/header.ftlh" as h>

<@h.header "Student Dashboard - ExamVote"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <i class="fas fa-tachometer-alt"></i>
            Student Dashboard
        </h2>
        <p class="text-muted">Welcome back, ${user.fullName}!</p>
    </div>
    <div class="col-auto">
        <a href="/student/history" class="btn btn-info btn-lg">
            <i class="fas fa-history"></i> My History
        </a>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-4">
        <div class="card bg-primary text-white">
            <div class="card-body">
                <h5 class="card-title">
                    <i class="fas fa-door-open"></i> Available Exams
                </h5>
                <h2 class="display-4">${sessions?size}</h2>
            </div>
        </div>
    </div>
</div>

<#if sessions?size == 0>
    <div class="alert alert-info text-center py-5">
        <i class="fas fa-info-circle fa-3x mb-3"></i>
        <h4>No exams available</h4>
        <p>Check back later for new exams</p>
    </div>
<#else>
    <h4 class="mb-3">Available Exams</h4>
    <div class="row">
        <#list sessions as session>
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card h-100 shadow-sm hover-shadow">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-file-alt"></i>
                            ${session.examName}
                        </h5>
                    </div>
                    <div class="card-body">
                        <#if session.description?has_content>
                            <p class="card-text">${session.description?truncate(100)}</p>
                        </#if>

                        <ul class="list-unstyled">
                            <li class="mb-2">
                                <i class="fas fa-question-circle text-primary"></i>
                                <strong>Questions:</strong> ${session.questions?size}
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-clock text-success"></i>
                                <strong>Opened:</strong>
                                <#if session.openTime??>
                                    <#assign openDate = session.openTime?split("T") />
                                    ${openDate[0]}
                                    <#if openDate?size gt 1>
                                        ${openDate[1]?substring(0,5)}
                                    </#if>
                                </#if>
                            </li>
                        </ul>
                    </div>
                    <div class="card-footer bg-transparent">
                        <a href="/student/sessions/${session.id}/take" class="btn btn-success w-100">
                            <i class="fas fa-pencil-alt"></i> Take Exam
                        </a>
                    </div>
                </div>
            </div>
        </#list>
    </div>
</#if>

<@h.footer/>