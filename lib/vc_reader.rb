# frozen_string_literal: true

Dir[File.join(File.dirname(__FILE__), 'vc_reader', '*.rb')]
  .sort
  .each { |file_path| require file_path }
require 'json'
require 'securerandom'
require 'base64'
require 'yaml'

module VcReader
  def self.run
    terminal = Terminal.new
    terminal.first_run
    loop do
      terminal.wait_for_action
    end
  end
end
