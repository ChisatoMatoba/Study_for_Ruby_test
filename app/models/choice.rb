class Choice < ApplicationRecord
  belongs_to :question

  with_options presence: true do
    validates :question_id
    validates :content
  end
end
