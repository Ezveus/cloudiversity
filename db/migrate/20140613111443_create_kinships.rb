class CreateKinships < ActiveRecord::Migration
  def change
    create_table :kinships do |t|
      t.belongs_to :parent, index: true
      t.belongs_to :student, index: true

      t.timestamps
    end
  end
end
