module Cloudiversity::AssetsHelper
    ## Function to include a controller-defined stylesheet
    # All options are passed as provided to `stylesheet_link_tag`
    def controller_stylesheet_link_tag(options = {})
        unless params[:controller].blank?
            stylesheet_link_tag "#{params[:controller]}_controller", options
        end
    end

    ## Function to include a controller-defined Javascript
    # All options are passed as provided to `javascript_include_tag`
    def controller_javascript_include_tag(options = {})
        unless params[:controller].blank?
            javascript_include_tag "#{params[:controller]}_controller", options
        end
    end

    ## Function to get controller- and action-defined classes for body
    # Additional classes can be passed and are get through an array
    def controller_body_class(*classes)
        body_classes = ["#{params[:controller].parameterize}_controller",
                        "#{params[:controller].parameterize}_controller_#{params[:action]}"]
        classes.each do |c|
            body_classes << c.parameterize
        end
        body_classes.join(' ')
    end
end
