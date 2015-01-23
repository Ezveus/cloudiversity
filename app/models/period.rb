class Period < ActiveRecord::Base
    include Handleable

    has_many :school_classes
    has_many :teachings, through: :school_classes

    validates_presence_of :name, :end_date, :start_date
    validates_uniqueness_of :name
    validates_with TimeSpanValidator

    def to_s
        "#{name} (#{start_date} - #{end_date})"
    end

    protected
    def generate_handle
      name.nil? ? nil : name.parameterize
    end
end
