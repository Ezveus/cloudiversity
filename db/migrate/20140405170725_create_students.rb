class CreateStudents < ActiveRecord::Migration
    def change
        create_table :students do |t|
            t.references :school_class, default: nil
            t.timestamps
        end
    end
end
