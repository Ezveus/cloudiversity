class AddPeriodHandles < ActiveRecord::Migration
    def change
        add_column :periods, :handle, :string

        add_index :periods, :handle

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
