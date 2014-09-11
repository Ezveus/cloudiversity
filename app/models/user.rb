class User < ActiveRecord::Base
    acts_as_token_authenticatable

    devise :database_authenticatable,
        :rememberable, :trackable, :lockable,
        :validatable, :recoverable

    has_many :abstract_roles

    mount_uploader :avatar, AvatarUploader

    validates :login,
        presence: true,
        length: { minimum: 6 },
        uniqueness: true,
        format: /\A[a-z][\w\.-]+\z/i
    validates :first_name, presence: true
    validates :last_name, presence: true

    self.per_page = 10

    def full_name
        last_name + ", " + first_name
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

    def good?
        password_set? and not locked_at?
    end

    def login_full_name
        login + " - " + full_name
    end

    def roles
        abstract_roles
    end

    def method_missing(m, *args, &block)
        User.app_roles
        if /is_(?<role__name>\w+)\?/ =~ m.to_s
            role__name.capitalize!
            if @@roles.include?(role__name)
                return roles.map{|r| r.role_type}.include? role__name
            end
        elsif /as_(?<role_name>\w+)/ =~ m.to_s
            role_name.capitalize!
            if @@roles.include?(role_name)
                ar = roles.select{|r| r.role_type == role_name}.first
                if ar
                    return ar.role
                else
                    return nil
                end
            end
        end
        super
    end

    def to_param
        login
    end

    # Reimplements standard +find+ to be able to find by both login and
    # id.
    # Just check if the parameter looks like an id (first character is a
    # number) and sends back to standard +find+ or, if it's a login, uses
    # +find_by+.
    # As the standard method, returns a user or raise an exception.
    def self.find(id)
        if id.to_s =~ /\A\d/
            super id
        else
            find_by! login: id
        end
    end

    def to_json
        {
            id: id,
            login: login,
            first_name: first_name,
            last_name: last_name,
            email: email,
            roles: roles.map do |role|
                role.role_type
            end
        }.to_json
    end

    def self.app_roles
        @@roles ||= ActiveRecord::Base.connection.tables.map do |model|
            model.capitalize.singularize.camelize
        end.select do |model|
            begin
                model.constantize.ancestors.include? UserRole
            rescue
                false
            end
        end
    end

    protected

    def password_required?
        encrypted_password? and (not password.nil? or not password_confirmation.nil?)
    end
end
