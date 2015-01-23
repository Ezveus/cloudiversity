class RemoveUserFromSchoolClass < ActiveRecord::Migration
  def change
    remove_reference :users, :school_class
  end
end
