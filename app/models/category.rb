class Category < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :quiz_results, dependent: :destroy

  validates :name, presence: true

  def prepare_quiz(randomize)
    question_ids = questions.pluck(:id)
    question_ids.shuffle! if randomize
    question_ids
  end
end
