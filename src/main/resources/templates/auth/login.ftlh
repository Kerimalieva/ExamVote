<#import "/fragments/header.ftlh" as h>

<@h.header "Login - ExamVote"/>

<div class="row justify-content-center">
    <div class="col-md-6 col-lg-5">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header bg-primary text-white text-center py-4">
                <h3 class="mb-0">
                    <i class="fas fa-graduation-cap fa-2x mb-3"></i><br>
                    Welcome to ExamVote
                </h3>
            </div>
            <div class="card-body p-4">
                <#if RequestParameters.error??>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i>
                        Invalid username or password
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </#if>

                <#if RequestParameters.logout??>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i>
                        You have been logged out successfully
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </#if>

                <#if success??>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </#if>

                <form action="/auth/login" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="username" name="username"
                               placeholder="Username" required autofocus>
                        <label for="username">
                            <i class="fas fa-user"></i> Username
                        </label>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Password" required>
                        <label for="password">
                            <i class="fas fa-lock"></i> Password
                        </label>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </button>
                    </div>
                </form>

                <hr class="my-4">

                <div class="text-center">
                    <p class="mb-0">Don't have an account?</p>
                    <a href="/auth/register" class="btn btn-outline-primary mt-2">
                        <i class="fas fa-user-plus"></i> Register as Student
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<@h.footer/>