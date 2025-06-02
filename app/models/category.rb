class Category < ApplicationRecord
  has_many :question_categories, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  # カテゴリに関連する問題集がある場合は削除できない
  before_destroy :ensure_no_question_categories

  private

  def ensure_no_question_categories
    if question_categories.exists?
      errors.add(:base, '関連する問題集があるため、このカテゴリは削除できません')
      throw :abort
    end
  end
end
