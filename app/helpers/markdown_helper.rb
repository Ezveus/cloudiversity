# Helper to manage Markdown in Cloudiversity.
# This provides functions to create markdown input or output markdown,
# with automatic loading of libraries and safeties on.
module MarkdownHelper
    # Manages the markdown library. It instanciates a JavaScript runtime
    # to run Marked and then calls it when needed.
    class Parser
        MARKED_FILE = Rails.root.join('vendor', 'assets', 'bower_components', 'marked', 'lib', 'marked.js').to_s

        def initialize
            @engine = init_engine
            @engine.eval('marked.setOptions({ gfm: true, sanitize: true })')
        end

        # Parses markdown text.
        def parse(text)
            @engine[:source] = text
            @engine.eval('marked(source)').tap { |_| @engine[:source] = nil }
        end

    private
        # Selects between V8 or Rhino, depending on the platform.
        # Initializes a clean and usable context.
        def init_engine
            if RUBY_PLATFORM == "java"
                Rhino::Context.open do |ctx|
                    ctx.load(MARKED_FILE)
                    ctx
                end
            else
                ctx = V8::Context.new
                ctx.load(MARKED_FILE)
                ctx
            end
        end
    end

    # Parses markdown for output.
    # @param text [String] The input text as markdown
    # @return [String] The output as HTML
    def markdown(text)
        @@parser ||= Parser.new
        @@parser.parse text
    end

    # Creates a new markdown area in a form.
    # @param f [ActionView::Helpers::FormHelper] The form helper
    # @param opts [Hash] Additionnal options to the 'uk-htmleditor' data attribute.
    # @return [String] The generated field
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
