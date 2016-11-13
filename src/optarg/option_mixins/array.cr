module Optarg::OptionMixins
  module Array(T)
    macro included
      {%
        snake = T.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        type = T.id.split("::").map{|i| i.underscore}.join("_") + "_array"
      %}

      getter default : ::Array(T)
      getter min : Int32

      def initialize(names, metadata = nil, default = nil, min = nil, group = nil)
        @default = default || ::Array(T).new
        @min = min || 0
        super names, metadata: metadata, group: group
      end

      def type
        :{{type.id}}
      end

      def length
        2
      end

      def parse(args, data)
        data.__options.__{{snake.id}}_arrays[key] << args[1]
      end

      def validate(data)
        with_data?(data) do |data|
          size = data.__options.__{{snake.id}}_arrays[key].size
          raise ::Optarg::MinimumLengthError.new(key, @min, size) if @min > 0 && size < @min
        end
      end

      def required?
        min > 0
      end
    end
  end
end
