
## インストール
1. このリポジトリをCloneして利用して下さい。
2. 問題と正解のデータセット(csvファイル)は公開していません。自身で用意するか、知り合いの方は個人的に問い合わせて下さい。
- 現在提供可能なデータセット
  - Ruby Silver
    - 基礎力確認問題（30問）
    - 模擬試験（50問）
    - [公式の模擬試験（50問）](https://github.com/ruby-association/prep-test/blob/version3/silver_ja.md)

## 使い方
### 1. ユーザー登録
成績管理のために必要です。

### 2. 問題作成
(1) 問題一覧ページから問題集名を登録

(2)問題詳細ページからアクセスできる[CSVアップロードガイドライン](app/views/home/csv_upload_guidelines.html)を参考に、csvファイルを用意してアップロードして下さい。

### 3. 問題を解く
(1) 1問目から順に解くか、ランダムで解くかを選べます

(2) 問題を解く

(3) 解答・解説を読む → **自分なりに追加学習してメモを追記出来ます**

(4) 最後まで解き終える or 中断する

(5) 結果を確認できます

### 4. 過去の結果を見る（マイページ）
- 過去の成績を見ることが出来ます
- タイトルをクリックすると、一問ごとの正誤やその解説を見ることが出来ます
- 不正解の問題の解説を見たり、追加学習結果をメモすることで、知識の定着が期待出来ます
- メモ一覧を見ることが出来ます

## ユーザーの役割による機能制約
役割 | カテゴリ管理 | 問題集管理 | メモ・成績閲覧 | ユーザー管理
-- | -- | -- | -- | --
owner | ○ | ○（削除も） | 全員分可 | 一覧・削除・編集○
admin | × | ○（削除×） | 自分のみ | ×
general | × | × | 自分のみ | ×

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
  node_10["問題・回答・解説・メモを追記"]
  node_11{"最後の問題？"}
  node_12["成績（正否一覧）"]
  node_13["問題集詳細"]
  node_14("問題作成")
  node_15["マイページ（成績履歴）"]
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
        int role
    }
    CATEGORIES {
        string name
    }
    QUESTION_CATEGORIES {
        string name
        int category_id
    }
    QUESTIONS {
        int number
        text content
        text explanation
        int question_category_id
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
        int question_category_id
        int question_id
    }
    MEMOS {
        text content
        int user_id
        int question_id
    }

    USERS ||--o{ QUIZ_RESULTS : "has"
    USERS ||--o{ MEMOS : "has"
    CATEGORIES ||--o{ QUESTION_CATEGORIES : "has"
    QUESTION_CATEGORIES ||--o{ QUESTIONS : "has"
    QUESTIONS ||--o{ CHOICES : "has"
    QUESTIONS ||--o{ MEMOS : "has"
    QUESTION_CATEGORIES ||--o{ QUIZ_RESULTS : "has"
    QUESTIONS ||--o{ QUIZ_RESULTS : "has"
```
