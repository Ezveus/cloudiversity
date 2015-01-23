# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :exercices_exercice, :class => 'Exercices::Exercice' do
        start_date "2014-07-27"
        end_date "2014-07-27"
        is_graduated false
        teacher_school_class_discipline nil
        exercice_type nil
    end
end
