class Exercices::Choice < ActiveRecord::Base
    belongs_to :Question

    validates_presence_of :Question, :choice, :is_correct
    validates_uniqueness_of :choice, scope: :Question, case_sensitive: false
end
