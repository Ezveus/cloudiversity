class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.references :commentable, polymorphic: true
      t.belongs_to :user, index: true
      t.belongs_to :deleted_by

      t.timestamps
    end
  end
end
