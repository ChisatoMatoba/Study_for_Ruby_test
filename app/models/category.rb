class Category < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :quiz_results, dependent: :destroy

  validates :name, presence: true
end
