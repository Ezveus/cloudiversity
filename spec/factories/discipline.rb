# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :discipline do
        name "test discipline"
    end

    factory :multiple_disciplines, class: Discipline do
        sequence(:name) { |n| "test discipline #{n}" }
    end
end
