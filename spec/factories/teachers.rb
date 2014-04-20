# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :teacher do
        association :user, factory: :user
    end

    factory :multiple_teachers, class: :teacher do
        association :user, factory: :multiple_users
    end
end
