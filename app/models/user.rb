class User < ActiveRecord::Base
    acts_as_token_authenticatable

    devise :database_authenticatable,
        :rememberable, :trackable, :lockable,
        :validatable, :recoverable

    belongs_to :role, polymorphic: true

    validates :login, presence: true, length: { minimum: 6 }, uniqueness: true
    validates :first_name, presence: true
    validates :last_name, presence: true

    def full_name
        first_name + " " + last_name
    end

    # Password, reset, stuff. Better done here than in the view.
    # Has a password ever been set ?
    def password_set?
        encrypted_password?
    end

    # Is a password reset pending ?
    def reset_pending?
        # Devise resets reset_password_sent_at but not reset_password_token.
        reset_password_sent_at?
    end

    # If a password reset is pending, has it expired ?
    def reset_expired?
        reset_password_sent_at? and not reset_password_period_valid?
    end

    def login_full_name
        login + " - " + full_name
    end

    def is_student?
        role_type == "Student"
    end

    def is_teacher?
        role_type == "Teacher"
    end

    def as_teacher
        role if is_teacher?
    end

    def as_student
        role if is_student?
    end

    protected

    def password_required?
        encrypted_password? and (not password.nil? or not password_confirmation.nil?)
    end
end
