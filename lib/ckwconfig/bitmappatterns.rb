class CkwConfig
  module BitmapPatterns
    BMP_PATTERNS = [
      'tiled',
      'on_left_top',
      'on_right_top',
      'on_left_bottom',
      'on_right_bottom',
      'resize_width',
      'resize_height',
      'resize_screen',
    ]

    def self.fetch(pattern)
      BMP_PATTERNS.index(pattern)
    end

    def self.validate(pattern)
      return true if BMP_PATTERNS.index(pattern)
      max = BMP_PATTERNS.size - 1
      msg = begin
              if pattern.between?(0, max)
                nil
              else
                "bitmap pattern id out of range: #{pattern.inspect} (for 0 .. #{max})"
              end
            rescue ArgumentError, NoMethodError
              "invalid bitmap pattern: #{pattern.inspect}"
            end
      raise ArgumentError, msg if msg
      true
    end
  end
end
