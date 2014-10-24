FactoryGirl.define do
    factory :admin do
        after :build do |admin|
            u = create :user
            admin.user = u
        end
    end
end
