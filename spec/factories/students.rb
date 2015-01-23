# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :student do
        association :user, factory: :user
    end

    factory :multiple_students, class: :student do
        association :user, factory: :multiple_users
    end
end
