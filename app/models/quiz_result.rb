class QuizResult < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :question

  class << self
    # セッションタイムスタンプで結果を集計する
    def aggregate_results_by_session(user_id)
      where(user_id: user_id)
        .select('session_ts, category_id, COUNT(id) as total_questions, SUM(is_correct) as correct_answers')
        .group(:session_ts, :category_id)
        .order(session_ts: :desc)
    end
  end
end
