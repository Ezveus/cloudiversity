# -*- coding: utf-8 -*-
module Cloudiversity
    ## The core of `auto_input` method. This module injects itself in
    # rails's `FormHelper` to provide the new method.
    module FormHelper
        ## Function to automatically generate a form field, its label, and
        # error tag. It is called by `FormBuilder::auto_input`, so see
        # this function for call details.
        #
        # `auto_input` will take care of the following:
        # * Layout (`div` tags, classes)
        # * Error classes and messages
        # * Find the correct field to use (currently only works for passowrd fields)
        def auto_input(object, field, opts = {})
            # Extract the parameters that we will use to generate elements
            label_opts = opts[:label] || {}
            field_opts = opts[:field] || {}
            hide = opts[:hide] || false
            row_opts = "row"

            # Get the object we are working on, we need it for errors
            obj = instance_variable_get('@' + object.to_s)

            # Add some classes
            add_class(label_opts, :inline)
            if obj.errors.include?(field)
                add_class(label_opts, :error)
                add_class(field_opts, :error)
            end
            row_opts += " hide" if hide

            # The elements
            content_tag :div, id: "#{object}_#{field}_row", class: row_opts do
                content_tag(:div, class: 'large-3 columns') do
                    label object, field, label_opts
                end + content_tag(:div, class: 'large-9 columns') do
                    method = :text_field

                    if field.to_s.start_with?("password")
                        method = :password_field
                    end

                    # Developper may override our detection
                    if opts.has_key?(:field_method)
                        method = (opts[:field_method].to_s + "_field").to_sym
                        method = :text_area if opts[:field_method].to_s == 'text_area'
                    end

                    out = self.send method, object, field, field_opts

                    if obj.errors.include?(field)
                        out += content_tag(:small, class: 'error') do
                            obj.errors.full_messages_for(field).first
                        end
                    end

                    out
                end
            end
        end

        ## Inject the `FormBuilder` module in-place
        def self.included(arg)
            ActionView::Helpers::FormBuilder.send(:include, Cloudiversity::FormBuilder)
        end

        private
        ## Little helper to auto-add class
        def add_class(opts, cls)
            if opts.has_key?(:class)
                opts[:class] += ' ' + cls.to_s
            else
                opts[:class] = cls.to_s
            end
        end
    end

    ## Provides the +auto_input+ method in the `FormBuilder`.
    module FormBuilder
        ## The method you will call from the form helper object in your
        # view. The call differ slightly from “classic” Rails calls :
        # * The first argument is the field name
        # * Then follow a option array. The label and fields options
        #   that you would have put here should be hashes under
        #   `label` and `field` keys respectively. The following
        #   top-level options are available:
        #   * `field_method`: allows to select a different filed type.
        #     Use the name of the Rails method to generate the field,
        #     without the `_field` suffix, e.g. `:email`.
        def auto_input(field, opts = {})
            @template.auto_input(@object_name, field, opts)
        end
    end
end

ActionView::Helpers::FormHelper.send(:include, Cloudiversity::FormHelper)
