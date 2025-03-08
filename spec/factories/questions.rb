FactoryBot.define do
  factory :question do
    category
    number { SecureRandom.random_number(10_000) }
    content { Faker::Lorem.sentence }
    explanation { Faker::Lorem.sentence }
  end
end
