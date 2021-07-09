# frozen_string_literal: true

module VcReader
  class LinkRepository
    attr_accessor :last_id, :links
    attr_reader :per_page

    # @param file_manager [FileManager]
    # @param per_page [Integer]
    def initialize(file_manager = FileManager.instance, per_page = 4)
      @file_manager = file_manager
      @saved_links = file_manager.load_file
      @last_id = nil
      @links = []
      @per_page = per_page
      @cursor = nil
    end

    # @param index [Integer]
    # @return [VCLink]
    # @raise [StandardError]
    def find_by_index(index)
      link = @links[index - 1] || nil
      raise NoLinkError, index if link.nil?

      link
    end

    # @param index [Integer]
    # @return [VCLink, NilClass]
    def find_by_index_and_mark(index)
      link = find_by_index(index)
      link.visited = true
      saved_links << link.href
      link
    end

    # rubocop:disable Metrics/AbcSize
    # @param links [Array<Node>]
    def fill_links(array)
      @cursor = cursor.nil? ? 1 : cursor + per_page
      current_step = links.size
      array
        .map { |i| VCLink.new(i) }
        .each_with_index do |link, index|
          link.index = index + 1 + current_step
          link.visited = true if saved_links.include?(link.href)
          @links << link
        end
      nil
    end
    # rubocop:enable Metrics/AbcSize

    # NOTE: it changes cursor to back
    def cursor_to_prev
      @cursor = case cursor
                when nil then nil
                when 1 then 1
                else
                  cursor - per_page
                end
      nil
    end

    def current_links
      from = cursor - 1
      to = cursor + per_page - 1
      links[from..to]
    end

    def save_data
      file_manager.save_file(saved_links.uniq)
    end

    private

    attr_reader :file_manager, :saved_links, :cursor
  end
end
