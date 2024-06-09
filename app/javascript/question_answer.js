document.addEventListener('turbo:load', function () {
  const choices = document.querySelectorAll('.choice');
  const selectedChoices = document.getElementById('selected_choices');
  const submitButton = document.getElementById('submit_answers');
  const resultCard = document.getElementById('result_card');
  const resultDisplay = document.getElementById('result_display');
  const nextButton = document.getElementById('next_button');

  // 選択肢をクリックしたときに選択状態を切り替える
  choices.forEach(choice => {
    choice.addEventListener('click', function () {
      this.classList.toggle('selected');
      updateSelectedChoices();
    });
  });

  function updateSelectedChoices() {
    const selected = document.querySelectorAll('.choice.selected');

    selectedChoices.innerHTML = '選択: ' + Array.from(selected).map(el => el.textContent.split(':')[0].trim()).join(', ');
  }

  // 回答ボタンをクリック→サーバーに回答を送信して正解判定を受け取り、結果を表示
  submitButton.addEventListener('click', function() {
    const selected = document.querySelectorAll('.choice.selected');
    const selectedIds = Array.from(selected).map(el => el.getAttribute('data-choice-id'));

    // サーバーに選択肢のIDを送信して正解判定を受け取る
    fetch(`/categories/${document.querySelector('body').dataset.categoryId}/questions/${document.querySelector('body').dataset.questionId}/check_answer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({
        question_id: document.querySelector('body').dataset.questionId,
        choice_ids: selectedIds
      })
    })
    .then(response => response.json())
    .then(data => {
      // resultDisplay.textContent = data.is_correct ? '正解！' : '不正解';
      if (data.is_correct) {
        resultDisplay.textContent = '正解！';
        resultDisplay.classList.add('alert-success');
        resultDisplay.classList.remove('alert-danger');
      } else {
        resultDisplay.textContent = '不正解';
        resultDisplay.classList.add('alert-danger');
        resultDisplay.classList.remove('alert-success');
      }
      resultDisplay.classList.add('animated');

      // レスポンスから取得したMarkdown形式のテキストをHTMLに変換して表示
      const markdownContent = '\n' + data.correct_choices.map(choice => `- ${choice}`).join('\n');
      document.getElementById('correct_answers').innerHTML = marked.parse('正しい選択肢: ' + markdownContent);

      document.getElementById('explanation').innerHTML = '解説: <br>' + data.explanation;
      submitButton.disabled = true;
      resultCard.style.display = 'block';
    })
  });

  // 次の問題へボタンをクリックしたとき
  nextButton.addEventListener('click', function() {
    const nextQuestionUrl = document.querySelector('body').dataset.nextQuestionUrl;
    window.location.href = nextQuestionUrl;
  });
});
