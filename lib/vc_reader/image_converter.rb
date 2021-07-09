# frozen_string_literal: true

module VcReader
  module ImageConverter
    # @param url [String]
    # @return [String]
    def self.image_to_str(url)
      image = MiniMagick::Image.open(url)
      image.resize('640x640')
      base64 = Base64.encode64(image.to_blob).split("\n").join
      "\x1B]1337;File=inline=1;width=auto;height=auto:#{base64}\x07"
    end
  end
end
