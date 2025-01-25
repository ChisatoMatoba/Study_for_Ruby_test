FactoryBot.define do
  factory :question do
    category
    number { Faker::Number.number(digits: 2) }
    content { Faker::Lorem.sentence }
    explanation { Faker::Lorem.sentence }
  end
end
