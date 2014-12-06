FactoryGirl.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name  { Faker::Name.last_name }
        login      { Faker::Internet.user_name(full_name, %w(-)) }
        email      { Faker::Internet.email(full_name) }
        password   { Faker::Internet.password }
        password_confirmation { password }
    end
end
