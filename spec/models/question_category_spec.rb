require 'rails_helper'

RSpec.describe QuestionCategory, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      question_category = build(:question_category)
      expect(question_category).to be_valid
    end

    it 'nameがなければ無効であること' do
      question_category = build(:question_category, name: nil)
      expect(question_category.valid?).to eq(false)
      expect(question_category.errors.full_messages).to include('問題集名 が入力されていません')
    end
  end

  describe '#prepare_quiz(randomize)' do
    let(:question_category) { create(:question_category) }
    let!(:question1) { create(:question, question_category: question_category) }
    let!(:question2) { create(:question, question_category: question_category) }
    let!(:question3) { create(:question, question_category: question_category) }

    it '問題のIDをランダムに並び替えること' do
      question_ids = question_category.prepare_quiz(true)
      expect(question_ids).to match_array([question1.id, question2.id, question3.id])
    end

    it '問題のIDを並び替えないこと' do
      question_ids = question_category.prepare_quiz(false)
      expect(question_ids).to match_array([question1.id, question2.id, question3.id])
    end
  end
end
