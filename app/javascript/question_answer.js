document.addEventListener('turbo:load', function () {
  const choices = document.querySelectorAll('.choice');
  const selectedChoices = document.getElementById('selected_choices');
  const submitButton = document.getElementById('submit_answers');
  const resultCard = document.getElementById('result_card');
  const resultDisplay = document.getElementById('result_display');
  const editExplanationButton = document.getElementById('edit_explanation_button');
  const editExplanation = document.getElementById('edit_explanation');
  const nextButton = document.getElementById('next_button');
  const body = document.querySelector('body');
  const categoryId = body.dataset.categoryId;
  const questionId = body.dataset.questionId;

  // 選択肢をクリックしたときに選択状態を切り替える
  choices.forEach(choice => {
    choice.addEventListener('click', function () {
      this.classList.toggle('selected');
      updateSelectedChoices();
    });
  });

  // 選択された選択肢を更新する
  function updateSelectedChoices() {
    const selected = document.querySelectorAll('.choice.selected');
    const selectedTexts = Array.from(selected).map(el => el.textContent.split(':')[0].trim()).join(', ');
    selectedChoices.innerHTML = `選択: ${selectedTexts}`;
  }

  // 回答を送信して結果を受け取る
  if (submitButton) {
    submitButton.addEventListener('click', function() {
      const selected = document.querySelectorAll('.choice.selected');
      const selectedIds = Array.from(selected).map(el => el.getAttribute('data-choice-id'));

      sendAnswer(selectedIds);
    });
  }

  // サーバーに選択肢のIDを送信して正解判定を受け取る
  function sendAnswer(selectedIds) {
    fetch(`/categories/${categoryId}/questions/${questionId}/check_answer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({
        question_id: questionId,
        choice_ids: selectedIds
      })
    })
    .then(response => response.json())
    .then(data => displayResult(data));
  }

  // 結果を表示する
  function displayResult(data) {
    toggleResultCard(true); // 結果カードを表示、回答ボタンを非表示
    updateResultDisplay(data.is_correct); // 正解かどうかを表示
    updateCorrectAnswers(data.correct_choices); // 正しい選択肢を表示
    updateExplanation(data.explanation); // 解説を表示
    setupEditExplanationButton(); // 解説編集ボタンを表示
  }

  // 結果カードを表示/非表示にする
  function toggleResultCard(show) {
    submitButton.style.display = show ? 'none' : 'block';
    resultCard.style.display = show ? 'block' : 'none';
  }

  // 正解かどうかを表示する
  function updateResultDisplay(isCorrect) {
    if (isCorrect) {
      resultDisplay.textContent = '正解！！';
      resultDisplay.classList.add('bg-warning');
      resultDisplay.classList.remove('bg-danger');
    } else {
      resultDisplay.textContent = '不正解！！';
      resultDisplay.classList.add('bg-danger');
      resultDisplay.classList.remove('bg-warning');
    }
    resultDisplay.classList.add('animated');
  }

  // 正しい選択肢を表示する
  function updateCorrectAnswers(correctChoices) {
    const markdownContent = '\n' + correctChoices.map(choice => `- ${choice}`).join('\n');
    document.getElementById('correct_answers').innerHTML = marked.parse('<b>正しい選択肢</b>' + markdownContent);
  }

  // 解説を表示する
  function updateExplanation(explanation) {
    document.getElementById('explanation').innerHTML = '<b>解説</b>' + explanation;
    editExplanationButton.style.display = 'block';
    document.getElementById('learned_content').value = explanation;
  }

  // 解説編集ボタンを表示する
  function setupEditExplanationButton() {
    editExplanationButton.addEventListener('click', function() {
      toggleExplanationEdit(true); // 解説編集モードの表示
    });

    document.getElementById("save_learned_content").addEventListener("click", function() {
      const learnedContent = document.getElementById("learned_content").value;
      if (learnedContent.trim() !== "") {
        saveExplanationContent(learnedContent);
      }
    });
  }

  // 解説編集モードの切り替え
  function toggleExplanationEdit(editMode) {
    document.getElementById('explanation').style.display = editMode ? 'none' : 'block';
    editExplanation.style.display = editMode ? 'block' : 'none';
    editExplanationButton.style.display = editMode ? 'none' : 'block';
    nextButton.style.display = editMode ? 'none' : 'block';
  }

  // 解説をサーバーに保存する
  function saveExplanationContent(content) {
    fetch(`/categories/${categoryId}/questions/${questionId}/edit_explanation_content`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        question_id: questionId,
        learned_content: content
      })
    }).then(response => response.json()).then(data => {
      if (data.success) {
        alert("解説が更新されました");
        document.getElementById('explanation').innerHTML = '<b>解説</b>' + content;
        toggleExplanationEdit(false); // 解説編集モードを解除
      } else {
        alert("保存に失敗しました");
      }
    });
  }

  // 次の問題へ移動する
  if (nextButton) {
    nextButton.addEventListener('click', function() {
      const nextQuestionUrl = body.dataset.nextQuestionUrl;
      window.location.href = nextQuestionUrl;
    });
  }
});
