
## インストール
1. このリポジトリをCloneして利用して下さい。
2. 問題と正解のデータセット(csvファイル)は公開していません。自身で用意するか、知り合いの方は個人的に問い合わせて下さい。
- 現在提供可能なデータセット
  - Ruby Silver
    - 基礎力確認問題（30問）
    - 模擬試験（50問） 

## 使い方
### 1. ユーザー登録
成績管理のために必要です。

### 2. 問題作成
(1) 問題一覧ページからカテゴリー名を登録

(2)問題詳細ページからアクセスできる[CSVアップロードガイドライン](app/views/home/csv_upload_guidelines.html)を参考に、csvファイルを用意してアップロードして下さい。

## 設計情報
### 画面遷移、フローチャート
```mermaid
flowchart TB
  node_4["TOPページ"]
  node_5["問題一覧"]
  node_6("問題を解く")
  node_7{"ランダムで解く？"}
  node_8("問題をランダムに並び替え")
  node_9("問題順そのまま")
  node_10["問題\n回答\n解説"]
  node_11{"最後の問題？"}
  node_12["成績（正否一覧）"]
  node_13["問題詳細"]
  node_14("問題作成")
  node_15["マイページ\n（成績履歴）"]
  node_16["問題ごとの正解と解説"]
  node_17["ログイン/ユーザー登録"]
  node_4 --> node_5
  node_5 --> node_6
  node_6 --> node_7
  node_7 --"Yes"--> node_8
  node_7 --"No"--> node_9
  node_8 --> node_10
  node_9 --> node_10
  node_10 --> node_11
  node_11 --"No"--> node_10
  node_11 --"Yes"--> node_12
  node_5 --> node_13
  node_13 --> node_14
  node_4 --> node_15
  node_15 --> node_12
  node_12 --> node_16
  node_4 --> node_17
```

### ER図
```mermaid
erDiagram
    USERS {
        string name
        string email
        string password
    }
    CATEGORIES {
        string name
    }
    QUESTIONS {
        int number
        text content
        text explanation
        int category_id
    }
    CHOICES {
        text content
        boolean is_correct
        int question_id
    }
    QUIZ_RESULTS {
        json selected
        json correct
        boolean is_correct
        bigint session_ts
        int user_id
        int category_id
        int question_id
    }

    USERS ||--o{ QUIZ_RESULTS : "has"
    CATEGORIES ||--o{ QUESTIONS : "has"
    QUESTIONS ||--o{ CHOICES : "has"
    USERS ||--o{ QUIZ_RESULTS : "has"
    CATEGORIES ||--o{ QUIZ_RESULTS : "has"
    QUESTIONS ||--o{ QUIZ_RESULTS : "has"
```
