class Category < ApplicationRecord
  # question_categoriesがある場合は削除をエラーとする
  has_many :question_categories, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
