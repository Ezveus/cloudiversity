class CreatePeriods < ActiveRecord::Migration
    def change
        create_table :periods do |t|
            t.date :end_date
            t.string :name
            t.date :start_date

            t.timestamps
        end
    end
end
