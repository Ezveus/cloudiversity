# Defines an handleable model.
#
# An handleable model has an +handle+ attribute, which is a stripped down version of a full
# name, suitable for use in URIs. It is automatically generated and used by the model.
# 
# To get this to work, you need to implement the private method +generate_handle+ which
# will create the handle from informations of the model on demand.
#
# @note The +generate_handle+ generated handle should not generate a numeric identifier.
# It should contain at least a non numeric character, or there will be conflicts in URI
# resolution.
module Handleable
    extend ActiveSupport::Concern

    FORMAT = /\A[\w\.-]+\z/i
    ROUTE_FORMAT = /[\w\.-]+/i

    included do
        validates :handle, presence: true, uniqueness: { case_sensitive: true }, format: FORMAT

        before_validation :generate_handle!, on: :create

        def self.find(id)
            if (Integer(id) rescue false)
                super id
            else
                find_by! handle: id
            end
        end

        def to_param
            self.handle
        end

        def generate_handle!
            self.handle = generate_handle
        end

        protected

        def generate_handle
            raise NotImplementedError
        end
    end
end
