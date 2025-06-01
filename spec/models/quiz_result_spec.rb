require 'rails_helper'

RSpec.describe QuizResult, type: :model do
  describe 'self.aggregate_results_by_session' do
    let(:user) { create(:user) }
    let(:question_category) { create(:question_category) }
    let(:question1) { create(:question, question_category: question_category) }
    let(:question2) { create(:question, question_category: question_category) }
    let(:question3) { create(:question, question_category: question_category) }
    let(:other_question_category) { create(:question_category) }
    let(:other_question) { create(:question, question_category: other_question_category) }
    let(:session_ts1) { session_ts2 - 3600 }
    let(:session_ts2) { Time.current.to_i }

    before do
      # session_ts1のセッション
      create(:quiz_result, user: user, question_category: question_category, question: question1, is_correct: true, session_ts: session_ts1)
      create(:quiz_result, user: user, question_category: question_category, question: question2, is_correct: false, session_ts: session_ts1)
      create(:quiz_result, user: user, question_category: question_category, question: question3, is_correct: true, session_ts: session_ts1)

      # session_ts1の他の問題集のセッション
      create(:quiz_result, user: user, question_category: other_question_category, question: other_question, is_correct: false, session_ts: session_ts1)

      # session_ts2のセッション
      create(:quiz_result, user: user, question_category: question_category, question: question1, is_correct: true, session_ts: session_ts2)
      create(:quiz_result, user: user, question_category: question_category, question: question2, is_correct: false, session_ts: session_ts2)
      create(:quiz_result, user: user, question_category: question_category, question: question3, is_correct: false, session_ts: session_ts2)
    end

    it '結果を集計できること' do
      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.to_a.size).to eq(3)
      expect(subject.first.session_ts).to eq(session_ts2)
      expect(subject.first.question_category_id).to eq(question_category.id)
      expect(subject.first.total_questions).to eq(3)
      expect(subject.first.correct_answers).to eq(1)
    end

    it 'セッションタイムスタンプの降順で並んでいること' do
      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.first.session_ts).to eq(session_ts2)
      expect(subject.second.session_ts).to eq(session_ts1)
    end

    it '同じセッションタイムスタンプでも問題集が異なる場合は別のセッションとして扱われること' do
      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.to_a.size).to eq(3)
    end

    it '他のユーザーのデータは含まれないこと' do
      other_user = create(:user)
      create(:quiz_result, user: other_user, question_category: question_category, question: question1, is_correct: true, session_ts: session_ts2)

      subject = QuizResult.aggregate_results_by_session(user.id)

      expect(subject.to_a.size).to eq(3)
    end
  end
end
