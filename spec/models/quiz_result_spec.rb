require 'rails_helper'

RSpec.describe QuizResult, type: :model do
  describe 'self.aggregate_results_by_session' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }
    let(:question1) { create(:question, category: category) }
    let(:question2) { create(:question, category: category) }
    let(:question3) { create(:question, category: category) }
    let(:other_category) { create(:category) }
    let(:other_question) { create(:question, category: other_category) }
    let(:session_ts1) { session_ts2 - 3600 }
    let(:session_ts2) { Time.current.to_i }

    before do
      # session_ts1のセッション
      create(:quiz_result, user: user, category: category, question: question1, is_correct: true, session_ts: session_ts1)
      create(:quiz_result, user: user, category: category, question: question2, is_correct: false, session_ts: session_ts1)
      create(:quiz_result, user: user, category: category, question: question3, is_correct: true, session_ts: session_ts1)

      # session_ts1の他のカテゴリーのセッション
      create(:quiz_result, user: user, category: other_category, question: other_question, is_correct: false, session_ts: session_ts1)

      # session_ts2のセッション
      create(:quiz_result, user: user, category: category, question: question1, is_correct: true, session_ts: session_ts2)
      create(:quiz_result, user: user, category: category, question: question2, is_correct: false, session_ts: session_ts2)
      create(:quiz_result, user: user, category: category, question: question3, is_correct: false, session_ts: session_ts2)
    end

    it '結果を集計できること' do
      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.to_a.size).to eq(3)
      expect(subject.first.session_ts).to eq(session_ts2)
      expect(subject.first.category_id).to eq(category.id)
      expect(subject.first.total_questions).to eq(3)
      expect(subject.first.correct_answers).to eq(1)
    end

    it 'セッションタイムスタンプの降順で並んでいること' do
      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.first.session_ts).to eq(session_ts2)
      expect(subject.second.session_ts).to eq(session_ts1)
    end

    it '同じセッションタイムスタンプでもカテゴリーが異なる場合は別のセッションとして扱われること' do
      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.to_a.size).to eq(3)
    end

    it '他のユーザーのデータは含まれないこと' do
      other_user = create(:user)
      create(:quiz_result, user: other_user, category: category, question: question1, is_correct: true, session_ts: session_ts2)

      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.to_a.size).to eq(3)
    end
  end
end
