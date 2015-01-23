# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :exercices_question, :class => 'Exercices::Question' do
        availability_mode false
        timer "2014-08-02 18:32:02"
        wording "MyText"
        MCQ nil
    end
end
