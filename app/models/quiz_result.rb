class QuizResult < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :question
end
