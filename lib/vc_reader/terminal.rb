# frozen_string_literal: true

module VcReader
  # here is only logic for stdout and stdin
  class Terminal
    def initialize
      @config = Config.new
    end

    def first_run
      clean_terminal
      config.first_fetch
      print_links
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
    def wait_for_action
      show_prompt
      $stdin.gets
      command = $_.strip.downcase

      case command
      when reg_exps[:open_news] then open_news(command)
      when reg_exps[:read_news] then read_news(command)
      when 'prev' then show_previous_news
      when 'next' then show_next_news
      when 'menu' then print_menu
      when 'exit' then end_the_work
      else puts '¯\_(ツ)_/¯'
      end
    rescue NoLinkError => e
      no_link_handle(e)
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

    private

    def reg_exps
      { open_news: /(?:open *(\d*))/,
        read_news: /(?:read *(\d*))/ }
    end

    def no_link_handle(exception)
      puts exception.message
    end

    def open_news(command)
      command =~ reg_exps[:open_news]
      number = Regexp.last_match[1]
      url = config.get_link_url(number.to_i)
      `open -a "Google Chrome" '#{url}'`
    end

    def read_news(command)
      command =~ reg_exps[:read_news]
      clean_terminal
      number = Regexp.last_match[1]
      link_text = config.read_news(number.to_i)
      puts "#{link_text}\n"
    end

    def show_next_news
      clean_terminal
      config.load_news
      print_links
    end

    def show_previous_news
      clean_terminal
      config.load_prev_news
      print_links
    end

    def print_menu
      clean_terminal
      print_links
    end

    def end_the_work
      config.before_exit
      puts 'Good bye'
      exit 0
    end

    def show_prompt
      puts "Choose 'menu', 'prev', 'open N', 'read N', 'next' or 'exit'"
    end

    def clean_terminal
      puts `clear`
    end

    def print_links
      puts config.current_links.join("\n")
    end

    attr_reader :config
  end
end
