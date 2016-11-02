require 'ckwconfig/colors'
require 'ckwconfig/bitmappatterns'
require 'kwalify'

class CkwConfig
  class Validator < Kwalify::Validator
    VALIDATORS = {
      'color'       => Colors,
      'bmp_pattern' => BitmapPatterns,
    }

    def validate_hook(value, rule, path, errors)
      v = VALIDATORS[rule] and v[value]
    rescue ArgumentError => e
      errors << Kwalify::ValidationError.new(e.message, path)
    end
  end
end

