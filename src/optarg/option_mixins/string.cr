module Optarg::OptionMixins
  module String
    macro included
      getter default : ::String?
      @required : ::Bool

      def initialize(names, metadata = nil, @default = nil, required = nil, group = nil)
        @required = !!required
        super names, metadata: metadata, group: group
      end

      def type
        :string
      end

      def parse(arg, data)
        raise ::Optarg::UnsupportedConcatenation.new(arg)
      end

      def parse(args, index, data)
        return index unless data = as_data?(data)
        if is_name?(args[index])
          raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
          data.__options__string[key] = args[index + 1]
          index + 2
        else
          index
        end
      end

      def validate(data)
        with_data?(data) do |data|
          raise ::Optarg::RequiredError.new(key) if @required && !data.__options__string[key]?
        end
      end
    end
  end
end
