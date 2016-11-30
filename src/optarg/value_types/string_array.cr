module Optarg::ValueTypes
  class StringArray < Base
    __concrete Array(::String), et: ::String

    class Value
      def compare_to(other)
        raise "Can't compare."
      end
    end
  end
end
