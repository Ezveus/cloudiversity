# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :exercices_choice, :class => 'Exercices::Choice' do
        choice "MyString"
        is_correct false
        Question nil
    end
end
