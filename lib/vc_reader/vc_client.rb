# frozen_string_literal: true

module VcReader
  class VcClient
    attr_reader :domain

    def initialize
      @domain = 'https://vc.ru/'
    end

    # @return [String]
    def first_fetch
      response = Faraday.get(domain)
      # response.status
      response.body
    end

    # @return [Hash]
    def load_news(tmp_last_id)
      response = Faraday.get("#{@domain}news/more/#{tmp_last_id}")
      JSON.parse(response.body)['data']
    end

    # @return [String]
    def get_page_body(url)
      # NOTE: or by api adding "?mode=ajax"
      response = Faraday.get(url)
      # response.status
      response.body
    end
  end
end
