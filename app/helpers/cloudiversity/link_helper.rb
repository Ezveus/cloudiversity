module Cloudiversity::LinkHelper
    # Generate an "action" link, i.e. the icons you find in tables in
    # action column. Will automatically add good classes and HTML
    # attributes such as tooltips.
    #
    # It takes the same arguments as link_to, except you can't pass block.
    # It has an additionnal option, `glyph`, which you can use to indicate
    # which glyph to use. Defaults to `arrow-right`.
    def action_to(text, path, options = {})
        glyph = options.delete(:glyph) || 'arrow-right'
        if options.include?(:class)
            options[:class] += " button glyph-button glyph-#{glyph}"
        else
            options[:class] = "button glyph-button glyph-#{glyph}"
        end

        options.merge! title: text

        link_to text, path, options
    end
end
