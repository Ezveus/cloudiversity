# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :school_class do
        name "Test school class"
    end

    factory :multiple_school_classes, class: SchoolClass do
        sequence(:name) { |n| "test school class #{n}" }
    end
end
