require 'csv'

class Question < ApplicationRecord
  belongs_to :category
  has_many :choices, dependent: :destroy

  with_options presence: true do
    validates :category_id
    validates :content
    validates :number, uniqueness: { scope: :category_id }
  end

  def self.import(file, category)
    CSV.foreach(file.path, headers: true) do |row|
      question = category.questions.create!(
        number: row['number'],
        content: row['question_content'],
        explanation: row['explanation']
      )

      row['choices'].split(',').each do |choice|
        content, is_correct = choice.split('|')
        question.choices.create!(content: content.strip, is_correct: is_correct.strip == 'true')
      end
    end
  end
end
