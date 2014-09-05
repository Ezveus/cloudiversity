class TimeSpanValidator < ActiveModel::Validator
    def validate(record)
        if record.end_date && record.start_date && record.end_date < record.start_date
            record.errors[:end_date] = "should be later than start date"
        end
    end
end
