class User < ActiveRecord::Base
    devise :database_authenticatable,
        :rememberable, :trackable, :confirmable, :lockable

    belongs_to :role, polymorphic: true

    validates :login, presence: true, length: { minimum: 6 }, uniqueness: true
    validates :email, presence: true, format: Devise.email_regexp, uniqueness: { case_sensitive: false }
    validates :first_name, presence: true
    validates :last_name, presence: true

    def full_name
        first_name + " " + last_name
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
end
