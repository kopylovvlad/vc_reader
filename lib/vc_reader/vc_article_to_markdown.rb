# frozen_string_literal: true

module VcReader
  class VcArticleToMarkdown
    attr_reader :html_doc

    def initialize(html_body)
      @html_doc = Nokogiri::HTML(html_body)
      @headline_css = '.page.page--entry .l-entry .content-title'
      @content_css = '.page.page--entry .l-entry .l-entry__content .content.content--full'
    end

    # @return [String]
    def call
      html_headline = html_doc.css(headline_css)
      # delete links from headline
      html_headline.css('a').remove

      html_content = html_doc.css(content_css)
      # delete footer from the content
      delete_content(html_content)

      # add images to html
      fill_images_to_html(html_content)
      [html_headline.to_s, html_content.to_s].join("\n\n")
    end

    private

    attr_reader :headline_css, :content_css

    def replace_link(node)
      if node.text[0] == '#'
        node.replace('')
      else
        node.replace("<span>#{node.text}</span>")
      end
    end

    def delete_content(html_content)
      html_content.css('div.l-island-a p a').map(&method(:replace_link))
      html_content.css('div.l-island-a li a').map(&method(:replace_link))
      html_content.css('.content-info__item').remove
      html_content.css('.content-footer').remove
    end

    def fill_images_to_html(html_content)
      html_content.css('figure').each do |figure|
        imgs = figure.css('div.andropov_image').map do |img|
          # take image from attr data-image-src and change url
          img_src = img.attr('data-image-src')
          new_img_url = "#{img_src}-/preview/650/-/format/jpg/"
          alt = SecureRandom.hex(10)
          "<img src='#{new_img_url}' alt=#{alt} />"
        end

        imgs.size.positive? ? figure.replace(imgs.first) : figure.replace('<div></div>')
      end
    end
  end
end
