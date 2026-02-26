<#import "/fragments/header.ftlh" as h>

<@h.header "Register - ExamVote"/>

<div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header bg-success text-white text-center py-4">
                <h3 class="mb-0">
                    <i class="fas fa-user-plus fa-2x mb-3"></i><br>
                    Student Registration
                </h3>
            </div>
            <div class="card-body p-4">
                <#if error??>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </#if>

                <form action="/auth/register" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="form-floating">
                                <input type="text" class="form-control"
                                       id="username" name="username" placeholder="Username"
                                       value="<#if registerRequest.username??>${registerRequest.username}</#if>" required>
                                <label for="username">
                                    <i class="fas fa-user"></i> Username
                                </label>
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <div class="form-floating">
                                <input type="email" class="form-control"
                                       id="email" name="email" placeholder="Email"
                                       value="<#if registerRequest.email??>${registerRequest.email}</#if>" required>
                                <label for="email">
                                    <i class="fas fa-envelope"></i> Email
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-floating">
                            <input type="text" class="form-control"
                                   id="fullName" name="fullName" placeholder="Full Name"
                                   value="<#if registerRequest.fullName??>${registerRequest.fullName}</#if>" required>
                            <label for="fullName">
                                <i class="fas fa-id-card"></i> Full Name
                            </label>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="form-floating">
                                <input type="password" class="form-control"
                                       id="password" name="password" placeholder="Password" required>
                                <label for="password">
                                    <i class="fas fa-lock"></i> Password
                                </label>
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <div class="form-floating">
                                <input type="password" class="form-control"
                                       id="confirmPassword" name="confirmPassword"
                                       placeholder="Confirm Password" required>
                                <label for="confirmPassword">
                                    <i class="fas fa-lock"></i> Confirm Password
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-success btn-lg">
                            <i class="fas fa-user-check"></i> Register
                        </button>
                    </div>
                </form>

                <hr class="my-4">

                <div class="text-center">
                    <p class="mb-0">Already have an account?</p>
                    <a href="/auth/login" class="btn btn-outline-primary mt-2">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<@h.footer/>