module Optarg::OptionMixins
  module String
    macro included
      @default : ::String?
      getter :default

      def initialize(names, metadata = nil, @default = nil)
        super names, metadata: metadata
      end

      def type
        :string
      end

      def parse(arg, data)
        raise ::Optarg::UnsupportedConcatenation.new(arg)
      end

      def parse(args, index, data)
        return index unless data = as_data(data)
        if is_name?(args[index])
          raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
          data.__optarg_string_options[key] = args[index + 1]
          index + 2
        else
          index
        end
      end
    end
  end
end
