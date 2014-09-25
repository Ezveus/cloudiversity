class Period < ActiveRecord::Base
    include Handleable

    has_many :teacher_school_class_discipline, dependent: :destroy
    has_many :teachers, through: :teacher_school_class_discipline
    has_many :disciplines, through: :teacher_school_class_discipline
    has_many :school_classes, through: :teacher_school_class_discipline

    validates_presence_of :name, :end_date, :start_date
    validates_uniqueness_of :name
    validates_with TimeSpanValidator
    validates_with PeriodValidator

    def to_s
        "#{name} (#{start_date} - #{end_date})"
    end

    def current_one?
        current
    end

    def self.get_current
        Period.find_by(current: true)
    end

    def self.set_current(p)
        current_one = Period.get_current

        current_one.update(current: false) if current_one
        p.update(current: true)
    end

    protected
    def generate_handle
        name.parameterize
    end
end
