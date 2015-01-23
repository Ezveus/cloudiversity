# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :exercices_mcq, :class => 'Exercices::Mcq' do
        allow_blank false
        blank_point 1
        correct_point 1
        multiple false
        number_of_question 1
        training_number 1
        wrong_points 1
     end
end
