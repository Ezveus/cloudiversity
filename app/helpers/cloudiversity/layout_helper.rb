# Helper which provides functions to generate standard page elements
# easily. These functions have to be used each time a standard element
# is provided here.
module Cloudiversity::LayoutHelper
    # Sets the page title.
    # Settings a page title is compulsory for each page.
    def title!(title)
        content_for :title do
            title
        end
    end

    # Defines the object passed to the block in `sidebar!`, providing quick
    # functions to generate the contents of the sidebar.
    class SidebarHelper
        # Creates a new `SidebarHelper`.
        # Saves the current context for later use.
        def initialize(ctx)
            @ctx = ctx
            @waiting_header = nil
        end

        # Generates a link entry.
        #
        # `text` and `link` are similar to `link_to`'s first arguments.
        # `opts` is an optional hash which can hold an the following entries:
        # * `icon`: Sets an icon to the link (icon name, without prefix)
        # * `subtitle`: Adds an additional subtitle text
        def link(text, link, opts = {})
            waiting_header = @waiting_header
            @waiting_header = nil
            @ctx.instance_eval {
                l = unless waiting_header.nil?
                    content_tag(:li, class: 'uk-nav-header') do
                        waiting_header
                    end
                end || ''
                l += content_tag(:li) do
                    link_to(link, opts[:link] || {}) do
                        s = ''

                        unless opts[:icon].nil?
                            s += content_tag(:i, '', class: "uk-icon-#{opts[:icon]}")
                            s += '&nbsp;'
                        end

                        s += text

                        unless opts[:subtitle].nil?
                            s += content_tag(:div, opts[:subtitle])
                        end

                        raw s
                    end
                end
                raw l
            }
        end

        # Generates a header in the menu
        # The element is actually really generated if you put at least one
        # link below
        def header(text)
            @waiting_header = text
            ''
        end
    end

    # Generates a sidebar. The block takes one argument which is a SidebarHelper
    # object.
    def sidebar!(&blk)
        content_for :sidebar do
            content_tag :ul, class: 'uk-nav uk-nav-side' do
                blk.call SidebarHelper.new(self)
            end
        end
    end
end
