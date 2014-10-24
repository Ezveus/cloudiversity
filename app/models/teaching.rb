class Teaching < ActiveRecord::Base
    belongs_to :teacher
    belongs_to :school_class
    belongs_to :discipline

    has_many :students, through: :school_class
    has_one :period, through: :school_class

    validates_presence_of :teacher_id, :school_class_id, :discipline_id
    validates_with TeachingValidator
end
