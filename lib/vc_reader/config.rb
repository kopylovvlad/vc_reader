# frozen_string_literal: true

module VcReader
  # here is only logic how to manipulate with data
  class Config
    attr_reader :vc_client, :link_repository

    def initialize
      @vc_client = VcClient.new
      @link_repository = LinkRepository.new
    end

    def current_links
      link_repository.current_links.map(&:render)
    end

    def first_fetch
      html_body = @vc_client.first_fetch
      find_links(html_body, '.news_widget a.news_item__title')
      find_last_id(html_body)
      nil
    end

    def load_prev_news
      link_repository.cursor_to_prev
      nil
    end

    def load_news
      json = @vc_client.load_news(link_repository.last_id)
      link_repository.last_id = json['last_id']
      find_links(json['html'], 'a.news_item__title')
      nil
    end

    # @return [String]
    def get_link_url(index)
      link_repository.find_by_index_and_mark(index).href
    end

    # @param index [Integer]
    # @return [String]
    def read_news(index)
      link = link_repository.find_by_index_and_mark(index)
      html_body = vc_client.get_page_body(link.href)
      # html to markdown
      converter = VcArticleToMarkdown.new(html_body)
      converted_markdown = converter.call
      MarkdownToTty.new(converted_markdown).call
    end

    def before_exit
      @link_repository.save_data
      nil
    end

    private

    # @return [Array]
    def find_links(html_body, links_class)
      html_doc = Nokogiri::HTML(html_body)
      link_repository.fill_links(html_doc.css(links_class))
      nil
    end

    def find_last_id(html_body)
      # or take from last links element
      link_repository.last_id = Nokogiri::HTML(html_body).css('.news_widget.l-island-bg').first.attr('data-last_id')
      nil
    end
  end
end
