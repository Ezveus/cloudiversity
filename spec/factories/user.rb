FactoryGirl.define do
  factory :user do
    login "foo"
    email "foo@cloudiversity.eu"
    first_name "Foo"
    last_name "Bar"
  end
end
