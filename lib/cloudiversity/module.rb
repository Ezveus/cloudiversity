module Cloudiversity
    module ModuleManager
        @@modules = []

        def self.register_module(mod)
            @@modules << mod.new
        end

        def self.modules
            @@modules
        end
    end

    module Module
        def self.included(where)
            ModuleManager.register_module where
        end

        def name
            self.class.name.split('::')[0]
        end

        def namespace
            name.underscore
        end

        def role_previews
            []
        end
    end
end
