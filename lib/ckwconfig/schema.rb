class CkwConfig
  module Schema
    def self.define
      normalize define_schema()
    end

    def self.define_schema
      types.map({
        fg:                 types.color,
        bg:                 types.color,
        cursor:             types.color,
        cursor_ime:         types.color,
        color0:             types.color,
        color1:             types.color,
        color2:             types.color,
        color3:             types.color,
        color4:             types.color,
        color5:             types.color,
        color6:             types.color,
        color7:             types.color,
        color8:             types.color,
        color9:             types.color,
        color10:            types.color,
        color11:            types.color,
        color12:            types.color,
        color13:            types.color,
        color14:            types.color,
        color15:            types.color,
        bg_bmp:             types.str,
        bg_bmp_pattern:     types.bmp_pattern,
        icon:               types.str,
        always_on_tray:     types.bool,
        minimize_to_tray:   types.bool,
        geometry:           types.map(w: types.int(required: true),
                                      h: types.int(required: true),
                                      x: types.int,
                                      y: types.int),
        font:               types.str,
        font_size:          types.int,
        scroll_hide:        types.bool,
        scroll_on_right:    types.bool,
        history_max:        types.int,
        internal_border:    types.int,
        line_space:         types.int,
        transparency:       types.int(range: {min: 0, max: 255}),
        transparency_color: types.color,
        always_on_top:      types.bool,
        start_dir:          types.str,
        cursor_blink:       types.bool,
      })
    end
    private_class_method :define_schema

    def self.types
      @types ||= Types.new
    end

    class Types
      BASES = {
        int: {type: :int},
        str: {type: :str},
        bool: {type: :bool},
        color: {type: :text, name: :color},
        bmp_pattern: {type: :text, name: :bmp_pattern},
      }

      BASES.each_key do |k|
        define_method(k){|arg = {}| make_type(k, arg) }
      end

      def map(contents = {}, extras = {})
        merge_table({type: :map, mapping: contents}, extras)
      end

      def seq(contents = [], extras = {})
        merge_table({type: :seq, sequence: contents}, extras)
      end

      private

      def make_type(base, extras = {})
        merge_table BASES.fetch(base), extras
      end

      def merge_table(dest, from)
        from.empty? ? dest : dest.merge(from)
      end
    end

    module NormalizeForSchema
      refine Object do
        alias normalize_for_schema itself
      end

      refine Array do
        def normalize_for_schema
          map(&:normalize_for_schema)
        end
      end

      refine Hash do
        def normalize_for_schema
          map{|k, v| [k.normalize_for_schema, v.normalize_for_schema] }.to_h
        end
      end

      refine Symbol do
        alias normalize_for_schema id2name
      end
    end

    using NormalizeForSchema

    def self.normalize(schema)
      schema.normalize_for_schema
    end
  end
end
