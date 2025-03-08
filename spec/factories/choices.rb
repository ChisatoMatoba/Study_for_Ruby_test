FactoryBot.define do
  factory :choice do
    question
    content { Faker::Lorem.sentence }
    is_correct { [true, false].sample }
  end
end
