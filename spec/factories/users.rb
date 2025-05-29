FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "test#{rand(1000)}#{ENV['ALLOWED_EMAIL_DOMAIN'] || '@example.com'}" }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'general' }
  end
end
