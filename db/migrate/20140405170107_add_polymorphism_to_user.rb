class AddPolymorphismToUser < ActiveRecord::Migration
  def change
    add_reference :users, :role, polymorphic: true, index: true
  end
end
