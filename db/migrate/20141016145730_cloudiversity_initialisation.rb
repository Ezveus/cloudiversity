class CloudiversityInitialisation < ActiveRecord::Migration
    def change
        create_table :users do |t|
            ## Database authenticatable
            t.string     :login,                 null:    false, default: ""
            t.string     :email,                 null:    false, default: ""
            t.string     :encrypted_password,    null:    false, default: ""
            t.string     :first_name,            null:    false, default: ""
            t.string     :last_name,             null:    false, default: ""
            t.string     :avatar
            t.string     :reset_password_token
            t.datetime   :reset_password_sent_at
            t.string     :authentication_token

            ## Rememberable
            t.datetime   :remember_created_at

            ## Trackable
            t.integer    :sign_in_count,         null:    false, default: 0
            t.datetime   :current_sign_in_at
            t.datetime   :last_sign_in_at
            t.string     :current_sign_in_ip
            t.string     :last_sign_in_ip

            ## Lockable
            t.integer    :failed_attempts,       null:    false, default: 0 # Only if lock strategy is :failed_attempts
            t.string     :unlock_token # Only if unlock strategy is :email or :both
            t.datetime   :locked_at

            ## Indexes
            t.index      :login,                 unique:  true
            t.index      :authentication_token
            t.index      :reset_password_token,  unique:  true
            t.index      :unlock_token,          unique:  true

            t.timestamps
        end

        create_table :periods do |t|
            t.string     :name
            t.date       :start_date
            t.date       :end_date
            t.string     :handle
            t.index      :handle

            t.timestamps
        end

        create_table :school_classes do |t|
            t.string     :name,                  null:    false
            t.string     :handle
            t.belongs_to :period,                index:   true

            t.index      :handle

            t.timestamps
        end

        create_table :disciplines do |t|
            t.string     :name
            t.string     :handle
            t.index      :handle

            t.timestamps
        end

        create_table :abstract_roles do |t|
            t.belongs_to :user,                  index:   true
            t.belongs_to :role,                  index:   true,  polymorphic: true

            t.timestamps
        end

        create_table :teachers do |t|
            t.timestamps
        end

        create_table :students do |t|
            t.timestamps
        end

        create_table :admins do |t|
            t.timestamps
        end

        create_table :parents do |t|
            t.timestamps
        end

        create_table :kinships do |t|
            t.belongs_to :parent,              index: true
            t.belongs_to :student,             index: true

            t.timestamps
        end

        create_table :teachings do |t|
            t.belongs_to :teacher,             index:   true
            t.belongs_to :school_class,        index:   true
            t.belongs_to :discipline,          index:   true
        end

        create_table :attachments do |t|
            t.string     :file
            t.belongs_to :attachable,          index:   true,  polymorphic: true

            t.timestamps
        end

        create_join_table :students, :school_classes do |t|
            t.index      :student_id
            t.index      :school_class_id
        end
    end
end
