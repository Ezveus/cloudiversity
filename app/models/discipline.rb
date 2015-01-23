class Discipline < ActiveRecord::Base
    include Handleable

    has_many :teacher_school_class_discipline, dependent: :destroy
    has_many :teachers, through: :teacher_school_class_discipline
    has_many :school_classes, through: :teacher_school_class_discipline
    has_many :periods, through: :teacher_school_class_discipline

    # We want at least a non numeric character, so handles are useful
    validates :name, format: /[^\d]/

    protected

    def generate_handle
        name.parameterize
    end
end
