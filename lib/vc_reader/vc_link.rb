# frozen_string_literal: true

module VcReader
  class VCLink
    attr_accessor :index
    attr_writer :visited
    attr_reader :node

    def initialize(node)
      @node = node
      @visited = false
      @index = 0
    end

    # @return [String]
    def text
      node.text
    end

    # @return [String]
    def href
      node.attr('href')
    end

    # @return [String]
    def render
      status = visited? ? '✅' : '🆕'
      "#{status} #{index}: #{text}"
    end

    # @return [Boolean]
    def visited?
      @visited == true
    end
  end
end
