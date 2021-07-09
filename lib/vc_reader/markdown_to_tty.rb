# frozen_string_literal: true

module VcReader
  class MarkdownToTty
    attr_reader :markdown

    def initialize(markdown)
      @markdown = markdown
      @image_data = []
    end

    # @return [String]
    def call
      reverse_content = ReverseMarkdown.convert(markdown, unknown_tags: :drop)
      collect_image_data(reverse_content)
      render_tty_markdown(reverse_content)
    end

    private

    attr_reader :image_data

    def collect_image_data(text)
      text.gsub(/!\[([^\]]*)\]\((.*?)\s*("(?:.*[^"])")?\s*\)/) do
        title = Regexp.last_match(1)
        url = Regexp.last_match(2)
        @image_data.push({ title: title, url: url, string: ImageConverter.image_to_str(url) })
        Regexp.last_match(0)
      end
    end

    def render_tty_markdown(text)
      tty_content = TTY::Markdown.parse(text, symbols: :ascii, width: 100_500)
      image_data.each do |i|
        tty_content.gsub!("(#{i[:title]} - #{i[:url]})", i[:string])
      end
      tty_content
    end
  end
end
