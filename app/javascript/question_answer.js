import { setupMemoEditor } from './memo_editor'; // memo_editor.js を読み込む

document.addEventListener('turbo:load', function () {
  const choices = document.querySelectorAll('.choice');
  const selectedChoices = document.getElementById('selected_choices');
  const submitButton = document.getElementById('submit_answers');
  const resultCard = document.getElementById('result_card');
  const resultDisplay = document.getElementById('result_display');
  const nextButton = document.getElementById('next_button');
  const quitButton = document.getElementById('quit_button');
  const body = document.querySelector('body');
  const questionCategoryId = body.dataset.questionCategoryId;
  const questionId = body.dataset.questionId;

  // 選択肢をクリックしたときに選択状態を切り替える
  choices.forEach(choice => {
    choice.addEventListener('click', function () {
      choice.classList.toggle('selected');
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
    fetch(`/question_categories/${questionCategoryId}/questions/${questionId}/check_answers`, {
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
    setupMemoEditor({ questionCategoryId, questionId, memo: data.memo }); // メモ表示と編集をセットアップ
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
  }

  // 次の問題へ移動する
  if (nextButton) {
    nextButton.addEventListener('click', function() {
      const nextQuestionUrl = body.dataset.nextQuestionUrl;
      window.location.href = nextQuestionUrl;
    });
  }

  // 中断して結果ページに移動する
  if (quitButton) {
    quitButton.addEventListener('click', function() {
      const confirmation = confirm('途中でテストを終了します。続きから始めることは出来ません。よろしいですか？');
      if (confirmation) {
        // 確認が「はい」なら結果ページにリダイレクト
        window.location.href = '/results/create_quiz';
      }
    });
  }
});
