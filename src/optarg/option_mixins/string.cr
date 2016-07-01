module Optarg::OptionMixins
  module String
    macro included
      @default : ::String?
      @required : Bool

      def initialize(names, metadata = nil, @default = nil, required = nil)
        @required = !!required
        super names, metadata: metadata
      end

      def type
        :string
      end

      def get_default
        @default
      end

      def parse(arg, data)
        raise ::Optarg::UnsupportedConcatenation.new(arg)
      end

      def parse(args, index, data)
        return index unless data = as_data(data)
        if is_name?(args[index])
          raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
          data.__options__string[key] = args[index + 1]
          index + 2
        else
          index
        end
      end

      def validate(data)
        return unless data = as_data(data)
        raise ::Optarg::RequiredError.new(key) if @required && !data.__options__string[key]?
      end
    end
  end
end
