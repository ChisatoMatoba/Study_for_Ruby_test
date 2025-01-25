require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      category = build(:category)
      expect(category).to be_valid
    end

    it 'nameがなければ無効であること' do
      category = build(:category, name: nil)
      expect(category.valid?).to eq(false)
      expect(category.errors.full_messages).to include('カテゴリー名 が入力されていません')
    end
  end

  describe '#prepare_quiz(randomize)' do
    let(:category) { create(:category) }
    let!(:question1) { create(:question, category: category) }
    let!(:question2) { create(:question, category: category) }
    let!(:question3) { create(:question, category: category) }

    it '問題のIDをランダムに並び替えること' do
      question_ids = category.prepare_quiz(true)
      expect(question_ids).to match_array([question1.id, question2.id, question3.id])
    end

    it '問題のIDを並び替えないこと' do
      question_ids = category.prepare_quiz(false)
      expect(question_ids).to match_array([question1.id, question2.id, question3.id])
    end
  end
end
