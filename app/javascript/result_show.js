import { setupMemoEditor } from './memo_editor'; // memo_editor.js を読み込む

document.addEventListener('turbo:load', function () {
  const body = document.querySelector('body');
  const questionCategoryId = body.dataset.questionCategoryId;
  const questionId = body.dataset.questionId;

  // メモを編集するためのセットアップを呼び出し
  setupMemoEditor({ questionCategoryId, questionId, memo: body.dataset.memo });
});
