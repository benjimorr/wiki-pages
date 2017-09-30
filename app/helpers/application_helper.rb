require 'redcarpet'

module ApplicationHelper
    def form_group_tag(errors, &block)
        css_class='form-group'
        css_class << ' has-error' if errors.any?
        content_tag :div, capture(&block), class: css_class
    end

    def render_markdown(text)
        renderer = Redcarpet::Render::HTML.new(render_options = {
                filter_html: true,
                hard_wrap: true,
                link_attributes: { rel: 'nofollow', target: "_blank" },
                space_after_headers: true,
                fenced_code_blocks: true
            })

        markdown = Redcarpet::Markdown.new(renderer, extensions = {
                autolink: true,
                superscript: true,
                disable_indented_code_blocks: true
            })

        markdown.render(text).html_safe if text
    end
end
