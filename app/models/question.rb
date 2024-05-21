require 'csv'

class Question < ApplicationRecord
  belongs_to :category
  has_many :choices, dependent: :destroy

  with_options presence: true do
    validates :category_id
    validates :content
    validates :number, uniqueness: { scope: :category_id }
  end

  def self.import(file, category, overwrite)
    CSV.foreach(file.path, headers: true) do |row|
      question = category.questions.find_by(number: row['number'])

      if question
        if overwrite
          question.update!(
            content: row['question_content'],
            explanation: row['explanation']
          )
          question.choices.destroy_all
          choices_create(question, row['choices'])
        end
      else
        category.questions.create!(
          number: row['number'],
          content: row['question_content'],
          explanation: row['explanation']
        )
        choices_create(question, row['choices'])
      end
    end
  end

  private

  def self.choices_create(question, choices)
    choices.split(',').each do |choice|
      content, is_correct = choice.split('|')
      question.choices.create!(content: content.strip, is_correct: is_correct.strip == 'true')
    end
  end
end
