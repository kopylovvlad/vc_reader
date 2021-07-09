# frozen_string_literal: true

module VcReader
  class FileManager
    @instance = new

    class << self
      attr_reader :instance
    end

    def file_name
      'vc_reader_dump.yml'
    end

    def file_path
      File.join(ENV['DUMP_PATH'], file_name)
    end

    # @return [Array]
    def load_file
      YAML.safe_load(File.open(file_path).read)
    rescue StandardError
      []
    end

    # @params data [Array]
    def save_file(data)
      File.open(file_path, 'w') { |file| file.write(YAML.dump(data)) }
      nil
    end

    private_class_method :new
  end
end
