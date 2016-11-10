module Optarg::OptionMixins
  module String
    macro included
      getter default : ::String?
      @required : ::Bool

      def initialize(names, metadata = nil, @default = nil, required = nil, group = nil, stop = nil)
        @required = !!required
        super names, metadata: metadata, group: group, stop: stop
      end

      def type
        :string
      end

      def length
        2
      end

      def parse(args, data)
        data.string_options[key] = args[1]
      end

      def validate(data)
        with_data?(data) do |data|
          raise ::Optarg::RequiredOptionError.new(key) if @required && !data.string_options[key]?
        end
      end

      def required?
        @required
      end
    end
  end
end
