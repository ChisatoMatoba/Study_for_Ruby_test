FactoryBot.define do
  factory :question_category do
    name { Faker::Lorem.word }
    association :category
  end
end
