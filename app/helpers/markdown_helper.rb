module MarkdownHelper
    def markdown(text)
        @@parser ||= Redcarpet::Markdown.new(
            Redcarpet::Render::HTML.new(
                escape_html: true,
                safe_links_only: true
            )
        )

        @@parser.render(text)
    end

    def markdown_area(f, opts = {})
        f.text_area :content, data: {
            'uk-htmleditor' => {
                markdown: true,
                autocomplete: false,
                markedOptions: { sanitize: true },
                codemirror: { mode: 'gfm' },
            }.merge(opts).to_json
        }
    end
end
