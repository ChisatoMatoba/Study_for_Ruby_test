require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      category = build(:category, name: 'Ruby Silver')
      expect(category).to be_valid
    end

    it 'nameがなければ無効であること' do
      category = build(:category, name: nil)
      expect(category.valid?).to eq(false)
      expect(category.errors.full_messages).to include('カテゴリ名 が入力されていません')
    end

    it '同じnameのカテゴリは作成できないこと' do
      create(:category, name: 'Ruby Silver')
      duplicate_category = build(:category, name: 'Ruby Silver')
      expect(duplicate_category.valid?).to eq(false)
      expect(duplicate_category.errors.full_messages).to include('カテゴリ名 はすでに存在します')
    end
  end

  describe '#ensure_no_question_categories' do
    context '関連するquestion_categoriesがある場合' do
      it '削除できないこと' do
        category = create(:category)
        create(:question_category, category: category)

        expect { category.destroy }.not_to(change { Category.count })
        expect(category.errors.full_messages).to include('関連する問題集があるため、このカテゴリは削除できません')
      end
    end

    context '関連するquestion_categoriesがない場合' do
      it '削除できること' do
        category = create(:category)

        expect { category.destroy }.to change { Category.count }.by(-1)
      end
    end
  end
end
