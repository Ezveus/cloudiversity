class Period < ActiveRecord::Base
    has_many :teacher_school_class_discipline, dependent: :destroy
    has_many :teachers, through: :teacher_school_class_discipline
    has_many :disciplines, through: :teacher_school_class_discipline
    has_many :school_classes, through: :teacher_school_class_discipline

    validates_presence_of :name, :end_date, :start_date
    validates_with DateValidator

    def to_s
        "#{name} (#{start_date} - #{end_date})"
    end
end
