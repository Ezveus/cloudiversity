class CreateAbstractRoles < ActiveRecord::Migration
  def change
    create_table :abstract_roles do |t|
      t.references :user, index: true
      t.references :role, polymorphic: true, index: true

      t.timestamps
    end
  end
end
