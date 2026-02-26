<#import "/fragments/header.ftlh" as h>

<@h.header "Voting History - ExamVote"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <i class="fas fa-history"></i>
            My Voting History
        </h2>
    </div>
</div>

<#if history?size == 0>
    <div class="alert alert-info text-center py-5">
        <i class="fas fa-info-circle fa-3x mb-3"></i>
        <h4>No voting history yet</h4>
        <p>Take some exams to see your history here</p>
        <a href="/student/dashboard" class="btn btn-primary mt-3">
            <i class="fas fa-door-open"></i> View Available Exams
        </a>
    </div>
<#else>
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">
                <i class="fas fa-list"></i>
                Your Votes
            </h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Exam</th>
                        <th>Question</th>
                        <th>Your Answer</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list history as vote>
                        <tr>
                            <td>
                                <#if vote.voteTimestamp??>
                                    <#assign dateTime = vote.voteTimestamp?split("T") />
                                    ${dateTime[0]}
                                    <#if dateTime?size gt 1>
                                        <br><small class="text-muted">${dateTime[1]?substring(0,5)}</small>
                                    </#if>
                                </#if>
                            </td>
                            <td>${vote.session.examName}</td>
                            <td>${vote.question.questionText?truncate(50)}</td>
                            <td>
                                    <span class="badge bg-info">
                                        ${vote.selectedOption.optionText}
                                    </span>
                            </td>
                            <td>
                                <#if vote.session.status == 'OPEN'>
                                    <span class="badge bg-success">Open</span>
                                <#elseif vote.session.status == 'CLOSED'>
                                    <span class="badge bg-secondary">Closed</span>
                                </#if>
                            </td>
                            <td>
                                <a href="/student/sessions/${vote.session.id}/results"
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-chart-bar"></i> Results
                                </a>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</#if>

<@h.footer/>