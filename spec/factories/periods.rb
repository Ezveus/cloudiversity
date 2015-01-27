# FactoryGirl.define do
#     factory :period do
#         end_date "2014-06-27"
#         name "MyString"
#         start_date "2014-06-27"
#     end
# end

FactoryGirl.define do
    factory :period do
        end_date { Date.today }
        name { Faker::Name.title }
        start_date { end_date - Faker::Number.number(3).to_i.days }
    end
end
