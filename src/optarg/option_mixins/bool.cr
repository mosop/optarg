module Optarg::OptionMixins
  module Bool
    macro included
      @default : ::Bool?
      getter :default

      @not = \%w()

      def initialize(names, metadata = nil, @default = nil, @not = \%w())
        super names, metadata: metadata
      end

      def parse(args, index, result)
        return index unless result = as_result(result)
        if is_name?(args[index])
          result.__optarg_bool_options[key] = true
          index + 1
        elsif is_not?(args[index])
          result.__optarg_bool_options[key] = false
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
