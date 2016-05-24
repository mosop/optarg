module Optarg::OptionMixins
  module String
    macro included
      @default : ::String?
      getter :default

      def initialize(names, metadata = nil, @default = nil)
        super names, metadata: metadata
      end

      def parse(args, index, result)
        return index unless result = as_result(result)
        if is_name?(args[index])
          raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
          result.__optarg_string_options[key] = args[index + 1]
          index + 2
        else
          index
        end
      end
    end
  end
end
