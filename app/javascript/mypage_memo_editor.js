import { setupMypageMemoEditor } from "memo_editor"

// 初期化フラグ
let isInitialized = false;

// マイページでメモ編集機能を初期化
function initializeMypageMemoEditor() {
  // 既に初期化済みの場合は何もしない
  if (isInitialized) {
    return;
  }

  setupMypageMemoEditor();
  isInitialized = true;
}

// ページ離脱時に初期化フラグをリセット
function resetInitialization() {
  isInitialized = false;
}

// DOMContentLoadedイベントで初期化
document.addEventListener('DOMContentLoaded', initializeMypageMemoEditor);

// Turboによるページ遷移後も初期化
document.addEventListener('turbo:load', initializeMypageMemoEditor);

// ページ離脱時にリセット
document.addEventListener('turbo:before-visit', resetInitialization);
document.addEventListener('beforeunload', resetInitialization);
