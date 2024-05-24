class Category < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :name, presence: true
end
