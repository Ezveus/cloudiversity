FactoryGirl.define do
    factory :user do
        login "foo_bar"
        email "foo_bar@cloudiversity.eu"
        first_name "Foo"
        last_name "Bar"
    end

    factory :multiple_users, class: User do
        sequence(:login) { |n| "login#{n}" }
        sequence(:email) { |n| "email#{n}@fai.org" }
        sequence(:first_name) { |n| "first_name#{n}" }
        sequence(:last_name) { |n| "last_name#{n}" }
    end

    factory :admin, class: User do
        login "administrator"
        email "admin@cloudiversity.eu"
        first_name "Bruce"
        last_name "Almighty"
    end
end
