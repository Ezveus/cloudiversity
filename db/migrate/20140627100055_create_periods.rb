class CreatePeriods < ActiveRecord::Migration
    def change
        create_table :periods do |t|
            t.date :end_date
            t.string :name
            t.date :start_date

            t.timestamps
        end

        change_table :teacher_school_class_disciplines do |t|
            t.belongs_to :period, index: true, default: nil
        end
    end
end
