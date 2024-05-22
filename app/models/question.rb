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
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, line_number|
      begin
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
          question = category.questions.create!(
            number: row['number'],
            content: row['question_content'],
            explanation: row['explanation']
          )
          choices_create(question, row['choices'])
        end
      rescue StandardError => e
        errors << "Line #{line_number}: #{e.message}"
      end
    end

    raise "Import failed with the following errors:\n" + errors.join("\n") if errors.any?
  end

  private

  def self.choices_create(question, choices)
    choices.split(',').each do |choice|
      content, is_correct = choice.split('|')
      question.choices.create!(content: content.strip, is_correct: is_correct.strip == 'true')
    end
  end
end
