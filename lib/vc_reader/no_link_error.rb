# frozen_string_literal: true

module VcReader
  class NoLinkError < StandardError
    # @param index [Integer]
    def initialize(index = nil)
      message = if index.nil?
                  %(Can't find link ¯\\_(ツ)_/¯)
                else
                  %(Can't find link ##{index} ¯\\_(ツ)_/¯)
                end
      super(message)
    end
  end
end
