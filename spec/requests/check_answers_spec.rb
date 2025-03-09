require 'rails_helper'

RSpec.describe 'CheckAnswers', type: :request do
  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }
    let(:question) { create(:question, category: category) }
    let!(:choice1_true) { create(:choice, question: question, is_correct: true) }
    let!(:choice2_false) { create(:choice, question: question, is_correct: false) }
    let!(:choice3_true) { create(:choice, question: question, is_correct: true) }
    let!(:memo) { create(:memo, question: question, user: user) }

    describe 'POST /categories/:category_id/questions/:question_id/check_answers' do
      before { sign_in user }

      it '正解のとき、is_correct=trueと解答、解説、メモを返すこと' do
        post category_question_check_answers_path(category, question), params: { choice_ids: [choice1_true.id, choice3_true.id] }, as: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['is_correct']).to be true
        expect(json_response['correct_choices']).to include(choice1_true.content, choice3_true.content)
        expect(json_response['explanation']).to eq(question.explanation)
        expect(json_response['memo']).to eq(memo.content)
      end

      it '不正解のとき、is_correct=falseと解答、解説、メモを返すこと' do
        post category_question_check_answers_path(category, question), params: { choice_ids: [choice2_false.id, choice3_true.id] }, as: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['is_correct']).to be false
        expect(json_response['correct_choices']).to include(choice1_true.content, choice3_true.content)
        expect(json_response['explanation']).to eq(question.explanation)
        expect(json_response['memo']).to eq(memo.content)
      end
    end
  end
end
