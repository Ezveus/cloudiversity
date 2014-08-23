class PeriodValidator < ActiveModel::Validator
    def validate(record)
        current_period = Period.get_current
        if current_period && record.current
            record.errors[:current] = "can't be true; another period is already the current one"
        end
    end
end
