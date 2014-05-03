module UserRole
    extend ActiveSupport::Concern

    included do
        has_one :user, as: :role
        $extended_class = name
        ext_class = name

        $is_extended_class = proc { role_type == ext_class }
        $as_extended_class = proc { self.role if role_type == ext_class }

        class ::User
            define_method "is_#{$extended_class.underscore}?", $is_extended_class
            define_method "as_#{$extended_class.underscore}", $as_extended_class
        end
    end
end
