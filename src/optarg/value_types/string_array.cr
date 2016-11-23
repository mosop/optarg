module Optarg::ValueTypes
  abstract class StringArray < Array(::String)
    __concrete
    __concrete_array

    class Value
      def compare_to(other)
        raise "Can't compare."
      end
    end
  end
end
