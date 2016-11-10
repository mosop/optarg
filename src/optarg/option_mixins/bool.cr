module Optarg::OptionMixins
  module Bool
    macro included
      getter default : ::Bool?
      getter not : ::Array(::String)

      def initialize(names, metadata = nil, @default = nil, not = nil, group = nil, stop = nil)
        @not = not || \%w()
        super names, metadata: metadata, group: group, stop: stop
      end

      def type
        :bool
      end

      def length
        1
      end

      def matches?(name)
        super || matches_to_not?(name)
      end

      def matches_to_not?(name)
        @not.includes?(name)
      end

      def parse(args, data)
        if matches_to_not?(args[0])
          data.bool_options[key] = false
        else
          data.bool_options[key] = true
        end
      end

      def required?
        false
      end
    end
  end
end
