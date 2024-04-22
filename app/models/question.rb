class Question < ApplicationRecord
  belongs_to :category
  has_many :choices, dependent: :destroy

  with_options presence: true do
    validates :category_id
    validates :content
    validates :number, uniqueness: { scope: :category_id }
  end
end
