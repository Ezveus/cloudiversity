class Exercices::Mcq < ActiveRecord::Base
    has_many :exercice_questions, class_name: 'Exercice::Question', foreign_key: 'exercice_mcq_id'

    validates_presence_of :allow_blank, :blank_points, :correct_points, :wrong_points, :multiple,
    :question_number, :training_number, :random_mode
    validates_inclusion_of :random_mode, :in => 0..3
    validates_numericality_of :question_number, :greater_than_or_equal_to => 0
    validates_numericality_of :training_number, :greater_than_or_equal_to => 0
end
