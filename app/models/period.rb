class Period < ActiveRecord::Base
    include Handleable

    has_many :school_classes
    has_many :teachings, through: :school_classes

    validates_presence_of :name, :end_date, :start_date
    validates_uniqueness_of :name
    validates_with TimeSpanValidator

    def self.current
        # FIXME: This is SQLite only. MySQL uses `NOW()`. Should use a standard method or detect cases.
        where('DATE(\'now\') BETWEEN `start_date` AND `end_date`')
    end

    def to_s
        "#{name} (#{start_date} - #{end_date})"
    end

    def duration
        (end_date - start_date).to_i
    end

    def elapsed
        (Time.now.to_date - start_date).to_i
    end

    def remaining
        (end_date - Time.now.to_date).to_i
    end

    def current?
        start_date < Time.now.to_date and end_date > Time.now.to_date
    end

    def future?
        start_date > Time.now.to_date
    end

    def past?
        end_date < Time.now.to_date
    end

    def relative
        if past?
            :past
        elsif future?
            :future
        else
            :current
        end
    end

    def elapsed_percent
        elapsed * 100 / duration
    end

    protected
    def generate_handle
      name.nil? ? nil : name.parameterize
    end
end
