module Optarg::OptionMixins
  module Array(T)
    macro included
      {%
        snake = T.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        type = T.id.split("::").map{|i| i.underscore}.join("_") + "_array"
      %}

      @default : ::Array(T)?

      def initialize(names, metadata = nil, @default = nil)
        super names, metadata: metadata
      end

      def type
        :{{type.id}}
      end

      def get_default
        @default ? @default.dup : Array(T).new
      end

      def parse(arg, data)
        raise ::Optarg::UnsupportedConcatenation.new(arg)
      end

      def parse(args, index, data)
        return index unless data = as_data(data)
        if is_name?(args[index])
          raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
          data.__array_options__{{snake.id}}[key] << args[index + 1]
          index + 2
        else
          index
        end
      end
    end
  end
end
