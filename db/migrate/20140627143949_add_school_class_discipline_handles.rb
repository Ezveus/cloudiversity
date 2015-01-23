class AddSchoolClassDisciplineHandles < ActiveRecord::Migration
    def change
        add_column :school_classes, :handle, :string
        add_column :disciplines, :handle, :string

        add_index :school_classes, :handle
        add_index :disciplines, :handle

        reversible do |dir|
            dir.up do
                puts ''
                puts "== WARNING =="
                puts "This migration need manual action to be perfomed on data."
                puts "Please run `rake cloudi:fix:handles` to migrate data."
                puts ''
            end
        end
    end
end
