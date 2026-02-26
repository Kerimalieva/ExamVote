<#macro header title>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${title} - ExamVote</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="/css/style.css" rel="stylesheet">
    </head>
    <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="/dashboard">
                <i class="fas fa-graduation-cap"></i> ExamVote
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <#if user??>
                        <li class="nav-item">
                            <span class="nav-link text-light">
                                <i class="fas fa-user"></i> ${user.fullName}
                            </span>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/auth/logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    <#else>
                        <li class="nav-item">
                            <a class="nav-link" href="/auth/login">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/auth/register">
                                <i class="fas fa-user-plus"></i> Register
                            </a>
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
    </nav>
    <main class="container mt-4">
</#macro>

<#macro footer>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/script.js"></script>
    </body>
    </html>
</#macro>