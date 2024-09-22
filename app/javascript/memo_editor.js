export function setupMemoEditor({ categoryId, questionId, memo }) {
  const editMemoButton = document.getElementById('edit_memo_button');
  const editMemo = document.getElementById('edit_memo');
  const memoDisplay = document.getElementById('memo');
  const saveMemoButton = document.getElementById('save_memo_content');
  const nextButton = document.getElementById('next_button');
  const quitButton = document.getElementById('quit_button');

  // メモを表示
  const memoContent = memo ? memo : '';
  memoDisplay.innerHTML = '<b>メモ</b>' + (memoContent || 'メモはありません');
  document.getElementById('memo_content').value = memoContent;

  // メモ編集ボタンを表示
  if (editMemoButton) {
    editMemoButton.addEventListener('click', function () {
      toggleMemoEdit(true); // メモ編集モードの表示
    });
  }

  // メモを保存
  if (saveMemoButton) {
    saveMemoButton.addEventListener('click', function () {
      const memoContent = document.getElementById('memo_content').value;
      saveMemoContent(memoContent);
    });
  }

  // メモ編集モードの切り替え
  function toggleMemoEdit(editMode) {
    memoDisplay.style.display = editMode ? 'none' : 'block';
    editMemo.style.display = editMode ? 'block' : 'none';
    editMemoButton.style.display = editMode ? 'none' : 'block';
    if (nextButton) nextButton.style.display = editMode ? 'none' : 'block';
    if (quitButton) quitButton.style.display = editMode ? 'none' : 'block';
  }

  // メモをサーバーに保存する
  function saveMemoContent(content) {
    fetch(`/categories/${categoryId}/questions/${questionId}/edit_memo_content`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        question_id: questionId,
        memo_content: content || ""
      })
    }).then(response => response.json()).then(data => {
      if (data.success) {
        memoDisplay.innerHTML = '<b>メモ</b><br>' + (content || 'メモはありません');
        toggleMemoEdit(false); // メモ編集モードを非表示にする
        editMemoButton.style.display = 'block';
      } else {
        alert("保存に失敗しました");
      }
    });
  }
}
