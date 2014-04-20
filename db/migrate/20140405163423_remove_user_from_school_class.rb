class RemoveUserFromSchoolClass < ActiveRecord::Migration
  def change
    remove_reference :users, :school_classes
  end
end
