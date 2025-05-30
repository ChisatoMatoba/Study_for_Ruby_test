FactoryBot.define do
  factory :quiz_result do
    user
    question_category
    question
    session_ts { Time.current.to_i }
    is_correct { [true, false].sample }
    selected { [1, 2] }
    correct { [1] }
  end
end
