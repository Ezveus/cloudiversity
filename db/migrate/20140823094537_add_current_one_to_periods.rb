class AddCurrentOneToPeriods < ActiveRecord::Migration
  def change
    add_column :periods, :current, :boolean, default: false
  end
end
