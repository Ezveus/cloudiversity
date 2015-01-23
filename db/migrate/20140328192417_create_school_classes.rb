class CreateSchoolClasses < ActiveRecord::Migration
    def change
        create_table :school_classes do |t|
            t.string :name, null: false

            t.timestamps
        end

        change_table :users do |t|
            t.belongs_to :school_class, index: true, default: nil
        end
    end
end
