class Cloudiversity::LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
        tag :ul, html, class: 'uk-pagination'
    end

    def page_number(page)
        unless page == current_page
            tag(:li, link(page, page, rel: rel_value(page)))
        else
            tag(:li, tag(:span, page), class: 'uk-active')
        end
    end

    def previous_page
        num = @collection.current_page > 1 && @collection.current_page - 1
        previous_or_next_page(num, tag(:i, '', class: 'uk-icon-angle-double-left'), 'uk-pagination-previous')
    end

    def next_page
        num = @collection.current_page < total_pages && @collection.current_page + 1
        previous_or_next_page(num, tag(:i, '', class: 'uk-icon-angle-double-right'), 'uk-pagination-next')
    end

    def previous_or_next_page(page, text, classname)
        if page
            tag(:li, link(text, page), class: classname)
        else
            tag(:li, tag(:span, text), class: classname + ' uk-disabled')
        end
    end
end
