# require 'cloudiversity/link_renderer'
load Rails.root.to_s + '/lib/cloudiversity/link_renderer.rb'

module ApplicationHelper
    # See https://github.com/mislav/will_paginate/wiki/Link-renderer
    def will_paginate(collection_or_options = nil, options = {})
        if collection_or_options.is_a? Hash
            options, collection_or_options = collection_or_options, nil
        end
        unless options[:renderer]
            options = options.merge renderer: Cloudiversity::LinkRenderer
        end
        super *[collection_or_options, options].compact
    end
end
