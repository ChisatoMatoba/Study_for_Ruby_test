class Category < ApplicationRecord
  has_many :question_categories, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
