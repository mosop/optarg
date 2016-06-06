module Optarg::OptionMixins
  module Bool
    macro included
      @default : ::Bool?
      getter :default

      @not = \%w()

      def initialize(names, metadata = nil, @default = nil, @not = \%w())
        super names, metadata: metadata
      end

      def parse(arg, data)
        return false unless data = as_data(data)
        if is_name?(arg)
          data.__optarg_bool_options[key] = true
          true
        elsif is_not?(arg)
          data.__optarg_bool_options[key] = false
          true
        else
          false
        end
      end

      def parse(args, index, data)
        if parse(args[index], data)
          index + 1
        else
          index
        end
      end

      def is_not?(name)
        @not.includes?(name)
      end
    end
  end
end
