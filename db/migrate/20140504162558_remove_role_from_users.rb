class RemoveRoleFromUsers < ActiveRecord::Migration
  def change
    remove_reference :users, :role, polymorphic: true, index: true
  end
end
