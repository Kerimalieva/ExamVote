<#import "/fragments/header.ftlh" as h>

<@h.header "Create Exam - ExamVote"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <i class="fas fa-plus-circle"></i>
            Create New Exam Session
        </h2>
        <p class="text-muted">Fill in the details below to create a new exam</p>
    </div>
</div>

<div class="card shadow">
    <div class="card-body">
        <form id="examForm">

            <div class="mb-4">
                <label for="examName" class="form-label fw-bold">
                    <i class="fas fa-heading"></i> Exam Name
                </label>
                <input type="text" class="form-control form-control-lg"
                       id="examName" required
                       placeholder="e.g., Midterm Examination 2024">
            </div>

            <div class="mb-4">
                <label for="description" class="form-label fw-bold">
                    <i class="fas fa-align-left"></i> Description
                </label>
                <textarea class="form-control" id="description"
                          rows="3" placeholder="Enter exam description (optional)"></textarea>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold">
                    <i class="fas fa-tasks"></i> Questions and Options
                </label>

                <div id="questionsContainer">
                    <!-- Questions will be added here dynamically -->
                </div>

<#--                <button type="button" class="btn btn-outline-primary mt-3" onclick="addQuestion()">-->
<#--                    <i class="fas fa-plus"></i> Add Question-->
<#--                </button>-->
            </div>

            <hr class="my-4">

            <div class="d-flex justify-content-between">
                <a href="/admin/dashboard" class="btn btn-secondary btn-lg">
                    <i class="fas fa-times"></i> Cancel
                </a>
                <button type="button" id="submitBtn" class="btn btn-success btn-lg" onclick="submitForm()">
                    <i class="fas fa-save"></i> Create Exam Session
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let questionCount = 0;
    // Храним уникальные ID для каждого вопроса
    let questionUniqueIds = [];

    function generateUniqueId() {
        return 'q_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }

    function addQuestion() {
        const container = document.getElementById('questionsContainer');
        const uniqueId = generateUniqueId();
        questionUniqueIds.push(uniqueId);

        const questionDiv = document.createElement('div');
        questionDiv.className = 'card mb-3 question-card';
        questionDiv.dataset.uniqueId = uniqueId;
        questionDiv.dataset.index = questionCount;

        questionDiv.innerHTML = `
        <div class="card-header bg-light d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Question ${questionCount + 1}</h5>
            <button type="button" class="btn btn-sm btn-danger" onclick="removeQuestion(this)">
                <i class="fas fa-trash"></i> Remove Question
            </button>
        </div>
        <div class="card-body">
            <div class="mb-3">
                <label class="form-label fw-bold">Question Text</label>
                <input type="text" class="form-control question-text"
                       placeholder="Enter your question" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Options</label>
                <div class="options-container mb-2">
                </div>
                <button type="button" class="btn btn-sm btn-outline-success add-option-btn">
                    <i class="fas fa-plus"></i> Add Option
                </button>
            </div>
        </div>
    `;

        container.appendChild(questionDiv);

        // Добавляем обработчики
        const addOptionBtn = questionDiv.querySelector('.add-option-btn');
        addOptionBtn.addEventListener('click', function() {
            addOption(questionDiv);
        });

        // Добавляем две опции по умолчанию
        addOption(questionDiv);
        addOption(questionDiv);

        questionCount++;
    }

    function addOption(questionDiv) {
        const optionsContainer = questionDiv.querySelector('.options-container');
        const optionIndex = optionsContainer.children.length;
        const uniqueId = questionDiv.dataset.uniqueId;

        const optionDiv = document.createElement('div');
        optionDiv.className = 'input-group mb-2 option-item';

        optionDiv.innerHTML = `
        <input type="text" class="form-control option-text"
               placeholder="Option ${optionIndex + 1}" required>
        <div class="input-group-text">
            <input type="radio" name="correct_${uniqueId}" class="correct-option">
            <label class="ms-1">Correct</label>
        </div>
        <button type="button" class="btn btn-outline-danger remove-option-btn">
            <i class="fas fa-times"></i>
        </button>
    `;

        optionsContainer.appendChild(optionDiv);

        // Добавляем обработчик для удаления опции
        const removeBtn = optionDiv.querySelector('.remove-option-btn');
        removeBtn.addEventListener('click', function() {
            if (optionsContainer.children.length > 2) {
                optionDiv.remove();
                updateOptionPlaceholders(questionDiv);
            } else {
                alert('Each question must have at least 2 options');
            }
        });

        // Обновляем плейсхолдеры
        updateOptionPlaceholders(questionDiv);

        // Добавляем подсветку выбранного правильного ответа
        highlightCorrectOption(questionDiv);
    }

    function updateOptionPlaceholders(questionDiv) {
        const options = questionDiv.querySelectorAll('.option-text');
        options.forEach((option, index) => {
            option.placeholder = `Option ${index + 1}`;
        });
    }

    function removeQuestion(button) {
        if (confirm('Are you sure you want to remove this question?')) {
            const questionDiv = button.closest('.question-card');
            if (document.querySelectorAll('.question-card').length > 1) {
                // Удаляем уникальный ID из массива
                const uniqueId = questionDiv.dataset.uniqueId;
                const index = questionUniqueIds.indexOf(uniqueId);
                if (index > -1) {
                    questionUniqueIds.splice(index, 1);
                }
                questionDiv.remove();
                updateQuestionIndices();
            } else {
                alert('You must have at least one question');
            }
        }
    }

    function updateQuestionIndices() {
        const questions = document.querySelectorAll('.question-card');
        questions.forEach((question, index) => {
            question.dataset.index = index;
            const header = question.querySelector('.card-header h5');
            header.textContent = `Question ${index + 1}`;

            // НЕ обновляем name у радио-кнопок - они должны оставаться с уникальными ID
            // Радио-кнопки остаются с уникальными именами на основе dataset.uniqueId

            // Добавляем проверку, что уникальный ID не потерян
            if (!question.dataset.uniqueId) {
                console.warn('Question missing uniqueId, generating new one');
                question.dataset.uniqueId = generateUniqueId();
            }
        });
    }

    function highlightCorrectOption(questionDiv) {
        const radios = questionDiv.querySelectorAll('.correct-option');
        radios.forEach(radio => {
            radio.addEventListener('change', function() {
                // Убираем подсветку у всех опций в этом вопросе
                const allOptions = questionDiv.querySelectorAll('.option-item');
                allOptions.forEach(opt => {
                    opt.style.backgroundColor = '';
                    opt.classList.remove('highlight-correct');
                });

                // Подсвечиваем выбранную опцию
                if (this.checked) {
                    const optionItem = this.closest('.option-item');
                    optionItem.style.backgroundColor = '#d4edda';
                    optionItem.classList.add('highlight-correct');
                }
            });
        });
    }

    // Add first question by default when page loads
    window.onload = function() {
        addQuestion();
    };

    // Функция отправки формы
    function submitForm() {
        const questions = document.querySelectorAll('.question-card');

        // Валидация
        if (questions.length === 0) {
            alert('Please add at least one question');
            return;
        }

        const examName = document.getElementById('examName').value;
        if (!examName.trim()) {
            alert('Please enter exam name');
            return;
        }

        for (let i = 0; i < questions.length; i++) {
            const question = questions[i];
            const questionText = question.querySelector('.question-text').value;

            if (!questionText.trim()) {
                alert(`Please enter text for Question ${i + 1}`);
                return;
            }

            const options = question.querySelectorAll('.option-item');
            if (options.length < 2) {
                alert(`Question ${i + 1} must have at least 2 options`);
                return;
            }

            let hasCorrectAnswer = false;
            options.forEach(option => {
                if (option.querySelector('.correct-option').checked) {
                    hasCorrectAnswer = true;
                }
            });

            if (!hasCorrectAnswer) {
                alert(`Please select the correct answer for Question ${i + 1}`);
                return;
            }

            for (let j = 0; j < options.length; j++) {
                const optionText = options[j].querySelector('.option-text').value;
                if (!optionText.trim()) {
                    alert(`Please enter text for Option ${j + 1} of Question ${i + 1}`);
                    return;
                }
            }
        }

        // Создаем объект для отправки в формате JSON
        const examData = {
            examName: examName,
            description: document.getElementById('description').value || '',
            questions: []
        };

        questions.forEach((question, qIndex) => {
            const questionObj = {
                questionText: question.querySelector('.question-text').value,
                questionOrder: qIndex,
                options: []
            };

            const options = question.querySelectorAll('.option-item');

            options.forEach((option, oIndex) => {
                const optionObj = {
                    optionText: option.querySelector('.option-text').value,
                    optionOrder: oIndex,
                    correct: option.querySelector('.correct-option').checked
                };
                questionObj.options.push(optionObj);
            });

            examData.questions.push(questionObj);
        });

        // Опционально: валидация данных перед отправкой
        console.log('Exam data to send:', examData);

        // Показываем индикатор загрузки
        const submitBtn = document.getElementById('submitBtn');
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
        submitBtn.disabled = true;

        // Отправляем как JSON
        fetch('/admin/sessions/create', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(examData)
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw err; });
                }
                return response.json();
            })
            .then(data => {
                if (data.redirect) {
                    window.location.href = data.redirect;
                } else if (data.error) {
                    alert('Error: ' + data.error);
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error creating exam session: ' + (error.error || 'Unknown error'));
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
    }
</script>

<style>
    .question-card {
        transition: all 0.3s ease;
        border-left: 4px solid transparent;
        margin-bottom: 1rem;
    }
    .question-card:hover {
        border-left-color: #4e73df;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .input-group-text {
        background-color: #f8f9fa;
        cursor: pointer;
    }
    .input-group-text input[type="radio"] {
        cursor: pointer;
        margin-right: 5px;
    }
    .remove-option-btn {
        border-top-left-radius: 0;
        border-bottom-left-radius: 0;
    }
    .add-option-btn {
        margin-top: 0.5rem;
    }
    .card-header .btn-danger {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }
    .btn-success:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }
    .option-item.highlight-correct {
        background-color: #d4edda;
        border-color: #c3e6cb;
    }
    .option-item .correct-option:checked + label {
        font-weight: bold;
        color: #155724;
    }
</style>

<@h.footer/>