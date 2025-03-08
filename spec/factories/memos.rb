FactoryBot.define do
  factory :memo do
    user
    question
    content { Faker::Lorem.sentence }
  end
end
