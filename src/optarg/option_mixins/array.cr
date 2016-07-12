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

      def parse(arg, data)
        raise ::Optarg::UnsupportedConcatenation.new(arg)
      end

      def parse(args, index, data)
        return index unless data = as_data?(data)
        if is_name?(args[index])
          raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
          data.__array_options__{{snake.id}}[key] << args[index + 1]
          index + 2
        else
          index
        end
      end

      def validate(data)
        with_data?(data) do |data|
          raise ::Optarg::MinimumLengthError.new(key, @min) if @min > 0 && data.__array_options__string[key].size < @min
        end
      end

      def required?
        min > 0
      end
    end
  end
end
