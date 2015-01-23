class Exercices::Question < ActiveRecord::Base
    belongs_to :Mcq
    has_many :exercice_questions, class_name: 'Exercice::Question', foreign_key: 'exercice_question_id'

    validates_presence_of :Mcq, :timer, :wording, :availability_mode
    validates_uniqueness_of :question, scope: :Mcq, case_sensitive: false
    validates_inclusion_of :availability_mode, :in => 1..3
    validates_length_of :wording, :maximum => 50
end
