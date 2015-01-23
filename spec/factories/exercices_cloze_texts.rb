# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :exercices_cloze_text, :class => 'Exercices::ClozeText' do
        text "MyString"
    end
end
