require 'csv'

class Question < ApplicationRecord
  belongs_to :category
  has_many :choices, dependent: :destroy
  has_many :quiz_results, dependent: :destroy
  has_many :memos, dependent: :destroy

  with_options presence: true do
    validates :category_id
    validates :content
    validates :number, uniqueness: { scope: :category_id }
  end

  def session_result(selected_ids)
    correct_choice_ids = choices.where(is_correct: true).pluck(:id)
    is_correct = (selected_ids - correct_choice_ids).empty? && (correct_choice_ids - selected_ids).empty?
    {
      selected: selected_ids,
      correct: correct_choice_ids,
      is_correct: is_correct
    }
  end

  def memo_content(user)
    memos.find_by(user_id: user.id)&.content
  end

  class << self
    def import(file, category, overwrite)
      CSV.foreach(file.path, headers: true) do |row|
        question = category.questions.find_by(number: row['number'])

        if question
          overwrite_question_choices(question, row) if overwrite
        else
          create_question_choices(row, category)
        end
      end
    end

    private

    def overwrite_question_choices(question, row)
      question.update!(
        content: row['question_content'],
        explanation: row['explanation']
      )
      question.choices.destroy_all
      choices_create(question, row['choices'])
    end

    def create_question_choices(row, category)
      question = category.questions.create!(
        number: row['number'],
        content: row['question_content'],
        explanation: row['explanation']
      )
      choices_create(question, row['choices'])
    end

    def choices_create(question, choices)
      choices.split(',,').each do |choice|
        content, is_correct = choice.split('~')
        question.choices.create!(content: content.strip, is_correct: is_correct.strip == 'true')
      end
    end
  end
end
