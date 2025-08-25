// 共通のメモ保存機能
function saveMemo(questionCategoryId, questionId, content) {
  return fetch(`/question_categories/${questionCategoryId}/questions/${questionId}/memo`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({
      question_id: questionId,
      memo_content: content || ""
    })
  }).then(response => response.json());
}

// 共通のメモ編集フォーム作成機能
function createMemoEditForm(content, memoId, questionCategoryId, questionId) {
  const editForm = document.createElement('div');
  editForm.className = 'memo-edit-form mt-2';
  editForm.innerHTML = `
    <textarea class="form-control memo-edit-textarea mb-2" rows="4">${content.trim()}</textarea>
    <div class="btn-group">
      <button type="button" class="btn btn-sm btn-primary save-memo-btn"
              data-memo-id="${memoId || ''}"
              data-question-category-id="${questionCategoryId || ''}"
              data-question-id="${questionId || ''}">保存</button>
      <button type="button" class="btn btn-sm btn-secondary cancel-memo-btn">キャンセル</button>
    </div>
  `;
  return editForm;
}

// 問題解答画面用のメモ編集機能
export function setupMemoEditor({ questionCategoryId, questionId, memo }) {
  const editMemoButton = document.getElementById('edit_memo_button');
  const editMemo = document.getElementById('edit_memo');
  const memoDisplay = document.getElementById('memo');
  const saveMemoButton = document.getElementById('save_memo_content');
  const nextButton = document.getElementById('next_button');
  const quitButton = document.getElementById('quit_button');

  // メモを表示
  const memoContent = memo ? memo : '';
  const formattedContent = memoContent.replace(/\n/g, "<br>"); // 改行を <br> に変換
  memoDisplay.innerHTML = '<b>メモ</b>' + (formattedContent || 'メモはありません');
  document.getElementById('memo_content').value = formattedContent;

  // メモ編集ボタンを表示
  if (editMemoButton) {
    editMemoButton.addEventListener('click', function () {
      toggleMemoEdit(true); // メモ編集モードの表示
    });
  }

  // メモを保存
  if (saveMemoButton) {
    const newButton = saveMemoButton.cloneNode(true);
    saveMemoButton.parentNode.replaceChild(newButton, saveMemoButton);

    newButton.addEventListener('click', function () {
      const memoContent = document.getElementById('memo_content').value;
      saveQuestionMemo(memoContent);
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

  // 問題画面専用の保存処理
  function saveQuestionMemo(content) {
    saveMemo(questionCategoryId, questionId, content).then(data => {
      if (data.success) {
        const formattedContent = content.replace(/\n/g, "<br>"); // 改行を <br> に変換
        memoDisplay.innerHTML = '<b>メモ</b><br>' + (formattedContent || 'メモはありません');
        toggleMemoEdit(false); // メモ編集モードを非表示にする
        editMemoButton.style.display = 'block';
      } else {
        alert("保存に失敗しました");
      }
    });
  }
}

// マイページ用のメモ編集機能
export function setupMypageMemoEditor() {
  // 既存のイベントリスナーを削除（重複防止）
  const existingListener = document._mypageMemoEditorListener;
  if (existingListener) {
    document.removeEventListener('click', existingListener);
    delete document._mypageMemoEditorListener;
  }

  const memoEditorHandler = function(e) {
    // アコーディオンのボタンクリックは無視
    if (e.target.closest('.accordion-button')) {
      return;
    }

    // 編集ボタンがクリックされた場合
    if (e.target.classList.contains('edit-memo-btn')) {
      e.preventDefault();
      e.stopPropagation();
      handleEditButtonClick(e.target);
    }

    // 保存ボタンがクリックされた場合
    if (e.target.classList.contains('save-memo-btn')) {
      e.preventDefault();
      e.stopPropagation();
      handleSaveButtonClick(e.target);
    }

    // キャンセルボタンがクリックされた場合
    if (e.target.classList.contains('cancel-memo-btn')) {
      e.preventDefault();
      e.stopPropagation();
      handleCancelButtonClick(e.target);
    }
  };

  // 編集ボタンクリック処理
  function handleEditButtonClick(button) {
    const cardBody = button.closest('.card-body');
    if (!cardBody || button.disabled) return;

    // 既に編集フォームが表示されている場合は何もしない
    if (cardBody.querySelector('.memo-edit-form')) return;

    const memoId = button.dataset.memoId;
    const questionCategoryId = button.dataset.questionCategoryId;
    const questionId = button.dataset.questionId;

    // ボタンを一時的に無効化
    button.disabled = true;

    showMypageMemoEditForm(cardBody, memoId, questionCategoryId, questionId);

    // 少し待ってからボタンを有効化
    setTimeout(() => { button.disabled = false; }, 500);
  }

  // 保存ボタンクリック処理
  function handleSaveButtonClick(button) {
    const cardBody = button.closest('.card-body');
    if (!cardBody) return;

    const memoId = button.dataset.memoId;
    const questionCategoryId = button.dataset.questionCategoryId;
    const questionId = button.dataset.questionId;
    const content = cardBody.querySelector('.memo-edit-textarea').value;

    saveMypageMemo(cardBody, memoId, questionCategoryId, questionId, content);
  }

  // キャンセルボタンクリック処理
  function handleCancelButtonClick(button) {
    const cardBody = button.closest('.card-body');
    if (!cardBody) return;

    hideMypageMemoEditForm(cardBody);
  }

  // イベントリスナーを登録
  document.addEventListener('click', memoEditorHandler, true);
  document._mypageMemoEditorListener = memoEditorHandler;
}

// マイページ専用のメモ編集フォーム表示
function showMypageMemoEditForm(cardBody, memoId, questionCategoryId, questionId) {
  const memoDisplay = cardBody.querySelector('.memo-display');
  const memoActions = cardBody.querySelector('.memo-actions');

  if (!memoDisplay || !memoActions) return;

  // テキストコンテンツを取得（HTMLタグを除去）
  const tempDiv = document.createElement('div');
  tempDiv.innerHTML = memoDisplay.innerHTML;
  const memoContent = tempDiv.textContent || tempDiv.innerText || '';

  // 共通のフォーム作成機能を使用
  const editForm = createMemoEditForm(memoContent, memoId, questionCategoryId, questionId);

  // 要素を非表示にして編集フォームを追加
  memoDisplay.style.display = 'none';
  memoActions.style.display = 'none';
  cardBody.appendChild(editForm);

  // テキストエリアにフォーカス
  const textarea = editForm.querySelector('.memo-edit-textarea');
  if (textarea) {
    setTimeout(() => textarea.focus(), 100);
  }
}

// マイページ専用のメモ編集フォーム非表示
function hideMypageMemoEditForm(cardBody) {
  const memoDisplay = cardBody.querySelector('.memo-display');
  const editForm = cardBody.querySelector('.memo-edit-form');
  const memoActions = cardBody.querySelector('.memo-actions');
  const editButton = cardBody.querySelector('.edit-memo-btn');

  if (memoDisplay) memoDisplay.style.display = 'block';
  if (memoActions) memoActions.style.display = 'block';
  if (editButton) editButton.disabled = false;
  if (editForm) editForm.remove();
}

// マイページ専用のメモ保存処理
function saveMypageMemo(cardBody, memoId, questionCategoryId, questionId, content) {
  // 共通の保存機能を使用
  saveMemo(questionCategoryId, questionId, content).then(data => {
    if (data.success) {
      const memoDisplay = cardBody.querySelector('.memo-display');
      memoDisplay.innerHTML = content || 'メモはありません';
      hideMypageMemoEditForm(cardBody);

      // 編集ボタンを再有効化
      const editButton = cardBody.querySelector('.edit-memo-btn');
      if (editButton) editButton.disabled = false;
    } else {
      alert("保存に失敗しました");
      enableEditButton(cardBody);
    }
  }).catch(error => {
    alert("保存に失敗しました");
    enableEditButton(cardBody);
  });
}

// 編集ボタンを有効化
function enableEditButton(cardBody) {
  const editButton = cardBody.querySelector('.edit-memo-btn');
  if (editButton) editButton.disabled = false;
}
