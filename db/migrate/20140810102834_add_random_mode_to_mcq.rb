class AddRandomModeToMcq < ActiveRecord::Migration
  def change
    add_column :mcqs, :random_mode, :integer
  end
end
