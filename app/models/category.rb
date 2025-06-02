class Category < ApplicationRecord
  # カテゴリを削除しても問題集は残す（関連付けは残す）
  # dependent: :nullifyは、category_idにnot null制約があるため使用不可
  has_many :question_categories

  validates :name, presence: true, uniqueness: true

  # カテゴリに関連する問題集がある場合は削除できない
  before_destroy :ensure_no_question_categories

  private

  def ensure_no_question_categories
    return unless question_categories.exists?

    errors.add(:base, '関連する問題集があるため、このカテゴリは削除できません')
    throw :abort
  end
end
