class UpdateDeviseFields < ActiveRecord::Migration
    def up
        remove_column :users, :confirmation_token
        remove_column :users, :confirmed_at
        remove_column :users, :confirmation_sent_at
        remove_column :users, :unconfirmed_email

        add_column :users, :reset_password_token, :string
        add_column :users, :reset_password_sent_at, :datetime

        add_index :users, :reset_password_token, unique: true
    end

    def down
        remove_column :users, :reset_password_token
        remove_column :users, :reset_password_sent_at
        
        add_column :users, :confirmation_token, :string
        add_column :users, :confirmed_at, :datetime
        add_column :users, :confirmation_sent_at, :datetime
        add_column :users, :unconfirmed_email, :string

        add_index :users, :reset_password_token, unique: true
    end
end
