require 'ckwconfig/bitmappatterns'

class CkwConfig
  module Dumper
    DUMPERS = {
      'bg_bmp_pattern' => ->(s){
        BitmapPatterns.fetch(s)
      },
      'geometry' => ->(h){
        w, h, x, y = h.values_at('w', 'h', 'x', 'y')
        buf = ["#{w}x#{h}"]
        buf << "-#{x}" if x
        buf << "+#{y}" if y
        buf.join
      },
    }

    def self.dump(table, f)
      table.each do |k, v|
        next if v.nil?
        key = CONFIGS[k] || k
        val = v
        d = DUMPERS[k] and val = d[v]
        f.puts "Ckw*#{key}: #{val}"
      end
    end

    CONFIGS = {
      'fg'                 => 'foreground',
      'bg'                 => 'background',
      'cursor'             => 'cursorColor',
      'cursor_ime'         => 'cursorImeColor',
      'bg_bmp'             => 'backgroundBitmap',
      'always_on_tray'     => 'alwaysTray',
      'minimize_to_tray'   => 'minimizeToTray',
      'font_size'          => 'fontSize',
      'scroll_hide'        => 'scrollHide',
      'scroll_on_right'    => 'scrollRight',
      'history_max'        => 'saveLines',
      'internal_border'    => 'internalBorder',
      'line_space'         => 'lineSpace',
      'transparency'       => 'transp',
      'transparency_color' => 'transpColor',
      'always_on_top'      => 'topmost',
      'start_dir'          => 'chdir',
      'shell'              => 'exec',
      'bg_bmp_pattern'     => 'backgroundBitmapPos',
      'cursor_blink'       => 'cursorBlink',
    }
  end
end

