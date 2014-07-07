class Period < ActiveRecord::Base
    validates_presence_of :name, :end_date, :start_date
    validates_with DateValidator
end
